netstream.Hook('followVehicles', function(vehs, dir)
	hook.Add('CalcView', 'followVehicles', function(ply, pos, ang, fov)

		local pos = Vector()
		for i = #vehs, 1, -1 do
			local veh = vehs[i]
			if IsValid(veh) then
				pos = pos + veh:GetPos()
			else
				table.remove(vehs, i)
			end
		end

		if #vehs <= 0 then return hook.Remove('CalcView', 'followVehicles') end

		pos = pos / #vehs - dir * 50 + Vector(0, 0, 400)

		local ang = dir:Angle()
		ang:RotateAroundAxis(ang:Right(), -80)

		return {
			origin = pos,
			angles = ang,
			fov = 110,
		}

	end)
end)
