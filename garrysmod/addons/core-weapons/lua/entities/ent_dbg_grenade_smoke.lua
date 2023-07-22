ENT.Base 		= 'ent_dbg_throwable'
ENT.PrintName	= 'Дымовая'
ENT.Category	= 'Гранаты'
ENT.Spawnable	= true
ENT.AdminSpawnable = true
ENT.Author		= 'Wani4ka'
ENT.Contact		= '4wk@wani4ka.ru'

if SERVER then
	AddCSLuaFile()
end

ENT.Model				= 'models/csgo/weapons/w_eq_smokegrenade.mdl'
ENT.LifeTime			= 3

ENT.SoundExplode = {'weapons/smokegrenade/sg_explode.wav', 100, 100, 1}
ENT.SoundHit	  = {'weapons/smokegrenade/grenade_hit1.wav'}

if CLIENT then

	function ENT:Think()
		if not IsValid(self.em) then return end
		if not self:GetNetVar('exploded') then
			return self.BaseClass.Think(self)
		end

		if LocalPlayer():EyePos():DistToSqr(self:GetPos()) <= 4000000 then
			local particle = self.em:Add(string.format('particle/smokesprites_00%02d', math.random(1,10)), self:GetPos())
			if particle then
				local dir = VectorRand() + Vector(0, 0, 0.8)
				dir.z = dir.z * 0.5
				particle:SetVelocity(dir * 200)
				particle:SetDieTime(math.Rand(6, 8))
				particle:SetStartAlpha(math.Rand(220, 255))
				particle:SetEndAlpha(0)
				particle:SetStartSize(math.Rand(40, 50))
				particle:SetEndSize(math.Rand(150, 200))
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-0.5, 0.5))
				local col = math.Rand(135, 145)
				particle:SetColor(col, col, col)
				particle:SetAirResistance(200)
				particle:SetGravity(dir * math.random(25, 50))
				particle:SetCollide(true)
			end
		end

		self:SetNextClientThink(CurTime() + 0.1)
		return true
	end

else

	function ENT:Think()
		if not self:GetNetVar('exploded') then return end

		for _,v in ipairs(ents.FindInSphere(self:GetPos(), 150)) do
			if v:IsPlayer() and self:CanDamage(v, 'eyes') then
				timer.Simple(math.random(0.5,1.5), function()
					if IsValid(v) then
						v:EmitSound('ambient/voices/cough'..math.random(1,4)..'.wav')
					end
				end)
			end
		end

		self:NextThink(CurTime() + 2)
		return true
	end

end

function ENT:OnExplode()

	self:SetNetVar('exploded', true)
	timer.Simple(30, function()
		if IsValid(self) then
			self:Remove()
		end
	end)

	return true

end
