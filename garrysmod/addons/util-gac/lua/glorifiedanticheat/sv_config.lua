local CFG = table.Copy(gAC.config or {}) -- for ignoring SV configs, don't remove
gAC.config = {}

--[[
	Hello there and welcome to gAC!
	Here are all the necessary configs for them pesky cheaters to stay off your server!
	Please chose wisely on your decisions to enable/disable configs as
	Every server is unique and may create issues depending on what is on the server.
]]

gAC.config.LICENSE = "LICENSE" -- If you didn't receive a license please contact GlorifiedPig.

-- Tutorial for new gAC users --
--[[
	MySQLOO Table Setup, Simply query this into the SQL query and it should auto generate a table.

	DROP TABLE IF EXISTS `gac_detections`;
	CREATE TABLE `gac_detections` (
		`time` bigint(20) COLLATE utf8_unicode_ci NOT NULL,
		`steamid` text COLLATE utf8_unicode_ci NOT NULL,
		`detection` text COLLATE utf8_unicode_ci NOT NULL,
		`index` int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
	) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
]]
--Note: i will create a function that will be able to gather information on cheat records of a user, for now use this example to create your own command.
--[[
	How to setup cheatlog command.
	targetid = player's SteamID (not 64 ok?)
	pl = person who executed the command.
	data = data retreived from the database
	nameid = player's SteamID + Name like this, Cream (STEAM_0:0:8319238493)

	Example,
	gAC.GetLog( targetid, function(data)
		if isstring(data) then
			gAC.ClientMessage( pl, data, Color( 225, 150, 25 ) )
		else
			if data == {} or data == nil then
				gAC.ClientMessage( pl, nameid .. " has no detections.", Color( 0, 255, 0 ) )
			else
				gAC.PrintMessage(pl, HUD_PRINTCONSOLE, "\n\n")
				gAC.PrintMessage(pl, HUD_PRINTCONSOLE, "Detection Log for " .. nameid .. "\n")
				for k, v in pairs(data) do
					gAC.PrintMessage(pl, HUD_PRINTCONSOLE, os.date( "[%H:%M:%S %p - %d/%m/%Y]", v["time"] ) .. " - " .. v["detection"] .. "\n")
				end
				gAC.ClientMessage( pl, "Look in console.", Color( 0, 255, 0 ) )
			end
		end
	end)
]]

--Recommend sqlite, Recommend mysql if you have more than one server (You must know basic knowledge of SQL programming).
gAC.storage.Type = "sqlite" -- Types: flatfile, sqlite, mysql

-- MySQL Settings ("mysql" module only)
gAC.storage.hostname = "127.0.0.1"
gAC.storage.username = "root"
gAC.storage.password = "root"
gAC.storage.database = "gac"
gAC.storage.port = 3306

gAC.config.IMMUNE_USERS = { -- Set all the people you want to be immune to detections here, SteamID64s only.
   --  "76561198061230671", -- NiceCream, remove me if you want.
}

--[[ DISCORD WEBHOOK SETTINGS ]]--
	gAC.config.ENABLE_DISCORD_WEBHOOK = false
	gAC.config.DISCORD_WEBHOOK_URL = "" -- To find this, right click a discord channel, go to "Edit Channel", click "Webhooks" and then create a new webhook. Copy and paste the URL here.
--[[ DISCORD WEBHOOK SETTINGS END ]]--

--[[ BAN SYSTEM SETTINGS ]]--
	--[[
		Just because some servers want their ban functions to be unique.
		Like they always say, uniqueness is key.

		Ban Types:
			custom - gAC's custom ban system
			ulx - use the ulx ban system
			d3a - use D3vine's ban system
			serverguard - server-guard's ban system
			custom_func - uses BAN_FUNC to ban users, basically make your own ban type

		Kick Types:
			default - normal gAC kick system
			custom_func - uses KICK_FUNC to kick users, basically make your own kick type
	]]
	gAC.config.BAN_MESSAGE_SYNTAX = "AC [g]" -- Syntax for ban messages.

	-- Your ban system must allow access to ban SteamID's
	gAC.config.DELAYEDBANS = true --Delays bans to prevent cheaters from understanding the system
	gAC.config.DELAYEDBANS_TIME = 30 --In seconds, how long to delay the ban

	-- Kick system will only kick those that are online
	gAC.config.DELAYEDKICKS = false --Delays kicks to prevent cheaters from understanding the system
	gAC.config.DELAYEDKICKS_TIME = 30 --In seconds, how long to delay the kick

	local kickThreshold = 2

	-- set to 'custom_func' to use your own custom banning function
	-- set to 'custom' for our custom banning system
	-- set to 'ulx' for ulx, 'serverguard' for ServerGuard, 'd3a' for d3a, 'sam' for SAM
	gAC.config.BAN_TYPE = "custom_func"
	gAC.config.BAN_FUNC = function(ply, banlength, code)
		local msg = 'Античит: ' .. code:gsub('.*(%[Code.-%]).*', '%1')
		octolib.banEverywhere(isstring(ply) and ply or ply:SteamID(), banlength, msg)
	end

	gAC.config.KICK_TYPE = "custom_func" -- set to 'default' for normal kick
	gAC.config.KICK_FUNC = function(ply, code) --only to override the kick function!
		ply.gacKickPoints = (ply.gacKickPoints or 0) + 1
		if ply.gacKickPoints >= kickThreshold then
			local msg =
				'Кажется, какая-то информация не дошла к нам... ' ..
				code:gsub('.*(%[Code.-%]).*', '%1') ..
				' Если это повторяется, обратись к администрации'
			ply:Kick(msg)
		end
	end
