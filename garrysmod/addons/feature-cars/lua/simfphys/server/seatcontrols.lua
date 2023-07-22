util.AddNetworkString 'simfphys_request_seatswitch'
util.AddNetworkString 'simfphys_blockcontrols'

netstream.Listen('dbg-cars.seatStatus', function(done, ply)
	local ct = CurTime()
	if ply.lastSeatStatus and ply.lastSeatStatus.til >= ct then
		return done(ply.lastSeatStatus.data)
	end

	local veh = ply:GetVehicle()
	if not IsValid(veh) then return end
	local car = veh:GetParent()
	if not (IsValid(car) and car:GetClass() == 'gmod_sent_vehicle_fphysics_base') then return end

	local response = {}

	if IsValid(car:GetDriverSeat()) and car:CanDrive(ply) then
		local seat = car:GetDriverSeat()
		response[#response + 1] = {
			id = 0,
			name = 'Водительское сидение',
			check = veh == seat or nil,
			icon = veh ~= seat and IsValid(seat:GetDriver()) and 'delete' or nil,
		}
	end

	for i, seat in ipairs(car.pSeat or {}) do
		response[#response + 1] = {
			id = i,
			name = 'Пассажирское сидение ' .. i,
			check = veh == seat or nil,
			icon = veh ~= seat and IsValid(seat:GetDriver()) and 'delete' or nil,
		}
	end

	ply.lastSeatStatus = {
		til = ct + 1,
		data = response,
	}

	done(response)
end)

net.Receive('simfphys_blockcontrols', function(len, ply)
	if not IsValid(ply) then return end
	ply.blockcontrols = net.ReadBool()
end)

net.Receive('simfphys_request_seatswitch', function(len, ply)
	local vehicle = ply:GetVehicle() and ply:GetVehicle().vehiclebase
	local req_seat = net.ReadInt(32)

	if not IsValid(vehicle) then return end
	if not IsValid(ply) then return end

	if vehicle:GetVelocity():LengthSqr() > 100 then
		ply:Notify('warning', L.no_change_seat)
		return
	end

	if ply:IsHandcuffed() or ply:GetNetVar('belted') or ply.belting then
		return
	end

	ply.NextSeatSwitch = ply.NextSeatSwitch or 0

	if ply.NextSeatSwitch < CurTime() then
		ply.NextSeatSwitch = CurTime() + 0.5

		if req_seat == 0 then
			if not IsValid(vehicle:GetDriver()) and vehicle:CanDrive(ply) then
				ply:ExitVehicle()

				if IsValid(vehicle.DriverSeat) then
					ply:SelectWeapon('dbg_hands')
					timer.Simple(0.05, function()
						if not IsValid(vehicle) then return end
						if not IsValid(ply) then return end
						if IsValid(vehicle:GetDriver()) then return end

						ply:EnterVehicle(vehicle.DriverSeat)
						vehicle:EnteringSequence(ply)
						ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)

						ply:SetAllowWeaponsInVehicle(false)
						local angles = Angle(0,90,0)
						ply:SetEyeAngles(angles)
					end)
				end
			end
		else
			if not vehicle.pSeat then return end

			local seat = vehicle.pSeat[req_seat]

			if IsValid(seat) and not IsValid(seat:GetDriver()) then
				ply:ExitVehicle()

				timer.Simple(0.05, function()
					if not IsValid(vehicle) then return end
					if not IsValid(ply) then return end
					if IsValid(seat:GetDriver()) then return end

					ply:EnterVehicle(seat)
					ply:SetAllowWeaponsInVehicle(true)
					ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)
					local angles = Angle(0,90,0)
					ply:SetEyeAngles(angles)
				end)
			end
		end
	end
end)

hook.Add('PlayerEnteredVehicle', 'simfphys.seats', function(ply, seat)
	local car = seat:GetParent()
	if not simfphys.IsCar(car) then return end

	local carInv = car:GetInventory()
	if carInv and carInv.conts.glove then
		ply:CloseInventory(carInv, {'trunk'})
		if seat == car:GetDriverSeat() then ply:OpenInventory(carInv, {'glove'}) end
	end

	if IsValid(seat.MassEnt) then
		local mass = 100
		local inv = ply:GetInventory()
		if inv then mass = mass + inv:GetMass() * 2 end

		local ph = seat.MassEnt:GetPhysicsObject()
		ph:SetMass(mass)
		ph:Wake()
	end
end)

hook.Add('PlayerLeaveVehicle', 'simfphys.seats', function(ply, seat)
	local car = seat:GetParent()
	if not simfphys.IsCar(car) then return end

	octolib.stopAnimations(ply)

	local carInv = car:GetInventory()
	if carInv and carInv.conts.glove then
		ply:CloseInventory(carInv, {'glove'})
	end

	if IsValid(seat.MassEnt) then
		local ph = seat.MassEnt:GetPhysicsObject()
		ph:SetMass(1)
		ph:Wake()
	end
end)
