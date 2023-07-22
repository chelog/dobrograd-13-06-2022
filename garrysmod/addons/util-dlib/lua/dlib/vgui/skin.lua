
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


_G.SKIN = {}
DLib.skin = SKIN

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

local nomat = surface.GetTextureID('gui/corner8')

DLib.skin.ENABLE_BLUR = CreateConVar('dlib_vguiblur', '1', {FCVAR_ARCHIVE}, 'Enable VGUI elements background blur')

function DLib.skin.Simple_DrawBox(x, y, w, h, color)
	if color then
		surface_SetDrawColor(color)
	end

	surface_SetTexture(nomat)
	surface_DrawRect(x, y, w, h)
end

function DLib.skin.Simple_DrawText(text, font, x, y, col, center)
	if font then
		surface_SetFont(font)
	end

	if center then
		x = x - surface_GetTextSize(text) / 2
	end

	if col then
		surface_SetTextColor(col.r, col.g, col.b, col.a)
	end

	surface_SetTextPos(x, y)
	surface_DrawText(text)
end

local Simple_DrawBox = DLib.skin.Simple_DrawBox
local Simple_DrawText = DLib.skin.Simple_DrawText

surface.CreateFont('DLib.SkinRoboto', {
	font = 'Roboto',
	size = 18,
	weight = 500,
	extended = true,
})

surface.CreateFont('DLib.SkinPT', {
	font = 'PT Sans',
	size = 20,
	weight = 500,
	extended = true,
})

DLib.skin.PrintName  = 'DLib FlatBlack skin utilizing Lua draw functions'
DLib.skin.Author  = 'DBot'
DLib.skin.DermaVersion = 1
DLib.skin.GwenTexture = Material('gwenskin/GModDefault.png')
DLib.skin.fontFrame = 'DLib.SkinPT'
DLib.skin.texGradientUp = Material('gui/gradient_up')
DLib.skin.texGradientDown = Material('gui/gradient_down')
DLib.skin.fontTab = 'DLib.SkinPT'
DLib.skin.fontCategoryHeader = 'TabLarge'

DLib.skin.tex = {}
DLib.skin.tex.Panels = {}
DLib.skin.tex.Window = {}
DLib.skin.tex.Scroller = {}
DLib.skin.tex.Menu = {}
DLib.skin.tex.Input = {}
DLib.skin.tex.Input.ComboBox = {}
DLib.skin.tex.Input.ComboBox.Button = {}
DLib.skin.tex.Input.UpDown = {}
DLib.skin.tex.Input.UpDown.Up = {}
DLib.skin.tex.Input.UpDown.Down = {}
DLib.skin.tex.Input.Slider = {}
DLib.skin.tex.Input.Slider.H = {}
DLib.skin.tex.Input.Slider.V = {}
DLib.skin.tex.Input.ListBox = {}
DLib.skin.tex.ProgressBar = {}

function DLib.skin.tex.Panels.Normal(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.colours.bg_bright)
end

function DLib.skin.tex.Panels.Bright(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.bg_verybright)
end

function DLib.skin.tex.Panels.Dark(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.background)
end

function DLib.skin.tex.Panels.Highlight(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.bg_hightlight)
end

function DLib.skin.tex.Selection(x, y, w, h)
	Simple_DrawBox(x, y, w, h, DLib.skin.SelectColor)
end

DLib.Loader.loadPureCS('dlib/vgui/skin')

derma.DefineSkin('DLib_Black', 'Made to look like flat VGUI', SKIN)
derma.RefreshSkins()
