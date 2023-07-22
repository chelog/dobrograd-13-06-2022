ENT.Base 		= 'ent_dbg_throwable'
ENT.PrintName	= 'Шоковая'
ENT.Category	= 'Гранаты'
ENT.Spawnable	= true
ENT.AdminSpawnable = true
ENT.Author		= 'Wani4ka'
ENT.Contact		= '4wk@wani4ka.ru'

if SERVER then
	AddCSLuaFile()
end

ENT.Model				= 'models/csgo/weapons/w_eq_decoy.mdl'
ENT.LifeTime = 3
ENT.SoundExplode = {'weapons/357_fire2.wav', 100, 100, 1}
ENT.SoundHit	  = {'weapons/smokegrenade/grenade_hit1.wav'}
ENT.Radius		= 250
ENT.RadiusSqr	= ENT.Radius ^ 2

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

local function hasGasMask(ply)
	local hMask = ply:GetNetVar('hMask')
	return hMask and hMask[1] == 'gasmask'
end

function ENT:CanDamage(ply)
	return not hasGasMask(ply) and self.BaseClass.CanDamage(self, ply, 'eyes')
end