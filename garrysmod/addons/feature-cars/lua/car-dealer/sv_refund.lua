local content = file.Read('dbg_car_refund.json')
if not content then return end

local refundDB = util.JSONToTable(content)
local oldBeforeID = 3000

local function shouldSell(row)
	return refundDB[row.class] ~= nil
end

local function getSellInfoForCar(row)

	if not shouldSell(row) then return end

	local refundData = refundDB[row.class]
	if not istable(row.data) then
		row.data = pon.decode(row.data)
	end

	local info = {}
	table.insert(info, 1, { refundData.name .. ', рег. номер ' .. row.plate })
	table.insert(info, { 'Автомобиль', refundData.price }) -- vehicle itself

	local function addInfo(reason, price)
		price = math.floor(price)
		if price == 0 then return end
		table.insert(info, { reason, price })
	end

	for k, v in pairs(row.data.bg or {}) do
		local bgData = refundData.bgs and refundData.bgs[k] and refundData.bgs[k][v]
		if bgData then addInfo(bgData.name, bgData.price) end
	end
	local rimsData = simfphys.rims[(row.data.rims or {})[1] or '']
	if rimsData then addInfo(rimsData.name, rimsData.price) end

	if row.id < oldBeforeID then addInfo('Старая модель (> 90 дней)', -refundData.price * 0.2) end
	addInfo('Ремонт', math.floor(-50000 * (1 - (row.data.health or 1))))
	addInfo('Дозаправка', math.floor(-refundData.fuelPrice * (1 - (row.data.fuel or 1))))

	return info

end

local function getTotalSellInfo(rows)

	local totalInfo, totalMoney = {}, 0
	local toSell = octolib.array.filter(rows, shouldSell)

	for i, row in ipairs(toSell) do
		local thisInfo = getSellInfoForCar(row)
		totalMoney = totalMoney + octolib.table.reduce(thisInfo, function(acc, line) return acc + (line[2] or 0) end, 0)
		table.Add(totalInfo, thisInfo)
		table.insert(totalInfo, { })
	end

	return totalMoney, totalInfo, toSell

end

local function sendSellInfo(ply)
	octolib.func.chain({
		function(next)
			octolib.db:PrepareQuery('select * from cardealer_owned where garage = ?', { ply:SteamID() }, next)
		end,
		function(next, q, st, rows)
			if #rows < 1 then return end
			local totalMoney, totalInfo = getTotalSellInfo(rows)
			if #totalInfo < 1 then return end

			netstream.Start(ply, 'cd.refundOld', totalInfo)
			ply.hasRefundableCars = true
		end
	})
end
hook.Add('dbg-test.complete', 'car-dealer.refund', sendSellInfo)

local function sellVehicles(ply)
	if not ply.hasRefundableCars then return end
	octolib.func.chain({
		function(next)
			octolib.db:PrepareQuery('select * from cardealer_owned where garage = ?', { ply:SteamID() }, next)
		end,
		function(next, q, st, rows)
			if #rows < 1 then return end
			local totalMoney, totalInfo, toSell = getTotalSellInfo(rows)
			if #toSell < 1 then return end

			carDealer.addMoney(ply, totalMoney)
			carDealer.notify(ply, 'hint', ('На твой банковский счет зачислено %s за старые автомобили'):format(DarkRP.formatMoney(totalMoney)))

			local carAtts = {}
			for _, row in ipairs(toSell) do
				for _, att in ipairs(row.data and row.data.atts or {}) do
					carAtts[#carAtts + 1] = {'car_att', {
						name = att.name,
						desc = att.desc,
						icon = att.icon,
						mass = att.mass,
						volume = att.volume,
						colorable = att.colorable,
						attmdl = att.model,
						model = att.model,
						skin = att.skin,
						scale = att.scale,
					}}
				end

				octolib.db:PrepareQuery('delete from cardealer_owned where id = ?', { row.id })
			end

			if #carAtts > 0 then
				octoinv.addReturnItems(ply, carAtts)
				carDealer.notify(ply, 'hint', 'На автомобилях были аксессуары, их можно вернуть через магазин')
			end

			ply.hasRefundableCars = nil
			carDealer.sync(ply)
		end
	})
end
netstream.Hook('cd.refundOld', sellVehicles)

-- local refundDB = {}
-- for id, vehData in pairs(carDealer.vehicles) do
-- 	if vehData.deposit or vehData.price == 0 then continue end

-- 	local data = {}
-- 	refundDB[id] = data

-- 	data.name = vehData.name
-- 	data.price = vehData.price
-- 	data.spID = vehData.simfphysID

-- 	local bgs = simfphys.carBGs[data.spID]
-- 	if bgs then
-- 		data.bgs = {}
-- 		for i, v in ipairs(bgs) do
-- 			if i == 1 then continue end
-- 			local name, price, bgID, bgNum, mass, volume = unpack(v)
-- 			data.bgs[bgID] = data.bgs[bgID] or {}
-- 			data.bgs[bgID][bgNum] = {
-- 				name = name,
-- 				price = price,
-- 			}
-- 		end
-- 	end

-- 	local spData = list.Get('simfphys_vehicles')[data.spID]
-- 	data.fuelPrice = (simfphys.fuelPrices[spData.Members.FuelType] or 0) * spData.Members.FuelTankSize
-- end

-- file.Write('dbg_car_refund.json', util.TableToJSON(refundDB))
