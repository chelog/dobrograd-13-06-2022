--[[
	� 2017 Thriving Ventures Limited do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

--- ## Shared
-- Handles rank loading, saving, assignment, management, etc.
-- @module serverguard.ranks

include "modules/sh_cami.lua"

serverguard.ranks = serverguard.ranks or {};
serverguard.ranks.stored = serverguard.ranks.stored or {};
serverguard.ranks.default = serverguard.ranks.default or {};

serverguard.ranks.default["founder"] = true;
serverguard.ranks.default["superadmin"] = true;
serverguard.ranks.default["admin"] = true;
serverguard.ranks.default["user"] = true;

if (SERVER) then
	serverguard.AddFolder("ranks");

	--- **(SERVERSIDE)** Saves a player's rank.
	-- @player player The player to save the rank of.
	-- @string rank The unique ID of the rank.
	function serverguard.ranks:SavePlayerRank(player, rank)
		if (!player:IsBot()) then
			local steamID = player:SteamID();

			local queryObj = serverguard.mysql:Select("serverguard_users");
				queryObj:Where("steam_id", steamID);
				queryObj:Limit(1);
				queryObj:Callback(function(result, status, lastID)
					if (type(result) == "table" and #result > 0) then
						serverguard.player:SaveField(player, "Rank", rank);
					else
						serverguard.player:Save(player, true);
					end;
				end);
			queryObj:Execute();

			hook.Call("serverguard.PostSavePlayerRank", nil, player, rank);
		end;
	end;

	hook.Add("CAMI.PlayerHasAccess", "serverguard.ranks.CAMI.PlayerHasAccess", function(actor, privilege, callback, target, extra)
		if (serverguard.permission:GetAll()[privilege]) then -- it's our permission
			if (serverguard.player:HasPermission(actor, privilege) and (not IsValid(target) or serverguard.player:CanTarget(actor, target))) then
				callback(true, "Allowed")
				return true
			end

		end

	end)

	function serverguard.ranks:CAMILoadRank(unique)
		local rank = serverguard.ranks.stored[unique]

		if (unique != "user" and unique != "admin" and unique != "superadmin") then
			if (self:HasPermission(unique, "Superadmin")) then
				CAMI.RegisterUsergroup({Name = unique, Inherits = "superadmin"}, "SERVERGUARD");
			elseif (self:HasPermission(unique, "Admin")) then
				CAMI.RegisterUsergroup({Name = unique, Inherits = "admin"}, "SERVERGUARD");
			else
				CAMI.RegisterUsergroup({Name = unique, Inherits = "user"}, "SERVERGUARD");
			end;
		end;
	end





	--- **(SERVERSIDE)** Loads all of the ranks into memory.
	-- You shouldn't call this unless you know what you're doing.
	function serverguard.ranks:Load()
		local queryObj = serverguard.mysql:Select("serverguard_ranks");
			queryObj:Callback(function(result, status, lastID)
				if (type(result) == "table" and #result > 0) then
					for k, v in pairs(result) do
						serverguard.ranks.stored[string.lower(v.unique_id)] = {
							unique = string.lower(v.unique_id),
							name = v.name,
							color = util.JSONToTable(v.color),
							immunity = tonumber(v.immunity),
							texture = v.texture,
							data = util.JSONToTable(v.data),
							targetable = tonumber(v.targetable),
							banlimit = tonumber(v.banlimit),
						};
					end;

					hook.Call("serverguard.RanksLoaded", nil);
				else
					for k, v in pairs(serverguard.ranks.stored) do
						serverguard.ranks:Save(v.unique, v.name, v.color, v.immunity, v.texture, v.data, true, v.targetable, v.banlimit);
					end;
				end;
			end);
		queryObj:Execute();
	end;

	hook.Add("serverguard.mysql.CreateTables", "serverguard.ranks.CreateTables", function()
		local RANKS_TABLE_QUERY = serverguard.mysql:Create("serverguard_ranks");
			RANKS_TABLE_QUERY:Create("id", "INTEGER NOT NULL AUTO_INCREMENT");
			RANKS_TABLE_QUERY:Create("unique_id", "VARCHAR(255) NOT NULL");
			RANKS_TABLE_QUERY:Create("name", "VARCHAR(255) NOT NULL");
			RANKS_TABLE_QUERY:Create("color", "VARCHAR(63) NOT NULL");
			RANKS_TABLE_QUERY:Create("immunity", "INT(11) NOT NULL");
			-- RANKS_TABLE_QUERY:Create("targetable", "INT(11) NOT NULL");
			-- let upgrade create targetable
			RANKS_TABLE_QUERY:Create("texture", "VARCHAR(255) NOT NULL");
			RANKS_TABLE_QUERY:Create("data", "TEXT");
			RANKS_TABLE_QUERY:PrimaryKey("id");
		RANKS_TABLE_QUERY:Execute();
	end);

	hook.Add("serverguard.mysql.UpgradeSchemas", "serverguard.ranks.UpgradeSchemas", function(callback)
		serverguard.mysql:UpgradeSchema("serverguard_ranks", {
			{ -- update 1
				"ALTER TABLE `serverguard_ranks` ADD `targetable` INT(11) NOT NULL DEFAULT '0';",
				"UPDATE `serverguard_ranks` SET `targetable` = `immunity` WHERE `id` > '-1';" -- because of safe mode in mysql
			},
			{ -- update 2
				"ALTER TABLE `serverguard_ranks` ADD `banlimit` INT(11) NOT NULL DEFAULT '0';",
			}
		}, callback);
	end);

	hook.Add("serverguard.mysql.OnConnected", "serverguard.ranks.OnConnected", function()
		serverguard.ranks:Load();
	end);

	--- **(SERVERSIDE)** Saves a rank.
	-- @string uniqueID The unique ID of the rank.
	-- @string name The pretty name of the rank.
	-- @color color The color of the rank.
	-- @number immunity The immunity level of the rank.
	-- @string texture The texture path of the rank.
	-- @table data Any extra data to save with the rank.
	-- @bool[opt] bNew Whether to save as a new rank, or to update an existing one with the same name. Defaults to false.
	-- @number[opt] targetable The targetable rank of a player
	 -- @number[opt] banlimit The banlimit the player has.
	function serverguard.ranks:Save(uniqueID, name, color, immunity, texture, data, bNew, targetable, banlimit)
		if (bNew) then
			local insertObj = serverguard.mysql:Insert("serverguard_ranks");
				insertObj:Insert("unique_id", string.lower(uniqueID));
				insertObj:Insert("name", tostring(name));
				insertObj:Insert("color", util.TableToJSON(color));
				insertObj:Insert("immunity", tonumber(immunity));
				insertObj:Insert("targetable", tonumber(targetable) or 0)
				insertObj:Insert("banlimit", tonumber(banlimit) or 0)
				insertObj:Insert("texture", tostring(texture));
				insertObj:Insert("data", util.TableToJSON(data));
			insertObj:Execute();
		else
			local updateObj = serverguard.mysql:Update("serverguard_ranks");
				updateObj:Update("name", tostring(name));
				updateObj:Update("color", util.TableToJSON(color));
				updateObj:Update("immunity", tonumber(immunity));
				updateObj:Update("targetable", tonumber(targetable) or 0)
				updateObj:Update("banlimit", tonumber(banlimit) or 0)
				updateObj:Update("texture", tostring(texture));
				updateObj:Update("data", util.TableToJSON(data));
				updateObj:Where("unique_id", string.lower(uniqueID));
			updateObj:Execute();
		end;
	end

	--- **(SERVERSIDE)** Saves a rank in ranktable form.
	-- @string uniqueID The unique ID of the rank.
	-- @table rankTable The table of data to save.
	-- @bool[opt] bNew Whether to save as a new rank, or to update an existing one with the same name. Defaults to false.
	function serverguard.ranks:SaveTable(uniqueID, rankTable, bNew)
		if (type(uniqueID) == "string" and type(rankTable) == "nil") then
			rankTable = self:FindByID(uniqueID);
		end;

		self:Save(uniqueID, rankTable.name, rankTable.color, rankTable.immunity, rankTable.texture, rankTable.data, bNew, rankTable.targetable, rankTable.banlimit);
	end;

	-- **(SERVERSIDE)** Saves a rank's field.
	-- (DEPRECATED)
	function serverguard.ranks:SaveField(uniqueID, field, value)
		if (type(value) == "table") then
			value = util.TableToJSON(value);
		end;

		local queryObj = serverguard.mysql:Update("serverguard_ranks");
			queryObj:Update(field, value);
			queryObj:Where("unique_id", string.lower(uniqueID));
		queryObj:Execute();
	end;

	--- **(SERVERSIDE)** Sends all ranks' data to a player.
	-- @player player The player to send the data to.
	function serverguard.ranks:SendInitialRanks(player)
		netstream.Heavy(player, "sgNetworkInitialRanks", self.stored);
	end

	--- **(SERVERSIDE)** Sends a rank's data to all connected players.
	-- @string uniqueID The unique ID of the rank.
	-- @bool[opt] bRemove Whether or not to remove the rank. Defaults to false.
	function serverguard.ranks:NetworkRank(uniqueID, bRemove)
		if (bRemove) then
			serverguard.netstream.Start(nil, "sgNetworkRankRemove", uniqueID);
		else
			local rankTable = serverguard.ranks:FindByID(uniqueID);

			if (rankTable) then
				serverguard.netstream.Start(nil, "sgNetworkRankUpdate", rankTable);
			end;
		end
	end

	--- **(SERVERSIDE)** Adds a new rank.
	-- @string unique The unique ID of the rank.
	-- @string name The pretty name of the rank.
	-- @color color The color of the rank.
	-- @number immunity The immunity level of the rank.
	-- @string texture The texture path of the rank.
	-- @table data Any extra data to save with the rank.
	-- @targetable[opt] The targetable rank of the rank.
	-- @treturn string The unique ID of the rank.
	function serverguard.ranks:AddRank(unique, name, immunity, color, texture, data, targetable, banlimit)
		self.stored[string.lower(unique)] = {
			unique = string.lower(unique),
			name = name,
			color = color,
			immunity = tonumber(immunity) or 0,
			texture = texture,
			data = data or {},
			targetable = tonumber(targetable) or tonumber(immunity) or 0,
			banlimit = tonumber(banlimit) or 0,
		};

		serverguard.ranks:CAMILoadRank(unique)

		hook.Call("serverguard.RankCreated", nil, unique); -- Used to set data.

		return unique;
	end;

	--- **(SERVERSIDE)** Removes a rank from memory.
	-- @string uniqueID The unique ID of the rank to remove.
	-- @bool[opt] bSaveless Whether or not to skip saving. Defaults to false.
	-- @treturn bool Whether or not the removal was successful.
	-- @treturn string The error message if the removal failed.
	function serverguard.ranks:RemoveRank(uniqueID, bSaveless)
		if (serverguard.ranks.stored[uniqueID]) then
			if (serverguard.ranks:IsDefault(uniqueID)) then
				return false, "Default ranks cannot be removed!";
			end;

			serverguard.ranks.stored[uniqueID] = nil

			CAMI.UnregisterUsergroup(uniqueID, "SERVERGUARD");

			if (!bSaveless) then
				local queryObj = serverguard.mysql:Delete("serverguard_ranks");
					queryObj:Where("unique_id", uniqueID);
				queryObj:Execute();
			end;

			return true;
		end;
	end;

	-- **(SERVERSIDE)** Returns a rank variable.
	-- (DEPRECATED)
	function serverguard.ranks:GetVariable(lookup, variable)
		local rankData;

		if (type(lookup) == "Player" and IsValid(lookup) and lookup:IsPlayer()) then
			rankData = serverguard.ranks:GetRank(
				serverguard.player:GetRank(lookup)
			);
		elseif (type(lookup) == "string") then
			local rank = serverguard.ranks:GetRank(lookup);

			if (rank) then
				rankData = rank;
			else
				return;
			end;
		elseif (type(lookup) == "table") then
			rankData = lookup;
		else
			return;
		end;

		return rankData[variable];
	end;

	-- Creates a new rank.
	serverguard.netstream.Hook("sgNewRank", function(player, data)
		if (serverguard.player:HasPermission(player, "Edit Ranks")) then
			local uniqueID = data[1] or "unknown";
			local name = data[2] or "Unknown";
			local immunity = data[3] or 0;
			local color = data[4];
			local texture = data[5];
			local targetable_rank = data[8];
			local banlimit = data[9];

			serverguard.ranks:AddRank(uniqueID, name, immunity, color, texture, nil, targetable_rank, banlimit);
				serverguard.ranks:SetData(uniqueID, "Permissions", data[6]);

				for k, v in pairs(data[7]) do
					serverguard.ranks:SetData(uniqueID, k, v);
				end

				serverguard.ranks:NetworkRank(uniqueID);
			serverguard.ranks:SaveTable(uniqueID, nil, true);

			serverguard.Notify(player, SERVERGUARD.NOTIFY.WHITE, "The ", SERVERGUARD.NOTIFY.GREEN, name, SERVERGUARD.NOTIFY.WHITE, " rank has been created!");
		end;
	end);

	-- Removes a rank.
	serverguard.netstream.Hook("sgRemoveRank", function(player, data)
		if (serverguard.player:HasPermission(player, "Edit Ranks")) then
			local uniqueID = data;
			local bStatus, fault = serverguard.ranks:RemoveRank(uniqueID);

			if (bStatus == false and fault) then
				serverguard.netstream.Start(player, "sgPopupError", fault);
				return;
			end;

			serverguard.Notify(player, SERVERGUARD.NOTIFY.WHITE, "The rank ", SERVERGUARD.NOTIFY.GREEN, uniqueID, SERVERGUARD.NOTIFY.WHITE, " was removed!");
			serverguard.ranks:NetworkRank(uniqueID, true);
		end;
	end);

	-- Changes specific data in a rank.
	serverguard.netstream.Hook("sgChangeRankInfo", function(pPlayer, data)
		if (serverguard.player:HasPermission(pPlayer, "Edit Ranks")) then
			local uniqueID = data[1];
			local field = data[2];
			local valueType = data[3];
			local value = data[4];

			if (valueType == SERVERGUARD.NETWORK.STRING) then
				value = tostring(value);
			elseif (valueType == SERVERGUARD.NETWORK.NUMBER) then
				value = tonumber(value);
			elseif (valueType == SERVERGUARD.NETWORK.BOOLEAN) then
				value = tobool(value)
			elseif (valueType == SERVERGUARD.NETWORK.COLOR) then
				value = Color(value.r, value.g, value.b, 255);
			elseif (valueType == SERVERGUARD.NETWORK.CUSTOM) then
				value = serverguard.von.deserialize(value);
			end;

			serverguard.ranks.stored[uniqueID][field] = value;
			serverguard.ranks:SaveField(uniqueID, field, value);

			serverguard.netstream.Start(nil, "sgNetworkRankInfo", {
				unique = uniqueID,
				field = field,
				type = valueType,
				value = value
			});
			if (field == "immunity") then
				for k,v in ipairs(player.GetAll()) do
					if (v:GetNetVar "serverguard_rank" == uniqueID) then
						serverguard.player:SetImmunity(v, value)
					end
				end
			elseif (field == "targetable") then
				for k,v in ipairs(player.GetAll()) do
					if (v:GetNetVar "serverguard_rank" == uniqueID) then
						serverguard.player:SetTargetableRank(v, value)
					end
				end
			elseif (field == "banlimit") then
				for k,v in ipairs(player.GetAll()) do
					if (v:GetNetVar "serverguard_rank" == uniqueID) then
						serverguard.player:SetBanLimit(v, value)
					end
				end
			end
			end
	end);

	-- Changes a rank's data field.
	serverguard.netstream.Hook("sgChangeRankData", function(player, data)
		if (serverguard.player:HasPermission(player, "Edit Ranks")) then
			local uniqueID = data[1];
			local field = data[2];
			local value = data[3];

			if (field == "Permissions") then
				if (uniqueID != "founder") then
					serverguard.ranks:SetData(uniqueID, field, value);
					serverguard.netstream.Start(nil, "sgNetworkRankData", {
						uniqueID, field, value
					});
				end;
			else
				serverguard.ranks:SetData(uniqueID, field, value);
				serverguard.netstream.Start(nil, "sgNetworkRankData", {
					uniqueID, field, value
				});
			end;

			serverguard.ranks:SaveTable(uniqueID);
		end;
	end);

	-- Set a player to founder rank.
	concommand.Add("serverguard_setowner", function(player, command, arguments)
		if (util.IsConsole(player) or !game.IsDedicated()) then
			local target = util.FindPlayer(arguments[1])

			if (IsValid(target)) then
				local rankData = serverguard.ranks:GetRank("founder")

				if (rankData) then
					serverguard.player:SetRank(target, rankData.unique, 0)
					serverguard.player:SetImmunity(target, rankData.immunity)
					serverguard.player:SetTargetableRank(target, rankData.targetable)
					serverguard.player:SetBanLimit(target, rankData.banlimit)

					serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, "Console", SERVERGUARD.NOTIFY.WHITE, " has set ", SERVERGUARD.NOTIFY.RED, serverguard.player:GetName(target), SERVERGUARD.NOTIFY.WHITE, string.Ownership(serverguard.player:GetName(target), true) .. " rank to ", SERVERGUARD.NOTIFY.GREEN, "Founder", SERVERGUARD.NOTIFY.WHITE, ".")
				else
					serverguard.PrintConsole("Something went really wrong! Unable to find the founder rank.\n");
				end;
			end;
		elseif (IsValid(player)) then
			serverguard.Notify(player, SERVERGUARD.NOTIFY.DEFAULT, "You must run this command via rcon or the servers console!");
		end;
	end)

	-- Set a players rank.
	concommand.Add("serverguard_setrank", function(player, command, arguments)
		if (util.IsConsole(player) or !game.IsDedicated()) then
			local target = util.FindPlayer(arguments[1], NULL, true);
			local rankData = serverguard.ranks:GetRank(arguments[2]);

			if (!rankData) then
				serverguard.PrintConsole("Invalid rank! Here are some valid ones:\n");

				for unique, data in pairs(serverguard.ranks:GetRanks()) do
					serverguard.PrintConsole(data.unique .. "\n");
				end;

				return;
			end

			if (IsValid(target)) then
				serverguard.player:SetRank(target, rankData.unique, 0);
				serverguard.player:SetImmunity(target, rankData.immunity);
				serverguard.player:SetTargetableRank(target, rankData.targetable)
				serverguard.player:SetBanLimit(target, rankData.banlimit)

				serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, "Console", SERVERGUARD.NOTIFY.WHITE, " has set ", SERVERGUARD.NOTIFY.RED, serverguard.player:GetName(target), SERVERGUARD.NOTIFY.WHITE, string.Ownership(serverguard.player:GetName(target), true) .. " rank to ", SERVERGUARD.NOTIFY.GREEN, rankData.name, SERVERGUARD.NOTIFY.WHITE, ".")
			elseif (string.SteamID(arguments[1])) then
				local steamID = arguments[1];

				serverguard.player:SetRank(steamID, rankData.unique, 0);
				serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, "Console", SERVERGUARD.NOTIFY.WHITE, " has set ", SERVERGUARD.NOTIFY.RED, steamID, SERVERGUARD.NOTIFY.WHITE, string.Ownership(serverguard.player:GetName(target), true) .. " rank to ", SERVERGUARD.NOTIFY.GREEN, rankData.name, SERVERGUARD.NOTIFY.WHITE, ".")
			else
				serverguard.PrintConsole("Could not find a player with that identifier!");
			end;
		end;
	end);

	-- hook.Add("PlayerInitialSpawn", "serverguard.ranks.PlayerInitialSpawn", function(player)
	-- 	local queryObj = serverguard.mysql:Select("serverguard_users");
	-- 		queryObj:Where("rank", "founder");
	-- 		queryObj:Callback(function(result, status, lastID)
	-- 			if (type(result) != "table" or #result == 0) then
	-- 				serverguard.Notify(player, SERVERGUARD.NOTIFY.DEFAULT, "Use the command serverguard_setowner <name> via rcon to set yourself as founder.");
	-- 			end;
	-- 		end);
	-- 	queryObj:Execute();
	-- end);

	hook.Add("PlayerLoadout", "serverguard.ranks.PlayerLoadout", function(player)
		local uniqueID = serverguard.player:GetRank(player);
		local color = serverguard.ranks:GetData(uniqueID, "phys_color", Color(77, 255, 255));
		player:SetWeaponColor(Vector(color.r / 255, color.g / 255, color.b / 255));
	end);

	-- Sends the rank data to a player.
	serverguard.netstream.Hook("sgRequestPlayerRanks", function(player, data)
		if not serverguard.player:HasPermission(player, "Set Rank") then return end

		local queryObj = serverguard.mysql:Select("serverguard_users");
			queryObj:WhereNotEqual("rank", "user");
			queryObj:Callback(function(result, status, lastID)
				if (type(result) == "table" and #result > 0) then
					for k, v in pairs(result) do
						local expires_in;
						if v.data and v.data != nil then
							local temp = serverguard.von.deserialize(v.data);
							if temp.groupExpire then
								if temp.groupExpire == 0 then
									expires_in = "never";
								else
									expires_in = temp.groupExpire - os.time();
								end;
							else
								expires_in = "never";
							end;
						end;

						serverguard.netstream.Start(player, "sgGetRankList", {
							v.steam_id, v.rank, v.name, expires_in, os.date("*t", os.difftime(os.time(), v.last_played)) or "Unknown"
						});
					end;
				end;
			end);
		queryObj:Execute();
	end);

	-- Changes a player's rank.
	serverguard.netstream.Hook("sgChangePlayerRank", function(player, data)
		if not serverguard.player:HasPermission(player, "Set Rank") then return end

		local steamID = data[1];
		local rank = data[2];
		local length = tonumber(data[3]) or 0;

		if IsValid(player) and player:IsPlayer() then
			local curImm = serverguard.ranks:FindByID(player:GetUserGroup()).immunity
			local tgtImm = serverguard.ranks:GetRank(rank).immunity
			if tgtImm >= curImm then
				serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "No access.")
				return
			end
		end

		if (rank != "") then
			local data = player.sg_data or {};
			if (length != nil and isnumber(length) and length > 0) then
				data.groupExpire = os.time() + length * 60;
			else
				data.groupExpire = false;
			end;
			local queryObj = serverguard.mysql:Update("serverguard_users");
				queryObj:Update("rank", rank);
				queryObj:Update("data", serverguard.von.serialize(data))
				queryObj:Where("steam_id", steamID);
			queryObj:Execute();

			local target = util.FindPlayer(steamID, player, true);
			local rankData = serverguard.ranks:GetRank(rank);

			if (rankData) then
				if (IsValid(target)) then
					serverguard.player:SetRank(target, rank, length * 60);
					serverguard.player:SetImmunity(target, rankData.immunity);
					serverguard.player:SetTargetableRank(target, rankData.targetable)
					serverguard.player:SetBanLimit(target, rankData.banlimit)

					serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, player:Name(), SERVERGUARD.NOTIFY.WHITE, " has set ", SERVERGUARD.NOTIFY.RED, target:Name(), SERVERGUARD.NOTIFY.WHITE, string.Ownership(target:Name(), true) .. " rank to ", SERVERGUARD.NOTIFY.GREEN, rankData.name, SERVERGUARD.NOTIFY.WHITE, ". Length: ", SERVERGUARD.NOTIFY.RED, ((length != nil and length > 0) and length .. " minute(s)" or "Indefinitely"), SERVERGUARD.NOTIFY.WHITE, ".");
				else
					serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, player:Name(), SERVERGUARD.NOTIFY.WHITE, " has set ", SERVERGUARD.NOTIFY.RED, steamID, SERVERGUARD.NOTIFY.WHITE, "'s rank to ", SERVERGUARD.NOTIFY.GREEN, rankData.name, SERVERGUARD.NOTIFY.WHITE, ". Length: ", SERVERGUARD.NOTIFY.RED, ((length != nil and length > 0) and length .. " minute(s)." or "Indefinitely"), SERVERGUARD.NOTIFY.WHITE, ".");
				end;
			else
				serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "No rank with the '"..rank.."' unique idenfier exists.");
			end;
		else
			local queryObj = serverguard.mysql:Update("serverguard_users");
				queryObj:Update("rank", rank);
				queryObj:Where("steam_id", steamID);
			queryObj:Execute();

			local target = util.FindPlayer(steamID, player);
			local rankData = serverguard.ranks:GetRank("user");

			if (rankData) then
				if (IsValid(target)) then
					serverguard.player:SetRank(target, rankData.unique, 0);
					serverguard.player:SetImmunity(target, rankData.immunity);
					serverguard.player:SetTargetableRank(target, rankData.targetable)
					serverguard.player:SetBanLimit(target, rankData.banlimit)

					serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, player:Name(), SERVERGUARD.NOTIFY.WHITE, " has set ", SERVERGUARD.NOTIFY.RED, target:Name(), SERVERGUARD.NOTIFY.WHITE, string.Ownership(target:Name(), true) .. " rank to ", SERVERGUARD.NOTIFY.GREEN, rankData.name, SERVERGUARD.NOTIFY.WHITE, ".")
				else
					serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, player:Name(), SERVERGUARD.NOTIFY.WHITE, " has set ", SERVERGUARD.NOTIFY.RED, steamID, SERVERGUARD.NOTIFY.WHITE, string.Ownership(steamID, true) .. " rank to ", SERVERGUARD.NOTIFY.GREEN, rankData.name, SERVERGUARD.NOTIFY.WHITE, ".")
				end;
			end;
		end;
	end);
