local ent = FindMetaTable 'Entity'

function ent:CreateInventory()

	return octoinv.createInv(self)

end

function ent:GetInventory()

	return self.inv

end

function ent:PrintInventory()

	if not self.inv then
		print("no inventory")
		return
	end

	local inv = table.Copy(self.inv)
	for contID, cont in pairs(inv.conts) do
		cont.id = nil
		cont.inv = nil
		for itemID, item in ipairs(cont.items) do
			item.classTbl = nil
			item.cont = nil
		end
	end

	PrintTable(inv)

end

function ent:ExportInventory()

	return self.inv and self.inv:Export() or nil

end

function ent:ImportInventory(data)

	local ct = os.time()
	local inv = self:CreateInventory()
	for contID, cont in pairs(data) do
		local newCont = inv:AddContainer(contID, cont)
		if cont.items then
			for itemID, item in ipairs(cont.items) do
				if item.expire and item.expire <= ct then continue end
				newCont:AddItem(item.class, item, true)
			end
		end
	end

end

function ent:AddContainer(...)

	local inv = self:GetInventory()
	if not inv then return end

	return inv:AddContainer(...)

end

function ent:AddItem(...)

	local inv = self:GetInventory()
	if not inv then return end

	return inv:AddItem(...)

end

function ent:TakeItem(...)

	local inv = self:GetInventory()
	if not inv then return end

	return inv:TakeItem(...)

end

function ent:HasItem(...)

	local inv = self:GetInventory()
	if not inv then return false end

	return inv:HasItem(...)

end

function ent:FindItems(...)

	local inv = self:GetInventory()
	if not inv then return end

	return inv:FindItems(...)

end

function ent:FindItem(...)

	local inv = self:GetInventory()
	if not inv then return end

	return inv:FindItem(...)

end
