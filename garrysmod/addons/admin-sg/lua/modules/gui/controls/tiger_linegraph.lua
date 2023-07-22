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


local color_label = Color(49, 49, 49);

surface.CreateFont("tiger.linegraph", {font = "Tahoma", size = 12, weight = 400});

local math = math;
local surface = surface;
local lineTexture = surface.GetTextureID("trails/smoke");
local baseX = 30;
local baseY = 25;
local spaceX = 0;

local panel = {};

function panel:Init()
	self.data = {{}, {}, {}};
	self.min, self.max = 0, 0;
end

function panel:SetStepping(step)
	self.data[1] = {};
	
	step = math.max(step, 1);
	
	for i = self.min, self.max, step do
		table.insert(self.data[1], i);
	end;
	
	self.stepping = step;
end;

function panel:SetRange(min, max, step)
	self.data[1] = {};
	
	step = math.max(step, 1);
	
	for i = min, max, step do
		table.insert(self.data[1], i);
	end;
	
	self.min = tonumber(min);
	self.max = tonumber(max);
	self.stepping = step;
end;

function panel:AddHorizontal(name)
	table.insert(self.data[2], name);
end;

function panel:ResetLines()
	self.data[3] = {};
end;

function panel:AddLine(name, color, ...)
	local data = {...}
	local line = {}

	for i = 1, #self.data[2] do
		line[i] = data[i]
	end
	
	line.name = name
	line.color = color
	
	if (name) then
		spaceX = 80
	end
	
	table.insert(self.data[3], line)
end

function panel:SetLine(name, color, ...)
	self.data[3] = {}
	
	local data = {...}
	local line = {}

	for i = 1, #self.data[2] do
		line[i] = data[i]
	end
	
	line.name = name
	line.color = color
	
	if (name) then
		spaceX = 80
	end
	
	table.insert(self.data[3], line)
end

function panel:Paint(w, h)

	local lineSpace = (h -baseY *2) /(#self.data[1] -1)

	for i = 1, #self.data[1] do
		local left = self.data[1][i]
		local y = (h -baseY) -lineSpace *(i -1)
		
		draw.SimpleText(left, "tiger.linegraph", baseX -10, y, color_label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		
		--if (i < #self.data[1] -1) then
			surface.SetDrawColor(i % 2 == 0 and Color(230, 230, 230, 100) or color_transparent)
			surface.DrawRect(baseX, y -lineSpace, (w -baseX *2) -spaceX, lineSpace)
		--end
		
		surface.SetDrawColor(Color(189, 189, 189, 255))
		surface.DrawLine(baseX, y, baseX -6, y)
	end
	
	surface.SetDrawColor(Color(189, 189, 189, 255))
	surface.DrawLine(baseX, h -baseY, (w -baseX) -spaceX, h -baseY)
	surface.DrawLine(baseX, baseY, baseX, h -baseY)
	
	local lineSpace2 = ((w -baseX *2) -spaceX) /(#self.data[2] -1)
	local x = baseX

	for i = 1, #self.data[2] do
		local name = self.data[2][i]
		
		draw.SimpleText(name, "tiger.linegraph", x, h -(baseY -16), color_label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		surface.SetDrawColor(Color(189, 189, 189, 255))
		surface.DrawLine(x, h -baseY, x, h -baseY +6)
		
		for i2 = 1, #self.data[3] do
			local value = self.data[3][i2][i]

			if (value) then
				local color = self.data[3][i2].color
				local nextValue = self.data[3][i2][math.min(i +1, #self.data[3][i2])]
				local startY = (h -baseY) -((lineSpace /self.stepping) *(value -self.min))
				local endX = i == #self.data[3][i2] and x or x +lineSpace2
				local endY = i == #self.data[3][i2] and startY or (h -baseY) -((lineSpace /self.stepping) *(nextValue -self.min))
				
				surface.SetDrawColor(color)
				surface.SetTexture(lineTexture)
				surface.DrawLineEx(x, startY, endX, endY, 3)
				
				surface.DrawRect(x -2, startY -2, 4, 4)
				
				draw.SimpleText(value, "tiger.linegraph", x +6, startY +6, color_label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		end
	
		x = x +lineSpace2
	end
	
	if (spaceX > 0) then
		for i = 1, #self.data[3] do
			local name = self.data[3][i].name
			
			local nameY = baseY +((20 *#self.data[3] /#self.data[3]) *i)
			local color = self.data[3][i].color
			
			surface.SetDrawColor(color)
			surface.DrawRect(w -spaceX /2 -45, nameY, 5, 5)
			
			draw.SimpleText(name, "tiger.linegraph", w -spaceX /2 -35, nameY +2, color_label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
end

vgui.Register("tiger.linegraph", panel, "Panel")