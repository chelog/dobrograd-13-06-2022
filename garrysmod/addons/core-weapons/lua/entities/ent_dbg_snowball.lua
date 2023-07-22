ENT.Base 		= 'ent_dbg_throwable'
ENT.PrintName	= 'Снежок'
ENT.Category	= 'Гранаты'
ENT.Spawnable	= true
ENT.AdminSpawnable = true
ENT.ExplodeAfterCollision = true

if SERVER then
	AddCSLuaFile()
end

ENT.Model				= 'models/weapons/w_snowball_thrown.mdl'
ENT.LifeTime			= 0

if SERVER then
	function ENT:PhysicsCollide(data, phys)
		self.BaseClass.PhysicsCollide(self, data, phys)

		local ply = data.HitEntity
		if IsValid(ply) and ply:IsPlayer() then
			ply:ViewPunch(Angle(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5)))
		end
	end
end

if CLIENT then
	function ENT:ExplodeEffect(pos)
		local e = ParticleEmitter(Vector())

		for _ = 1, 50 do
			local p = e:Add('effects/splash2', pos + VectorRand())
			p:SetDieTime(3 + math.Rand(0, 2))
			p:SetStartAlpha(255)
			p:SetStartSize(math.Rand(0.8, 1.2))
			p:SetEndAlpha(0)
			p:SetEndSize(1)
			p:SetGravity(Vector(0,0,-200))
			p:SetVelocity(VectorRand() * 50)
			p:SetColor(255, 255, 255)
			p:SetCollide(true)
			p:SetAirResistance(-50)
		end

		timer.Simple(5, function()
			if IsValid(e) then e:Finish() end
		end)
	end
end
