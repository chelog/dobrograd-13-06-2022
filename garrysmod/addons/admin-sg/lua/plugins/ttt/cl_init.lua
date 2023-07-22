--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.CLIENT);
plugin:IncludeFile("sh_commands.lua", SERVERGUARD.STATE.CLIENT);

plugin:Hook("TTTScoreboardColorForPlayer", "serverguard.ttt.ScoreboardColorForPlayer", function(player)
	local rankData = serverguard.ranks:FindByID(serverguard.player:GetRank(player));

	if (rankData) then
		return rankData.color;
	end;
end);

plugin:Hook("TTTScoreboardColumns", "serverguard.ttt.ScoreboardColumns", function(panel)
	local label = nil;
	
	label = panel:AddColumn("Rank", function(player)
		local rankData = serverguard.ranks:FindByID(serverguard.player:GetRank(player));

		if (rankData) then
			label:SetTextColor(rankData.color);

			return rankData.name;
		end;
	end, 150);
end);