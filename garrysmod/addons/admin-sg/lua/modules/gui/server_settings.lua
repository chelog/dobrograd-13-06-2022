--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local category = {}

category.name = "Server settings"
category.material = "serverguard/menuicons/icon_plugins.png"
category.permissions = {"Manage Advertisements", "Manage Chat Settings", "Manage Plugins", "Manage Reserved Slots", "Sandbox settings", "Manage MOTD"}

function category:Create(categoryBase)

	categoryBase.base = categoryBase:Add("tiger.base");
	categoryBase.base:SetFooterEnabled(false);
	categoryBase.base:UseSmallPanels(true);
	categoryBase.base:Dock(FILL);
	
end

serverguard.menu.AddCategory(category)