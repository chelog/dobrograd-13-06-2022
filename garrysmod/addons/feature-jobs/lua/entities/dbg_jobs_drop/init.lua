AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetSkin(self.Skin)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)
	self:SetOpen(not self:GetOpen())
end

function ENT:SetDeliveryData(jobID, check)
	self.jobID = jobID
	self.check = check
end

function ENT:Think()
	if self.jobID and self.check(ents.FindInSphere(self:GetPos(), 40)) then
		dbgJobs.finishJob(self.jobID, true)
	end

	self:NextThink(CurTime() + 2)
	return true
end
