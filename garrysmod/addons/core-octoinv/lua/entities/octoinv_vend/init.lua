AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

ENT.Model = 'models/props/apoc/vendingmachine.mdl'
ENT.CollisionGroup = COLLISION_GROUP_NONE
ENT.Physics = true

ENT.slots = {}
ENT.Containers = {
	vend = { name = L.vend_money, volume = 50, icon = octolib.icons.color('machine_vend') },
}

function ENT:Initialize()

	self.BaseClass.Initialize(self)

	self:SetSlotsNum(7)
	self.lockNum = 6

end

function ENT:Use(ply, caller)

	if not ply:IsPlayer() then return end
	if not ply:CanUseInventory(self.inv) then return end

	ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
	timer.Simple(0.5, function()
		if not IsValid(self) then return end
		if self.locked then
			if self.owner == ply then
				ply:Notify(L.vend_manage)
			else
				ply:Notify(L.for_buy_vend)
			end
		else
			ply:OpenInventory(self.inv)
		end
	end)

end

function ENT:DropFromSlot(id)

	if not self.slots[id] then return end

	local item = self.slots[id].cont.items[1]
	if item then
		local pos, ang = LocalToWorld(Vector(0,10,-30), Angle(0,0,0), self:GetPos(), self:GetAngles())
		item:Drop(1, nil, pos, ang, self:GetForward() * 150)

		self:UpdateContents()
	end

end

function ENT:UpdateContents()

	if not self.locked then
		self:SetNetVar('contents', nil)
		return
	end

	local data = {}
	for i, slot in ipairs(self.slots) do
		local item = slot.cont.items[1]
		if item and item:GetData('amount') > 0 then
			table.insert(data, {
				icon = item:GetData('icon'),
				name = item:GetData('name'),
				price = slot.price,
			})
		else
			table.insert(data, {})
		end
	end

	self:SetNetVar('contents', data)

end

local restricted = octolib.array.toKeys {
	'money', 'weapon', 'armor', 'ammo', 'lockpick', 'drug_vitalex', 'drug_painkiller', 'drug_relaxant', 'drug_vampire',
	'drug_dextradose', 'drug_roids', 'drug_bouncer', 'drug_antitoxin', 'drug_weed', 'drug_pingaz', 'drug_preserver', 'drug_meth',
}

local function canMoveIn(cont, ply, item, contFrom)

	if item and item.class and restricted[item.class] then
		return false, L.forbidden_to_load
	end

end

function ENT:SetSlotsNum(slots)

	local pos, ang = LocalToWorld(Vector(0,10,-30), Angle(0,0,0), self:GetPos(), self:GetAngles())
	for i, slot in ipairs(self.slots) do
		slot.cont:Remove(true, pos, ang, self:GetForward() * 150)
	end

	self.slots = {}
	for i = 1, slots do
		self.slots[i] = {
			cont = self.inv
				:AddContainer('vend' .. i, {name = L.vend_slot .. i, volume = 30, icon = octolib.icons.color('machine_vend')})
				:Hook('canMoveIn', 'vend', canMoveIn),
			price = 0
		}
	end

	self:UpdateContents()

end

function ENT:SetPrices(prices)

	self:SetLocked(true)
	for i, slot in ipairs(self.slots) do slot.price = 0 end

	local set = {}
	for k, price in pairs(prices) do
		if not self.slots[k] then continue end

		local amount = tonumber(prices[k])
		if set[amount] then
			self:SetLocked(false)
			return
		end

		self.slots[k].price = math.floor(amount or 0)
		set[amount] = true
	end

	self:UpdateContents()
	return true

end

function ENT:Think()

	if not self.locked and self:GetNetVar('contents') then
		self:UpdateContents()
	end

	local cont = self.inv.conts.vend
	for i, item in ipairs(cont.items) do
		if item.class ~= 'money' then
			local pos, ang = LocalToWorld(Vector(0,10,-30), Angle(0,0,0), self:GetPos(), self:GetAngles())
			item:Drop(nil, nil, pos, ang, self:GetForward() * 150)
		end
	end

	self:NextThink(CurTime() + 1)
	return true

end

function ENT:StartTouch(ent)

	if not IsValid(ent) or ent:GetClass() ~= 'octoinv_item' or not ent:GetNetVar('Item') or ent.aquired then return end
	local ply = ent.droppedBy

	if not self.locked then
		if IsValid(ply) then ply:Notify('warning', L.vend_need_closed) end
		return
	end

	local amount, slotID = ent:GetNetVar('Item')[2]
	for i, slot in ipairs(self.slots) do
		if slot.price == amount then slotID = i break end
	end

	if not slotID then
		if IsValid(ply) then ply:Notify('warning', L.vend_accurate_money) end
		return
	end

	local item = self.slots[slotID].cont.items[1]
	if not item or item:GetData('amount') < 1 then
		if IsValid(ply) then ply:Notify('warning', L.vend_slot_empty) end
		return
	end

	self:DropFromSlot(slotID)

	ent.aquired = true
	ent:Remove()
	self.inv.conts.vend:AddItem('money', amount)

end
