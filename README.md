# Luau-Instance-Wrapper
## a cheap and detectable and shitty instance wrapper for roblox instances

## list of da functions:
1. setrawmetatable - (sets a gaven objects metatable even despite if it has the ``__metatable`` field)
2. getrawmetatable - (gets a gaven objects metatable even despite if it has the ``__metatable`` field)
3. hookmetamethod  - (hooks a gaven object's metamethod if found with your own function)
4. newcclosure     - (doesnt actually newcclosure its just for the debug.info hook to make it look liek its a c function)
5. islclosure      - (returns true if the function was written in lua)
6. iscclosure      - (returns true if the function was written in c)
7. getgc           - (returns all the userdatas and tables)
8. add_method      - (adds your own custom method to an instance)
9. protect_from_debug_info - (attempts to protect your function from debug.info attacks)
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
