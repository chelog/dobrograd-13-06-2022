AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

function ENT:Initialize()

	self:SetModel('models/hunter/blocks/cube1x1x1.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)

end

function ENT:CheckRequired(ply)

	if self.pendingWorker ~= ply then return false end
	if self.requiredItems then
		for i, v in ipairs(self.requiredItems) do
			if ply:HasItem(v[1]) < v[2] then
				ply:Notify('warning', L.where_details)
				return false
			end
		end
	end

	return true

end

function ENT:SetWork(ply, data)

	if not IsValid(ply) or not data or not data.finish then return end

	self.pendingWorker = ply
	self.finish = data.finish
	self.repairTime = data.time or 20
	self.requiredItems = data.items

end

function ENT:UnsetWork()

	self.pendingWorker = nil
	self.finish = nil
	self.repairTime = nil
	self.requiredItems = nil

end

local sounds = {
	'physics/metal/chain_impact_hard1.wav',
	'physics/metal/chain_impact_soft3.wav',
	'physics/metal/metal_box_impact_soft3.wav',
	'physics/metal/metal_box_strain2.wav',
	'physics/metal/metal_box_strain4.wav',
	'ambient/machines/pneumatic_drill_1.wav',
	'ambient/machines/pneumatic_drill_2.wav',
	'ambient/machines/squeak_2.wav',
	'ambient/machines/squeak_5.wav',
	'ambient/machines/squeak_6.wav',
	'ambient/machines/squeak_7.wav',
	'ambient/machines/squeak_8.wav',
}

function ENT:Use(ply)
	if not self:CheckRequired(ply) then return end

	ply:ClearMarkers('work2')
	ply:DelayedAction('work', L.repair_action, {
		time = self.repairTime,
		check = function()
			return ply:GetPos():DistToSqr(self:GetPos()) < self.RepairDistSqr
		end,
		succ = function()
			if not self:CheckRequired(ply) then return end
			for i, v in ipairs(self.requiredItems) do
				ply:TakeItem(v[1], v[2])
			end
			self.finish(ply)
		end,
	}, {
		time = 1.5,
		inst = true,
		action = function()
			ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
			local snd = table.Random(sounds)
			self:EmitSound(snd, 60, 100, 0.8)
		end,
	})

end
