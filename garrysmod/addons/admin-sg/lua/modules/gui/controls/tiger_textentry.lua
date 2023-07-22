--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).

  _______ _				   _	_ _____ 
 |__   __(_)				 | |  | |_   _|
	| |   _  __ _  ___ _ __  | |  | | | |  
	| |  | |/ _` |/ _ \ '__| | |  | | | |  
	| |  | | (_| |  __/ |	| |__| |_| |_ 
	|_|  |_|\__, |\___|_|	 \____/|_____|
			 __/ |						 
			|___/						  

]]

surface.CreateFont("tiger.textentry.label", {
	font = "Istok",
	weight = 300,
	size = 12
});

local panel = {};

AccessorFunc(panel, "m_sLabelText", "LabelText", FORCE_STRING);

function panel:Init()
	self:SetSkin("serverguard");
	self:SetLabelText("");

	self:SetHistoryEnabled(false);
	self.History = {};
	self.HistoryPos = 0;

	self:SetPaintBorderEnabled(false);
	self:SetPaintBackgroundEnabled(false);
	
	self:SetDrawBorder(true);
	self:SetDrawBackground(true);

	self:SetEnterAllowed(true);
	self:SetUpdateOnType(false);
	self:SetNumeric(false);
	self:SetAllowNonAsciiCharacters(true);
	self:SetTall(30);
	self:SetCursor("beam");
	
	self.m_bLoseFocusOnClickAway = true;
end;

function panel:Paint(width, height)
	local theme = serverguard.themes.GetCurrent();

	if (vgui.GetKeyboardFocus() == self) then
		derma.SkinHook("Paint", "TextEntry", self, width, height);
	else
		if (self.hovered) then
			draw.SimpleRect(0, 0, width, height, theme.tiger_list_panel_list_hover);

			surface.SetTextColor(theme.tiger_list_panel_label_hover)
			surface.SetFont("tiger.textentry.label");

			surface.SetTextPos(8, 4);
			surface.DrawText(self:GetLabelText());
		else
			surface.SetTextColor(theme.tiger_list_panel_list_hover);
			surface.SetFont("tiger.textentry.label");

			surface.SetTextPos(8, 4);
			surface.DrawText(self:GetLabelText());

			surface.SetTextColor(theme.tiger_list_panel_label);
		end;

		surface.SetFont(self:GetFont());
		local textWidth, textHeight = surface.GetTextSize(self:GetText());

		surface.SetTextPos(8, height - textHeight - 2);
		surface.DrawText(self:GetText());
	end;

	return false;
end;

function panel:OnCursorEntered()
	self:SetCursor("beam");
	self.hovered = true;
end;

function panel:OnCursorExited()
	self:SetCursor("arrow");
	self.hovered = nil;
end;

vgui.Register("tiger.textentry", panel, "DTextEntry");