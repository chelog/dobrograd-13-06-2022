octoinv.InventoryClass = octoinv.InventoryClass or {}
local Inventory = octoinv.InventoryClass
Inventory.__index = Inventory

-- (inventory) creates a new inventory and returns it
function octoinv.createInv(owner)

	if not owner or not IsValid(owner) then return end
	if owner.inv then
		owner.inv:Remove()
	end

	local inv = {
		owner = owner,
		conts = {}
	}

	setmetatable(inv, Inventory)
	owner.inv = inv

	local tname = 'octoinv_' .. tostring(owner)
	timer.Create(tname, 1, 0, function()
		if inv and IsValid(inv.owner) then
			for contID, cont in pairs(inv.conts) do
				for ply, _ in pairs(cont.users) do
					if not ply:CanUseInventory(inv) then
						inv:RemoveUser(ply)
					end
				end
			end
		else
			timer.Remove(tname)
		end
	end)

	return inv

end

-- (entity) gets owner of inventory
function Inventory:GetOwner()

	return self.owner

end

-- (nil) sets owner of inventory
function Inventory:SetOwner(ent)

	if self.owner then
		self.owner.inv = nil
	end

	if ent.inv then
		ent.inv:Remove()
	end

	for contID, cont in pairs(self.conts) do
		cont:RemoveUsers()
		cont:QueueSync()
	end

	self.owner = ent
	ent.inv = self

end

-- (nil) destroys the inventory
function Inventory:Remove(...)

	for contID, cont in pairs(self.conts) do
		cont:Remove(...)
	end

	self.owner.inv = nil
	self.owner = nil

end

-- (container) creates a container, attaches to inventory and returns it
function Inventory:AddContainer(id, ...)

	if not id then return end
	name = name or L.container
	volume = volume or 10

	if self.conts[id] then
		octoinv.msg('ERROR: Trying to add container with duplicate id!')
		return
	end

	local cont = octoinv.createCont(id, ...)
	cont.inv = self

	self.conts[id] = cont
	cont:QueueSync()

	return cont

end

-- (container[]) returns all containers of the inventory
function Inventory:GetContainers()
	return self.conts
end
Inventory.GetChildren = Inventory.GetContainers

-- (container) returns container with specified id
function Inventory:GetContainer(id)

	return self.conts[id]

end

-- (int) returns amount of specified item in container or whole inventory
function Inventory:HasItem(item, contID)

	if istable(item) then
		if contID then
			return cont:HasItem(item)
		else
			for contID, cont in pairs(self.conts) do
				local has = cont:HasItem(item)
				if has then return has end
			end

			return false
		end
	elseif isstring(item) then
		local amount = 0
		if not contID then
			for contID, cont in pairs(self.conts) do
				amount = amount + (cont:HasItem(item) or 0)
			end
		else
			local cont = self.conts[contID]
			if not cont then return 0 end
			amount = amount + (cont:HasItem(item) or 0)
		end

		return amount
	end

	return false

end

-- (table) returs table of items matching octolib.filterQuery
function Inventory:FindItems(...)

	local found = {}
	for contID, cont in pairs(self.conts) do
		table.Add(found, cont:FindItems(...))
	end

	return found

end

-- (item) returns first item matching octolib.filterQuery
function Inventory:FindItem(query)

	for _, cont in pairs(self.conts) do
		local found = cont:FindItem(query)
		if found then return found end
	end

end

-- (float) returns free space in inventory
function Inventory:FreeSpace()

	local space = 0
	for _, cont in pairs(self.conts) do
		space = space + cont:FreeSpace()
	end

	return space

end

-- (float) returns all items mass
function Inventory:GetMass()

	local mass = 0
	for _, cont in pairs(self.conts) do
		mass = mass + cont:GetMass()
	end

	return mass

end

-- (nil) updates mass of owner
function Inventory:UpdateMass()

	if not IsValid(self.owner) then return end

	local phys = self.owner:GetPhysicsObject()
	if not IsValid(phys) or not self.owner.baseMass then return end

	local mass = self.owner.baseMass + self:GetMass() * (self.owner.invMassMultiplier or 2)
	phys:SetMass(mass)
	phys:Wake()

	hook.Run('octoinv.massUpdated', self.owner, mass)

end

-- (int) returns maximum amount of items of defined type which container or whole invenory can take now
function Inventory:SpaceFor(class, data, contID)

	local canTake = 0
	if not contID then
		for contID, cont in pairs(self.conts) do
			canTake = canTake + cont:SpaceFor(class, data)
		end
	else
		local cont = self.conts[contID]
		if not cont then return 0 end
		canTake = cont:SpaceFor(class, data)
	end

	return canTake

