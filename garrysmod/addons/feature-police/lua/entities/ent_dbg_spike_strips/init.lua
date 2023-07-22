AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'
include 'shared.lua'

function ENT:Initialize()

	self:SetModel('models/notakid/spikestrips/spikestrip.mdl')
	self:SetMaterial('models/debug/debugwhite')
	self:SetColor(Color(36, 36, 36, 255))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetTrigger(true)

end

function ENT:StartTouch(otherEnt)

	if not IsValid(otherEnt) or otherEnt:GetClass() ~= 'gmod_sent_vehicle_fphysics_wheel' then return end

	otherEnt:TakeDamage(math.random(0, 3))

	timer.Simple(2, function()
		if not IsValid(self) then return end
		self:Remove()
	end)

end
