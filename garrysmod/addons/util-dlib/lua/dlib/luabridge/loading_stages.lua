
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

local hook = hook
local DLib = DLib
local CurTime = CurTime

local init_post_entity = CurTime() > 60
local initialize = CurTime() > 60

--[[
	@doc
	@fname AreEntitiesAvailable

	@returns
	boolean
]]
function _G.AreEntitiesAvailable()
	return init_post_entity
end

function _G.AreEntitiesAvaliable()
	return init_post_entity
end

--[[
	@doc
	@fname IsGamemodeAvaliable

	@returns
	boolean
]]
function _G.IsGamemodeAvaliable()
	return initialize
end

if not init_post_entity then
	hook.Add('InitPostEntity', 'DLib.LoadingStages', function()
		init_post_entity = true
	end)
end

if not initialize then
	hook.Add('Initialize', 'DLib.LoadingStages', function()
		initialize = true
	end)
end
