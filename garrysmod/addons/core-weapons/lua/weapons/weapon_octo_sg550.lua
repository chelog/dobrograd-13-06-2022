SWEP.Base						= "weapon_octo_base_sniper"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "SG550"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "sg550.fire" )
SWEP.Primary.DistantSound 		= Sound( "sg550.fire-distant" )
SWEP.Primary.Damage				= 51
SWEP.Primary.RPM				= 450
SWEP.Primary.ClipSize			= 20
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 0.9
SWEP.Primary.KickDown			= 0.3
SWEP.Primary.KickHorizontal		= 0.03
SWEP.Primary.Spread				= 0

SWEP.WorldModel					= "models/weapons/w_snip_sg550.mdl"
SWEP.Icon = 'octoteam/icons/gun_rifle.png'
SWEP.AimPos = Vector(-3.5, -0.8, 5.2)
SWEP.AimAng = Angle(-9, 0, 0)
SWEP.SightPos = Vector(-1.5, -0.79, 5.41)
SWEP.SightAng = Angle(0, -90, 100)
SWEP.SightSize = 1.3
SWEP.SightFOV = 12
