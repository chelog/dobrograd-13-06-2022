
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

local WINDOW_ALPHA = 200
local WINDOW_ALPHA_SOFT = 140

DLib.skin.colours = {}
DLib.skin.colors = DLib.skin.colours
DLib.skin.colours.white = Color(255, 255, 255)
DLib.skin.colours.black = Color(0, 0, 0)
DLib.skin.colours.gray_bright = Color(225, 225, 225)
DLib.skin.colours.gray = Color(200, 200, 200)
DLib.skin.colours.gray_dark = Color(175, 175, 175)
DLib.skin.colours.bg_bright = Color(45, 45, 45, 200)

DLib.skin.colours.ComboBoxNormal = Color(30, 30, 30, 150)
DLib.skin.colours.ComboBoxHover = Color(60, 80, 60, 150)
DLib.skin.colours.ComboBoxDown = Color(80, 120, 80, 150)
DLib.skin.colours.ComboBoxDisabled = Color(0, 0, 0, 130)

DLib.skin.CloseAlpha = 150

DLib.skin.bg_color  = Color(55, 55, 55, WINDOW_ALPHA)
DLib.skin.bg_color_menu  = Color(55, 55, 55, WINDOW_ALPHA_SOFT)
DLib.skin.bg_color_sleep  = Color(70, 70, 70, WINDOW_ALPHA)
DLib.skin.bg_color_dark = Color(0, 0, 0, WINDOW_ALPHA)
DLib.skin.bg_color_bright = Color(220, 220, 220, WINDOW_ALPHA)
DLib.skin.frame_border = Color(50, 50, 50, WINDOW_ALPHA)

DLib.skin.control_color  = Color(120, 120, 120)
DLib.skin.control_color_highlight = Color(150, 150, 150, 255)
DLib.skin.control_color_active  = Color(110, 150, 250, 255)
DLib.skin.control_color_bright  = Color(255, 200, 100, 255)
DLib.skin.control_color_dark  = Color(100, 100, 100, 255)

DLib.skin.bg_alt1  = Color(50, 50, 50, WINDOW_ALPHA)
DLib.skin.bg_alt2  = Color(55, 55, 55, WINDOW_ALPHA)

DLib.skin.listview_hover = Color(70, 70, 70, 255)
DLib.skin.listview_selected = Color(100, 170, 220, 255)

DLib.skin.text_bright = Color(255, 255, 255, 255)
DLib.skin.text_normal = Color(255, 255, 255, 255)
DLib.skin.text_dark = Color(175, 175, 175, 255)
DLib.skin.text_highlight = Color(255, 20, 20, 255)

DLib.skin.combobox_selected = DLib.skin.listview_selected

DLib.skin.panel_transback = Color(255, 255, 255, 50)
DLib.skin.tooltip = Color(255, 245, 175, 255)

DLib.skin.colPropertySheet  = Color(170, 170, 170, 255)
DLib.skin.colTab              = DLib.skin.colPropertySheet
DLib.skin.colTabInactive = Color(140, 140, 140, 255)
DLib.skin.colTabShadow = Color(0, 0, 0, 170)
DLib.skin.colTabText          = Color(255, 255, 255, 255)
DLib.skin.colTabTextInactive = Color(0, 0, 0, 200)

DLib.skin.colCollapsibleCategory = Color(255, 255, 255, 20)

DLib.skin.colCategoryText = Color(255, 255, 255, 255)
DLib.skin.colCategoryTextInactive = Color(200, 200, 200, 255)

DLib.skin.colNumberWangBG = Color(255, 240, 150, 255)
DLib.skin.colTextEntryBG = Color(200, 200, 200, 255)
DLib.skin.colTextEntryBorder = Color(140, 140, 140, 255)
DLib.skin.colTextEntryText = Color(25, 25, 25, 255)
DLib.skin.colTextEntryTextHighlight = Color(255, 255, 255, 255)
DLib.skin.colTextEntryTextCursor = Color(0, 0, 100, 255)

DLib.skin.colTextEntryTextPlaceholder = Color(100, 100, 100)

DLib.skin.colMenuBG = Color(255, 255, 255, 200)
DLib.skin.colMenuBorder = Color(0, 0, 0, 200)

