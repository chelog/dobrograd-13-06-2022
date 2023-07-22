local V = {
	Name = 'Buffalo',
	Model = 'models/octoteam/vehicles/buffalo.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1500,
		Trunk = { 30 },

		EnginePos = Vector(70,0,0),

		Backfire = true,

		LightsTable = 'gta4_buffalo',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,3)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,0,103)}
				-- CarCols[3] =  {REN.GTA4ColorTable(3,3,103)}
				-- CarCols[4] =  {REN.GTA4ColorTable(1,1,79)}
				-- CarCols[5] =  {REN.GTA4ColorTable(3,3,73)}
				-- CarCols[6] =  {REN.GTA4ColorTable(4,4,82)}
				-- CarCols[7] =  {REN.GTA4ColorTable(6,6,84)}
				-- CarCols[8] =  {REN.GTA4ColorTable(11,11,86)}
				-- CarCols[9] =  {REN.GTA4ColorTable(16,16,92)}
				-- CarCols[10] = {REN.GTA4ColorTable(23,23,25)}
				-- CarCols[11] = {REN.GTA4ColorTable(34,34,28)}
				-- CarCols[12] = {REN.GTA4ColorTable(36,36,27)}
				-- CarCols[13] = {REN.GTA4ColorTable(47,47,91)}
				-- CarCols[14] = {REN.GTA4ColorTable(52,52,53)}
				-- CarCols[15] = {REN.GTA4ColorTable(53,53,51)}
				-- CarCols[16] = {REN.GTA4ColorTable(64,64,65)}
				-- CarCols[17] = {REN.GTA4ColorTable(69,69,63)}
				-- CarCols[18] = {REN.GTA4ColorTable(70,70,64)}
				-- CarCols[19] = {REN.GTA4ColorTable(73,73,58)}
				-- CarCols[20] = {REN.GTA4ColorTable(76,76,58)}
				-- CarCols[21] = {REN.GTA4ColorTable(2,2,63)}
				-- CarCols[22] = {REN.GTA4ColorTable(21,21,72)}
				-- CarCols[23] = {REN.GTA4ColorTable(22,22,72)}
				-- CarCols[24] = {REN.GTA4ColorTable(13,11,91)}
				-- CarCols[25] = {REN.GTA4ColorTable(19,19,93)}
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

		CustomWheelModel = 'models/octoteam/vehicles/buffalo_wheel.mdl',

		ModelInfo = {
			WheelColor = Color(10,10,10),
		},

		CustomWheelPosFL = Vector(67,32,-12),
		CustomWheelPosFR = Vector(67,-32,-12),
		CustomWheelPosRL = Vector(-61,32,-12),
		CustomWheelPosRR = Vector(-61,-32,-12),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-5,-17,17),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(8,-17,-15),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-30,18,-15),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-30,-18,-15),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-102,22,-14),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-102,-22,-14),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 5.5,
		FrontConstant = 33000,
		FrontDamping = 1000,
		FrontRelativeDamping = 1000,

		RearHeight = 5.5,
		RearConstant = 33000,
		RearDamping = 1000,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 20,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 5.5,
		CounterSteeringMul = 0.85,

		MaxGrip = 62,
		Efficiency = 1.1,
		GripOffset = 0,
		BrakePower = 42,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6500,
		PeakTorque = 68,
		PowerbandStart = 1200,
		PowerbandEnd = 6200,
		Turbocharged = true,
		Supercharged = true,
		DoNotStall = false,
		PowerBoost = 1.3,

		FuelFillPos = Vector(-61,37,17),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/buffalo2_idle.wav',

		snd_low = 'octoteam/vehicles/buffalo2_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/buffalo2_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/buffalo2_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/buffalo2_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/buffalo2_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/sultanrs_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.45,
		Gears = {-0.12,0,0.12,0.18,0.24,0.32,0.42},

		Dash = { pos = Vector(22.469, 17.686, 13.903), ang = Angle(-0.0, -90.0, 77.0) },
		Radio = { pos = Vector(28.962, 0.010, 4.947), ang = Angle(-19.6, -180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(103.097, -0.016, -12.006), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-99.164, 0.008, 7.328), ang = Angle(-22.1, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(15.675, 0.030, 25.598),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(29.291, 36.604, 16.617),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(28.574, -37.075, 16.650),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tbogt_buffalo', V )

local light_table = {
	L_HeadLampPos = Vector(91,29,5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(91,-29,5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-94,35,9),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-94,-35,9),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(91,29,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(91,-29,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(26.5,17,11),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(91,29,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(91,-29,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(26.5,18,11),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(95,30,-10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(95,-30,-10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-94,35,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-94,-35,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-96,30,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-96,-30,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-97,30,6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-97,-30,6),
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
				pos = Vector(95,31,-5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-95,31,14),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(26.5,19,11),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(95,-31,-5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-95,-31,14),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(26.5,16,11),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[9] = '',
				[11] = '',
				[5] = ''
			},
			Brake = {
				[9] = '',
				[11] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[5] = ''
			},
			Reverse = {
				[9] = '',
				[11] = '',
				[5] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
			Brake_Reverse = {
				[9] = '',
				[11] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[5] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = '',
				[5] = ''
			},
			Brake = {
				[9] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[5] = ''
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = '',
				[5] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[5] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = '',
				[5] = ''
			},
			Brake = {
				[9] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[5] = ''
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = '',
				[5] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[5] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
			right = {
				[8] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_buffalo', light_table)