ENT.Base 		= 'ent_dbg_throwable'
ENT.PrintName	= 'Осколочная'
ENT.Category	= 'Гранаты'
ENT.Spawnable	= true
ENT.AdminSpawnable = true

if SERVER then
	AddCSLuaFile()
end

ENT.Model				= 'models/csgo/weapons/w_eq_fraggrenade.mdl'
ENT.LifeTime			= 5

ENT.SoundHit = { Sound('Flashbang.Bounce') }

function ENT:OnExplode()

	local attacker = IsValid(self.owner) and self.owner or self
	util.BlastDamage(self, attacker, self:GetPos(), 400, 150)
	local e = EffectData()
	e:SetOrigin(self:GetPos())
	util.Effect('Explosion', e)

end
