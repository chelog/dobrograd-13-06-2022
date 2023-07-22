
local PANEL = {}

function PANEL:Init()
	self.Label  = vgui.Create("DLabel",	   self)
	self.NumPad = vgui.Create("DNumPadMulti", self)
	
	self.Label:SetTextColor(color_white)
	
	self:SetPaintBackground(false)
end

function PANEL:SetLabel(txt)
	self.Label:SetText(txt or "Unnamed CtrlNumPadMulti: ")
end

function PANEL:SetConVar(varname)
	self.ConVar = varname
	
	self.NumPad:SetConVar(varname)
end

function PANEL:GetConVar()
	return self.ConVar
end

function PANEL:PerformLayout()
	self.NumPad:InvalidateLayout(true)
	self.NumPad:Center()
	self.NumPad:AlignBottom(5)
	
	self.Label:CenterHorizontal()
	self.Label:AlignTop(5)
	self.Label:SizeToContents()
	
	self:SetTall(self.Label:GetTall() + self.NumPad:GetTall() + 15)
end

vgui.Register("CtrlNumPadMulti", PANEL, "DPanel")
