local foodRequests = {
	{ 700, L.omelet },
	{ 800, L.hotdog },
	{ 950, L.ceasar },
	{ 1280, L.mushroom_soup },
	{ 1350, L.bolognese },
	{ 1500, L.zitti },
	{ 1550, L.wrap },
	{ 1750, L.borsch },
	{ 1900, L.pizza_pepperoni },
	{ 1900, L.pizza_margarita },
	{ 2250, L.pizza_volcano },
	{ 2350, L.lasagna },
	{ 3200, 'Запеченный окунь' },
	{ 3200, 'Запеченный карп' },
	{ 3200, 'Форель под медом' },
	{ 3200, 'Щука в сливочном соусе' },

	{ 700, L.tea },
	{ 700, L.cacao },
	{ 800, L.cappuccino },
	{ 900, L.espresso },
}

local function getBoxData(volume)
	if volume <= 10 then
		return 10, 'models/props/cs_office/cardboard_box02.mdl'
	elseif volume <= 50 then
		return 50, 'models/props/cs_office/cardboard_box03.mdl'
	else
		return math.ceil(volume / 10) * 10, 'models/props/cs_office/cardboard_box01.mdl'
	end
end

local orderTypes = {
	{
	-- 	name = 'Продукты на дом',
	-- 	icon = octolib.icons.silk32('apple'),
	-- 	getOrderData = function()
	-- 		if not foodShopItems then
	-- 			foodShopItems = octolib.table.map(octoinv.shopItems, function(item)
	-- 				if item.cat == 'ings' then return item end
	-- 			end)
	-- 		end

	-- 		local totalPrice = 0
	-- 		local totalVolume = 0
	-- 		local items = {}
	-- 		local kindsAmount = math.random(2, 10)
	-- 		for _ = 1, kindsAmount do
	-- 			local itemData, itemID = table.Random(foodShopItems)
	-- 			local amount = math.random(1, 10)
	-- 			items[itemID] = (items[itemID] or 0) + amount
	-- 			totalPrice = totalPrice + itemData.price * amount
	-- 			totalVolume = totalVolume + octoinv.getItemData('volume', itemID) * amount
	-- 		end

	-- 		local bonusMoney = math.ceil(totalPrice * 0.05) * 10 -- 50% rounded up to 10s

	-- 		return {
	-- 			timeout = octolib.time.toSeconds(15, 'minutes'),
	-- 			reward = DarkRP.formatMoney(bonusMoney),
	-- 			money = totalPrice + bonusMoney,
	-- 			text = table.concat(octolib.table.mapSequential(items, function(amount, itemID)
	-- 				return '— ' .. amount .. 'х ' .. octoinv.getItemData('name', itemID)
	-- 			end), '\n') .. '\nСтоимость продуктов будет компенсирована',
	-- 			volume = totalVolume,
	-- 			queries = octolib.table.mapSequential(items, function(amount, itemID)
	-- 				return { class = itemID, amount = { _gte = amount }}
	-- 			end),
	-- 		}
	-- 	end,
	-- }, {
		name = 'Доставка еды',
		icon = octolib.icons.silk32('hamburger'),
		getOrderData = function()
			local totalMoney = 0
			local queries = {}
			local amount = math.random(1, 4)
			for _, item in RandomPairs(foodRequests) do
				local price, name = unpack(item)
				totalMoney = totalMoney + price
				queries[#queries + 1] = { class = 'food', name = name, part = { _exists = false }}

				if #queries >= amount then break end
			end

			return {
				timeout = octolib.time.toSeconds(20, 'minutes'),
				reward = DarkRP.formatMoney(totalMoney),
				money = totalMoney,
				text = table.concat(octolib.table.mapSequential(queries, function(item)
					return '— ' .. item.name
				end), '\n'),
				volume = 20,
				queries = queries,
			}
		end,
	},
}

local job = {}

function job.publish()
	local orderType = table.Random(orderTypes)
	if not orderType then return end

	local orderData = orderType.getOrderData()
	if not orderData or #orderData.queries < 1 then return end

	local mapConfig = dbgJobs.mapConfig and dbgJobs.mapConfig.home
	if not mapConfig then return end

	local existingContainersPositions = octolib.table.mapSequential(ents.FindByClass('dbg_jobs_container'), function(ent)
		return ent:GetPos()
	end)

	local spawnPos
	for _, pos in RandomPairs(mapConfig) do
		-- we don't want any other containers near spawn
		local ok = true
		for _, theirPos in ipairs(existingContainersPositions) do
			if theirPos:DistToSqr(pos) < 40000 then
				ok = false
				break
			end
		end

		if ok then
			spawnPos = pos
			break
		end
	end
	if not spawnPos then return end

	local volume, model = getBoxData(orderData.volume)
	local cont = ents.Create 'dbg_jobs_container'
	cont:SetModel(model)
	cont:SetPos(spawnPos)
	cont:SetAngles(Angle(0, math.random() * 360, 0))
	cont:Spawn()
	cont:Activate()

	local phys = cont:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		timer.Simple(3, function()
			if not IsValid(phys) then return end
			phys:EnableMotion(false)
		end)
	end

	local estateTo = dbgEstates.getNearest(spawnPos)
	local addressTo = estateTo and estateTo.name or '???'

	local desc = ('Требуется доставить к %s:\n%s'):format(addressTo, orderData.text)

	return {
		name = orderType.name,
		icon = orderType.icon,
		desc = desc,
		reward = orderData.reward,
		deposit = math.floor(orderData.money / 40) * 10,
		timeout = orderData.timeout,

		money = orderData.money,
		cont = cont,
		volume = volume,
		queries = orderData.queries,
	}
end

function job.cancel(publishData)
	local cont = publishData.cont
	if IsValid(cont) then cont:Remove() end
end

function job.start(ply, publishData)
	if not IsValid(publishData.cont) then
		ply:Notify('Что-то случилось с контейнером, задание отменено')
		dbgJobs.removeAvailable(publishData.id, true)
		return
	end

	local cont = publishData.cont
	ply:AddMarker({
		id = 'job:' .. publishData.id,
		txt = 'Получатель',
		pos = cont:WorldSpaceCenter(),
		col = Color(255,92,38),
		des = {'time', { octolib.time.toSeconds(2, 'hours') }},
		icon = octolib.icons.silk16('arrow_down'),
	})
	cont:SetDeliveryData(publishData.id, publishData.volume, function(cont)
		for _, query in ipairs(publishData.queries) do
			if not cont:FindItem(query) then return end
		end

		return true
	end)

	return {}
end

function job.finish(startData, isSuccessful)
	local cont = startData.publishData.cont
	if IsValid(cont) then cont:Remove() end

	local ply = startData.ply
	if not IsValid(ply) then return end

	ply:ClearMarkers('job:' .. startData.publishData.id)

	if isSuccessful then
		local totalReward = startData.publishData.money + startData.publishData.deposit

		ply:Notify(('Задание "%s" выполнено! На твой счет перечислено %s'):format(
			startData.publishData.name,
			DarkRP.formatMoney(totalReward)
		))
		ply:BankAdd(totalReward)
	else
		ply:Notify('warning', ('Задание "%s" провалено'):format(startData.publishData.name))
	end
end

dbgJobs.registerType('home', job)