else
	netstream.Hook("sgNetworkInitialRanks", function(data)
		for uniqueID, rank in pairs(data) do
			serverguard.ranks.stored[uniqueID] = rank;
		end;
	end);

	serverguard.netstream.Hook("sgNetworkRankUpdate", function(data)
		serverguard.ranks.stored[data.unique] = data;
	end);

	serverguard.netstream.Hook("sgNetworkRankRemove", function(data)
		serverguard.ranks.stored[data] = nil;
	end);

	serverguard.netstream.Hook("sgNetworkRankInfo", function(data)
		local uniqueID = data.unique;
		local field = data.field;
		local dataType = data.type;
		local value = data.value;

		if (type == SERVERGUARD.NETWORK.STRING) then
			value = tostring(data.value);
		elseif (type == SERVERGUARD.NETWORK.NUMBER) then
			value = tonumber(data.value);
		elseif (type == SERVERGUARD.NETWORK.BOOLEAN) then
			value = tobool(data.value);
		elseif (type == SERVERGUARD.NETWORK.DECODE) then -- The only thing using this are the flags.
			value = tostring(data.value);

			serverguard.flags:ApplyFlags(serverguard.ranks.stored[unique], string.Explode(",", value));
		elseif (type == SERVERGUARD.NETWORK.COLOR) then -- Only color using this.
			value = Color(value.r, value.g, value.b, 255);
		elseif (type == SERVERGUARD.NETWORK.CUSTOM) then -- Restrictions.
			value = serverguard.von.deserialize(tostring(data.value));
		end;

		if (field == "immunity") then
			for k,v in ipairs(player.GetAll()) do
				if (v:GetNetVar "serverguard_rank" == uniqueID) then
					serverguard.player:SetImmunity(v, value)
				end
			end
		elseif (field == "targetable") then
				for k,v in ipairs(player.GetAll()) do
					if (v:GetNetVar "serverguard_rank" == uniqueID) then
						serverguard.player:SetTargetableRank(v, value)
					end
				end
		elseif (field == "banlimit") then
				for k,v in ipairs(player.GetAll()) do
					if (v:GetNetVar "serverguard_rank" == uniqueID) then
						serverguard.player:SetBanLimit(v, value)
					end
				end
		end

		serverguard.ranks.stored[uniqueID][field] = value;

		hook.Call("serverguard.ranks.RankUpdate", nil)

	end);

	serverguard.netstream.Hook("sgNetworkRankData", function(data)
		local uniqueID = data[1];
		local field = data[2];
		local value = data[3];

		serverguard.ranks:SetData(uniqueID, field, value);
	end);
