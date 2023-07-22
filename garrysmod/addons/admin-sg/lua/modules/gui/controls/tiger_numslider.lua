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

-- Slider button.
local panel = {};

AccessorFunc(panel, "m_bDragging", "Dragging", FORCE_BOOL);

function panel:Init()
	self:SetMouseInputEnabled(true);
	self:SetSize(16, 16);

	self.circleRadius = 4;
	self.targetCircleRadius = 4;

	self:SetDragging(false);
end;

function panel:OnMousePressed(keyCode)
	if (keyCode != MOUSE_LEFT) then
		return;
	end;

	self:SetDragging(true);
end;

function panel:Think()
	if (self:GetDragging()) then
		self.targetCircleRadius = 8;

		if (!input.IsMouseDown(MOUSE_LEFT)) then
			self:SetDragging(false);

			local parent = self:GetParent();

			if (IsValid(parent) and parent.ButtonMoved) then
				parent:ButtonMoved();
			end;
		end;
	else
		self.targetCircleRadius = 4;
	end;
end;

function panel:Paint(width, height)
	local theme = serverguard.themes.GetCurrent();

	if (self.circleRadius != self.targetCircleRadius) then
		self.circleRadius = math.Approach(self.circleRadius, self.targetCircleRadius, 30 * FrameTime());
	end;

	if (self:GetDragging()) then
		DisableClipping(true);
	end;
	
	surface.SetDrawColor(theme.tiger_base_section_icon_selected);

	draw.NoTexture();
	draw.Circle(self.circleRadius, self:GetTall() / 2, self.circleRadius, self.circleRadius * 2);

	DisableClipping(false);
end;

vgui.Register("tiger.numslider.button", panel, "Panel");

-- Slider.
local panel = {};

AccessorFunc(panel, "m_iMin", "Min", FORCE_NUMBER);
AccessorFunc(panel, "m_iMax", "Max", FORCE_NUMBER);
AccessorFunc(panel, "m_iValue", "Value", FORCE_NUMBER);
AccessorFunc(panel, "m_bClamp", "ClampValue", FORCE_BOOL);

function panel:Init()
	self:SetMouseInputEnabled(true);

	self.button = self:Add("tiger.numslider.button");
	self.button:SetPos(0, 0);

	self:SetMin(0);
	self:SetMax(100);
	self:SetValue(0);
	self:SetClampValue(false);
end;

function panel:SetValue(value)
	local number = util.ToNumber(value);

	if (self:GetClampValue()) then
		number = math.Clamp(number, self:GetMin(), self:GetMax());
	end;

	self.m_iValue = number;
	self:ValueChanged(number);
end;

function panel:GetFunctionalWidth()
	return self:GetWide() - 10;
end;

function panel:Think()
	if (self.button:GetDragging()) then
		local x, y = self.button:GetPos();
		local mouseX, mouseY = self:CursorPos();

		self.button:SetPos(math.Clamp(mouseX, 1, self:GetWide() - 8), y);
	end;
end;

function panel:Paint(width, height)
	local theme = serverguard.themes.GetCurrent();

	surface.SetDrawColor(theme.tiger_base_section_label);
	surface.DrawRect(2, height / 2 - 1, self:GetWide() - 2, 2);
end;

function panel:CalculateValue()
	local x, y = self.button:GetPos();

	return math.Clamp(math.Round(x / self:GetFunctionalWidth() * self:GetMax()), self:GetMin(), self:GetMax());
end;

function panel:PerformLayout()
	local x, y = self.button:GetPos();

	if (!self.button:GetDragging()) then
		x = math.Clamp(math.Round(math.Clamp(self:GetValue(), self:GetMin(), self:GetMax()) / self:GetMax() * self:GetFunctionalWidth()), 1, self:GetFunctionalWidth());
	end;

	if (!bNoUpdate) then
		self.button:SetPos(x, self:GetTall() / 2 - self.button:GetTall() / 2);
	end;
end;

function panel:ButtonMoved()
	local parent = self:GetParent();

	self.m_iValue = self:CalculateValue();

	if (IsValid(parent) and parent.ValueChanged) then
		parent:ValueChanged(self:GetValue());
	end;
end;

function panel:ValueChanged()
	self:PerformLayout(true);
end;

vgui.Register("tiger.numslider.slider", panel, "Panel");

-- Panel.
local panel = {};

function panel:Init()
	local theme = serverguard.themes.GetCurrent();

	self:SetTall(30);

	self.textLabel = self:Add("DLabel");
	self.textLabel:SetText("Undefined");
	self.textLabel:SizeToContents();
	self.textLabel:Dock(LEFT);
	self.textLabel:DockMargin(8, 0, 8, 0);
	self.textLabel:SetSkin("serverguard");
	self.textLabel:SetColor(theme.tiger_list_panel_label);

	self.slider = self:Add("tiger.numslider.slider");
	self.slider:Dock(FILL);

	self.valueEntry = self:Add("DTextEntry");
	self.valueEntry:SetText("0");
	self.valueEntry:SetSize(32, 30);
	self.valueEntry:Dock(RIGHT);
	self.valueEntry:DockMargin(8, 0, 8, 0);
	self.valueEntry:SetDrawBackground(false);
	self.valueEntry:SetDrawBorder(false);
	self.valueEntry:SetTextColor(theme.tiger_list_panel_label);
	self.valueEntry:SetNumeric(true);

	self.valueEntry.OnValueChange = function(panel, value)
		local number = util.ToNumber(value);

		self.slider:SetValue(number);
		self:ValueChanged(number);
	end;
end;

function panel:Think()
	if (vgui.GetKeyboardFocus() != self.valueEntry) then
		local value = tostring(self.slider:GetValue());

		if (self.slider.button:GetDragging()) then
			value = tostring(self.slider:CalculateValue());
		end;

		self.valueEntry:SetText(value);
	end;
end;

function panel:SetClampValue(bValue)
	self.slider:SetClampValue(bValue);
end;

function panel:SetText(text)
	self.textLabel:SetText(text);
	self.textLabel:SizeToContents();
end;

function panel:SetMinMax(min, max)
	self.slider:SetMin(util.ToNumber(min));
	self.slider:SetMax(util.ToNumber(max));
end;

function panel:SetValue(value)
	self.slider:SetValue(util.ToNumber(value));
	self.valueEntry:SetText(value);
end;

function panel:GetValue()
	return self.slider:GetValue();
end;

function panel:ValueChanged(value)
end;

vgui.Register("tiger.numslider", panel, "Panel");