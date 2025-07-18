# Luau-Instance-Wrapper
## a cheap and detectable and shitty instance wrapper for roblox instances, some code has been skidded from my friend

## list of da functions:
## Most of these functions are present on most exploits, therefor they have their existing and proper docmentation you shall read this before you read mine :3  https://orangedoggo.github.io/synapse-x-docs/introduction.html
1. setrawmetatable - (sets a gaven objects metatable even despite if it has the ``__metatable`` field)
2. getrawmetatable - (gets a gaven objects metatable even despite if it has the ``__metatable`` field)
3. hookmetamethod  - (hooks a gaven object's metamethod if found with your own function)
4. newcclosure     - (doesnt actually newcclosure its just for the debug.info hook to make it look liek its a c function)
5. islclosure      - (returns true if the function was written in lua)
6. iscclosure      - (returns true if the function was written in c)
7. getgc           - (returns all the userdatas and tables)
8. add_method      - (adds your own custom method to an instance)
9. protect_from_debug_info - (attempts to protect your function from debug.info attacks)
10. checkcaller - (returns false if the sandbox env called the function)
11. cloneref - (refrence to the replicate_instance function)
12. getthreadidentity - (always returns the number 2)
13. isluau - (always returns true)
14. getnilinstances - (gets instances that are parent to nil)
15. getinstances - (gets every instance)
16. getnamecallmethod - (returns the method that invoked ``__namecall``)
17. identifyexecutor - meows at u :33
18. isnewcclosure - (returns the true if the function is a fake C function)
19. isreadonly - table.isfrozen
20. setreadonly - table.freeze
21. newcproxy - (emulates a (C) proxy but with your own metamethods, special metamethods like __type will work on these proxies.)
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
protect_from_debug_info(getrawmetatable(game).__index, hook); --> always do this after hooks, else you may be prone to some detections.
print(game.CreatorId);

-- You can also hook lua metatables:
local e = setmetatable({}, {
	__index = function()
		print("invoked");	
		return 0;
	end,
	__metatable = "the";
});
print(e.hi)
local hook; hook = hookmetamethod(e, "__index", function(...)
	warn("hooked", ...);
	return hook(...);
end);
print(e.r)

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
-- example 2:

local new_table = {};
table.insert(new_table, "hi");
table.insert(new_table, "hi2");
local LUA_GC = getgc(true);
for _,v in LUA_GC do
	if type(v) == "table" and table.find(v, "hi2") then
		print("found", v);
		break;
	end;
end;

-- 5. implode
setrawmetatable(game, {});
print(getrawmetatable(game));

-- 6. hooking functionss
local old; old = task.wait;
task = table.clone(task);
task.wait = newcclosure(@native function(...: any): number
	local time_to_wait: number? = ...;
	if time_to_wait and type(time_to_wait) == "number" and time_to_wait == 2 then
		warn("i hate the number 2");
		return 0;
	end;
	return old(...);
end, "wait");
protect_from_debug_info(task.wait, old);
table.freeze(task);
task.wait(2);

```
