AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

SWEP.HitDistance = 48

function SWEP:PrimaryAttack()
	self.attack = CurTime() + 1
	local owner = self:GetOwner()
	if owner:GetVelocity():Length2DSqr() < 1 then
		owner:DoAnimation(ACT_GMOD_GESTURE_DISAGREE)
	end
	owner:EmitSound('octoteam/characters/dog/rawr' .. math.random(2) .. '.ogg')
	self:SetNextPrimaryFire(CurTime() + 1.5)
end

function SWEP:SecondaryAttack()
	local owner = self:GetOwner()
	if owner:GetVelocity():Length2DSqr() < 1 then
		owner:DoAnimation(ACT_GMOD_GESTURE_BOW)
	end
	timer.Simple(0.5, function()
		if IsValid(owner) then owner:EmitSound('octoteam/characters/dog/bark' .. math.random(5) .. '.ogg') end
	end)
	self:SetNextSecondaryFire(CurTime() + 0.5)
end

function SWEP:Think()
	if not (self.attack and CurTime() > self.attack) then return end
	self.attack = nil

	local owner = self:GetOwner()
	owner:LagCompensation(true)

	local aim = owner:EyeAngles():Forward()
	local tr = util.TraceLine({
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + aim * self.HitDistance,
		filter = owner,
		mask = MASK_SHOT_HULL
	})

	if not IsValid(tr.Entity) then
		tr = util.TraceHull({
			start = owner:GetShootPos(),
			endpos = owner:GetShootPos() + aim * self.HitDistance,
			filter = owner,
			mins = Vector(-10, -10, -8),
			maxs = Vector(10, 10, 8),
			mask = MASK_SHOT_HULL
		})
	end

	if IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity:Health() > 0 then
		local dmginfo = DamageInfo()

		local attacker = owner
		if not IsValid(attacker) then attacker = self end
		dmginfo:SetAttacker(attacker)

		dmginfo:SetInflictor(self)
		local dmgAmount = math.random(8, 12)
		dmginfo:SetDamage(dmgAmount)
		dmginfo:SetDamageType(DMG_SLASH)

		tr.Entity:TakeDamageInfo(dmginfo)
		DarkRP.damageHands(tr.Entity, 70)
		tr.Entity:MoveModifier('dog-bite', {
			walkmul = 0.75,
			runmul = 0.75,
			nojump = true,
		})
		tr.Entity:EmitSound('vo/npc/' .. (tr.Entity:IsMale() and '' or 'fe') .. 'male01/pain0' .. math.random(9) .. '.wav')
		timer.Create('dog-bite' .. tr.Entity:SteamID(), math.random(2, 4), 1, function()
			tr.Entity:MoveModifier('dog-bite')
		end)
		owner:EmitSound('npc/barnacle/barnacle_crunch' .. math.random(2,3) .. '.wav')

	end

	owner:LagCompensation(false)

end
