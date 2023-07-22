--[[
	© 2017 Thriving Ventures Ltd do not share, re-distribute or modify
	without permission of its author (gustaf@thrivingventures.com).
]]

serverguard.AddFolder("levelchange")

local plugin = plugin

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED)
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT)

local function serverGetMaps()
	local all_maps = {}
	local lc_maps = file.Find("maps/*.bsp", "GAME")
	local GamemodeList = engine.GetGamemodes()
	
	-- Find gamemode prefixes
	for k, gm in ipairs( GamemodeList ) do
		local Name = gm.title or "Uncategorized"
		local Maps = string.Split( gm.maps, "|" )

		if ( Maps && gm.maps != "" ) then
			for k, pattern in ipairs( Maps ) do
				local patt_str = string.lower(pattern):Replace("^", "")
			
				if !(plugin.MapPrefixes[Name]) then plugin.MapPrefixes[Name] = {} end
				if !(table.HasValue(plugin.MapPrefixes[Name], patt_str)) then
					table.insert(plugin.MapPrefixes[Name], patt_str)
				end
			end
		end
	end
	
	-- Categorize Maps
	for map_cat, map_prfx in pairs(plugin.MapPrefixes) do
		for i = 1, #plugin.MapPrefixes[map_cat] do
			for _, map in pairs(lc_maps) do
				local map_noext = map:StripExtension()
				
				if (map:lower():find("^" .. map_prfx[i]) and map_noext != plugin.CurrentMap) then
					if !(all_maps[map_cat]) then table.Merge(all_maps, {[map_cat] = {}}) end
					table.insert(all_maps[map_cat], map)
				end
			end
		end
	end
	
	return all_maps
end

serverguard.netstream.Hook("sgRequestServerMaps", function(player, data)
	serverguard.netstream.Start(player, "sgReceiveServerMaps", {serverGetMaps()})
end)