--[[ BAN SYSTEM SETTINGS END ]]--

--[[Anti-Cheat vs Player detections]]
	--Checks of gAC was altered by an external source.
	gAC.config.INTEGRITY_CHECKS = true
	gAC.config.INTEGRITY_CHECKS_PUNISHMENT = true
	gAC.config.INTEGRITY_CHECKS_BANTIME = -1
	gAC.config.INTEGRITY_CHECKS_INTERVAL = 60 -- check a player every minute

	--Checks if the player has successfuly loaded with gAC's payload loader.
	--Verification failure means they did not receive the payload in required time.
	gAC.config.PAYLOAD_VERIFY = true
	gAC.config.PAYLOAD_VERIFY_PUNISHMENT = true
	gAC.config.PAYLOAD_VERIFY_TIMELIMIT = 180 --120 seconds to verify or else do an action

	--Checks if the player has successfuly loaded into garrysmod.
	--Verification failure means they did not receive the payload in required time.
	gAC.config.JOIN_VERIFY = true
	gAC.config.JOIN_VERIFY_PUNISHMENT = true
	gAC.config.JOIN_VERIFY_TIMELIMIT = 360 --360 seconds to verify or else do an action
--[[end]]

--[[Server related detections]]
	--[[ BACKOOR EXPLOITATION SETTINGS ]]--
		gAC.config.BACKDOOR_NET_EXPLOIT_CHECKS = true -- Whether or not to check for illegal net messages.

		gAC.config.BACKDOOR_EXPLOITATION_PUNISHMENT = true -- Set to 'true' if you want using net exploits to be punishable.
		gAC.config.BACKDOOR_EXPLOITATION_BANTIME = 0 -- Set to '0' for permban, '-1' for kick and anything above for ban time in minutes.
	--[[ BACKOOR EXPLOITATION SETTINGS END ]]--
--[[end]]

--[[Cheat specific detections]]
	--[[ ANTI CITIZENHACK SETTINGS ]]--
		gAC.config.ENABLE_CITIZENHACK_CHECKS = true -- Set to 'true' to enable citizenhack checks.

		gAC.config.CITIZENHACK_PUNISHMENT = true -- Set to 'true' if you wish to punish players for using citizenhack.
		gAC.config.CITIZENHACK_PUNSIHMENT_BANTIME = 0 -- Set to '0' for permban, '-1' for kick and anything above for ban time in minutes.
	--[[ ANTI CITIZENHACK SETTINGS END ]]--

	--[[ ANTI BigPackets SETTINGS ]]--
		gAC.config.ANTI_BP = false
		gAC.config.BP_PUNISHMENT = true
		gAC.config.BP_BANTIME = 0
	--[[ ANTI BigPackets SETTINGS END ]]--

	--[[ ANTI METH SETTINGS ]]--
		gAC.config.ANTI_METH = true
		gAC.config.METH_PUNISHMENT = true
		gAC.config.METH_BANTIME = 0
	--[[ ANTI METH SETTINGS END ]]--
--[[end]]

