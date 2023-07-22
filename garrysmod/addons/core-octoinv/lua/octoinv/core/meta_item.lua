octoinv.ItemClass = octoinv.ItemClass or {}
local Item = octoinv.ItemClass
Item.__index = Item

local function getOffsetZ(ent)
	local a, b = ent:GetCollisionBounds()
	return math.min(a.z, b.z)
end

-- (item) creates and returns a new item
function octoinv.createItem(class, cont, data, force)

	if not class or not octoinv.items[class] or not cont then return end
	local rAmount = istable(data) and data.amount or isnumber(data) and data or 1
	local amount = force and rAmount or math.min(cont:SpaceFor(class, data), rAmount)
	if amount < 1 then return end

	local item = cont:FindItem({class = class})
	if item and not item:GetData('nostack') then
		item:SetData('amount', item:GetData('amount') + amount)
		hook.Run('octoinv.added', cont, item, amount)
	else
		local tbl = octoinv.items[class]
		item = {
			class = class,
			classTbl = tbl,
			cont = cont,
		}

		if istable(data) then
			for k, v in pairs(data) do
				item[k] = v
			end
		end

		setmetatable(item, Item)
		table.insert(cont.items, item)
		hook.Run('octoinv.added', cont, item, 1)
	end

	cont:QueueSync()
	return item, amount

end

-- (nil) destroys the item
function Item:Remove(amount)

	local cont = self:GetParent()
	if not cont then return end

	if amount then
		cont:TakeItem(self.class, amount)
	else
		cont:TakeItem(self)
		self.cont = nil
	end

end

-- (bool) checks and removes item if is expired
function Item:CheckExpired(noRemove)

	local expire = self:GetData('expire')
	if expire and expire <= os.time() then
		if not noRemove then self:Remove() end
		return true
	end

	return false

end

-- (entity) drops an item and return created entity
function Item:Drop(amount, owner, pos, ang, vel)

	if self:CheckExpired() then return end

	local cont = self:GetParent()
	if not cont or cont:Call('canDrop', self:GetParent(), self) == false then return end

	local owner = owner or cont:GetParent().owner
	amount = amount or self:GetData('amount')
	amount = math.max(math.ceil(amount), 1)

	local put = false
	if owner:IsPlayer() then
		local trace = owner:GetEyeTraceLimited(CFG.useDist)
		put = trace.Hit and trace.HitNormal.z >= 0.85
		if put then
			pos = trace.HitPos
			ang = owner:EyeAngles()
			ang.p = 0
			ang:RotateAroundAxis(vector_up, 180)
			vel = Vector(0,0,0)
		end
	end

	local function drop(isPlayer)
		local has = (self.nostack and cont:HasItem(self) or (cont:HasItem(self.class) >= amount)) and self:GetParent() == cont
		if not has then return end

		local ent, dropped = NULL, 0
		local classTbl = self.classTbl
		if classTbl.class then
			if classTbl.drop then
				ent, dropped = classTbl.drop(owner, self, amount, {
					pos = pos,
					ang = ang,
					vel = vel,
					put = put
				})
			else
				ent = ents.Create(classTbl.class)
				ent.apgIgnore = true
				ent.droppedBy = owner
				ent:SetPos(pos)
				ent:SetAngles(ang)
				ent:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
				ent.Model = self:GetData('model') or ent.Model

				if classTbl.dropped then
					classTbl.dropped(owner, ent, self)
				end

				ent:Spawn()
				ent:Activate()
				if put then
					pos:Sub(Vector(0,0,getOffsetZ(ent)))
					ent:SetPos(pos)
				end
				if isPlayer then
					owner:LinkEntity(ent)
				end

				local phys = ent:GetPhysicsObject()
				if IsValid(phys) then
					phys:Wake()
					phys:SetVelocity(vel)
				end

				dropped = amount
			end
		else
			ent = ents.Create 'octoinv_item'
			ent.apgIgnore = true
			ent.droppedBy = owner
			ent:SetPos(pos)
			ent:SetAngles(ang)
			ent.Model = self:GetData('model') or ent.Model
			ent:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)

			ent:Spawn()
			ent:Activate()
			if self:GetData('nodespawn') then
				ent.dieTime = nil
			end
			if put then
				pos:Sub(Vector(0,0,getOffsetZ(ent)))
				ent:SetPos(pos)
			end
			if isPlayer then
				owner:LinkEntity(ent)
			end

			if classTbl.nostack then
				local data = table.Copy(self)
				data.class = nil
				data.classTbl = nil
				data.cont = nil
				data.id = nil
				ent:SetData(self.class, data)
			else
				ent:SetData(self.class, amount)
			end

			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:Wake()
				phys:SetVelocity(vel)
			end

			dropped = amount
		end

		if IsValid(ent) then
			ent.pickupItemData = self:Export()
		end

		cont = self:GetParent()

		hook.Run('octoinv.dropped', self.cont, self, ent, owner, dropped)
		self:SetData('amount', self:GetData('amount') - dropped)

		if cont then cont:QueueSync() end
	end

	if owner:IsPlayer() then
		owner:DoAnimation(ACT_GMOD_GESTURE_ITEM_GIVE)
		timer.Simple(0.88, function()
			if not IsValid(owner) then return drop() end
			if not pos or not ang then
				pos, ang = owner:GetBonePosition(owner:LookupBone('ValveBiped.Bip01_L_Hand') or 16)
			end
			local tr = util.TraceLine { start = owner:GetShootPos(), endpos = pos, filter = owner }
			if tr.Hit then
				pos = tr.HitPos + tr.HitNormal * 5
				vel =  tr.HitNormal * 200
			elseif not vel then
				vel = owner:GetAimVector()
				vel.z = 0
				vel = vel * 200 + VectorRand() * math.random(15,40)
			end

			drop(true)
		end)
	else
		pos = pos or (owner:GetPos() + Vector(0,0,30))
		ang = ang or owner:GetAngles()
		vel = vel or (VectorRand() * math.random(20, 80))

		drop()
	end

