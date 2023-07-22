local V = {
	Name = 'DF8-90',
	Model = 'models/octoteam/vehicles/df8.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1450,
		Trunk = { 25 },

		EnginePos = Vector(70,0,10),

		LightsTable = 'gta4_df8',

		OnSpawn = function(ent)
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

		CustomWheelModel = 'models/octoteam/vehicles/df8_wheel.mdl',

		CustomWheelPosFL = Vector(64,32,-9),
		CustomWheelPosFR = Vector(64,-32,-9),
		CustomWheelPosRL = Vector(-64,32,-9),
		CustomWheelPosRR = Vector(-64,-32,-9),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-8,-20,20),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(5,-20,-12),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-35,20,-12),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-35,-20,-12),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-104,20,-7),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-104,-20,-7),
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

		FuelFillPos = Vector(-80,-34,20),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 40,

		AirFriction = -60,
		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1.1,
		snd_idle = 'octoteam/vehicles/e109_idle.wav',

		snd_low = 'octoteam/vehicles/e109_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/e109_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/e109_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/e109_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/e109_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/banshee_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(22.264, 18.693, 15.785), ang = Angle(-0.0, -90.0, 84.5) },
		Radio = { pos = Vector(26.557, -1.965, 10.618), ang = Angle(-7.7, 159.6, 2.4) },
		Plates = {
			Front = { pos = Vector(104.050, -0.006, -5.885), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-107.377, -0.000, -2.960), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(8.188, -0.000, 28.153),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(27.104, 39.941, 20.285),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(27.357, -39.483, 20.157),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_df8', V )

local light_table = {
	L_HeadLampPos = Vector(90,27,5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(90,-27,5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-105,25,9),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-105,-25,9),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(90,27,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(90,-27,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(91,21,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(91,-21,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(26,27,16),
			material = 'gta4/dash_lowbeam',
			size = 1,
			color = Color(255,57,50,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(91,21,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(91,-21,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(90,27,5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(90,-27,5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(26,27,15),
			material = 'gta4/dash_highbeam',
			size = 1,
			color = Color(255,57,50,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(97,22,-7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(97,-22,-7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-105,25,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-105,-25,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-105,25,12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-105,-25,12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-105,13,7.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-105,-13,7.5),
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
				pos = Vector(91,32,6),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-101,32,9),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(26,21.25,16),
				material = 'gta4/dash_left',
				size = 1,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(91,-32,6),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-101,-32,9),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(26,16.13,16),
				material = 'gta4/dash_right',
				size = 1,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[8] = '',
				[9] = '',
				[13] = ''
			},
			Brake = {
				[8] = '',
				[9] = 'models/gta4/vehicles/df8/df8_90_lights_on',
				[13] = ''
			},
			Reverse = {
				[8] = '',
				[9] = '',
				[13] = 'models/gta4/vehicles/df8/df8_90_lights_on'
			},
			Brake_Reverse = {
				[8] = '',
				[9] = 'models/gta4/vehicles/df8/df8_90_lights_on',
				[13] = 'models/gta4/vehicles/df8/df8_90_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/df8/df8_90_lights_on',
				[9] = '',
				[13] = ''
			},
			Brake = {
				[8] = 'models/gta4/vehicles/df8/df8_90_lights_on',
				[9] = 'models/gta4/vehicles/df8/df8_90_lights_on',
				[13] = ''
			},
			Reverse = {
				[8] = 'models/gta4/vehicles/df8/df8_90_lights_on',
				[9] = '',
				[13] = 'models/gta4/vehicles/df8/df8_90_lights_on'
			},
			Brake_Reverse = {
				[8] = 'models/gta4/vehicles/df8/df8_90_lights_on',
				[9] = 'models/gta4/vehicles/df8/df8_90_lights_on',
				[13] = 'models/gta4/vehicles/df8/df8_90_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/df8/df8_90_lights_on',
				[9] = '',
				[13] = ''
			},
			Brake = {
				[8] = 'models/gta4/vehicles/df8/df8_90_lights_on',
				[9] = 'models/gta4/vehicles/df8/df8_90_lights_on',
				[13] = ''
			},
			Reverse = {
				[8] = 'models/gta4/vehicles/df8/df8_90_lights_on',
				[9] = '',
				[13] = 'models/gta4/vehicles/df8/df8_90_lights_on'
			},
			Brake_Reverse = {
				[8] = 'models/gta4/vehicles/df8/df8_90_lights_on',
				[9] = 'models/gta4/vehicles/df8/df8_90_lights_on',
				[13] = 'models/gta4/vehicles/df8/df8_90_lights_on'
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/df8/df8_90_lights_on'
			},
			right = {
				[7] = 'models/gta4/vehicles/df8/df8_90_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_df8', light_table)