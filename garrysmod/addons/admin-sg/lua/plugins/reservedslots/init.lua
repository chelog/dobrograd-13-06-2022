--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);

local bypassRanks = {
	"admin",
	"superadmin",
	"founder"
};

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED)
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT)

local function kickID(uniqueID, reason)
	RunConsoleCommand("kickid", tostring(uniqueID), reason);
end;

plugin.config:AddCallback("hide", function(value)
	RunConsoleCommand("sv_visiblemaxplayers", value and (game.MaxPlayers() - plugin.config:GetValue("slots")) or 0);
end);

plugin.config:AddCallback("slots", function(value)
	RunConsoleCommand("sv_visiblemaxplayers", plugin.config:GetValue("hide") and (game.MaxPlayers() - value) or 0);
end);

plugin:Hook("PlayerAuthed", "reservedslots.PlayerAuthed", function(ply, steamID, uniqueID)
	local onlinePlayers = #player.GetAll();
	local maxPlayers = game.MaxPlayers();
	
	if (onlinePlayers + plugin.config:GetValue("slots") >= maxPlayers) then
		local queryObj = serverguard.mysql:Select("serverguard_users");
			queryObj:Select("rank");
			queryObj:Where("steam_id", steamID);
			queryObj:Callback(function(result, status, lastID)
				local rank = "user";

				if (type(result) == "table" and #result > 0) then
					rank = result[1].rank;
				end;
				
				if (!table.HasValue(bypassRanks, rank)) then
					kickID(uniqueID, "Sorry, that slot has been reserved.")
					return;
				end;
				
				local kickablePlayer, shortestTime = nil, math.huge;

				for k, pPlayer in ipairs(player.GetAll()) do
					local vrank = serverguard.player:GetRank(pPlayer);
					local timeConnected = pPlayer:TimeConnected();
					
					if (timeConnected < shortestTime and !table.HasValue(bypassRanks, vrank)) then
						kickablePlayer, timeConnected = pPlayer, timeConnected;
					end;
				end;
				
				if (kickablePlayer and IsValid(kickablePlayer)) then
					kickablePlayer:Kick("Sorry, freeing up slots for reserved slots.");
				end;
			end);
		queryObj:Execute();
	end;
end);