local V = {
	Name = 'Vincent',
	Model = 'models/octoteam/vehicles/vincent.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1600,
		Trunk = { 30 },

		EnginePos = Vector(65,0,5),

		LightsTable = 'gta4_vincent',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(121,133,1)}
				-- CarCols[2] =  {REN.GTA4ColorTable(8,133,1)}
				-- CarCols[3] =  {REN.GTA4ColorTable(10,133,1)}
				-- CarCols[4] =  {REN.GTA4ColorTable(17,133,1)}
				-- CarCols[5] =  {REN.GTA4ColorTable(24,133,1)}
				-- CarCols[6] =  {REN.GTA4ColorTable(36,133,1)}
				-- CarCols[7] =  {REN.GTA4ColorTable(37,133,1)}
				-- CarCols[8] =  {REN.GTA4ColorTable(75,133,1)}
				-- CarCols[9] =  {REN.GTA4ColorTable(55,133,1)}
				-- CarCols[10] = {REN.GTA4ColorTable(75,133,1)}
				-- CarCols[11] = {REN.GTA4ColorTable(0,93,34)}
				-- CarCols[12] = {REN.GTA4ColorTable(0,1,1)}
				-- CarCols[13] = {REN.GTA4ColorTable(87,133,83)}
				-- CarCols[14] = {REN.GTA4ColorTable(52,133,83)}
				-- CarCols[15] = {REN.GTA4ColorTable(39,133,34)}
				-- CarCols[16] = {REN.GTA4ColorTable(1,133,1)}
				-- CarCols[17] = {REN.GTA4ColorTable(7,133,7)}
				-- CarCols[18] = {REN.GTA4ColorTable(31,93,29)}
				-- CarCols[19] = {REN.GTA4ColorTable(16,133,76)}
				-- CarCols[20] = {REN.GTA4ColorTable(9,1,91)}
				-- CarCols[21] = {REN.GTA4ColorTable(15,133,93)}
				-- CarCols[22] = {REN.GTA4ColorTable(19,1,93)}
				-- CarCols[23] = {REN.GTA4ColorTable(13,133,80)}
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

		CustomWheelModel = 'models/octoteam/vehicles/vincent_wheel.mdl',

		CustomWheelPosFL = Vector(55,29,-8),
		CustomWheelPosFR = Vector(55,-29,-8),
		CustomWheelPosRL = Vector(-55,29,-8),
		CustomWheelPosRR = Vector(-55,-29,-8),
		CustomWheelAngleOffset = Angle(0,-90,0),

		FrontWheelRadius = 13.4,

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-8,-14,18),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(5,-14,-13),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-27,14,-13),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-27,-14,-13),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-97,19.5,-8.3),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 7,
		FrontConstant = 32500,
		FrontDamping = 900,
		FrontRelativeDamping = 900,

		RearHeight = 7,
		RearConstant = 32500,
		RearDamping = 900,
		RearRelativeDamping = 900,

		FastSteeringAngle = 15,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 4,
		CounterSteeringMul = 0.7,

		MaxGrip = 56,
		Efficiency = 0.9,
		GripOffset = 0,
		BrakePower = 32,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6200,
		PeakTorque = 52,
		PowerbandStart = 1200,
		PowerbandEnd = 5800,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-76,-30,15),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 45,

		PowerBias = -0.25,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/feroci_idle.wav',

		snd_low = 'octoteam/vehicles/feroci_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/feroci_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/feroci_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/feroci_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/feroci_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/huntley_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.12,0.19,0.28,0.36,0.48},

		Dash = { pos = Vector(23.525, 14.011, 14.204), ang = Angle(-0.0, -90.0, 76.4) },
		Radio = { pos = Vector(27.050, -0.207, 8.469), ang = Angle(-17.2, 163.0, -1.3) },
		Plates = {
			Front = { pos = Vector(95.796, 0.022, -7.263), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-97.833, -0.004, 9.375), ang = Angle(-5.4, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(6.741, 0.007, 27.305),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(20.948, 32.583, 17.375),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(21.052, -33.590, 17.176),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_vincent', V )

local light_table = {
	L_HeadLampPos = Vector(83,24,2.4),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(83,-24,2.4),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-97,23.5,9.4),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-97,-23.5,9.4),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(83,24,2.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(83,-24,2.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(26,21,13.4),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(76,240,255,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(83,24,2.4),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(83,-24,2.4),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(25,21,12.4),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(76,240,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(90,20.5,-8.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(90,-20.5,-8.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-97,23.5,9.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-97,-23.5,9.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-97,23.5,9.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-97,-23.5,9.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-97,12.5,9.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-97,-12.5,9.4),
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
				pos = Vector(80,31,2.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-97,21.5,13),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(26,17,13.4),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(80,-31,2.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-97,-21.5,13),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(26,13,13.4),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[6] = '',
				[7] = '',
				[11] = '',
			},
			Brake = {
				[6] = '',
				[7] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[11] = '',
			},
			Reverse = {
				[6] = '',
				[7] = '',
				[11] = 'models/gta4/vehicles/vincent/vincent_lights_on',
			},
			Brake_Reverse = {
				[6] = '',
				[7] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[11] = 'models/gta4/vehicles/vincent/vincent_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[6] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[7] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[11] = '',
			},
			Brake = {
				[6] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[7] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[11] = '',
			},
			Reverse = {
				[6] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[7] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[11] = 'models/gta4/vehicles/vincent/vincent_lights_on',
			},
			Brake_Reverse = {
				[6] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[7] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[11] = 'models/gta4/vehicles/vincent/vincent_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[6] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[7] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[11] = '',
			},
			Brake = {
				[6] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[7] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[11] = '',
			},
			Reverse = {
				[6] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[7] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[11] = 'models/gta4/vehicles/vincent/vincent_lights_on',
			},
			Brake_Reverse = {
				[6] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[7] = 'models/gta4/vehicles/vincent/vincent_lights_on',
				[11] = 'models/gta4/vehicles/vincent/vincent_lights_on',
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/vincent/vincent_lights_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/vincent/vincent_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_vincent', light_table)