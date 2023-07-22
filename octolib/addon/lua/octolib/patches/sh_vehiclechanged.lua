if CLIENT then
	local lastVehicle

	hook.Add('Think', 'octolib.vehicleChanged', function()
		local ply = LocalPlayer()
		local currentVehicle = ply:GetVehicle()

		if currentVehicle ~= lastVehicle then
			hook.Run('VehicleChanged', ply, currentVehicle, lastVehicle)
			lastVehicle = currentVehicle
		end
	end)

	netstream.Hook('vehicleChanged', function(ply, new, old)
		if ply == LocalPlayer() then return end -- detected by client in Think hook above
		hook.Run('VehicleChanged', ply, new, old)
	end)
end

if SERVER then
	hook.Add('PlayerEnteredVehicle', 'octolib.vehicleChanged', function(ply, veh, role)
		netstream.Start(nil, 'vehicleChanged', ply, veh, nil)
	end)

	hook.Add('PlayerLeaveVehicle', 'octolib.vehicleChanged', function(ply, veh)
		netstream.Start(nil, 'vehicleChanged', ply, nil, veh)
	end)
end
