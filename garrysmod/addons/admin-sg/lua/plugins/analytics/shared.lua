--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin.name = "Analytics";
plugin.author = "alexgrist";
plugin.version = "1.1";
plugin.description = "Provides statistics of users that join the server.";
plugin.permissions = {"Analytics"};

plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);
