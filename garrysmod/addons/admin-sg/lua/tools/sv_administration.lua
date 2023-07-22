--[[
	� 2017 Thriving Ventures Limited do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

serverguard.pollinterval = CreateConVar("serverguard_pollinterval", "0", {FCVAR_PROTECTED, FCVAR_SERVER_CAN_EXECUTE},
	"How often local ban data is synced with the database (in seconds). Set to 0 to disable."
);

function serverguard:playerSend(from, to, force)
	if not to:IsInWorld() and not force then return end;

	if (IsValid(from) and from:IsPlayer() and from:InVehicle()) then
		from:ExitVehicle();
	end;

	local traceTable = {};
	traceTable.start = to:GetPos();
	traceTable.filter = {to, from};

	for i = 1, 4, 1 do
		traceTable.endpos = to:GetPos() + Angle(0, to:EyeAngles().yaw - 180 + 90 * (i - 1), 0):Forward() * 47;
		tr = util.TraceEntity(traceTable, from);
		if !tr.Hit then
			break;
		end;
		if i == 4 and tr.Hit and !force then
			return false;
		end;
	end;

	local result = tr.HitPos or (force and to:GetPos()) or false;

	if (result and IsValid(from) and from:IsPlayer()) then
		from.sg_LastPosition = from:GetPos();
		from.sg_LastAngles = from:EyeAngles();
	end;

	return result;
end;

local jail = {
	{Vector(0, 0, 5), Angle(90, 0, 0)}, 	-- Bottom
	{Vector(0, 0, 100), Angle(90, 0, 0)}, 	-- Top
	{Vector(0, 40, 50), Angle(0, 90, 0)}, 	-- Side
	{Vector(0, -40, 50), Angle(0, 90, 0)}, 	-- Side
	{Vector(40, 0, 50), Angle(0, 0, 0)}, 	-- Side
	{Vector(-40, 0, 50), Angle(0, 0, 0)} 	-- Side
};

--
-- Jail a player.
--

local pieceModel = "models/props_c17/fence01b.mdl";

function serverguard:JailPlayer(player, duration)
	if (IsValid(player) and isnumber(duration)) then
		local pieces = {};

		if (player:InVehicle()) then
			player:ExitVehicle();
		end;

		player:SetMoveType(MOVETYPE_WALK);
		player:SetLocalVelocity(Vector(0, 0, 0));

		for k, v in pairs(jail) do
			local piece = ents.Create("prop_physics");

			piece:SetModel(pieceModel);
			piece:SetPos(player:GetPos() + v[1]);
			piece:SetAngles(v[2]);
			piece:Spawn();
			piece:SetMoveType(MOVETYPE_NONE);
			piece:GetPhysicsObject():EnableMotion(false);
			piece.sg_jail = true;

			table.insert(pieces, piece);
		end;

		-- If one piece gets removed, remove them all.
		for i = 1, #pieces do
			local piece = pieces[i];
			local otherPiece = pieces[i - 1] or pieces[i + 1];

			piece:DeleteOnRemove(otherPiece);
			otherPiece:DeleteOnRemove(piece);
		end;

		player:SetPos(player:GetPos() + Vector(0, 0, 8));
		player:SetNetVar("serverguard_jailed", true);

		player.sg_jail = pieces;
		player.sg_jailLocation = player:GetPos();

		if duration > 0 then
			local timerID = "serverguard.jail.timer_" .. player:UniqueID();
			player.sg_jailTime = duration;
			timer.Create(timerID, duration, 1, function()
				serverguard:UnjailPlayer(player);
			end);
		end;
	end;
end;

--
-- Unjail a player.
--

function serverguard:UnjailPlayer(player)
	if (IsValid(player) and player.sg_jail) then
		for k, v in pairs(player.sg_jail) do
			if (IsValid(v)) then
				v:Remove();
			end;
		end;

		player.sg_jail = nil;
		player.sg_jailLocation = nil;
		player.sg_jailTime = nil;

		local timerID = "serverguard.jail.timer_" .. player:UniqueID()

		if timer.Exists(timerID) then
			timer.Remove(timerID)
		end


		player:SetNetVar("serverguard_jailed", false);
	else
		return false;
	end;
end;

hook.Add("PlayerDisconnected", "serverguard.jail.PlayerDisconnected", function(player)
	if (player.sg_jail) then
		serverguard:UnjailPlayer(player);
	end;
end);

hook.Add("CanPlayerSuicide", "serverguard.jail.CanPlayerSuicide", function(player)
	if (player.sg_jail) then
		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "You can't suicide because you're jailed!");

		return false;
	end;
end);

hook.Add("PhysgunPickup", "serverguard.jail.PhysgunPickup", function(player, entity)
	if (IsValid(entity) and entity.sg_jail or player.sg_jail) then
		return false;
	end;
end);

-- hook.Add("PostGamemodeLoaded", "serverguard.jail.PostGamemodeLoaded", function()
-- 	local playerSpawnHook = GAMEMODE.PlayerSpawn;
-- 	function GAMEMODE:PlayerSpawn(player)
-- 		playerSpawnHook(self, player);
-- 		if (player.sg_jail) then
-- 			player:SetPos(player.sg_jailLocation);
-- 			player:SetMoveType(MOVETYPE_WALK);
-- 		end;
-- 	end;
-- end);

hook.Add("EntityTakeDamage", "serverguard.jail.EntityTakeDamage", function(target, dmgInfo)
	local attacker = dmgInfo:GetAttacker();

	if (IsValid(attacker) and attacker.sg_jail) then
		return true;
	end;
end);

local function JailBlock(player)
	if (IsValid(player) and player.sg_jail) then
		return false;
	end;
end;

hook.Add("PlayerSpawnProp", 		"serverguard.jail.PlayerSpawnProp", 		JailBlock);
hook.Add("PlayerSpawnRagdoll", 		"serverguard.jail.PlayerSpawnRagdoll", 		JailBlock);
hook.Add("PlayerSpawnVehicle", 		"serverguard.jail.PlayerSpawnVehicle", 		JailBlock);
hook.Add("PlayerSpawnSENT", 		"serverguard.jail.PlayerSpawnSENT", 		JailBlock);
hook.Add("PlayerSpawnSWEP", 		"serverguard.jail.PlayerSpawnSWEP", 		JailBlock);
hook.Add("PlayerSpawnEffect", 		"serverguard.jail.PlayerSpawnEffect", 		JailBlock);
hook.Add("PlayerSpawnNPC", 			"serverguard.jail.PlayerSpawnNPC", 			JailBlock);
hook.Add("PlayerSpawnObject", 		"serverguard.jail.PlayerSpawnObject", 		JailBlock);
hook.Add("GravGunPickupAllowed",	"serverguard.jail.GravGunPickupAllowed", 	JailBlock);
hook.Add("GravGunPunt", 			"serverguard.jail.GravGunPunt", 			JailBlock);
hook.Add("OnPhysgunReload",			"serverguard.jail.OnPhysgunReload", 		JailBlock);

--
-- Restrictions.
--

local function RestrictBlock(player)
	if (IsValid(player)) then
		local restrictTime = serverguard.player:GetData(player, "restrictTime");

		if (restrictTime and restrictTime > os.time()) then
			if (!player.nextRestrictNotify or CurTime() > player.nextRestrictNotify) then
				restrictTime = (restrictTime - os.time()) / 60;
				local minutes, text = util.ParseDuration(restrictTime);

				serverguard.Notify(player, SGPF("restricted", text));
				player.nextRestrictNotify = CurTime() + 2;
			end;

			return false;
		end;
	end;
end;

hook.Add("PlayerSpawnProp", 		"serverguard.restrict.PlayerSpawnProp",			RestrictBlock);
hook.Add("PhysgunPickup", 			"serverguard.restrict.PhysgunPickup", 			RestrictBlock);
hook.Add("CanTool", 				"serverguard.restrict.CanTool", 				RestrictBlock);
hook.Add("GravGunPunt", 			"serverguard.restrict.GravGunPunt", 			RestrictBlock);
hook.Add("OnPhysgunReload", 		"serverguard.restrict.OnPhysgunReload", 		RestrictBlock);
hook.Add("PlayerSpawnSENT", 		"serverguard.restrict.PlayerSpawnSENT", 		RestrictBlock);
hook.Add("PlayerSpawnSWEP", 		"serverguard.restrict.PlayerSpawnSWEP", 		RestrictBlock);

--
-- Load the ban data.
--

serverguard.banTable = serverguard.banTable or {};
serverguard.evadeBan = function(ply, v)
	ply:Kick(L.evade_ban)
end

local function LoadBanData()
	timer.Simple(2, function()
		if (hook.Call("serverguard.LoadBanData", nil)) then
			return;
		end;

		local callback = function(result, status, lastID)
			if (type(result) == "table" and #result > 0) then
				for k, v in pairs(result) do
					if (tonumber(v.start_time) == nil or tonumber(v.end_time) == nil) then
						local deleteObj = serverguard.mysql:Delete("serverguard_bans");
							deleteObj:Where("id", v.id);
						deleteObj:Execute();
					elseif (v.end_time and tonumber(v.end_time) != 0 and tonumber(v.end_time) <= os.time()) then
						serverguard:UnbanPlayer(v.steam_id);
					else
						local ply = player.GetBySteamID(v.steam_id)
						if IsValid(ply) then serverguard.evadeBan(ply, v) end
						serverguard.banTable[v.steam_id] = {
							communityID = v.community_id,
							player 		= v.player,
							reason 		= v.reason,
							startTime 	= tonumber(v.start_time),
							endTime 	= tonumber(v.end_time),
							admin 		= v.admin,
							ip			= v.ip_address
						};
					end;
				end;
			end;
		end;

		local queryObj = serverguard.mysql:Select("serverguard_bans");
			queryObj:Callback(callback);
		queryObj:Execute();
	end);
end;

hook.Add("serverguard.mysql.OnConnected", "serverguard_ban.OnConnected", LoadBanData);

cvars.AddChangeCallback("serverguard_pollinterval", function(conVar, oldValue, newValue)
	newValue = tonumber(newValue);

	if (!newValue) then
		ErrorNoHalt("[mysql] Invalid poll interval.\n");
		return;
	elseif (newValue < 0) then
		newValue = 0;
	end;

	if (newValue != 0) then
		if (newValue <= 2) then
			timer.Create("serverguard.mysql.BanPolling", newValue, 0, LoadBanData);
		else
			timer.Create("serverguard.mysql.BanPolling", newValue - 2, 0, LoadBanData);
		end;
	else
		timer.Remove("serverguard.mysql.BanPolling");
	end;
end);

--
-- Check if player is banned.
--

local function CheckPlayerBanned(communityID, ip, serverPassword, enteredPassword, name)
	if (hook.Call("serverguard.ShouldCheckPlayerBanned", nil, communityID, ip, serverPassword, enteredPassword, name) == false) then
		return;
	end;

	local steamID = util.SteamIDFrom64(communityID);
	local data = serverguard.banTable[steamID];

	serverguard.PrintConsole("Player '"..name.."' ["..steamID.."] is attempting to connect.\n");

	if (data) then
		local startTime, endTime = tonumber(data.startTime), tonumber(data.endTime);
		local startText, endText = os.date('%d/%m/%Y - %H:%M:%S', data.startTime), endTime > 0 and os.date('%d/%m/%Y - %H:%M:%S', data.endTime) or '-'

		if (endTime > 0 and endTime <= os.time()) then
			serverguard:UnbanPlayer(steamID);

			serverguard.PrintConsole("Player '"..name.."' ["..steamID.."] ban has expired!\n");
		else
			serverguard.PrintConsole("Player '"..name.."' ["..steamID.."] was kicked for being banned!\n");

			return false, ("Ты заблокирован!\n___\n\nВыдал: %s \nПричина: %s\nДата и время бана: %s\nДата и время разбана: %s\nТвой SteamID: %s\n___\n\nПодать апелляцию: octo.gg/dbg-unban"):format(data.admin, data.reason, startText, endText, steamID);
		end;
	else
		-- Check if the player changed steam account. (Try to match the ip)
		for steamid, info in pairs(serverguard.banTable) do
			if (info.ip != "" and info.ip == ip) then
				if (info.endTime != 0) then
					serverguard:BanPlayer(nil, steamID, (info.endTime - os.time()), info.reason);
				else
					serverguard:BanPlayer(nil, steamID, 0, info.reason);
				end;

				serverguard.PrintConsole("Player \""..playerName.."\" tried to connect using another steam profile!\n");

				return false, "Banned: "..info.reason;
			end;
		end;
	end;
end;

hook.Add("CheckPassword", "serverguard_ban.CheckPassword", CheckPlayerBanned);

--
-- Name: serverguard:BanPlayer(admin, player, lengthID, reason)
-- Desc: Ban a player.
--

--[[ Internal function to add a ban. --]]
local function BAN_INSERT(steamID, communityID, playerName, reason, startTime, endTime, adminName, ipAddress, noReplicate)
	if (!steamID) then
		return;
	end;


	ipAddress = ipAddress and (ipAddress:gsub(":%d+", "")) or "";

	local data = {
		communityID = communityID,
		player = playerName,
		reason = reason,
		startTime = tonumber(startTime),
		endTime = tonumber(endTime),
		admin = adminName,
		ip = ipAddress
	};
	serverguard.banTable[steamID] = data;

	serverguard.netstream.Start(nil, "sgNewBan", {
		steamID = steamID,
		playerName = data.player,
		length = tonumber(data.endTime) - tonumber(data.startTime),
		reason = data.reason,
		admin = data.admin
	});

	local deleteObj = serverguard.mysql:Delete("serverguard_bans");
		deleteObj:Where("steam_id", steamID);
	deleteObj:Execute();

	local insertObj = serverguard.mysql:Insert("serverguard_bans");
		insertObj:Insert("steam_id", steamID);
		insertObj:Insert("community_id", communityID);
		insertObj:Insert("player", playerName);
		insertObj:Insert("reason", reason);
		insertObj:Insert("start_time", tostring(startTime));
		insertObj:Insert("end_time", tostring(endTime));
		insertObj:Insert("admin", adminName);
		insertObj:Insert("ip_address", ipAddress);
	insertObj:Execute();

	if endTime == 0 and not noReplicate then
		octolib.sendCmdToOthers('replicate-permaban', { steamID, communityID, playerName, reason, startTime, endTime, adminName, ipAddress })
	end
end;

hook.Add('octolib.event:replicate-permaban', 'sg', function(data)
	local steamID, communityID, playerName, reason, startTime, endTime, adminName, ipAddress = unpack(data)
	octolib.msg('Replicating permaban for ' .. steamID)
	BAN_INSERT(steamID, communityID, playerName, reason, startTime, endTime, adminName, ipAddress, true)
	local ply = player.GetBySteamID(steamID)
	if IsValid(ply) then ply:Kick(reason) end
end)

function serverguard:BanPlayer(admin, player, length, reason, bKick, bSilent, adminNameOverride)
	if (!player) then
		return;
	end;

	local bIsConsole = util.IsConsole(admin) or admin == nil;
	local osTime = os.time();
	local startTime = osTime;
	local bShouldKick = true;
	local originalLength = length;
	local length, lengthText, bClamped = util.ParseDuration(length);
	local endTime = osTime + (length * 60);


	if (bIsConsole) then
		admin = NULL;
	else
		local banLimit, banLimitText = util.ParseDuration(serverguard.player:GetBanLimit(admin))
		if (length > serverguard.player:GetBanLimit(admin) and serverguard.player:GetBanLimit(admin) != 0) then
			serverguard.Notify(admin, SGPF("command_ban_exceed_banlimit", banLimitText));
			return;
		end
	end;

	if (length == 0 and tostring(originalLength) != "0") then
		serverguard.Notify(admin, SGPF("command_ban_invalid_duration"));
		return;
	end;

	local adminName = adminNameOverride or bIsConsole and "Console" or admin:IsPlayer() and ('%s [%s]'):format(admin:SteamName(), admin:SteamID()) or "Unknown";

	if (!reason or reason == "") then
		reason = "No Reason";
	end;

	if (bKick != nil) then
		bShouldKick = bKick;
	end;

	if (length == 0) then
		endTime = length;
	end;

	if (type(player) == "Player") then
		if (!hook.Call("serverguard.PlayerBanned", nil, player, length, reason, admin)) then
			if (!bIsConsole) then
				if (serverguard.player:GetImmunity(admin) > serverguard.player:GetImmunity(player)) then
					if ((length == 0) and serverguard.player:GetBanLimit(admin) != 0) then
						serverguard.Notify(admin, SGPF("command_ban_cannot_permaban"));
						return;
					end;

					if (bClamped) then
						serverguard.Notify(admin, SGPF("command_ban_clamped_duration"));
					end;
				else
					serverguard.Notify(admin, SGPF("player_higher_immunity"));
					return;
				end;
			end;

			BAN_INSERT(
				player:SteamID(), player:SteamID64(), player:Name(), reason, startTime, endTime, adminName, (player:IPAddress():gsub(":%d+", ""))
			);

			if (!bSilent) then
				if (length > 0) then
					serverguard.Notify(nil, SGPF("command_ban", adminName, player:Name(), lengthText, reason));
				else
					serverguard.Notify(nil, SGPF("command_ban_perma", adminName, player:Name(), reason));
				end;
			end;

			if (bShouldKick) then
				player:Kick(reason);
			end;
		end;

		return;
	elseif (type(player) == "string") then
		local playerObj = util.FindPlayer(player, nil, true);

		if (IsValid(playerObj)) then
			self:BanPlayer(admin, playerObj, originalLength, reason, bKick, bSilent, adminNameOverride);
			return;
		else
			if (string.find(player, "STEAM_(%d+):(%d+):(%d+)")) then
				local callback = function(result, status, lastID)
					local name = player;
					local immunity = 0;

					if (type(result) == "table" and #result > 0) then
						name = result[1].name;
						immunity = serverguard.ranks:GetVariable(result[1].rank, "immunity");
					end;

					if (!hook.Call("serverguard.PlayerBannedBySteamID", nil, player, length, reason, admin, name)) then
						if (!bIsConsole) then
							if (immunity < serverguard.player:GetImmunity(admin)) then
								if ((length == 0 or length > 604800) and serverguard.player:GetBanLimit(admin) != 0) then
									serverguard.Notify(admin, SGPF("command_ban_cannot_permaban"));
									return;
								end;

								if (bClamped) then
									serverguard.Notify(admin, SGPF("command_ban_clamped_duration"));
								end;
							else
								serverguard.Notify(admin, SGPF("player_higher_immunity"));
								return;
							end;
						end;

						BAN_INSERT(
							player, util.SteamIDTo64(player), name, reason, startTime, endTime, adminName, ""
						);

						if (!bSilent) then
							if (length > 0) then
								serverguard.Notify(nil, SGPF("command_ban", adminName, player, lengthText, reason));
							else
								serverguard.Notify(nil, SGPF("command_ban_perma", adminName, player, reason));
							end;
						end;
					end;
				end;

				local queryObj = serverguard.mysql:Select("serverguard_users");
					queryObj:Where("steam_id", player);
					queryObj:Limit(1);
					queryObj:Callback(callback);
				queryObj:Execute();
				return;
			end;
		end;
	end;
end;

--
-- Unban a player.
--

function serverguard:UnbanPlayer(steamID, admin, reason, noCheck)
	if not noCheck and hook.Call("serverguard.PreventPlayerUnban", nil, steamID, admin, reason) then
		return;
	end;

	serverguard.netstream.Start(nil, "sgRemoveBan", steamID);

	local deleteObj = serverguard.mysql:Delete("serverguard_bans");
		deleteObj:Where("steam_id", steamID);
	deleteObj:Execute();

	if (serverguard.banTable[steamID]) then
		serverguard.banTable[steamID] = nil;
	end;

	hook.Call("serverguard.PlayerUnbanned", nil, steamID, admin);

end;

--
-- Console kicking.
--

local function serverGuard_KickPlayer(player, command, arguments)
	if (util.IsConsole(player)) then
		local target = util.FindPlayer(arguments[1], player)

		if (IsValid(target)) then
			local reason = table.concat(arguments, " ", 2)

			reason = reason or "No Reason"

			serverguard.Notify(nil, SERVERGUARD.NOTIFY.DEFAULT, "Console has kicked '" .. target:Name() .. "'. Reason: " .. reason)

			target:Kick(reason)

			--game.ConsoleCommand("kickid " .. target:UserID() .. " " .. reason .. "\n")
		end
	end
end

concommand.Add("serverguard_kick", serverGuard_KickPlayer)

--
-- Hotfixes
--

serverguard.hotFix = CreateConVar("serverguard_hotfix", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_PROTECTED}, "Whether or not hotfixes are automatically ran");

local function GetHotfixes(callback)
	http.Fetch(SERVERGUARD.ENDPOINT.."hotfix/all", function(body)
		serverguard.hotFixes = util.JSONToTable(body);

		if (serverguard.hotFixes.master and serverguard.hotFix:GetBool()) then
			RunString(serverguard.hotFixes.master, "ServerGuard hotfix master");
		else
			serverguard.PrintConsole("Not running master hotfix, serverguard_hotfix set to 0.\n");
		end;

		if (callback) then
			callback(body);
		end;
	end);
end;

serverguard.hotFixes = {};

hook.Add("Think", "serverguard.fetchHotFixes", function()
	-- GetHotfixes();
	hook.Remove("Think", "serverguard.fetchHotFixes");
end);

concommand.Add("serverguard_hotfix", function(ply, cmd, args)
	if (util.IsConsole(ply) or ply:IsListenServerHost() and istable(serverguard.hotFixes)) then
		if (args[1]) then
			args[1] = args[1]:lower();
		end;

		-- Not found? Get the latest hotfixes and see if it exists there.
		if (not serverguard.hotFixes[args[1]]) then
			GetHotfixes(function()
				if (not serverguard.hotFixes[args[1]]) then
					print("Hotfix not found.");
				else
					RunString(serverguard.hotFixes[args[1]], "ServerGuard hotfix "..args[1]);
				end;
			end);
		else
			RunString(serverguard.hotFixes[args[1]], "ServerGuard hotfix "..args[1]);
		end;
	end;
end);
--
-- Console banning.
--

local function serverGuard_BanPlayer(player, command, arguments)
	if (util.IsConsole(player)) then
		local target = util.FindPlayer(arguments[1], player)

		if (IsValid(target)) then
			local length = tonumber(arguments[2]) * 60;
			local reason = table.concat(arguments, " ", 3);

			reason = reason or "No Reason"

			if (length > 0) then
				local hours = math.Round(length / 3600);

				if (hours >= 1) then
					serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, "Console", SERVERGUARD.NOTIFY.WHITE, " has banned ", SERVERGUARD.NOTIFY.RED, target:Name(), SERVERGUARD.NOTIFY.WHITE, " for ", SERVERGUARD.NOTIFY.RED, tostring(hours), SERVERGUARD.NOTIFY.WHITE, " hour(s). Reason: " .. reason);
				else
					serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, "Console", SERVERGUARD.NOTIFY.WHITE, " has banned ", SERVERGUARD.NOTIFY.RED, target:Name(), SERVERGUARD.NOTIFY.WHITE, " for ", SERVERGUARD.NOTIFY.RED, tostring(math.Round(length / 60)), SERVERGUARD.NOTIFY.WHITE, " minutes(s). Reason: " .. reason);
				end;
			else
				serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, "Console", SERVERGUARD.NOTIFY.WHITE, " has banned ", SERVERGUARD.NOTIFY.RED, target:Name(), SERVERGUARD.NOTIFY.WHITE, ",", SERVERGUARD.NOTIFY.RED, " permanently", SERVERGUARD.NOTIFY.WHITE, ". Reason: " .. reason);
			end;

			serverguard:BanPlayer(player, target, length, reason)
		end
	end
