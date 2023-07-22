ENT.Base 		= 'ent_dbg_throwable'
ENT.PrintName	= 'Газовая'
ENT.Category	= 'Гранаты'
ENT.Spawnable	= true
ENT.AdminSpawnable = true
ENT.Author		= 'Wani4ka'
ENT.Contact		= '4wk@wani4ka.ru'

ENT.Model				= 'models/csgo/weapons/w_eq_smokegrenade.mdl'
ENT.LifeTime			= 5
ENT.SoundExplode 		= {'physics/plastic/plastic_barrel_impact_bullet1.wav', 100, 100, 1}

ENT.SoundExplode = {'weapons/smokegrenade/sg_explode.wav', 100, 100, 1}
ENT.SoundHit	  = {'weapons/smokegrenade/grenade_hit1.wav'}
ENT.Radius		= 250
ENT.RadiusSqr	= ENT.Radius ^ 2

local function hasGasMask(ply)
	local hMask = ply:GetNetVar('hMask')
	return hMask and hMask[1] == 'gasmask'
end

function ENT:CanDamage(ply)
	return not hasGasMask(ply) and self.BaseClass.CanDamage(self, ply, 'eyes')
end

function ENT:OnExplode()

	self:SetNetVar('exploded', true)

	timer.Simple(120, function()
		if IsValid(self) then
			for _,v in ipairs(ents.FindInSphere(self:GetPos(), 200)) do
				if v:IsPlayer() and self:CanDamage(v) then
					v:SetLocalVar('gas', CurTime() + 10)
					timer.Simple(10.5, function()
						if IsValid(v) then v:SetLocalVar('gas') end
					end)
				end
			end
			self:Remove()
		end
	end)

	return true

end
