local V = {
	Name = 'Dukes',
	Model = 'models/octoteam/vehicles/dukes.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Маслкары',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Маслкары',

	Members = {
		Mass = 1700.0,

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_dukes',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,2)..math.random(0,1)..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,133,32)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,133,62)}
				-- CarCols[3] =  {REN.GTA4ColorTable(0,0,0)}
				-- CarCols[4] =  {REN.GTA4ColorTable(1,133,1)}
				-- CarCols[5] =  {REN.GTA4ColorTable(5,133,8)}
				-- CarCols[6] =  {REN.GTA4ColorTable(11,133,8)}
				-- CarCols[7] =  {REN.GTA4ColorTable(31,133,30)}
				-- CarCols[8] =  {REN.GTA4ColorTable(36,133,27)}
				-- CarCols[9] =  {REN.GTA4ColorTable(52,133,50)}
				-- CarCols[10] = {REN.GTA4ColorTable(62,133,53)}
				-- CarCols[11] = {REN.GTA4ColorTable(82,133,63)}
				-- CarCols[12] = {REN.GTA4ColorTable(80,133,65)}
				-- CarCols[13] = {REN.GTA4ColorTable(65,133,65)}
				-- CarCols[14] = {REN.GTA4ColorTable(61,133,61)}
				-- CarCols[15] = {REN.GTA4ColorTable(93,133,93)}
				-- CarCols[16] = {REN.GTA4ColorTable(104,133,103)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/dukes_wheel.mdl',

		CustomWheelPosFL = Vector(62,33,-12),
		CustomWheelPosFR = Vector(62,-33,-12),
		CustomWheelPosRL = Vector(-63,32,-12),
		CustomWheelPosRR = Vector(-63,-32,-12),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-15,-17,17),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(0,-17,-15),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-34,39,-12.7),
				ang = Angle(-90,-55,0),
			},
			{
				pos = Vector(-41,36,-12.7),
				ang = Angle(-90,-55,0),
			},
			{
				pos = Vector(-34,-39,-12.7),
				ang = Angle(-90,55,0),
			},
			{
				pos = Vector(-41,-36,-12.7),
				ang = Angle(-90,55,0),
			},
		},

		FrontHeight = 13,
		FrontConstant = 18000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 13,
		RearConstant = 18000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 73,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 15,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6500,
		PeakTorque = 135.0,
		PowerbandStart = 1500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = true,
		DoNotStall = false,

		FuelFillPos = Vector(-90,40,14),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 80,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/dukes_idle.wav',

		snd_low = 'octoteam/vehicles/vigero_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/vigero_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/vigero_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/vigero_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/vigero_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/dukes_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.21,
		Gears = {-0.3,0,0.15,0.35,0.5,0.75}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_dukes', V )

local V2 = {}
V2.Name = 'Highway Reaper Dukes'
V2.Model = 'models/octoteam/vehicles/dukes.mdl'
V2.Class = 'gmod_sent_vehicle_fphysics_base'
V2.Category = 'Доброград - Особые'
V2.SpawnOffset = Vector(0,0,20)
V2.SpawnAngleOffset = 90
V2.NAKGame = 'Доброград'
V2.NAKType = 'Маслкары'

local V2Members = {}
for k,v in pairs(V.Members) do
	V2Members[k] = v
end
V2.Members = V2Members
V2.Members.OnSpawn = function(ent)
	-- ent:SetSkin(math.random(0,2))
	ent:SetBodyGroups('0311'	 )

	if (ProxyColor ) then
		-- local CarCols = {}
		-- CarCols[1] =  {REN.GTA4ColorTable(132,0,131)}
		-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
	end

	REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
end,
list.Set('simfphys_vehicles', 'sim_fphys_gta4_dukes2', V2 )

local light_table = {
	L_HeadLampPos = Vector(98,27.4,-1),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(98,-27.4,-1),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-118.2,25,4.7),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-118.2,-25,4.7),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(98,27.4,-1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(98,-27.4,-1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(98,21.1,-1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(98,-21.1,-1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
	},

	Headlamp_sprites = {
		{pos = Vector(98,27.4,-1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(98,-27.4,-1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(98,21.1,-1),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(98,-21.1,-1),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
	},

	Rearlight_sprites = {
		{
			pos = Vector(-118.2,25,4.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-118.2,-25,4.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-118.2,19,4.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-118.2,-19,4.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		TurnBrakeLeft = {
			{
				pos = Vector(-118.2,13,4.7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 60,
				color = Color(255,0,0,150),
			},
		},
		TurnBrakeRight = {
			{
				pos = Vector(-118.2,-13,4.7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 60,
				color = Color(255,0,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[5] = '',
				[6] = '',
				[9] = ''
			},
			Brake = {
				[5] = '',
				[6] = 'models/gta4/vehicles/dukes/dukes_lights_on',
				[9] = ''
			},
			Reverse = {
				[5] = '',
				[6] = '',
				[9] = 'models/gta4/vehicles/dukes/dukes_lights_on'
			},
			Brake_Reverse = {
				[5] = '',
				[6] = 'models/gta4/vehicles/dukes/dukes_lights_on',
				[9] = 'models/gta4/vehicles/dukes/dukes_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/dukes/dukes_lights_on',
				[6] = '',
				[9] = ''
			},
			Brake = {
				[5] = 'models/gta4/vehicles/dukes/dukes_lights_on',
				[6] = 'models/gta4/vehicles/dukes/dukes_lights_on',
				[9] = ''
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/dukes/dukes_lights_on',
				[6] = '',
				[9] = 'models/gta4/vehicles/dukes/dukes_lights_on'
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/dukes/dukes_lights_on',
				[6] = 'models/gta4/vehicles/dukes/dukes_lights_on',
				[9] = 'models/gta4/vehicles/dukes/dukes_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/dukes/dukes_lights_on',
				[6] = '',
				[9] = ''
			},
			Brake = {
				[5] = 'models/gta4/vehicles/dukes/dukes_lights_on',
				[6] = 'models/gta4/vehicles/dukes/dukes_lights_on',
				[9] = ''
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/dukes/dukes_lights_on',
				[6] = '',
				[9] = 'models/gta4/vehicles/dukes/dukes_lights_on'
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/dukes/dukes_lights_on',
				[6] = 'models/gta4/vehicles/dukes/dukes_lights_on',
				[9] = 'models/gta4/vehicles/dukes/dukes_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_dukes', light_table)