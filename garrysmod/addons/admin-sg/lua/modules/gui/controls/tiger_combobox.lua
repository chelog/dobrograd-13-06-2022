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

surface.CreateFont("tiger.combobox.label", {
	font = "Istok",
	weight = 300,
	size = 12
});

local panel = {};

AccessorFunc(panel, "m_sLabelText", "LabelText", FORCE_STRING);

function panel:Init()
	self:SetTall(30);
	self:SetLabelText("");
end;

function panel:OpenMenu(pControlOpener)
	if (pControlOpener) then
		if (pControlOpener == self.TextEntry) then
			return;
		end;
	end;

	if (#self.Choices == 0) then
		return;
	end;
	
	if (IsValid(self.Menu)) then
		self.Menu:Remove();
		self.Menu = nil;
	end;

	self.Menu = DermaMenu();
	self.Menu:SetSkin("serverguard");
	
	local sorted = {};

	for k, v in pairs(self.Choices) do
		table.insert(sorted, {
			id = k,
			data = v
		});
	end;

	for k, v in SortedPairsByMemberValue(sorted, "data") do
		self.Menu:AddOption(v.data, function()
			self:ChooseOption(v.data, v.id);
		end);
	end;
	
	local x, y = self:LocalToScreen(0, self:GetTall());
	
	self.Menu:SetMinimumWidth(self:GetWide());
	self.Menu:Open(x, y, false, self);

	local width, height = self.Menu:GetSize();

	self.Menu:SetTall(0);
	self.Menu:SizeTo(width, height, 1, 0, 1, function() end);
end;

function panel:SetText()
end;

function panel:Paint(width, height)
	local theme = serverguard.themes.GetCurrent();
	local text = self:GetSelected();
	
	if (self.hovered) then
		draw.SimpleRect(0, 0, width, height, theme.tiger_list_panel_list_hover);

		surface.SetTextColor(theme.tiger_list_panel_label_hover)
		surface.SetFont("tiger.combobox.label");

		surface.SetTextPos(8, 4);
		surface.DrawText(self:GetLabelText());
	else
		surface.SetTextColor(theme.tiger_list_panel_list_hover);
		surface.SetFont("tiger.combobox.label");

		surface.SetTextPos(8, 4);
		surface.DrawText(self:GetLabelText());

		surface.SetTextColor(theme.tiger_list_panel_label);
	end;
	
	if (!text) then
		return;
	end;

	surface.SetFont(self:GetFont());
	local textWidth, textHeight = surface.GetTextSize(self:GetText());

	surface.SetTextPos(8, height - textHeight - 2);
	surface.DrawText(text);

	return false;
end;

function panel:OnCursorEntered()
	self:SetCursor("hand");
	self.hovered = true;
end;

function panel:OnCursorExited()
	self:SetCursor("arrow");
	self.hovered = nil;
end;

vgui.Register("tiger.combobox", panel, "DComboBox");