end;

--- Returns all the ranks.
-- @treturn table The list of ranks
function serverguard.ranks:GetStored()
	return self.stored;
end;

serverguard.ranks.GetRanks = serverguard.ranks.GetStored;
serverguard.ranks.GetTable = serverguard.ranks.GetStored;

--- Finds a rank by the given unique ID.
-- @string uniqueID The unique ID of the rank.
-- @treturn table The rank table.
function serverguard.ranks:FindByID(uniqueID)
	if (self.stored[string.lower(uniqueID)]) then
		return self.stored[string.lower(uniqueID)];
	end;
end;

serverguard.ranks.GetRank = serverguard.ranks.FindByID;

--- Whether or not the rank's unique ID is a default one. (i.e user, founder, etc)
-- @string identifier The rank's unique ID.
-- @treturn bool Whether or not the rank is a default rank.
function serverguard.ranks:IsDefault(identifier)
	if (type(identifier) == "string") then
		return self.default[string.lower(identifier)];
	end;
end;

--- Sets a data field for a rank. You shouldn't call this unless you know what you're doing.
-- @string rank The rank's unique ID.
-- @string key The key to set.
-- @string value The value to set.
function serverguard.ranks:SetData(rank, key, value)
	local rankTable = serverguard.ranks:FindByID(rank);

	if (rankTable) then
		rankTable.data[key] = value;
	end;