DLib.skin.colButtonText = Color(255, 255, 255, 255)
DLib.skin.colButtonTextDisabled = Color(255, 255, 255, 55)
DLib.skin.colButtonBorder = Color(20, 20, 20, 255)
DLib.skin.colButtonBorderHighlight = Color(255, 255, 255, 50)
DLib.skin.colButtonBorderShadow = Color(0, 0, 0, 100)

DLib.skin.bg_verybright  = Color(80, 80, 80, 200)
DLib.skin.bg_hightlight = Color(40, 80, 40, 200)

DLib.skin.background = DLib.skin.bg_color
DLib.skin.background_inactive  = DLib.skin.bg_color_dark
DLib.skin.frame_top  = Color(90, 90, 90, WINDOW_ALPHA)

DLib.skin.ButtonHoverColor = Color(200, 200, 200, 150)
DLib.skin.ButtonAlpha = 150
DLib.skin.ButtonDefColor = Color(0, 0, 0, 150)
DLib.skin.ButtonDefColor2 = Color(140, 140, 140, 150)

DLib.skin.CheckBoxBG = Color(30, 30, 30)
DLib.skin.CheckBoxBGD = Color(70, 70, 70)

DLib.skin.CheckBoxC = Color(105, 255, 250)
DLib.skin.CheckBoxU = Color(255, 148, 148)

DLib.skin.MenuHoverColor = Color(140, 140, 140)
DLib.skin.MenuSpacer = Color(200, 200, 200)
DLib.skin.MenuSpacerStrip = Color(100, 100, 100, 200)

DLib.skin.colours.TabControl = Color(0, 0, 0, 200)
DLib.skin.CloseHoverCol = Color(200, 130, 130, DLib.skin.CloseAlpha)

DLib.skin.SelectColor = Color(203, 225, 203, 50)

DLib.skin.colours.TabSelected = Color(200, 255, 200, 150)
DLib.skin.colours.TabUnSelected = Color(80, 80, 80, 200)
DLib.skin.colours.TabUnSelected2 = Color(255, 255, 255, 20)

DLib.skin.colours.windowCol = Color(200, 200, 200)

-- sub categories

DLib.skin.tex.CategoryList = {}
DLib.skin.tex.CategoryList.BG = Color(65, 65, 65, 255)
DLib.skin.tex.CategoryList.Headerr = Color(200, 200, 200, 180)

DLib.skin.Colours = {}

DLib.skin.Colours.Window = {}
DLib.skin.Colours.Window.TitleActive = Color(255, 255, 255)
DLib.skin.Colours.Window.TitleInactive = Color(200, 200, 200)

DLib.skin.Colours.Button = {}
DLib.skin.Colours.Button.Normal = Color(200, 200, 200, 225)
DLib.skin.Colours.Button.Disabled = Color(145, 145, 145)
DLib.skin.Colours.Button.Down = Color(255, 255, 255)
DLib.skin.Colours.Button.Hover = Color(225, 225, 225)
DLib.skin.Colours.Button.Menu = Color(255, 255, 255)

DLib.skin.Colours.Tab = {}
DLib.skin.Colours.Tab.Active = {}
DLib.skin.Colours.Tab.Active.Normal = Color(120, 120, 120)
DLib.skin.Colours.Tab.Active.Hover = Color(0, 120, 0)
DLib.skin.Colours.Tab.Active.Down = Color(0, 140, 0)
DLib.skin.Colours.Tab.Active.Disabled = Color(170, 150, 170)

DLib.skin.Colours.Tab.Inactive = {}
DLib.skin.Colours.Tab.Inactive.Normal = Color(200, 200, 200)
DLib.skin.Colours.Tab.Inactive.Hover = Color(200, 225, 200)
DLib.skin.Colours.Tab.Inactive.Down = Color(200, 255, 200)
DLib.skin.Colours.Tab.Inactive.Disabled = Color(170, 170, 170)

DLib.skin.Colours.Label = {}
DLib.skin.Colours.Label.Default = Color(255, 255, 255)
DLib.skin.Colours.Label.Bright = Color(255, 255, 255)
DLib.skin.Colours.Label.Dark = Color(225, 225, 225)
DLib.skin.Colours.Label.Highlight = Color(200, 255, 200)

