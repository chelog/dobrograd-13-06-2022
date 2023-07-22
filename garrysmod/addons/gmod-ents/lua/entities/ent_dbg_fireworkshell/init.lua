AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

ENT.LifeTime = 2
ENT.SoundFlame = {'ambient/gas/steam2.wav', 55, 175, 08}
ENT.SoundExplode = {'weapons/357_fire2.wav', 75, 150, 1}

function ENT:Initialize()

	local half = Vector(1,1,1)
	self:SetModel('models/hunter/plates/plate.mdl')
	self:PhysicsInitBox(-half, half)
	self:DrawShadow(false)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(1)
		phys:Wake()
	end

	local sd = self.SoundFlame
	local s = CreateSound(self, sd[1])
	s:SetSoundLevel(sd[2])
	s:PlayEx(sd[4], sd[3])
	self.sndFlame = s

	timer.Simple(self.LifeTime, function()
		if not IsValid(self) then return end
		self:Explode()
	end)

end

function ENT:Explode()

	netstream.Start(nil, 'dbg-fireworks.explode', self:GetPos())

	local sd = self.SoundExplode
	self:EmitSound(sd[1], sd[2], sd[3] + math.random(-10, 10), sd[4])
	self:Remove()

end

function ENT:OnRemove()

	self.sndFlame:Stop()
	
end
