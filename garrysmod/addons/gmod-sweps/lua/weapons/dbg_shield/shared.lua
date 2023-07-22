if SERVER then
	AddCSLuaFile()
end

SWEP.Base 			= 'weapon_base'
SWEP.Category		= L.dobrograd
SWEP.PrintName		= 'Баллистический щит'
SWEP.Instructions 	= ''
SWEP.Slot			= 1
SWEP.SlotPos		= 9
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.ViewModel		= ''
SWEP.WorldModel		= 'models/bshields/hshield.mdl'
SWEP.HoldType		= 'melee2'
SWEP.Spawnable		= true
SWEP.AdminOnly		= true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ''

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ''

SWEP.NoHandDamageDrop = true
SWEP.Types = {
	['models/bshields/hshield.mdl'] = { Vector(-.5, 10.4, -2.7), Angle(4.4, 13.8, -13), 'MetalSpark' },
	['models/bshields/rshield.mdl'] = { Vector(-1, 10.4, -4.5), Angle(4.4, 13.8, -13), 'GlassImpact' },
}

local function getShieldOwner(ent)
	if not IsValid(ent) or ent:GetClass() ~= 'collider' then return false end
	local wep = ent:GetNetVar('weapon')
	if IsValid(wep) and wep:GetClass() == 'dbg_shield' then
		return wep:GetOwner()
	end
end

local ignoreClasses = octolib.array.toKeys({'gmod_sent_vehicle_fphysics_base', 'gmod_sent_vehicle_fphysics_wheel'})
hook.Add('ShouldCollide', 'octolib.collider', function(ent1, ent2)

	local ply1 = getShieldOwner(ent1)
	local ply2 = getShieldOwner(ent2)
	if not ply1 and not ply2 then return end

	-- no collide players with their own shields and other players' shields
	if ply1 and (ply1 == ent2 or ignoreClasses[ent2:GetClass()] or (ent2:IsPlayer() and ent2:GetActiveWeaponClass() == 'dbg_shield'))
	or ply2 and (ply2 == ent1 or ignoreClasses[ent1:GetClass()] or (ent1:IsPlayer() and ent1:GetActiveWeaponClass() == 'dbg_shield')) then
		return false
	end

end)