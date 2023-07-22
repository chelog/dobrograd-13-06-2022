
-- Copyright (C) 2017-2020 DBotThePony

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.


-- performance and functionality to the core

jit.on()

local pairs = pairs
local ipairs = ipairs
local print = print
local debug = debug
local tostring = tostring
local tonumber = tonumber
local type = type
local traceback = debug.traceback
local DLib = DLib
local unpack = unpack
local gxpcall = xpcall
local SysTime = SysTime

DLib.hook = DLib.hook or {}
local ghook = _G.hook
local hook = DLib.hook

hook.PROFILING = false
hook.PROFILING_RESULTS_EXISTS = false
hook.PROFILE_STARTED = 0
hook.PROFILE_ENDS = 0

hook.__tableOptimized = hook.__tableOptimized or {}
hook.__table = hook.__table or {}
hook.__tableGmod = hook.__tableGmod or {}
hook.__tableModifiersPost = hook.__tableModifiersPost or {}
hook.__tableModifiersPostOptimized = hook.__tableModifiersPostOptimized or {}
hook.__disabled = hook.__disabled or {}

local __table = hook.__table
local __disabled = hook.__disabled
local __tableOptimized = hook.__tableOptimized
local __tableGmod = hook.__tableGmod
local __tableModifiersPost = hook.__tableModifiersPost
local __tableModifiersPostOptimized = hook.__tableModifiersPostOptimized

-- ULib compatibility
-- ugh
_G.HOOK_MONITOR_HIGH = -2
_G.HOOK_HIGH = -1
_G.HOOK_NORMAL = 0
_G.HOOK_LOW = 1
_G.HOOK_MONITOR_LOW = 2

local maximalPriority = -10
local minimalPriority = 10

--[[
	@doc
	@fname hook.GetTable
	@replaces
	@returns
	table: `table<string, table<string, function>>`
]]
local function GetTable()
	return __tableGmod
end

--[[
	@doc
	@fname hook.GetDLibOptimizedTable
	@returns
	table: of `eventName -> array of functions`
]]
function hook.GetDLibOptimizedTable()
	return __tableOptimized
end

--[[
	@doc
	@fname hook.GetDLibModifiers
	@returns
	table
]]
function hook.GetDLibModifiers()
	return __tableModifiersPost
end

--[[
	@doc
	@fname hook.GetDLibSortedTable
	@returns
	table
]]
function hook.GetDLibSortedTable()
	return __tableOptimized
end

--[[
	@doc
	@replaces
	@fname hook.GetULibTable

	@desc
	For mods like DarkRP
	Althrough, DarkRP can use DLib's Post Modifiers instead for things that
	DarkRP currently do with table provided by `GetULibTable`
	@enddesc

	@returns
	table
]]
function hook.GetULibTable()
	return __table
end

--[[
	@doc
	@fname hook.GetDLibTable
	@returns
	table
]]
function hook.GetDLibTable()
	return __table
end

--[[
	@doc
	@fname hook.GetDisabledHooks
	@returns
	table
]]
function hook.GetDisabledHooks()
	return __disabled
end

local oldHooks

if ghook ~= DLib.ghook then
	if ghook.GetULibTable then
		oldHooks = ghook.GetULibTable()
	else
		oldHooks = {}

		for event, eventData in pairs(ghook.GetTable()) do
			oldHooks[event] = {}
			oldHooks[event][0] = {}
			local target = oldHooks[event][0]

			for hookID, hookFunc in pairs(eventData) do
				target[hookID] = {fn = hookFunc}
			end
		end
	end
end

local function transformStringID(stringID, event)
	if type(stringID) == 'number' then
		stringID = tostring(stringID)
	end

	if type(stringID) == 'boolean' then
		error('booleans are not allowed as hookID value', 3)
	end

	if type(stringID) ~= 'string' then
		local success = pcall(function()
			stringID.IsValid(stringID)
		end)

		if not success then
			--if DLib.DEBUG_MODE:GetBool() then
				--DLib.Message(traceback('hook.Add - hook ID is not a string and not a valid object! Using tostring() instead. ' .. type(stringID)))
				error('hook.Add - hook ID is not a string and not a valid object! ' .. type(stringID), 3)
			--end
			stringID = tostring(stringID)
		end
	end

	return stringID
end

--[[
	@doc
	@fname hook.DisableHook
	@args string event, any hookID

	@returns
	boolean
]]
function hook.DisableHook(event, stringID)
	assert(type(event) == 'string', 'hook.DisableHook - event is not a string! ' .. type(event))

	if not stringID then
		if __disabled[event] then
			return false
		end

		__disabled[event] = true
		return true
	else
		if not __table[event] then return false end
		stringID = transformStringID(stringID, event)

		for priority = -10, 10 do
			if __table[event][priority] and __table[event][priority][stringID] then
				local wasDisabled = __table[event][priority][stringID].disabled
				__table[event][priority][stringID].disabled = true
				hook.Reconstruct(event)
				return not wasDisabled
			end
		end

		return false
	end
