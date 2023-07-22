--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin.name = "Reserved Slots";
plugin.author = "fangli";
plugin.version = "1.0";
plugin.description = "Set up reserved slots";
plugin.permissions = {"Manage Reserved Slots"};
plugin.toggled = false;

local config = serverguard.config.Create("reservedslots");
	config:SetPermission("Manage Reserved Slots");
	config:AddBoolean("hide", false, "Hide reserved slots");
	config:AddNumber("slots", 2, "Amount of reserved slots");
plugin.config = config:Load();