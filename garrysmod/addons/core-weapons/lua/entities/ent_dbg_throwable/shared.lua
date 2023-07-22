ENT.Type 		= "anim"
ENT.Base 		= "base_gmodentity"
ENT.PrintName	= '[основа]'
ENT.Category	= 'Гранаты'

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Model = 'models/weapons/w_eq_fraggrenade_thrown.mdl'
ENT.ThrowForce = 750
ENT.LifeTime = 5
ENT.BreakSensitivity = math.huge
ENT.ExplodeAfterCollision = false

function ENT:CanDamage(target, att)

	if target:IsGhost() or (target.IsInvisible and target:IsInvisible()) then return false end
	local attID = target:LookupAttachment(att or 'chest')
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = target:GetAttachment(attID).Pos,
		filter = { self, target },
	})

	return not tr.HitWorld

end

-- ENT.SoundExplode = { 'weapons/357_fire2.wav', 75, 150, 1 }
-- ENT.SoundHit = { Sound('Flashbang.Bounce') }
-- ENT.SoundFlame = {'ambient/gas/steam2.wav', 55, 175, 08}

-- ENT.FlameEffect = 'effects/spark'
-- ENT.FlameAlpha = 255
-- ENT.FlamePos	= Vector(-3, 0, 0.8)
-- ENT.FlameDieTime = 0.1
-- ENT.FlameSize	= 2
