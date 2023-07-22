SWEP.Base				= 'weapon_octo_base_cold'
SWEP.Category			= L.dobrograd .. ' - Холодное'
SWEP.Spawnable			= true
SWEP.AdminSpawnable	= false
SWEP.PrintName			= 'Топор'

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo		= 'sharp'
SWEP.HitDistance		= 45
SWEP.HitInclination	= 0.4
SWEP.HitPushback		= 700
SWEP.HitRate			= 1
SWEP.Damage				= {34, 40}
SWEP.ScareMultiplier	= 0.8

SWEP.SwingSound		= Sound('WeaponFrag.Roll')
SWEP.HitSoundWorld	= Sound('Canister.ImpactHard')
SWEP.HitSoundBody		= Sound('Weapon_Knife.Hit')
SWEP.PushSoundBody	= Sound('Flesh.ImpactSoft')

SWEP.Icon				= 'octoteam/icons/gun_axe.png'
SWEP.ViewModel			= Model('models/weapons/HL2meleepack/v_axe.mdl')
SWEP.WorldModel		= Model('models/weapons/HL2meleepack/w_axe.mdl')
SWEP.ActiveHoldType	= 'melee2'

hook.Add('EntityTakeDamage', 'dbg-weapons.axe', function(ent, dmgInfo)
	local attacker = dmgInfo:GetAttacker()
	if IsValid(ent) and ent:IsDoor() and attacker:Team() == TEAM_FIREFIGHTER then 
		if math.random(1,3) == 2 then 
			ent:DoUnlock()
			ent:Fire('setanimation', 'open', 0)
			ent:EmitSound('physics/wood/wood_crate_break' .. math.random(1, 5) .. '.wav')
		end
	end
end)