--[[General cheating detections]]
	--[[ Lua Execution ]]
		-- This does something, yet, still in development.
		-- WARNING: AntiLua can be CPU intensive depending on how it is configured.
		-- I've tried my best to make this as minimal as possible to reserve resources for the server.
		-- Only use this if your server has enough resources to spare.
		-- Debug data on users detections is sorted in folder gac-antilua as month-day-year
		gAC.config.AntiLua_PUNISHMENT = true
		gAC.config.AntiLua_BANTIME = 0

		-- For how fast you want AntiLua to check code
		-- RequestTimeActive is for when the client is responding with data.
		-- RequestTime is for when the client has no data to send and is idling till new execution.
		gAC.config.AntiLua_RequestTimeActive = 0.25
		gAC.config.AntiLua_RequestTime = 5

		-- If they try to manipulate the network of anti-lua
		gAC.config.AntiLua_Net_PUNISHMENT = true
		gAC.config.AntiLua_Net_BANTIME = 0

		-- If they did not respond to the server in required time
		gAC.config.AntiLua_Fail_PUNISHMENT = true
		gAC.config.AntiLua_Fail_BANTIME = -1
		gAC.config.AntiLua_Fail_TIMEOUT = 240 -- time it takes for them to be considered timed out.

		-- Uses a stronger method of lua verification, using functions to verify an execution.
		-- However this works at a cost of some small amounts of CPU usage server-side.
		-- Verification only checks functions based on their line definitions.
		gAC.config.AntiLua_FunctionVerification = true

		-- Same as above however even further in depth by using a special method of function hashing
		-- WARNING: This has been proven not to work in special cases, please do not turn this on.
		gAC.config.AntiLua_HashFunctionVerification = false

		-- WARNING, Only use this in the event of a lua refresh being necessary.
		-- This will auto reload verifications for a certain file on lua refresh.
		-- This will also make the verification for that specific file to be changed to weak verification for security purposes.
		gAC.config.AntiLua_LuaRefresh = true

		-- for "AntiLua_IgnoreBoot"
		-- This will make it so that the client only starts sending data after the gamemode has loaded
		-- So it makes it so that it's faster for the client to finish up sending all data of executed lua scripts.
		-- However if code is compiled before the gamemode posts, it may cause false detections.
	--[[ Lua Execution End]]

	--[[ ANTI Aim SETTINGS ]]--
		-- WARNING, This detection is untested!
		gAC.config.ANTI_ANTIAIM = false
		gAC.config.ANTIAIM_PUNISHMENT = true
		gAC.config.ANTIAIM_BANTIME = 0
	--[[ ANTI Aim SETTINGS END ]]--

	--[[ ANTI Movement Manipulation SETTINGS ]]--
		-- WARNING, This detection is untested!
		gAC.config.ANTI_MOVEMANIP = false
		gAC.config.MOVEMANIP_PUNISHMENT = true
		gAC.config.MOVEMANIP_BANTIME = 0
	--[[ ANTI Movement Manipulation SETTINGS END ]]--

	--[[ CVAR MANIPULATION SETTINGS ]]
		gAC.config.ALLOWCSLUA_CHECKS = true -- Set to 'true' if you wish to check for sv_allowcslua being set to active.
		gAC.config.SVCHEATS_CHECKS = true -- Set to 'true' if you wish to check for sv_cheats being set to active.
		gAC.config.CVARMANIP_PUNISHMENT = true -- Set to 'true' if you want to punish the player for C-var manipulation.
		gAC.config.CVARMANIP_BANTIME = 0 -- Set to '0' for permban, '-1' for kick and anything above for ban time in minutes.
	--[[ CVAR MANIPULATION SETTINGS END ]]

	--[[ GENERAL MODULE SETTINGS ]]--
		gAC.config.ANTI_NOSPREAD_CHECKS = true -- Set to 'true' if you wish for the anti-nospread module to be enabled.
		gAC.config.BHOP_CHECKS = true -- Set to 'true' if you wish for the anti-bhop module to be enabled.
		gAC.config.KEYBIND_CHECKS = true -- Set to 'true' if you wish for suspicious keybindings to be logged.
		gAC.config.DISABLE_BAD_COMMANDS = true -- Set to 'true' if you wish for sv_allowcslua and sv_cheats to be disabled on server startup.
	--[[ GENERAL MODULE SETTINGS END ]]--
--[[end]]

--[[Account related detections]]
	--[[ ALT DETECT SETTINGS ]]--
		gAC.config.ALT_DETECTION_CHECKS = true -- Set to 'true' if you want to check for alts.

		gAC.config.ALT_DETECTION_NOTIFY_ALTS = true -- Set to 'true' if you want to notify all admins about alts.
		gAC.config.ALT_DETECTION_PUNISHMENT = false -- Set to 'true' if you wish to punish players for having alts.
		gAC.config.ALT_DETECTION_BANTIME = 0 -- Set to '0' for permban, '-1' for kick and anything above for ban time in minutes.
	--[[ ALT DETECT SETTINGS END ]]--

	--[[ FAMILY SHARING CHECK ]]--
	--[[ GUIDE FOR GETTING A STEAM API KEY:
		1. Go to https://steamcommunity.com/dev/apikey
		2. Name the key.
		3. Create the key and paste it below.

		Your key should look something like this: 1369GJ41970G26891B26AGGFAD526B49
	]]--
	gAC.config.STEAM_API_KEY = "" -- Steam API key for the family sharing module.

	gAC.config.ENABLE_FAMILY_SHARE_CHECKS = false -- Whether or not to check if the player is using a family shared account.

	gAC.config.FAMILY_SHARE_PUNISHMENT = false -- Set to 'true' if you want using a family shared account to be punishable.
	gAC.config.FAMILY_SHARE_BANTIME = -1 -- Set to '0' for permban, '-1' for kick and anything above for ban time in minutes.
	--[[ FAMILY SHARING CHECK END ]]--
--[[end]]

--[[ DO NOT TOUCH BELOW THIS LINE ]]--
gAC.config.INTEGRITY_INGORES = {}

for k, v in pairs( gAC.config ) do
	gAC.config.INTEGRITY_INGORES[k] = true
end

table.Merge( gAC.config, CFG )

gAC.DRM_LoadIndexes = {} -- empty table cause i'm too lazy to refactor everything to work around no query file