end

--[[
	@doc
	@fname hook.DisableAllHooksExcept
	@args string event, any hookID

	@returns
	boolean
]]
function hook.DisableAllHooksExcept(event, stringID)
	assert(type(event) == 'string', 'hook.DisableAllHooksExcept - event is not a string! ' .. type(event))
	assert(type(stringID) ~= 'nil', 'hook.DisableAllHooksExcept - ID is not a valid value! ' .. type(stringID))

	if not __table[event] then return false end
	stringID = transformStringID(stringID, event)

	for priority = -10, 10 do
		if __table[event][priority] then
			for id, hookData in pairs(__table[event][priority]) do
				if id ~= stringID then
					hookData.disabled = true
				end
			end
		end
	end

	hook.Reconstruct(event)
	return true
end

--[[
	@doc
	@fname hook.DisableHooksByPredicate
	@args string event, function predicate

	@desc
	Predicate should return true to disable hook
	and return false to enable hook
	Arguments passed to predicate are `event, id, priority, dlibHookData`
	@enddesc

	@returns
	boolean
]]
function hook.DisableHooksByPredicate(event, predicate)
	assert(type(event) == 'string', 'hook.DisableAllHooksByPredicate - event is not a string! ' .. type(event))
	assert(type(predicate) == 'function', 'hook.DisableAllHooksByPredicate - invalid predicate function! ' .. type(predicate))

	if not __table[event] then return false end

	for priority = -10, 10 do
		if __table[event][priority] then
			for id, hookData in pairs(__table[event][priority]) do
				local reply = predicate(event, id, priority, hookData)

				if reply then
					hookData.disabled = true
				end
			end
		end
	end

	hook.Reconstruct(event)
	return true
end

--[[
	@doc
	@fname hook.DisableAllHooksByPredicate
	@args function predicate

	@desc
	same as `hook.DisableHooksByPredicate`, except it is ran for all events
	pass `function() return true end` as predicate to disable **EVERYTHING**
	@enddesc

	@returns
	boolean
]]
function hook.DisableAllHooksByPredicate(predicate)
	assert(type(predicate) == 'function', 'hook.DisableAllHooksByPredicate - invalid predicate function! ' .. type(predicate))

	for event, eventData in pairs(__table) do
		for priority = -10, 10 do
			if eventData[priority] then
				for id, hookData in pairs(eventData[priority]) do
					local reply = predicate(event, id, priority, hookData)

					if reply then
						hookData.disabled = true
					end
				end
			end
		end

		hook.Reconstruct(event)
	end

	return true
end

--[[
	@doc
	@fname hook.EnableHooksByPredicate
	@args string event, function predicate

	@desc
	counterpart of `hook.DisableHooksByPredicate`
	@enddesc

	@returns
	boolean
]]
function hook.EnableHooksByPredicate(event, predicate)
	assert(type(event) == 'string', 'hook.DisableAllHooksByPredicate - event is not a string! ' .. type(event))
	assert(type(predicate) == 'function', 'hook.DisableAllHooksByPredicate - invalid predicate function! ' .. type(predicate))

	if not __table[event] then return false end

	for priority = -10, 10 do
		if __table[event][priority] then
			for id, hookData in pairs(__table[event][priority]) do
				local reply = predicate(event, id, priority, hookData)

				if reply then
					hookData.disabled = false
				end
			end
		end
	end

	hook.Reconstruct(event)
	return true
end

--[[
	@doc
	@fname hook.EnableAllHooksByPredicate
	@args function predicate

	@desc
	counterpart of `hook.DisableAllHooksByPredicate`
	@enddesc

	@returns
	boolean
]]
function hook.EnableAllHooksByPredicate(predicate)
	assert(type(predicate) == 'function', 'hook.DisableAllHooksByPredicate - invalid predicate function! ' .. type(predicate))

	for event, eventData in pairs(__table) do
		for priority = -10, 10 do
			if eventData[priority] then
				for id, hookData in pairs(eventData[priority]) do
					local reply = predicate(event, id, priority, hookData)

					if reply then
						hookData.disabled = false
					end
				end
			end
		end

		hook.Reconstruct(event)
	end

	return true
end

--[[
	@doc
	@fname hook.EnableAllHooks

	@returns
	table: enabled hooks (copy of __disabled)
]]
function hook.EnableAllHooks()
	local toenable = {}

	for k, v in pairs(__disabled) do
		table.insert(toenable, k)
	end

	for i, v in ipairs(toenable) do
		__disabled[v] = nil
	end

	for event, eventData in pairs(__table) do
		for priority = -10, 10 do
			if eventData[priority] then
				for id, hookData in pairs(eventData[priority]) do
					hookData.disabled = false
				end
			end
		end

		hook.Reconstruct(event)
	end

	return toenable
