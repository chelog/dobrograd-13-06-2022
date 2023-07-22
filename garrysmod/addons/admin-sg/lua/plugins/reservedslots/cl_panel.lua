--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local category = {};

category.name = "Reserved slots";
category.material = "serverguard/menuicons/icon_reserved_slots.png";
category.permissions = "Manage Reserved Slots";

function category:Create(base)
	base.panel = base:Add("tiger.panel");
	base.panel:SetTitle("Slot reservation");
	base.panel:Dock(FILL);

	local configList = base.panel:Add("tiger.list");
	configList:SetTall(64);
	configList:Dock(TOP);

	local shouldShowReal = vgui.Create("tiger.checkbox");
	configList:AddPanel(shouldShowReal);

	shouldShowReal:Dock(TOP);
	shouldShowReal:SetText("Hide reserved slots");
	shouldShowReal:BindToConfig("reservedslots", "hide");
	
	local slotsReserved = base.panel:Add("tiger.numslider");
	configList:AddPanel(slotsReserved);

	slotsReserved:Dock(TOP);
	slotsReserved:SetText("Amount of reserved slots");
	slotsReserved:SetMinMax(1, game.MaxPlayers() - 1);
	slotsReserved:SetClampValue(true);
	slotsReserved:SetValue(1);
	slotsReserved:BindToConfig("reservedslots", "slots", true);
end;

plugin:AddSubCategory("Server settings", category);