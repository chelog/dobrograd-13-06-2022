--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("sh_commands.lua", SERVERGUARD.STATE.SHARED);

plugin:Hook("serverguard.mysql.CreateTables", "serverguard.ttt.CreateTables", function()
	local AUTOSLAY_TABLE_QUERY = serverguard.mysql:Create("serverguard_ttt_autoslays");
		AUTOSLAY_TABLE_QUERY:Create("steam_id", "VARCHAR(255) NOT NULL");
		AUTOSLAY_TABLE_QUERY:Create("amount", "TINYINT UNSIGNED NOT NULL");
		AUTOSLAY_TABLE_QUERY:PrimaryKey("steam_id");
	AUTOSLAY_TABLE_QUERY:Execute();
end);

plugin:Hook("PlayerInitialSpawn", "serverguard.ttt.PlayerInitialSpawn", function(player)
	local queryObj = serverguard.mysql:Select("serverguard_ttt_autoslays");
		queryObj:Where("steam_id", player:SteamID());
		queryObj:Limit(1);
		queryObj:Callback(function(result, status, lastID)
			if (type(result) == "table" and #result > 0) then
				player.sg_autoslays = tonumber(result[1].amount);
			end;
		end);
	queryObj:Execute();
end);

plugin:Hook("TTTBeginRound", "serverguard.ttt.AutoSlay", function()
	local targets = {};

	for k, v in ipairs(player.GetAll()) do
		if (v.sg_autoslays and v.sg_autoslays > 0) then
			v:Kill();
			v.sg_autoslays = v.sg_autoslays - 1;
			table.insert(targets, v);
			serverguard.Notify(v, SGPF("local_autoslayed", v.sg_autoslays));

			local updateObj = serverguard.mysql:Update("serverguard_ttt_autoslays");
				updateObj:Update("amount", v.sg_autoslays);
				updateObj:Where("steam_id", v:SteamID());
				updateObj:Limit(1);
			updateObj:Execute();
		end;

		v.sg_dna = nil;
	end;

	if (#targets > 0) then
		serverguard.Notify(nil, SGPF("global_autoslayed", util.GetNotifyListForTargets(targets)));
	end;
end);

plugin:Hook("DoPlayerDeath", "serverguard.ttt.DoPlayerDeath", function(player, attacker, dmgInfo)
	if (IsValid(attacker) and attacker:IsPlayer() and attacker != player) then
		if (attacker.sg_dna and attacker.sg_dna[player]) then
			serverguard.Notify(player, SGPF(attacker:GetTraitor() and "killed_by_traitor_dna" or "killed_by_innocent_dna", attacker:Name()));
		else
			serverguard.Notify(player, SGPF(attacker:GetTraitor() and "killed_by_traitor" or "killed_by_innocent", attacker:Name()));
		end;
	end;
end);

plugin:Hook("TTTFoundDNA", "serverguard.ttt.FoundDNA", function(player, killer, entity)
	if (IsValid(killer)) then
		player.sg_dna = player.sg_dna or {};
		player.sg_dna[killer] = true;
	end;
end);