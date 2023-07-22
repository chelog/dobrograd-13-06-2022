
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


local QUQUED_CALLS = {}
local QUQUED_CALLS_WRAPPED = {}

local table = table
local ipairs = ipairs
local select = select
local unpack = unpack

--[[
	@doc
	@fname DLib.QueuedFunction
	@args function funcIn, vargarg values

	@desc
	Adds function to internal run queue.
	If queue is empty, function provided will be ran on next frame.
	If not, function will run after all previous function will be executed over game frames.
	Can be used for queueing functions which can be called ina burst on a single game frame
	and are not timing critical, like broadcasting log messages.
	In example above it will avoid net channel overflow and avoid data discard when using
	`reliable = false` in net.Start
	@enddesc
]]
function DLib.QueuedFunction(funcIn, ...)
	table.insert(QUQUED_CALLS, {
		nextevent = funcIn,
		args = {...},
		argsNum = select('#', ...)
	})
end

--[[
	@doc
	@fname DLib.WrappedQueueFunction
	@args function upvalue

	@desc
	same purpose as DLib.QueuedFunction, but instead returns function
	which on call will create queue entry
	@enddesc

	@returns
	function: a function to call. can accept vararg arguments which will be passed to upvalue function
]]
function DLib.WrappedQueueFunction(funcIn)
	return function(...)
		table.insert(QUQUED_CALLS_WRAPPED, {
			nextevent = funcIn,
			args = {...},
			argsNum = select('#', ...)
		})
	end
end

hook.Add('Think', 'DLib.util.QueuedFunction', function()
	local data = table.remove(QUQUED_CALLS, 1)
	if not data then return end
	data.nextevent(unpack(data.args, 1, data.argsNum))
end)

hook.Add('Think', 'DLib.util.WrappedQueueFunction', function()
	local data = table.remove(QUQUED_CALLS_WRAPPED, 1)
	if not data then return end
	data.nextevent(unpack(data.args, 1, data.argsNum))
end)
