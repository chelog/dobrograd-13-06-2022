AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Think()
	if self.jobID and self.check(self.mainCont) then
		dbgJobs.finishJob(self.jobID, true)
		return
	end

	self:NextThink(CurTime() + 2)
	return true
end

function ENT:Use(ply)
	ply:OpenInventory(self.inv)
	ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
end

function ENT:SetDeliveryData(jobID, volume, check)
	if self.inv then
		self.inv:Remove()
	end

	local inv = self:CreateInventory()
	self.mainCont = inv:AddContainer('main', {
		icon = octolib.icons.color('box3_drop'),
		name = 'Получатель',
		volume = volume,
	})

	self.jobID = jobID
	self.check = check
end
