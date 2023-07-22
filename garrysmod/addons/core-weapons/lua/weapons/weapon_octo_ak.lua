SWEP.Base						= "weapon_octo_base_rifle"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "AK"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "ak47.fire" )
SWEP.Primary.DistantSound 		= Sound( "ak47.fire-distant" )
SWEP.Primary.Damage				= 22
SWEP.Primary.RPM				= 850
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 0
SWEP.Primary.KickDown			= 1.2
SWEP.Primary.KickHorizontal		= 0.8


SWEP.WorldModel					= "models/weapons/w_rif_ak47.mdl"
SWEP.AimPos = Vector(-4, -1.03, 5.2)
SWEP.AimAng = Angle(-9, 0, 0)