end

--[[
	@doc
	@fname hook.EnableHook
	@args string event, any hookID

	@returns
	boolean
]]
function hook.EnableHook(event, stringID)
	assert(type(event) == 'string', 'hook.EnableHook - event is not a string! ' .. type(event))

	if not stringID then
		if not __disabled[event] then
			return false
		end

		__disabled[event] = nil
		return true
	end

	if not __table[event] then return false end
	stringID = transformStringID(stringID, event)

	for priority = -10, 10 do
		if __table[event][priority] and __table[event][priority][stringID] then
			local wasDisabled = __table[event][priority][stringID].disabled
			__table[event][priority][stringID].disabled = false
			hook.Reconstruct(event)
			return wasDisabled
		end
	end

	return false
end

--[[
	@doc
	@fname hook.Add
	@replaces
	@args string event, any hookID, function callback, number priority = 0

	@desc
	Refer to !g:hook.Add for main information
	`priority` can be a number within range of -10 to 10 inclusive
	`hookID` **can** be a number, unlike default gmod behavior, but can not be a boolean
	prints tracebacks when some of arguments are invalid instead of silent fail, unlike original hook
	throws an error when something goes horribly wrong instead of silent fail, unlike original hook
	if priority argument is omitted, then it uses `0` as priority (if hook was not defined before)
	and use previous priority if hook already exists (assuming we want to overwrite old hook definition) unlike ULib's hook
	this can be useful with software which can provide hook benchmarking by re-defining every single hook using hook.Add
	and it doesn't know about hook priorities
	@enddesc
]]
function hook.Add(event, stringID, funcToCall, priority)
	if type(event) ~= 'string' then
		--if DLib.DEBUG_MODE:GetBool() then
			DLib.Message(traceback('hook.Add - event is not a string! ' .. type(event)))
		--end

		return
	end

	__table[event] = __table[event] or {}

	if type(funcToCall) ~= 'function' then
		--if DLib.DEBUG_MODE:GetBool() then
			DLib.Message(traceback('hook.Add - function is not a function! ' .. type(funcToCall)))
		--end

		return
	end

	stringID = transformStringID(stringID, event)

	for priority = maximalPriority, minimalPriority do
		local eventsTable = __table[event][priority]

		if eventsTable and eventsTable[stringID] then
			if not priority then
				priority = eventsTable[stringID].priority
			end

			eventsTable[stringID] = nil
		end
	end

	priority = priority or 0

	if type(priority) ~= 'number' then
		priority = tonumber(priority) or 0
	end

	priority = math.Clamp(math.floor(priority), maximalPriority, minimalPriority)

	local hookData = {
		event = event,
		priority = priority,
		funcToCall = funcToCall,
		fn = funcToCall, -- ULib
		isstring = type(stringID) == 'string', -- ULib
		id = stringID,
		idString = tostring(stringID),
		registeredAt = SysTime(),
		typeof = type(stringID) == 'string'
	}

	__table[event][priority] = __table[event][priority] or {}
	__table[event][priority][stringID] = hookData
	__tableGmod[event] = __tableGmod[event] or {}
	__tableGmod[event][stringID] = funcToCall

	hook.Reconstruct(event)
	return
end

hook._O_SALT = hook._O_SALT or -0xFFFFFFF

--[[
	@doc
	@fname hook.Once
	@replaces
	@args string event, function callback, number priority = 0

	@desc
	`hook.Add`, but function would be called back only once.
	@enddesc
]]
function hook.Once(event, funcToCall, priority)
	hook._O_SALT = hook._O_SALT + 1
	local id = 'hook.Once.' .. hook._O_SALT

	hook.Add(event, id, function(...)
		hook.Remove(event, id)
		return funcToCall(...)
	end, priority)
end

--[[
	@doc
	@fname hook.Remove
	@replaces
	@args string event, any hookID
]]
function hook.Remove(event, stringID)
	if type(event) ~= 'string' then
		--if DLib.DEBUG_MODE:GetBool() then
			DLib.Message(traceback('hook.Remove - event is not a string! ' .. type(event)))
		--end

		return
	end

	if type(stringID) == 'nil' then
		--if DLib.DEBUG_MODE:GetBool() then
			DLib.Message(traceback('hook.Remove - hook id is nil!'))
		--end

		return
	end

	if not __table[event] then return end
	__tableGmod[event] = __tableGmod[event] or {}

	stringID = transformStringID(stringID, event)

	__tableGmod[event][stringID] = nil

	for priority = maximalPriority, minimalPriority do
		local eventsTable = __table[event][priority]

		if eventsTable ~= nil then
			local oldData = eventsTable[stringID]
			if oldData ~= nil then
				eventsTable[stringID] = nil
				hook.Reconstruct(event)
				return
			end
		end
	end
end

