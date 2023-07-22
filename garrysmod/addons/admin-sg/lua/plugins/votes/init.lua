--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin.tally = {};

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("sh_commands.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);

function plugin:CreateVote(title, options, callback, bDefaultOptions, bRandomWinner)
	if (!plugin.vote) then
		if (#options < 2 and bDefaultOptions) then
			table.insert(options, "Yes");
			table.insert(options, "No");
		end;

		plugin.vote = {
			title = title,
			options = options
		};

		serverguard.netstream.Start(nil, "CreateVote", plugin.vote);

		timer.Simple(16.5, function()
			local option = table.GetWinningKey(plugin.tally);

			if (!option) then
				if (bRandomWinner) then
					local winner = table.Random(plugin.vote.options);

					serverguard.Notify(nil, SGPF("vote_tied_random", winner));

					if (callback) then
						callback(winner);
					end;

					plugin.vote = nil;
					plugin.tally = {};

					return;
				end

				serverguard.Notify(nil, SGPF("vote_tied"));

				plugin.vote = nil;
				plugin.tally = {};

				return;
			end

			local optionText = plugin.vote.options[option];
			local winnerVotes, totalVotes = 0, 0;

			for k, v in pairs(plugin.tally) do
				if (k == option) then
					winnerVotes = v;
				end;

				totalVotes = totalVotes + v;
			end;

			plugin.vote = nil;
			plugin.tally = {};

			for k, v in pairs(player.GetAll()) do
				v.sg_voted = nil;
			end;

			serverguard.Notify(nil, SGPF("vote_winner", optionText, winnerVotes, totalVotes));

			if (callback) then
				callback(optionText, winnerVotes, totalVotes);
			end;
		end);
	else
		return false;
	end;
end;

serverguard.netstream.Hook("CastVote", function(player, data)
	if (plugin.vote and !player.sg_voted and plugin.vote.options[data]) then
		player.sg_voted = true;
		plugin.tally[data] = (plugin.tally[data] or 0) + 1;
	end;
end);