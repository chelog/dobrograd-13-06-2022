SWEP.Base						= "weapon_octo_base_air"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Bean Bag"

if SERVER then
	AddCSLuaFile()
end

SWEP.Primary.Sound 				= Sound( "beanbag.fire" )
SWEP.Primary.Automatic		= false
SWEP.Primary.Damage				= 1
SWEP.Primary.RPM				= 70
SWEP.Primary.ClipSize			= 4
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 5.28
SWEP.Primary.KickDown		   = 0.3
SWEP.Primary.KickHorizontal	 = 0.03
SWEP.Primary.Spread			 = 0.1
SWEP.Primary.Distance			= 500

SWEP.WorldModel					= "models/weapons/w_shot_m3super90_beanbag.mdl"
SWEP.AimPos = Vector(-5, -0.94, 4.6)
SWEP.AimAng = Angle(-9, 0, 0)

SWEP.Primary.NumShots			= 1
SWEP.Icon = "octoteam/icons/gun_shotgun.png"

SWEP.CanScare						= true
SWEP.IsLethal						= true

if SERVER then
	function SWEP:BulletHitCallback(trace, bullet)
		local ent = trace.Entity
		if not IsValid(ent) or not ent:IsPlayer() then return end

		ent:MoveModifier('stunstick', {
			walkmul = 0.1,
			norun = true,
			nojump = true,
		})

		timer.Create('stunstick' .. ent:EntIndex(), 5, 1, function()
			if not IsValid(ent) then return end
			ent:MoveModifier('stunstick', nil)
		end)
	end

end