end

concommand.Add("serverguard_ban", serverGuard_BanPlayer)

--
-- The unban command.
--

local function serverGuard_UnbanPlayer(player, command, arguments)
	if (util.IsConsole(player)) then
		local steamID = arguments[1];

		if (serverguard.banTable[steamID]) then
			serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, "Console", SERVERGUARD.NOTIFY.WHITE, " has unbanned ", SERVERGUARD.NOTIFY.RED, serverguard.banTable[steamID].player, SERVERGUARD.NOTIFY.WHITE, ".");

			serverguard:UnbanPlayer(steamID);
		end;
	else
		if (serverguard.player:HasPermission(player, "Unban")) then
			local steamID = arguments[1];

			if (serverguard.banTable[steamID]) then
				serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " has unbanned ", SERVERGUARD.NOTIFY.RED, serverguard.banTable[steamID].player, SERVERGUARD.NOTIFY.WHITE, ".");

				serverguard:UnbanPlayer(steamID, player);
			elseif (!util.IsConsole(player)) then
				serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "No ban entry exists for that Steam ID!");
			end;
		end;
	end;
end;

concommand.Add("serverguard_unban", serverGuard_UnbanPlayer);

--
-- The query command for the bans menu.
--

local function sendBanChunkData(player, banList)
	serverguard.netstream.StartChunked(player, "sgGetBanListChunk", banList);
