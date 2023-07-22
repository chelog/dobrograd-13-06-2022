--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin.name = "MOTD";
plugin.author = "`impulse";
plugin.version = "1.0";
plugin.description = "An MOTD that is displayed when a player joins the server.";
plugin.permissions = {"Manage MOTD"};
plugin.toggled = false;
plugin.config = {
	{uniqueID = "Unlock Type", description = "Changes how the MOTD closes", default = "slider"},
	{uniqueID = "URL", description = "The website to load when opened", default = ""},
	{uniqueID = "Delay", description = "How long you need to wait before you can close the MOTD", default = 0}
};