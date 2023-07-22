AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

ENT.Model = 'models/props_junk/garbage_bag001a.mdl'
ENT.CollisionGroup = COLLISION_GROUP_INTERACTIVE

local lifeTime = 1800
function ENT:Initialize()

	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	if not IsValid(self:GetPhysicsObject()) then
		self:PhysicsInitBox(Vector(-4,-4,-4), Vector(4,4,4))
	end
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(self.CollisionGroup)

	self:SetUseType(SIMPLE_USE)
	self:Activate()

	self.dieTime = self.dieTime or (CurTime() + lifeTime)
	self.uid = self.uid or octolib.string.uuid()

end

function ENT:SetData(item, data)
	self.uid = self.uid or octolib.string.uuid()

	if self:GetNetVar('Item') then
		timer.Remove('octoinv.entExpire' .. self.uid)
	end

	self:SetNetVar('Item', { item, data })

	local expire = istable(data) and data.expire or octoinv.items[item].expire
	if expire then
		timer.Create('octoinv.entExpire' .. self.uid, expire - os.time(), 1, function()
			if IsValid(self) then self:Remove() end
		end)
	end

	self:SetModel(octoinv.getItemData('model', item, data))
	self:SetSkin(octoinv.getItemData('modelSkin', item, data) or 0)
	self:SetMaterial(octoinv.getItemData('modelMaterial', item, data) or '')
	self:SetColor(octoinv.getItemData('modelColor', item, data) or color_white)

	self:PhysicsInit(SOLID_VPHYSICS)
	if not IsValid(self:GetPhysicsObject()) then
		self:PhysicsInitBox(Vector(-4,-4,-4), Vector(4,4,4))
	end
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:Activate()

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		local amount = istable(data) and data.amount or isnumber(data) and data or 1
		local mass = istable(data) and data.mass or octoinv.items[item].mass or 0

		self.baseMass = self.baseMass or phys:GetMass()
		phys:SetMass(self.baseMass + mass * amount)
		if amount < 1 then self:Remove() end
	end

	self:SetNetVar('dbgLook', {
		name = '',
		desc = 'octoinv_item',
		time = 0.5,
		descRender = true,
	})

end

function ENT:Use(ply, caller)

	if not ply:Alive() or ply:IsGhost() then return end

	local inv = ply:GetInventory()
	if not inv then
		ply:Notify('warning', 'Что-то пошло не так')
		return
	end

	local itemData = self:GetNetVar('Item')
	if not itemData then return end

	local can, why = hook.Run('octoinv.canPickup', ply, self, itemData)
	if can ~= nil and not can then
		ply:Notify('warning', why or L.cannotpickup)
		return
	end

	local cont = inv:GetContainer('_hand') or inv

	local added, item = cont:AddItem(itemData[1], itemData[2])
	if added < 1 then
		ply:Notify('warning', 'У тебя не хватает места в инвентаре')
		return
	end

	if istable(itemData[2]) then
		itemData[2].amount = itemData[2].amount and (itemData[2].amount - added) or 0
		self:SetNetVar('Item', { itemData[1], itemData[2] })
		if itemData[2].amount < 1 then self:Remove() end
	elseif isnumber(itemData[2]) then
		itemData[2] = itemData[2] - added
		self:SetNetVar('Item', { itemData[1], itemData[2] })
		if itemData[2] < 1 then self:Remove() end
	end
	ply:DoAnimation(ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND)

	hook.Run('octoinv.pickup', ply, self, item, added)

end

function ENT:Think()

	if self.dieTime and CurTime() > self.dieTime then
		self:Remove()
	end

	self:NextThink(CurTime() + 30)
	return true

end

function ENT:OnRemove()
	timer.Remove('octoinv.entExpire' .. self.uid)
end