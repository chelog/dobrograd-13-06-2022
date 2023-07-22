--[[---------------------------------------------------------------------------
DarkRP disabled defaults
---------------------------------------------------------------------------

DarkRP comes with a bunch of default things:
	- a load of modules
	- default jobs
	- shipments and guns
	- entities (like the money printer)
	and many more

If you want to disable or replace the default things, you should disable them here

Note: if you want to have e.g. edit the official medic job, you MUST disable the default one in this file!
You can copy the medic from DarkRP and paste it in darkrp_config/jobs.lua
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults = DarkRP.disabledDefaults or {}

--[[---------------------------------------------------------------------------
The list of modules that are disabled. Set to true to disable, false to enable.
Modules that are not in this list are enabled by default.
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults["modules"] = {
	["fpp"]			  = false,
	["hud"]			  = false,
	["hungermod"]		= false,
	["playerscale"]	  = false,
}

--[[---------------------------------------------------------------------------
Shipments and pistols
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults["shipments"] = {
	["AK47"]		 = true,
	["Desert eagle"] = true,
	["Fiveseven"]	= true,
	["Glock"]		= true,
	["M4"]		   = true,
	["Mac 10"]	   = true,
	["MP5"]		  = true,
	["P228"]		 = true,
	["Pump shotgun"] = true,
	["Sniper rifle"] = true,
}

--[[---------------------------------------------------------------------------
Entities
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults["entities"] = {
	["Drug lab"]	  = true,
	["Gun lab"]	   = true,
	["Money printer"] = true,
	["Microwave"]	 = true, --Hungermod only
}

--[[---------------------------------------------------------------------------
Vehicles
(at the moment there are no default vehicles)
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults["vehicles"] = {

}

--[[---------------------------------------------------------------------------
Food
Food is only enabled when hungermod is enabled (see disabled modules above).
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults["food"] = {
	["Banana"]		   = true,
	["Bunch of bananas"] = true,
	["Melon"]			= true,
	["Glass bottle"]	 = true,
	["Pop can"]		  = true,
	["Plastic bottle"]   = true,
	["Milk"]			 = true,
	["Bottle 1"]		 = true,
	["Bottle 2"]		 = true,
	["Bottle 3"]		 = true,
	["Orange"]		   = true,
}

--[[---------------------------------------------------------------------------
Door groups
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults["doorgroups"] = {
	["Cops and Mayor only"] = true,
	["Gundealer only"]	  = true,
}


--[[---------------------------------------------------------------------------
Ammo packets
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults["ammo"] = {
	["Pistol ammo"]  = true,
	["Rifle ammo"]   = true,
	["Shotgun ammo"] = true,
}

--[[---------------------------------------------------------------------------
Agendas
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults["agendas"] = {
	["Gangster's agenda"] = true,
	["Police agenda"] = true,
}

--[[---------------------------------------------------------------------------
Chat groups (chat with /g)
Chat groups do not have names, so their index is used instead.
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults["groupchat"] = {
	[1] = true, -- Police group chat (mayor, cp, chief and/or your custom CP teams)
	[2] = true, -- Group chat between gangsters and the mobboss
	[3] = true, -- Group chat between people of the same team
}

--[[---------------------------------------------------------------------------
Demote groups
When anyone is demote from any job in this group, they will be temporarily banned
from every job in the group
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults["demotegroups"] = {
	["Cops"]		 = false,
	["Gangsters"]	 = false,
}