end;

local function serverGuard_QueryBans(player)
	if (!player.nextBanQuery) then
		player.nextBanQuery = 0;
	end;

	local curTime = CurTime();

	if (player.nextBanQuery < curTime) then
		if (player.banQueryData != nil) then
			serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "Please wait until you finish loading the ban data!");
			return;
		end;

		local banCount = table.Count(serverguard.banTable);
		serverguard.netstream.Start(player, "sgGetBanCount", banCount);

		local banList = {};

		for steamID, data in pairs(serverguard.banTable) do
			banList[#banList + 1] = {
				steamID = steamID,
				playerName = data.player,
				length = tonumber(data.endTime) - tonumber(data.startTime),
				reason = data.reason,
				admin = data.admin
			};
		end;

		if (banCount > 0) then
			sendBanChunkData(player, banList);
		end;

		player.nextBanQuery = curTime + 10;
	else
		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "Please wait " .. math.ceil(player.nextBanQuery - curTime) .. " seconds.")
	end;
end;

concommand.Add("serverguard_rfbans", serverGuard_QueryBans)

--
-- Add a ban for players not on the server.
--

local function serverGuard_AddMenuBan(pPlayer, command, arguments)
	if (serverguard.player:HasPermission(pPlayer, "Ban")) then
		local found = NULL
		local steamID = arguments[1]

		for k, v in ipairs(player.GetAll()) do
			if (v:SteamID() == steamID) then
				if (serverguard.player:GetImmunity(v) >= serverguard.player:GetImmunity(pPlayer)) then
					serverguard.Notify(pPlayer, SERVERGUARD.NOTIFY.RED, "There is a player with this steamID on the server that has a higher immunity than you!")

					return
				else
					found = v

					break
				end
			end
		end

		local length 		= tonumber(arguments[2]) * 60;
		local playerName 	= arguments[3]
		local reason 		= table.concat(arguments, " ", 4)
		local communityID	= "-1"
		local startTime 	= os.time()
		local endTime 		= startTime + length;
		local adminName 	= serverguard.player:GetName(pPlayer)
		local ip 			= ""

		reason = reason or "No Reason"

		if (length == 0) then
			endTime = length;
		end;

		if (IsValid(found)) then
			communityID = found:SteamID64()
			playerName = serverguard.player:GetName(found)
			ip = (found:IPAddress():gsub(":%d+", ""));

			if (length > 0) then
				local hours = math.Round(length / 3600);

				if (hours >= 1) then
					serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(pPlayer), SERVERGUARD.NOTIFY.WHITE, " has banned ", SERVERGUARD.NOTIFY.RED, playerName, SERVERGUARD.NOTIFY.WHITE, " for ", SERVERGUARD.NOTIFY.RED, tostring(hours), SERVERGUARD.NOTIFY.WHITE, " hour(s). Reason: " .. reason);
				else
					serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(pPlayer), SERVERGUARD.NOTIFY.WHITE, " has banned ", SERVERGUARD.NOTIFY.RED, playerName, SERVERGUARD.NOTIFY.WHITE, " for ", SERVERGUARD.NOTIFY.RED, tostring(math.Round(length / 60)), SERVERGUARD.NOTIFY.WHITE, " minute(s). Reason: " .. reason);
				end;
			else
				serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(pPlayer), SERVERGUARD.NOTIFY.WHITE, " has banned ", SERVERGUARD.NOTIFY.RED, playerName, SERVERGUARD.NOTIFY.WHITE, ",", SERVERGUARD.NOTIFY.RED, " permanently", SERVERGUARD.NOTIFY.WHITE, ". Reason: " .. reason);
			end;

			found:Kick(reason)
			--game.ConsoleCommand("kickid " .. found:UserID() .. " " .. reason .. "\n")
		else
			if (length > 0) then
				local hours = math.Round(length / 3600);

				if (hours >= 1) then
					serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(pPlayer), SERVERGUARD.NOTIFY.WHITE, " has banned ", SERVERGUARD.NOTIFY.RED, steamID, SERVERGUARD.NOTIFY.WHITE, " for ", SERVERGUARD.NOTIFY.RED, tostring(hours), SERVERGUARD.NOTIFY.WHITE, " hour(s). Reason: " .. reason);
				else
					serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(pPlayer), SERVERGUARD.NOTIFY.WHITE, " has banned ", SERVERGUARD.NOTIFY.RED, steamID, SERVERGUARD.NOTIFY.WHITE, " for ", SERVERGUARD.NOTIFY.RED, tostring(math.Round(length / 60)), SERVERGUARD.NOTIFY.WHITE, " minute(s). Reason: " .. reason);
				end;
			else
				serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(pPlayer), SERVERGUARD.NOTIFY.WHITE, " has banned ", SERVERGUARD.NOTIFY.RED, steamID, SERVERGUARD.NOTIFY.WHITE, ",", SERVERGUARD.NOTIFY.RED, " permanently", SERVERGUARD.NOTIFY.WHITE, ". Reason: " .. reason);
			end;
		end;

		local insertObj = serverguard.mysql:Insert("serverguard_bans");
			insertObj:Insert("steam_id", steamID);
			insertObj:Insert("community_id", communityID);
			insertObj:Insert("player", playerName);
			insertObj:Insert("reason", reason);
			insertObj:Insert("start_time", tostring(startTime));
			insertObj:Insert("end_time", tostring(endTime));
			insertObj:Insert("admin", adminName);
			insertObj:Insert("ip_address", ip);
		insertObj:Execute();

		local data = {
			communityID = communityID,
			player 		= playerName,
			reason 		= reason,
			startTime 	= startTime,
			endTime 	= endTime,
			admin 		= adminName
		};

		serverguard.netstream.Start(nil, "sgNewBan", {
			steamID = steamID,
			playerName = data.player,
			length = tonumber(data.endTime) - tonumber(data.startTime),
			reason = data.reason,
			admin = data.admin
		});

		serverguard.banTable[steamID] = data;
	end;
