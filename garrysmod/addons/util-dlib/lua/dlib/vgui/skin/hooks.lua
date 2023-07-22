
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

--[[---------------------------------------------------------
	ExpandButton
-----------------------------------------------------------]]
function DLib.skin:PaintExpandButton(panel, w, h)

	if not panel:GetExpanded() then
		self.tex.TreePlus(0, 0, w, h)
	else
		self.tex.TreeMinus(0, 0, w, h)
	end

end

local DefaultSkin

local function access(key)
	if DefaultSkin ~= nil then
		return DefaultSkin[key]
	end

	DefaultSkin = derma.GetSkinTable().Default
	return DefaultSkin[key]
end

--[[---------------------------------------------------------
	TextEntry
-----------------------------------------------------------]]
function DLib.skin:PaintTextEntry(panel, w, h)
	-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/skins/default.lua#L442
	-- this is stupid
	local super = access('PaintTextEntry')

	if super then
		return super(self, panel, w, h)
	else
		if panel.m_bBackground then
			if panel:GetDisabled() then
				self.tex.TextBox_Disabled(0, 0, w, h)
			elseif panel:HasFocus() then
				self.tex.TextBox_Focus(0, 0, w, h)
			else
				self.tex.TextBox(0, 0, w, h)
			end
		end

		panel:DrawTextEntryText(panel:GetTextColor(), panel:GetHighlightColor(), panel:GetCursorColor())
	end
end

function DLib.skin:SchemeTextEntry(panel) ---------------------- TODO
	if access('PaintTextEntry') then return end
	panel:SetTextColor(self.colTextEntryText)
	panel:SetHighlightColor(self.colTextEntryTextHighlight)
	panel:SetCursorColor(self.colTextEntryTextCursor)
end

--[[---------------------------------------------------------
	Menu
-----------------------------------------------------------]]
function DLib.skin:PaintMenuSpacer(panel, w, h)
	self.tex.MenuBG(0, 0, w, h)
end

--[[---------------------------------------------------------
	MenuOption
-----------------------------------------------------------]]
function DLib.skin:PaintMenuOption(panel, w, h)
	if panel.m_bBackground and (panel.Hovered or panel.Highlight) then
		self.tex.MenuBG_Hover(0, 0, w, h)
	end

	if panel:GetChecked() then
		self.tex.Menu_Check(5, h/2-7, 15, 15)
	end
end

--[[---------------------------------------------------------
	MenuRightArrow
-----------------------------------------------------------]]
function DLib.skin:PaintMenuRightArrow(panel, w, h)

	self.tex.Menu.RightArrow(0, 0, w, h)

end

--[[---------------------------------------------------------
	PropertySheet
-----------------------------------------------------------]]
function DLib.skin:PaintPropertySheet(panel, w, h)

	-- TODO: Tabs at bottom, left, right
	local ActiveTab = panel:GetActiveTab()
	local Offset = 0
	if ActiveTab then Offset = ActiveTab:GetTall()-8 end

	if self.ENABLE_BLUR:GetBool() then
		DLib.blur.RefreshNow(true)
		DLib.blur.DrawOffset(0, Offset, w, h, panel:LocalToScreen(0, Offset))
	end

	self.tex.Tab_Control(0, Offset, w, h-Offset)
end

--[[---------------------------------------------------------
	Tab
-----------------------------------------------------------]]
function DLib.skin:PaintTab(panel, w, h)
	if panel:GetPropertySheet():GetActiveTab() == panel then
		return self:PaintActiveTab(panel, w, h)
	end

	--DLib.blur.DrawPanel(w, h, panel:LocalToScreen(0, 0))
	self.tex.TabT_Inactive(0, 0, w, h)
end

function DLib.skin:PaintActiveTab(panel, w, h)
	--DLib.blur.DrawPanel(w, h, panel:LocalToScreen(0, 0))
	self.tex.TabT_Active(0, 0, w, h)
end

