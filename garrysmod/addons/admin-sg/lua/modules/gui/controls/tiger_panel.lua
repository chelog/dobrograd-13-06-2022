--[[
	� 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
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

local panel = {}

surface.CreateFont("tiger.panel.title", {font = "Istok", size = 24, weight = 800})

serverguard.themes.CreateDefault("tiger_panel_bg", Color(255, 255, 255), "tiger.panel")
serverguard.themes.CreateDefault("tiger_panel_outline", Color(190, 190, 190), "tiger.panel")
serverguard.themes.CreateDefault("tiger_panel_label", Color(151, 137, 133), "tiger.panel")

function panel:Init()
end

function panel:SetTitle(text)
	if (!IsValid(self.label)) then
		self:DockPadding(24, 24, 24, 24)
	
		local theme = serverguard.themes.GetCurrent()
		
		self.label = self:Add("DLabel")
		self.label:Dock(TOP)
		self.label:SetFont("tiger.panel.title")
		self.label:SetColor(theme.tiger_panel_label)
		self.label:DockMargin(0, 0, 0, 24)
		
		serverguard.themes.AddPanel(self.label, "tiger_panel_label")
	end
	
	self.label:SetText(text)
	self.label:SizeToContents()
end

local shadow2 = {}
local shadow3 = {}

for i = 1, 2 do
	shadow2[i] = Color(0, 0, 0, (255 /i) *0.1)
end

for i = 1, 3 do
	shadow3[i] = Color(0, 0, 0, (255 /i) *0.2)
end

function panel:Paint(w, h)
	local theme = serverguard.themes.GetCurrent()

	for i = 1, 2 do
		local color = shadow2[i]
	
		surface.SetDrawColor(color)
	
		-- Right shadow.
		surface.DrawRect(w -2, 2, i, h -4)
	
		-- Top shadow.
		surface.DrawRect(2, 2 -i, w -4, 1)
	
		-- Left shadow.
		surface.DrawRect(2 -i, 2, 1, h -4)
	end
	
	for i = 1, 3 do
		local color = shadow3[i]
	
		surface.SetDrawColor(color)
	
		-- Bottom shadow.
		surface.DrawRect(2, h -3 +i, w -4, 1)
	end

	draw.RoundedBox(4, 2, 2, w -4, h -4, theme.tiger_panel_outline)
	draw.RoundedBox(2, 3, 3, w -6, h -6, theme.tiger_panel_bg)
end

vgui.Register("tiger.panel", panel, "EditablePanel")