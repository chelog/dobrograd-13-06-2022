octoinv.ContainerClass = octoinv.ContainerClass or {}

hook.Add('octoinv.taken', 'octoinv.expire', function(cont)
	if cont:FindItem({expire = {_exists = true, _lte = os.time()}}) then
		cont:CreateExpireTimer()
	else
		timer.Remove('octoinv.expireThink' .. cont.uid)
	end
end)
hook.Add('octoinv.added', 'octoinv.expire', function(cont, item)
	local expire = item:GetData('expire')
	if expire then
		if expire <= os.time() then return item:Remove() end
		cont:CreateExpireTimer()
	end
end)

local Container = octoinv.ContainerClass
Container.__index = Container

-- (container) creates and returns a new container
function octoinv.createCont(id, data)

	if not id then return end
	local default = octoinv.defaultInventory[id] or {}
	local cont = {
		id = id,
		uid = octolib.string.uuid(),
		name = data.name or default.name or L.container,
		volume = data.volume or default.volume or 10,
		craft = data.craft or default.craft,
		prod = data.prod or default.prod,
		icon = data.icon or default.icon,
		hooks = {},
		items = {},
		users = {},
	}

	setmetatable(cont, Container)
	return cont

end

-- (nil) destroys the container
function Container:Remove(dropItems, pos, ang, vel)

	local inv = self:GetParent()
	local owner = inv.owner

	self:RemoveUser(owner)
	self:RemoveUsers()
	timer.Remove('octoinv.expireThink' .. self.uid)

	if dropItems then
		for i = #self.items, 1, -1 do
			if self.items[i].cont == self then
				if pos ~= false then
					pos = pos or IsValid(owner) and owner:GetPos() or Vector()
					ang = ang or IsValid(owner) and owner:GetAngles() or Angle()
					vel = vel or VectorRand() * 50
				end

				self.items[i]:Drop(nil, nil, pos, ang, vel)
			end
		end
	end

	inv.conts[self.id] = nil
	octoinv.unsyncCont(self)

end

-- (item) returns item in container by its id
function Container:GetItem(id)

	return self.items[id]

end

-- (table) returns all items in container
function Container:GetItems()

	return self.items

end

function Container:CreateExpireTimer()
	local tName = 'octoinv.expireThink' .. self.uid
	if not timer.Exists(tName) then
		timer.Create(tName, 60, 0, function()
			local expiringLeft = 0
			for _,v in ipairs(self.items) do
				if v:GetData('expire') and not v:CheckExpired() then
					expiringLeft = expiringLeft + 1
				end
			end

			if expiringLeft < 1 then
				timer.Remove(tName)
			end
		end)
	end
end

-- (inventory) returns container's parent inventory
function Container:GetParent()

	return self.inv

end
Container.GetInventory = Container.GetParent

-- (int) returns amount of specified item in container
function Container:HasItem(item)

	if istable(item) then
		-- it's an item reference
		for i, _item in ipairs(self.items) do
			if _item == item then
				return _item
			end
		end
	elseif isstring(item) then
		-- it's a class
		local amount = 0
		for i, _item in ipairs(self.items) do
			if _item.class == item then
				amount = amount + _item:GetData('amount')
			end
		end

		--return amount ~= 0 and amount or false
		return amount
	end

	return false

end

-- (float) returns free space in container
function Container:FreeSpace()

	if self.space then return self.space end

	local space = self.volume
	for i, item in ipairs(self.items) do
		space = space - item:GetData('volume') * item:GetData('amount')
	end
	self.space = math.Round(space, 4)

	return self.space

end

-- (float) returns mass of container
function Container:GetMass()

	if self.mass then return self.mass end

	local mass = 0
	for i, item in ipairs(self.items) do
		mass = mass + item:GetData('mass') * item:GetData('amount')
	end

	self.mass = math.Round(mass, 4)
	return self.mass

end

-- (bool) returns whether player can craft inside container
function Container:CanCraft()

	return self.craft or false

end

-- (bool) returns whether player can process inside container
function Container:CanProd()

	return self.prod or false

end

-- (bool) sets container power on of off and returns current state
function Container:ToggleProd()

	if not self.prod then return end

	self.on = not self.on
	self:QueueSync()

	return self.on

end

-- (any) calls a hook chain on container and returns first non-nil value
function Container:Call(event, ...)

	if not event or not self.hooks[event] then return end
	for name, func in pairs(self.hooks[event]) do
		local q, w, e, r, t, y = func(self, ...)
		if q ~= nil then return q, w, e, r, t, y end
	end

end

