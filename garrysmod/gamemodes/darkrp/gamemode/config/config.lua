--[[-------------------------------------------------------------------------
DarkRP config settings.
-----------------------------------------------------------------------------

This is the settings file of DarkRP. Every DarkRP setting is listed here.

Warning:
If this file is missing settings (because of e.g. an update), DarkRP will assume default values for these settings.
You need not worry about updating this file. If a new setting is added you can manually add them to this file.
---------------------------------------------------------------------------]]


--[[
Toggle settings.
Set to true or false.
]]

-- voice3D - Enable/disable 3DVoice is enabled.
GM.Config.voice3D					   = true
-- AdminsCopWeapons - Enable/disable admins spawning with cop weapons.
GM.Config.AdminsCopWeapons			  = false
-- adminBypassJobCustomCheck - Enable/disable whether an admin can force set a job with whenever customCheck returns false.
GM.Config.adminBypassJobRestrictions	= true
-- allowrpnames - Allow Players to Set their RP names using the /rpname command.
GM.Config.allowrpnames				  = true
-- allowsprays - Enable/disable the use of sprays on the server.
GM.Config.allowsprays				   = false
-- allowvnocollide - Enable/disable the ability to no-collide a vehicle (for security).
GM.Config.allowvnocollide			   = false
-- canforcedooropen - whether players can force an unownable door open with lockpick or battering ram or w/e.
GM.Config.canforcedooropen			  = true
-- copscanunfreeze - Enable/disable the ability of cops to unfreeze other people's props.
GM.Config.copscanunfreeze			   = false
-- copscanunweld - Enable/disable the ability of cops to unweld other people's props.
GM.Config.copscanunweld				 = false
-- currencyLeft - The position of the currency symbol. true for left, false for right.
GM.Config.currencyLeft				  = false
-- deathblack - Whether or not a player sees black on death.
GM.Config.deathblack					= false
-- showdeaths - Display kill information in the upper right corner of everyone's screen.
GM.Config.showdeaths					= false
-- deadvoice - Enable/disable whether people talk through the microphone while dead.
GM.Config.deadvoice					 = false
-- deathpov - Enable/disable whether people see their death in first person view.
GM.Config.deathpov					  = true
-- disallowClientsideScripts - Clientside scripts can be very useful for customizing the HUD or to aid in building. This option bans those scripts.
GM.Config.disallowClientsideScripts	 = true
-- doorwarrants - Enable/disable Warrant requirement to enter property.
GM.Config.doorwarrants				  = false
-- Whether players can drop the weapons they spawn with.
GM.Config.dropspawnedweapons			= false
-- dynamicvoice - Enable/disable whether only people in the same room as you can hear your mic.
GM.Config.dynamicvoice				  = true
-- enforceplayermodel - Whether or not to force players to use their role-defined character models.
GM.Config.enforceplayermodel			= true
-- ironshoot - Enable/disable whether people need iron sights to shoot.
GM.Config.ironshoot					 = true
-- license - Enable/disable People need a license to be able to pick up guns.
GM.Config.license					   = false
-- lockdown - Enable/Disable initiating lockdowns for mayors.
GM.Config.lockdown					  = true
-- norespawn - Enable/Disable that people don't have to respawn when they change job.
GM.Config.norespawn					 = true
-- proppaying - Whether or not players should pay for spawning props.
GM.Config.proppaying					= false
-- propspawning - Enable/disable props spawning. Applies to admins too.
GM.Config.propspawning				  = true
-- respawninjail - Enable/disable whether people can respawn in jail when they die.
GM.Config.respawninjail				 = true
-- restrictdrop - Enable/disable restricting the weapons players can drop. Setting this to true disallows weapons from shipments from being dropped.
GM.Config.restrictdrop				  = false
-- revokeLicenseOnJobChange - Whether licenses are revoked when a player changes jobs.
GM.Config.revokeLicenseOnJobChange	  = true
-- shouldResetLaws - Enable/Disable resetting the laws back to the default law set when the mayor changes.
GM.Config.shouldResetLaws			   = true
-- strictsuicide - Whether or not players should spawn where they suicided.
GM.Config.strictsuicide				 = false
-- telefromjail - Enable/disable teleporting from jail.
GM.Config.telefromjail				  = true
-- unlockdoorsonstart - Enable/Disable unlocking all doors on map start.
GM.Config.unlockdoorsonstart			= false
-- voiceradius - Enable/disable local voice chat.
GM.Config.voiceradius				   = true

