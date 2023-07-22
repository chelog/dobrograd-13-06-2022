SWEP.Base						= "weapon_octo_base_zoom"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Пневмат. AUG"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo				= "air"
SWEP.Primary.Damage			= 0
SWEP.Primary.Sound 				= Sound( "weapon.BulletImpact" )
SWEP.Primary.DistantSound 		= Sound( "" )
SWEP.Primary.RPM				= 720
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0
SWEP.Primary.KickDown		   = 0.52
SWEP.Primary.KickHorizontal	 = 0.25
SWEP.Primary.Spread				= 0

SWEP.CanScare					= false
SWEP.IsLethal					= false
SWEP.ReloadTime 				= 2.2
SWEP.WorldModel					= "models/weapons/w_rif_aug.mdl"
SWEP.AimPos = Vector(-5, -0.68, 5.5)
SWEP.AimAng = Angle(-8, 0, 0)
SWEP.SightPos = Vector(-3.2, -0.67, 5.87)
SWEP.SightAng = Angle(0, -90, 100)
SWEP.SightSize = 1
SWEP.SightFOV = 18
