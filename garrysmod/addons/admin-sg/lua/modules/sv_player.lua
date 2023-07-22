--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

function serverguard.player:Load(player)
	local queryObj = serverguard.mysql:Select("serverguard_users");
		queryObj:Where("steam_id", player:SteamID());
		queryObj:Callback(function(result, status, lastID)
			if (type(result) == "table" and #result > 0) then
				if (result[1].rank) then
					local rankData = serverguard.ranks:GetRank(result[1].rank);

					if (rankData) then
						serverguard.player:SetRank(player, rankData.unique, 0, true);
						serverguard.player:SetImmunity(player, rankData.immunity);
						serverguard.player:SetTargetableRank(player, rankData.targetable);
						serverguard.player:SetBanLimit(player, rankData.banlimit);
					end;
				end;

				if (result[1].data and result[1].data != "NULL") then
					player.sg_data = serverguard.von.deserialize(result[1].data);
				else
					player.sg_data = {};
				end;

				serverguard.player:Save(player);
			else
				player.sg_data = {};
				serverguard.player:Save(player, true);
			end;
			hook.Call("serverguard.LoadedPlayerData", nil, player, player:SteamID());
		end);
	queryObj:Execute();
end;

function serverguard.player:Save(player, bNew)
	if (bNew) then
		local insertObj = serverguard.mysql:Insert("serverguard_users");
			insertObj:Insert("name", player:Nick());
			insertObj:Insert("rank", "user");
			insertObj:Insert("steam_id", player:SteamID());
			insertObj:Insert("last_played", os.time());
		insertObj:Execute();
	else
		local updateObj = serverguard.mysql:Update("serverguard_users");
			updateObj:Update("name", player:Nick());
			updateObj:Update("rank", serverguard.player:GetRank(player));
			updateObj:Update("last_played", os.time());
			updateObj:Update("data", serverguard.von.serialize(player.sg_data));
			updateObj:Where("steam_id", player:SteamID());
		updateObj:Execute();
	end;
end;

function serverguard.player:SaveField(player, field, value)
	local updateObj = serverguard.mysql:Update("serverguard_users");
		updateObj:Update(string.lower(field), value);
		updateObj:Where("steam_id", player:SteamID());
	updateObj:Execute();
end;

function serverguard.player:SetData(player, key, value)
	if (not player.sg_data) then
		player.sg_data = {}
	end

	player.sg_data[key] = value;

	local updateObj = serverguard.mysql:Update("serverguard_users");
		updateObj:Update("data", serverguard.von.serialize(player.sg_data));
		updateObj:Where("steam_id", player:SteamID());
	updateObj:Execute();
end;

function serverguard.player:GetData(player, key, default)
	if (player.sg_data and player.sg_data[key] != nil) then
		return player.sg_data[key];
	end

	return default;
end;