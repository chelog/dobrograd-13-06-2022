simfphys = simfphys or {}
simfphys.gMultiplier = 66 / (1 / engine.TickInterval())

if SERVER then
	AddCSLuaFile("simfphys/client/killicons.lua")
	AddCSLuaFile("simfphys/client/fonts.lua")
	AddCSLuaFile("simfphys/client/tab.lua")
	AddCSLuaFile("simfphys/client/hud.lua")
	AddCSLuaFile("simfphys/client/seatcontrols.lua")
	AddCSLuaFile("simfphys/client/lighting.lua")
	AddCSLuaFile("simfphys/client/damage.lua")
	AddCSLuaFile("simfphys/client/poseparameter.lua")

	AddCSLuaFile("simfphys/anim.lua")
	AddCSLuaFile("simfphys/attachments.lua")
	AddCSLuaFile("simfphys/base_functions.lua")
	AddCSLuaFile("simfphys/rescuespawnlists.lua")
	AddCSLuaFile("simfphys/base_lights.lua")
	AddCSLuaFile("simfphys/base_vehicles.lua")
	AddCSLuaFile("simfphys/view.lua")
	AddCSLuaFile("simfphys/misc.lua")

	include("simfphys/base_functions.lua")
	include("simfphys/server/exitpoints.lua")
	include("simfphys/server/spawner.lua")
	include("simfphys/server/seatcontrols.lua")
	include("simfphys/server/damage.lua")
	include("simfphys/server/poseparameter.lua")
	-- include("simfphys/server/joystick.lua")
	include("simfphys/attachments.lua")
	include("simfphys/server/octothorp.lua")
	include("simfphys/server/tow.lua")
end

if CLIENT then
	include("simfphys/base_functions.lua")
	include("simfphys/client/killicons.lua")
	include("simfphys/client/fonts.lua")
	include("simfphys/client/tab.lua")
	include("simfphys/client/hud.lua")
	include("simfphys/client/seatcontrols.lua")
	include("simfphys/client/lighting.lua")
	include("simfphys/client/damage.lua")
	include("simfphys/client/poseparameter.lua")
	include("simfphys/attachments.lua")
end

include("simfphys/anim.lua")
include("simfphys/base_lights.lua")
include("simfphys/base_vehicles.lua")
include("simfphys/view.lua")
include("simfphys/misc.lua")

timer.Simple( 0.5, function()
	include("simfphys/rescuespawnlists.lua")
end)