end;

concommand.Add("serverguard_addmban", serverGuard_AddMenuBan)

--
-- Edit a players ban.
--
local function serverGuard_EditBan(pPlayer, command, arguments)
	if (serverguard.player:HasPermission(pPlayer, "Edit Ban")) then
		local steamID = arguments[1]

		local length 		= tonumber(arguments[2]) * 60;
		local playerName 	= arguments[3]
		local reason 		= table.concat(arguments, " ", 4)
		local communityID	= "-1"
		local startTime 	= os.time()
		local endTime 		= startTime + length;
		local adminName 	= serverguard.player:GetName(pPlayer)
		local parsedLength, parsedLengthText = util.ParseDuration(arguments[2])

		reason = reason or "No Reason"

		local updateObj = serverguard.mysql:Update("serverguard_bans");
			updateObj:Update("reason", reason);
			updateObj:Update("start_time", tostring(startTime));
			updateObj:Update("end_time", tostring(endTime));
			updateObj:Where("steam_id", steamID);
		updateObj:Execute();

		local data = {
			communityID = communityID,
			player 		= playerName,
			reason 		= reason,
			startTime 	= startTime,
			endTime 	= endTime,
			admin 		= adminName
		};

		serverguard.banTable[steamID] = data;
		serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(pPlayer), SERVERGUARD.NOTIFY.WHITE, " has edited ", SERVERGUARD.NOTIFY.RED, playerName, "'s", SERVERGUARD.NOTIFY.WHITE, " ban. Length: ", SERVERGUARD.NOTIFY.RED, parsedLengthText, SERVERGUARD.NOTIFY.WHITE, " Reason: ", SERVERGUARD.NOTIFY.RED, reason);
	end;
