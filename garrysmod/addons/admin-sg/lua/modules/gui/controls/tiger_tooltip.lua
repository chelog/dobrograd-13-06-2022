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

surface.CreateFont("tiger.tooltip", {font = "Arial", size = 14, weight = 400});

local panel = {};

serverguard.themes.CreateDefault("tiger_tooltip_bg", Color(255, 255, 255), "tiger.tooltip");
serverguard.themes.CreateDefault("tiger_tooltip_outline", Color(190, 190, 190), "tiger.tooltip");
serverguard.themes.CreateDefault("tiger_tooltip_label", Color(151, 137, 133), "tiger.tooltip");

function panel:Init()
	self:SetDrawOnTop(true);
	
	self.label = self:Add("DLabel");
	self.label:SetText("");
	self.label:SetFont("tiger.tooltip");
	self.label:SetSkin("serverguard");
	
	serverguard.themes.AddPanel(self.label, "tiger_tooltip_label");
end;

function panel:SetText(text)
	self.label:SetText(text);
end;

function panel:SizeToContents()
	self.label:SizeToContents();
	
	local w, h = self.label:GetSize();
	
	self:SetSize(w +14, h +14);
end;

function panel:PerformLayout()
	self.label:SetPos(7, 7);
end;

function panel:Think()
	if (!self:IsVisible()) then
		return;
	end;

	if (!self.parentPanel or !IsValid(self.parentPanel) and !self.collect) then
		self.collect = true;

		self:AlphaTo(0, 0.2, 0, function()
			self:SetVisible(false);
			self:Remove();
		end);
	end;
end;

function panel:Paint(w, h)
	local theme = serverguard.themes.GetCurrent();
	
	draw.RoundedBox(4, 0, 0, w, h, theme.tiger_tooltip_outline);
	draw.RoundedBox(2, 1, 1, w - 2, h - 2, theme.tiger_tooltip_bg);
	
	DisableClipping(true);
		for i = 1, 2 do
			local color = Color(0, 0, 0, (255 / i) * 0.1);
		
			surface.SetDrawColor(color);
		
			-- Right shadow.
			surface.DrawRect(w - 1 + i, 1, 1, h - 1);
		
			-- Top shadow.
			surface.DrawRect(1, - i, w - 1, 1);
		
			-- Left shadow.
			surface.DrawRect(-i, 0, 1, h);
		end;
	
		for i = 1, 3 do
			local color = Color(0, 0, 0, (255 / i) * 0.16);
		
			surface.SetDrawColor(color);
		
			-- Bottom shadow.
			surface.DrawRect(1, (h - 1) + i, w - 1, 1);
		end;
	DisableClipping(false);
end;

vgui.Register("tiger.tooltip", panel, "Panel");

local registry = debug.getregistry();

function registry.Panel:SetToolTipSG(text)
	if (text == nil) then
		if (IsValid(self.tooltip_sg)) then
			self.tooltip_sg:Remove();
		end;
		
		return;
	end;
	
	if (!IsValid(self.tooltip_sg)) then
		self.tooltip_sg = vgui.Create("tiger.tooltip");
	end;
	
	self.tooltip_sg.parentPanel = self;
	self.tooltip_sg:SetText(text);
	self.tooltip_sg:SizeToContents();
	self.tooltip_sg:SetVisible(false);
	
	local oldHover = self.OnCursorEntered;
	local oldExited = self.OnCursorExited;
	
	function self:OnCursorEntered()
		if (IsValid(self.tooltip_sg)) then
			self.sgToolTip = true;
			
			self.tooltip_sg:SetVisible(true);
			self.tooltip_sg:SetAlpha(0);
			self.tooltip_sg:AlphaTo(255, 0.2, 0, function()
				if (IsValid(self)) then
					self.sgToolTip = nil;
				end;
			end);
			
			local x, y = gui.MousePos();
		
			self.tooltip_sg:SetPos(x + 10, y + 10);
		end
		
		if (oldHover) then
			oldHover(self);
		end;
	end;
	
	function self:OnCursorExited()
		if (IsValid(self.tooltip_sg)) then
			self.tooltip_sg:AlphaTo(0, 0.2, 0, function()
				if (!self.sgToolTip and self.tooltip_sg and IsValid(self)) then
					self.tooltip_sg:SetVisible(false);
				end;
			end);
		end;
		
		if (oldExited) then
			oldExited(self);
		end;
	end;
end;