--[[---------------------------------------------------------
	Button
-----------------------------------------------------------]]
function DLib.skin:PaintWindowCloseButton(panel, w, h)
	if not panel.m_bBackground then return end

	if panel:GetDisabled() then
		return self.tex.Window.Close(0, 0, w, h, Color(255, 255, 255, 50))
	end

	if panel.Depressed or panel:IsSelected() then
		return self.tex.Window.Close_Down(0, 0, w, h)
	end

	if panel.Hovered then
		return self.tex.Window.Close_Hover(0, 0, w, h)
	end

	self.tex.Window.Close(0, 0, w, h)
end

function DLib.skin:PaintWindowMinimizeButton(panel, w, h)
	if not panel.m_bBackground then return end

	if panel:GetDisabled() then
		return self.tex.Window.Mini(0, 0, w, h, Color(255, 255, 255, 50))
	end

	if panel.Depressed or panel:IsSelected() then
		return self.tex.Window.Mini_Down(0, 0, w, h)
	end

	if panel.Hovered then
		return self.tex.Window.Mini_Hover(0, 0, w, h)
	end

	self.tex.Window.Mini(0, 0, w, h)
end

function DLib.skin:PaintWindowMaximizeButton(panel, w, h)
	if not panel.m_bBackground then return end

	if panel:GetDisabled() then
		return self.tex.Window.Maxi(0, 0, w, h, Color(255, 255, 255, 50))
	end

	if panel.Depressed or panel:IsSelected() then
		return self.tex.Window.Maxi_Down(0, 0, w, h)
	end

	if panel.Hovered then
		return self.tex.Window.Maxi_Hover(0, 0, w, h)
	end

	self.tex.Window.Maxi(0, 0, w, h)
end

--[[---------------------------------------------------------
	VScrollBar
-----------------------------------------------------------]]
function DLib.skin:PaintVScrollBar(panel, w, h)
	self.tex.Scroller.TrackV(0, 0, w, h)
end

--[[---------------------------------------------------------
	ScrollBarGrip
-----------------------------------------------------------]]
function DLib.skin:PaintScrollBarGrip(panel, w, h)
	if panel:GetDisabled() then
		return self.tex.Scroller.ButtonV_Disabled(0, 0, w, h)
	end

	if panel.Depressed then
		return self.tex.Scroller.ButtonV_Down(0, 0, w, h)
	end

	if panel.Hovered then
		return self.tex.Scroller.ButtonV_Hover(0, 0, w, h)
	end

	return self.tex.Scroller.ButtonV_Normal(0, 0, w, h)
end

--[[---------------------------------------------------------
	ButtonDown
-----------------------------------------------------------]]
function DLib.skin:PaintButtonDown(panel, w, h)
	if not panel.m_bBackground then return end

	if panel.Depressed or panel:IsSelected() then
		return self.tex.Scroller.DownButton_Down(0, 0, w, h)
	end

	if panel:GetDisabled() then
		return self.tex.Scroller.DownButton_Dead(0, 0, w, h)
	end

	if panel.Hovered then
		return self.tex.Scroller.DownButton_Hover(0, 0, w, h)
	end

	self.tex.Scroller.DownButton_Normal(0, 0, w, h)
end

--[[---------------------------------------------------------
	ButtonUp
-----------------------------------------------------------]]
function DLib.skin:PaintButtonUp(panel, w, h)
	if not panel.m_bBackground then return end

	if panel.Depressed or panel:IsSelected() then
		return self.tex.Scroller.UpButton_Down(0, 0, w, h)
	end

	if panel:GetDisabled() then
		return self.tex.Scroller.UpButton_Dead(0, 0, w, h)
	end

	if panel.Hovered then
		return self.tex.Scroller.UpButton_Hover(0, 0, w, h)
	end

	self.tex.Scroller.UpButton_Normal(0, 0, w, h)
end

--[[---------------------------------------------------------
	ButtonLeft
-----------------------------------------------------------]]
function DLib.skin:PaintButtonLeft(panel, w, h)
	if not panel.m_bBackground then return end

	if panel.Depressed or panel:IsSelected() then
		return self.tex.Scroller.LeftButton_Down(0, 0, w, h)
	end

	if panel:GetDisabled() then
		return self.tex.Scroller.LeftButton_Dead(0, 0, w, h)
	end

	if panel.Hovered then
		return self.tex.Scroller.LeftButton_Hover(0, 0, w, h)
	end

	self.tex.Scroller.LeftButton_Normal(0, 0, w, h)