end

-- (int) adds an item to container or inventory and returns added amount
function Inventory:AddItem(item, data)

	if istable(item) then
		for k, v in pairs(self.conts) do
			if cont:SpaceFor(item, data) > 0 then
				return cont:AddItem(item, data)
			end
		end
	elseif isstring(item) then
		local itemTbl = octoinv.items[item]
		if not itemTbl then return 0 end

		if itemTbl.nostack then
			for contID, cont in pairs(self.conts) do
				local given, item = cont:AddItem(item, data)
				if given >= 1 then return given, item end
			end

			return 0
		else
			local amount = data or 1
			if amount <= 0 then return 0 end

			local givenTotal = 0
			for contID, cont in pairs(self.conts) do
				local given = cont:AddItem(item, amount)
				amount, givenTotal = amount - given, givenTotal + given
				if amount <= 0 then break end
			end

			return givenTotal
		end
	end

end

-- (int) takes an item to container or inventory and returns taken amount
function Inventory:TakeItem(item, data, contID)

	if istable(item) then
		local _item, taken = self:HasItem(item, contID)
		if _item then taken = _item:SetData('amount', _item:GetData('amount') - (data or 1)) end
		return taken
	elseif isstring(item) then
		local has = self:HasItem(item, contID)
		if has <= 0 then return 0 end

		local amount = data or has
		amount = math.min(amount, has)
		if amount <= 0 then return 0 end

		local takenTotal = 0
		if not contID then
			for contID, cont in pairs(self.conts) do
				local taken = cont:TakeItem(item, amount)
				amount, takenTotal = amount - taken, takenTotal + taken
				if amount <= 0 then break end
			end
		else
			local cont = self.conts[contID]
			if not cont then return 0 end

			local taken = cont:TakeItem(item, amount)
			amount, takenTotal = amount - taken, takenTotal + taken
		end

		return takenTotal
	end

	return false

end
Inventory.RemoveItem = Inventory.TakeItem

-- (nil) removes all items from inventory
function Inventory:Clear()
	for _,cont in pairs(self.conts) do
		cont:Clear()
	end
end

-- (nil) performs actions on random items
function Inventory:PerformRandom(opts, func)

	opts = opts or {}
	opts.maxItems = opts.maxItems or 5
	opts.maxVolume = opts.maxVolume or 20

	local curItems, curVol = 0, 0
	while curItems < opts.maxItems and curVol < opts.maxVolume do
		local contFrom = table.Random(self.conts)
		if not contFrom then break end
		local item = table.Random(contFrom.items)
		if not item then break end

		local randomWeight = item:GetData('randomWeight') or 1
		local amount = math.floor(1 / randomWeight)

		local performed = func(item, amount)
		if performed == -1 then break end

		curVol = curVol + item:GetData('volume') * performed
		curItems = curItems + performed * randomWeight
	end

end

-- (table) moves random items to container based on given criteria
function Inventory:MoveRandom(cont, opts)

	if not istable(cont) or not cont.inv then return end

	local movedData = {}
	self:PerformRandom(opts, function(item, amount)
		if cont:SpaceFor(item.class, item.nostack and item or nil) < amount then return -1 end

		local moved = item:MoveTo(cont, amount) or 0

		local name = item:GetData('name')
		movedData[name] = (movedData[name] or 0) + moved

		return moved
	end)

	return movedData

end

-- (nil) adds a user to all containers of this inventory
function Inventory:AddUser(ply, conts)

	if conts then
		for i, contID in pairs(conts) do
			local cont = self.conts[contID]
			if cont then cont:AddUser(ply) end
		end
	else
		for contID, cont in pairs(self.conts) do
			cont:AddUser(ply)
		end
	end

end

-- (nil) removes specific user from containers of this inventory
function Inventory:RemoveUser(ply, conts)

	if conts then
		for i, contID in pairs(conts) do
			local cont = self.conts[contID]
			if cont then cont:RemoveUser(ply) end
		end
	else
		for contID, cont in pairs(self.conts) do
			cont:RemoveUser(ply)
		end
	end

end

-- (nil) removes all users from this inventory
function Inventory:RemoveUsers()

	for contID, cont in pairs(self.conts) do
		for user, _ in pairs(cont.users) do
			cont:RemoveUser(user)
		end
	end

end

-- (table) returns serializable table of this inventory
function Inventory:Export()
	local inv = table.Copy(self.conts)
	for contID, cont in pairs(inv) do
		if string.sub(contID, 1, 1) == '_' then
			inv[contID] = nil
			continue
		end
		inv[contID] = cont:Export()
	end

	return inv
end
