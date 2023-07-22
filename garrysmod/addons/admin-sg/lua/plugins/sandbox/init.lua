--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED)

plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT)

serverguard.netstream.Hook("sgSandboxChangeSetting", function(player, data)
	if (player:IsAdmin()) then
		local conVar = plugin.convars[data[1]];
		
		if (conVar) then
			local newValue = math.Round(tonumber(data[2]));

			game.ConsoleCommand(conVar.." "..tostring(newValue).."\n");
		end;
	end;
end);