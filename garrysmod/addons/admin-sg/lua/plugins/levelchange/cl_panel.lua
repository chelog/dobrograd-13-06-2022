--[[
	 2017 Thriving Ventures Ltd do not share, re-distribute or modify
	without permission of its author (gustaf@thrivingventures.com).
]]

surface.CreateFont("sg.mapchange.divider", {font = "Roboto", size = 18, weight = 800})
surface.CreateFont("sg.mapchange.curmap", {font = "Roboto", size = 16, weight = 800})

local plugin = plugin
local category = {}
category.name = "Change map"
category.material = "serverguard/menuicons/icon_mapmenu.png"
category.permissions = "Map"

category.LoadedMaps = nil
category.RequestedMaps = nil
category.ServerMaps = nil
category.categoryPanels = {}

serverguard.netstream.Hook("sgReceiveServerMaps", function(data)
	local smaps = data[1]
	category.ServerMaps = smaps
end)

function category:Create(base)
	base.panel = base:Add("tiger.panel")
	base.panel:SetTitle("Change Map")
	base.panel:Dock(FILL)

	category.filterMapSettings = base.panel:Add("tiger.list")
	category.filterMapSettings:Dock(TOP)
	category.filterMapSettings:DockMargin(0, 5, 0, 5)
	
	category.mapList = base.panel:Add("tiger.scrollpanel")
	category.mapList:Dock(FILL)
	
	local ThinkTime = 0.4
	category.UpdateMapsTimer = CurTime() + ThinkTime
	
	function category.mapList:Think()
		if (CurTime() < category.UpdateMapsTimer and !category.LoadedMaps) then
			category.UpdateMapsTimer = CurTime() + ThinkTime
		
			category:Update()
		end
	end
	
	category.curMapLabel = base.panel:Add("DLabel")
	category.curMapLabel:SetFont("sg.mapchange.curmap")
	category.curMapLabel:SetSkin("serverguard")
	category.curMapLabel:SetText("Current map: " .. plugin.CurrentMap)
	category.curMapLabel:Dock(BOTTOM)
	category.curMapLabel:DockMargin(5, 5, 5, 5)
	category.curMapLabel:SizeToContents()
	
	local refreshMaps = base.panel:Add("tiger.button")
	refreshMaps:SetText("Refresh Maps")
	refreshMaps:Dock(BOTTOM)
	refreshMaps:DockMargin(5, 5, 5, 5)
	refreshMaps:SizeToContents()
					
	function refreshMaps:DoClick()
		category.mapList:Clear()
		
		category.ServerMaps = nil
		category.LoadedMaps = nil
		category.RequestedMaps = nil
		
		category.UpdateMapsTimer = CurTime() + ThinkTime
	end
end
plugin:AddSubCategory("Server settings", category)

function category:Update()
	if (self.ServerMaps and !self.LoadedMaps) then
		self.LoadedMaps = true

		self.filterMapSettings:SetTall(table.Count(self.ServerMaps) * 20)
		
		for cat_name, maps in pairs(self.ServerMaps) do
			self.mapCatFilter = self.filterMapSettings:Add("tiger.checkbox")
			self.mapCatFilter:SetText("Hide " .. cat_name .. " Maps")
			self.mapCatFilter:Dock(TOP)
			self.mapCatFilter:SetTall(20)
			self.mapCatFilter:SetChecked(true)
			self.mapCatFilter.SetCat = cat_name
		
			self.mapCat = self.mapList:Add("tiger.list")
			self.mapCat:Dock(TOP)
			self.mapCat:SetTall((table.Count(maps) * 40) + 35)
			self.mapCat:DockMargin(0, 5, 0, 5)
			self.mapCat.SetCat = cat_name
			
			self.mapCatDiv = self.mapCat:Add("Panel")
			self.mapCatDiv:Dock(TOP)
			self.mapCatDiv:SetTall(30)
			
			self.mapCatLabel = self.mapCatDiv:Add("DLabel")
			self.mapCatLabel:SetFont("sg.mapchange.divider")
			self.mapCatLabel:SetSkin("serverguard")
			self.mapCatLabel:SetText(cat_name .. " Maps")
			self.mapCatLabel:Dock(LEFT)
			self.mapCatLabel:DockMargin(5, 5, 5, 5)
			self.mapCatLabel:SizeToContents()
			
			table.insert(category.categoryPanels, self.mapCat)
				
			for i = 1, #maps do
				local map_noext = maps[i]:StripExtension()

				local mapPnl = self.mapCat:Add("tiger.panel")
				mapPnl:SetTall(40)
				mapPnl:Dock(TOP)
					
				local mapImage = mapPnl:Add("DImage")
				mapImage:Dock(LEFT)
				mapImage:DockMargin(5, 3, 5, 3)
				mapImage:SetWide(28)
				mapImage:SetImage("maps/thumb/" .. map_noext .. ".png", category.material)
					
				local mapLabel = mapPnl:Add("DLabel")
				mapLabel:SetFont("tiger.button")
				mapLabel:SetSkin("serverguard")
				mapLabel:SetText(map_noext)
				mapLabel:Dock(LEFT)
				mapLabel:DockMargin(5, 3, 5, 3)
				mapLabel:SizeToContents()
					
				local mapSwitchButton = mapPnl:Add("tiger.button")
				mapSwitchButton:SetText("Switch to Map")
				mapSwitchButton:Dock(RIGHT)
				mapSwitchButton:DockMargin(5, 5, 5, 5)
				mapSwitchButton:SizeToContents()
					
				function mapSwitchButton:DoClick()
					self:SetText("Changing...")
					category.curMapLabel:SetText("Changing to map: " .. map_noext)
					RunConsoleCommand("sg", "map", map_noext)
				end
			end
			
			self.mapCat:SetTall((table.Count(maps) * 40) + 35)
			
			function self.mapCatFilter:OnChange(bool)
				if !(bool) then
					self:SetText("Show " .. cat_name .. " Maps")
				else
					self:SetText("Hide " .. cat_name .. " Maps")
				end
			
				for _, catpnls in pairs(category.categoryPanels) do
					if (catpnls.SetCat == self.SetCat) then
						catpnls:SetVisible(bool)
						category.mapList:GetCanvas():InvalidateLayout()
					end
				end
			end
		end
	elseif (!self.RequestedMaps) then
		self.RequestedMaps = true
		serverguard.netstream.Start("sgRequestServerMaps", true)
	end
end