end;

--- Gets a data field for a rank. You shouldn't call this unless you know what you're doing.
-- @string rank The rank's unique ID.
-- @string key The key to get.
-- @string default The default value if the key/value doesn't exist.
-- @treturn string The stored data.
function serverguard.ranks:GetData(rank, key, default)
	local rankTable = serverguard.ranks:FindByID(rank);

	if (rankTable) then
		if (!rankTable.data[key] and default != nil) then
			self:SetData(rank, key, default);
		end;

		return rankTable.data[key];
	end;
end;

--- Gets whether or not the rank has the given permission.
-- @string rank The unique ID of the rank.
-- @string identifier The name of the permission.
function serverguard.ranks:HasPermission(rank, identifier)
	if (rank == "founder") then
		return true;
	end;

	local permissionTable = self:GetData(rank, "Permissions", {});

	return permissionTable[identifier];
end;

--- Gives a permission to the specified rank.
-- @string rank The unique ID of the rank.
-- @string identifier The permission to give the rank.
function serverguard.ranks:GivePermission(rank, identifier)
	local permissionTable = self:GetData(rank, "Permissions", {});

	if (serverguard.permission:Exists(identifier)) then
		permissionTable[identifier] = true;
	end;
end;

--- Revokes a permission from the specified rank.
-- @string rank The unique ID of the rank.
-- @string identifier The permission to revoke.
function serverguard.ranks:TakePermission(rank, identifier)
	local permissionTable = self:GetData(rank, "Permissions", {});

	if (serverguard.permission:Exists(identifier)) then
		permissionTable[identifier] = nil;
	end;
end;
