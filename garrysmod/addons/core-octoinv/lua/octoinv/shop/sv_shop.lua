octoinv.shopCats = octoinv.shopCats or {}
octoinv.shopItems = octoinv.shopItems or {}

local catJobs, itemJobs
octoinv.recalcShopPerms = octolib.func.debounce(function()

	catJobs = {}
	for catID, cat in pairs(octoinv.shopCats) do
		if istable(cat.jobs) then
			catJobs[catID] = {}
			for i, v in ipairs(cat.jobs) do catJobs[catID][v] = true end
		end
	end

	itemJobs = {}
	for itemID, item in pairs(octoinv.shopItems) do
		if istable(item.jobs) then
			itemJobs[itemID] = {}
			for i, v in ipairs(item.jobs) do itemJobs[itemID][v] = true end
		end
	end

end, 0)
octoinv.recalcShopPerms()

function octoinv.addShopCat(id, data)

	if id then
		octoinv.shopCats[id] = data
	else
		octoinv.shopCats[#octoinv.shopCats + 1] = data
	end

end

function octoinv.addShopItem(id, data)

	if id then
		octoinv.shopItems[id] = data
	else
		octoinv.shopItems[#octoinv.shopItems + 1] = data
	end

	octoinv.recalcShopPerms()

end

function octoinv.sendToMailbox(sID, items, box)

	if not IsValid(box) then
		box = table.Random(ents.FindByClass('octoinv_mailbox'))
	end
	if not IsValid(box) then return false end

	if not isstring(sID) then
		sID = sID:SteamID()
	end

	box:Deliver(sID, items)
	return box

end

function octoinv.getNearestMailbox(ply)

	local plyPos = ply:GetPos()
	local data = octolib.table.reduce(ents.FindByClass('octoinv_mailbox'), function(acc, ent)
		local dist = ent:GetPos():DistToSqr(plyPos)
		if dist < acc.dist then
			return { dist = dist, box = ent }
		else
			return acc
		end
	end, { dist = math.huge })

	return data.box, data.dist

end

function octoinv.expectShipment(ply, id, check)

	ply.pendingShipments = ply.pendingShipments or {}
	ply.pendingShipments[id] = check

end

function octoinv.removeShipment(ply, id)

	if not IsValid(ply) or not ply.pendingShipments then return end

	ply.pendingShipments[id] = nil
	if table.IsEmpty(ply.pendingShipments) then
		ply.pendingShipments = nil
	end

end

function octoinv.syncShop(ply)

	local catsCache = {}
	local res = {}
	for itemID, item in pairs(octoinv.shopItems) do
		local itemData = octoinv.items[item.item or itemID]
		if not itemData then print('Unknown item: ' .. itemID) continue end

		local catID = octoinv.shopCats[item.cat] and item.cat or '_other'
		if catsCache[catID] == true then
			continue
		elseif catsCache[catID] ~= false then
			catsCache[catID] = catJobs[catID] and not catJobs[catID][ply:getJobTable().command] -- category job restrictions
			or octoinv.shopCats[catID].check and not octoinv.shopCats[catID].check(ply) -- category custom checks
			if catsCache[catID] == true then continue end
		end

		if itemJobs[itemID] and not itemJobs[itemID][ply:getJobTable().command] -- item job restrictions
		or octoinv.shopItems[itemID].check and not octoinv.shopItems[itemID].check(ply) -- item custom checks
		then continue end

		local price = isfunction(item.price) and item.price(ply) or item.price
		res[catID] = res[catID] or {}
		res[catID][itemID] = {
			name = item.name or itemData.name,
			desc = item.desc or itemData.desc,
			icon = item.icon or itemData.icon,
			model = item.model or item.data and item.data.model or itemData.model or nil,
			plyMat = item.plyMat or itemData.plyMat,
			skin = item.skin or itemData.skin,
			price = price,
		}
	end

	netstream.Start(ply, 'octoinv.shoplist', res)
	netstream.Start(ply, 'octoinv.return', ply:GetDBVar('return'))

end

function octoinv.calcOrderPriceAndVolume(ply, basket)

	local totalVolume, totalPrice, totalCount = 0, 0, 0
	local catsCache = {}
	for itemID, amount in pairs(basket) do
		amount = math.floor(amount)
		basket[itemID] = amount

		local item = octoinv.shopItems[itemID]
		if not item or amount <= 0 then
			basket[itemID] = nil
			continue
		end
		local itemData = octoinv.items[item.item or itemID]

		local catID = item.cat or '_other'
		if catsCache[catID] == true then
			continue
		elseif catsCache[catID] ~= false then
			catsCache[catID] = catJobs[catID] and not catJobs[catID][ply:getJobTable().command] -- category job restrictions
			or octoinv.shopCats[catID].check and not octoinv.shopCats[catID].check(ply) -- category custom checks
			if catsCache[catID] == true then
				ply:Notify('warning', L.order_not_have_access .. '(' .. itemData.name .. ')')
				return
			end
		end

		if itemJobs[itemID] and not itemJobs[itemID][ply:getJobTable().command] -- item job restrictions
		or octoinv.shopItems[itemID].check and not octoinv.shopItems[itemID].check(ply) -- item custom checks
		then
			ply:Notify('warning', L.order_not_have_access .. '(' .. itemData.name .. ')')
			return
		end

		totalVolume = totalVolume + (item.data and item.data.volume or itemData.volume or 0) * amount
		totalPrice = totalPrice + (item.price or 0) * amount
		totalCount = totalCount + (itemData.nostack and amount or 1)
	end

	return totalVolume, totalPrice, totalCount

end

octoinv.deliveryMethods = {{
	time = { 120, 180 },
	price = 0,
	findBox = function(ply)
		local boxes = ents.FindByClass('octoinv_mailbox')
		for i, ent in RandomPairs(boxes) do
			if ent:GetPos():DistToSqr(ply:GetPos()) > 9000000 then
				return ent
			end
		end
		return table.Random(boxes)
	end,
}, {
	time = { 30, 60 },
	price = 0.05,
	findBox = function(ply)
		local boxes = ents.FindByClass('octoinv_mailbox')
		for i, ent in RandomPairs(boxes) do
			if ent:GetPos():DistToSqr(ply:GetPos()) > 9000000 then
				return ent
			end
		end
		return table.Random(boxes)
	end,
}, {
	time = { 60, 120 },
	price = 0.2,
	findBox = function(ply)
		local curDist, box = math.huge
		for i, ent in ipairs(ents.FindByClass('octoinv_mailbox')) do
			local dist = ent:GetPos():DistToSqr(ply:GetPos())
			if dist < curDist and dist > 250000 then
				curDist = dist
				box = ent
			end
		end
		return box
	end,
}}

function octoinv.addReturnItems(steamID, items)

	if not isstring(steamID) then
		-- arg is player entity
		steamID = steamID:SteamID()
	end

	octolib.getDBVar(steamID, 'return', {}):Then(function(cache)
		for _, item in ipairs(items) do
			cache[#cache + 1] = item
		end
		octolib.setDBVar(steamID, 'return', cache)

		local ply = player.GetBySteamID(steamID)
		if IsValid(ply) then
			octoinv.syncShop(ply)
		end
	end)

end

local function queueClientUpdate(ply)

	netstream.Start(ply, 'octoinv.shop', true)

end
hook.Add('PlayerSpawn', 'octoinv.shop', queueClientUpdate)
