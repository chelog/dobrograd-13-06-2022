local V = {
	Name = 'Fortune',
	Model = 'models/octoteam/vehicles/fortune.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Хетчбеки',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Хетчбеки',

	Members = {
		Mass = 1400,
		Trunk = { 30 },

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_fortune',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,1)}
				-- CarCols[2] =  {REN.GTA4ColorTable(3,3,3)}
				-- CarCols[3] =  {REN.GTA4ColorTable(4,4,4)}
				-- CarCols[4] =  {REN.GTA4ColorTable(10,10,10)}
				-- CarCols[5] =  {REN.GTA4ColorTable(16,16,76)}
				-- CarCols[6] =  {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[7] =  {REN.GTA4ColorTable(15,15,93)}
				-- CarCols[8] =  {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[9] =  {REN.GTA4ColorTable(13,13,80)}
				-- CarCols[10] = {REN.GTA4ColorTable(16,16,16)}
				-- CarCols[11] = {REN.GTA4ColorTable(31,31,31)}
				-- CarCols[12] = {REN.GTA4ColorTable(31,31,33)}
				-- CarCols[13] = {REN.GTA4ColorTable(34,34,34)}
				-- CarCols[14] = {REN.GTA4ColorTable(36,36,33)}
				-- CarCols[15] = {REN.GTA4ColorTable(49,49,75)}
				-- CarCols[16] = {REN.GTA4ColorTable(52,52,52)}
				-- CarCols[17] = {REN.GTA4ColorTable(56,56,57)}
				-- CarCols[18] = {REN.GTA4ColorTable(55,55,55)}
				-- CarCols[19] = {REN.GTA4ColorTable(62,62,1)}
				-- CarCols[20] = {REN.GTA4ColorTable(64,64,1)}
				-- CarCols[21] = {REN.GTA4ColorTable(68,68,72)}
				-- CarCols[22] = {REN.GTA4ColorTable(72,72,2)}
				-- CarCols[23] = {REN.GTA4ColorTable(77,77,74)}
				-- CarCols[24] = {REN.GTA4ColorTable(80,80,50)}
				-- CarCols[25] = {REN.GTA4ColorTable(87,87,74)}
				-- CarCols[26] = {REN.GTA4ColorTable(95,95,95)}
				-- CarCols[27] = {REN.GTA4ColorTable(103,103,1)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 1) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/fortune_wheel.mdl',

		CustomWheelPosFL = Vector(67,30,-14),
		CustomWheelPosFR = Vector(67,-30,-14),
		CustomWheelPosRL = Vector(-60,30,-14),
		CustomWheelPosRR = Vector(-60,-30,-14),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0.02,-2.4),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-13,-17,16),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-1,-17,-18),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-97,-17,-15.5),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 7,
		FrontConstant = 27000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 7,
		RearConstant = 27000,
		RearDamping = 800,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3.5,

		MaxGrip = 46,
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

		FuelFillPos = Vector(-76,-34,8),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 35,

		AirFriction = -50,
		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1.1,
		snd_idle = 'octoteam/vehicles/lokus_idle.wav',

		snd_low = 'octoteam/vehicles/lokus_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/lokus_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/lokus_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/lokus_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/lokus_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/fortune_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(24.611, 16.938, 11.693), ang = Angle(-0.0, -90.0, 61.4) },
		Radio = { pos = Vector(27.494, 0.003, 5.008), ang = Angle(0.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(105.732, -0.011, -10.466), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-102.308, -0.007, -10.224), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(10.416, -0.016, 24.228),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(33.774, 37.675, 10.917),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(32.980, -37.800, 11.236),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_fortune', V )

local light_table = {
	L_HeadLampPos = Vector(99,25,1),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(99,-25,1),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-99,27,3),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-99,-27,3),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(99,25,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(99,-25,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(24,17,10),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(99,25,1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(99,-25,1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(24,15,10),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-99,27,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-99,-27,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-99,12,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-99,-12,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 90,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-99,26,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-99,-26,1),
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
				pos = Vector(96,31,1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-97,31,2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(26,19,13),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(96,-31,1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-97,-31,2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(26,13.5,13),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[4] = '',
				[8] = '',
				[11] = '',
			},
			Brake = {
				[4] = '',
				[8] = 'models/gta4/vehicles/fortune/fortune_lights_on',
				[11] = '',
			},
			Reverse = {
				[4] = '',
				[8] = '',
				[11] = 'models/gta4/vehicles/fortune/fortune_lights_on',
			},
			Brake_Reverse = {
				[4] = '',
				[8] = 'models/gta4/vehicles/fortune/fortune_lights_on',
				[11] = 'models/gta4/vehicles/fortune/fortune_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/fortune/fortune_lights_on',
				[8] = '',
				[11] = '',
			},
			Brake = {
				[4] = 'models/gta4/vehicles/fortune/fortune_lights_on',
				[8] = 'models/gta4/vehicles/fortune/fortune_lights_on',
				[11] = '',
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/fortune/fortune_lights_on',
				[8] = '',
				[11] = 'models/gta4/vehicles/fortune/fortune_lights_on',
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/fortune/fortune_lights_on',
				[8] = 'models/gta4/vehicles/fortune/fortune_lights_on',
				[11] = 'models/gta4/vehicles/fortune/fortune_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/fortune/fortune_lights_on',
				[8] = '',
				[11] = '',
			},
			Brake = {
				[4] = 'models/gta4/vehicles/fortune/fortune_lights_on',
				[8] = 'models/gta4/vehicles/fortune/fortune_lights_on',
				[11] = '',
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/fortune/fortune_lights_on',
				[8] = '',
				[11] = 'models/gta4/vehicles/fortune/fortune_lights_on',
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/fortune/fortune_lights_on',
				[8] = 'models/gta4/vehicles/fortune/fortune_lights_on',
				[11] = 'models/gta4/vehicles/fortune/fortune_lights_on',
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/fortune/fortune_lights_on'
			},
			right = {
				[3] = 'models/gta4/vehicles/fortune/fortune_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_fortune', light_table)