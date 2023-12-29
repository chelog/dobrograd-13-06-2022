--[[
	Namespace: octolib

	Group: func
		Utilities to work with async tasks, mostly based on functions
]]
octolib.func = octolib.func or {}

function octolib.func.zero() end
function octolib.func.yes() return true end
function octolib.func.no() return false end

--[[
	Function: performance
		Run a performace check on table of functions

	Arguments:
		<table> funcs - Keyed table of functions to execute
		<int> times = 1 - Amount of times to execute each function

	Examples:
		Print performance results out of two functions
		--- Lua
		octolib.func.performance({
			add = function() return 5 + 5 end,
			mul = function() return 5 * 5 end,
		}, 10000)
		---
		> add: 0.025s
		> mul: 0.04s
]]
function octolib.func.performance(funcs, times)

	if not istable(funcs) then funcs = { funcs } end
	for k, func in pairs(funcs) do
		local start = SysTime()
		for i = 1, times or 1 do func() end
		print(('%s: %ss'):format(k, SysTime() - start))
	end

end

--[[
	Function: debounce
		Create a function that executes on end of delay which resets after repeated call

	Arguments:
		<function> func - Function to run
		<float> delay - Debounce time in seconds

	Returns:
		<function> - Debounced function

	Examples:
		--- Lua
		local save = octolib.func.debounce(function() print('saved') end, 0.5)

		-- this will print "saved" only once after 0.5 seconds
		save()
		save()

		-- and this will print it only once after 1.7 (1.2 + 0.5) seconds
		timer.Simple(1, save)
		timer.Simple(1.2, save)
		---
]]
function octolib.func.debounce(func, delay)

	local name = tostring(func) .. octolib.string.uuid()
	return function(...)
		local args = {...}
		timer.Create(name, delay, 1, function() func(unpack(args)) end)
	end

end

local pendingDebounce = {}
function octolib.func.debounceStart(func, delay)

	local name = tostring(func) .. octolib.string.uuid()
	return function(...)
		local callAt = pendingDebounce[name]
		if callAt then
			local args = {...}
			timer.Create(name, callAt - RealTime(), 1, function() func(unpack(args)) end)
		else
			func(...)
			pendingDebounce[name] = RealTime() + delay
			timer.Simple(delay, function()
				pendingDebounce[name] = nil
			end)
		end
	end

end

function octolib.func.debounceEnd(func, delay)

	local name = tostring(func) .. octolib.string.uuid()
	local args = {}
	return function(...)
		args = {...}
		if not timer.Exists(name) then
			timer.Create(name, delay, 1, function() func(unpack(args)) end)
		end
	end

end

local function runThrottle(data)

	for i = 1, data.steps do
		if data.stack:Size() <= 0 then
			if data.finish then timer.Simple(data.minStep, data.finish) end
			return
		end

		data.func(data.stack:Top())
		data.stack:Pop()
	end

	timer.Simple(data.minStep, function()
		runThrottle(data)
	end)

end

--[[
	Function: throttle
		Throttled iterator with limited call amount per interval.
		Useful for heavy tasks that not necessarily be executed in one frame

	Arguments:
		<table> tbl - Sequential table to run through
		<int> steps = 1 - How many values to iterate per interval
		<float> minStep = 0.01 - Time in seconds for minimum interval time
		<function> func - Function to execute on each value
		<function> onFinish = nil - Function to run after all values passed

	_func_ arguments::
		<any> val - Single value from supplied table

	Returns:
		<Promise> - Promise resolved after execution completed

	Example:
		--- Lua
		-- print all player names, 10 players at once every 0.2s
		octolib.func.throttle(player.GetAll(), 10, 0.2, function(ply)
			print(ply:Name())
		end):Then(function()
			print('Done printing names!')
		end)
		---
]]
function octolib.func.throttle(tbl, steps, minStep, func)

	local stack = octolib.array.toStack(tbl)
	return util.Promise(function(res, rej)
		runThrottle({
			stack = stack,
			steps = steps or 1,
			minStep = minStep or 0.01,
			func = func,
			finish = res,
		})
	end)

