--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

local command = {};

command.help				= "Play a song for the server to listen to.";
command.command 			= "playsong";
command.arguments			= {"url"};
command.optionalArguments 	= {"start time"};
command.permissions			= "Play Song";

function command:Execute(player, silent, arguments)
	local url = arguments[1];
	local time = tonumber(arguments[2]) or 0;

	if (url) then
		serverguard.netstream.Start(nil, "sgSongPlayerPlay", {
			url, time
		});

		if (!silent) then
			serverguard.Notify(player, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " has started playing a song.");
		end;
	else
		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "You have entered an invalid link! Please make sure that it's a valid YouTube link.");
	end;
end;

plugin:AddCommand(command);

local command = {};

command.help		= "Stop any songs currently playing.";
command.command 	= "stopsong";
command.permissions	= "Play Song";

function command:Execute(player, silent, arguments)
	serverguard.netstream.Start(nil, "sgSongPlayerStop", true);

	if (!silent) then
		serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " has stopped the song player.");
	end;
end;

plugin:AddCommand(command);
