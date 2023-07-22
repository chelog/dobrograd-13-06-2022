function carDealer.setCurVeh(ply, veh)

	-- use table because 'pon.entityCreated'
	ply:SetNetVar('cd.vehicle', { veh })

	veh:SetNetVar('cd.owner', nil)
	veh:SetNetVar('cd.owner', ply)

end

function carDealer.getCurVehID(ply)

	local veh = carDealer.getCurVeh(ply)
	return veh and veh:GetNetVar('cd.id') or nil

end

function carDealer.getAvailableCategories(ply)

	local result = {}
	for k,v in pairs(carDealer.categories) do
		if (not isfunction(v.canUse) or v.canUse(ply) ~= false)
		and (not isfunction(v.canSee) or v.canSee(ply) ~= false) then
			result[#result + 1] = k
		end
	end

	return result

end

function carDealer.clearMarkers(ply)

	if IsValid(ply) then
		ply:ClearMarkers('car.spawn')
		ply:ClearMarkers('car.despawn')
	end

end

function carDealer.spawnOwnedVeh(ply, id, callback, force)

	callback = callback or octolib.func.zero

	local veh = carDealer.getCurVeh(ply)
	if IsValid(veh) then
		return callback(false, 'Сначала надо загнать свой автомобиль')
	end

	local class, garage, dbData, cdData
	octolib.func.chain({
		function(done) -- checks and stuff
			carDealer.getVehById(id, done)
		end,
		function(done, data) -- prepare entity
			dbData = data or {}
			class, garage = dbData.class, dbData.garage

			if not dbData or (garage ~= ply:SteamID() and not force) then
				return callback(false, 'Ты не приобрел этот автомобиль')
			end

			cdData = class and carDealer.vehicles[class]
			if not cdData or not carDealer.canUse(ply, class) then return callback(false) end

			local catData = cdData.category and carDealer.categories[cdData.category]
			if not catData then return callback(false) end

			local spawns = catData.spawns[game.GetMap()]
				or carDealer.civilSpawns[game.GetMap()]

			if not spawns then
				return callback(false, 'Напиши админам, что они опростоволосились, и передай привет от автодилера')
			end

			carDealer.notify(ply, 'Поиск свободного места...')
			carDealer.nearestPos({
				pPos = ply:GetPos(),
				vars = spawns,
				check = function()
					return IsValid(ply)
				end,
				callback = done,
			})
		end,
		function(_, pos, ang)
			if not IsValid(ply) then return callback(false) end
			if not pos then return callback(false, 'Не получилось найти свободное место') end

			local veh = carDealer.spawnVeh(class, pos, ang, dbData.data)
			if not IsValid(veh) then return callback(false, 'Не получилось создать автомобиль') end

			local mins = veh:GetCollisionBounds()
			local tr = util.TraceLine({
				start = pos,
				endpos = pos + Vector(0, 0, -1000),
				collisiongroup = COLLISION_GROUP_WORLD,
			})

			if tr.Hit then
				veh:SetPos(tr.HitPos + Vector(0, 0, 20 - mins.z))
			end

			veh:SetNetVar('cd.id', id)
			simfphys.SetOwner(ply, veh)
			veh:Lock()

			carDealer.setCurVeh(ply, veh)
			veh:SetNetVar('cd.plate', dbData.plate)

			veh.idleScore = 10
			carDealer.clearMarkers(ply)
			ply:AddMarker({
				id = 'car.spawn',
				txt = cdData.name or 'Автомобиль',
				pos = veh:GetPos() + Vector(0,0,10),
				col = Color(255,92,38),
				des = {'timedist', {600, 300}},
				icon = 'octoteam/icons-16/car.png',
			})

			if dbData.plate then
				hook.Run('car-dealer.spawnedOwned', veh, ply)
				callback(true, veh)
			else
				carDealer.firstAvailablePlate(function(plate)
					veh:SetNetVar('cd.plate', plate)
					hook.Run('car-dealer.spawnedOwned', veh, ply)
					callback(true, veh)
				end)
			end
		end,
	})

end

function carDealer.spawnDepositVeh(ply, class, callback)

	callback = callback or octolib.func.zero

	local veh = carDealer.getCurVeh(ply)
	if IsValid(veh) then
		return callback(false, 'Сначала надо загнать свой автомобиль')
	end

	local cdData = class and carDealer.vehicles[class]
	if not cdData or not carDealer.canUse(ply, class) then return callback(false) end

	local catData = cdData.category and carDealer.categories[cdData.category]
	if not catData then return callback(false) end

	local spawns = catData.spawns[game.GetMap()]
		or carDealer.civilSpawns[game.GetMap()]

	if not spawns then
		return callback(false, 'Напиши админам, что они опростоволосились, и передай привет от автодилера')
	end

	carDealer.nearestPos({
		pPos = ply:GetPos(),
		vars = spawns,
		maxAttempts = 1,
		check = function()
			return IsValid(ply)
		end,
		callback = function(pos, ang)

			if not pos then
				return callback(false, 'Не получилось найти свободное место')
			end

			local veh = carDealer.spawnVeh(class, pos, ang)
			if not IsValid(veh) then return callback(false, 'Не получилось создать автомобиль') end

			local mins = veh:GetCollisionBounds()
			local tr = util.TraceLine({
				start = pos,
				endpos = pos + Vector(0, 0, -1000),
				collisiongroup = COLLISION_GROUP_WORLD,
			})

			if tr.Hit then
				veh:SetPos(tr.HitPos + Vector(0, 0, 20 - mins.z))
			end

			simfphys.SetOwner(ply, veh)
			veh:Lock()

			carDealer.setCurVeh(ply, veh)
			veh.steamID = ply:SteamID()

			veh.idleScore = 10
			carDealer.clearMarkers(ply)
			ply:AddMarker({
				id = 'car.spawn',
				txt = cdData.name or 'Автомобиль',
				pos = veh:GetPos() + Vector(0,0,10),
				col = Color(255,92,38),
				des = {'timedist', {600, 300}},
				icon = 'octoteam/icons-16/car.png',
			})

			carDealer.firstAvailablePlate(function(plate)
				veh:SetNetVar('cd.plate', plate)
				hook.Run('car-dealer.spawnedDeposit', veh, ply)
				callback(true, veh) -- call outer callback
			end)

		end,
	})

end

function carDealer.returnDeposit(ent)

	local ply = ent:GetNetVar('cd.owner')
	local account = IsValid(ply) and ply or ent.steamID
	if not account then return end

	local amount = carDealer.getCurVehPrice(ent)
	local name = ent.cdData.name
	hook.Run('car-dealer.returnedDeposit', ent, ply, amount)
	BraxBank.PlayerMoneyAsync(account, function(money)
		BraxBank.UpdateMoney(account, money + amount)
		if IsValid(ply) then
			carDealer.notify(ply, 'hint', 'Возврат залога за ' .. name .. ': ' .. carDealer.formatMoney(amount))
		end
	end)

end

function carDealer.sync(ply)

	if not IsValid(ply) then return end
	carDealer.getGarage(ply:SteamID(), function(garage)
		local categories = carDealer.getAvailableCategories(ply)
		netstream.Start(ply, 'car-dealer.sync', garage, categories)
	end)

end

function carDealer.canUseCategory(ply, catID)

	if not catID then return false end
	local catData = carDealer.categories[catID]
	if not catData then return false end

	if catData.canUse then
		local ok, why = catData.canUse(ply)
		if ok == false then
			return false, why or 'Ты не можешь использовать эту категорию'
		end
	end

	return true

end

function carDealer.canUse(ply, class)

	local cdData = carDealer.vehicles[class]
	if not cdData then return false, 'Этой модели автомобиля не существует' end

	if cdData.canUse then
		local ok, why = cdData.canUse(ply)
		if ok == false then
			return false, why or 'Ты не можешь использовать этот автомобиль'
		end
	end

	return carDealer.canUseCategory(ply, cdData.category)

end

function carDealer.canBuy(ply, class)

	local cdData = carDealer.vehicles[class]
	if not cdData then return false, 'Этой модели автомобиля не существует' end

	local canUse, canUseWhy = carDealer.canUse(ply, class)
	if not canUse then return canUse, canUseWhy end

	if cdData.canBuy then
		local ok, why = cdData.canBuy(ply)
		if ok == false then
			return false, why or 'Ты не можешь купить этот автомобиль'
		end
	end

	if cdData.canSee then
		local ok, why = cdData.canSee(ply)
		if ok == false then
			return false, why or 'А-та-та'
		end
	end

	-- dont check for nil as it's done in canUseClass
	local catData = carDealer.categories[cdData.category]

	if catData.canBuy then
		local ok, why = catData.canBuy(ply)
		if ok == false then
			return false, why or 'Ты не можешь купить этот автомобиль'
		end
	end

	if catData.canSee then
		local ok, why = catData.canSee(ply)
		if ok == false then
			return false, why or 'А-та-та'
		end
	end

	return true

end

function carDealer.resetPlate(ent, returnItem, admin)
	local id, owner = ent:GetNetVar('cd.id'), ent:CPPIGetOwner()
	if not id or not owner then return end
	local oldPlate = ent:GetNetVar('cd.plate')
	octolib.func.chain({
		carDealer.firstAvailablePlate,
		function(done, plate)
			carDealer.updateVehData(id, {plate = plate}, function()
				done(plate)
			end)
		end,
		function(done, plate)
			ent:SetNetVar('cd.plate', plate)
			owner:Notify('Администрация сбросила номер ' .. tostring(oldPlate) .. ' на твоем автомобиле')
			if returnItem then
				owner:osGiveItem('car_plate', function()
					owner:Notify('Плюшка "Блатной номер" была возвращена')
					done()
				end)
			else
				owner:Notify('Плюшка "Блатной номер" возвращена не будет')
				done()
			end
		end,
		function()
			if admin then
				hook.Run('car-dealer.resetPlate', admin, ent, oldPlate, returnItem)
			end
		end,
	})
end
