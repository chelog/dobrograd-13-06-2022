--
-- The respawn command.
--

local command = {};

command.help	= "Respawn a player.";
command.command   = "respawn_g";
command.arguments = {"player"};
command.permissions = "Respawn Ghost";
command.immunity  = SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(_, target, arguments)
	if target:Alive() then target:KillSilent() end
	target:SetNetVar( "_SpawnTime", CurTime() )

	-- Needed for TTT.
	if (target.SpawnForRound) then
		target:SpawnForRound();

		-- Remove their corpse.
		if (IsValid(target.server_ragdoll)) then
			target.server_ragdoll:Remove();
		end;
	end;

	return true;
end;

function command:OnNotify(pPlayer, targets, arguments)
	local amount = util.ToNumber(arguments[2]);

	return SGPF("command_respawn", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets), amount);
end;

function command:ContextMenu(pPlayer, menu, rankData)
	local option = menu:AddOption("Respawn Ghost", function()
		serverguard.command.Run("respawn_g", false, pPlayer:Name());
	end);

	option:SetImage("icon16/user_go.png");
end;

serverguard.command:Add(command);

local command = {};

command.help	= L.retest;
command.command   = "retest";
command.arguments = {"player"};
command.permissions = "Retest";
command.immunity  = SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(_, target, arguments)
	dbgTest.reset(target:SteamID())
	target:Kick(L.retest_hint)

	return true;
end;

function command:ContextMenu(pPlayer, menu, rankData)
	local option = menu:AddOption("Retest", function()
		serverguard.command.Run("retest", false, pPlayer:Name());
	end);

	option:SetImage("icon16/delete.png");
end;

serverguard.command:Add(command);

local command = {};

command.help		= 'Отключить говорилку';
command.command 	= 'goomute';
command.arguments	= {'player'};
command.permissions	= 'Gag';
command.immunity 	= SERVERGUARD.IMMUNITY.LESS;

function command:OnPlayerExecute(_, target)
	target:SetNetVar('govorilka_mute', true)
	target:SetDBVar('govorilka_mute', true)
	return true;
end;

serverguard.command:Add(command);

local command = {};

command.help		= 'Включить говорилку';
command.command	= 'goounmute';
command.arguments	= {'player'};
command.permissions = 'Ungag';
command.immunity	= SERVERGUARD.IMMUNITY.LESS;

function command:OnPlayerExecute(_, target)
	target:SetNetVar('govorilka_mute')
	target:SetDBVar('govorilka_mute')
	return true;
end;

serverguard.command:Add(command);

local servers = {
	pt_dbg = 'Центральный',
	pt_dbg2 = 'Новый',
}

local function playTime(time)
	local h, m, s
	h = math.floor(time / 60 / 60)
	m = math.floor(time / 60) % 60
	s = math.floor(time) % 60
	return string.format('%02i:%02i:%02i', h, m, s)
end

local command = {}
command.help    = 'Get play time on servers'
command.command   = 'ptime'
command.arguments = {'steamid'}
command.permissions = 'Get play time'
command.immunity  = SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:Execute(admin, silent, args)
	if SERVER then
		local steamID = args[1]
		if not octolib.string.isSteamID(steamID) then return end

		local doNotify
		if IsValid(admin) then doNotify = function(msg) admin:Notify(msg) end
		else doNotify = function(msg) octolib.msg(msg) end end

		local doNotify
		if IsValid(admin) then doNotify = function(msg) admin:Notify(msg) end
		else doNotify = function(msg) octolib.msg(msg) end end

		octolib.getDBVar(steamID, 'pt'):Then(function(var)
			doNotify('===== ' .. steamID .. ' =====')
			if not var then
				doNotify('Игрок не появлялся на Доброградах')
				return
			end
			doNotify('Общее время: ' .. playTime(var))
			for serverID, serverName in pairs(servers) do
				octolib.getDBVar(steamID, serverID):Then(function(tp)
					if tp then
						doNotify(serverName .. ': ' .. playTime(tp))
					else
						doNotify(serverName .. ': Не играл')
					end
				end):Catch(function()
					doNotify(serverName .. ': Не играл')
				end)
			end
		end):Catch(function()
			doNotify('Данные не найдены')
		end)
	end

	return true
end

serverguard.command:Add(command)

if CFG.dev then
	local command = {};

	command.help		= 'Рестарт карты';
	command.command	= 'dev-restart';
	command.arguments	= {};

	function command:Execute(ply, silent, arguments)
		if player.GetCount() > 1 then return end
		RunConsoleCommand('_restart')
	end;

	serverguard.command:Add(command);
end