--[[
	@doc
	@fname hook.AddPostModifier
	@args string event, any hookID, function callback

	@desc
	Unique feature of DLib hook
	This allows you to define "post-hooks"
	hooks which transform data returned by previous hook
	Hooks bound to event will receive values returned by upvalue hook.
	**This is meant for advanced users only. Use with care and don't try anything stupid!**
	If you somehow don't want to mess with passed arguments, **you must return them back**
	otherwise engine/hook.Run caller/other post modifiers will receive empty values, like none of hooks returned values
	this can be useful for doing "final fixes" to data
	like custom final logic for PlayerSay (local chat/roleyplay for example) or fixes to CalcView
	using this will not affect admin/fun mods (they will use hook (e.g. PlayerSay) as usual)
	and final fixes will always work too despite type of hook
	*Limitation of this hook is that it can not see original arguments passed to* `hook.Run`
	@enddesc

	@returns
	boolean
	table: hookData
]]
function hook.AddPostModifier(event, stringID, funcToCall)
	__tableModifiersPost[event] = __tableModifiersPost[event] or {}

	if type(event) ~= 'string' then
		--if DLib.DEBUG_MODE:GetBool() then
			DLib.Message(traceback('hook.AddPostModifier - event is not a string! ' .. type(event)))
		--end

		return false
	end

	if type(funcToCall) ~= 'function' then
		--if DLib.DEBUG_MODE:GetBool() then
			DLib.Message(traceback('hook.AddPostModifier - function is not a function! ' .. type(funcToCall)))
		--end

		return false
	end

	stringID = transformStringID(stringID, event)

	local hookData = {
		event = event,
		funcToCall = funcToCall,
		id = stringID,
		idString = tostring(stringID),
		registeredAt = SysTime(),
		typeof = type(stringID) == 'string'
	}

	__tableModifiersPost[event][stringID] = hookData
	hook.ReconstructPostModifiers(event)
	return true, hookData
end

--[[
	@doc
	@fname hook.RemovePostModifier
	@args string event, any hookID

	@returns
	boolean
	table: hookData
]]
function hook.RemovePostModifier(event, stringID)
	if not __tableModifiersPost[event] then return false end

	stringID = transformStringID(stringID, event)
	if __tableModifiersPost[event][stringID] then
		local old = __tableModifiersPost[event][stringID]
		__tableModifiersPost[event][stringID] = nil
		hook.ReconstructPostModifiers(event)
		return true, old
	end

	return false
end

--[[
	@doc
	@fname hook.ReconstructPostModifiers
	@args string event

	@internal

	@desc
	builds optimized hook table
	@enddesc

	@returns
	table: sorted array of functions
	table: sorted array of hookData
]]
function hook.ReconstructPostModifiers(eventToReconstruct)
	if not eventToReconstruct then
		for event, tab in pairs(__tableModifiersPost) do
			hook.ReconstructPostModifiers(event)
		end

		return
	end

	__tableModifiersPostOptimized[eventToReconstruct] = {}
	local event = __tableModifiersPost[eventToReconstruct]

	local ordered = {}

	if event then
		for stringID, hookData in pairs(event) do
			if hookData.typeof == false then
				if hookData.id:IsValid() then
					table.insert(ordered, hookData)
				else
					event[stringID] = nil
				end
			else
				table.insert(ordered, hookData)
			end
		end
	end

	local cnt = #ordered

	if cnt == 0 then
		__tableModifiersPostOptimized[eventToReconstruct] = nil
	else
		local target = __tableModifiersPostOptimized[eventToReconstruct]

		for i = 1, cnt do
			table.insert(target, ordered[i].funcToCall)
		end
	end

	return __tableModifiersPostOptimized, ordered
end

--[[
	@doc
	@fname hook.ListAllHooks
	@args boolean includeDisabled = true

	@returns
	table: sorted array of hookData
]]
function hook.ListAllHooks(includeDisabled)
	if includeDisabled == nil then includeDisabled = true end
	local output = {}

	for event, priorityTable in pairs(__table) do
		for priority = maximalPriority, minimalPriority do
			local hookList = priorityTable[priority]

			if hookList then
				for stringID, hookData in pairs(hookList) do
					if not hookData.disabled or includeDisabled then
						table.insert(output, hookData)
					end
				end
			end
		end
	end

	return output
end

