--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin.name = "Votes";
plugin.author = "duck";
plugin.version = "0.1";
plugin.description = "Adds various commands for voting.";
plugin.permissions = {"Custom Vote"};

serverguard.phrase:Add("english", "command_vote", {
	SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " has started a vote."
});

serverguard.phrase:Add("english", "vote_winner", {
	SERVERGUARD.NOTIFY.WHITE, "Option ", SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " has won the vote (%d/", "%d)"
});

serverguard.phrase:Add("english", "vote_tied", {
	SERVERGUARD.NOTIFY.WHITE, "The vote was inconclusive."
});

serverguard.phrase:Add("english", "vote_tied_random", {
	SERVERGUARD.NOTIFY.WHITE, "The vote was inconclusive. Option ", SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE,
	" was randomly selected as the winner."
});

serverguard.phrase:Add("english", "vote_in_progress", {
	SERVERGUARD.NOTIFY.RED, "There is already a vote in progress."
});