end

-- (table) returns a table of available actions for a player
function Item:UseList(ply)

	if self:CheckExpired() then return end

	local uses = self:GetData('use')
	if not istable(uses) then return false end

	local res = {}
	for i, use in ipairs(uses) do
		local name, icon = use(ply, self)
		if name ~= nil then
			table.insert(res, { i, name, icon })
		end
	end

	return self:GetParent():Call('canSeeUseList', self:GetParent(), ply, self, res) == false and {} or res

end

-- (bool) returns whether an item was used and amount changed
function Item:Use(id, ply)

	local uses = self:GetData('use')
	if not uses or not uses[id] then return false end

	local can, why = self:GetParent():Call('canUse', self:GetParent(), ply, self, id)
	if can == false then
		ply:Notify(why or 'Ты не можешь выполнить это действие с этим предметом')
		return false
	end

	local name, icon, action = uses[id](ply, self)
	if not name then return false end

	local used = action(ply, self)
	if used and used ~= 0 then
		local cont = self:GetParent()
		self:SetData('amount', self:GetData('amount') - used)
		cont:QueueSync()
		return true
	end

	return false

end

-- (container) returns item's parent container
function Item:GetParent()

	return self.cont

end
Item.GetContainer = Item.GetParent

-- (item) sets specific item data and returns the item
function Item:SetData(field, val)

	local cont = self:GetParent()
	if field == 'amount' then
		if val <= 0 then
			self:Remove()
		else
			local diff = val - self:GetData('amount')
			if diff > 0 then
				if cont then cont:AddItemStats(self, diff) end
			elseif diff < 0 then
				if cont then cont:TakeItemStats(self, -diff) end
			end
		end
	elseif field == 'mass' then
		local diff = val - self:GetData('mass')
		if cont then cont.mass = cont.mass + diff * self:GetData('amount') end
	elseif field == 'volume' then
		local diff = val - self:GetData('volume')
		if cont then cont.space = cont.space - diff * self:GetData('amount') end
	elseif field == 'expire' then
		if val <= os.time() then
			self:Remove()
		elseif cont then
			cont:CreateExpireTimer()
		end
	end

	self[field] = val
	if cont then cont:QueueSync() end

	return self

end

-- (any) returns specific item data (name, volume, etc)
function Item:GetData(field, skipDefault)

	if self[field] ~= nil then return self[field] end
	if skipDefault then return end

	if self.classTbl[field] ~= nil then return self.classTbl[field] end
	return octoinv.defaultData[field]

end

function Item:GetMass(amountOverride)
	return self:GetData('mass') * (amountOverride or self:GetData('amount'))
end

function Item:GetVolume(amountOverride)
	return self:GetData('volume') * (amountOverride or self:GetData('amount'))
end

-- (int) moves item to container, returns amount moved
function Item:MoveTo(cont, amount)

	if self:CheckExpired() or not self.cont then return end

	local prevCont = self:GetParent()
	amount = isnumber(amount) and math.max(math.ceil(amount), 1)
	if self:GetData('nostack') then
		if not cont or cont:SpaceFor(self) < 1 then return 0 end
		cont:AddItem(self)
		return 1
	else
		local given = cont:AddItem(self.class, math.min(amount, self:GetData('amount')))
		if prevCont then prevCont:TakeItem(self.class, given) end
		return given
	end

end
Item.Move = Item.MoveTo

-- (table) returns serializable table of this item
function Item:Export()
	local data = table.Copy(self)
	data.cont = nil
	data.id = nil
	local classTbl = data.classTbl
	data.classTbl = nil
	for k,v in pairs(data) do
		if v == classTbl[k] then
			data[k] = nil
		end
	end
	return data
end
