
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


local DLib = DLib
local surface = surface
local draw = draw
local Color = Color
local GWEN = GWEN
local surface_SetTexture = surface.SetTexture
local surface_DrawRect = surface.DrawRect
local surface_GetTextSize = surface.GetTextSize
local surface_SetTextColor = surface.SetTextColor
local surface_SetTextPos = surface.SetTextPos
local surface_DrawText = surface.DrawText
local surface_SetFont = surface.SetFont
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawLine = surface.DrawLine
local Simple_DrawBox = DLib.skin.Simple_DrawBox
local Simple_DrawText = DLib.skin.Simple_DrawText

--Left
function DLib.skin.tex.Scroller.LeftButton_Normal(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColor)
	Simple_DrawText('◀', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

function DLib.skin.tex.Scroller.LeftButton_Hover(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColorH)
	Simple_DrawText('◀', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

function DLib.skin.tex.Scroller.LeftButton_Down(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColorP)
	Simple_DrawText('◀', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

function DLib.skin.tex.Scroller.LeftButton_Disabled(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColorD)
	Simple_DrawText('◀', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

--Up
function DLib.skin.tex.Scroller.UpButton_Normal(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColor)
	Simple_DrawText('▲', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

function DLib.skin.tex.Scroller.UpButton_Hover(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColorH)
	Simple_DrawText('▲', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

function DLib.skin.tex.Scroller.UpButton_Down(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColorP)
	Simple_DrawText('▲', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

function DLib.skin.tex.Scroller.UpButton_Disabled(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColorD)
	Simple_DrawText('▲', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

--Down
function DLib.skin.tex.Scroller.DownButton_Normal(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColor)
	Simple_DrawText('▼', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

function DLib.skin.tex.Scroller.DownButton_Hover(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColorH)
	Simple_DrawText('▼', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

function DLib.skin.tex.Scroller.DownButton_Down(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColorP)
	Simple_DrawText('▼', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

function DLib.skin.tex.Scroller.DownButton_Disabled(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColorD)
	Simple_DrawText('▼', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

--Right
function DLib.skin.tex.Scroller.RightButton_Normal(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColor)
	Simple_DrawText('▶', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

function DLib.skin.tex.Scroller.RightButton_Hover(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColorH)
	Simple_DrawText('▶', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

function DLib.skin.tex.Scroller.RightButton_Down(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColorP)
	Simple_DrawText('▶', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

function DLib.skin.tex.Scroller.RightButton_Disabled(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BColorD)
	Simple_DrawText('▶', 'Default', x + 2, y + 1, DLib.skin.tex.Scroller.TextColr)
end

function DLib.skin.tex.Scroller.TrackV(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.BackColor)
end

function DLib.skin.tex.Scroller.ButtonV_Normal(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.ScrollerColI)
end

function DLib.skin.tex.Scroller.ButtonV_Hover(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.ScrollerColH)
end

function DLib.skin.tex.Scroller.ButtonV_Down(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.ScrollerColP)
end

function DLib.skin.tex.Scroller.ButtonV_Disabled(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Scroller.ScrollerColD)
end
