SWEP.Base						= "weapon_octo_base_air"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Пневмат. AK"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.RPM				= 850
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0
SWEP.Primary.KickDown		   = 0.6
SWEP.Primary.KickHorizontal	 = 0.4

SWEP.WorldModel					= "models/weapons/w_rif_ak47.mdl"
SWEP.AimPos = Vector(-4, -1.03, 5.65)
SWEP.AimAng = Angle(-8, 0, 0)
