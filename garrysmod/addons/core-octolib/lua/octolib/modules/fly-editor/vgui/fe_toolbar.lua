local PANEL = {}

function PANEL:Init()

	self:SetSize(42, 42)

	local il = self:Add 'DIconLayout'
	il:Dock(FILL)
	il:DockMargin(5, 5, 5, 5)
	il:SetSpaceX(5)
	self.iconLayout = il

end

function PANEL:SetAlignment(val)

	self.align = val

end

function PANEL:UpdateSize()

	local w = octolib.array.reduce(self.iconLayout:GetChildren(), function(a, v)
		return a + v:GetWide() + 5
	end, 5)

	self:SetWide(w)

	if self.align == 7 then
		self:AlignLeft(5)
		self:AlignTop(5)
	elseif self.align == 9 then
		self:AlignRight(5)
		self:AlignTop(5)
	else
		self:AlignTop(5)
		self:CenterHorizontal()
	end

end

function PANEL:AddButton(tooltip, icon, func)

	local b = self.iconLayout:Add 'DImageButton'
	b:SetTooltip(tooltip or false)
	b:SetImage(icon or 'octoteam/icons-32/control_stop_blue.png')
	b:SetSize(32, 32)
	b.DoClick = func

	self:UpdateSize()
	return b

end

function PANEL:AddSpacer()

	local s = self.iconLayout:Add 'DPanel'
	s:SetDrawBackground(false)
	s:SetSize(10, 32)

	self:UpdateSize()
	return s

end

vgui.Register('fe_toolbar', PANEL, 'DPanel')
