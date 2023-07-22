--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

local category = {}

category.name = "Lists"
category.material = "serverguard/menuicons/icon_banlist.png"
category.permissions = {"Ban", "Unban", "Set Rank", "Edit Ranks"}

function category:Create(categoryBase)

	categoryBase.base = categoryBase:Add("tiger.base");
	categoryBase.base:SetFooterEnabled(false);
	categoryBase.base:UseSmallPanels(true);
	categoryBase.base:Dock(FILL);

end

serverguard.menu.AddCategory(category)
