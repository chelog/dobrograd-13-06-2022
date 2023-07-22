carDealer = carDealer or {}
carDealer.categories = carDealer.categories or {}
carDealer.vehicles = carDealer.vehicles or {}

function carDealer.addCategory(id, data)

	carDealer.categories[id] = data
	carDealer.lastCategory = id

end

function carDealer.addVeh(id, data)

	if not data.price then data.price = 0 end
	if not data.category then data.category = carDealer.lastCategory or 'main' end

	carDealer.vehicles[id] = data

	if CLIENT then
		local spData = list.Get('simfphys_vehicles')[data.simfphysID]
		if spData and spData.Model then util.PrecacheModel(spData.Model) end
	end

end

function carDealer.getCurVeh(ply)

	if not IsValid(ply) then return end

	-- use table because 'pon.entityCreated'
	local vehTbl = ply:GetNetVar('cd.vehicle')
	if istable(vehTbl) then
		return ply:GetNetVar('cd.vehicle')[1]
	end

end

function carDealer.limitedSpawn(max, limitGroup, msg)

	return function(ply, class)
		local count = 0
		for _, v in ipairs(ents.FindByClass('gmod_sent_vehicle_fphysics_base')) do
			local car = v.cdClass and carDealer.vehicles[v.cdClass]
			local category = car and carDealer.categories[car.category]
			if category and category.limitGroup == limitGroup then
				count = count + 1
				if count >= max then return false, msg end
			end
		end
		return true
	end

end
