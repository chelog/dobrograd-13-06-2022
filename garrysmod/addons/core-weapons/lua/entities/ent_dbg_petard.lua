ENT.Base 		= 'ent_dbg_throwable'
ENT.PrintName	= 'Петарда'
ENT.Category	= 'Гранаты'
ENT.Spawnable	= true
ENT.AdminSpawnable = true
ENT.Author		= 'Wani4ka'
ENT.Contact		= '4wk@wani4ka.ru'

DEFINE_BASECLASS('ent_dbg_throwable')

if SERVER then
	AddCSLuaFile()
end

ENT.Model				= 'models/weapons/Shotgun_shell.mdl'
ENT.LifeTime			= 10

ENT.FlameEffect = 'effects/spark'
ENT.FlameAlpha = 255
ENT.FlamePos	= Vector(-3, 0, 0.8)
ENT.FlameDieTime = 0.1
ENT.FlameSize	= 2
ENT.ExplosionAmount = 20

ENT.SoundFlame = {'ambient/gas/steam2.wav', 55, 175, 08}
ENT.SoundExplode = {'weapons/357_fire2.wav', 100, 150, 1}

function ENT:ExplodeEffect()

	local e = ParticleEmitter(Vector())
	if IsValid(e) and self.ExplosionAmount > 0 then
		for i = 1, self.ExplosionAmount do
			local p = e:Add(self.FlameEffect, self:LocalToWorld(self.FlamePos))
			p:SetDieTime(self.FlameDieTime)
			p:SetStartAlpha(self.FlameAlpha)
			p:SetEndAlpha(0)
			p:SetStartSize(self.FlameSize)
			p:SetEndSize(0)
			p:SetVelocity(VectorRand() * 100)
		end
	end
	timer.Simple(2, function()
		if IsValid(e) then e:Finish() end
	end)

end


function ENT:Initialize()

	BaseClass.Initialize(self)

	local half = Vector(1.5, 0.5, 0.5)
	self:SetModel(self.Model)
	self:PhysicsInitBox(-half, half)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		if self.Mass then phys:SetMass(self.Mass) end
		phys:Wake()
		phys:SetMass(5)
	end

end
