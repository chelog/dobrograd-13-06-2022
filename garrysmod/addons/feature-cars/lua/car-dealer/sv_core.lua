local defaultColors = { Color(255,255,255), Color(255,255,255), Color(0,0,0), Color(255,255,255) }

hook.Add('octolib.db.init', 'car-dealer.init', function()

	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS cardealer_owned (
			id INT UNSIGNED NOT NULL AUTO_INCREMENT,
			garage VARCHAR(30) NOT NULL,
			class VARCHAR(30) NOT NULL,
			plate VARCHAR(7) NOT NULL,
			data TEXT NOT NULL,
				PRIMARY KEY (id),
				UNIQUE (plate)
		)
	]])
	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS cardealer_plates (
			vehicleID INT UNSIGNED NOT NULL,
			garage VARCHAR(30) NOT NULL,
			plate VARCHAR(7) NOT NULL,
			changeDate INT NOT NULL,
				INDEX cardealer_plates_ibfk_1 (vehicleID),
				CONSTRAINT cardealer_plates_ibfk_1
					FOREIGN KEY (vehicleID)
					REFERENCES cardealer_owned(id)
					ON UPDATE CASCADE ON DELETE CASCADE
		)
	]])

end)

function carDealer.getVehById(id, callback)

	callback = callback or octolib.func.zero

	octolib.db:PrepareQuery('select * from cardealer_owned where id=? limit 1', { id }, function(_, _, data)
		local data = istable(data) and data[1]
		if not data then return callback() end
		data.data = pon.decode(data.data) or {}
		callback(data)
	end)

end

function carDealer.getVehByPlate(plate, callback)

	callback = callback or octolib.func.zero

	octolib.db:PrepareQuery('select * from cardealer_owned where plate=? limit 1', { plate:upper() }, function(_, _, data)
		local data = istable(data) and data[1]
		if not data then return callback() end
		data.data = pon.decode(data.data) or {}
		callback(data)
	end)

end

function carDealer.getGarage(garage, callback)

	callback = callback or octolib.func.zero

	octolib.db:PrepareQuery('select id, class, plate, data from cardealer_owned where garage=?', { garage }, function(_, _, data)
		if istable(data) then
			local toReturn = {}
			for _, row in ipairs(data) do
				toReturn[row.id] = {
					class = row.class,
					plate = row.plate,
					data = pon.decode(row.data) or {},
				}
			end
			callback(toReturn)
		else
			callback({})
		end
	end)

end

