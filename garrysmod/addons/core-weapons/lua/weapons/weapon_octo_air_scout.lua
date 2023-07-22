SWEP.Base						= "weapon_octo_base_sniper"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Пневмат. Scout"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo				= "air"
SWEP.Primary.Sound 				= Sound( "weapon.BulletImpact" )
SWEP.Primary.DistantSound 		= Sound( "" )
SWEP.Primary.Damage				= 0
SWEP.Primary.RPM				= 60
SWEP.Primary.ClipSize			= 10
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 3.35
SWEP.Primary.KickDown			= 0.6
SWEP.Primary.KickHorizontal		= 0.01
SWEP.Primary.Spread				= 0
SWEP.ReloadTime						= 2.2
SWEP.CanScare						= false
SWEP.IsLethal						= false -- shouldn't take karma whet shots fired

SWEP.WorldModel					= "models/weapons/w_snip_scout.mdl"
SWEP.AimPos = Vector(-0.5, -0.98, 5.8)
SWEP.AimAng = Angle(-9, 0, 0)
SWEP.SightPos = Vector(1.6, -0.99, 6.17)
SWEP.SightAng = Angle(0, -90, 100)
SWEP.SightSize = 1.3
SWEP.SightFOV = 10
SWEP.SightZNear = 12
