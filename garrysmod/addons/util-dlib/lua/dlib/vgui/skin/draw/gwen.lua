
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

DLib.skin.tex.Shadow = GWEN.CreateTextureBorder(448, 0, 31, 31, 8, 8, 8, 8)
DLib.skin.tex.TreePlus = GWEN.CreateTextureNormal(448, 96, 15, 15)
DLib.skin.tex.TreeMinus = GWEN.CreateTextureNormal(464, 96, 15, 15)
DLib.skin.tex.TextBox = GWEN.CreateTextureBorder(0, 150, 127, 21, 4, 4, 4, 4)
DLib.skin.tex.TextBox_Focus = GWEN.CreateTextureBorder(0, 172, 127, 21, 4, 4, 4, 4)
DLib.skin.tex.TextBox_Disabled = GWEN.CreateTextureBorder(0, 194, 127, 21, 4, 4, 4, 4)
DLib.skin.tex.Menu_Check = GWEN.CreateTextureNormal(448, 112, 15, 15)

DLib.skin.tex.TabL_Active = GWEN.CreateTextureBorder(64, 384, 31, 63, 8, 8, 8, 8)
DLib.skin.tex.TabL_Inactive = GWEN.CreateTextureBorder(64 + 128, 384, 31, 63, 8, 8, 8, 8)
DLib.skin.tex.TabR_Active = GWEN.CreateTextureBorder(96, 384, 31, 63, 8, 8, 8, 8)
DLib.skin.tex.TabR_Inactive = GWEN.CreateTextureBorder(96 + 128, 384, 31, 63, 8, 8, 8, 8)
DLib.skin.tex.Tab_Bar = GWEN.CreateTextureBorder(128, 352, 127, 31, 4, 4, 4, 4)

DLib.skin.tex.Input.ComboBox.Button.Normal = GWEN.CreateTextureNormal(496, 272, 15, 15)
DLib.skin.tex.Input.ComboBox.Button.Hover = GWEN.CreateTextureNormal(496, 272 + 16, 15, 15)
DLib.skin.tex.Input.ComboBox.Button.Down = GWEN.CreateTextureNormal(496, 272 + 32, 15, 15)
DLib.skin.tex.Input.ComboBox.Button.Disabled = GWEN.CreateTextureNormal(496, 272 + 48, 15, 15)

DLib.skin.tex.Input.UpDown.Down.Normal = GWEN.CreateTextureCentered(384, 120, 7, 7)
DLib.skin.tex.Input.UpDown.Down.Hover = GWEN.CreateTextureCentered(384 + 8, 120, 7, 7)
DLib.skin.tex.Input.UpDown.Down.Down = GWEN.CreateTextureCentered(384 + 16, 120, 7, 7)
DLib.skin.tex.Input.UpDown.Down.Disabled = GWEN.CreateTextureCentered(384 + 24, 120, 7, 7)

DLib.skin.tex.Input.Slider.H.Normal = GWEN.CreateTextureNormal(416, 32, 15, 15)
DLib.skin.tex.Input.Slider.H.Hover = GWEN.CreateTextureNormal(416, 32 + 16, 15, 15)
DLib.skin.tex.Input.Slider.H.Down = GWEN.CreateTextureNormal(416, 32 + 32, 15, 15)
DLib.skin.tex.Input.Slider.H.Disabled = GWEN.CreateTextureNormal(416, 32 + 48, 15, 15)

DLib.skin.tex.Input.Slider.V.Normal = GWEN.CreateTextureNormal(416 + 16, 32, 15, 15)
DLib.skin.tex.Input.Slider.V.Hover = GWEN.CreateTextureNormal(416 + 16, 32 + 16, 15, 15)
DLib.skin.tex.Input.Slider.V.Down = GWEN.CreateTextureNormal(416 + 16, 32 + 32, 15, 15)
DLib.skin.tex.Input.Slider.V.Disabled = GWEN.CreateTextureNormal(416 + 16, 32 + 48, 15, 15)

DLib.skin.tex.Input.UpDown.Up.Normal = GWEN.CreateTextureCentered(384, 112, 7, 7)
DLib.skin.tex.Input.UpDown.Up.Hover = GWEN.CreateTextureCentered(384 + 8, 112, 7, 7)
DLib.skin.tex.Input.UpDown.Up.Down = GWEN.CreateTextureCentered(384 + 16, 112, 7, 7)
DLib.skin.tex.Input.UpDown.Up.Disabled = GWEN.CreateTextureCentered(384 + 24, 112, 7, 7)

DLib.skin.tex.Menu.RightArrow = GWEN.CreateTextureNormal(464, 112, 15, 15)

DLib.skin.tex.Scroller.TrackH = GWEN.CreateTextureBorder(384, 128, 127, 15, 4, 4, 4, 4)
DLib.skin.tex.Scroller.ButtonH_Normal = GWEN.CreateTextureBorder(384, 128 + 16, 127, 15, 4, 4, 4, 4)
DLib.skin.tex.Scroller.ButtonH_Hover = GWEN.CreateTextureBorder(384, 128 + 32, 127, 15, 4, 4, 4, 4)
DLib.skin.tex.Scroller.ButtonH_Down = GWEN.CreateTextureBorder(384, 128 + 48, 127, 15, 4, 4, 4, 4)
DLib.skin.tex.Scroller.ButtonH_Disabled = GWEN.CreateTextureBorder(384, 128 + 64, 127, 15, 4, 4, 4, 4)
