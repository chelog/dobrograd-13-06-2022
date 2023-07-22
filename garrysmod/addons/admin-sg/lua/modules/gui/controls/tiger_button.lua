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

surface.CreateFont("tiger.button", {font = "Istok", size = 14, weight = 800});
surface.CreateFont("tiger.button.bold", {font = "Istok", size = 14, weight = 800});
surface.CreateFont("tiger.button.boldblur", {font = "Istok", size = 14, weight = 800, blursize = 2});

local panel = {};

panel.color_bg = Color(241, 241, 241);
panel.color_outline = Color(190, 190, 190);
panel.color_text = Color(151, 137, 133);
panel.color_text_hovered = color_black;
panel.color_stripe = Color(255, 255, 255);
panel.color_hovered = Color(231, 231, 231);
panel.color_hovered_stripe = Color(241, 241, 241);

serverguard.themes.CreateDefault("tiger_button_bg", Color(241, 241, 241), "tiger.button");
serverguard.themes.CreateDefault("tiger_button_outline", Color(190, 190, 190), "tiger.button");
serverguard.themes.CreateDefault("tiger_button_stripe", Color(255, 255, 255), "tiger.button");
serverguard.themes.CreateDefault("tiger_button_text", Color(151, 137, 133), "tiger.button");
serverguard.themes.CreateDefault("tiger_button_text_hovered", Color(0, 0, 0), "tiger.button");
serverguard.themes.CreateDefault("tiger_button_hovered", Color(231, 231, 231), "tiger.button");
serverguard.themes.CreateDefault("tiger_button_hovered_stripe", Color(241, 241, 241), "tiger.button");

AccessorFunc(panel, "m_sText", "Text");
AccessorFunc(panel, "m_bBold", "Bold", FORCE_BOOL);

function panel:Init()
	self:SetText("");
	self:SetBold(false);
end;

function panel:SizeToContents()
	local width, height = util.GetTextSize("tiger.button", self.m_sText);
	
	self:SetSize(width +15, height +8);
end;

function panel:OnCursorEntered()
	self:SetCursor("hand");
	
	self.hovered = true;
end;

function panel:OnCursorExited()
	self:SetCursor("arrow");
	
	self.hovered = false;
end;

function panel:OnMousePressed()
	self:DoClick();
end;

function panel:DoClick()
end;

function panel:Paint(w, h)
	local theme = serverguard.themes.GetCurrent();
	local font = (self:GetBold() and "tiger.button.bold") or "tiger.button";
	
	draw.RoundedBox(4, 0, 0, w, h, theme.tiger_button_outline);
	
	if (self.hovered) then
		draw.RoundedBox(2, 1, 1, w -2, h -2, theme.tiger_button_hovered);
		draw.SimpleRect(2, 1, w -4, 1, theme.tiger_button_hovered_stripe);
		
		draw.SimpleText(self.m_sText, font, w /2, h /2, theme.tiger_button_text_hovered, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		
		if (self:GetBold()) then
			draw.SimpleText(self.m_sText, "tiger.button.boldblur", w /2, h /2, util.DimColor(theme.tiger_button_text_hovered, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		end;
	else
		draw.RoundedBox(2, 1, 1, w -2, h -2, theme.tiger_button_bg);
		draw.SimpleRect(2, 1, w -4, 1, theme.tiger_button_stripe);
		
		draw.SimpleText(self.m_sText, font, w /2, h /2, theme.tiger_button_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

		if (self:GetBold()) then
			draw.SimpleText(self.m_sText, "tiger.button.boldblur", w /2, h /2, util.DimColor(theme.tiger_button_text, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		end;
	end;
	
	DisableClipping(true);
		for i = 1, 2 do
			local color = Color(0, 0, 0, (255 /i) *0.15);
		
			surface.SetDrawColor(color);
		
			-- Right shadow.
			surface.DrawRect(w -1 +i, 1, 1, h -1);
		
			-- Top shadow.
			--surface.DrawRect(1, -i, w -1, 1);
		
			-- Left shadow.
			--surface.DrawRect(-i, 0, 1, h);
		
			-- Bottom shadow.
			surface.DrawRect(1, h, w -1, i);
		end;
	DisableClipping(false);
end;

vgui.Register("tiger.button", panel, "Panel");