--[[
	@doc
	@fname hook.Reconstruct
	@args string event

	@internal

	@desc
	builds optimized hook table
	@enddesc

	@returns
	table: sorted array of functions
	table: sorted array of hookData
]]
function hook.Reconstruct(eventToReconstruct)
	if not eventToReconstruct then
		for event, data in pairs(__table) do
			hook.Reconstruct(event)
		end

		return
	end

	__tableOptimized[eventToReconstruct] = {}
	local ordered = {}
	local priorityTable = __table[eventToReconstruct]
	local inboundgmod = __tableGmod[eventToReconstruct]

	if priorityTable then
		for priority = maximalPriority, minimalPriority do
			local hookList = priorityTable[priority]

			if hookList then
				for stringID, hookData in pairs(hookList) do
					if not hookData.disabled then
						if hookData.typeof == false then
							if hookData.id:IsValid() then
								table.insert(ordered, hookData)
							else
								hookList[stringID] = nil
								inboundgmod[stringID] = nil
							end
						else
							table.insert(ordered, hookData)
						end
					end
				end
			end
		end
	end

	local cnt = #ordered

	if cnt == 0 then
		__tableOptimized[eventToReconstruct] = nil
	else
		local target = __tableOptimized[eventToReconstruct]

		for i = 1, cnt do
			local callable
			local hookData = ordered[i]

			if type(hookData.id) == 'string' then
				callable = hookData.funcToCall
			else
				local self = hookData.id
				local upfuncCallableSelf = hookData.funcToCall

				callable = function(...)
					if not self:IsValid() then
						hook.Remove(hookData.event, self)
						return
					end

					return upfuncCallableSelf(self, ...)
				end
			end

			if hook.PROFILING then
				local THIS_RUNTIME = 0
				local THIS_CALLS = 0
				local upfuncProfiled = callable

				callable = function(...)
					THIS_CALLS = THIS_CALLS + 1
					local t = SysTime()
					local Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M = upfuncProfiled(...)
					local t2 = SysTime()

					THIS_RUNTIME = THIS_RUNTIME + (t2 - t)
					return Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M
				end

				hookData.profileEnds = function()
					hookData.THIS_RUNTIME = THIS_RUNTIME
					hookData.THIS_CALLS = THIS_CALLS
				end
			end

			table.insert(target, callable)
		end
	end

	return __tableOptimized, ordered
end

local function Call(...)
	return hook.Call2(...)
end

local function Run(...)
	return hook.Run2(...)
end

local __breakage1 = {
	'HUDPaint',
	'PreDrawHUD',
	'PostDrawHUD',
	'Initialize',
	'InitPostEntity',
	'PreGamemodeInit',
	'PostGamemodeInit',
	'PostGamemodeInitialize',
	'PreGamemodeInitialize',
	'PostGamemodeLoaded',
	'PreGamemodeLoaded',
	'PostRenderVGUI',
	'OnGamemodeLoaded',

	'CreateMove',
	'StartCommand',
	'SetupMove',
}

local __breakage = {}

for i, str in ipairs(__breakage1) do
	__breakage[str] = true
end

-- these hooks can't return any values
hook.StaticHooks = __breakage

--[[
	@doc
	@fname hook.HasHooks
	@args string event

	@returns
	boolean
]]
function hook.HasHooks(event)
	return __tableOptimized[event] ~= nil and #__tableOptimized[event] ~= 0
end

--[[
	@doc
	@fname hook.CallStatic
	@args string event, table hookTable, vararg arguments

	@desc
	functions called can not interrupt call loop by returning arguments
	can not return arguments
	internall used to call some of most popular hooks
	which will break the game if at least one function in hook list will return value
	@enddesc

	@internal
]]
function hook.CallStatic(event, hookTable, ...)
	local post = __tableModifiersPostOptimized[event]
	local events = __tableOptimized[event]

	if events == nil then
		if hookTable == nil then
			return
		end

		local gamemodeFunction = hookTable[event]

		if gamemodeFunction == nil then
			return
		end

		return gamemodeFunction(hookTable, ...)
	end

	local i = 1
	local nextevent = events[i]

	::loop::
	nextevent(...)
	i = i + 1
	nextevent = events[i]

	if nextevent ~= nil then
		goto loop
	end

	if hookTable == nil then
		return
	end

	local gamemodeFunction = hookTable[event]

	if gamemodeFunction == nil then
		return
	end

	return gamemodeFunction(hookTable, ...)
end

--[[
	@doc
	@fname hook.Call
	@replaces
	@args string event, table hookTable, vararg arguments

	@returns
	vararg: values
]]
function hook.Call2(event, hookTable, ...)
	if __disabled[event] then
		return
	end

	ITERATING = event

	if __breakage[event] == true then
		hook.CallStatic(event, hookTable, ...)
		return
	end

	local post = __tableModifiersPostOptimized[event]
	local events = __tableOptimized[event]

	if events == nil then
		if hookTable == nil then
			return
		end

		local gamemodeFunction = hookTable[event]

		if gamemodeFunction == nil then
			return
		end

		if post == nil then
			return gamemodeFunction(hookTable, ...)
		end

		local Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M = gamemodeFunction(hookTable, ...)
		local i = 1
		local nextevent = post[i]

		::post_mloop1::
		Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M = nextevent(Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M)

		i = i + 1
		nextevent = post[i]

		if nextevent ~= nil then
			goto post_mloop1
		end

		return Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M
	end

	local i = 1
	local nextevent = events[i]

	::loop::
	local Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M = nextevent(...)

	if Q ~= nil then
		if post == nil then
			return Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M
		end

		local i = 1
		local nextevent = post[i]

		::post_mloop2::
		Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M = nextevent(Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M)

		i = i + 1
		nextevent = post[i]

		if nextevent ~= nil then
			goto post_mloop2
		end

		return Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M
	end

	i = i + 1
	nextevent = events[i]

	if nextevent ~= nil then
		goto loop
	end

	if hookTable == nil then
		return
	end

	local gamemodeFunction = hookTable[event]

	if gamemodeFunction == nil then
		return
	end

	if post == nil then
		return gamemodeFunction(hookTable, ...)
	end

	local Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M = gamemodeFunction(hookTable, ...)
	local i = 1
	local nextevent = post[i]

	::post_mloop3::
	Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M = nextevent(Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M)

	i = i + 1
	nextevent = post[i]

	if nextevent ~= nil then
		goto post_mloop3
	end

	return Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M
