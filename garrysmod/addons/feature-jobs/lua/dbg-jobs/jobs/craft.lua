octolib.server('craft_jewelry')

local jewelryItems = {
	{ 4500, 'Золотое кольцо с гравировкой' },
	{ 20000, 'Золотое кольцо с алмазом' },
	{ 15000, 'Золотое кольцо с рубином' },
	{ 17000, 'Золотое кольцо с сапфиром' },
	{ 15000, 'Серебряное кольцо с сапфиром' },
	{ 50000, 'Золотой браслет с рубинами' },
	{ 43000, 'Золотое ожерелье с рубинами' },
	{ 45000, 'Серьги с алмазом и жемчужиной' },
}

local orderTypes = {
	{
		name = 'Покупка украшений',
		icon = octolib.icons.silk32('diamond'),
		getOrderData = function()
			local totalMoney = 0
			local queries = {}
			local amount = math.random(1, 3)
			for _, item in RandomPairs(jewelryItems) do
				local price, name = unpack(item)
				totalMoney = totalMoney + price
				queries[#queries + 1] = { class = 'souvenir', name = name }

				if #queries >= amount then break end
			end

			return {
				timeout = octolib.time.toSeconds(30, 'minutes'),
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
job.chance = 0.2

function job.publish()
	local orderType = table.Random(orderTypes)
	if not orderType then return end

	local orderData = orderType.getOrderData()
	if not orderData or #orderData.queries < 1 then return end

	return {
		name = orderType.name,
		icon = orderType.icon,
		desc = 'Требуется доставить к почтовому ящику:\n' .. orderData.text,
		reward = orderData.reward,
		deposit = math.floor(orderData.money / 40) * 10,
		timeout = orderData.timeout,

		money = orderData.money,
		queries = orderData.queries,
	}
end

function job.start(ply, publishData)
	octoinv.expectShipment(ply, publishData.id, function(cont)
		local items = cont:FindItemsByQueryList(publishData.queries)
		if not items then return end

		for _, item in ipairs(items) do
			item:Remove()
		end

		dbgJobs.finishJob(publishData.id, true)
		return true
	end)

	return {}
end

function job.finish(startData, isSuccessful)
	local ply = startData.ply
	if not IsValid(ply) then return end

	octoinv.removeShipment(ply, startData.publishData.id)
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

dbgJobs.registerType('craft', job)
