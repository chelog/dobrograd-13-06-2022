SWEP.Base						= "weapon_octo_base_smg"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "MAC10"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "mac10.fire" )
SWEP.Primary.DistantSound 		= Sound( "mac10.fire-distant" )
SWEP.Primary.Damage				= 15
SWEP.Primary.RPM				= 1270
SWEP.Primary.ClipSize			= 32
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 0
SWEP.Primary.KickDown			= 0.375
SWEP.Primary.KickHorizontal		= 1.9
SWEP.Primary.Spread			 = 0.08

SWEP.WorldModel					= "models/weapons/w_smg_mac10.mdl"
SWEP.AimPos = Vector(-12, -1.62, 5.2)
SWEP.AimAng = Angle(-2, 5, 0)

SWEP.PassiveHoldType			 = "normal"
SWEP.ActiveHoldType			 = "pistol"
