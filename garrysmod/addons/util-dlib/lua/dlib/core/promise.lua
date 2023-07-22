
-- Copyright (C) 2016-2018 DBot

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

local meta = FindMetaTable('Promise') or {}
debug.getregistry().Promise = meta

local setmetatable = setmetatable
local DLib = DLib
local type = type
local error = error
local xpcall = xpcall
local debug = debug
local ProtectedCall = ProtectedCall

meta.MetaName = 'Promise'
meta.__index = meta

local coroutine = coroutine

--[[
	@doc
	@fname DLib.Promise
	@args function handler

	@desc
	Same as [Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) but:
	use `Promise:Catch(function)` and
	`Promise:Then(function)`

	Alse there is `Promise:Awat(varargForYield)` for use inside coroutine available.
	@enddesc

	@returns
	Promise: created promise
]]
local function constructor(handler)
	local mtype = type(handler)
	assert(mtype == 'function' or mtype ~= 'thread', 'Promise handler were not provided (function/thread); got ' .. mtype)

	local self = setmetatable({}, meta)

	self.handlerType = mtype
	self.handler = handler
	self.success = false
	self.executed = false
	self.executed_finish = false
	self.failure = false
	self.traceback = debug.traceback(nil, 2)

	self:execute()

	return self
end

DLib.Promise = constructor
_G.Promise = constructor

function meta:execute()
	if self.executed then error('wtf dude') end

	self.executed = true

	if self.handlerType == 'function' then
		xpcall(self.handler, function(err)
			self.errors = {debug.traceback(err, 2)}
			self.failure = true
			self.executed_finish = true

			if self.reject then
				self.reject(debug.traceback(err, 2))
			end
		end, function(...)
			self.returns = {...}
			self.success = true
			self.executed_finish = true

			if self.resolve then
				self.resolve(...)
			end
		end, function(...)
			self.errors = {...}
			self.failure = true
			self.executed_finish = true

			if self.reject then
				self.reject(...)
			end
		end)
	else
		hook.Add('Think', self, function()
			local args = {coroutine.resume(self.handler)}

			if not args[1] then
				self.errors = {args[2]}
				self.failure = true
				self.executed_finish = true

				if self.reject then
					self.reject(err)
				end

				return
			end

			local status = coroutine.status(status)

			if status == 'dead' then
				table.remove(args, 1)

				self.returns = args
				self.success = true
				self.executed_finish = true

				if self.resolve then
					self.resolve(unpack(args, 1, #args))
				end
			end
		end)
	end

	return self
end

function meta:catch(handler)
	if type(handler) ~= 'function' then
		error('Invalid handler; got ' .. type(handler))
	end

	self.reject = handler

	if self.executed and self.failure then
		handler(unpack(self.errors, 1, #self.errors))
	end

	return self
end

function meta:reslv(handler)
	if type(handler) ~= 'function' then
		error('Invalid handler; got ' .. type(handler))
	end

	self.resolve = handler

	if self.executed and self.success then
		handler(unpack(self.returns, 1, #self.returns))
	end

	return self
end

function meta:IsValid()
	return not self.executed_finish
end

function meta:Await(...)
	local thread = assert(coroutine.running(), 'not in a coroutine thread')

	local fulfilled = false
	local err

	self:reslv(function()
		fulfilled = true
		coroutine.resume(thread)
	end)

	self:catch(function(err2)
		err = err2
		fulfilled = true
		coroutine.resume(thread)
	end)

	while not fulfilled do
		coroutine.yield(...)
	end

	if err then
		error(err)
	end

	return unpack(self.returns, 1, #self.returns)
end

meta.await = meta.Await
meta.resolv = meta.reslv
meta.after = meta.reslv
meta.Then = meta.reslv
meta.error = meta.catch
meta.Catch = meta.catch
