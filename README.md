# Luau-Instance-Wrapper
## a cheap and detectable instance wrapper for roblox instances


```luau
-- 1. Adding fake methods to 'game' instance
add_method(game, "Number", 4); -- now if the 3rd arg in add_method is NOT a function, __namecall will ignore it
print(game.Number) --> 4
add_method(game, "Crash", newcclosure(@native function(self: any, ...: any) -- self would be the game instance, should always be the real instance unless u did smthin
	assert(self, "Expected ':' not '.' calling member function crash");
	print({...});
	print("crash!!");	
end, "Crash"));
print(game.Crash) --> function0x....
warn("debug.info", debug.info(game.Crash, "sn"));
game:Crash();
game.Crash() --> will trigger the assert.

-- 2. metatable hooking example: spoofing game.creator id via __index hook
local hook; hook = hookmetamethod(game, "__index", newcclosure(@native function(...: any): any
	local self: any?, index: any = ...;
	if self and typeof(self) == "Instance" and self == game and index == "CreatorId" then
		return "noo!";
	end;
	return hook(...);
end));
protect_from_debug_info(getrawmetatable(game).__index, hook); --> you should always do this after hooking
print(game.CreatorId);

-- 3. reading locked metatables, i've hooked newproxy and setmetable to respect getrawmetatable
local mt = setmetatable({}, {
	__newindex = function()
		
	end,
	__metatable = "locked"
});
print(getmetatable(mt)) --> "locked"
print(getrawmetatable(mt)) --> {__newindex = "function", __metatable = "locked"}


-- 4. cheap getgc (its not good)
local lua_gc = getgc(true); --> boolean doesnt matter since its cheap it'll always include tables and userdatas
for _,v in lua_gc do
	if type(v) == "table" and rawget(v, "__index") then
		print("whos metatable is this????", v);
		break;
	end;
end;

-- 5. implode
setrawmetatable(game, {});
print(getrawmetatable(game));

```
