hook.Add('octolib.netVarUpdate', 'dbg-radio', function(idx, var, val)
	if not isnumber(idx) then return end
	local ent = Entity(idx)
	if not IsValid(ent) or ent:GetClass() ~= 'ent_dbg_radio' then return end

	if var == 'stream' then
		if val then
			ent:StartStream(val)
			if IsValid(ent:GetParent()) and ent:GetParent():GetClass() == 'gmod_sent_vehicle_fphysics_base' then
				local veh = LocalPlayer():GetVehicle()
				ent:Set2D(IsValid(veh) and veh.vehiclebase == ent:GetParent())
			end
		else ent:StopStream() end
		return
	end

	if not val then return end
	if var == 'volume' then ent:SetVolume(val)
	elseif var == 'dist' then ent:SetDistance(val) end

end)

hook.Add('NotifyShouldTransmit', 'dbg-radio', function(ent, should)
	if not should or ent:GetClass() ~= 'ent_dbg_radio' or not ent.GetStreamURL then return end
	local url = ent:GetStreamURL()
	if not url then return end
	if ent.stream.url ~= url then
		ent:StartStream(url)
	end
end)

hook.Add('VehicleChanged', 'dbg-radio', function(ply, new, old)

	if ply ~= LocalPlayer() then return end
	local seat = IsValid(new) and new or old
	if not IsValid(seat) or not IsValid(seat.vehiclebase) then return end
	if new.vehiclebase == old.vehiclebase then return end

	local car = seat.vehiclebase
	local radio
	for _,v in ipairs(car:GetChildren()) do
		if v:GetClass() == 'ent_dbg_radio' then
			radio = v
			break
		end
	end
	if radio then radio:Set2D(IsValid(new)) end

end)
