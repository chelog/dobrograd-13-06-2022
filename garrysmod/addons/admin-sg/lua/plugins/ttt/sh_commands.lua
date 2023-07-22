--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local command = {};

command.help = "Add autoslays to a player.";
command.command = "aslay";
command.arguments = {"player"};
command.optionalArguments = {"amount", "reason"};
command.bSingleTarget = true;
command.immunity = SERVERGUARD.IMMUNITY.LESS;
command.aliases = {"slaynr", "autoslay"};
command.permissions = "SlayNR";

function command:OnPlayerExecute(player, target, arguments)
	local clamped = nil;

	arguments[2] = arguments[2] or 1;
	clamped = math.Clamp((target.sg_autoslays or 0) + arguments[2], 0, 99);
	target.sg_autoslays = clamped;

	local queryObj = serverguard.mysql:Select("serverguard_ttt_autoslays");
		queryObj:Where("steam_id", target:SteamID());
		queryObj:Limit(1);
		queryObj:Callback(function(result, status, lastID)
			if (type(result) == "table" and #result > 0) then
				local updateObj = serverguard.mysql:Update("serverguard_ttt_autoslays");
					updateObj:Update("amount", target.sg_autoslays);
					updateObj:Where("steam_id", target:SteamID());
					updateObj:Limit(1);
				updateObj:Execute();
			else
				local insertObj = serverguard.mysql:Insert("serverguard_ttt_autoslays");
					insertObj:Insert("steam_id", target:SteamID());
					insertObj:Insert("amount", target.sg_autoslays);
				insertObj:Execute();
			end;
		end);
	queryObj:Execute();

	return true;
end;

function command:OnNotify(player, targets, arguments)
	return SGPF("command_aslay", serverguard.player:GetName(player), arguments[2], util.GetNotifyListForTargets(targets), table.concat(arguments, " ", 3));
end;

plugin:AddCommand(command);

local command = {};

command.help = "Remove autoslays from a player.";
command.command = "raslay";
command.arguments = {"player"};
command.optionalArguments = {"amount"};
command.bSingleTarget = true;
command.immunity = SERVERGUARD.IMMUNITY.ANY;
command.aliases = {"raslaynr", "rslaynr"};
command.permissions = "Remove SlayNR";

function command:OnPlayerExecute(player, target, arguments)
	local clamped = nil;

	arguments[2] = arguments[2] or 1;
	clamped = math.Clamp((target.sg_autoslays or 0) - arguments[2], 0, 99);
	target.sg_autoslays = clamped;

	local updateObj = serverguard.mysql:Update("serverguard_ttt_autoslays");
		updateObj:Update("amount", target.sg_autoslays);
		updateObj:Where("steam_id", target:SteamID());
		updateObj:Limit(1);
	updateObj:Execute();

	return true;
end;

function command:OnNotify(player, targets, arguments)
	return SGPF("command_raslay", serverguard.player:GetName(player), arguments[2], util.GetNotifyListForTargets(targets));
end;

plugin:AddCommand(command);

local command = {};

command.help = "Set a player's karma.";
command.command = "setkarma";
command.arguments = {"player"};
command.optionalArguments = {"amount"};
command.immunity = SERVERGUARD.IMMUNITY.LESS;
command.aliases = {"karma"};
command.permissions = "Set Karma";

function command:OnPlayerExecute(player, target, arguments)
	arguments[2] = tonumber(arguments[2]) or 1000;
	target:SetBaseKarma(arguments[2]);
	target:SetLiveKarma(arguments[2]);

	return true;
end;

function command:OnNotify(player, targets, arguments)
	return SGPF("command_setkarma", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets, true), arguments[2]);
end;

plugin:AddCommand(command);

local command = {};

command.help = "Set a player's credits.";
command.command = "setcredits";
command.arguments = {"player", "amount"};
command.immunity = SERVERGUARD.IMMUNITY.ANY;
command.aliases = {"credits"};
command.permissions = "Set Credits";

function command:OnPlayerExecute(player, target, arguments)
	arguments[2] = tonumber(arguments[2]);

	if (arguments[2]) then
		arguments[2] = math.Clamp(arguments[2], 0, 200);
		target:SetCredits(arguments[2]);
		return true;
	end;

	serverguard.Notify(player, SGPF("invalid_number"));
end;

function command:OnNotify(player, targets, arguments)
	return SGPF("command_setcredits", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets, true), arguments[2]);
end;

plugin:AddCommand(command);

local command = {};

command.help = "Set a player's role.";
command.command = "setrole";
command.arguments = {"player", "role"};
command.immunity = SERVERGUARD.IMMUNITY.LESS;
command.bSingleTarget = true;
command.aliases = {"role", "setteam", "team"};
command.permissions = "Set Role";

function command:OnPlayerExecute(player, target, arguments)
	local role = plugin.roles[string.lower(arguments[2])];

	if (role) then
		target:SetRole(role);
		SendFullStateUpdate();
		return true;
	end;

	serverguard.Notify(player, SGPF("invalid_role"));
end;

function command:OnNotify(player, targets, arguments)
	return SGPF("command_setrole", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets, true), arguments[2]);
end;

plugin:AddCommand(command);

local command = {};

command.help = "Restart the round.";
command.command = "restartround";
command.aliases = {"roundrestart"};
command.permissions = "Restart Round";

function command:Execute(player, silent, arguments)
	RunConsoleCommand("ttt_roundrestart");
	serverguard.Notify(nil, SGPF("command_restartround", serverguard.player:GetName(player)));
end;

plugin:AddCommand(command);