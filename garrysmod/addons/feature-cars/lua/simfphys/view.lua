local LockedPitch = 5
if CLIENT then
	cvars.AddChangeCallback( "cl_simfphys_ms_lockedpitch", function( convar, oldValue, newValue ) LockedPitch = tonumber( newValue ) end)
	LockedPitch = GetConVar( "cl_simfphys_ms_lockedpitch" ):GetFloat()
end


local function simfphyslerpView( ply, view )

	ply.simfphys_smooth_in = ply.simfphys_smooth_in or 1
	ply.simfphys_smooth_out = ply.simfphys_smooth_out or 1

	if ply:InVehicle() then
		if ply.simfphys_smooth_in < 0.999 then
			ply.simfphys_smooth_in = ply.simfphys_smooth_in + (1 - ply.simfphys_smooth_in) * FrameTime() * 5

			view.origin = LerpVector(ply.simfphys_smooth_in, ply.simfphys_eyepos_in, view.origin )
			view.angles = LerpAngle(ply.simfphys_smooth_in, ply.simfphys_eyeang_in, view.angles )
		end

		local vehicle = ply:GetVehicle()
		if IsValid(vehicle) then
			ply.simfphys_eyeang_out = view.angles
			ply.simfphys_eyepos_out = view.origin
		end
	else
		if ply.simfphys_smooth_out < 0.999 then
			ply.simfphys_smooth_out = ply.simfphys_smooth_out + (1 - ply.simfphys_smooth_out) * FrameTime() * 5

			view.origin = LerpVector(ply.simfphys_smooth_out, ply.simfphys_eyepos_out, ply:GetShootPos() )
			view.angles = LerpAngle(ply.simfphys_smooth_out, ply.simfphys_eyeang_out, ply:EyeAngles() )
		end

		ply.simfphys_eyeang_in = view.angles
		ply.simfphys_eyepos_in = view.origin
	end

	return view
end

hook.Add( "CalcView", "simfphys_camtransitionshit", function( ply, pos, angles, fov )
	if not ply:InVehicle() then
		ply.simfphys_smooth_in = 0
		ply.simfphys_smooth_out = ply.simfphys_smooth_out or 1

		if ply.simfphys_smooth_out < 0.999 then

			local view = {}
			view.origin = Vector(0,0,0)
			view.angles = angles
			view.fov = fov
			view.drawviewer = false

			return simfphyslerpView( ply, view )
		else
			ply.simfphys_eyeang_in = angles
			ply.simfphys_eyepos_in = pos
		end
	end
end)

local function GetViewOverride( vehicle )
	if not IsValid( vehicle ) then return Vector(0,0,0) end

	if not vehicle.customview then
		local car = vehicle.vehiclebase
		car.spawnlist = car.spawnlist or list.Get( "simfphys_vehicles" )[ car:GetSpawn_List() ]
		local vehiclelist = car.spawnlist

		if vehiclelist then
			vehicle.customview = vehiclelist.Members.FirstPersonViewPos or Vector(0,-9,5)
		else
			vehicle.customview = Vector(0,-9,5)
		end
	end

	return vehicle.customview
end

hook.Add("CalcVehicleView", "simfphysViewOverride", function(Vehicle, ply, view)

	local vehiclebase = Vehicle.vehiclebase

	if not IsValid(vehiclebase) then return end

	local IsDriverSeat = Vehicle == vehiclebase:GetDriverSeat()

	if Vehicle.GetThirdPersonMode == nil or ply:GetViewEntity() ~= ply  then
		return
	end

	ply.simfphys_smooth_out = 0

	if not Vehicle:GetThirdPersonMode() then
		local viewoverride = GetViewOverride( Vehicle )

		local X = viewoverride.X
		local Y = viewoverride.Y
		local Z = viewoverride.Z

		view.origin = IsDriverSeat and view.origin + Vehicle:GetForward() * X + Vehicle:GetRight() * Y + Vehicle:GetUp() * Z or view.origin + Vehicle:GetUp() * 5

		return simfphyslerpView( ply, view )
	end

	local mn, mx = vehiclebase:GetRenderBounds()
	local radius = ( mn - mx ):Length()
	local radius = radius + radius * Vehicle:GetCameraDistance()

	local TargetOrigin = view.origin + ( view.angles:Forward() * -radius )
	local WallOffset = 4

	local tr = util.TraceHull( {
		start = view.origin,
		endpos = TargetOrigin,
		filter = function( e )
			local c = e:GetClass()
			local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" )
			return collide
		end,
		mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
		maxs = Vector( WallOffset, WallOffset, WallOffset ),
	} )

	view.origin = tr.HitPos
	view.drawviewer = true

	if tr.Hit and not tr.StartSolid then
		view.origin = view.origin + tr.HitNormal * WallOffset
	end

	return simfphyslerpView( ply, view )
end)

-- hook.Add("StartCommand", "simfphys_lockview", function(ply, ucmd)
-- 	local vehicle = ply:GetVehicle()
-- 	if not IsValid(vehicle) then return end

-- 	local vehiclebase = vehicle.vehiclebase

-- 	if not IsValid(vehiclebase) then return end

-- 	local IsDriverSeat = vehicle == vehiclebase:GetDriverSeat()

-- 	if not IsDriverSeat then return end
-- 	if not (ply:GetInfoNum( "cl_simfphys_mousesteer", 0 ) == 1) then return end

-- 	local ang = ucmd:GetViewAngles()

-- 	if ply.Freelook then
-- 		vehicle.lockedpitch = ang.p
-- 		vehicle.lockedyaw = ang.y
-- 		return
-- 	end

-- 	vehicle.lockedpitch = vehicle.lockedpitch or 0
-- 	vehicle.lockedyaw = vehicle.lockedyaw or 90

-- 	local dir = 0
-- 	if vehicle.lockedyaw < 90 and vehicle.lockedyaw > -90 then
-- 		dir = math.abs(vehicle.lockedyaw - 90)
-- 	end
-- 	if vehicle.lockedyaw >= 90 then
-- 		dir = -math.abs(vehicle.lockedyaw - 90)
-- 	end
-- 	if vehicle.lockedyaw < -90 and vehicle.lockedyaw >= -270 then
-- 		dir = -math.abs(vehicle.lockedyaw + 270)
-- 	end

-- 	vehicle.lockedyaw = vehicle.lockedyaw + dir * 0.05
-- 	vehicle.lockedpitch = vehicle.lockedpitch + (LockedPitch - vehicle.lockedpitch) * 0.05

-- 	if ply:GetInfoNum( "cl_simfphys_ms_lockpitch", 0 ) == 1 then
-- 		ang.p = vehicle.lockedpitch
-- 	end

-- 	ang.y = vehicle.lockedyaw

-- 	ucmd:SetViewAngles( ang )
-- end)