end


--[[
	@doc
	@fname hook.Run
	@replaces
	@args string event, vararg arguments

	@returns
	vararg: values
]]

--[[
	@doc
	@fname gamemode.Call
	@replaces
	@args string event, vararg arguments

	@returns
	vararg: values
]]
if gmod then
	local GetGamemode = gmod.GetGamemode

	function hook.Run2(event, ...)
		return hook.Call2(event, GetGamemode(), ...)
	end

	function gamemode.Call(event, ...)
		local gm = GetGamemode()

		if gm == nil then return false end
		if gm[event] == nil then return false end

		return hook.Call2(event, gm, ...)
	end
else
	function hook.Run2(event, ...)
		return hook.Call2(event, GAMEMODE, ...)
	end

	function gamemode.Call()
		return false
	end
end

for k, v in pairs(hook) do
	if type(v) == 'function' then
		hook[k:sub(1, 1):lower() .. k:sub(2)] = v
	end
end

-- Engine permanently remembers function address
-- So we need to transmit the call to our subfunction in order to modify it on the fly (with no runtime costs because JIT is <3)
-- and local "hook" will never point at wrong table

hook.Call = Call
hook.Run = Run
hook.GetTable = GetTable

if oldHooks then
	for event, priorityTable in pairs(oldHooks) do
		for priority, hookTable in pairs(priorityTable) do
			for hookID, hookFunc in pairs(hookTable) do
				hook.Add(event, hookID, hookFunc.fn, priority)
			end
		end
	end
end

setmetatable(hook, {
	__call = function(self, ...)
		return self.Add(...)
	end
})

if ghook ~= DLib.ghook and ents.GetCount() < 10 then
	DLib.ghook = ghook

	for k, v in pairs(ghook) do
		rawset(ghook, k, nil)
	end

	setmetatable(DLib.ghook, {
		__index = hook,

		__newindex = function(self, key, value)
			if hook[key] == value then return end

			if DLib.DEBUG_MODE:GetBool() then
				DLib.Message(traceback('DEPRECATED: Do NOT mess with hook system directly! https://goo.gl/NDAQqY\nReport this message to addon author which is involved in this stack trace:\nhook.' .. tostring(key) .. ' (' .. tostring(hook[key]) .. ') -> ' .. tostring(value), 2))
			end

			local status = hook.Call('DLibHookChange', nil, key, value)
			if status == false then return end
			rawset(hook, key, value)
		end,

		__call = function(self, ...)
			return self.Add(...)
		end
	})
elseif ghook ~= DLib.ghook then
	function ghook.AddPostModifier()

	end
end

DLib.benchhook = {
	Add = hook.Add,
	Call = hook.Call2,
	Run = hook.Run2,
	Remove = hook.Remove,
	GetTable = hook.GetTable,
}

local function lua_findhooks(eventName, ply)
	DLib.MessagePlayer(ply, '----------------------------------')
	DLib.MessagePlayer(ply, string.format('Finding %s hooks for event %q', CLIENT and 'CLIENTSIDE' or 'SERVERSIDE', eventName))

	local tableToUse = __table[eventName]

	if tableToUse and table.Count(tableToUse) ~= 0 then
		for priority = maximalPriority, minimalPriority do
			local hookList = tableToUse[priority]

			if hookList then
				for stringID, hookData in pairs(hookList) do
					local info = debug.getinfo(hookData.funcToCall)
					DLib.MessagePlayer(ply,
						string.format(
							'\t\t%q [%s] at %p (%s: %i->%i)',
							stringID,
							priority,
							hookData.funcToCall,
							info.source,
							info.linedefined,
							info.lastlinedefined
						)
					)
				end
			end
		end
	else
		DLib.MessagePlayer(ply, 'No hooks defined for specified event')
	end

	DLib.MessagePlayer(ply, '----------------------------------')
end

