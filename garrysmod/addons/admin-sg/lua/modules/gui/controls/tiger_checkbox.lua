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

local panel = {};

AccessorFunc(panel, "m_Material", "Material");

function panel:Init()
	local theme = serverguard.themes.GetCurrent();

	self.checked = false;

	self.currentLocation = 0;
	self.targetLocation = 0;

	self.currentAlpha = 0;
	self.targetAlpha = 0;

	self:SetTall(30);

	self.label = self:Add("DLabel");
	self.label:SetText("Undefined");
	self.label:SizeToContents();
	self.label:Dock(LEFT);
	self.label:DockMargin(8, 0, 0, 0);
	self.label:SetSkin("serverguard");
	self.label:SetColor(theme.tiger_list_panel_label);

	self:SetMaterial(Material("icon16/tick.png"));
end;

function panel:PerformIconLayout()
	local material = self:GetMaterial();
	local width = self:GetWide();

	if (self.checked) then
		self.currentAlpha = 0;
		self.targetAlpha = 255;

		self.currentLocation = width - material:Width();
		self.targetLocation = width - (material:Width() * 2);

	else
		self.currentAlpha = (self.currentAlpha != 0) and 255 or 0;
		self.targetAlpha = 0;

		self.currentLocation = width - (material:Width() * 2);
		self.targetLocation = width - (material:Width() * 3);
	end;
end;

function panel:SetChecked(bValue)
	self.checked = tobool(bValue);

	self:PerformIconLayout();
end;

function panel:GetChecked()
	return self.checked;
end;

function panel:Paint(width, height)
	local theme = serverguard.themes.GetCurrent();
	local material = self:GetMaterial();
	local animateSpeed;

	if (self.currentAlpha != self.targetAlpha) then
		animateSpeed = math.abs(self.targetAlpha - self.currentAlpha) * 8;
		self.currentAlpha = math.Approach(self.currentAlpha, self.targetAlpha, animateSpeed * FrameTime());
	end;

	if (self.currentLocation != self.targetLocation) then
		animateSpeed = math.abs(self.targetLocation - self.currentLocation) * 4;
		self.currentLocation = math.Approach(self.currentLocation, self.targetLocation, animateSpeed * FrameTime());
	end;

	if (self.hovered) then
		draw.SimpleRect(0, 0, width, height, theme.tiger_list_panel_list_hover);
	end;

	surface.SetDrawColor(Color(255, 255, 255, self.currentAlpha));
	surface.SetMaterial(self:GetMaterial());
	surface.DrawTexturedRect(self.currentLocation, self:GetTall() / 2 - material:Height() / 2, material:Width(), material:Height());
end;

function panel:OnCursorEntered()
	self:SetCursor("hand");
	self.hovered = true;

	local theme = serverguard.themes.GetCurrent();

	self.label:SetColor(theme.tiger_list_panel_label_hover);
	self.label:InvalidateLayout(true);
end;

function panel:OnCursorExited()
	self:SetCursor("arrow");
	self.hovered = nil;

	local theme = serverguard.themes.GetCurrent();

	self.label:SetColor(theme.tiger_list_panel_label);
	self.label:InvalidateLayout(true);
end;

function panel:OnMousePressed()
	self:SetChecked(!self.checked);
	self:OnChange(self.checked);
end;

function panel:SetText(text)
	self.label:SetText(text);
	self.label:SizeToContents();
end;

function panel:GetText()
	return self.label:GetText();
end;

function panel:PerformLayout(width, height)
	if (self.lastWidth or 0) ~= width or (self.lastHeight or 0) ~= height then
		self.lastWidth = width
		self.lastHeight = height
		self:PerformIconLayout()
	end
end;

function panel:OnChange(bValue)
end;

vgui.Register("tiger.checkbox", panel, "Panel");