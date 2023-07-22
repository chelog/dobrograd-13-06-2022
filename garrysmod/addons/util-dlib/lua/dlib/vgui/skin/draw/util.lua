
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

function DLib.skin.tex.CategoryList.Outer(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.CategoryList.BG)
end

function DLib.skin.tex.CategoryList.Inner(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.CategoryList.BG)
end

function DLib.skin.tex.CategoryList.Header(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.CategoryList.Headerr)
end

function DLib.skin.tex.Tooltip(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.background)
end

function DLib.skin.tex.ProgressBar.Back(x, y, w, h)
	Simple_DrawBox(x, y, w, h, Color(90, 90, 90))
end

function DLib.skin.tex.ProgressBar.Front(x, y, w, h)
	Simple_DrawBox(x + 2, y + 2, w - 4, h - 4, Color(160, 200, 130))
end
