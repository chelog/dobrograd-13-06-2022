
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


local surface = surface
local gui = gui
local vgui = vgui
local input = input

--[[
	@doc
	@panel DLib_ResizeTap

	@internal

	@desc
	internally used by !p:DLib_Window
	can be actually put on any panel. just set DLib_ResizeTap's property `.target` to required panel.
	@enddesc
]]
local PANEL = {}

function PANEL:Init()
	self.tapped = false
	self.target = NULL
	self.effects = true
	self.tapX, self.tapY = 0, 0
	self.oldW, self.oldH = 0, 0
	self.minW, self.minH = 100, 30
	self.currX, self.currY = 0, 0
	self.translucent = 0
	self:SetCursor('sizenwse')

	hook.Add('PostRenderVGUI', self, self.PostRenderVGUI)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(140, 140, 140, 150)
	surface.DrawRect(0, 0, w, h)
end

function PANEL:SetTarget(targetPanel)
	self.target = targetPanel
	return self
end

function PANEL:PostRenderVGUI()
	if not self.tapped and not self.fadeout then return end
	surface.SetDrawColor(self.translucent * 2.5, self.translucent * 2.5, self.translucent * 2.5, self.translucent)
	surface.DrawRect(self.currX, self.currY, self:GetNewDimensions())
end

function PANEL:OnMousePressed(key)
	if key ~= MOUSE_LEFT then return end
	self.tapped = true
	self.tapX, self.tapY = gui.MousePos()
	self.oldW, self.oldH = self.target:GetSize()
	self.translucent = 0
	self.currX, self.currY = self.target:GetPos()
end

function PANEL:Think()
	if self.tapped then
		if not input.IsMouseDown(MOUSE_LEFT) then
			self:OnMouseReleased(MOUSE_LEFT)
			return
		end

		self.translucent = Lerp(FrameTime() * 5, self.translucent, 100)
	end

	if self.fadeout then
		self.translucent = Lerp(FrameTime() * 8, self.translucent, 0)
		self.fadeout = self.translucent > 1
	end
end

function PANEL:GetNewDimensions()
	local x, y = gui.MousePos()
	local diffX, diffY = x - self.tapX, y - self.tapY
	return math.max(self.oldW + diffX, self.minW), math.max(self.oldH + diffY, self.minH)
end

function PANEL:OnMouseReleased()
	self.tapped = false
	self.fadeout = true
	local w, h = self:GetNewDimensions()
	self.target:SetSize(w, h)
end

vgui.Register('DLib_ResizeTap', PANEL, 'EditablePanel')

--[[
	@doc
	@panel DLib_Window
	@parent DFrame

	@desc
	!g:DFrame but with DLib's VGUI skin and resize control parented to it
	and some spice like always `:MakePopup()`
	@enddesc
]]
PANEL = {}
DLib.VGUI.Window = PANEL

function PANEL:Init()
	self:SetSize(ScrWL() - 100, ScrHL() - 100)
	self:Center()
	self:MakePopup()
	self:SetTitle('DLib Window')
	self:SetSkin('DLib_Black')

	self.bottomBar = vgui.Create('EditablePanel', self)
	local bar = self.bottomBar
	bar:Dock(BOTTOM)
	bar:SetSize(0, 16)
	bar:SetMouseInputEnabled(true)

	self.bottomTap = vgui.Create('DLib_ResizeTap', bar)
	local tap = self.bottomTap
	tap:Dock(RIGHT)
	tap:SetSize(16, 16)
	tap:SetMouseInputEnabled(true)
	tap:SetTarget(self)
end

--[[
	@doc
	@fname DLib_Window:UpdateSize
	@args number width, number height
]]
function PANEL:UpdateSize(w, h)
	self:SetSize(w, h)
	self:Center()
end

--[[
	@doc
	@fname DLib_Window:RemoveResize

	@desc
	Removes the, wait, can't we just use !g:DFrame ?
	@enddesc
]]
function PANEL:RemoveResize()
	if IsValid(self.bottomBar) then
		self.bottomBar:Remove()
	end
end

function PANEL:SetLabel(str)
	return self:SetTitle(str)
end

--[[
	@doc
	@fname DLib_Window:AddPanel
	@args Panel panel, number dockMode
]]
function PANEL:AddPanel(panel, dock)
	if type(panel) == 'string' then
		panel = vgui.Create(panel, self)
	end

	panel:Dock(dock or TOP)
	return panel
end

--[[
	@doc
	@fname DLib_Window:Label
	@args string text

	@returns
	Panel: DLabel
]]
function PANEL:Label(text)
	local panel = vgui.Create('DLabel', self)
	self:AddPanel(panel)

	if text then
		panel:SetText(text)
	end

	panel:SizeToContents()

	return panel
end

vgui.Register('DLib_Window', PANEL, 'DFrame')

--[[
	@doc
	@panel DLib_WindowScroll
	@parent DLib_Window

	@desc
	!p:DLib_Window with parented scroll panel to it
	@enddesc
]]

--[[
	@doc
	@fname DLib_WindowScroll:AddPanel
	@args Panel panel, number dockMode
]]
PANEL = {}
DLib.VGUI.WindowScroll = PANEL

function PANEL:Init()
	local scroll = vgui.Create('DScrollPanel', self)
	self.scroll = scroll
	scroll:Dock(FILL)
end

--[[
	@doc
	@fname DLib_WindowScroll:GetCanvas

	@returns
	Panel
]]
function PANEL:GetCanvas()
	return self.scroll:GetCanvas()
end

--[[
	@doc
	@fname DLib_WindowScroll:ParentToCanvas
	@args Panel child
]]
function PANEL:ParentToCanvas(child)
	return child:SetParent(self:GetCanvas())
end

--[[
	@doc
	@fname DLib_WindowScroll:GetPadding

	@returns
	number
]]
function PANEL:GetPadding()
	return self.scroll:GetPadding()
end

--[[
	@doc
	@fname DLib_WindowScroll:GetVBar

	@returns
	Panel
]]
function PANEL:GetVBar()
	return self.scroll:GetVBar()
end

--[[
	@doc
	@fname DLib_WindowScroll:GetScrollPanel

	@returns
	Panel
]]
function PANEL:GetScrollPanel()
	return self.scroll
end

--[[
	@doc
	@fname DLib_WindowScroll:ScrollToChild
	@args Panel child
]]
function PANEL:ScrollToChild(child)
	return self.scroll:ScrollToChild(child)
end

function PANEL:AddPanel(panel, dock)
	if type(panel) == 'string' then
		panel = vgui.Create(panel, self)
	end

	self.scroll:AddItem(panel)
	panel:Dock(dock or TOP)
	return panel
end

vgui.Register('DLib_WindowScroll', PANEL, 'DLib_Window')
