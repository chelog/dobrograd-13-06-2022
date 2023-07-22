netstream.Hook('car-dealer.sync', function(ply)
	carDealer.sync(ply)
end)

local busyFor = {}
hook.Add('PlayerDisconnected', 'car-dealer.busy', function(ply)
	busyFor[ply] = nil
end)

function carDealer.Listen(channel, handler)
	netstream.Listen(channel, function(reply, ply, ...)

		if busyFor[ply] then
			carDealer.notify(ply, 'warning', 'Продавец машин сейчас занят, попробуй повторить попытку позже')
			return reply()
		end
		busyFor[ply] = true

		handler(function(...)
			if IsValid(ply) then busyFor[ply] = nil end
			reply(unpack({...}))
		end, ply, unpack({...}))

	end)
end

local function tryQueuedSpawn(ply, idOrClass, callback)

	local queued = ply:GetLocalVar('car-dealer.queued')
	queued = queued and queued[1]
	if queued then
		if queued ~= idOrClass then
			carDealer.notify(ply, 'warning', 'Ты уже ожидаешь автомобиль. Дождись своей очереди или покинь ее')
			callback()
		end

		if ply:GetLocalVar('car-dealer.queuedReady') then
			carDealer.spawningQueuedAuto = true
			ply:Notify('admin', 0)

			if isnumber(queued) then
				carDealer.spawnOwnedVeh(ply, queued, function(ok, veh)
					carDealer.removeFromQueue(ply)
					carDealer.spawningQueuedAuto = false

					if not ok then
						carDealer.notify(ply, 'warning', veh or 'Не получилось создать автомобиль')
						return callback()
					end

					callback(veh)
				end)
			else
				carDealer.spawnDepositVeh(ply, queued, function(ok, veh)
					carDealer.removeFromQueue(ply)
					carDealer.spawningQueuedAuto = false

					if not ok then
						carDealer.notify(ply, 'warning', veh or 'Не получилось создать автомобиль')
						return callback()
					end

					callback(veh)
				end)
			end
		else
			carDealer.notify(ply, 'warning', 'Ты уже ожидаешь автомобиль. Дождись своей очереди или покинь ее')
			callback()
		end
	end

	carDealer.notify(ply, 'Твой запрос поставлен в очередь. Ожидай уведомления о готовности автомобиля')
	carDealer.addToQueue(ply, idOrClass)

	callback()

end

carDealer.Listen('car-dealer.spawn', function(reply, ply, id)

	if ply:IsGhost() or ply:GetLocalVar('cd.cantHaveOwned') then
		carDealer.notify(ply, 'warning', 'Ты не можешь пригонять автомобили сейчас')
		return reply()
	end

	local veh = carDealer.getCurVeh(ply)
	if IsValid(veh) then
		carDealer.notify(ply, 'warning', 'Сначала надо загнать свой автомобиль')
		carDealer.setCurVeh(ply, veh)
		return reply()
	end

	local nextCar = ply:GetDBVar('nextCar')
	if nextCar and os.time() < nextCar then
		carDealer.notify(ply, 'warning', 'Твой автомобиль находится в другой части города')
		return reply()
	end

	carDealer.getVehById(id, function(veh)
		if not veh or veh.garage ~= ply:SteamID() then
			carDealer.notify(ply, 'warning', 'Ты не владеешь этим автомобилем')
			return reply()
		end

		local class = veh and veh.class
		local cdData = carDealer.vehicles[class]
		if not cdData then
			carDealer.notify(ply, 'warning', 'Не получилось найти данные об автомобиле')
			return reply()
		end

		local category = carDealer.categories[cdData.category]
		local ok, why = carDealer.canUse(ply, class)
		if not ok or not category then
			carDealer.notify(ply, 'warning', why or 'Ты не можешь использовать этот автомобиль')
			return reply()
		end

		if isfunction(category.spawnCheck) then
			local can, why = category.spawnCheck(ply, class)
			if can == false then
				carDealer.notify(ply, why or 'Ты не можешь пригнать этот автомобиль сейчас')
				return reply()
			end
		end

		if category.queue then
			tryQueuedSpawn(ply, id, function(veh)
				if not veh then return reply() end

				carDealer.notify(ply, (veh.cdData.name or 'Автомобиль') .. ' ждет тебя неподалеку. Забери его в течение 10 минут, или автомобиль эвакуируют')
				veh.despawnAfter = CurTime() + 15 * 60
			end)
		else
			carDealer.spawnOwnedVeh(ply, id, function(ok, veh)
				if ok then
					carDealer.notify(ply, (veh.cdData.name or 'Автомобиль') .. ' ждет тебя неподалеку. Забери его в течение 10 минут, или автомобиль эвакуируют')
				else
					carDealer.notify(ply, 'warning', veh or 'Не получилось создать автомобиль')
				end

				carDealer.sync(ply)
				reply()
			end)
		end
	end)

end)

