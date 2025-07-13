--!nonstrict
--!native
local hookmetamethod;
local newcclosure;
local protect_from_debug_info;
local getrawmetatable;
local setrawmetatable;
local getgc;
local replicate_instance;
local islclosure;
local iscclosure;
local isourclosure;
local add_method;
local getnamecallmethod;
local checkcaller;
local identifyexecutor;
local isluau;
local getgenv;
local cloneref;
local getnilinstances;
local getinstances;
local getthreadidentity;
do
	local INIT_ON_START_UP: boolean = false;
	local all_instances: {any} = {};
	local current_env: { [string]: any } = getfenv();
	local illegal_debug_fetch:{ [(...any) -> (...any)]: (...any) -> (...any) } = {};
	local lua_gc: {any} = {};
	local c_functions: {(...any) -> (...any)} = {};
	local c_function_data: { [(...any) -> (...any)]: string } = {};
	local raw_metatables: { [any]: any } = {};
	local real_to_fake: { [Instance]: any }= {};
	local fake_to_real:{ [any]: Instance } = {};
	local debug = debug;
	local debugInfo: (<A..., R1..., R2...>((A...) -> (R1...), string) -> (R2...)) & (<R...>(number, string) -> (R...)) & (<R...>(thread, number, string) -> (R...)) = debug.info;
	local newproxy: (boolean?) -> any = newproxy;
	local getmetatable = getmetatable;
	local setmetatable = setmetatable;
	local getfenv: (any) -> { [string]: any } = getfenv;
	local setfenv: <T..., R...>(((T...) -> (R...)) | number, { [string]: any }) -> ((T...) -> (R...))? = setfenv;
	local table_insert: (<V>({V}, V) -> ()) & (<V>({V}, number, V) -> ()) = table.insert;
	local error: <T>(T, number?) -> never = error;
	local table_clear: <K, V>({ [K]: V }) -> () = table.clear;
	local unpack: <V>({V}, number?, number?) -> (...V) = table.unpack;
	local table_clone: ({  }) -> {  } = table.clone;
	local type: <T>(T) -> string = type;
	local makereadable: ({  }) -> {  } = table.freeze;
	local rawset: <K, V>({ [K]: V }, K, V) -> { [K]: V } = rawset;
	local rawget: <K, V>({ [K]: V }, K) -> V = rawget;
	local assert: <T>(T, string?) -> T = assert;
	local string = string;
	local custom_methods: {[any]: any} = {}
	local pcall = pcall;
	local table_find: <V>({V}, V, number?) -> number? = table.find;
	local insert_gc; insert_gc = @native function(to_insert: any): ()
		table_insert(lua_gc, to_insert);
	end :: (any) -> ();
	local namecall_leax = @native function(object: any): any
		local _: boolean, namecall: any = xpcall(@native function(): ()
			(object :: any):__namecall();
		end, @native function()
			return debug.info(2, "f");
		end);
		return namecall;
	end;
	local first: any = namecall_leax(OverlapParams.new());
	local second: any = namecall_leax(Color3.new());
	namecall_leax = nil :: never;
	getnamecallmethod = @native function(): string
		local success: boolean, error_message: string = pcall(first);
		local namecall_method: string? | boolean? = not success and string.match(error_message, "^(.+) is not a valid member of %w+$");
		if not namecall_method then
			local success: boolean, error_message: string = pcall(second);
			namecall_method = not success and string.match(error_message, "^(.+) is not a valid member of %w+$");
		end;
		return namecall_method :: string? or "";
	end;
	checkcaller = @native function(): boolean
		for i: number = 1, 20 do
			local __ENV = pcall(getfenv, i);
			if __ENV and raw_metatables[__ENV] then
				return false;
			end;
		end;
		return true;
	end;
	local _typeof = typeof;
	newcclosure = @native function(...: any): ((...any) -> (...any))
		local _function: (...any) -> (...any), name_of_function: string? = ...;
		assert(_function and _typeof(_function) == "function", `invalid argument #1 to 'newcclosure' (function expected, got {_typeof(_function)})`)
		if name_of_function then
			assert(name_of_function and _typeof(name_of_function) == "string", `invalid argument #2 to 'newcclosure' (string expected, got {_typeof(_function)})`)
			c_function_data[_function] = name_of_function;
		end;
		table_insert(c_functions, _function);
		return _function;
	end;
	getthreadidentity = newcclosure(@native function()
		return 2;
	end, "getthreadidentity");
	getrawmetatable = newcclosure(@native function(to_get: any): {[string]: any}
		-- assert(to_get and _typeof(to_get) == "table" or _typeof(to_get) == "userdata", `invalid argument #1 to 'getrawmetatable' (table or userdata expected, got {typeof(to_get)})`);
		return raw_metatables[to_get] or getmetatable(to_get);
	end, "getrawmetatable");

	setrawmetatable = newcclosure(@native function(to_replace: any, new_methods: {[string]: any}): any
		assert(to_replace and _typeof(to_replace) == "table" or _typeof(to_replace) == "userdata", `invalid argument #1 to 'setrawmetatable' (table or userdata expected, got {typeof(to_replace)})`);
		assert(new_methods and _typeof(new_methods) == "table", `invalid argument #2 to 'setrawmetatable' (table expected, got {typeof(new_methods)})`);
		local raw_mt = raw_metatables[to_replace];
		if raw_mt then
			table_clear(raw_mt);
			for i: any, v: any in new_methods do
				raw_mt[i] = v;
			end;
			return raw_mt;
		end;
		return setmetatable(to_replace, new_methods);
	end, "setrawmetatable");

	identifyexecutor = newcclosure(@native function(): "da meower >:3"
		return "da meower >:3";	
	end, "identifyexecutor");
	isluau = newcclosure(@native function(): true
		return true;		
	end, "isluau");
	local setnewproxy; setnewproxy = @native function(meta_methods: {[string]: any}): any
		local proxy = newproxy(true);
		local proxy_mt = getmetatable(proxy);
		insert_gc(proxy_mt);
		insert_gc(meta_methods);
		insert_gc(proxy);
		raw_metatables[proxy] = proxy_mt;
		for i,v in meta_methods do
			proxy_mt[i] = v;
		end;
		return proxy;
	end;

	add_method = newcclosure(@native function(targeted_instance: any, new_method: any, thing: any): any
		custom_methods[targeted_instance][new_method] = thing;
		return thing;
	end, "add_method");
	iscclosure = newcclosure(@native function(f: (...any) -> (...any)): boolean
		assert(f and _typeof(f) == "function", `invalid argument #1 to 'iscclosure' (function expected, got {_typeof(f)})`);
		if table_find(c_functions, f) then
			return true;
		end;
		return debugInfo(f, "s") == "[C]";
	end, "iscclosure");
	isnewcclosure = newcclosure(@native function(f: (...any) -> (...any)): boolean
		assert(f and _typeof(f) == "function", `invalid argument #1 to 'isnewcclosure' (function expected, got {_typeof(f)})`);
		if table_find(c_functions, f) then
			return true;
		end;
		return false;
	end, "isnewcclosure");
	islclosure = newcclosure(@native function(f: (...any) -> (...any)): boolean
		assert(f and _typeof(f) == "function", `invalid argument #1 to 'islclosure' (function expected, got {_typeof(f)})`);
		return debugInfo(f, "s") ~= "[C]";
	end, "islclosure");

	isourclosure = newcclosure(@native function(f: (...any) -> (...any)): boolean
		assert(f and _typeof(f) == "function", `invalid argument #1 to 'isourclosure' (function expected, got {_typeof(f)})`);
		return current_env.debug.info(f, "s") == "[C]";
	end, "isourclosure");

	protect_from_debug_info = @native function(fake_function: (...any) -> (...any), real_function: (...any) -> (...any)): (...any) -> (...any)
		illegal_debug_fetch[real_function] = fake_function; 
		return fake_function;
	end;

	hookmetamethod = @native function(...: any): (...any) -> (...any)
		local target: any, method: string, closure: (...any) -> (...any) = ...;
		assert(target and _typeof(target) == "table" or _typeof(target) == "userdata", `invalid argument #1 to 'hookmetamethod' (table or userdata expected, got {_typeof(target)})`);
		assert(method and _typeof(method) == "string", `invalid argument #2 to 'hookmetamethod' (string expected, got {_typeof(method)})`);
		assert(closure and _typeof(closure) == "function", `invalid argument #3 to 'hookmetamethod' (function expected, got {_typeof(closure)})`);
		target = getrawmetatable(target);
		assert(target and _typeof(target) == "table", "Object has no metatable");
		local old_method: (...any) -> (...any) = rawget(target, method);
		assert(old_method, `{method} is not a valid member of the gaven object's metatable`);
		assert(_typeof(old_method) == "function", `{method} is not a function.`);
		rawset(target, method, closure);
		protect_from_debug_info(old_method, closure);
		return old_method;
	end;

	local getinstance; getinstance = @native function(to_get: any, mode: string): any?
		if mode == "real" then
			if _typeof(to_get) == "Instance" then
				return to_get;
			end;
			return fake_to_real[to_get];
		elseif mode == "fake" then
			return real_to_fake[to_get];
		end;
		return nil;
	end;

	local scan_for_instances; scan_for_instances = @native function(tbl: {any}): {any}
		local new_table = {};
		for index: any, value: any in tbl do
			new_table[index] = (_typeof(value) == "userdata" and getinstance(value, "real")) or _typeof(value) == "Instance" and replicate_instance(value) or value;
		end;
		return new_table;
	end;

	getgc = newcclosure(@native function()
		return lua_gc;
	end, "getgc");
	getinstances = newcclosure(@native function(): {any}
		local instances: {any} = {};
		for i: number, v: any in all_instances do
			instances[i] = v;
		end;
		return instances;
	end, "getinstances");
	getnilinstances = newcclosure(@native function(): {any}
		local nil_instances: {any} = {};
		for i: number ,v: any in getinstances() do
			if v.Parent == nil then
				table_insert(nil_instances, v);
			end;
		end;
		return nil_instances;
	end, "getnilinstances");
	replicate_instance = @native function(obj: any, is_clone_ref: boolean?): any
		warn("[replicate_instance] called on", obj);
		local fake_instance;
		if _typeof(obj) ~= "Instance" then
			return obj;
		end;
		if getinstance(obj, "fake") and not is_clone_ref then
			warn("[replicate_instance] instance already exists", obj);
			return getinstance(obj, "fake");
		end;
		warn("[replicate_instance] creating new fake instance", obj);
		local real_methods = {};
		xpcall(function()
			return obj.___;
		end, function()
			real_methods.__index = debugInfo(2, "f");
		end);
		xpcall(function()
			obj.___ = newproxy();
		end, function()
			real_methods.__newindex = debugInfo(2, "f");
		end);
		xpcall(function()
			return tostring(game.CoreGui);
		end, function()
			real_methods.__tostring = debugInfo(2, "f");
		end);
		xpcall(function()
			return obj:____();	
		end, function()
			real_methods.__namecall = debugInfo(2, "f");
		end);
		xpcall(function()
			return obj.."hi";	
		end, function()
			real_methods.__concat = debugInfo(2, "f");
		end);
		xpcall(function()
			return -obj;	
		end, function()
			real_methods.__unm = debugInfo(2, "f");
		end);
		xpcall(function()
			return obj + 1;	
		end, function()
			real_methods.__add = debugInfo(2, "f");
		end);
		xpcall(function()
			return obj - 1;	
		end, function()
			real_methods.__sub = debugInfo(2, "f");
		end);
		xpcall(function()
			return obj * 1;	
		end, function()
			real_methods.__mul = debugInfo(2, "f");
		end);
		xpcall(function()
			return obj / 1;	
		end, function()
			real_methods.__div = debugInfo(2, "f");
		end);
		xpcall(function()
			return obj // 1;	
		end, function()
			real_methods.__idiv = debugInfo(2, "f");
		end);
		xpcall(function()
			return obj % 1;	
		end, function()
			real_methods.__mod = debugInfo(2, "f");
		end);
		xpcall(function()
			return obj <= 1;	
		end, function()
			real_methods.__le = debugInfo(2, "f");
		end);
		xpcall(function()
			return obj < 1;	
		end, function()
			real_methods.__lt = debugInfo(2, "f");
		end);
		xpcall(function()
			return #obj;
		end, function()
			real_methods.__len = debugInfo(2, "f");
		end);
		xpcall(function()
			return obj();
		end, function()
			real_methods.__call = debugInfo(2, "f");
		end);
		xpcall(function()
			for _, v in obj do

			end
		end, function()
			real_methods.__iter = debugInfo(2, "f");
		end);

		local fake_methods: {[string]: any} = {
			__index = newcclosure(@native @checked function(...: any): any
				local raw_args = {...};
				local raw_self = raw_args[1];
				local Args = scan_for_instances({...});	
				local self: any, index: any = Args[1], Args[2];
				if raw_self and raw_self == fake_instance and index and _typeof(index) == "string" and custom_methods[raw_self] and custom_methods[raw_self][index] then
					return custom_methods[raw_self][index];
				end;
				local result: any =  unpack(scan_for_instances({real_methods.__index(unpack(Args))}));
				if type(result) == "function" and debug.info(result, "s") == "[C]" then
					if illegal_debug_fetch[result] then
						return illegal_debug_fetch[result];
					end;
					local da_function: (...any) -> (...any) = newcclosure(@native function(...: any): any
						local new_args: {any} = scan_for_instances({...});
						return unpack(scan_for_instances({result(unpack(new_args))}));
					end, debug.info(result, "n"));
					insert_gc(da_function);
					protect_from_debug_info(da_function, result);
					return da_function;
				end;
				return result;
			end);
			__newindex = newcclosure(@native @checked function(...: any): ()
				local Args = scan_for_instances({...});	
				real_methods.__newindex(unpack(Args));
			end);
			__namecall = newcclosure(@native @checked function(...: any): any
				local raw_args = {...};
				local raw_self = raw_args[1];
				local Args: {any} = scan_for_instances({...});	
				local self: any = Args[1];
				local namecall_method: string = getnamecallmethod();
				if raw_self and raw_self == fake_instance and namecall_method and _typeof(namecall_method) == "string" and custom_methods[raw_self][namecall_method] and _typeof(custom_methods[raw_self][namecall_method]) == "function" then
					return custom_methods[raw_self][namecall_method](unpack(Args));
				end;
				--[[if self and self == fake_instance and namecall_method and _typeof(namecall_method) == "string" and custom_methods[fake_instance] and custom_methods[fake_instance][namecall_method] then
					local meower_args = table_clone(Args);
					Args[1] = nil;
					return custom_methods[fake_instance][namecall_method](unpack(Args));
				end;]]
				return unpack(scan_for_instances({real_methods.__namecall(unpack(Args))}))
			end);
			__tostring = newcclosure(@native @checked function(...: any)
				local Args = scan_for_instances({...});	
				return unpack(scan_for_instances({real_methods.__tostring(unpack(Args))}))
			end);
			__concat = newcclosure(@native @checked function(...: any): any
				local Args = scan_for_instances({...});	
				return unpack(scan_for_instances({real_methods.__concat(unpack(Args))}))
			end);
			__unm = newcclosure(@native @checked function(...: any): any
				local Args = scan_for_instances({...});	
				return unpack(scan_for_instances({real_methods.__unm(unpack(Args))}))
			end);
			__add = newcclosure(@native @checked function(...: any): any
				local Args = scan_for_instances({...});	
				return unpack(scan_for_instances({real_methods.__add(unpack(Args))}))
			end);
			__sub = newcclosure(@native @checked function(...: any): any
				local Args = scan_for_instances({...});	
				return unpack(scan_for_instances({real_methods.__sub(unpack(Args))}))
			end);
			__mul = newcclosure(@native @checked function(...: any ): any
				local Args = scan_for_instances({...});	
				return unpack(scan_for_instances({real_methods.__mul(unpack(Args))}))
			end);
			__div = newcclosure(@native @checked function(...: any): any
				local Args = scan_for_instances({...});	
				return unpack(scan_for_instances({real_methods.__div(unpack(Args))}))
			end);
			__idiv = newcclosure(@native @checked function(...: any): any
				local Args = scan_for_instances({...});	
				return unpack(scan_for_instances({real_methods.__idiv(unpack(Args))}))
			end);
			__mod = newcclosure(@native @checked function(...: any): any
				local Args = scan_for_instances({...});	
				return unpack(scan_for_instances({real_methods.__mod(unpack(Args))}))
			end);
			__le = newcclosure(@native @checked function(...: any): any
				local Args = scan_for_instances({...});	
				return unpack(scan_for_instances({real_methods.__le(unpack(Args))}))
			end);
			__lt = newcclosure(@native @checked function(...: any): any
				local Args = scan_for_instances({...});	
				return unpack(scan_for_instances({real_methods.__lt(unpack(Args))}))
			end);
			__len = newcclosure(@native @checked function(...: any): any
				local Args = scan_for_instances({...});
				return unpack(scan_for_instances({real_methods.__len(unpack(Args))}))
			end);
			__call = newcclosure(@native @checked function(...: any): any
				local Args = scan_for_instances({...});		
				return unpack(scan_for_instances({real_methods.__call(unpack(Args))}))
			end);
			__iter = newcclosure(@native @checked function(...: any): any
				local Args = scan_for_instances({...});	
				return unpack(scan_for_instances({real_methods.__iter(unpack(Args))}))
			end);
			__type = "Instance";
			__metatable = getmetatable(obj);			
		};
		for i: any, v: any in fake_methods do
			if real_methods[i] and _typeof(real_methods[i]) == "function" then
				protect_from_debug_info(i, real_methods[i]);
			end;
		end;
		fake_instance = setnewproxy(fake_methods);
		custom_methods[fake_instance] = {};
		real_to_fake[obj] = fake_instance;
		fake_to_real[fake_instance] = obj;
		table_insert(all_instances, obj);
		return fake_instance;	
	end;

	current_env.Instance = table_clone(Instance);
	local old = current_env.Instance.new;

	current_env.Instance.new = newcclosure(@native function(class_name: string, parent: any): any
		parent = getinstance(parent, "real") or parent;
		return unpack(scan_for_instances({old(class_name, parent)}));
	end, "new");
	protect_from_debug_info(current_env.Instance.new, old);

	local old = current_env.Instance.fromExisting;
	current_env.Instance.fromExisting = newcclosure(@native function(to_replicate: any): any
		to_replicate = getinstance(to_replicate, "real") or to_replicate;
		return unpack(scan_for_instances({old(to_replicate)}));
	end, "fromExisting");

	protect_from_debug_info(current_env.Instance.fromExisting, old);
	makereadable(current_env.Instance);
	insert_gc(current_env.Instance);

	current_env.debug = table_clone(debug);
	current_env.debug.getmetatable = newcclosure(@native function(...: any): any
		return getrawmetatable(...);
	end, "getmetatable");
	current_env.debug.setmetatable = newcclosure(@native function(...: any): any
		return setrawmetatable(...);
	end, "setmetatable");
	insert_gc(current_env.debug);

	local old = current_env.debug.info;

	current_env.debug.info = newcclosure(@native @checked function(param1: any, param2: any): any | string
		if type(param1) == "number" then
			param1 += 2; -- no: 3
		end;
		local result: {any} = {old(param1, param2)};
		local unpacked_result: any = unpack(result);
		if table_find(c_functions, param1) and type(param2) == "string" then
			local Source: number? = string.find(param2, "s");
			if Source then
				result[Source] = "[C]";
			end;
			local Line: number? = string.find(param2, "l");
			if Line then
				result[Line] = -1;
			end;
			local Name: number? = string.find(param2, "n");
			if Name then
				result[Name] = c_function_data[unpacked_result] or c_function_data[param1] or "";
			end;
			local _function: number? = string.find(param2, "f");
			if _function then
				result[_function] = param1 or nil;
			end;
			local Amasity: number? = string.find(param2, "a");
			if Amasity then
				result[Amasity] = 0;
				result[Amasity + 1] = true;
			end;
		end;
		if type(unpacked_result) == "function" and illegal_debug_fetch[unpacked_result] then
			return illegal_debug_fetch[unpacked_result];
		end;
		return unpack(result);
	end, "info");

	protect_from_debug_info(current_env.debug.info, old);
	makereadable(current_env.debug);

	local old = current_env.typeof;
	current_env.typeof = newcclosure(@native function(to_check: any): any
		if to_check and old(to_check) == "userdata" and getrawmetatable(to_check) and getrawmetatable(to_check).__type and getrawmetatable(to_check).__namecall and getrawmetatable(to_check).__call then
			return getrawmetatable(to_check).__type;
		end;
		return old(to_check);
	end, "typeof");

	protect_from_debug_info(current_env.typeof, old);
	local old = current_env.getfenv;
	local fake_env;

	current_env.getfenv = newcclosure(@native function(...: any): {[string]: any}
		local result = old(...);
		if rawget(result, "_G") == _G or result == current_env then -- for now
			return fake_env; -- for now
		end;
		return result;
	end, "getfenv");
	protect_from_debug_info(current_env.getfenv, old);

	local old = current_env.setmetatable;
	current_env.setmetatable = newcclosure(@native function(...): any
		local arg1: any, arg2: any = ...;
		local result = old(...);
		insert_gc(result);
		if type(arg1) == "table" then
			insert_gc(arg1);
		end;
		if type(arg2) == "table" then
			insert_gc(arg2);
			raw_metatables[result] = arg2;
			if rawget(arg2, "__gc") then
				rawget(arg2, "__gc")(result);
			end;
		end;
		
		return result;
	end, "setmetatable");
	protect_from_debug_info(current_env.setmetatable, old);

	local old = current_env.newproxy;
	current_env.newproxy = newcclosure(@native function(...: any): any
		local include_mt: boolean = ...;
		local _proxy = old(include_mt);
		insert_gc(_proxy);
		raw_metatables[_proxy] = getmetatable(_proxy);
		insert_gc(getmetatable(_proxy));
		-- // TODO: do __gc for newproxy later
		return _proxy;
	end, "newproxy");
	protect_from_debug_info(current_env.newproxy, old);
	fake_env = setmetatable({
		["script"] = replicate_instance(script);	
		["_G"] = table_clone(_G);
		["shared"] = table_clone(shared);
	}, {
		__index = current_env;	
	});
	raw_metatables[fake_env] = getmetatable(fake_env);
	insert_gc(getmetatable(fake_env));

	getmetatable(fake_env).__metatable = getmetatable(current_env);
	insert_gc(fake_env);

	game = replicate_instance(game) :: DataModel & typeof(game:GetDescendants());
	workspace = replicate_instance(workspace) :: Workspace;

	Workspace = workspace :: Workspace;
	getgenv = newcclosure(@native function(): typeof(fake_env)
		return fake_env;
	end, "getgenv");
	cloneref = newcclosure(@native function(to_clone: any): any
		assert(to_clone and _typeof(to_clone) == "userdata", `invalid argument #1 to 'cloneref' (Instance expected, got {_typeof(to_clone)})`);
		local result = replicate_instance(fake_to_real[to_clone], true);
		return result;
	end, "cloneref");
	fake_env.hookmetamethod = hookmetamethod;
	fake_env.newcclosure = newcclosure;
	fake_env.islclosure = islclosure;
	fake_env.getgc = getgc;
	fake_env.getrawmetatable = getrawmetatable;
	fake_env.setrawmetatable = setrawmetatable;
	fake_env.getgenv = getgenv;
	fake_env.checkcaller = checkcaller;
	fake_env.cloneref = cloneref;
	fake_env.iscclosure = iscclosure;
	fake_env.isourclosure = isourclosure;
	fake_env.isnewcclosure = isnewcclosure;
	fake_env.identifyexecutor = identifyexecutor;
	fake_env.getnamecallmethod = getnamecallmethod;
	fake_env.setreadonly = current_env.table.freeze;
	fake_env.isreadonly = current_env.table.isfrozen;
	fake_env.getnilinstances = getnilinstances;
	fake_env.getinstances = getinstances;
	fake_env.getthreadidentity = getthreadidentity;
	if INIT_ON_START_UP then
		local services: {string} = {"Workspace", "Players", "Lighting", "MaterialService", "ReplicatedFirst", "ReplicatedStorage", "ServerScriptService", "ServerStorage", "StarterGui", "StarterPack", "StarterPlayer", "Teams", "SoundService"};
		local init_instance; init_instance = @native function(directory: Instance): ()
			replicate_instance(directory);
			for _,v in directory:GetDescendants() do
				if _typeof(v) == "Instance" then 
					replicate_instance(v);
					init_instance(v);
				end;
			end;
		end;
		for _,v in game:GetDescendants() do
			if _typeof(v) == "Instance" and table_find(services, tostring(v)) then
				warn("[INIT] Replicating Service", v);
				init_instance(v);
			end;
		end;
	end;
	setfenv(1, fake_env);
end;
xpcall(function()
	return game:___();
end, function()
	local __namecall = debug.info(2, 'f');
	print(__namecall == getrawmetatable(game).__namecall);
	print(debug.info(__namecall, "s"))
end);
local lole = setmetatable({}, {
	__gc = function(self)
		-- print(debug.info(2, "fns"))
		print("__gc test", self);
	end,
});
