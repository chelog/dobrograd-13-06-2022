--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

--- ## Shared
-- Player manipulation.
-- @module serverguard.player

serverguard.player = serverguard.player or {};

--- Sets a player's rank.
-- @player player The player to set the rank of.
-- @string rank The unique ID of the rank to set as.
-- @bool[opt] length Amount of time (in seconds) after which the rank will be taken away from the player.
-- @bool[opt] bSaveless Whether or not to save the player's rank. Defaults to false;
-- @treturn bool Whether or not the operation was successful.
function serverguard.player:SetRank(player, rank, length, bSaveless)
	local rankData = serverguard.ranks:GetRank(rank);

	if (!rankData) then
		ErrorNoHalt("Error: (SetRank) Attempted to set non-existent rank to player '"..tostring(rank).."'.\n"..debug.traceback().."\n");
		return false;
	end;

	if (isstring(player) and string.SteamID(player)) then
		local queryObj = serverguard.mysql:Select("serverguard_users");
			queryObj:Where("steam_id", player);
			queryObj:Limit(1);
			queryObj:Callback(function(result, status, lastID)
				if (istable(result) and #result > 0) then
					local updateObj = serverguard.mysql:Update("serverguard_users");
						updateObj:Update("rank", rank);
						updateObj:Where("steam_id", player);
					updateObj:Execute();
				else
					local insertObj = serverguard.mysql:Insert("serverguard_users");
						insertObj:Insert("name", "Unknown");
						insertObj:Insert("rank", rank);
						insertObj:Insert("steam_id", player);
						insertObj:Insert("last_played", os.time());
						insertObj:Insert("data",
							serverguard.von.serialize(
								{
									groupExpire = ((length != nil and tonumber(length) != nil and length > 0) and os.time() + math.ceil(tonumber(length))) or 0
								}
							)
						);
					insertObj:Execute();
				end;
			end);
		queryObj:Execute();

		return true;
	end;

	if (!IsValid(player)) then
		ErrorNoHalt("Error: (SetRank) Attempted to set rank to non-existent player.\n"..debug.traceback().."\n");
		return false;
	end;

	player.sg_incognito = nil;
	player:SetNetVar("serverguard_rank", rank);
	player:SetUserGroup(rank);

	if timer.Exists("serverguard.timer.RemoveRank_" .. player:UniqueID()) then
		timer.Remove("serverguard.timer.RemoveRank_" .. player:UniqueID());
	end;

	if (length != nil and tonumber(length) != nil and length > 0) then
		serverguard.player:SetData(player, "groupExpire", os.time() + math.ceil(tonumber(length)));
		timer.Create("serverguard.timer.RemoveRank_" .. player:UniqueID(), math.ceil(tonumber(length)), 1, function()
			if (IsValid(player)) then
				serverguard.player:SetRank(player, "user", 0);
			end;
		end);
	else
		serverguard.player:SetData(player, "groupExpire", false);
	end

	if (!bSaveless) then
		serverguard.ranks:SavePlayerRank(player, rankData.unique);
	end;

	if (SERVER) then
		timer.Simple(FrameTime() * 32, function()
			hook.Run('octolib.updateNetVars', player)
			serverguard.netstream.Start(player, "sgSetPlayerRank", true);
		end);
	end;

	return true;
end;

--- Gets the player's rank unique ID. Defaults to "user" if it doesn't exist.
-- @player player The player to get the rank of.
-- @treturn string The rank's unique ID.
function serverguard.player:GetRank(player)
	result = "user";

	if (IsValid(player) and player:IsPlayer()) then
		result = player:GetNetVar("serverguard_rank", "user");
	elseif (util.IsConsole(player)) then
		result = "founder";
	end;

	return result;
end;

--- Sets a player's immunity level.
-- @player player The player to set the immunity of.
-- @number immunity The new immunity level to set.
function serverguard.player:SetImmunity(player, immunity)
	player:SetNetVar("serverguard_immunity", immunity);
end;

--- Sets a player's ban limit.
-- @player player The player to set the ban limit of.
-- @number limit The new ban limit to set.
function serverguard.player:SetBanLimit(player, limit)
	player:SetNetVar("serverguard_banlimit", limit);
end;

--- Sets a player's targetable rank.
-- @player player The player to set the targetable rank of.
-- @number immunity The new targetable rank to set.
function serverguard.player:SetTargetableRank(player, immunity)
	player:SetNetVar("serverguard_targetable_rank", immunity);
end;

--- Gets a player's immunity level. Defaults to 0 if the immunity is not set.
-- @player player The player to get the immunity of.
-- @treturn number The immunity level of the player.
function serverguard.player:GetImmunity(player)
	if (IsValid(player)) then
		return player:GetNetVar("serverguard_immunity", 0);
	else
		return 100;
	end;
end;

--- Gets a player's ban length.
-- @player player The player to get the banlimit of.
-- @number length The ban limit to get.
function serverguard.player:GetBanLimit(player)
	if (IsValid(player)) then
		return player:GetNetVar("serverguard_banlimit", 0);
	end
end;

--- Gets a player's targetable rank. Defaults to 0 if the immunity is not set.
-- @player player The player to get the targetable rank of.
-- @treturn number The targetable rank of the player.
function serverguard.player:GetTargetableRank(player)
	if (IsValid(player)) then
		return player:GetNetVar("serverguard_targetable_rank", 0);
	else
		return 100;
	end;
end;

--- Returns whether or not the player has a better targetable level than the immunity specified.
-- @player player The player to check the targetable rank of.
-- @number immunity The immunity level to check with.
-- @treturn bool Whether or not the player has a better immunity.
function serverguard.player:HasBetterImmunity(player, immunity)
	return self:GetTargetableRank(player) >= immunity;
end;
--- Returns whether or not the player has a better targetable level than the target's immunity level.
-- @player player The player to check the targetable rank of.
-- @player target The target to check with.
-- @treturn bool Whether or not the player has a better immunity.
function serverguard.player:CanTarget(player, target)
	return self:GetTargetableRank(player) >= serverguard.player:GetImmunity(target);
end;

--- Gets a player's name. Will return with the orignal name in if player.SteamName is defined.
function serverguard.player:GetName(pPlayer)
	if (util.IsConsole(pPlayer)) then
		return "Console";
	elseif (isplayer(pPlayer)) then
		local playerName = pPlayer:Name();

		if (pPlayer.SteamName) then
			playerName = "(" .. pPlayer:SteamName() .. ") " .. playerName;
		end;

		return playerName;
	else
		return "Unknown";
	end;
end;

--- Sets up the spectate routine for the given player. Strips weapons, makes invisible,
-- disables collision, etc.
-- @player player The player to set up the spectate mode for.
-- @number mode The spectate mode to use.
function serverguard.player:SetupSpectate(player, mode)
	if (!player.sg_spectateData) then
		local weapons = player:GetWeapons();

		player.sg_spectateData = {};
		player.sg_spectateData.weapons = {};
		player.sg_spectateData.position = player:GetPos();
		player.sg_spectateData.team = player:Team();

		for k, v in pairs(weapons) do
			table.insert(player.sg_spectateData.weapons, v:GetClass());
		end;
	end;

	player:StripWeapons();
	player:SetTeam(TEAM_SPECTATOR);
	player:Spectate(mode);
	player:SpectateEntity(NULL);
	player:SetCollisionGroup(COLLISION_GROUP_WORLD);

	if (mode == OBS_MODE_ROAMING) then
		player:SetMoveType(MOVETYPE_NOCLIP);
	else
		player:SetMoveType(MOVETYPE_OBSERVER);

		if (IsValid(player.spectateTarget)) then
			player:SpectateEntity(player.spectateTarget);
		end;
	end;

	if (!player.spectatorMode) then
		player.spectatorMode = 1;
	end;

	player.sg_spectating = true;
end;

--- Stops a player from spectating. Returns all of their stuff to normal; weapons,
-- collision, etc.
-- @player player The player to make stop spectating.
function serverguard.player:StopSpectate(player)
	player:SetTeam(player.sg_spectateData.team);
	player:Spectate(OBS_MODE_NONE);
	player:SetMoveType(MOVETYPE_WALK);
	player:SpectateEntity(NULL);
	player:SetCollisionGroup(COLLISION_GROUP_PLAYER);

	player:Spawn();

	player:SetPos(player.sg_spectateData.position);

	for k, v in pairs(player.sg_spectateData.weapons) do
		player:Give(v);
	end;

	player.sg_spectating = nil;
	player.sg_spectateData = nil;
end;

--- Gets the target player that the given player is spectating.
-- @player player The spectating player.
-- @bool[opt] decrease Whether or not to get the next/previous player.
-- @treturn player The spectated player.
function serverguard.player:GetSpectatorTarget(pPlayer, decrease)
	if (isentity(decrease)) then
		pPlayer.spectatorIndex = pPlayer.spectatorIndex or 1;

		return decrease;
	end

	local players = player.GetAll();

	for i = 1, #players do
		if (v == pPlayer) then
			table.remove(players, i);

			break;
		end;
	end;

	pPlayer.spectatorIndex = pPlayer.spectatorIndex or 0;
	pPlayer.spectatorIndex = decrease and pPlayer.spectatorIndex - 1 or pPlayer.spectatorIndex + 1;

	if (pPlayer.spectatorIndex > #players) then
		pPlayer.spectatorIndex = 1;
	elseif (pPlayer.spectatorIndex < 1) then
		pPlayer.spectatorIndex = #players;
	end;

	return players[player.spectatorIndex];
end;

--- Makes a player spectate the set target.
-- @player player The player to put into spectate mode.
-- @bool[opt] decrease Whether to get the next/previous target.
function serverguard.player:SpectateTarget(player, decrease)
	local target = self:GetSpectatorTarget(player, decrease);

	player:SpectateEntity(target);

	player.spectateTarget = target;
end;

--- Changes a player's spectator mode.
-- @player player The player to change the mode of.
-- @bool[opt] decrease Whether to get the next/previous target.
function serverguard.player:ChangeSpectatorMode(player, decrease)
	local spectatorModes = {
		OBS_MODE_ROAMING,
		OBS_MODE_CHASE,
		OBS_MODE_IN_EYE
	};

	player.spectatorMode = decrease and player.spectatorMode - 1 or player.spectatorMode + 1;

	if (player.spectatorMode > #spectatorModes) then
		player.spectatorMode = 1;
	elseif (player.spectatorMode < 1) then
		player.spectatorMode = #spectatorModes;
	end;

	local mode = spectatorModes[player.spectatorMode];

	self:SetupSpectate(player, mode);
end;

if (CLIENT) then
	serverguard.netstream.Hook("sgSetPlayerRank", function(data)
		serverguard.menu:Rebuild();
	end);
end;

--- Gets whether or not the player has the given permission.
-- @player player The player to check the permissions of.
-- @string identifier The name of the permission. This can also be a table of string to check for multiple permissions.
-- @treturn bool Whether or not the player has the given permission.
function serverguard.player:HasPermission(player, identifier)
	if (self:GetRank(player) == "founder") then
		return true;
	end;

	local permissionTable = serverguard.ranks:GetData(
		self:GetRank(player), "Permissions"
	);

	if (permissionTable) then
		local identype = type(identifier)

		if (identype == "string") then
			return permissionTable[identifier] or false;
		end

		if (identype == "table") then
			for k, v in pairs(identifier) do
				if (isstring(v) and permissionTable[v]) then
					return true;
				end;
			end;
		end;
	end;

	return false;
end;

do
	local playerMeta = FindMetaTable("Player");

	playerMeta.sgIsAdmin = playerMeta.sgIsAdmin or playerMeta.IsAdmin;
	playerMeta.sgIsSuperAdmin = playerMeta.sgIsSuperAdmin or playerMeta.IsSuperAdmin;
	playerMeta.sgIsUserGroup = playerMeta.sgIsUserGroup or playerMeta.IsUserGroup;

	--
	-- Override IsAdmin to check serverguard rank.
	--

	function playerMeta:IsAdmin()
		if (self:IsSuperAdmin() or serverguard.player:HasPermission(self, "Admin")) then
			return true;
		end;

		return self:sgIsAdmin();
	end;

	--
	-- Override IsSuperAdmin to check serverguard rank.
	--

	function playerMeta:IsSuperAdmin()
		if (serverguard.player:HasPermission(self, "Superadmin")) then
			return true;
		end;

		return self:sgIsSuperAdmin();
	end;

	--
	-- Override IsUserGroup to check serverguard rank.
	--

	function playerMeta:IsUserGroup(name)
		if (serverguard.player:GetRank(self) == name) then
			return true;
		end;

		return self:sgIsUserGroup(name)
	end;

	--
	-- Override GetUserGroup to check serverguard rank.
	--

	function playerMeta:GetUserGroup()
		return serverguard.player:GetRank(self);
	end;

	--
	-- Override Ban to use serverguard ban.
	--

	function playerMeta:Ban(length, bKick, reason)
		reason = reason or "No Reason";

		serverguard:BanPlayer(nil, self, length, reason, bKick);
	end;
end;
