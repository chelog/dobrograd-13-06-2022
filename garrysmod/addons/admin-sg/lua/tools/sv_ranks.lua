--[[
	� 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

--
--	Default ranks.	
--	serverguard.ranks:AddRank(unique, name, immunity, color, texture, data)
--

serverguard.ranks:AddRank("user", "Guest", 0, Color(100, 150, 245, 255), "icon16/user.png", {
	Restrictions = {
		["Vehicles"] = 2,
		["Effects"] = 4,
		["Props"] = 128,
		["Ragdolls"] = 1,
		["Npcs"] = 1,
		["Tools"] = {},
		["Sents"] = 4,
		["Balloons"] = 4,
		["Buttons"] = 6,
		["Dynamite"] = 3,
		["Effects"] = 10,
		["Emitters"] = 3,
		["Hoverballs"] = 6,
		["Lamps"] = 2,
		["Lights"] = 2,
		["Thrusters"] = 10,
		["Wheels"] = 10,
	},
	
	phys_color = Color(77, 255, 255)
});

--
--	Administrator groups.
--

serverguard.ranks:AddRank("admin", "Administrator", 20, Color(117, 0, 211), "icon16/award_star_bronze_1.png", {
	Permissions = {
		["Sandbox settings"] = false,
		["Set Rank"] = false,
		["Edit Ranks"] = false,
		["Manage Players"] = true,
		["Extinguish"] = true,
		["Invisible"] = true,
		["Slay"] = true,
		["NPC Target"] = true,
		["Ban"] = true,
		["Edit Ban"] = false,
		["Unban"] = true,
		["Manage Plugins"] = false,
		["Slap"] = true,
		["Set Armor"] = true,
		["Strip Weapons"] = true,
		["Map Restart"] = true,
		["Clear Decals"] = true,
		["Send"] = true,
		["Give Ammo"] = true,
		["Ragdoll"] = true,
		["Goto"] = true,
		["Quick Menu"] = true,
		["Kick"] = true,
		["Spectate"] = true,
		["Screencap"] = false,
		["Ignite"] = true,
		["Server Logs"] = true,
		["Map"] = true,
		["Respawn"] = true,
		["Set Health"] = true,
		["Bring"] = true,
		["Noclip"] = true,
		["Manage Restrictions"] = false,
		["Give Weapon"] = true,
		["Play Song"] = false,
		["Analytics"] = false,
		["God mode"] = true,
		["Manage Advertisements"] = false,
		["Mute"] = true,
		["Announce"] = true,
		["Freeze"] = true,
		["Rcon"] = false,
		["Admin"] = true,
		["Superadmin"] = false,
		["Manage Prop-Protection"] = false,
		["Bypass Prop-Protection"] = true,
		["Physgun Player"] = true,
		["Freeze Props"] = false,
		["Manage MOTD"] = false,
		["Manage Reports"] = true,
		["Bypass Prop Deletion"] = true,
		["Respond to Help Requests"] = true,
		["Return"] = true,
		["Admin Chat"] = true
	},

	Restrictions = {
		["Vehicles"] = 4,
		["Effects"] = 6,
		["Props"] = 256,
		["Ragdolls"] = 4,
		["Npcs"] = 2,
		["Tools"] = {},
		["Sents"] = 8,
		["Balloons"] = 6,
		["Buttons"] = 15,
		["Dynamite"] = 6,
		["Effects"] = 25,
		["Emitters"] = 6,
		["Hoverballs"] = 10,
		["Lamps"] = 6,
		["Lights"] = 6,
		["Thrusters"] = 25,
		["Wheels"] = 25,
	},
	
	phys_color = Color(77, 255, 255)
});

serverguard.ranks:AddRank("superadmin", "Super Administrator", 25, Color(0, 150, 0), "icon16/award_star_silver_1.png", {
	Permissions = {
		["Sandbox settings"] = true,
		["Set Rank"] = false,
		["Edit Ranks"] = false,
		["Manage Players"] = true,
		["Extinguish"] = true,
		["Invisible"] = true,
		["Slay"] = true,
		["NPC Target"] = true,
		["Ban"] = true,
		["Edit Ban"] = true,
		["Unban"] = true,
		["Manage Plugins"] = false,
		["Slap"] = true,
		["Set Armor"] = true,
		["Strip Weapons"] = true,
		["Map Restart"] = true,
		["Clear Decals"] = true,
		["Send"] = true,
		["Give Ammo"] = true,
		["Ragdoll"] = true,
		["Goto"] = true,
		["Quick Menu"] = true,
		["Kick"] = true,
		["Spectate"] = true,
		["Screencap"] = true,
		["Ignite"] = true,
		["Server Logs"] = true,
		["Map"] = true,
		["Respawn"] = true,
		["Set Health"] = true,
		["Bring"] = true,
		["Noclip"] = true,
		["Manage Restrictions"] = false,
		["Give Weapon"] = true,
		["Play Song"] = true,
		["Analytics"] = true,
		["God mode"] = true,
		["Manage Advertisements"] = true,
		["Mute"] = true,
		["Announce"] = true,
		["Freeze"] = true,
		["Rcon"] = false,
		["Superadmin"] = true,
		["Admin"] = true,
		["Manage Prop-Protection"] = true,
		["Bypass Prop-Protection"] = true,
		["Manage Prop Blacklist"] = true,
		["Bypass Prop Blacklist"] = true,
		["Physgun Player"] = true,
		["Freeze Props"] = true,
		["Manage MOTD"] = true,
		["Manage Reports"] = true,
		["Bypass Prop Deletion"] = true,
		["Respond to Help Requests"] = true,
		["Return"] = true,
		["Admin Chat"] = true
	},

	Restrictions = {
		["Vehicles"] = 8,
		["Effects"] = 12,
		["Props"] = 512,
		["Ragdolls"] = 6,
		["Npcs"] = 4,
		["Tools"] = {},
		["Sents"] = 12,
		["Balloons"] = 12,
		["Buttons"] = 30,
		["Dynamite"] = 12,
		["Effects"] = 50,
		["Emitters"] = 12,
		["Hoverballs"] = 20,
		["Lamps"] = 12,
		["Lights"] = 12,
		["Thrusters"] = 50,
		["Wheels"] = 50,
	},
	
	phys_color = Color(77, 255, 255)
});

-- The founder rank is automatically granted all permissions, so no data needs to be set here.
serverguard.ranks:AddRank("founder", "Founder", 99, Color(240, 0, 0), "icon16/award_star_gold_1.png");