end

--[[---------------------------------------------------------
	ButtonRight
-----------------------------------------------------------]]
function DLib.skin:PaintButtonRight(panel, w, h)

	if not panel.m_bBackground then return end

	if panel.Depressed or panel:IsSelected() then
		return self.tex.Scroller.RightButton_Down(0, 0, w, h)
	end

	if panel:GetDisabled() then
		return self.tex.Scroller.RightButton_Dead(0, 0, w, h)
	end

	if panel.Hovered then
		return self.tex.Scroller.RightButton_Hover(0, 0, w, h)
	end

	self.tex.Scroller.RightButton_Normal(0, 0, w, h)

end

--[[---------------------------------------------------------
	ComboDownArrow
-----------------------------------------------------------]]
function DLib.skin:PaintComboDownArrow(panel, w, h)
	if panel.ComboBox:GetDisabled() then
		return self.tex.Input.ComboBox.Button.Disabled(0, 0, w, h)
	end

	if panel.ComboBox.Depressed or panel.ComboBox:IsMenuOpen() then
		return self.tex.Input.ComboBox.Button.Down(0, 0, w, h)
	end

	if panel.ComboBox.Hovered then
		return self.tex.Input.ComboBox.Button.Hover(0, 0, w, h)
	end

	self.tex.Input.ComboBox.Button.Normal(0, 0, w, h)
end

--[[---------------------------------------------------------
	ComboBox
-----------------------------------------------------------]]
function DLib.skin:PaintComboBox(panel, w, h)
	if panel:GetDisabled() then
		return self.tex.Input.ComboBox.Disabled(0, 0, w, h)
	end

	if panel.Depressed or panel:IsMenuOpen() then
		return self.tex.Input.ComboBox.Down(0, 0, w, h)
	end

	if panel.Hovered then
		return self.tex.Input.ComboBox.Hover(0, 0, w, h)
	end

	self.tex.Input.ComboBox.Normal(0, 0, w, h)
end

--[[---------------------------------------------------------
	ComboBox
-----------------------------------------------------------]]
function DLib.skin:PaintListBox(panel, w, h)

	self.tex.Input.ListBox.Background(0, 0, w, h)

end

--[[---------------------------------------------------------
	NumberUp
-----------------------------------------------------------]]
function DLib.skin:PaintNumberUp(panel, w, h)
	if panel:GetDisabled() then
		return self.Input.UpDown.Up.Disabled(0, 0, w, h)
	end

	if panel.Depressed then
		return self.tex.Input.UpDown.Up.Down(0, 0, w, h)
	end

	if panel.Hovered then
		return self.tex.Input.UpDown.Up.Hover(0, 0, w, h)
	end

	self.tex.Input.UpDown.Up.Normal(0, 0, w, h)
end

--[[---------------------------------------------------------
	NumberDown
-----------------------------------------------------------]]
function DLib.skin:PaintNumberDown(panel, w, h)
	if panel:GetDisabled() then
		return self.tex.Input.UpDown.Down.Disabled(0, 0, w, h)
	end

	if panel.Depressed then
		return self.tex.Input.UpDown.Down.Down(0, 0, w, h)
	end

	if panel.Hovered then
		return self.tex.Input.UpDown.Down.Hover(0, 0, w, h)
	end

	self.tex.Input.UpDown.Down.Normal(0, 0, w, h)
end

function DLib.skin:PaintTreeNode(panel, w, h)
	if not panel.m_bDrawLines then return end

	surface_SetDrawColor(self.Colours.Tree.Lines)

	if panel.m_bLastChild then
		surface_DrawRect(9, 0, 1, 7)
		surface_DrawRect(9, 7, 9, 1)
	else
		surface_DrawRect(9, 0, 1, h)
		surface_DrawRect(9, 7, 9, 1)
	end
end

function DLib.skin:PaintTreeNodeButton(panel, w, h)
	if not panel.m_bSelected then return end

	-- Don't worry this isn't working out the size every render
	-- it just gets the cached value from inside the Label
	local w, _ = panel:GetTextSize()

	self.tex.Selection(38, 0, w + 6, h)
end

