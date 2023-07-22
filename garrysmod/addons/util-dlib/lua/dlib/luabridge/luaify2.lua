
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

if SERVER then return end

local DLib = DLib
local FrameNumberC = FrameNumberC
local RealTimeC = RealTimeC
local CurTimeC = CurTimeC
local ScrWC = ScrWC
local ScrHC = ScrHC
local hook = hook

local function update()
	DLib.luaify_rTime = RealTimeC()
	DLib.luaify_cTime = CurTimeC()
	DLib.luaify_frameNum = FrameNumberC()

	DLib.luaify_scrw = ScrWC()
	DLib.luaify_scrh = ScrHC()

	hook.Run('DLib.ScreenSettingsUpdate', DLib.luaify_scrw, DLib.luaify_scrh)
end

hook.Add('PreRender', 'DLib.UpdateFrameOptions', update, -9)
hook.Add('Think', 'DLib.UpdateFrameOptions', update, -9)

local function update()
	DLib.luaify_rTime = RealTimeC()
	DLib.luaify_cTime = CurTimeC()
	DLib.luaify_frameNum = FrameNumberC()
end

hook.Add('Tick', 'DLib.UpdateFrameOptions', update, -9)
hook.Add('PlayerSwitchWeapon', 'DLib.UpdateFrameOptions', update, -9)
hook.Add('StartCommand', 'DLib.UpdateFrameOptions', update, -9)
hook.Add('SetupMove', 'DLib.UpdateFrameOptions', update, -9)
hook.Add('Move', 'DLib.UpdateFrameOptions', update, -9)
hook.Add('VehicleMove', 'DLib.UpdateFrameOptions', update, -9)
hook.Add('PlayerTick', 'DLib.UpdateFrameOptions', update, -9)
hook.Add('ShouldCollide', 'DLib.UpdateFrameOptions', update, -9)
hook.Add('PlayerButtonDown', 'DLib.UpdateFrameOptions', update, -9)
hook.Add('PlayerButtonUp', 'DLib.UpdateFrameOptions', update, -9)
hook.Add('PhysgunPickup', 'DLib.UpdateFrameOptions', update, -9)
hook.Add('KeyPress', 'DLib.UpdateFrameOptions', update, -9)
hook.Add('KeyRelease', 'DLib.UpdateFrameOptions', update, -9)
hook.Add('FinishMove', 'DLib.UpdateFrameOptions', update, -9)
