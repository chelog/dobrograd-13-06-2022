
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


-- make some functions be jit compilable

if SERVER then
	_G.CurTimeL = CurTime
	_G.RealTimeL = RealTime
	return
end

--[[
	@docpreprocess

	const vars = [
		'FrameNumber',
		'RealTime',
		'CurTime',
		'ScrW',
		'ScrH',
	]

	const output = []

	for (const str of vars) {
		const output2 = []
		output2.push(`@fname ${str}L`)
		output2.push(`@desc`)
		output2.push(`alias of !g:${str} but JIT compilable`)
		output2.push(`@enddesc`)
		output2.push(`@returns`)
		output2.push(`number`)
		output.push(output2)
	}

	return output
]]

local DLib = DLib
_G.FrameNumberC = FrameNumberC or FrameNumber
_G.RealTimeC = RealTimeC or RealTime
_G.CurTimeC = CurTimeC or CurTime

_G.ScrWC = ScrWC or ScrW
_G.ScrHC = ScrHC or ScrH
local ScrWC = ScrWC
local ScrHC = ScrHC
local render = render
local type = type
local assert = assert

DLib.luaify_rTime = RealTimeC()
DLib.luaify_cTime = CurTimeC()
DLib.luaify_frameNum = FrameNumberC()

DLib.luaify_scrw = ScrWC()
DLib.luaify_scrh = ScrHC()
DLib.pstatus = false

function _G.RealTimeL()
	return DLib.luaify_rTime
end

function _G.FrameNumberL()
	return DLib.luaify_frameNum
end

function _G.CurTimeL()
	return DLib.luaify_cTime
end

function _G.ScrWL()
	return DLib.luaify_scrw
end

function _G.ScrHL()
	return DLib.luaify_scrh
end