-- (container) adds a hook function to given event and returns self
function Container:Hook(event, name, func)

	if not event or (func ~= nil and not isfunction(func)) then return end
	self.hooks[event] = self.hooks[event] or {}
	self.hooks[event][name] = func

	if table.Count(self.hooks[event]) < 1 then self.hooks[event] = nil end

	return self

end

-- (int) returns maximum amount of items which container can take now
function Container:SpaceFor(item, data)

	if isstring(item) and octoinv.items[item] then
		-- calc by class name
		local volume = istable(data) and data.volume or octoinv.items[item].volume
		if volume == 0 then return 2147483648 end

		local amount = self:FreeSpace() / volume
		return math.floor(tonumber(tostring(amount)))
	elseif istable(item) then
		-- use item's data
		local volume = item:GetData('volume') * item:GetData('amount')
		local amount = self:FreeSpace() / volume
		return math.floor(tonumber(tostring(amount)))
	end

	return 0

end

-- (int)
function Container:DropNewItem(class, data)

	local item
	if istable(class) then
		item = self:AddItem(class)
	else
		item = octoinv.createItem(class, self, data, true)
	end
	if item then item:Drop() end

end

-- (nil) sync container to clients
function Container:Sync()

	self:GetParent():UpdateMass()

	local owner = self:GetParent().owner
	local receivers = {}
	if IsValid(owner) and owner:IsPlayer() then
		table.insert(receivers, owner)
		if self.id == '_hand' then
			if self.volume - self:FreeSpace() >= 3 then
				owner:SetHandHold(true)
			else
				owner:SetHandHold(nil)
			end
		end
	end
	for ply, _ in pairs(self.users) do
		if IsValid(ply) and ply:IsPlayer() then
			table.insert(receivers, ply)
		else
			self.users[ply] = nil
		end
	end

	local toSend = table.Copy(self)
	toSend.inv = nil
	toSend.id = nil
	toSend.ownerID = nil
	toSend.hooks = nil
	for i, item in ipairs(toSend.items) do
		item.classTbl = nil
		item.cont = nil
		for k, v in pairs(item) do
			if isfunction(v) then item[k] = nil end
		end
	end

	netstream.Start(receivers, "octoinv.sync", self.ownerID, self.id, toSend)

end

function Container:ResetSpaceMass()

	-- invalidate cache
	self.space = nil
	self.mass = nil

end

-- (nil) add container to sync queue and adjust item ids
function Container:QueueSync()

	-- restore item ids in case if they have changed
	for i, item in ipairs(self.items) do item.id = i end
	-- update owner index
	self.ownerID = self.inv and IsValid(self.inv.owner) and self.inv.owner:EntIndex() or nil
	-- add to queue
	octoinv.syncCont(self)

end