end;
concommand.Add("serverguard_editban", serverGuard_EditBan)


--
-- Import ULX groups, users and bans.
--

local function serverGuard_ImportULX(pPlayer, command, arguments)
	if (util.IsConsole(pPlayer)) then
		if istable(ULib) and type(ULib.parseKeyValues) == "function" and type(ULib.removeCommentHeader) == "function" and type(ULib.fileRead) == "function" then

			-- Reading data

			local ulxUsers, uErr = ULib.parseKeyValues(ULib.removeCommentHeader(ULib.fileRead(ULib.UCL_USERS), "/"))
			local ulxGroups, gErr = ULib.parseKeyValues(ULib.removeCommentHeader(ULib.fileRead(ULib.UCL_GROUPS), "/"))
			local ulxBans, bErr = ULib.parseKeyValues(ULib.removeCommentHeader(ULib.fileRead(ULib.BANS_FILE), "/"))

			if (not ulxUsers) or (not ulxGroups) or (not ulxBans) then
				print("Some of the ULX data files are corrupted or do not exist.")
				return
			end

			-- Importing bans

			print("Importing bans...")

			local c = 0
			for k,v in pairs(ulxBans) do
				local unbanTime = tonumber(v.unban)
				if (unbanTime == 0 or unbanTime > os.time()) then
					BAN_INSERT(
						v.steamID, util.SteamIDTo64(v.steamID), v.name or v.steamID, v.reason, v.time or 0, v.unban or 0, v.admin or "", ""
					)
					c = c + 1
				end
			end

			print(c .. " bans have been imported.")

			-- Importing groups

			print("Importing groups...")

			c = 0
			for k,v in pairs(ulxGroups) do
				local rankData = serverguard.ranks:GetRank(k)
				if (!rankData) then
					serverguard.ranks:AddRank(k, k, 0, Color(100, 150, 245, 255), "",
						{
							Restrictions = {
								["Vehicles"] = 2,
								["Effects"] = 4,
								["Props"] = 128,
								["Ragdolls"] = 1,
								["Npcs"] = 1,
								["Tools"] = {},
								["Sents"] = 4,
								["Balloons"] = 4,
								["Buttons"] = 6,
								["Dynamite"] = 3,
								["Effects"] = 10,
								["Emitters"] = 3,
								["Hoverballs"] = 6,
								["Lamps"] = 2,
								["Lights"] = 2,
								["Thrusters"] = 10,
								["Wheels"] = 10,
							},

							phys_color = Color(77, 255, 255)
						}
					)
					serverguard.ranks:NetworkRank(k);
					serverguard.ranks:SaveTable(k, nil, true);
					c = c + 1
				end
			end

			print(c .. " groups have been imported.")

			-- Importing users

			print("Importing users...")

			c = 0
			for k,v in pairs(ulxUsers) do
				local rankData = serverguard.ranks:GetRank(v.group)
				if (rankData) then
					serverguard.player:SetRank(k, rankData.unique, 0)
					c = c + 1
				end
			end

			print(c .. " users have been imported.")

		else
			print("You must have ULX installed to import bans from it.")
		end
	end
end

concommand.Add("serverguard_importulx", serverGuard_ImportULX)
