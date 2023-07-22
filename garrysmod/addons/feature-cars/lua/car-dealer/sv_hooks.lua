hook.Add('PlayerInitialSpawn', 'car-dealer', function(ply)

	timer.Simple(15, function()
		if not IsValid(ply) then return end
		carDealer.sync(ply)

		for _, ent in ipairs(ents.FindByClass('gmod_sent_vehicle_fphysics_base')) do
			if ent:CPPIGetOwner() == ply then
				simfphys.SetOwner(ply, ent)
				carDealer.setCurVeh(ply, ent)
				break
			end
		end
	end)

	timer.Remove('storeVehicle_' .. ply:SteamID())

end)

hook.Add('PlayerDisconnected', 'car-dealer', function(ply)
	local veh = carDealer.getCurVeh(ply)
	if not IsValid(veh) then return end

	if not veh.deposit then
		timer.Create('storeVehicle_' .. ply:SteamID(), 10 * 60, 1, function()
			carDealer.storeVeh(veh)
		end)

		ply:SetDBVar('nextCar', os.time() + 10 * 60 + 30)
	else
		carDealer.storeVeh(veh)
	end
end)

hook.Add('EntityRemoved', 'car-dealer', function(ent)

	if ent:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' then return end

	if ent.deposit then
		carDealer.returnDeposit(ent)
	else
		carDealer.saveVeh(ent)
	end

	local ply = carDealer.getOwner(ent)
	if not IsValid(ply) then return end

	ply:SetNetVar('cd.vehicle')
	ply:SetLocalVar('cd.vehID')
	ply:SetLocalVar('cd.vehName')
	carDealer.sync(ply)
	carDealer.clearMarkers(ply)

end)

local idleTime = 20
local function someoneInside(veh)
	for _, v in ipairs(veh:GetChildren()) do
		if v:GetClass() ~= 'prop_vehicle_prisoner_pod' then continue end
		local dr = v:GetDriver()
		if IsValid(dr) and not dr:IsAFK() then return true end
	end
	return false
end

timer.Create('octocars.removeIdle', 60, 0, function()

	local ct = CurTime()
	local vehs = ents.FindByClass('gmod_sent_vehicle_fphysics_base')

	for _, veh in ipairs(vehs) do

		if veh.doNotEvacuate and not veh.idleScore then continue end
		if someoneInside(veh) then continue end

		local pos = veh:GetPos()
		if veh.idleLastPos then
			local moved = false
			if veh.idleLastPos:DistToSqr(pos) < 10 then
				veh.idleScore = (veh.idleScore or 0) + 1
			else
				if veh.doNotEvacuate then
					veh.idleScore = nil
					continue
				end
				veh.idleScore = math.max((veh.idleScore or 0) - 3, 0)
				moved = true
			end

			local ply = carDealer.getOwner(veh) or veh:CPPIGetOwner()
			if veh.idleScore >= idleTime then
				if ct < (veh.despawnAfter or 0) then return end
				carDealer.storeVeh(veh)
				if IsValid(ply) then
					ply:Notify(L.car_evacuated)
				end
				continue
			elseif veh.idleScore == idleTime - 5 and IsValid(ply) and not moved then
				ply:Notify(L.car_evacuate)
			end
		end

		veh.idleLastPos = pos
	end

end)

hook.Add('OnPlayerChangedTeam', 'car-dealer.refresh', function(ply, old, new)

	local block = false
	local cp = GAMEMODE.CivilProtection
	if cp then block = cp[new] end
	if RPExtraTeams[new].hobo then
		block = true
	end
	ply:SetLocalVar('cd.noPrivate', block)
	carDealer.sync(ply)

	if new == TEAM_ADMIN then return end
	local curVeh = carDealer.getCurVeh(ply)
	if IsValid(curVeh) then
		if not carDealer.canUse(ply, curVeh.cdClass) then
			timer.Create('storeVehicle_' .. ply:SteamID(), 5 * 60, 1, function()
				carDealer.storeVeh(curVeh)
				carDealer.notify(ply, 'warning', L.car_in_garage_unaivaible)
			end)
			return
		end

		if cp and cp[old] ~= cp[new] and new ~= TEAM_ADMIN and old ~= TEAM_ADMIN then
			carDealer.storeVeh(curVeh)
			carDealer.notify(ply, 'warning', cp[old] and L.your_service_car_evacuated or L.your_car_evacuated)
		elseif RPExtraTeams[new].hobo then
			carDealer.storeVeh(curVeh)
			carDealer.notify(ply, 'warning', L.your_car_evacuated)
		end
	end

end)

hook.Add('playerSellVehicle', 'car-dealer', function()
	return false, 'Автомобиль можно продать только у дилера'
end)
