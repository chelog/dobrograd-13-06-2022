
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


local DLib = DLib
local lastW, lastH = ScrWL(), ScrHL()
local hook = hook

local function check(w, h)
	if w == lastW and h == lastH then return end

	if w ~= lastW then
		hook.Run('ScreenWidthChanges', lastW, w)
	end

	if h ~= lastH then
		hook.Run('ScreenHeightChanges', lastH, h)
	end

	DLib.TriggerScreenSizeUpdate(lastW, lastH, w, h)

	lastW, lastH = w, h
end

--[[
	@doc
	@hook ScreenResolutionChanged
	@alias ScreenSizeChanged
	@alias OnScreenSizeChanged
	@alias OnScreenResolutionUpdated
	@args number lastWidth, number lastHeight, number width, number height

	@desc
	use this hook for recalculating logic based on sizes of screen resolution
	@enddesc
]]
function DLib.TriggerScreenSizeUpdate(lw, lh, w, h)
	hook.Run('ScreenResolutionChanged', lw, lh, w, h)
	hook.Run('ScreenSizeChanged', lw, lh, w, h)
	hook.Run('OnScreenSizeChanged', lw, lh, w, h)
	hook.Run('OnScreenResolutionUpdated', lw, lh, w, h)
end

concommand.Add('dlib_reload_materials', function()
	DLib.TriggerScreenSizeUpdate(0, 0, lastW, lastH)
end)

--[[
	@doc
	@fname surface.DLibCreateFont
	@args string fontName, table fontData

	@desc
	Same as !g:surface.CreateFont but `size` getting altered by `ScreenSize()` call and
	font is automatically recreated on each `ScreenResolutionChanged` hook call
	@enddesc
]]
function surface.DLibCreateFont(fontName, fontData)
	fontData.osize = fontData.size

	local function refresh()
		fontData.size = ScreenSize(fontData.osize)
		surface.CreateFont(fontName, fontData)
	end

	hook.Add('ScreenResolutionChanged', fontName, refresh)
	refresh()
end

local dlib_guiding_lines = CreateConVar('dlib_guiding_lines', '0', {}, 'Draw guiding lines on screen')
local gui = gui
local surface = surface
local ScreenSize = ScreenSize

surface.CreateFont('DLib.GuidingLine', {
	font = 'PT Mono',
	size = 24,
	weight = 500
})

local function DrawGuidingLines()
	if not dlib_guiding_lines:GetBool() then return end

	local x, y = gui.MousePos()
	if x == 0 and y == 0 then return end

	surface.SetDrawColor(183, 174, 174)

	surface.DrawRect(0, y - ScreenSize(2), lastW, ScreenSize(4))
	surface.DrawRect(x - ScreenSize(2), 0, ScreenSize(4), lastH)
	DLib.HUDCommons.WordBox(string.format('X percent: %.2f Y percent: %.2f', x / lastW, y / lastH), 'DLib.GuidingLine', x:clamp(lastW * 0.15, lastW * 0.85), (y - ScreenSize(17)):clamp(lastH * 0.1, lastH * 0.9), color_white, color_black, true)
end

hook.Add('DLib.ScreenSettingsUpdate', 'DLib.UpdateScreenSize', check)
hook.Add('HUDPaint', 'DLib.DrawGuidingLines', DrawGuidingLines)
