--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
plugin.disconnects = plugin.disconnects or {};

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);

serverguard.netstream.Hook("sgRequestDisconnects", function(player, data)
	if (serverguard.player:HasPermission(player, "View Disconnects")) then
		for k,v in pairs(plugin.disconnects) do
			serverguard.netstream.Start(player, "sgGetDisconnects", v);
		end;
	end;
end);

local function removeDisconnect(steamid)
	for k,v in pairs(plugin.disconnects) do
		if v[1] == steamid then
			table.remove(plugin.disconnects, k);
		end;
	end;
end;

hook.Add("PlayerDisconnected", "serverguard.disconnects.PlayerDisconnected", function(player)
	if IsValid(player) then
		local steamid = player:SteamID();
		
		table.insert(plugin.disconnects, {steamid, serverguard.player:GetRank(player), player:Name()});
		timer.Simple(600, function()
			removeDisconnect(steamid);
		end);
	end;
end);

hook.Add("PlayerInitialSpawn", "serverguard.disconnects.PlayerInitialSpawn", function(player)
	removeDisconnect(player:SteamID());
end)