function carDealer.randomPlate(length)

	local symbols = carDealer.plateSymbols
	local plate = {}
	for i = 1, length do
		plate[i] = symbols[math.random(#symbols)]
	end

	return table.concat(plate)

end

function carDealer.firstAvailablePlate(callback)

	callback = callback or octolib.func.zero

	octolib.func.loop(function(again)
		local plate = carDealer.randomPlate(carDealer.plateLength)
		carDealer.getVehByPlate(plate, function(veh)
			if veh then
				again()
			else
				callback(plate)
			end
		end)
	end)

end

function carDealer.ownVeh(garage, class, callback)

	callback = callback or octolib.func.zero

	local cdData = carDealer.vehicles[class]
	assert(cdData ~= nil, 'Wrong vehicle class: ' .. class)

	octolib.func.chain({
		function(done)
			carDealer.firstAvailablePlate(done)
		end,
		function(done, plate)
			octolib.db:PrepareQuery('insert into cardealer_owned(garage, class, plate, data) values(?, ?, ?, ?)', {
				garage, class, plate, pon.encode({}),
			}, function(q, st, res)
				if not st then return end
				done(q:lastInsert(), plate)
			end)
		end,
		function(_, id, plate)
			local ply = player.GetBySteamID(garage)
			if IsValid(ply) then carDealer.sync(ply) end
			callback(id, plate) -- call outer callback
		end,
	})

end

function carDealer.unownVeh(id, callback)

	callback = callback or octolib.func.zero

	octolib.func.chain({
		function(done)
			carDealer.getVehById(id, done)
		end,
		function(done, veh)
			if not veh then return callback(false) end

			local ply = player.GetBySteamID(veh.garage)
			if IsValid(ply) and carDealer.getCurVehID(ply) == id then
				carDealer.despawnVeh(carDealer.getCurVeh(ply))
			end

			octolib.db:PrepareQuery('delete from cardealer_owned where id=?', { id }, function(q, st, res)
				if q:affectedRows() < 1 then return callback(false) end
				done(true, veh, ply)
			end)
		end,
		function(done, unowned, veh, ply)
			octolib.db:PrepareQuery('delete from cardealer_plates where vehicleID=?', {id}, function()
				done(unowned, veh, ply)
			end)
		end,
		function(_, unowned, veh, ply)
			if unowned and IsValid(ply) then
				carDealer.sync(ply)
			end
			callback(veh)
		end,
	})

end

function carDealer.getCurVehPrice(ent)

	if not IsValid(ent) or not ent.cdClass then return 0 end
	local data = carDealer.vehicles[ent.cdClass]
	if not data then return end

	local price = ent.deposit or data.price
	price = price * ent:GetCurHealth() / ent:GetMaxHealth()
	price = price - (ent:GetMaxFuel() - ent:GetFuel()) * simfphys.fuelPrices[ent:GetFuelType()]
	for _, wheel in ipairs(ent.Wheels or {}) do
		if wheel:GetDamaged() then price = price - 3500 end
	end

	return math.max(0, math.Round(price))

end

function carDealer.nearestPos(data)

	if not istable(data) or
		not isvector(data.pPos) or
		not istable(data.vars) or
		not isfunction(data.callback) then return end

	local count = 0
	octolib.func.loop(function(done)

		local mnDist = math.huge
		local freeSpace, pos, ang = Vector(75, 75, 75)
		for _,v in ipairs(data.vars) do
			local dist = v[1]:DistToSqr(data.pPos)
			if dist >= mnDist then continue end
			local tr = util.TraceHull({
				mins = -freeSpace,
				maxs = freeSpace,
				start = v[1],
				endpos = v[1],
				ignoreworld = true,
				filter = data.filter,
			})

			if not tr.Hit then
				pos, ang = unpack(v)
				if data.okDist and dist <= data.okDist then
					return data.callback(pos, ang, dist)
				end
				mnDist = dist
			end
		end

		count = count + 1
		if not pos and (not isfunction(data.check) or data.check()) and count < (data.maxAttempts or 20) then
			timer.Simple(3, done)
		else data.callback(pos, ang, mnDist) end

	end)

end

function carDealer.getOwner(ent)

	return ent:GetNetVar('cd.owner')

end

function carDealer.saveVeh(ent, callback)

	callback = callback or octolib.func.zero

	if not IsValid(ent) then return callback() end
	if not ent:GetNetVar('cd.id') then return callback(ent) end

	local cdData = ent.cdData
	if not cdData or cdData.deposit then return callback(ent) end

	spData = list.Get('simfphys_vehicles')[cdData.simfphysID]
	if not spData then return end

	local members = spData.Members

	local data = {}
	data.health = ent:GetCurHealth() / ent:GetMaxHealth()
	data.fuel = ent:GetFuel() / ent:GetMaxFuel()
	data.col = octolib.table.mapSequential(ent:GetProxyColors(), function(v)
		if not v.r then return Color() end
		return Color((v.r or 1) * 255, (v.g or 1) * 255, (v.b or 1) * 255, (v.a or 1) * 255)
	end)
	data.atts = ent:GetNetVar('atts')

	data.wheels = {}
	local allWheelsOK = false
	for k,v in ipairs(ent.Wheels or {}) do
		data.wheels[k] = v:GetDamaged()
		if v:GetDamaged() then allWheelsOK = true end
	end
	if not allWheelsOK then data.wheels = '--delete--' end

	data.camber = ent.camber or 0
	data.wOffset = { ent.wOffsetF or 0, ent.wOffsetR or 0 }
	data.rims = {
		ent.wModelF or members.CustomWheelModel,
		ent.wModelR or members.CustomWheelModel or members.CustomWheelModel_R
	}
	data.susp = {
		ent:GetFrontSuspensionHeight() or 0,
		ent.consF or members.FrontConstant or 25000,
		ent.dampF or members.FrontDamping or 1500,
		ent:GetRearSuspensionHeight() or 0,
		ent.consR or members.RearConstant or 25000,
		ent.dampR or members.RearDamping or 1500
	}
	data.inv = ent:ExportInventory()

	-- these are reset when marked for deletion leading to data loss
	if not ent:IsMarkedForDeletion() then
		data.skin = ent:GetSkin()
		data.bg = {}
		for _, v in pairs(ent:GetBodyGroups()) do data.bg[v.id] = ent:GetBodygroup(v.id) end
	end

	carDealer.updateVehData(ent:GetNetVar('cd.id'), data, function() callback(ent) end)

end

function carDealer.updateVehData(id, override, callback)

	callback = callback or octolib.func.zero

	octolib.func.chain({
		function(done)
			carDealer.getVehById(id, done)
		end,
		function(done, veh)
			if not veh then return callback() end

			if override.plate then
				octolib.db:PrepareQuery('update cardealer_owned set plate=? where id=?', {
					string.upper(override.plate), id
				})
				veh.plate = string.upper(override.plate)
				override.plate = nil
			end
			for k, v in pairs(override) do
				veh.data[k] = v ~= '--delete--' and v or nil
			end

			octolib.db:PrepareQuery('update cardealer_owned set data=? where id=?', {
				pon.encode(veh.data), id
			}, function()
				done(veh)
			end)
		end,
		function(_, veh)
			if veh then
				local ply = player.GetBySteamID(veh.garage)
				if IsValid(ply) then
					carDealer.sync(ply)
				end
			end
			callback() -- call outer callback
		end,
	})

end

function carDealer.spawnVeh(class, pos, ang, saved)

	saved = saved or {}

	local cdData = carDealer.vehicles[class]
	if not cdData then return end
	local cdcData = cdData.category and carDealer.categories[cdData.category] or {}

	spData = list.Get('simfphys_vehicles')[cdData.simfphysID]
	if not spData then return end

	if cdData.SpawnAngleOffset then
		ang = cdData.SpawnAngleOffset
	end

	local veh = simfphys.SpawnVehicle(nil, pos, ang, spData.Model, spData.Class, cdData.simfphysID, spData, true)
	if not veh then return end
	veh.cdClass = class
	veh.cdData = cdData
	veh.preventEms = not cdcData.ems
	veh.doNotEvacuate = cdcData.doNotEvacuate
	veh.cdBulletproof = cdData.bulletproof
	veh.baseMass = veh.Mass * 0.75

	local cols = saved.col or cdData.default and cdData.default.col or defaultColors
	if isfunction(cols) then cols = cols() end
	veh:SetProxyColors({ cols[1], cols[2], CFG.reflectionTint, cols[4] })
	veh:SetSkin(saved.skin or cdData.default and cdData.default.skin or 0)
	local mats = saved.mats or cdData.default and cdData.default.mats or {}
	for k, v in pairs(mats) do
		veh:SetSubMaterial(k-1, v)
	end
	veh:SetNetVar('atts', saved.atts)

	timer.Simple(1, function()
		if not IsValid(veh) then return end

		if saved.fuel then veh:SetFuel(veh:GetMaxFuel() * math.max(saved.fuel, 0)) end
		if cdData.plateCol then
			veh:SetNetVar('cd.plateCol', {
				cdData.plateCol.bg,
				cdData.plateCol.border,
				cdData.plateCol.title,
				cdData.plateCol.txt,
			})
		elseif cdData.police then
			veh:SetNetVar('cd.plateCol', {
				Color(75, 86, 208),
				Color(40, 40, 40),
				Color(255, 255, 255),
				Color(255, 255, 255),
			})
		end

		if saved.health then
			local health = saved.health
			veh:TakeDamage(math.min(veh:GetCurHealth() - 1, veh:GetMaxHealth() * (1 - health)))

			if health <= 0.05 then -- crash light signals
				net.Start('simfphys_turnsignal')
					net.WriteEntity(veh)
					net.WriteInt(1, 32)
				net.Broadcast()
			end
		end

		if cdData.police then
			local mh = veh:GetMaxHealth() * 2
			veh:SetMaxHealth(mh)
			veh:SetCurHealth(mh)
			-- veh:SetMaxTorque(spData.Members.PeakTorque * 0.9)
			veh.police = true
			veh.snd_horn = 'octoteam/vehicles/police/warning.wav'
		end

		if cdData.radioWhitelist and veh.Radio then
			veh.Radio:SetStationsWhitelist(cdData.radioWhitelist)
		end

		if saved.wheels then
			for k,v in ipairs(veh.Wheels) do
				v:SetDamaged(saved.wheels[k])
			end
		end

		local members = spData.Members
		if saved.rims or saved.camber then
			local f = saved.rims and saved.rims[1] or members.CustomWheelModel
			local r = saved.rims and saved.rims[2] or members.CustomWheelModel_R or f
			simfphys.ApplyWheel(veh, saved.camber or 0, f, r)
		end

		for k, v in pairs(saved.bg or cdData.default and cdData.default.bg or {}) do
			veh:SetBodygroup(k, v)
		end
		if saved.inv then veh:ImportInventory(saved.inv) end
		veh:UpdateInventory()

		if saved.susp then
			simfphys.SetupSuspension(veh, {
				saved.susp[1] or 0,
				saved.susp[2] or members.FrontConstant or 25000,
				saved.susp[3] or members.FrontDamping or 1500,
				saved.susp[4] or 0,
				saved.susp[5] or members.RearConstant or 25000,
				saved.susp[6] or members.RearDamping or 1500
			})
		end

		if saved.wOffset then
			simfphys.SetWheelOffset(veh, saved.wOffset[1] or 0, saved.wOffset[2] or 0)
		end

		if saved.torque then veh:SetMaxTorque(members.PeakTorque * saved.torque) end
		if saved.grip then veh:SetMaxTraction(members.MaxGrip * saved.grip) end
		if saved.steer then veh:SetSteerSpeed(members.TurnSpeed * saved.steer) end
		if saved.csteer then veh.CounterSteeringMul = saved.csteer end
		if saved.turbo ~= nil then veh:SetTurboCharged(saved.turbo) end
		if saved.super ~= nil then veh:SetSuperCharged(saved.super) end
	end)

	return veh

end

function carDealer.despawnVeh(veh)

	if not IsValid(veh) then return end

	carDealer.saveVeh(veh)
	veh.handledRemove = true
	veh:Remove()

end

function carDealer.storeVeh(veh, callback)

	callback = callback or octolib.func.zero
	if not IsValid(veh) then return callback(false) end

	-- already being saved in EntityRemoved
	-- octolib.func.chain({
	-- 	function(done)
	-- 		carDealer.saveVeh(veh, done)
	-- 	end,
	-- 	function()
			carDealer.despawnVeh(veh)
			callback(true)
	-- 	end,
	-- })

end

hook.Add('car-dealer.plateChanged', 'car-dealer.logToDb', function(id, owner, newPlate)
	octolib.db:PrepareQuery('insert into cardealer_plates (vehicleID, garage, plate, changeDate) values (?, ?, ?, ?)',
		{id, owner, string.upper(newPlate), os.time()})
end)

function carDealer.getPlateChangeHistory(id, garage, done)
	octolib.func.chain({
		function(done)
			octolib.db:PrepareQuery([[select count(*) as count from cardealer_plates where garage = ?]], {garage}, function(q, st, res)
				done(istable(res) and res[1] and res[1].count or 0)
			end)
		end,
		function(_, gCount)
			octolib.db:PrepareQuery([[select plate from cardealer_plates where vehicleID = ? order by changeDate desc limit 20]], {id}, function(q, st, res)
				local hist = {}
				for _,v in ipairs(res or {}) do
					hist[#hist + 1] = v.plate
				end
				done(gCount, hist)
			end)
		end,
	})
end
