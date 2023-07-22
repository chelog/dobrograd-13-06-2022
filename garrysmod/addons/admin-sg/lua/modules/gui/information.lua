--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local category = {}

category.name = "Information"
category.material = "serverguard/menuicons/icon_information.png"

function category:Create(categoryBase)

	categoryBase.base = categoryBase:Add("tiger.base");
	categoryBase.base:SetFooterEnabled(false);
	categoryBase.base:UseSmallPanels(true);
	categoryBase.base:Dock(FILL);
	
end

serverguard.menu.AddCategory(category)