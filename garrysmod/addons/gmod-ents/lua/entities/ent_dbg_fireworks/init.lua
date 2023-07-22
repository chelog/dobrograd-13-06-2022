AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

ENT.ShellsNum = 10
ENT.LaunchInterval = 0.5
ENT.LaunchVariance = { -1, 1 }

function ENT:Initialize()

	self:SetModel('models/items/boxflares.mdl')
	self:PhysicsInitBox(Vector(-9, -2, 0), Vector(9, 2, 7))
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(10)
		phys:Wake()
	end

end

function ENT:Use()

	if self.activated then return end
	self.activated = true

	self:SetNetVar('working', true)
	timer.Simple(4, function()
		if not IsValid(self) then return end
		self:SetNetVar('working', nil)
	end)

	for i = 1, self.ShellsNum do
		timer.Simple(5 + i * self.LaunchInterval + math.Rand(unpack(self.LaunchVariance)), function()
			if not IsValid(self) then return end

			local dir = self:GetUp() + VectorRand() * 0.1
			local s = ents.Create 'ent_dbg_fireworkshell'
			s:SetAngles((dir):Angle())
			s:SetPos(self:LocalToWorld(Vector(0,0,5)))
			s:Spawn()
			s:GetPhysicsObject():SetVelocity(dir * 1000)
		end)
	end

	timer.Simple(15 + self.ShellsNum * self.LaunchInterval, function()
		if not IsValid(self) then return end
		self:Remove()
	end)

end