function DLib.skin:PaintSelection(panel, w, h)
	self.tex.Selection(0, 0, w, h)
end

function DLib.skin:PaintSliderKnob(panel, w, h)
	if panel:GetDisabled()  then    return self.tex.Input.Slider.H.Disabled(0, 0, w, h) end

	if panel.Depressed then
		return self.tex.Input.Slider.H.Down(0, 0, w, h)
	end

	if panel.Hovered then
		return self.tex.Input.Slider.H.Hover(0, 0, w, h)
	end

	self.tex.Input.Slider.H.Normal(0, 0, w, h)
end

local function PaintNotches(x, y, w, h, num)
	if not num then return end

	local space = w / num
	for i=0, num do
		surface_DrawRect(x + i * space, y + 4, 1,  5)
	end
end

function DLib.skin:PaintNumSlider(panel, w, h)
	surface_SetDrawColor(Color(0, 0, 0, 100))
	surface_DrawRect(8, h / 2 - 1, w - 15, 1)

	PaintNotches(8, h / 2 - 1, w - 16, 1, panel.m_iNotches)
end

function DLib.skin:PaintProgress(panel, w, h)
	self.tex.ProgressBar.Back(0, 0, w, h)
	self.tex.ProgressBar.Front(0, 0, w * panel:GetFraction(), h)
end

function DLib.skin:PaintCollapsibleCategory(panel, w, h)
	if not panel:GetExpanded() and h < 40 then
		return self.tex.CategoryList.Header(0, 0, w, h)
	end

	self.tex.CategoryList.Inner(0, 0, w, h)
end

function DLib.skin:PaintCategoryList(panel, w, h)
	self.tex.CategoryList.Outer(0, 0, w, h)
end

function DLib.skin:PaintCategoryButton(panel, w, h)
	if panel.AltLine then
		if panel.Depressed or panel.m_bSelected then
			surface_SetDrawColor(self.Colours.Category.LineAlt.Button_Selected)
		elseif panel.Hovered then
			surface_SetDrawColor(self.Colours.Category.LineAlt.Button_Hover)
		else
			surface_SetDrawColor(self.Colours.Category.LineAlt.Button)
		end
	else
		if panel.Depressed or panel.m_bSelected then
			surface_SetDrawColor(self.Colours.Category.Line.Button_Selected)
		elseif panel.Hovered then
			surface_SetDrawColor(self.Colours.Category.Line.Button_Hover)
		else
			surface_SetDrawColor(self.Colours.Category.Line.Button)
		end
	end

	surface_DrawRect(0, 0, w, h)
end

function DLib.skin:PaintListViewLine(panel, w, h)
	if panel:IsSelected() then
		self.tex.Input.ListBox.EvenLineSelected(0, 0, w, h)
	elseif panel.Hovered then
		self.tex.Input.ListBox.Hovered(0, 0, w, h)
	elseif panel.m_bAlt then
		self.tex.Input.ListBox.EvenLine(0, 0, w, h)
	end
end

function DLib.skin:PaintListView(panel, w, h)
	self.tex.Input.ListBox.Background(0, 0, w, h)
end

function DLib.skin:PaintTooltip(panel, w, h)
	self.tex.Tooltip(0, 0, w, h)
end

function DLib.skin:PaintMenuBar(panel, w, h)
	local Childs = panel:GetChildren()

	for k, v in pairs(Childs) do
		if panel.SetTextColor and not panel.FixFuckingTextColor then
			panel.FixFuckingTextColor = true
			panel:SetTextColor(DLib.skin.Colours.Button.Menu)
		end
	end

	self.tex.Menu_Strip(0, 0, w, h)
end

-- END DEFAULT

function DLib.skin:PaintMenuOption(panel, w, h)
	if panel.m_bBackground and (panel.Hovered or panel.Highlight) then
		self.tex.MenuBG_Hover(0, 0, w, h)
	end

	if panel:GetChecked() then
		self.tex.Menu_Check(5, h/2-7, 15, 15)
	end
end

