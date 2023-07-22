local function receiveppdata( length )
	local ent = net.ReadEntity()

	if IsValid( ent ) then
		ent.CustomWheels = net.ReadBool()

		if not ent.CustomWheels then
			local wheelFL = net.ReadEntity()
			local posFL = net.ReadFloat()
			local travelFL = net.ReadFloat()

			local wheelFR = net.ReadEntity()
			local posFR = net.ReadFloat()
			local travelFR = net.ReadFloat()

			local wheelRL = net.ReadEntity()
			local posRL = net.ReadFloat()
			local travelRL = net.ReadFloat()

			local wheelRR = net.ReadEntity()
			local posRR = net.ReadFloat()
			local travelRR = net.ReadFloat()

			if not IsValid( wheelFL ) or not IsValid( wheelFR ) or not IsValid( wheelRL ) or not IsValid( wheelRR ) then return end

			ent.pp_data = {
				[1] = {
					name = "vehicle_wheel_fl_height",
					entity = wheelFL,
					pos = posFL,
					travel = travelFL,
					dradius = (wheelFL:BoundingRadius() * 0.28),
				},
				[2] = {
					name = "vehicle_wheel_fr_height",
					entity = wheelFR,
					pos = posFR,
					travel = travelFR,
					dradius = (wheelFR:BoundingRadius() * 0.28),
				},
				[3] = {
					name = "vehicle_wheel_rl_height",
					entity = wheelRL,
					pos = posRL,
					travel = travelRL,
					dradius = (wheelRL:BoundingRadius() * 0.28),
				},
				[4] = {
					name = "vehicle_wheel_rr_height",
					entity = wheelRR,
					pos = posRR,
					travel = travelRR,
					dradius = (wheelRR:BoundingRadius() * 0.28),
				},
			}
		end
	end
end
net.Receive("simfphys_send_ppdata", receiveppdata)

simfphys.anims = {
	gear = function(ply, arg)
		octolib.manipulateBones(ply, {
			['ValveBiped.Bip01_R_Clavicle'] = Angle(-16.6, 1.8, -13.2),
			['ValveBiped.Bip01_R_Forearm'] = Angle(0.0, 0.0, -33.3),
		}, 0.3)
		timer.Simple(0.3, function()
			octolib.manipulateBones(ply, {
				['ValveBiped.Bip01_R_Clavicle'] = Angle(0,0,0),
				['ValveBiped.Bip01_R_Forearm'] = Angle(0,0,0),
			}, 0.3)
		end)
	end,
	brake = function(ply, arg)
		if arg then
			octolib.manipulateBones(ply, {
				['ValveBiped.Bip01_R_Clavicle'] = Angle(-20, 1.8, -17),
				['ValveBiped.Bip01_R_Forearm'] = Angle(0.0, 0.0, -10),
			}, 0.3)
		else
			octolib.manipulateBones(ply, {
				['ValveBiped.Bip01_R_Clavicle'] = Angle(0,0,0),
				['ValveBiped.Bip01_R_Forearm'] = Angle(0,0,0),
			}, 0.3)
		end
	end,
	engine = function(ply, arg)
		if arg then
			octolib.manipulateBones(ply, {
				['ValveBiped.Bip01_R_UpperArm'] = Angle(3.0, -3.4, 9.6),
				['ValveBiped.Bip01_R_Forearm'] = Angle(-2.3, 26.2, 7.4),
				['ValveBiped.Bip01_R_Hand'] = Angle(32.0, 1.4, -70.6),
			}, 0.3)
		else
			octolib.manipulateBones(ply, {
				['ValveBiped.Bip01_R_UpperArm'] = Angle(0,0,0),
				['ValveBiped.Bip01_R_Forearm'] = Angle(0,0,0),
				['ValveBiped.Bip01_R_Hand'] = Angle(0,0,0),
			}, 0.3)
		end
	end,
	rhandle = function(ply, arg)
		octolib.manipulateBones(ply, {
			['ValveBiped.Bip01_R_UpperArm'] = Angle(3.0, -3.0, 0.0),
			['ValveBiped.Bip01_R_Forearm'] = Angle(0.8, 9.5, 0.0),
			['ValveBiped.Bip01_R_Hand'] = Angle(0.0, -18.0, 17.8),
		}, 0.2)
		timer.Simple(0.2, function()
			octolib.manipulateBones(ply, {
				['ValveBiped.Bip01_R_UpperArm'] = Angle(0,0,0),
				['ValveBiped.Bip01_R_Forearm'] = Angle(0,0,0),
				['ValveBiped.Bip01_R_Hand'] = Angle(0,0,0),
			}, 0.2)
		end)
	end,
	lhandle = function(ply, arg)
		octolib.manipulateBones(ply, {
			['ValveBiped.Bip01_L_UpperArm'] = Angle(-3.0, -6.0, 0.0),
			['ValveBiped.Bip01_L_Forearm'] = Angle(0.8, 10.3, 0.0),
			['ValveBiped.Bip01_L_Hand'] = Angle(0.0, -18.0, -17.8),
		}, 0.2)
		timer.Simple(0.2, function()
			octolib.manipulateBones(ply, {
				['ValveBiped.Bip01_L_UpperArm'] = Angle(0,0,0),
				['ValveBiped.Bip01_L_Forearm'] = Angle(0,0,0),
				['ValveBiped.Bip01_L_Hand'] = Angle(0,0,0),
			}, 0.2)
		end)
	end,
	lfoot = function(ply, arg)
		if arg then
			octolib.manipulateBones(ply, {
				['ValveBiped.Bip01_L_Foot'] = Angle(0.0, 25.0, 0.0),
			}, 0.2)
		else
			octolib.manipulateBones(ply, {
				['ValveBiped.Bip01_L_Foot'] = Angle(0.0, 0.0, 0.0),
			}, 0.2)
		end
	end,
	rfoot = function(ply, arg)
		if arg < 0 then
			-- brake
			arg = -arg
			octolib.manipulateBones(ply, {
				['ValveBiped.Bip01_R_Thigh'] = Angle(-4.2, 0.0, 0.0) * arg,
				['ValveBiped.Bip01_R_Foot'] = Angle(-13.0, 15.0, 0.0) * arg,
			}, 0.2)
		else
			-- throttle
			octolib.manipulateBones(ply, {
				['ValveBiped.Bip01_R_Foot'] = Angle(0.0, 25.0, 0.0) * arg,
				['ValveBiped.Bip01_R_Thigh'] = Angle(0,0,0),
			}, 0.2)
		end
	end,
}

netstream.Hook('simfphys.anim', function(ply, id, arg)
	local anim = simfphys.anims[id]
	if anim and IsValid(ply) then anim(ply, arg) end
end)