--[[
	@doc
	@fname hook.GetDumpStr

	@internal

	@returns
	string
]]
function hook.GetDumpStr()
	local lines = {}

	local sorted = {}

	for eventName, eventData in pairs(__table) do
		table.insert(sorted, eventName)
	end

	table.sort(sorted)

	for i, eventName in ipairs(sorted) do
		local eventData = __table[eventName]

		for priority = maximalPriority, minimalPriority do
			local hookList = eventData[priority]

			if hookList then
				local llines = {}
				table.insert(lines, '// Begin list hooks of event ' .. eventName)

				for stringID, hookData in pairs(hookList) do
					local info = debug.getinfo(hookData.funcToCall)

					table.insert(llines,
						string.format(
							'\t%q [%s] at %p (%s: %i->%i)',
							tostring(stringID),
							tostring(priority),
							hookData.funcToCall,
							info.source,
							info.linedefined,
							info.lastlinedefined
						)
					)
				end

				table.sort(llines)
				table.append(lines, llines)

				table.insert(lines, '// End list hooks of event ' .. eventName .. '\n')
			end
		end
	end

	return table.concat(lines, '\n')
end

local function lua_findhooks_cl(ply, cmd, args)
	if not game.SinglePlayer() and IsValid(ply) and ply:IsPlayer() and not ply:IsAdmin() then return end

	if not args[1] then
		DLib.Message('No event name were provided!')
		return
	end

	lua_findhooks(table.concat(args, ' '):trim(), ply)
end

local function lua_findhooks_sv(ply, cmd, args)
	if not game.SinglePlayer() and IsValid(ply) and ply:IsPlayer() and not ply:IsAdmin() then return end

	if not args[1] then
		DLib.Message('No event name were provided!')
		return
	end

	lua_findhooks(table.concat(args, ' '):trim(), ply)
end

