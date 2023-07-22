local V = {
	Name = 'Esperanto',
	Model = 'models/octoteam/vehicles/esperanto.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1500.0,
		Trunk = { 30 },

		EnginePos = Vector(70,0,5),

		LightsTable = 'gta4_esperanto',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(20,20,18)}
				-- CarCols[2] =  {REN.GTA4ColorTable(16,16,15)}
				-- CarCols[3] =  {REN.GTA4ColorTable(7,7,15)}
				-- CarCols[9] =  {REN.GTA4ColorTable(1,1,8)}
				-- CarCols[7] =  {REN.GTA4ColorTable(26,26,8)}
				-- CarCols[6] =  {REN.GTA4ColorTable(34,34,33)}
				-- CarCols[7] =  {REN.GTA4ColorTable(40,40,39)}
				-- CarCols[8] =  {REN.GTA4ColorTable(50,50,51)}
				-- CarCols[9] =  {REN.GTA4ColorTable(52,52,51)}
				-- CarCols[10] = {REN.GTA4ColorTable(57,57,57)}
				-- CarCols[11] = {REN.GTA4ColorTable(65,65,68)}
				-- CarCols[12] = {REN.GTA4ColorTable(82,82,80)}
				-- CarCols[13] = {REN.GTA4ColorTable(97,97,97)}
				-- CarCols[14] = {REN.GTA4ColorTable(111,111,110)}
				-- CarCols[15] = {REN.GTA4ColorTable(2,2,63)}
				-- CarCols[16] = {REN.GTA4ColorTable(21,21,72)}
				-- CarCols[17] = {REN.GTA4ColorTable(22,22,72)}
				-- CarCols[18] = {REN.GTA4ColorTable(13,11,91)}
				-- CarCols[19] = {REN.GTA4ColorTable(19,19,93)}
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

		CustomWheelModel = 'models/octoteam/vehicles/esperanto_wheel.mdl',

		CustomWheelPosFL = Vector(60,33,-10),
		CustomWheelPosFR = Vector(60,-33,-10),
		CustomWheelPosRL = Vector(-60,33,-10),
		CustomWheelPosRR = Vector(-60,-33,-10),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-8,-18,20),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(4,-18,-12),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-36,18,-12),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-36,-18,-12),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-100,28.5,-11.7),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-100,-28.5,-11.7),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 8,
		FrontConstant = 28000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 8,
		RearConstant = 28000,
		RearDamping = 800,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3.5,

		MaxGrip = 45,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 25,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 39,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-80,36,10),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 40,

		AirFriction = -45,
		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/esperanto_idle.wav',
		BrakeSqueal = true,

		snd_low = 'octoteam/vehicles/esperanto_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/esperanto_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/esperanto_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/esperanto_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/esperanto_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/esperanto_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(23, 17.759, 13.138), ang = Angle(0.0, -90.0, 90.0) },
		Radio = { pos = Vector(28.770, -0.514, 7.001), ang = Angle(0.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(100.938, 0.003, -7.359), ang = Angle(-0.8, 0.0, 0.0) },
			Back = { pos = Vector(-99.935, -0.021, 3.340), ang = Angle(-20.5, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(7.453, 0.014, 29.380),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(24.050, 38.076, 16.854),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(23.120, -37.956, 16.929),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_esperanto', V )

local light_table = {
	L_HeadLampPos = Vector(93,26,5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(93,-26,5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-101,33,4),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-101,-33,4),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(93,26,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(93,-26,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(94,18,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(94,-18,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(23,18,15),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(94,18,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(94,-18,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(93,26,5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(93,-26,5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(23,18,14.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-101,33,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-101,-33,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-101,13,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-101,-13,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(94,18,0),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,19,15),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeLeft = {
			{
				pos = Vector(-101,21,4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
		Right = {
			{
				pos = Vector(94,-18,0),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,17,15),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeRight = {
			{
				pos = Vector(-101,-21,4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[9] = '',
				[7] = '',
				[10] = ''
			},
			Brake = {
				[9] = '',
				[7] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[10] = ''
			},
			Reverse = {
				[9] = '',
				[7] = '',
				[10] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
			Brake_Reverse = {
				[9] = '',
				[7] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[10] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = '',
				[10] = ''
			},
			Brake = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[10] = ''
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = '',
				[10] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[10] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = '',
				[10] = ''
			},
			Brake = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[10] = ''
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = '',
				[10] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[10] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
		},
		turnsignals = {
			left = {
				[11] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
			right = {
				[12] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_esperanto', light_table)