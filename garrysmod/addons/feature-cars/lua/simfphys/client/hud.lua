local screenw = ScrW()
local screenh = ScrH()
local Widescreen = (screenw / screenh) > (4 / 3)
local sizex = screenw * (Widescreen and 1 or 1.32)

local turnmenu = KEY_COMMA
local mirrorkey = KEY_M
local beltkey = KEY_B
local ms_key = MOUSE_MIDDLE

local ms_deadzone = 0.06
local ms_sensitivity = 1
local ms_return = 0

CreateClientConVar('dbg_cars_ms_sensitivity', ms_sensitivity, true)
CreateClientConVar('dbg_cars_ms_deadzone', ms_deadzone, true)
CreateClientConVar('dbg_cars_ms_return', ms_return, true)

cvars.AddChangeCallback('dbg_cars_ms_sensitivity', function(convar, oldValue, newValue)  ms_sensitivity = tonumber(newValue) end)
cvars.AddChangeCallback('dbg_cars_ms_return', function(convar, oldValue, newValue)  ms_return = tonumber(newValue) end)
cvars.AddChangeCallback('dbg_cars_ms_deadzone', function(convar, oldValue, newValue)  ms_deadzone = tonumber(newValue) end)

cvars.AddChangeCallback('cl_simfphys_key_turnmenu', function(convar, oldValue, newValue) turnmenu = tonumber(newValue) end)
cvars.AddChangeCallback('cl_simfphys_key_mirror', function(convar, oldValue, newValue) mirrorkey = tonumber(newValue) end)
cvars.AddChangeCallback('cl_simfphys_key_belt', function(convar, oldValue, newValue) beltkey = tonumber(newValue) end)

hook.Add('PlayerFinishedLoading', 'dbg-cars.hud', function()
	turnmenu = GetConVar('cl_simfphys_key_turnmenu'):GetInt()
	mirrorkey = GetConVar('cl_simfphys_key_mirror'):GetInt()
	beltkey = GetConVar('cl_simfphys_key_belt'):GetInt()
	ms_key = GetConVar('cl_simfphys_keymousesteer'):GetInt()
end)

ms_sensitivity = GetConVar('dbg_cars_ms_sensitivity'):GetFloat()
ms_deadzone = GetConVar('dbg_cars_ms_deadzone'):GetFloat()
ms_return = GetConVar('dbg_cars_ms_return'):GetFloat()

local function getMyCar()
	local mySeat = LocalPlayer():GetVehicle()
	if not IsValid(mySeat) or not IsValid(mySeat.vehiclebase) then return end

	return mySeat.vehiclebase, mySeat
end

local wantedSteer, inputSteer = 0, 0
local function sendWantedSteer()
	net.Start('car.steer', true)
		net.WriteFloat(wantedSteer)
	net.SendToServer()
end

local mouseSteerEnabled
hook.Add('PlayerButtonDown', 'dbg-cars.steer', function(ply, key)
	if key == ms_key and IsFirstTimePredicted() then
		local veh, seat = getMyCar()
		if veh and veh:GetDriverSeat() ~= seat then return end
		mouseSteerEnabled = not mouseSteerEnabled
	end
end)

hook.Add('InputMouseApply', 'dbg-cars.steer', function(cmd, x, y, ang)
	if not getMyCar() then
		mouseSteerEnabled = nil
		return
	end

	if not mouseSteerEnabled then
		if inputSteer ~= 0 then
			inputSteer = 0
			wantedSteer = 0
			sendWantedSteer()
		end
		return
	end

	inputSteer = math.Clamp(inputSteer + x * 0.0012 * ms_sensitivity, -1, 1)

	local absInput = math.abs(inputSteer)
	local steer = absInput > ms_deadzone and ((absInput - math.abs(ms_deadzone)) * octolib.math.sign(inputSteer) / (1 - ms_deadzone)) or 0
	if steer ~= wantedSteer then
		wantedSteer = steer
		sendWantedSteer()
	end

	cmd:SetMouseX(0)
	cmd:SetMouseY(0)
	return true
end)

hook.Add('Think', 'dbg-cars.steer', function()
	if ms_return > 0 then
		inputSteer = math.Approach(inputSteer, 0, ms_return * FrameTime())
	end
end)

