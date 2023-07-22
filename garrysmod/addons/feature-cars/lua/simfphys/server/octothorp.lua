--
-- OCTOSIMFPHYS
--

function simfphys.GetRight(ent, index, WheelPos)
	local Steer = ent:GetTransformedDirection()

	local Right = ent.Right

	if WheelPos.IsFrontWheel then
		Right = (IsValid(ent.SteerMaster) and Steer.Right or ent.Right) * (WheelPos.IsRightWheel and 1 or -1)
	else
		Right = (IsValid(ent.SteerMaster) and Steer.Right2 or ent.Right) * (WheelPos.IsRightWheel and 1 or -1)
	end

	return Right
end

function simfphys.SetWheelOffset(ent, offset_front, offset_rear)
	if not IsValid(ent) then return end

	offset_front = math.Clamp(offset_front, -8, 4)
	offset_rear = math.Clamp(offset_rear, -8, 4)

	ent.wOffsetF = offset_front
	ent.wOffsetR = offset_rear

	if not istable(ent.Wheels) or not istable(ent.GhostWheels) then return end

	for i = 1, table.Count(ent.GhostWheels) do
		local Wheel = ent.Wheels[ i ]
		local WheelModel = ent.GhostWheels[i]
		local WheelPos = ent:LogicWheelPos(i)

		if IsValid(Wheel) and IsValid(WheelModel) then
			local Pos = Wheel:GetPos()
			local Right = simfphys.GetRight(ent, i, WheelPos)
			local offset = WheelPos.IsFrontWheel and offset_front or offset_rear

			WheelModel:SetParent(nil)

			local physObj = WheelModel:GetPhysicsObject()
			if IsValid(physObj) then
				physObj:EnableMotion(false)
			end

			WheelModel:SetPos(Pos + Right * offset)
			WheelModel:SetParent(Wheel)
		end
	end
end

function simfphys.ApplyWheel(ent, camber, front, rear)

	rear = rear or front
	local aof, aor = simfphys.GetWheelAngle(front), simfphys.GetWheelAngle(rear)
	if not aof or not aor then print('Wheel model not registered') return end

	ent.wModelF = front
	ent.wModelR = rear
	ent.waOffsetF = aof
	ent.waOffsetR = aor
	ent.camber = math.Clamp(camber or 0, -18, 10)

	ent.PressedKeys["A"] = nil
	ent.PressedKeys["D"] = nil
	ent.SmoothAng = 0
	ent:SteerVehicle(0)

	timer.Simple(0.05, function()
		if not IsValid(ent) then return end

		for i = 1, table.Count(ent.GhostWheels) do
			local Wheel = ent.GhostWheels[i]

			if IsValid(Wheel) then
				local isfrontwheel = (i == 1 or i == 2)
				local swap_y = (i == 2 or i == 4 or i == 6)

				local angleoffset = isfrontwheel and ent.waOffsetF or ent.waOffsetR

				local model = isfrontwheel and ent.wModelF or ent.wModelR

				local fAng = ent:LocalToWorldAngles(ent.VehicleData.LocalAngForward)
				local rAng = ent:LocalToWorldAngles(ent.VehicleData.LocalAngRight)

				local Forward = fAng:Forward()
				local Right = swap_y and -rAng:Forward() or rAng:Forward()
				local Up = ent:GetUp()

				local ghostAng = Right:Angle()
				local mirAng = swap_y and 1 or -1
				ghostAng:RotateAroundAxis(Forward,angleoffset.p * mirAng)
				ghostAng:RotateAroundAxis(Right,angleoffset.r * mirAng)
				ghostAng:RotateAroundAxis(Up,-angleoffset.y)

				ghostAng:RotateAroundAxis(Forward, ent.camber * mirAng)

				Wheel:SetModelScale(1)
				Wheel:SetModel(model)
				Wheel:SetAngles(ghostAng)

				timer.Simple(0.05, function()
					if not IsValid(Wheel) or not IsValid(ent) then return end
					local wheelsize = Wheel:OBBMaxs() - Wheel:OBBMins()
					local radius = isfrontwheel and ent.FrontWheelRadius or ent.RearWheelRadius
					local size = (radius * 2) / math.max(wheelsize.x,wheelsize.y,wheelsize.z)

					Wheel:SetModelScale(size)
				end)
			end
		end
	end)
end

function simfphys.ValidateModel(model)
	local v_list = list.Get("simfphys_vehicles")
	for listname, _ in pairs(v_list) do
		if v_list[listname].Members.CustomWheels then
			local FrontWheel = v_list[listname].Members.CustomWheelModel
			local RearWheel = v_list[listname].Members.CustomWheelModel_R

			if FrontWheel then
				FrontWheel = string.lower(FrontWheel)
			end

			if RearWheel then
				RearWheel = string.lower(RearWheel)
			end

			if model == FrontWheel or model == RearWheel then
				return true
			end
		end
	end

	local list = list.Get("simfphys_Wheels")[model]

	if list then
		return true
	end

	return false
