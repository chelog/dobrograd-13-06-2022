
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

function DLib.skin.tex.Tree(x, y, w, h, self)
	Simple_DrawBox(x, y, w, h, DLib.skin.bg_color)
end

function DLib.skin.tex.Input.ListBox.Background(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Input.ListBox.BG)
end

function DLib.skin.tex.Input.ListBox.Hovered(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Input.ListBox.BG)
end

function DLib.skin.tex.Input.ListBox.EvenLine(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Input.ListBox.First)
end

function DLib.skin.tex.Input.ListBox.OddLine(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Input.ListBox.Second)
end

function DLib.skin.tex.Input.ListBox.EvenLineSelected(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Input.ListBox.Select)
end

function DLib.skin.tex.Input.ListBox.OddLineSelected(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.tex.Input.ListBox.Select)
end

function DLib.skin.tex.Input.ComboBox.Normal(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.colours.ComboBoxNormal)
end

function DLib.skin.tex.Input.ComboBox.Hover(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.colours.ComboBoxHover)
end

function DLib.skin.tex.Input.ComboBox.Down(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.colours.ComboBoxDown)
end

function DLib.skin.tex.Input.ComboBox.Disabled(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.colours.ComboBoxDisabled)
end