local steerPanelRadius = 300
hook.Add('HUDPaint', 'dbg-cars.hud', function()
	if mouseSteerEnabled then
		local car = getMyCar()
		if not car then return end

		local cx = ScrW() / 2
		local y = ScrH() - 50
		draw.RoundedBox(4, cx - steerPanelRadius, y, steerPanelRadius * 2 + 1, 8, Color(0,0,0, 255))
		draw.RoundedBox(4, cx - steerPanelRadius * ms_deadzone, y, steerPanelRadius * ms_deadzone * 2, 8, Color(255,255,255, 5))
		draw.RoundedBox(8, cx + steerPanelRadius * car.sm_vSteer - 8, y - 4, 16, 16, Color(120,120,120))
		draw.RoundedBox(8, cx + steerPanelRadius * inputSteer - 8, y - 4, 16, 16, Color(255,255,255, 255))
	end
end)

surface.CreateFont('dbg-cars.hud.large', {
	font = 'Calibri',
	extended = true,
	size = 60,
	weight = 350,
	shadow = true,
})

surface.CreateFont('dbg-cars.hud.normal', {
	font = 'Calibri',
	extended = true,
	size = 32,
	weight = 350,
	shadow = true,
})

local cols = {
	bg = Color(0,0,0),
	back = Color(60,60,60),
	active = Color(255,255,255),
	inactive = Color(60,60,60),
	rpm = Color(38,166,154),
	orange = Color(240,202,77),
	danger = Color(223,55,33),
	lightFar = Color(65,132,209),
}

local icons = {
	brake = Material('octoteam/icons-car/brake.png'),
	lock = Material('octoteam/icons-car/lock.png'),
	lightClose = Material('octoteam/icons-car/light_close.png'),
	lightFar = Material('octoteam/icons-car/light_far.png'),
	tire = Material('octoteam/icons-car/tire_flat.png'),
	alarm = Material('octoteam/icons-car/alarm.png'),
	belt = Material('octoteam/icons-car/belt.png'),
	fuel = Material('octoteam/icons-car/fuel.png'),
	left = Material('octoteam/icons-car/left_1.png'),
	right = Material('octoteam/icons-car/right_1.png'),
}

local function flash(freq)
	return math.sin(CurTime() * freq) / 2 + 0.5
end

local dashChecks = {
	function(car) return icons.left, (car.flashnum or 0) > 0.75 and car.signal_left and cols.orange or cols.bg end,
	function(car)
		local lights, lamps = car:GetLightsEnabled(), car:GetLampsEnabled()
		local col = lamps and cols.lightFar
			or lights and cols.active
			or cols.inactive
		if not car:GetEngineActive() and lights then col = col:Lerp(flash(3), cols.danger) end
		return lamps and icons.lightFar or icons.lightClose, col
	end,
	function(car) return icons.lock, car:GetIsLocked() end,
	function(car)
		local belt = LocalPlayer():GetNetVar('belted')
		local col = belt and cols.active or cols.inactive
		if (car.speed or 0) > 1 and not belt then col = col:Lerp(flash(3), cols.danger) end
		return icons.belt, col
	end,
	function(car)
		local brake = car:GetHandBrakeEnabled()
		local col = brake and cols.active or cols.inactive
		if not car:GetEngineActive() and not brake then col = col:Lerp(flash(3), cols.danger) end
		return icons.brake, col
	end,
	function(car) return car:GetEMSEnabled() and icons.alarm, cols.bg:Lerp(flash(4), cols.active) end,
	function(car) return (car:GetFuel() / car:GetMaxFuel()) < 0.2 and icons.fuel, cols.inactive:Lerp(flash(3), cols.danger) end,
	function(car) return icons.right, (car.flashnum or 0) > 0.75 and car.signal_right and cols.orange or cols.bg end,
}

local function niceGear(gear)
	return gear == 1 and 'R' or gear == 2 and 'N' or (gear - 2)
end

