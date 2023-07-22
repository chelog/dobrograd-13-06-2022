ENT.Base 		= 'ent_dbg_throwable'
ENT.PrintName	= 'Страйкбольная'
ENT.Category	= 'Гранаты'
ENT.Spawnable	= true
ENT.AdminSpawnable = true
ENT.Author		= 'Wani4ka'
ENT.Contact		= '4wk@wani4ka.ru'

if SERVER then
	AddCSLuaFile()
end

ENT.Model				= 'models/weapons/w_eq_fraggrenade_thrown.mdl'
ENT.LifeTime			= 5
ENT.SoundExplode = {'weapons/357_fire2.wav', 100, 150, 1}

function ENT:OnExplode()

	for _,v in ipairs(ents.FindInSphere(self:GetPos(), 100)) do
		if v:IsPlayer() and self:CanDamage(v) then
			local wep = v:GetActiveWeapon()
			if IsValid(wep) and wep:GetClass():find('_air') then
				v:dropDRPWeapon(wep)
			end

			local dmg = DamageInfo()
			dmg:SetDamageType(DMG_BLAST)
			dmg:SetDamage(1)
			v:TakeDamageInfo(dmg)
		end
	end

end

function ENT:ExplodeEffect()

	local e = ParticleEmitter(Vector())
	if IsValid(e) then
		for i = 1, 20 do
			local p = e:Add('effects/spark', self:GetPos())
			p:SetDieTime(0.1)
			p:SetStartAlpha(255)
			p:SetEndAlpha(0)
			p:SetStartSize(2)
			p:SetEndSize(0)
			p:SetVelocity(VectorRand() * 100)
		end
	end

	timer.Simple(2, function()
		if IsValid(e) then e:Finish() end
	end)

end
