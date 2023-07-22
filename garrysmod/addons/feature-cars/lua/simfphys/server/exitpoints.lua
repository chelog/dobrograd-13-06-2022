local function getExitPoint(seat, car)

	local seatPos = seat:GetPos() + seat:OBBCenter()
	local right = car.Right
	local dir = right * octolib.math.sign((seatPos - car:GetPos()):Dot(right))

	local outerTrace = util.TraceHull({
		start = seatPos + dir * 150,
		endpos = seatPos,
		mins = Vector(-16,-16,0),
		maxs = Vector(16,16,40),
		filter = function(ent) return ent == car end,
		ignoreworld = true,
	})
	if not outerTrace.Hit then return seatPos end

	local pos = outerTrace.HitPos + outerTrace.HitNormal
	local downTrace = util.TraceHull({
		start = pos + Vector(0, 0, 20),
		endpos = pos - Vector(0, 0, 50),
		mins = Vector(-16,-16,0),
		maxs = Vector(16,16,0),
	})
	if downTrace.Hit then
		pos.z = downTrace.HitPos.z
		pos:Add(downTrace.HitNormal)
	end

	local playerTrace = util.TraceHull({
		start = pos,
		endpos = pos,
		mins = Vector(-15,-15,0),
		maxs = Vector(15,15,40),
		filter = function(ent) return not (ent.IsGhost and ent:IsGhost()) end,
	})
	if playerTrace.Hit then return end

	return pos

end

hook.Add('PlayerLeaveVehicle', 'simfphysVehicleExit', function(ply, seat)

	if ply.exitPoint then
		ply:SetPos(ply.exitPoint)
		ply.exitPoint = nil
	end

	local vel = seat:GetVelocity():Length()
	if vel > 350 then
		ply:TakeDamage((vel - 200) / 5, Entity(0), nil)
	end

end)

hook.Add('PlayerEnteredVehicle', 'simfphys.seats', function(ply)
	ply.exitPoint = nil
end)

hook.Add('CanExitVehicle', 'octo-cars', function(seat, ply)

	local car = seat.base
	if not seat.fphysSeat or not IsValid(car) then return end

	if not ply.handledVehicleExit then return false end

	local drSeat = car.DriverSeat
	local driver = IsValid(drSeat) and drSeat:GetDriver()
	if car:GetIsLocked() and IsValid(driver) and not car.lockpicked then
		return false
	end

	local pos = getExitPoint(seat, car)
	if not pos then
		ply:Notify('warning', 'Что-то мешает выйти из автомобиля')
		return false
	end

	ply.exitPoint = pos

end)
