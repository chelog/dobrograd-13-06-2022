SWEP.Base						= "weapon_octo_base_pistol"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "USP-S"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "usps.fire" )
SWEP.Primary.DistantSound 		= Sound( "usps.fire-distant" )
SWEP.Primary.Damage				= 21
SWEP.Primary.RPM				= 825
SWEP.Primary.ClipSize			= 12
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 1.7
SWEP.Primary.KickDown		   = 0.3
SWEP.Primary.KickHorizontal	 = 0.03

SWEP.WorldModel					= "models/weapons/w_pist_usp_silencer.mdl"
SWEP.AimPos = Vector(-10.5, -1.13, 4.05)
SWEP.AimAng = Angle(-2, 5, 0)

SWEP.NoMuzzleflash = true