carDealer.Listen('car-dealer.despawn', function(reply, ply)

	local queued = ply:GetLocalVar('car-dealer.queued')
	if queued then
		carDealer.spawningQueuedAuto = false
		carDealer.removeFromQueue(ply)
		ply:Notify('admin', 0)
		carDealer.notify(ply, 'Ты покинул очередь')
		return reply(true)
	end

	local veh = carDealer.getCurVeh(ply)
	if not IsValid(veh) or not veh.cdData then
		carDealer.notify(ply, 'warning', 'У тебя нет автомобилей в городе')
		return reply()
	end

	if CurTime() < (veh.despawnAfter or 0) then
		carDealer.notify(ply, 'warning', 'Автомобиль можно загнать не ранее 15 минут после получения')
		return reply()
	end

	if ply:IsGhost() then
		carDealer.notify(ply, 'warning', 'Ты не можешь загонять автомобили сейчас')
		return reply()
	end

	local catData = carDealer.categories[veh.cdData.category]
	local spawns = catData.spawns[game.GetMap()]
		or carDealer.civilSpawns[game.GetMap()]

	if not spawns then
		carDealer.notify(ply, 'warning', 'Напиши админам, что они опростоволосились, и передай привет от автодилера')
		return reply()
	end

	octolib.func.chain({
		function(done)
			carDealer.nearestPos({
				pPos = veh:GetPos(),
				vars = spawns,
				okDist = 10000,
				check = function()
					return IsValid(ply) and IsValid(veh)
				end,
				callback = done,
				filter = table.Add(table.Add({ply, veh}, veh:GetChildren()), constraint.GetAllConstrainedEntities(veh)),
			})
		end,
		function(done, pos, _, distSqr)
			if not IsValid(ply) or not IsValid(veh) then return end
			if not pos then
				carDealer.notifty(ply, 'warning', 'Не получилось найти свободное место')
				return reply(true)
			end
			if distSqr > 10000 then
				carDealer.notify(ply, 'Оставь свой автомобиль на указанной точке и нажми "Загнать" снова. Если оно будет занято, повтори это действие')
				ply:AddMarker({
					id = 'car.despawn',
					txt = 'Парковочное место',
					pos = pos + Vector(0,0,10),
					col = Color(255,92,38),
					des = {'timedist', {600, 100}},
					icon = 'octoteam/icons-16/car.png',
				})
				reply(true)
			else done() end
		end,
		function(done)
			carDealer.saveVeh(veh, done)
		end,
		function(done)
			hook.Run('car-dealer.stored', veh, ply)
			carDealer.despawnVeh(veh, done)
			carDealer.notify(ply, (veh.cdData.name or 'Автомобиль') .. ' в гараже')
			carDealer.clearMarkers(ply)
			carDealer.sync(ply)
			reply(true)
		end,
	})

end)

carDealer.Listen('car-dealer.rent', function(reply, ply, class)

	if ply:IsGhost() then
		carDealer.notify(ply, 'warning', 'Ты не можешь пригонять автомобили сейчас')
		return reply()
	end

	local veh = carDealer.getCurVeh(ply)
	if IsValid(veh) then
		carDealer.notify(ply, 'warning', 'Сначала надо загнать свой автомобиль')
		carDealer.setCurVeh(ply, veh)
		return reply()
	end

	local cdData = carDealer.vehicles[class]
	if not cdData then
		carDealer.notify(ply, 'warning', 'Не получилось найти данные об автомобиле')
		return reply()
	end

	local category = carDealer.categories[cdData.category]
	local ok, why = carDealer.canUse(ply, class)
	if not ok or not category or not cdData.deposit then
		carDealer.notify(ply, 'warning', why or 'Ты не можешь арендовать этот автомобиль')
		return reply()
	end

	if isfunction(category.spawnCheck) then
		local can, why = category.spawnCheck(ply, class)
		if can == false then
			carDealer.notify(ply, why or 'Ты не можешь пригнать этот автомобиль сейчас')
			return reply()
		end
	end

	local price = hook.Run('car-dealer.priceOverride', ply, class) or cdData.price or carDealer.defaultDeposit
	if not carDealer.hasMoney(ply, price) then
		carDealer.notify(ply, 'warning', 'На банковском счете недостаточно средств')
		return reply()
	end

	if category.queue then
		tryQueuedSpawn(ply, class, function(veh)
			if not veh then return reply() end

			carDealer.addMoney(ply, -price)
			carDealer.notify(ply, 'С твоего банковского счета снят залог за ' .. (veh.cdData.name or 'автомобиль') .. ' в размере ' .. carDealer.formatMoney(price))
			carDealer.notify(ply, (cdData.name or 'Автомобиль') .. ' ждет тебя неподалеку. Забери его в течение 10 минут, или автомобиль эвакуируют')
			veh.deposit = price
			reply(true)
		end)
	else
		carDealer.spawnDepositVeh(ply, class, function(ok, veh)
			if not ok then
				carDealer.notify(ply, 'warning', veh or 'Не получилось создать автомобиль')
				return reply()
			end

			carDealer.addMoney(ply, -price)
			carDealer.notify(ply, 'С твоего банковского счета снят залог за ' .. (veh.cdData.name or 'автомобиль') .. ' в размере ' .. carDealer.formatMoney(price))
			carDealer.notify(ply, (cdData.name or 'Автомобиль') .. ' ждет тебя неподалеку. Забери его в течение 10 минут, или автомобиль эвакуируют')
			veh.deposit = price
			reply(true)
		end)
	end

end)