DLib.skin.Colours.Tree = {}
DLib.skin.Colours.Tree.Lines = Color(255, 255, 255) ---- !!!
DLib.skin.Colours.Tree.Normal = Color(200, 200, 200)
DLib.skin.Colours.Tree.Hover = Color(200, 255, 200)
DLib.skin.Colours.Tree.Selected = Color(255, 255, 255)

DLib.skin.Colours.Properties = {}
DLib.skin.Colours.Properties.Line_Normal = GWEN.TextureColor(4 + 8 * 12, 508)
DLib.skin.Colours.Properties.Line_Selected = GWEN.TextureColor(4 + 8 * 13, 508)
DLib.skin.Colours.Properties.Line_Hover = GWEN.TextureColor(4 + 8 * 12, 500)
DLib.skin.Colours.Properties.Title = Color(255, 255, 255)
DLib.skin.Colours.Properties.Column_Normal = GWEN.TextureColor(4 + 8 * 14, 508)
DLib.skin.Colours.Properties.Column_Selected = GWEN.TextureColor(4 + 8 * 15, 508)
DLib.skin.Colours.Properties.Column_Hover = GWEN.TextureColor(4 + 8 * 14, 500)
DLib.skin.Colours.Properties.Border = GWEN.TextureColor(4 + 8 * 15, 500)
DLib.skin.Colours.Properties.Label_Normal = Color(200, 200, 200)
DLib.skin.Colours.Properties.Label_Selected = Color(255, 255, 255)
DLib.skin.Colours.Properties.Label_Hover = Color(200, 255, 200)

DLib.skin.Colours.Category = {}
DLib.skin.Colours.Category.Line = {}
DLib.skin.Colours.Category.LineAlt = {}

DLib.skin.Colours.Category.Line.Text = Color(200, 200, 200)
DLib.skin.Colours.Category.Line.Text_Hover = Color(200, 255, 200)
DLib.skin.Colours.Category.Line.Text_Selected = Color(255, 255, 255)
DLib.skin.Colours.Category.Line.Button = DLib.skin.background
DLib.skin.Colours.Category.Line.Button_Hover = Color(100, 100, 100)
DLib.skin.Colours.Category.Line.Button_Selected = Color(130, 130, 130)

DLib.skin.Colours.Category.LineAlt.Text = Color(200, 200, 200)
DLib.skin.Colours.Category.LineAlt.Text_Hover = Color(200, 255, 200)
DLib.skin.Colours.Category.LineAlt.Text_Selected = Color(255, 255, 255)
DLib.skin.Colours.Category.LineAlt.Button = DLib.skin.background
DLib.skin.Colours.Category.LineAlt.Button_Hover = Color(100, 100, 100)
DLib.skin.Colours.Category.LineAlt.Button_Selected = Color(130, 130, 130)

DLib.skin.Colours.Category.Header = Color(255, 255, 255)
DLib.skin.Colours.Category.Header_Closed = Color(0, 0, 0)
DLib.skin.Colours.TooltipText = Color(255, 255, 255)

DLib.skin.tex.Input.ListBox.BG = Color(0, 0, 0, 200)
DLib.skin.tex.Input.ListBox.First = Color(100, 100, 100)
DLib.skin.tex.Input.ListBox.Second = Color(125, 125, 125)
DLib.skin.tex.Input.ListBox.Select = Color(75, 125, 75)

DLib.skin.tex.Scroller.BackColor = Color(0, 0, 0, 50)
DLib.skin.tex.Scroller.ScrollerColI = Color(200, 200, 200, 255)
DLib.skin.tex.Scroller.ScrollerColD = Color(140, 140, 140, 255)
DLib.skin.tex.Scroller.ScrollerColH = Color(255, 255, 255, 255)
DLib.skin.tex.Scroller.ScrollerColP = Color(200, 255, 200, 255)
DLib.skin.tex.Scroller.BColor = Color(130, 130, 130, 200)
DLib.skin.tex.Scroller.BColorH = Color(160, 160, 160, 200)
DLib.skin.tex.Scroller.BColorP = Color(200, 200, 200, 200)
DLib.skin.tex.Scroller.BColorD = Color(30, 30, 30, 200)
DLib.skin.tex.Scroller.TextColr = Color(255, 255, 255)