end

--[[
	Function: loop
		Async call function recursively passing results into next call

	Arguments:
		<function> func - Function to call
		<vararg> ... - Values to pass to first function call

	_func_ arguments::
		<function> again - Call same function again
		<vararg> ... - Values passed to again(...) function

	Example:
		--- Lua
		-- get messages from api until there's no left
		octolib.func.loop(function(again, lastMsg)
			if lastMsg then print('Last received message: ' .. lastMsg) end
			print('Getting new messages...')

			http.Fetch('http://myapi.com/get-message', function(body)
				local data = util.JSONToTable(body)
				if data.message then
					print('Got message: ' .. data.message)
					again(data.message)
				else
					print('Stopped. No messages left!')
				end
			end, function()
				print('Stopped. Error occured!')
			end)
		end, 'None :(')
		---
		> Last received message: None :(
		> Getting new messages...
		> Got message: Message1
		> Last received message: Message1
		> Getting new messages...
		> Got message: Message2
		> ...
		> Stopped. No messages left!
]]
function octolib.func.loop(func, ...)

	local function again(...)
		func(again, ...)
	end

	again(...)

end

--[[
	Function: chain
		Sequentially run functions from table passing values to next one

	Arguments:
		<table> funcs - Sequential table of functions

	_funcs_ element arguments::
		<function> done - Call next function
		<vararg> ... - Values for next function

	Example:
		--- Lua
		-- print all user's messages from async api
		octolib.func.chain({
			function(done)
				myApi.getUserByID(id, function(user)
					done(user)
				end)
			end, function(done, user)
				myApi.getUserMessages(user, function(messages)
					done(messages)
				end)
			end, function(done, messages)
				PrintTable(messages)
			end,
		})
		---
]]
function octolib.func.chain(funcs)

	local stack = octolib.array.toStack(funcs, true)

	local function runChain(...)
		local nextFunc = stack:Top()
		if nextFunc then
			stack:Pop()
			nextFunc(runChain, ...)
		end
	end

	runChain()

end

--[[
	Function: parallel
		Parallelly run functions from supplied table
		collecting all results into one table

	Arguments:
		<table> funcs - Keyed table of functions
		<int> amountToWait = table.Count(funcs) - How many functions to wait

	_funcs_ element arguments::
		<function> done - Finish execution, supports only one value

	Returns:
		<Promise> (<table>) - Promise with keyed table of results of functions

	Example:
		--- Lua
		-- print users data from different apis
		octolib.func.parallel({
			john = function(done)
				http.Fetch('http://myapi.com/get-john', function(body)
					local user = util.JSONToTable(body)
					done(user)
				end)
			end,
			kate = function(done)
				myApi.getUserByName('Kate'):Then(done)
			end,
		}):Then(function(users)
			print(users.john.status)
			print(users.kate.status)
		end)
		---
]]
function octolib.func.parallel(funcs, amountToWait)
	return util.Promise(function(res, rej)

		local numLeft = amountToWait or table.Count(funcs)
		local results = {}

		local function finished(id, result)
			results[id] = result
			numLeft = numLeft - 1
			if numLeft <= 0 then
				res(results)
			end
		end

		for id, func in pairs(funcs) do
			local succ, err = pcall(func, function(result)
				finished(id, result)
			end)

			if not succ then rej(err) end
		end

	end)
end

--[[
	Function: once
		Create a function that executes only once and
		returns same results on repeated calls

	Arguments:
		<function> func - Function to call

	Returns:
		<function> - Modified version of function
]]
function octolib.func.once(func)

	local called = false
	local result
	return function(...)
		if not called then
			result = func(...)
			called = true
		end
		return result
	end

end

octolib.func.originals = octolib.func.originals or {}

function octolib.func.detour(original, id, func)
	octolib.func.originals[id] = octolib.func.originals[id] or original

	return function(...)
		return func(original, ...)
	end
end