local lastRPM, lastFuelUse = 0, 0
local function drawDash(car)
	draw.RoundedBox(8, -120, -40, 240, 80, cols.bg)

	draw.Text {
		text = niceGear(car:GetGear()),
		font = 'dbg-cars.hud.large',
		pos = {0, -14},
		color = cols.back,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}

	lastRPM = math.Approach(lastRPM, car:GetRPM() / car:GetLimitRPM(), FrameTime())
	local colRPM = lastRPM < 0.7 and cols.rpm or cols.rpm:Lerp((lastRPM - 0.7) / 0.3, cols.danger)

	local bottom = 3
	draw.NoTexture()
	for i = 1, 10 do
		local height = i * 2 + 2
		surface.SetDrawColor((i / 10 < lastRPM + 0.09) and colRPM or cols.back)
		surface.DrawRect(-75 + (i-1) * 6, bottom - height, 4, height)
	end

	local fuel = car:GetFuel() / car:GetMaxFuel()
	local colFuel = fuel > 0.7 and cols.orange or cols.orange:Lerp(1 - fuel / 0.7, cols.danger)
	draw.NoTexture()
	for i = 1, 10 do
		local height = i * 2 + 2
		surface.SetDrawColor((i / 10 < fuel + 0.05) and colFuel or cols.back)
		surface.DrawRect(71 - (i-1) * 6, bottom - height, 4, height)
	end

	car.speed = math.Round(car:GetVelocity():Length() * 0.0568182, 0)
	draw.Text {
		text = car.speed,
		font = 'dbg-cars.hud.normal',
		pos = {0, -10},
		color = cols.active,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}

	local icons = {}
	for _, func in ipairs(dashChecks) do
		local icon, col = func(car)
		if icon then
			icons[#icons + 1] = { icon, col }
		end
	end

	local xStart = -(#icons * 28) / 2
	for i, icon in ipairs(icons) do
		local x, y = xStart + (i-1) * 28, 6
		if istable(icon[2]) then
			surface.SetDrawColor(icon[2])
		elseif icon[2] then
			surface.SetDrawColor(cols.active)
		else
			surface.SetDrawColor(cols.inactive)
		end
		surface.SetMaterial(icon[1])
		surface.DrawTexturedRect(x, y, 24, 24)
	end

	-- local x, y = 192 - 40 * (#icons + 1) - 36, -16

	-- surface.SetDrawColor(cols.inactive)
	-- surface.SetMaterial(icons.fuel)
	-- surface.DrawTexturedRect(x, y, 32, 32)

	-- lastFuelUse = octolib.math.lerp(lastFuelUse, car:GetFuelUse() * 10, FrameTime(), 0.003)
	-- draw.Text {
	-- 	text = ('%0.1f'):format(lastFuelUse),
	-- 	font = 'dbg-cars.hud.normal',
	-- 	pos = {-7, 0},
	-- 	color = cols.active,
	-- 	xalign = TEXT_ALIGN_LEFT,
	-- 	yalign = TEXT_ALIGN_CENTER,
	-- }

	-- local gb = 255
	-- if fuel < 0.5 then gb = fuel / 0.5 * 255 end

	-- surface.SetDrawColor(255,gb,gb, 255)
	-- surface.SetMaterial(icons.fuel)
	-- surface.DrawTexturedRectUV(x, y + 32 * (1 - fuel), 32, 32 * fuel, 0, 1 - fuel, 1, 1)

	-- if (car.flashnum or 0) > 0.75 then
	-- 	if car.signal_left then
	-- 		surface.SetDrawColor(255,150,0, 255)
	-- 		surface.SetMaterial(icons.turnLeft)
	-- 		surface.DrawTexturedRect(-237, -16, 32, 32)
	-- 	end

	-- 	if car.signal_right then
	-- 		surface.SetDrawColor(255,180,0, 255)
	-- 		surface.SetMaterial(icons.turnRight)
	-- 		surface.DrawTexturedRect(205, -16, 32, 32)
	-- 	end
	-- end
end

local fallback = {
	pos = Vector(0, 38, 30),
	ang = Angle(0, 0, 65),
}

hook.Add('PostDrawTranslucentRenderables', 'dbg-cars.hud', function()

	local car = getMyCar()
	if not IsValid(car) then return end

	car.spawnlist = car.spawnlist or list.Get('simfphys_vehicles')[car:GetSpawn_List()]

	local dashData = car.spawnlist.Members.Dash
	local posOff = dashData and dashData.pos or fallback.pos
	local angOff = dashData and dashData.ang or fallback.ang
	local pos, ang = LocalToWorld(posOff, angOff, car:GetPos(), car:GetAngles())
	cam.Start3D2D(pos, ang, 0.05)
		drawDash(car)
	cam.End3D2D()

end)


local turnmode = 0
local turnmenu_wasopen = false

local function drawTurnMenu(vehicle)

	if octolib.flyEditor.active then return end

	if input.IsKeyDown(GetConVar('cl_simfphys_keyforward'):GetInt()) then
		turnmode = 0
	end

	if input.IsKeyDown(GetConVar('cl_simfphys_keyleft'):GetInt()) then
		turnmode = 2
	end

	if input.IsKeyDown(GetConVar('cl_simfphys_keyright'):GetInt()) then
		turnmode = 3
	end

	if input.IsKeyDown(GetConVar('cl_simfphys_keyreverse'):GetInt()) then
		turnmode = 1
	end

	local cX = ScrW() / 2
	local cY = ScrH() / 2

	local sx = sizex * 0.065
	local sy = sizex * 0.065

	local selectorX = (turnmode == 2 and (-sx - 1) or 0) + (turnmode == 3 and (sx + 1) or 0)
	local selectorY = (turnmode == 0 and (-sy - 1) or 0)

	draw.RoundedBox(8, cX - sx * 0.5 - 1 + selectorX, cY - sy * 0.5 - 1 + selectorY, sx + 2, sy + 2, Color(240, 200, 0, 255))
	draw.RoundedBox(8, cX - sx * 0.5 + selectorX, cY - sy * 0.5 + selectorY, sx, sy, Color(50, 50, 50, 255))

	draw.RoundedBox(8, cX - sx * 0.5, cY - sy * 0.5, sx, sy, Color(0, 0, 0, 100))
	draw.RoundedBox(8, cX - sx * 0.5, cY - sy * 1.5 - 1, sx, sy, Color(0, 0, 0, 100))
	draw.RoundedBox(8, cX - sx * 1.5 - 1, cY - sy * 0.5, sx, sy, Color(0, 0, 0, 100))
	draw.RoundedBox(8, cX + sx * 0.5 + 1, cY - sy * 0.5, sx, sy, Color(0, 0, 0, 100))

	surface.SetDrawColor(240, 200, 0, 100)
	--X
	if turnmode == 0 then
		surface.SetDrawColor(240, 200, 0, 255)
	end
	surface.DrawLine(cX - sx * 0.3, cY - sy - sy * 0.3, cX + sx * 0.3, cY - sy + sy * 0.3)
	surface.DrawLine(cX + sx * 0.3, cY - sy - sy * 0.3, cX - sx * 0.3, cY - sy + sy * 0.3)
	surface.SetDrawColor(240, 200, 0, 100)

	-- <=
	if turnmode == 2 then
		surface.SetDrawColor(240, 200, 0, 255)
	end
	surface.DrawLine(cX - sx + sx * 0.3, cY - sy * 0.15, cX - sx + sx * 0.3, cY + sy * 0.15)
	surface.DrawLine(cX - sx + sx * 0.3, cY + sy * 0.15, cX - sx, cY + sy * 0.15)
	surface.DrawLine(cX - sx + sx * 0.3, cY - sy * 0.15, cX - sx, cY - sy * 0.15)
	surface.DrawLine(cX - sx, cY - sy * 0.3, cX - sx, cY - sy * 0.15)
	surface.DrawLine(cX - sx, cY + sy * 0.3, cX - sx, cY + sy * 0.15)
	surface.DrawLine(cX - sx, cY + sy * 0.3, cX - sx - sx * 0.3, cY)
	surface.DrawLine(cX - sx, cY - sy * 0.3, cX - sx - sx * 0.3, cY)
	surface.SetDrawColor(240, 200, 0, 100)

	-- =>
	if turnmode == 3 then
		surface.SetDrawColor(240, 200, 0, 255)
	end
	surface.DrawLine(cX + sx - sx * 0.3, cY - sy * 0.15, cX + sx - sx * 0.3, cY + sy * 0.15)
	surface.DrawLine(cX + sx - sx * 0.3, cY + sy * 0.15, cX + sx, cY + sy * 0.15)
	surface.DrawLine(cX + sx - sx * 0.3, cY - sy * 0.15, cX + sx, cY - sy * 0.15)
	surface.DrawLine(cX + sx, cY - sy * 0.3, cX + sx, cY - sy * 0.15)
	surface.DrawLine(cX + sx, cY + sy * 0.3, cX + sx, cY + sy * 0.15)
	surface.DrawLine(cX + sx, cY + sy * 0.3, cX + sx + sx * 0.3, cY)
	surface.DrawLine(cX + sx, cY - sy * 0.3, cX + sx + sx * 0.3, cY)
	surface.SetDrawColor(240, 200, 0, 100)

	-- ^
	if turnmode == 1 then
		surface.SetDrawColor(240, 200, 0, 255)
	end
	surface.DrawLine(cX, cY - sy * 0.4, cX + sx * 0.4, cY + sy * 0.3)
	surface.DrawLine(cX, cY - sy * 0.4, cX - sx * 0.4, cY + sy * 0.3)
	surface.DrawLine(cX + sx * 0.4, cY + sy * 0.3, cX - sx * 0.4, cY + sy * 0.3)
	surface.DrawLine(cX, cY - sy * 0.26, cX + sx * 0.3, cY + sy * 0.24)
	surface.DrawLine(cX, cY - sy * 0.26, cX - sx * 0.3, cY + sy * 0.24)
	surface.DrawLine(cX + sx * 0.3, cY + sy * 0.24, cX - sx * 0.3, cY + sy * 0.24)

	surface.SetDrawColor(255, 255, 255, 255)
end

local function simfphysHUD()
	local ply = LocalPlayer()
	local turnmenu_isopen = false

	if not IsValid(ply) or not ply:Alive() then turnmenu_wasopen = false return end

	local vehiclebase, vehicle = getMyCar()
	if not vehiclebase then
		turnmenu_wasopen = false
		return
	end

	local IsDriverSeat = vehicle == vehiclebase:GetDriverSeat()
	if not IsDriverSeat then turnmenu_wasopen = false return end

	if vehiclebase.HasTurnSignals and input.IsKeyDown(turnmenu) then
		turnmenu_isopen = true
		drawTurnMenu(vehiclebase)
	end

	if turnmenu_isopen ~= turnmenu_wasopen then
		turnmenu_wasopen = turnmenu_isopen

		if turnmenu_isopen then
			turnmode = 0
		else
			net.Start('simfphys_turnsignal')
				net.WriteEntity(vehiclebase)
				net.WriteInt(turnmode, 32)
			net.SendToServer()

			if turnmode == 1 or turnmode == 2 or turnmode == 3 then
				vehiclebase:EmitSound('simulated_vehicles/sfx/turnsignal_start.ogg')
			else
				vehiclebase:EmitSound('simulated_vehicles/sfx/turnsignal_end.ogg')
			end
		end
	end
end
hook.Add('HUDPaint', 'simfphys_HUD', simfphysHUD)

-- draw.arc function by bobbleheadbob
-- https://dl.dropboxusercontent.com/u/104427432/Scripts/drawarc.lua
-- https://facepunch.com/showthread.php?t=1438016&p=46536353&viewfull=1#post46536353

function surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness,bClockwise)
	local triarc = {}
	local deg2rad = math.pi / 180

	-- Correct start/end ang
	local startang,endang = startang or 0, endang or 0
	if bClockwise and (startang < endang) then
		local temp = startang
		startang = endang
		endang = temp
		temp = nil
	elseif (startang > endang) then
		local temp = startang
		startang = endang
		endang = temp
		temp = nil
	end


	-- Define step
	local roughness = math.max(roughness or 1, 1)
	local step = roughness
	if bClockwise then
		step = math.abs(roughness) * -1
	end


	-- Create the inner circle's points.
	local inner = {}
	local r = radius - thickness
	for deg=startang, endang, step do
		local rad = deg2rad * deg
		table.insert(inner, {
			x=cx+(math.cos(rad)*r),
			y=cy+(math.sin(rad)*r)
		})
	end


	-- Create the outer circle's points.
	local outer = {}
	for deg=startang, endang, step do
		local rad = deg2rad * deg
		table.insert(outer, {
			x=cx+(math.cos(rad)*radius),
			y=cy+(math.sin(rad)*radius)
		})
	end


	-- Triangulize the points.
	for tri=1,#inner*2 do -- twice as many triangles as there are degrees.
		local p1,p2,p3
		p1 = outer[math.floor(tri/2)+1]
		p3 = inner[math.floor((tri+1)/2)+1]
		if tri%2 == 0 then --if the number is even use outer.
			p2 = outer[math.floor((tri+1)/2)]
		else
			p2 = inner[math.floor((tri+1)/2)]
		end

		table.insert(triarc, {p1,p2,p3})
	end

	-- Return a table of triangles to draw.
	return triarc

end

function surface.DrawArc(arc)
	for k,v in ipairs(arc) do
		surface.DrawPoly(v)
	end
end

function draw.Arc(cx,cy,radius,thickness,startang,endang,roughness,color,bClockwise)
	surface.SetDrawColor(color)
	surface.DrawArc(surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness,bClockwise))
end

local showMirror = false
hook.Add('PlayerButtonDown', 'dbg-cars.mirror', function(ply, key)

	if IsFirstTimePredicted() then
		if key == mirrorkey then
			showMirror = not showMirror
		end

		if key == beltkey then
			netstream.Start('dbg-cars.belt')
		end
	end

end)

local rts = {}
local mirrorMat = CreateMaterial('dbg-cars-mirrorMat', 'UnlitGeneric', {})

local cmod = Material('pp/colour')
local colFrame = Color(50,50,50)
local function updateMirror(pos, angOff, veh, w, h)

	local ply = LocalPlayer()

	local ang = veh:LocalToWorldAngles(Angle(angOff.p, angOff.y + 180, angOff.r))

	local key = w .. '-' .. h
	rts[key] = rts[key] or GetRenderTarget('dbg-cars-mirrorRT' .. key, w, h)

	local oldHideHead = dbgView.headHidden
	dbgView.hideHead(false)
	ply:SetMaskVisible(true)
	local oldRT = cmod:GetTexture('$fbtexture')
	cmod:SetTexture('$fbtexture', rts[key])
	render.PushRenderTarget(rts[key])
	render.RenderView({
		origin = pos,
		angles = ang,
		w = w, h = h,
		aspectratio = w / h,
		x = 0, y = 0,
		fov = 90,
	})
	render.PopRenderTarget()
	if not oldRT then return rts[key] end
	cmod:SetTexture('$fbtexture', oldRT)
	dbgView.hideHead(oldHideHead)
	ply:SetMaskVisible()
	return rts[key]

end


local function checkLook(ply, pos)
	return (ply.viewAngs or ply:EyeAngles()):Forward():Dot((pos - ply:EyePos()):GetNormalized()) >= 0.95
end

local function drawMirror(pos, angOff, veh, x, y, w, h, noFlip)
	local rt = updateMirror(pos, angOff, veh, w, h)
	draw.RoundedBox(4, x - 4, y - 4, w + 8, h + 8, colFrame)
	mirrorMat:SetTexture('$basetexture', rt)
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(mirrorMat)
	if noFlip then
		surface.DrawTexturedRect(x, y, w, h)
	else
		surface.DrawTexturedRectUV(x, y, w, h, 1, 0, 0, 1)
	end
end

local function getSize(data)
	local w, h
	if data.w then
		w = ScrW() * data.w
		h = w / data.ratio
	else
		h = ScrH() * data.h
		w = h * data.ratio
	end
	return w, h
end

hook.Add('HUDPaint', 'dbg-cars.mirror', function()

	if not showMirror then return end

	local ply = LocalPlayer()
	if not ply:InVehicle() or ply:GetNetVar('blind') then return end

	local veh = ply:GetVehicle()
	local car = veh:GetParent()
	if not IsValid(car) or car:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' then return end
	if simfphys.GetSeatProperty(veh, 'noMirrors') then return end
	car.spawnlist = car.spawnlist or list.Get('simfphys_vehicles')[car:GetSpawn_List()]
	local mirrors = car.spawnlist.Members.Mirrors
	if not mirrors then return end

	local w, h = ScrW(), ScrH()

	local pos = mirrors.left and car:LocalToWorld(mirrors.left.pos)
	if mirrors.left and checkLook(ply, pos) then
		w, h = getSize(mirrors.left)
		drawMirror(pos, mirrors.left.ang or Angle(), car, 15, (ScrH() - h) / 2, w, h, mirrors.left.noFlip)
		return
	end

	pos = mirrors.top and car:LocalToWorld(mirrors.top.pos)
	if mirrors.top and checkLook(ply, pos) then
		w, h = getSize(mirrors.top)
		drawMirror(pos, mirrors.top.ang or Angle(), car, (ScrW() - w) / 2, 15, w, h, mirrors.top.noFlip)
		return
	end

	pos = mirrors.right and car:LocalToWorld(mirrors.right.pos)
	if mirrors.right and checkLook(ply, pos) then
		w, h = getSize(mirrors.right)
		drawMirror(pos, mirrors.right.ang or Angle(), car, ScrW() - (w + 15), (ScrH() - h) / 2, w, h, mirrors.right.noFlip)
		return
	end

end)
