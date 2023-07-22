--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

local command = {};

command.help				= "Create a vote.";
command.command 			= "vote";
command.arguments			= {"title"};
command.optionalArguments 	= {"options"};
command.permissions			= "Custom Vote";

function command:Execute(player, silent, arguments)
	local title = arguments[1];

	table.remove(arguments, 1);

	if (!plugin:CreateVote(title, arguments, nil, true)) then		
		serverguard.Notify(nil, SGPF("command_vote", serverguard.player:GetName(player)));
	else
		serverguard.Notify(player, SGPF("vote_in_progress"));
	end;
end;

plugin:AddCommand(command);

local command = {};

command.help				= "Create a map vote.";
command.command 			= "votemap";
command.arguments			= {"options"};
command.permissions			= "Vote Map";

function command:Execute(player, silent, arguments)
	if (!plugin:CreateVote("Vote for the next map", arguments, function(option)
			timer.Simple(3, function()
				RunConsoleCommand("changelevel", option);
			end);
		end)) then
		
		serverguard.Notify(nil, SGPF("command_vote", serverguard.player:GetName(player)));
	else
		serverguard.Notify(player, SGPF("vote_in_progress"));
	end;
end;

--plugin:AddCommand(command);

local command = {};

command.help				= "Create a vote to kick a player.";
command.command 			= "votekick";
command.arguments			= {"player"};
command.permissions			= "Vote Kick";

function command:Execute(player, silent, arguments)
	local target = util.FindPlayer(arguments[1], player);

	if (IsValid(target) and util.PlayerMatchesImmunity(SERVERGUARD.IMMUNITY.LESS, player, target)) then
		if (!plugin:CreateVote("Kick "..target:Name().."?", {}, function(option)
				if (option == "Yes") then
					game.ConsoleCommand("kickid " .. target:UserID() .. " " .. reason .. "\n");
				end;
			end, true)) then
			
			serverguard.Notify(nil, SGPF("command_vote", serverguard.player:GetName(player)));
		else
			serverguard.Notify(player, SGPF("vote_in_progress"));
		end;
	else
		serverguard.Notify(player, SGPF("player_higher_immunity"));
	end;
end;

--plugin:AddCommand(command);

local command = {};

command.help				= "Create a vote to ban a player.";
command.command 			= "voteban";
command.arguments			= {"player"};
command.permissions			= "Vote Ban";

function command:Execute(player, silent, arguments)
	local target = util.FindPlayer(arguments[1], player);

	if (IsValid(target) and util.PlayerMatchesImmunity(SERVERGUARD.IMMUNITY.LESS, player, target)) then
		if (!plugin:CreateVote("Ban "..target:Name().." for 30 minutes?", {}, function(option)
				if (option == "Yes") then
					serverguard:BanPlayer(nil, target, 30, "Vote Ban");
				end;
			end, true)) then
			
			serverguard.Notify(nil, SGPF("command_vote", serverguard.player:GetName(player)));
		else
			serverguard.Notify(player, SGPF("vote_in_progress"));
		end;
	else
		serverguard.Notify(player, SGPF("player_higher_immunity"));
	end;
end;

--plugin:AddCommand(command);