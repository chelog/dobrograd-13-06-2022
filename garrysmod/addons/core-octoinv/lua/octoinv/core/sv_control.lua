netstream.Hook('octoinv.move', function(ply, items, toEntID, toContID)

	local toEnt = Entity(toEntID)
	if not IsValid(toEnt) then return end
	local can, why = hook.Run('octoinv.canMove', ply, items, toEnt, toContID)
	if can == false then
		if why then ply:Notify(why) end
		return
	end

	local notifiedNoSpace = false
	for fromEntID, conts in pairs(items) do
		local fromEnt = Entity(fromEntID)
		if not IsValid(fromEnt) then return end

		local fromInv = fromEnt:GetInventory()
		local toInv = toEnt:GetInventory()
		if not fromInv then return end

		if not toInv or (toContID and not toInv:GetContainer(toContID)) then return end
		local contTo = toInv:GetContainer(toContID)

		for contID, contItems in pairs(conts) do
			local contFrom = fromInv:GetContainer(contID)
			if not contFrom then return end

			if not ply:HasAccessToContainer(fromEnt, contID) or not ply:HasAccessToContainer(toEnt, toContID) then continue end

			local queue = {}
			for itemID, amount in pairs(contItems) do
				local item = contFrom:GetItem(itemID)

				local outCan, outWhy = contFrom:Call('canMoveOut', ply, item, contTo)
				if outCan == false then ply:Notify('warning', outWhy or L.notmove) continue end
				local inCan, inWhy = contTo:Call('canMoveIn', ply, item, contFrom)
				if inCan == false then ply:Notify('warning', inWhy or L.notmove) continue end

				if item then
					table.insert(queue, {itemID, item, amount})
				else
					contItems[itemID] = nil
				end
			end
			for i = #queue, 1, -1 do
				local itemID, item, amount = queue[i][1], queue[i][2], queue[i][3]
				local moved = item:MoveTo(contTo, amount) or 1
				contItems[itemID] = contItems[itemID] - moved
				if moved > 0 then
					hook.Run('octoinv.plymoved', ply, item, contFrom, contTo, moved)
				elseif not notifiedNoSpace then
					ply:Notify('warning', L.notenoughspace)
					notifiedNoSpace = true
				end
				if contItems[itemID] <= 0 then contItems[itemID] = nil end
			end
			if table.Count(items[fromEntID][contID]) <= 0 then items[fromEntID][contID] = nil end
			if table.Count(items[fromEntID]) <= 0 then items[fromEntID] = nil end
		end
	end

	-- netstream.Start(ply, 'syncQueue', items)

end)

netstream.Hook('octoinv.drop', function(ply, owner, contID, itemID, amount)

	owner = Entity(owner)
	if not IsValid(owner) then return end

	if not ply:HasAccessToContainer(owner, contID) then return end
	local cont = owner:GetInventory():GetContainer(contID)

	local item = cont:GetItem(itemID)
	if item then
		local can, why = hook.Run('octoinv.canDrop', ply, item, amount, owner, contID)
		if can == false then
			if why then owner:Notify(why) end
			return
		end
		item:Drop(amount, ply)
	end

end)

netstream.Hook('octoinv.uselist', function(ply, owner, contID, itemID)


	owner = Entity(owner)
	if not IsValid(owner) then return end

	if not ply:HasAccessToContainer(owner, contID) then return end
	local cont = owner:GetInventory():GetContainer(contID)

	local item = cont:GetItem(itemID)
	if item then
		netstream.Start(ply, 'octoinv.uselist', item:UseList(ply))
	else
		netstream.Start(ply, 'octoinv.uselist', false)
	end

end)

netstream.Hook('octoinv.use', function(ply, owner, contID, itemID, useID)

	owner = Entity(owner)
	if not IsValid(owner) then return end

	if not ply:HasAccessToContainer(owner, contID) then return end
	local cont = owner:GetInventory():GetContainer(contID)

	local item = cont:GetItem(itemID)
	if item then
		local can, why = hook.Run('octoinv.canUse', cont, item, ply)
		if can == false then
			ply:Notify(why or 'Ты не можешь использовать этот предмет')
			return
		end
		item:Use(useID, ply)
		hook.Run('octoinv.used', cont, item, ply)
	end

end)

netstream.Hook('octoinv.toggle', function(ply, owner, contID)

	owner = Entity(owner)
	if not IsValid(owner) then return end

	if not ply:HasAccessToContainer(owner, contID) then return end
	local cont = owner:GetInventory():GetContainer(contID)

	cont:ToggleProd()

end)
