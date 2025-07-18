-- not finished
--!nocheck
--!native
do
	local xpcall = xpcall;
	local debug = debug;
	local old_debug_info = debug.info;
	local debug_info;
	local is_detected: boolean = false;
	xpcall(function()
		return old_debug_info();
	end, function()	
		debug_info = old_debug_info(2, "f");
	end);
	if not debug_info or debug_info ~= old_debug_info then
		is_detected = true;
	end;
	local get_safe_func; get_safe_func = @native function(f: (...any) -> (...any), validate_exist: boolean): (...any) -> (...any)
		local thing;
		local func_name: string = debug_info(f, "n");
		if func_name == "newproxy" or func_name == "getfenv" then
			xpcall(function()
				return f(43444);
			end, function()
				thing = debug_info(2, "f");
			end);
		elseif func_name == "random" then
			xpcall(function()
				return f(false, false);
			end, function()
				thing = debug_info(2, "f");
			end);
		else
			xpcall(function(...)
				return f();
			end, function()
				thing = debug_info(2, "f");
			end);
		end;
		--[[if func_name ~= "newproxy" then
			xpcall(function()
				return f();
			end, function()
				thing = debug_info(2, "f");			
			end);
		elseif func_name == "getfenv" then
			xpcall(function()
				return f(false);
			end, function()
				thing = debug_info(2, "f");
			end);
		elseif func_name == "newproxy" then
			xpcall(function()
				return f(44);
			end, function()
				thing = debug_info(2, "f");
			end);
		end;]]
		
		if not thing and validate_exist then
			is_detected = true;
		end;
		if validate_exist then
			if thing ~= f then
				is_detected = true;
			end;
		end;
		return thing;
	end;
	xpcall = get_safe_func(xpcall);
	
	local coroutine = coroutine
	local task = task;
	local wrap = get_safe_func(coroutine.wrap, true);
	local getfenv = get_safe_func(getfenv, true);
	local setfenv = get_safe_func(setfenv, true);
	local pcall = get_safe_func(pcall, true);
	local __ENV = getfenv();
	if not __ENV or not pcall then
		is_detected = true;
	end;
	pcall(function()
		coroutine = __ENV.coroutine
		task = __ENV.task;
	end);
	if not coroutine or not task then
		is_detected = true;
	end;
	local game = game;
	local Game = game;
	local workspace = workspace;
	local Workspace = workspace;
	local print = print;
	local setmetatable = get_safe_func(setmetatable, true);
	local newproxy = get_safe_func(newproxy, true);
	local typeof = get_safe_func(typeof, true);
	local type = get_safe_func(type, true);
	local create = get_safe_func(coroutine.create, true);
	local old_spawn = get_safe_func(spawn, true);
	local spawn = get_safe_func(task.spawn, true);
	local resume = get_safe_func(coroutine.resume, true);
	local math = math;
	local random = get_safe_func(math.random, true);
	local wait;
	local instance_new = get_safe_func(Instance.new, true);
	xpcall(function()
		return task.wait(false);
	end, function()
		wait = debug_info(2, "f");
	end);
	local debug = {};
	debug.info = debug_info;
	if not debug or not debug.info or debug.info ~= debug_info then
		is_detected = true;
	end;
	local expected_size: number = 3;
	local detection_strings = {
		"ENV tamper";
		"function tamper";
		"metamethod tamper";
	};
	wrap(function()
		local part = instance_new("Part");
		part.Parent = workspace;
		if part.Parent.Parent ~= game then
			is_detected = true;
		end;
		return;
	end)();
	local detected; detected = @native function(id: number)
		print("detected for", detection_strings[id] or "unknown");
		
	end;
	local return_types: { number | string} = {
		1;
		2;
		3;
		4;
		5;
		6;
		7;
		8;
		9;
		"hi";
		"meow";
		"ermm...";
	};
	local return_check = wrap(@native function()
		local table_size: number = #return_types;
		local random_index = random(1, #return_types);
		return return_types[random_index];
	end);
	wrap(function()
		local returned_value: number | string = return_check();
		if not returned_value then
			detected(2);
		end;
		local passed_checks: boolean = false;
		for _,v in return_types do
			if v == returned_value then
				passed_checks = true;	
				break;
			end;
		end;
		if not passed_checks then
			detected(2)
		end;
	end)();
	local setfenv_tamper_test = wrap(function()
		setfenv(1, {});
		return getfenv(0);
	end);
	local result = setfenv_tamper_test();
	setfenv_tamper_test = nil :: never;
	local size: number = 0;
	for _,v in result do
		size += 1;
	end;
	if size ~= expected_size then
		detected(1);
	end;
	if result ~= __ENV then
		detected(1);
	end;
	local validate_env; validate_env = @native function()
		if getfenv() ~= __ENV then
			detected(1);
		end;
		local size = 0;
		for i: string, v: any in getfenv() do
			if type(v) == "function" then
				continue;
			end;
			size += 1;
		end;
		if size ~= expected_size then
			detected(1);
		end;
	end;
	local validate_instances; validate_instances = @native function()
		local mt_trap;
		local mt_trap2;
		wrap(function()
			mt_trap = setmetatable({}, {
				__index = function()
					detected(3);
				end,
				__newindex = function()
					detected(3);
				end,
				__tostring = function()
					detected(3);
					return "";
				end,
				__namecall = function()
					detected(3);
				end,
				__metatable = getmetatable(game);
				__type = "Instance";
				__concat = @native @checked function(...: any): any
					detected(3);
					return nil;
				end;
				__unm = @native @checked function(...: any): any
					detected(3);
					return 34;
				end;
				__add = @native @checked function(...: any): any
					detected(3);
					return 45;
				end;
				__sub = @native @checked function(...: any): any
					detected(3);
					return 9;
				end;
				__mul = @native @checked function(...: any ): any
					detected(3);
					return 9;
				end;
				__div = @native @checked function(...: any): any
					detected(3);
					return 4;
				end;
				__idiv = @native @checked function(...: any): any
					detected(3);
					return 4;
				end;
				__mod = @native @checked function(...: any): any
					detected(3);
					return 34;
				end;
				__le = @native @checked function(...: any): any
					detected(3);
					return 2;
				end;
				__lt = @native @checked function(...: any): any
					detected(3);
					return 3;
				end;
				__len = @native @checked function(...: any): any
					detected(3);
					return "";
				end;
				__call = @native @checked function(...: any): any
					detected(3);
					return "e"
				end;
				__iter = @native @checked function(...: any): any
					detected(3);
					return 4
				end;
			});
		end)();
		wrap(function()
			mt_trap2 = newproxy(true);
			for i,v in {
				__index = function()
					return detected(3);
				end,
				__namecall = function()
					return detected(3);
				end,
				__tostring = function()
					detected(3);
					return ""
				end,
				__type = "Instance";
				__newindex = function()
					return detected(3);
				end,
				__concat = @native @checked function(...: any): any
					detected(3);
					return nil;
				end;
				__unm = @native @checked function(...: any): any
					detected(3);
					return 34;
				end;
				__add = @native @checked function(...: any): any
					detected(3);
					return 45;
				end;
				__sub = @native @checked function(...: any): any
					detected(3);
					return 9;
				end;
				__mul = @native @checked function(...: any ): any
					detected(3);
					return 9;
				end;
				__div = @native @checked function(...: any): any
					detected(3);
					return 4;
				end;
				__idiv = @native @checked function(...: any): any
					detected(3);
					return 4;
				end;
				__mod = @native @checked function(...: any): any
					detected(3);
					return 34;
				end;
				__le = @native @checked function(...: any): any
					detected(3);
					return 2;
				end;
				__lt = @native @checked function(...: any): any
					detected(3);
					return 3;
				end;
				__len = @native @checked function(...: any): any
					detected(3);
					return "";
				end;
				__call = @native @checked function(...: any): any
					detected(3);
					return "e"
				end;
				__iter = @native @checked function(...: any): any
					detected(3);
					return 4
				end;
				__metatable = getmetatable(game);
				} do
				getmetatable(mt_trap2)[i] = v;
			end;
		end)();
		wrap(function()
			local get_service = game.GetService;
			if not get_service or debug.info(get_service, "s") ~= "[C]" then
				return detected(3);
			end;
			xpcall(function()
				return get_service();
			end, function(err)
				if err ~= "Expected ':' not '.' calling member function GetService" then
					return detected(2);
				end;
				local info = debug_info(2, "f");
				if info ~= get_service or debug.info(info, "s") ~= "[C]" then
					return detected(2);
				end;
 			end);
			
		end)();
		wrap(function()
			pcall(function()
				game.GetService(mt_trap, mt_trap2);
			end);
			pcall(function()
				game.GetService(mt_trap2, mt_trap);
			end);
			pcall(function()
				game.FindService(mt_trap, mt_trap2);
			end);
			pcall(function()
				game.FindService(mt_trap2, mt_trap);
			end);
			pcall(function()
				Instance.new(mt_trap2, mt_trap);
			end);
			pcall(function()
				Instance.new(mt_trap, mt_trap2);
			end);
			pcall(function()
				return game[mt_trap2];
			end);
			pcall(function()
				return game[mt_trap];
			end);
			pcall(function()
				workspace.Name = mt_trap;
			end);
			pcall(function()
				Workspace.Name = mt_trap2;
			end);
			pcall(function()
				Workspace.Name = mt_trap;
			end);
			pcall(function()
				Workspace.Name = mt_trap2;
			end);
			pcall(function()
				if typeof(workspace) ~= "Instance"  or typeof(Workspace) ~= "Instance" or type(workspace) ~= "userdata" or type(Workspace) ~= "userdata" or typeof(game) ~= "Instance" or typeof(Game) ~= "Instance" or type(game) ~= "userdata" or type(Game) ~= "userdata" or workspace ~= game.Workspace or Workspace ~= workspace or game ~= workspace.Parent or game ~= Game then
					return detected(2);
				end;
			end);
			
			
		end)();
		if not mt_trap or not mt_trap2 then
			return detected(3);
		end;
		wrap(function()
			local succ, err = pcall(function()
				return game.GetService(game, "Workspace");
			end);
			if not succ or not err then
				return detected(3);
			end;
		end)();
		wrap(function()
			local succ, err = pcall(function()
				return game:GetService("ReplicatedStorage").CreatorId;
			end);
			if succ then
				detected(3);
			end;
		end)();
		local methods = {};
		xpcall(function()
			return game.hi;
		end, function(err: string)
			if not err.find(err, "hi is not a valid member of DataModel") then
				return detected(2);
			end;
			methods.__index = debug.info(2, "f");
		end);
		if typeof(mt_trap2) == "Instance" then
			return detected(2);
		end;
		if not methods.__index then
			return detected(2);
		end;
		xpcall(function()
			return game:meowat3am();
		end, function(err: string)
			if not err.find(err, "meowat3am is not a valid member of DataModel") then
				return detected(2);
			end;
			methods.__namecall = debug.info(2, "f");
		end)
		xpcall(function()
			game.Name = newproxy();
		end, function(err)
			if err ~= "Unable to assign property Name. string expected, got userdata" then
				return detected(2);
			end;
			methods.__newindex = debug.info(2, "f");
		end)
		xpcall(function()
			for i,v in game do
				
			end;
		end, function(err)
			if err.find(err, "userdata") then
				return detected(3);
			end;
		end)
		xpcall(function()
			return game - game
		end, function(err)
			if err.find(err, "userdata") then
				return detected(3);
			end;
		end)
		xpcall(function()
			
		end, function()

		end)
		xpcall(function()

		end, function()

		end)
		xpcall(function()

		end, function()

		end)
		xpcall(function()

		end, function()

		end)
		
		xpcall(function()

		end, function()

		end)
		xpcall(function()

		end, function()

		end)
		xpcall(function()

		end, function()

		end)
		
		xpcall(function()

		end, function()

		end)
		xpcall(function()

		end, function()

		end)
		
		xpcall(function()

		end, function()

		end)
		
		xpcall(function()

		end, function()

		end)
	end;
	
	validate_env();
	wrap(function()
		while true do
			wait();
			wrap(function()
				print(is_detected)
			end)();
			wrap(function()
				
			end)();
		end;
	end)();
end;