-- (table) returs table of items matching octolib.filterQuery
function Container:FindItems(query)

	local keys = table.GetKeys(query)
	if keys[1] == 'class' and not keys[2] and isstring(query.class) then
		local class = query.class
		local found = {}
		for _, _item in ipairs(self.items) do
			if _item.class == class then
				found[#found + 1] = _item
			end
		end
		return found
	end

	return octolib.array.filterQuery(self.items, query)

end

-- (item) returns first item matching octolib.filterQuery
function Container:FindItem(query)

	local keys = table.GetKeys(query)
	if keys[1] == 'class' and not keys[2] and isstring(query.class) then
		local class = query.class
		for _, _item in ipairs(self.items) do
			if _item.class == class then
				return _item
			end
		end
		return
	end

	return octolib.array.filterQuery(self.items, query, 1)[1]

end

-- (table) returs table of unique items matching list of octolib.filterQuery
function Container:FindItemsByQueryList(queries)

	local foundItems = {}
	for _, query in ipairs(queries) do
		local ok = false
		for _, item in ipairs(self:FindItems(query)) do
			if not foundItems[item] then
				foundItems[item] = true
				ok = true
				break
			end
		end

		if not ok then return end
	end

	return table.GetKeys(foundItems)

end

-- (int, item) adds an item to container and returns item and added amount
function Container:AddItem(item, data, force)

	if istable(item) then
		-- TODO: add checks
		local cont = item:GetParent()
		if cont then cont:TakeItem(item) end
		table.insert(self.items, item)
		item.cont = self
		self:AddItemStats(item)
		self:QueueSync()

		hook.Run('octoinv.added', self, item, 1)
		return 1, item
	elseif isstring(item) then
		local itemTbl = octoinv.items[item]
		if not itemTbl then return 0 end

		local canAdd = force and math.huge or self:SpaceFor(item, data)
		if not canAdd or canAdd < 1 then return 0 end

		if itemTbl.nostack then
			-- data is override in stackables
			if istable(data) and data.amount and canAdd < data.amount then return 0, nil end
			local item = octoinv.createItem(item, self, data, force)
			self:AddItemStats(item)
			self:QueueSync()

			hook.Run('octoinv.added', self, item, 1)
			return item and item:GetData('amount'), item
		else
			-- data is amount in stackables
			local amount = istable(data) and data.amount or data or 1
			if amount <= 0 then return 0 end

			local given = math.min(canAdd, amount)
			local itemR = self:FindItem({class = item})
			if itemR then
				itemR:SetData('amount', itemR:GetData('amount') + given)
			else
				itemR = octoinv.createItem(item, self, { amount = given }, force)
				self:AddItemStats(itemR)
			end
			self:QueueSync()

			hook.Run('octoinv.added', self, itemR, given)
			return given, itemR
		end
	end

	return false

end
Container.GiveItem = Container.AddItem

-- (int) removes an item and returns how many were removed
function Container:TakeItem(item, amount)

	if istable(item) then
		-- take item instance
		if not item.id then return octoinv.msg('ERROR: No id present on item. Aborting removal.') end
		if item.cont ~= self then return octoinv.msg('ERROR: Trying to remove other container\'s item. Aborting removal.') end

		if self.items[item.id] then
			local amount = item:GetData('amount')
			table.remove(self.items, item.id)
			self:TakeItemStats(item)
			self:QueueSync()
			hook.Run('octoinv.taken', self, item, amount)
			return amount
		else
			return 0
		end
	elseif isstring(item) then
		-- take items by class
		local item = self:FindItem({class = item})
		if not item then return 0 end

		local taken = math.min(amount or 1, item:GetData('amount'))
		if not taken or taken <= 0 then return 0 end

		item:SetData('amount', item:GetData('amount') - taken)
		self:QueueSync()

		hook.Run('octoinv.taken', self, item, taken)
		return taken
	end

	return false

end
Container.RemoveItem = Container.TakeItem

-- (nil) adds mass and volume of item to container
function Container:AddItemStats(item, amountOverride)
	self.mass = (self.mass and item:GetMass(amountOverride) or 0) + self:GetMass()
	self.space = (self.space and -item:GetVolume(amountOverride) or 0) + self:FreeSpace()
end

-- (nil) removes mass and volume of item from container
function Container:TakeItemStats(item, amountOverride)
	self.mass = (self.mass and -item:GetMass(amountOverride) or 0) + self:GetMass()
	self.space = (self.space and item:GetVolume(amountOverride) or 0) + self:FreeSpace()
end

-- (nil) removes all items from container
function Container:Clear()
	table.Empty(self.items)
	self:ResetSpaceMass()
	self:QueueSync()
end

-- (nil) adds a user to container
function Container:AddUser(ply)

	self.users[ply] = true
	self:Call('userAdd', ply)
	self:QueueSync()

end

-- (nil) removes a user from container
function Container:RemoveUser(ply)

	self.users[ply] = nil
	self:Call('userRemove', ply)

	if IsValid(ply) and ply:IsPlayer() then
		netstream.Start(ply, "octoinv.forget", self.ownerID, self.id)
	end

end

-- (nil) removes all users from container
function Container:RemoveUsers()

	for ply, _ in pairs(self.users) do
		self:RemoveUser(ply)
	end

end

-- (container) moves container to another inventory and returns the container
function Container:MoveTo(inv)

	if not inv then return false end

	local prevInv = self:GetParent()
	if prevInv then
		prevInv.conts[self.id] = nil
		if IsValid(prevInv.owner) and prevInv.owner:IsPlayer() then
			self:RemoveUser(prevInv.owner)
		end
	end
	self:RemoveUsers()

	inv.conts[self.id] = self
	self.inv = inv

	self:QueueSync()

end
Container.Move = Container.MoveTo

-- (table) returns serializable table of this item
function Container:Export()
	local cont = table.Copy(self)
	cont.id = nil
	cont.uid = nil
	cont.inv = nil
	cont.users = nil
	cont.space = nil
	cont.mass = nil
	cont.ownerID = nil
	cont.hooks = nil
	for k,v in pairs(octoinv.defaultInventory[self.id] or {}) do
		if cont[k] == v then
			cont[k] = nil
		end
	end
	local items = {}
	for itemID, item in pairs(cont.items) do
		items[itemID] = item:Export()
	end
	cont.items = items
	return cont
end