carDealer.Listen('car-dealer.buy', function(reply, ply, class, bg)

	class = class or ''
	bg = bg or {}

	if ply:IsGhost() then
		carDealer.notify(ply, 'warning', 'Ты не можешь покупать автомобили сейчас')
		return reply()
	end

	local cdData = carDealer.vehicles[class]
	local category = cdData and carDealer.categories[cdData.category]

	local ok, why = carDealer.canBuy(ply, class)
	if not ok or not category then
		carDealer.notify(ply, 'warning', why or 'Ты не можешь купить этот автомобиль')
		return reply()
	end

	if cdData.deposit then return reply() end

	local pr = hook.Run('car-dealer.priceOverride', ply, class, bg) or cdData.price

	local bgDefault = cdData.default and cdData.default.bg
	local bgData = cdData.bodygroups
	if not bgData then
		bg = {}
	elseif bg then
		for k, v in pairs(bg) do
			local variant = bgData[k] and bgData[k].variants[v + 1]
			if not variant then
				bg[k] = nil
				continue
			end

			local originalVal = bgDefault and bgDefault[k] or 0
			if v ~= originalVal then
				pr = pr + variant[2]
			end
		end
	end

	if bgDefault then
		for k, v in pairs(bgDefault) do
			if not bg[k] then bg[k] = v end
		end
	end

	if not carDealer.hasMoney(ply, pr) then
		carDealer.notify(ply, 'warning', carDealer.formatMoney(pr) .. ' должны лежать у тебя в банке')
		return reply()
	end

	carDealer.addMoney(ply, -pr)
	carDealer.ownVeh(ply:SteamID(), class, function(id, plate)
		carDealer.notify(ply, 'Ты приобрел ' .. (cdData.name or 'Автомобиль') .. ' с регистрационным номером ' .. plate)
		hook.Run('car-dealer.bought', class, ply, pr, id)

		carDealer.updateVehData(id, { bg = bg })
		reply(true)
	end)

end)

carDealer.Listen('car-dealer.sell', function(reply, ply, id)

	if not id then return end
	if ply:IsGhost() then
		return reply()
	end

	local veh
	octolib.func.chain({
		function(done)
			local veh = carDealer.getCurVeh(ply)
			if IsValid(veh) and veh:GetNetVar('cd.id') == id then
				carDealer.notify(ply, 'Сначала надо загнать свой автомобиль')
				return reply()
			end

			carDealer.getVehById(id, done)
		end,
		function(done, _veh)
			veh = _veh
			if not veh or veh.garage ~= ply:SteamID() then
				carDealer.notify(ply, 'warning', 'В твоем гараже нет этого автомобиля')
				return reply()
			end

			carDealer.unownVeh(id, done)
		end,
		function(_, unowned)
			if not unowned then return reply() end

			local toSend = {}
			for _, att in ipairs(veh.data.atts or {}) do
				toSend[#toSend + 1] = {'car_att', {
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

			if #toSend > 0 then
				octoinv.addReturnItems(ply, toSend)
				carDealer.notify(ply, 'hint', 'На автомобиле были аксессуары, ты можешь их вернуть через магазин')
			end

			local cdData = carDealer.vehicles[veh.class]
			local price = cdData.price * carDealer.sellPrice
			carDealer.addMoney(ply, price)
			carDealer.notify(ply, 'Ты продал ' .. (cdData.name or 'Автомобиль') .. ' за ' .. DarkRP.formatMoney(price))
			if ply:GetLocalVar('car-dealer.queued') and ply:GetLocalVar('car-dealer.queued')[1] == id then
				carDealer.removeFromQueue(ply)
			end
			hook.Run('car-dealer.sold', veh, ply, price)
			reply(true)
		end,
	})

end)