function DLib.skin:PaintMenu(panel, w, h)
	if self.ENABLE_BLUR:GetBool() then
		DLib.blur.RefreshNow(true)
		DLib.blur.DrawPanel(w, h, panel:LocalToScreen(0, 0))
	end

	if panel:GetDrawColumn() then
		self.tex.MenuBG_Column(0, 0, w, h)
	else
		self.tex.MenuBG(0, 0, w, h)
	end

	local Canvas = panel:GetCanvas()

	if IsValid(Canvas) then
		for k, v in pairs(Canvas:GetChildren()) do
			if v.SetTextColor and not v.FIX_FUCKING_COLOR then
				v:SetTextColor(DLib.skin.text_normal)
				v.FIX_FUCKING_COLOR = true
			end
		end
	end
end

function DLib.skin:PaintTree(panel, w, h)
	if not panel.m_bBackground then return end
	self.tex.Tree(0, 0, w, h, panel.m_bgColor, panel)
end

function DLib.skin:PaintCheckBox(panel, w, h)
	if panel:GetChecked() then
		if panel:GetDisabled() then
			self.tex.CheckboxD_Checked(0, 0, w, h)
		else
			self.tex.Checkbox_Checked(0, 0, w, h)
		end
	else
		if panel:GetDisabled() then
			self.tex.CheckboxD(0, 0, w, h)
		else
			self.tex.Checkbox(0, 0, w, h)
		end
	end
end

function DLib.skin:PaintButton(panel, w, h)
	if panel:GetIsMenu() then
		if not panel.FixFuckingTextColor then
			panel.FixFuckingTextColor = true
			panel:SetTextColor(DLib.skin.Colours.Button.Menu)
		end
	end

	if not panel.m_bBackground then return end

	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		return self.tex.Button_Down(0, 0, w, h, panel)
	end

	if panel:GetDisabled() then
		return self.tex.Button_Dead(0, 0, w, h, panel)
	end

	if panel.Hovered then
		return self.tex.Button_Hovered(0, 0, w, h, panel)
	end

	self.tex.Button(0, 0, w, h, panel)
end

function DLib.skin:PaintWindowCloseButton(panel, w, h)
	if not panel.m_bBackground then return end

	if panel:GetDisabled() then
		return self.tex.Window.Close(0, 0, w, h, panel)
	end

	if panel.Depressed or panel:IsSelected() then
		return self.tex.Window.Close_Down(0, 0, w, h, panel)
	end

	if panel.Hovered then
		return self.tex.Window.Close_Hover(0, 0, w, h, panel)
	end

	self.tex.Window.Close(0, 0, w, h, panel)
end

function DLib.skin:PaintWindowMinimizeButton(panel, w, h)
	if not panel.m_bBackground then return end

	if panel:GetDisabled() then
		return self.tex.Window.Mini(0, 0, w, h, panel)
	end

	if panel.Depressed or panel:IsSelected() then
		return self.tex.Window.Mini_Down(0, 0, w, h, panel)
	end

	if panel.Hovered then
		return self.tex.Window.Mini_Hover(0, 0, w, h, panel)
	end

	self.tex.Window.Mini(0, 0, w, h, panel)
end

function DLib.skin:PaintWindowMaximizeButton(panel, w, h)
	if not panel.m_bBackground then return end

	if panel:GetDisabled() then
		return self.tex.Window.Maxi(0, 0, w, h, panel)
	end

	if panel.Depressed or panel:IsSelected() then
		return self.tex.Window.Maxi_Down(0, 0, w, h, panel)
	end

	if panel.Hovered then
		return self.tex.Window.Maxi_Hover(0, 0, w, h, panel)
	end

	self.tex.Window.Maxi(0, 0, w, h, panel)
end

--[[---------------------------------------------------------
	Frame
-----------------------------------------------------------]]
function DLib.skin:PaintFrame(panel, w, h)
	if panel.m_bPaintShadow then
		DisableClipping(true)
		SKIN.tex.Shadow(-4, -4, w + 10, h + 10)
		DisableClipping(false)
	end

	if self.ENABLE_BLUR:GetBool() then
		DLib.blur.RefreshNow(true)
		DLib.blur.DrawPanel(w, h, panel:LocalToScreen(0, 0))
	end

	if panel:HasHierarchicalFocus() then
		self.tex.Window.Normal(0, 0, w, h)
	else
		self.tex.Window.Inactive(0, 0, w, h)
	end
end
