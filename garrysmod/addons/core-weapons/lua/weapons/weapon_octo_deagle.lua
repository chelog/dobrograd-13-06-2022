SWEP.Base						= "weapon_octo_base_pistol"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Desert Eagle"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "deagle.fire" )
SWEP.Primary.DistantSound 		= Sound( "deagle.fire-distant" )
SWEP.Primary.Damage				= 35
SWEP.Primary.RPM				= 300
SWEP.Primary.ClipSize			= 7
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 3.24
SWEP.Primary.KickDown			= 0.72
SWEP.Primary.KickHorizontal		= 0.01

SWEP.WorldModel					= "models/weapons/w_pist_deagle.mdl"
SWEP.AimPos = Vector(-10.5, -1.28, 4.5)
SWEP.AimAng = Angle(-2, 5, 0)