do
	local function autocomplete(cmd, args)
		args = args:lower():trim()

		if args[1] == '"' then
			args = args:sub(2)
		end

		if args[#args] == '"' then
			args = args:sub(1, #args - 1)
		end

		local output = {}

		for k, v in pairs(__tableGmod) do
			if k:lower():startsWith(args) then
				table.insert(output, cmd .. ' "' .. k .. '"')
			end
		end

		table.sort(output)

		return output
	end

	timer.Simple(0, function()
		if CLIENT then
			concommand.Add('lua_findhooks_cl', lua_findhooks_cl, autocomplete)
		else
			concommand.Add('lua_findhooks', lua_findhooks_sv, autocomplete)
		end
	end)
end

local function printProfilingResults(ply)
	local deftable = {}

	local totalRuntime = 0

	for i, hookData in ipairs(hook.ListAllHooks(false)) do
		deftable[hookData.event] = deftable[hookData.event] or {runtime = 0, calls = 0, list = {}, name = hookData.event}

		table.insert(deftable[hookData.event].list, hookData)
		deftable[hookData.event].runtime = deftable[hookData.event].runtime + hookData.THIS_RUNTIME
		totalRuntime = totalRuntime + hookData.THIS_RUNTIME
		deftable[hookData.event].calls = deftable[hookData.event].calls + hookData.THIS_CALLS
	end

	local sortedtable = {}

	for event, eventTable in pairs(deftable) do
		table.sort(eventTable.list, function(a, b)
			return a.THIS_RUNTIME > b.THIS_RUNTIME
		end)

		table.insert(sortedtable, eventTable)
	end

	table.sort(sortedtable, function(a, b)
		return a.runtime > b.runtime
	end)

	DLib.MessagePlayer(ply, '-----------------------------------')
	DLib.MessagePlayer(ply, '------ HOOK PROFILING REPORT ------')
	DLib.MessagePlayer(ply, '-----------------------------------')

	local time = hook.PROFILE_ENDS - hook.PROFILE_STARTED

	for pos, eventTable in ipairs(sortedtable) do
		if pos > 10 then
			DLib.MessagePlayer(ply, '... tail of events ... (', #sortedtable - 10, ' are not shown)')
			break
		end

		DLib.MessagePlayer(ply, '/// ' .. eventTable.name .. ': Runtime position: ', pos, string.format(' (%.2f%% of game runtime); - Total hook calls: ', (eventTable.runtime / time) * 100), eventTable.calls,
			string.format('; Total runtime: %.2f milliseconds (~%.2f microseconds per hook call on average)', eventTable.runtime * 1000, (eventTable.runtime * 1000000) / eventTable.calls))

		for pos2, hookData in ipairs(eventTable.list) do
			if hookData.THIS_RUNTIME <= 0.001 then
				DLib.MessagePlayer(ply, '(', #eventTable.list - pos2 + 1, ' are not shown)')
				break
			end

			DLib.MessagePlayer(ply, 'Hook ID: ', hookData.id)
			DLib.MessagePlayer(ply, string.format('\t - Runtime: %.2f milliseconds; %i calls; ~%.2f microseconds per call on average',
				hookData.THIS_RUNTIME * 1000, hookData.THIS_CALLS, (hookData.THIS_RUNTIME * 1000000) / hookData.THIS_CALLS))
		end
	end

	DLib.MessagePlayer(ply, '--')
	DLib.MessagePlayer(ply, 'In total, regular hooks took around ', math.floor((totalRuntime / time) * 10000) / 100, '% of game runtime.')
	DLib.MessagePlayer(ply, '--')

	DLib.MessagePlayer(ply, '-----------------------------------')
	DLib.MessagePlayer(ply, '--- END OF HOOK PROFILING REPORT --')
	DLib.MessagePlayer(ply, '-----------------------------------')
end

if CLIENT then
	concommand.Add('dlib_profile_hooks_cl', function(ply, cmd, args)
		if hook.PROFILING then
			hook.PROFILE_ENDS = SysTime()
			hook.PROFILING = false
			hook.PROFILING_RESULTS_EXISTS = true
			hook.Reconstruct()

			for i, hookData in ipairs(hook.ListAllHooks(false)) do
				hookData.profileEnds()
			end

			printProfilingResults(LocalPlayer())
			return
		end

		hook.PROFILE_STARTED = SysTime()
		hook.PROFILING = true

		DLib.Message('Hook profiling were started')
		DLib.Message('When you are ready you can type dlib_profile_hooks_cl again')
		DLib.Message('/// NOTE THAT RESULTS BECOME MORE ACCURATE AS PROFILING GOES!')
		DLib.Message('/// Disabling it too early will produce false results')
		hook.Reconstruct()
	end)

	concommand.Add('dlib_profile_hooks_last_cl', function(ply, cmd, args)
		if not hook.PROFILING_RESULTS_EXISTS then
			DLib.Message('No profiling results exists!')
			DLib.Message('Start a new one by typing dlib_profile_hooks_cl')
			return
		end

		printProfilingResults(LocalPlayer())
	end)
else
	concommand.Add('dlib_profile_hooks_last_sv', function(ply, cmd, args)
		if IsValid(ply) and not ply:IsSuperAdmin() then
			DLib.MessagePlayer(ply, 'Not a super admin!')
			return
		end

		if not hook.PROFILING_RESULTS_EXISTS then
			DLib.MessagePlayer(ply, 'No profiling results exists!')
			DLib.MessagePlayer(ply, 'Start a new one by typing dlib_profile_hooks_cl')
			return
		end

		DLib.Message(IsValid(ply) and ply or 'Console', ' requested hook profiling results')
		printProfilingResults(ply)
	end)

	concommand.Add('dlib_profile_hooks_sv', function(ply, cmd, args)
		if IsValid(ply) and not ply:IsSuperAdmin() then
			DLib.MessagePlayer(ply, 'Not a super admin!')
			return
		end

		if hook.PROFILING then
			DLib.Message(IsValid(ply) and ply or 'Console', ' stopped hook profiling')
			hook.PROFILE_ENDS = SysTime()
			hook.PROFILING = false
			hook.PROFILING_RESULTS_EXISTS = true
			hook.Reconstruct()

			for i, hookData in ipairs(hook.ListAllHooks(false)) do
				hookData.profileEnds()
			end

			printProfilingResults(ply)
			return
		end

		DLib.Message(IsValid(ply) and ply or 'Console', ' started hook profiling')

		hook.PROFILE_STARTED = SysTime()
		hook.PROFILING = true

		DLib.MessagePlayer(ply, 'Hook profiling were started')
		DLib.MessagePlayer(ply, 'When you are ready you can type dlib_profile_hooks_cl again')
		DLib.MessagePlayer(ply, '/// NOTE THAT RESULTS BECOME MORE ACCURATE AS PROFILING GOES!')
		DLib.MessagePlayer(ply, '/// Disabling it too early will produce false results')
		hook.Reconstruct()
	end)
end

if file.Exists('autorun/hat_init.lua', 'LUA') then
	DLib.Message(string.rep('-', 63))
	DLib.Message(string.rep('W', 63))
	DLib.Message(string.rep('A', 63))
	DLib.Message(string.rep('R', 63))
	DLib.Message(string.rep('N', 63))
	DLib.Message(string.rep('I', 63))
	DLib.Message(string.rep('N', 63))
	DLib.Message(string.rep('G', 63))
	DLib.Message('HAT INSTALLATION DETECTED')
	DLib.Message('HAT IS BASICALLY BROKEN FOR YEARS')
	DLib.Message('AND IT ALSO BREAK THE GAME, OBVIOUSLY')
	DLib.Message('IMPLEMENTING HAT LOADER TRAP')
	DLib.Message(string.rep('-', 63))

	table._DLibCopy = table._DLibCopy or table.Copy

	function table.Copy(tableIn)
		if tableIn == _G.concommand or tableIn == _G.hook then
			table.Copy = table._DLibCopy
			error('Nuh uh. No. Definitely Not. I dont even.', 2)
		end

		return table._DLibCopy(tableIn)
	end
end
