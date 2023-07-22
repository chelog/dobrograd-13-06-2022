local V = {
	Name = 'Dilettante',
	Model = 'models/octoteam/vehicles/dilettante.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1250,
		Trunk = { 40 },

		EnginePos = Vector(65,0,5),

		LightsTable = 'gta4_dilettante',

		OnSpawn = function(ent)
			REN.GTA4SimfphysInit(ent, 0, 0) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/dilettante_wheel.mdl',

		CustomWheelPosFL = Vector(57,30,-7),
		CustomWheelPosFR = Vector(57,-30,-7),
		CustomWheelPosRL = Vector(-56,30,-7),
		CustomWheelPosRR = Vector(-56,-30,-7),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-3,-18,22),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(10,-17,-10),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-34,15,-9),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-34,-15,-9),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-90,21,-7),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-90,-21,-7),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 9,
		FrontConstant = 24000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 9,
		RearConstant = 24000,
		RearDamping = 800,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3.5,

		MaxGrip = 35,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 25,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 31,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-67,32,16),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 45,

		AirFriction = -40,
		PowerBias = -1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/dilettante_idle.wav',
		BrakeSqueal = true,

		snd_low = 'octoteam/vehicles/dilettante_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/dilettante_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/dilettante_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/dilettante_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/dilettante_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/dilettante_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(29.153, 17.036, 18.406), ang = Angle(-0.0, -90.0, 71.9) },
		Radio = { pos = Vector(30.819, 0.014, 8.560), ang = Angle(-19.1, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(92.812, 0.011, -5.637), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-87.219, -0.010, 14.971), ang = Angle(-9.0, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(16.781, 0.002, 33.368),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(32.102, 36.223, 20.604),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(30.637, -36.015, 20.661),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_dilettante', V )

local light_table = {
	L_HeadLampPos = Vector(83,25,5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(83,-25,5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-86,20,18),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-86,-20,18),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(83,25,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(83,-25,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(29.1,24,18),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(84.4,18.8,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(84.4,-18.8,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(29.1,24,17),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-86,20,18),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-86,-20,18),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-87,13,18),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-87,-13,18),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-87,0,20),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,255,255,150),
		},
	},

	ems_sounds = {'octoteam/vehicles/police/siren1.wav','octoteam/vehicles/police/siren2.wav','octoteam/vehicles/police/siren3.wav'},
	ems_sprites = {
		{
			pos = Vector(32.1, 34.7, 18.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.03
		},
		{
			pos = Vector(32.1, -34.7, 18.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.025
		},
		{
			pos = Vector(-47.6, 22.2, 34.1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-47.6, -22.2, 34.1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.034
		},
		{
			pos = Vector(86.1, -7.8, 4.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(86.1, 7.8, 4.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.034
		},
		{
			pos = Vector(17.5, -21.2, 34.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(17.5, -17, 34.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.034
		},
		{
			pos = Vector(17.5, -13, 34.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.033
		},
		{
			pos = Vector(17.5, -9, 34.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.032
		},
		{
			pos = Vector(17.5, 21.2, 34.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(17.5, 17, 34.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.034
		},
		{
			pos = Vector(17.5, 13, 34.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.033
		},
		{
			pos = Vector(17.5, 9, 34.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.032
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(78,29.6,6.7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-85,28,18),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(29.5,20,20),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(78,-29.6,6.7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-85,-28,18),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(29.5,15,20),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[5] = '',
				[11] = '',
				[8] = '',
				[10] = ''
			},
			Brake = {
				[5] = '',
				[11] = '',
				[8] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[10] = ''
			},
			Reverse = {
				[5] = '',
				[11] = '',
				[8] = '',
				[10] = 'models/gta4/vehicles/dilettante/dilettante_lights_on'
			},
			Brake_Reverse = {
				[5] = '',
				[11] = '',
				[8] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[10] = 'models/gta4/vehicles/dilettante/dilettante_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[11] = '',
				[8] = '',
				[10] = ''
			},
			Brake = {
				[5] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[11] = '',
				[8] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[10] = ''
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[11] = '',
				[8] = '',
				[10] = 'models/gta4/vehicles/dilettante/dilettante_lights_on'
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[11] = '',
				[8] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[10] = 'models/gta4/vehicles/dilettante/dilettante_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[11] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[8] = '',
				[10] = ''
			},
			Brake = {
				[5] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[11] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[8] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[10] = ''
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[11] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[8] = '',
				[10] = 'models/gta4/vehicles/dilettante/dilettante_lights_on'
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[11] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[8] = 'models/gta4/vehicles/dilettante/dilettante_lights_on',
				[10] = 'models/gta4/vehicles/dilettante/dilettante_lights_on'
			},
		},
		turnsignals = {
			left = {
				[9] = 'models/gta4/vehicles/dilettante/dilettante_lights_on'
			},
			right = {
				[12] = 'models/gta4/vehicles/dilettante/dilettante_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_dilettante', light_table)