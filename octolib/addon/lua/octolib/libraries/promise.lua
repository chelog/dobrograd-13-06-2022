---------------------------------------------------------------------
-- PROMISE LIBRARY by Dragoteryx
-- improved by Octothorp Team
--
-- all credit goes to this guy, hope his pull request gets merged:
-- https://github.com/Dragoteryx/garrysmod/tree/promise
---------------------------------------------------------------------

--[[
	Class: Promise
		Helper object used to simplify asynchronous
		task chaining and error catching
]]

local PENDING = 0
local RESOLVED = 1
local REJECTED = -1

local Promise = {}
Promise.__index = Promise
function Promise:_New(callback)
	local self = {}
	self._state = PENDING
	self._handlers = {}
	setmetatable(self, Promise)
	local safe, args = pcall(function()
		callback(function(res)
			self:_Resolve(res)
		end, function(err)
			self:_Reject(err)
		end)
	end)
	if not safe then self:_Reject(args) end
	return self
end

function Promise:_Resolve(res)
	if self:IsSettled() then return end
	local safe, args = pcall(function()
		if getmetatable(res) == Promise then
			res:Then(function(res)
				self:_Resolve(res)
			end, function(err)
				self:_Reject(err)
			end)
		else
			self._state = RESOLVED
			self._value = res
			for i, handler in ipairs(self._handlers) do
				handler.onresolve(res)
			end
		end
	end)
	if not safe then self:_Reject(args) end
end

function Promise:_Reject(err)
	if self:IsSettled() then return end
	self._state = REJECTED
	self._value = err
	for i, handler in ipairs(self._handlers) do
		handler.onreject(err)
	end
end

setmetatable(Promise, {__call = Promise._New})

-- Group: Constructors

--[[
	Constructor: util.Promise

	Returns:
		<Promise> - Newly created promise
]]
function util.Promise(callback)
	return Promise(callback)
end

--[[
	Constructor: http.Promise

	Arguments:
		data - _table_ Table of <HTTP function: https://wiki.facepunch.com/gmod/Global.HTTP> options

	Returns:
		<Promise> - Newly created promise
]]
function http.Promise(request)
	return util.Promise(function(resolve, reject)		
		request.success = function(code, body, headers)
			resolve({
				code = code,
				body = body,
				headers = headers
			})
		end
		request.failed = reject
		if not HTTP(request) then reject("HTTP failed") end
	end)	
end

-- Group: Methods

--[[
	Function: IsPending
		Returns whether promise is pending

	Returns:
		_bool_ True if promise is neither resolved nor rejected yet
]]
function Promise:IsPending()
	return self._state == PENDING
end

--[[
	Function: IsSettled
		Returns whether promise is settled

	Returns:
		_bool_ True if promise is either resolved or rejected
]]
function Promise:IsSettled()
	return not self:IsPending()
end

--[[
	Function: IsResolved
		Returns whether promise is resolved

	Returns:
		_bool_ True if promise is resolved
]]
function Promise:IsResolved()
	return self._state == RESOLVED
end

--[[
	Function: IsFulfilled
		Alias of <IsResolved>
]]
function Promise:IsFulfilled()
	return self:IsResolved()
end

--[[
	Function: IsRejected
		Returns whether promise is rejected

	Returns:
		_bool_ True if promise is rejected
]]
function Promise:IsRejected()
	return self._state == REJECTED
end

--[[
	Function: Done
		Add handlers to the promise

	Arguments:
		onresolve - _function_ Function to execute on promise resolve
		onreject - _function_ Function to execute on promise reject
]]
function Promise:Done(onresolve, onreject)
	if onresolve == nil then onresolve = function() end end
	if onreject == nil then onreject = function() end end
	timer.Simple(0, function()
		if self:IsPending() then
			table.insert(self._handlers, {
				onresolve = onresolve,
				onreject = onreject
			})
		elseif self:IsResolved() then
			onresolve(self._value)
		else
			onreject(self._value)
		end
	end)
end

--[[
	Function: Finally
		Add handlers to the promise

	Arguments:
		ondone - _function_ Function to execute after promise was either resolved or rejected
]]
function Promise:Finally(ondone)
	if ondone == nil then return end
	if self:IsPending() then
		table.insert(self._handlers, {
			onresolve = ondone,
			onreject = ondone
		})
	else
		ondone(self._value)
	end
end

--[[
	Function: Then
		Add handlers to the promise

	Arguments:
		onresolve - _function_ Function to execute on promise resolve
		onreject - _function_ Function to execute on promise reject

	Returns:
		<Promise> - New promise wrapping original, useful for chaining
]]
function Promise:Then(onresolve, onreject)
	return Promise(function(resolve, reject)
		self:Done(function(res)
			if isfunction(onresolve) then
				local safe, args = pcall(function()
					resolve(onresolve(res))
				end)
				if not safe then reject(args) end
			else resolve(res) end
		end, function(err)
			if isfunction(onreject) then
				local safe, args = pcall(function()
					resolve(onreject(err))
				end)
				if not safe then reject(args) end
			else reject(err) end
		end)
	end)
end

--[[
	Function: Catch
		Error handler for rejected promises in chain

	Arguments:
		onreject - _function_ Function to execute on promise reject

	Returns:
		<Promise> - New promise wrapping original, useful for chaining
]]
function Promise:Catch(onreject)
	return self:Then(nil, onreject)
end

function Promise:Await()
	if not coroutine.running() then return end
	while self:IsPending() do coroutine.yield() end
	if self:IsResolved() then
		return self._value
	else error(self._value) end
end

function Promise:__tostring()
	if self:IsPending() then return "Promise: pending"
	elseif self:IsResolved() then return "Promise: fulfilled ("..tostring(self._value)..")"
	else return "Promise: rejected ("..tostring(self._value)..")" end
end

-- Group: Utility

--[[
	Function: util.PromiseAll
		Returns a Promise that is resolved when every Promise passed as a parameter
		is resolved, or rejected when one of the passed promises is rejected

	Arguments:
		promises - _table of <Promise>_ Sequential or keyed table of promises
	
	Returns:
		<Promise> - Table with results of supplied promises under same keys
]]
function util.PromiseAll(promises)
	return Promise(function(resolve, reject)
		local remaining = table.Count(promises)
		if remaining > 0 then
			local results = {}
			for key, promise in pairs(promises) do
				promise:Then(function(res)
					results[key] = res
					remaining = remaining - 1
					if remaining == 0 then
						resolve(results)
					end
				end, reject)
			end
		else resolve({}) end
	end)
end

--[[
	Function: util.PromiseFirst
		Returns a Promise that is resolved/rejected with the first settled Promise

	Arguments:
		promises - _table of <Promise>_ Sequential or keyed table of promises
	
	Returns:
		<Promise> - Result of first resolved promise
]]
function util.PromiseFirst(promises)
	return Promise(function(resolve, reject)
		for key, promise in pairs(promises) do
			promise:Then(resolve, reject)
		end
	end)
end

local id = 0
local coroutines = {}

function util.PromiseAsync(callback)
	return Promise(function(resolve, reject)
		local co = coroutine.create(function()
			local safe, args = pcall(function()
				resolve(callback())
			end)
			if not safe then reject(args) end
		end)
		coroutines[id] = co
		id = id+1
	end)
end

hook.Add("Think", "PromiseAsyncCoroutines", function()
	for id, co in pairs(coroutines) do
		local status = coroutine.status(co)
		if status == "suspended" then
			coroutine.resume(co)
		elseif status == "dead" then
			coroutines[id] = nil
		end
	end
end)
