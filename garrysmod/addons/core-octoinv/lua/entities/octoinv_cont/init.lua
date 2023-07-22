AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

ENT.Model = 'models/items/item_item_crate.mdl'
ENT.Skin = 0
ENT.CollisionGroup = COLLISION_GROUP_NONE
ENT.Physics = true

function ENT:Initialize()

	self:SetModel(self.Model)
	self:SetSkin(self.Skin)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(self.CollisionGroup)
	if self.Bodygroups then
		for k, v in pairs(self.Bodygroups) do self:SetBodygroup(k, v) end
	end

	local inv = self:CreateInventory()
	for contID, cont in pairs(self.Containers or {}) do
		local newCont = inv:AddContainer(contID, {
			icon = cont.icon or octolib.icons.color('box1'),
			name = cont.name,
			volume = cont.volume,
			craft = cont.craft,
			prod = cont.prod,
		})
		for _,h in ipairs(cont.hooks or {}) do
			newCont:Hook(unpack(h))
		end
	end

	if self.Physics then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			self.baseMass = self.Mass or math.min(phys:GetMass(), 1000)
			phys:Wake()
			phys:SetMass(self.baseMass)
		end
	end

	self:SetUseType(SIMPLE_USE)
	self:Activate()

	self:SetNetVar('dbgLook', {
		name = '',
		desc = L.can_open,
		time = 1,
	})

end

function ENT:Use(ply, caller)

	if not ply:IsPlayer() then return end
	if not ply:CanUseInventory(self.inv) then return end

	ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
	timer.Simple(0.5, function()
		if not IsValid(self) then return end
		if self.locked then
			self:EmitSound('doors/latchlocked2.wav', 60)
			if IsValid(ply) then ply:Notify(L.item_closed) end
		else
			ply:OpenInventory(self.inv)
		end
	end)

end

function ENT:DropUsers()

	for contID, cont in pairs(self.inv.conts) do
		cont:RemoveUsers()
	end

end

function ENT:SetLocked(val)

	self.locked = val
	self:SetModel(not val and self.ModelOpen or self.Model)
	self:EmitSound('doors/door_latch' .. (val and 1 or 3) .. '.wav', 55)

	if val then
		for contID, cont in pairs(self.inv.conts) do
			for user, _ in pairs(cont.users) do
				cont:RemoveUser(user)
			end
		end
	end

end

function ENT:SetPlayer(ply)

	self:LinkPlayer(ply)
	self:SetNetVar('owner', ply)

end

function ENT:Destruct()

	if self.inv then self.inv:Remove(true) end

	if self.DestructParts then
		for i, itemData in ipairs(self.DestructParts) do
			local dir = VectorRand()

			local ent = ents.Create 'octoinv_item'
			ent:SetPos(self:GetPos() + Vector(0,0,20))
			ent:SetAngles(AngleRand())

			ent:Spawn()
			ent:Activate()

			local owner = self:GetNetVar('owner')
			if IsValid(owner) then owner:LinkEntity(ent) end

			ent:SetData(itemData[1], itemData[2])

			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:Wake()
				phys:SetVelocity(dir * math.random(50, 200))
			end
		end
	end

	self:Remove()

end

function ENT:Destroy(dmg)

	self.Destroyed = true
	if self.inv then self.inv:Remove(true) end

	if self.DestroyParts then
		for i, itemData in ipairs(self.DestroyParts) do
			local dir = VectorRand()

			local ent = ents.Create 'octoinv_item'
			ent:SetPos(self:GetPos() + Vector(0,0,20))
			ent:SetAngles(AngleRand())

			ent:Spawn()
			ent:Activate()
			local owner = self:GetNetVar('owner')
			if IsValid(owner) then owner:LinkEntity(ent) end

			ent:SetData(itemData[1], itemData[2])

			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:Wake()
				phys:SetVelocity(dir * math.random(50, 200))
			end
		end
	end

	if istable(self.Explode) then
		local a, i = dmg:GetAttacker(), dmg:GetInflictor()
		local ply = IsValid(a) and a:IsPlayer() and a or IsValid(i) and i:IsPlayer() and i or nil
		local pos = self:GetPos()
		util.BlastDamage(self, ply, pos, self.Explode[1] or 80, self.Explode[2] or 100)
		local ef = EffectData()
		ef:SetOrigin(pos)
		ef:SetMagnitude(1)
		util.Effect('Explosion', ef)
	end

	self:Remove()

end

function ENT:OnTakeDamage(dmg)

	if self.ContHealth and not self.Destroyed then
		self.ContHealth = self.ContHealth - dmg:GetDamage()
		if self.ContHealth <= 0 then
			self:Destroy(dmg)
		end
	end

end

function ENT:OnRemove()

	if self.LoopSound then self:StopSound(self.LoopSound) end
	if self.WorkSound then self:StopSound(self.WorkSound) end

end

