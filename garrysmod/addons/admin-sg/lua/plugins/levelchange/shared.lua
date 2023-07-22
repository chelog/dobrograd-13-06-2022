--[[
	© 2017 Thriving Ventures Ltd do not share, re-distribute or modify
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin

plugin.name = "Change Map"
plugin.author = "zephruz"
plugin.version = "1"
plugin.description = "Adds a visual map/level-change menu for admins."
plugin.permissions = {}

plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT)

plugin.CurrentMap = game.GetMap()
plugin.MapPrefixes = {
		["Sandbox"] = {
			"gm_",
		},
		["Roleplay"] = {
			"rp_",
		},
		["Trouble in Terrorist Town"] = {
			"ttt_",
		},
		["Prop Hunt"] = {
			"ph_",
		},
		["Murder"] = {
			"md_",
			"mu_",
		},
		["Source"] = {
			"cs_",
			"de_",
		},
		["Uncategorized"] = {},
	}