end

function simfphys.SetupSuspension(ent, susp)

	local carData = list.Get("simfphys_vehicles")[ent.VehicleName].Members
	susp[1] = math.Clamp(susp[1], -1, 1)
	susp[2] = math.Clamp(susp[2], carData.FrontConstant, carData.FrontConstant * 2)
	susp[3] = math.Clamp(susp[3], 0, carData.FrontDamping * 1.5)
	susp[4] = math.Clamp(susp[4], math.max(susp[1] - 1, -1), math.min(susp[1] + 1, 1))
	susp[5] = math.Clamp(susp[5], carData.RearConstant, carData.RearConstant * 2)
	susp[6] = math.Clamp(susp[6], 0, carData.RearDamping * 1.5)
	local data = {
		[1] = {susp[2], susp[3]},
		[2] = {susp[2], susp[3]},
		[3] = {susp[5], susp[6]},
		[4] = {susp[5], susp[6]},
		[5] = {susp[5], susp[6]},
		[6] = {susp[5], susp[6]}
	}

	local elastics = ent.Elastics
	if (elastics) then
		for i = 1, table.Count(elastics) do
			local elastic = elastics[i]
			if not elastic or not data[i] then continue end

			if (ent.StrengthenSuspension == true) then
				if (IsValid(elastic)) then
					elastic:Fire("SetSpringConstant", data[i][1] * 0.5, 0)
					elastic:Fire("SetSpringDamping", data[i][2] * 0.5, 0)
				end
				local elastic2 = elastics[i * 10]
				if (IsValid(elastic2)) then
					elastic2:Fire("SetSpringConstant", data[i][1] * 0.5, 0)
					elastic2:Fire("SetSpringDamping", data[i][2] * 0.5, 0)
				end
			else
				if (IsValid(elastic)) then
					elastic:Fire("SetSpringConstant", data[i][1], 0)
					elastic:Fire("SetSpringDamping", data[i][2], 0)
				end
			end

			ent.dampF = data[1][2]
			ent.consF = data[1][1]
			ent.dampR = data[4][2]
			ent.consR = data[4][1]
		end
	end

	ent:SetFrontSuspensionHeight(susp[1])
	ent:SetRearSuspensionHeight(susp[4])

end

function simfphys.CanPlayerTune(ply, ent)

	if not IsValid(ply) or not IsValid(ent) then return false, L.car_not_found end
	if ent:GetIsLocked() then return false, L.car_closed end

	local owner = ent:CPPIGetOwner()
	if not IsValid(owner) or ply ~= owner and not (owner.Buddies and owner.Buddies[ply] and table.HasValue(owner.Buddies[ply], true)) then return false, L.car_you_need_be_friend end

	return true

end

simfphys.postSpawn = simfphys.postSpawn or {}
function simfphys.AddPostSpawnAction(class, func)
	simfphys.postSpawn[class] = func
end

function simfphys.GetSeatProperty(seat, property)

	if not IsValid(seat) then return end
	local car = seat:GetParent()
	if not IsValid(car) or car:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' then return end
	if seat[property] ~= nil then return seat[property] end

	car.spawnlist = car.spawnlist or list.Get('simfphys_vehicles')[car:GetSpawn_List()]
	local lst = car.spawnlist.Members
	local lPos = car:WorldToLocal(seat:GetPos())
	for _,v in ipairs(lst.PassengerSeats) do
		if lPos:DistToSqr(v.pos) < 10 then
			if v[property] ~= nil then
				seat[property] = v[property]
			else
				seat[property] = false
			end
			break
		end
	end

	return seat[property]

end

simfphys.fuelPrices = {
	[FUELTYPE_DIESEL] = 80,
	[FUELTYPE_PETROL] = 120,
	[FUELTYPE_ELECTRIC] = 10,
}

util.AddNetworkString 'car.steer'
net.Receive('car.steer', function(len, ply)
	local seat = ply:GetVehicle()
	if not IsValid(seat) or not IsValid(seat.base) then return end

	local car = seat.base
	if car:GetDriverSeat() ~= seat then return end

	car.wantedSteer = net.ReadFloat()
end)

hook.Add('CanTool', 'octo-cars', function(ply, tr, tool)

	local ent = tr.Entity
	if tool ~= 'remover' and IsValid(ent) and ent:GetClass() == 'gmod_sent_vehicle_fphysics_base'
	and IsValid(ply) and not ply:query('DBG: Изменять автомобили') then
		return false
	end

end)