--[[
Value settings
]]
-- adminnpcs - Whether or not NPCs should be admin only. 0 = everyone, 1 = admin or higher, 2 = superadmin or higher, 3 = rcon only
GM.Config.adminnpcs					 = 0
-- adminsents - Whether or not SENTs should be admin only. 0 = everyone, 1 = admin or higher, 2 = superadmin or higher, 3 = rcon only
GM.Config.adminsents					= 0
-- adminvehicles - Whether or not vehicles should be admin only. 0 = everyone, 1 = admin or higher, 2 = superadmin or higher, 3 = rcon only
GM.Config.adminvehicles				 = 0
-- adminweapons - Who can spawn weapons: 0: admins only, 1: supadmins only, 2: no one
GM.Config.adminweapons				  = 1
-- arrestspeed - Sets the max arrest speed.
GM.Config.arrestspeed				   = 240
-- demotetime - Number of seconds before a player can rejoin a team after demotion from that team.
GM.Config.demotetime					= 120
-- doorcost - Sets the cost of a door.
GM.Config.doorcost					  = 50
-- jailtimer - Sets the jailtimer (in seconds).
GM.Config.jailtimer					 = 1800
-- lockdowndelay - The amount of time a mayor must wait before starting the next lockdown.
GM.Config.lockdowndelay				 = 120
-- maxlawboards - The maximum number of law boards the mayor can place.
GM.Config.maxlawboards				  = 2
-- maxlotterycost - Maximum payment the mayor can set to join a lottery.
GM.Config.maxlotterycost				= 7500
-- minlotterycost - Minimum payment the mayor can set to join a lottery.
GM.Config.minlotterycost				= 1500
-- normalsalary - Sets the starting salary for newly joined players.
GM.Config.normalsalary				  = 500
-- npckillpay - Sets the money given for each NPC kill.
GM.Config.npckillpay					= 0
-- paydelay - Sets how long it takes before people get salary.
GM.Config.paydelay					  = 600
-- propcost - How much prop spawning should cost (prop paying must be enabled for this to have an effect).
GM.Config.propcost					  = 10
-- respawntime - Minimum amount of seconds a player has to wait before respawning.
GM.Config.respawntime				   = 1
-- changejobtime - Minimum amount of seconds a player has to wait before changing job.
GM.Config.changejobtime				 = 390
-- runspeed - Sets the max running speed.
GM.Config.runspeed					  = 185
-- runspeed - Sets the max running speed for CP teams.
GM.Config.runspeedcp					= 195
-- searchtime - Number of seconds for which a search warrant is valid.
GM.Config.searchtime					= 30
-- startinghealth - the health when you spawn.
GM.Config.startinghealth				= 100
-- startingmoney - your wallet when you join for the first time.
GM.Config.startingmoney				 = 0
-- wantedtime - Number of seconds for which a player is wanted for.
GM.Config.wantedtime					= 7200
-- walkspeed - Sets the max walking speed.
GM.Config.walkspeed					 = 80
-- propertytaxcoeff - The multiplier of property tax (formula: propertytaxcoeff * (sum of all prices)
GM.Config.propertytaxcoeff			  = 0.1

--[[---------------------------------------------------------------------------
Other settings
---------------------------------------------------------------------------]]

-- You can set your own, custom sound to be played for all players whenever a lockdown is initiated.
-- Note: Remember to include the folder where the sound file is located.
GM.Config.lockdownsound = "dbg/lockdown.ogg"

-- The skin DarkRP uses. Set to "default" to use the GMod default derma theme.
GM.Config.currency = "P"

-- The list of weapons that players are not allowed to drop. Items set to true are not allowed to be dropped.
GM.Config.DisallowDrop = {
	["arrest_stick"] = true,
	["door_ram"] = true,
	-- ["gmod_camera"] = true,
	["gmod_tool"] = true,
	["keys"] = true,
	["dbg_hands"] = true,
	["dbg_admingun"] = true,
	["lockpick"] = false,
	["med_kit"] = true,
	["pocket"] = true,
	["stunstick"] = true,
	["unarrest_stick"] = true,
	["weapon_keypadchecker"] = true,
	['dbg_punisher'] = true,
	["weapon_physcannon"] = true,
	["weapon_physgun"] = true,
	["weaponchecker"] = true,
	["weapon_fists"] = true,
	["weapon_cuffed"] = true,
	["realsnow"] = true,
	["weapon_zombie"] = true,
	["dbg_cigarette"] = true,
	["weapon_simfillerpistol"] = true,
	["weapon_flashlight_uv"] = true,
}

-- The list of weapons people spawn with.
GM.Config.DefaultWeapons = {
	-- "keys",
	"dbg_hands",
	-- "weapon_physcannon",
	"gmod_tool",
	"weapon_physgun",
	-- "weapon_fists",
	-- "realsnow",
}

-- The list of weapons admins spawn with, in addition to the default weapons, a job's weapons and GM.Config.AdminsCopWeapons.
GM.Config.AdminWeapons = {
	"weapon_keypadchecker",
	'dbg_punisher',
	-- "dbg_admingun",
}

-- These are the default laws, they're unchangeable in-game.
GM.Config.DefaultLaws = {
	-- L.defaultlaw
}

-- Properties set to true are allowed to be used. Values set to false or are missing from this list are blocked.
GM.Config.allowedProperties = {
	remover = true,
	ignite = false,
	extinguish = true,
	keepupright = false,
	gravity = false,
	collision = true,
	skin = true,
	bodygroups = true,
	rb655_make_animatable = true,
}

--[[---------------------------------------------------------------------------
Hungermod module
---------------------------------------------------------------------------]]
-- hungerspeed <Amount> - Set the rate at which players will become hungry (2 is the default).
GM.Config.hungerspeed = 0.30
-- starverate <Amount> - How much health that is taken away every second the player is starving  (3 is the default).
GM.Config.starverate = 1
