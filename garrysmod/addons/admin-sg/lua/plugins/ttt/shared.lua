--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin.name = "Trouble in Terrorist Town";
plugin.author = "duck";
plugin.version = "1.0";
plugin.description = "Adds various commands for TTT.";
plugin.gamemodes = {"terrortown"};

serverguard.phrase:Add("english", "command_aslay", {
	SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " has added ", SERVERGUARD.NOTIFY.RED, "%d", SERVERGUARD.NOTIFY.WHITE, " autoslay(s) to ",
	SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, ". Reason: %s"
});

serverguard.phrase:Add("english", "command_raslay", {
	SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " has removed ", SERVERGUARD.NOTIFY.RED, "%d", SERVERGUARD.NOTIFY.WHITE, " autoslay(s) from ",
	SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "."
});

serverguard.phrase:Add("english", "global_autoslayed", {
	SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, " has been automatically slayed."
});

serverguard.phrase:Add("english", "local_autoslayed", {
	SERVERGUARD.NOTIFY.WHITE, "You have ", SERVERGUARD.NOTIFY.RED, "%d", SERVERGUARD.NOTIFY.WHITE, " autoslay(s) remaining."
});

serverguard.phrase:Add("english", "command_setkarma", {
	SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " has set ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, " karma to ",
	SERVERGUARD.NOTIFY.GREEN, "%d", SERVERGUARD.NOTIFY.WHITE, "."
});

serverguard.phrase:Add("english", "command_setcredits", {
	SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " has set ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, " credits to ",
	SERVERGUARD.NOTIFY.GREEN, "%d", SERVERGUARD.NOTIFY.WHITE, "."
});

serverguard.phrase:Add("english", "command_restartround", {
	SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " has restarted the round."
});

serverguard.phrase:Add("english", "command_setrole", {
	SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " has set ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, " role to ",
	SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, "."
});

serverguard.phrase:Add("english", "killed_by_traitor", {
	SERVERGUARD.NOTIFY.WHITE, "You were killed by ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, ". He was a ", SERVERGUARD.NOTIFY.RED, "traitor",
	SERVERGUARD.NOTIFY.WHITE, "."
});

serverguard.phrase:Add("english", "killed_by_traitor_dna", {
	SERVERGUARD.NOTIFY.WHITE, "You were killed by ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, ". He was a ", SERVERGUARD.NOTIFY.RED, "traitor",
	SERVERGUARD.NOTIFY.WHITE, ", and had your DNA."
});

serverguard.phrase:Add("english", "killed_by_innocent", {
	SERVERGUARD.NOTIFY.WHITE, "You were killed by ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, ". He was ", SERVERGUARD.NOTIFY.GREEN, "innocent",
	SERVERGUARD.NOTIFY.WHITE, "."
});

serverguard.phrase:Add("english", "killed_by_innocent_dna", {
	SERVERGUARD.NOTIFY.WHITE, "You were killed by ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, ". He was ", SERVERGUARD.NOTIFY.GREEN, "innocent",
	SERVERGUARD.NOTIFY.WHITE, ", and had your DNA."
});

serverguard.phrase:Add("english", "invalid_role", {
	SERVERGUARD.NOTIFY.RED, "You must specify a valid role (innocent, detective, traitor)."
});

serverguard.phrase:Add("english", "invalid_number", {
	SERVERGUARD.NOTIFY.RED, "You must specify a valid number."
});

plugin:Hook("OnGamemodeLoaded", "serverguard.ttt.OnGamemodeLoaded", function()
	plugin.roles = {
		traitor = ROLE_TRAITOR,
		innocent = ROLE_INNOCENT,
		detective = ROLE_DETECTIVE
	};
end);