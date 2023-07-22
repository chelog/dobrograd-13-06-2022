local V = {
	Name = 'Enforcer',
	Model = 'models/octoteam/vehicles/nstockade.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Службы',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Службы',

	Members = {
		Mass = 5000,
		Trunk = { 100 },

		EnginePos = Vector(102,0,34),

		LightsTable = 'gta4_nstockade',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			REN.GTA4SimfphysInit(ent, 1, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 1, 0, 2) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
			REN.GTA4Bullhorn(ent)
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		MaxHealth = 5000,
		IsArmored = true,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		ModelInfo = {
			WheelColor = Color(10,10,10),
		},

		CustomWheelModel = 'models/octoteam/vehicles/nstockade_wheel.mdl',
		CustomWheelModel_R = 'models/octoteam/vehicles/nstockade_wheel_r.mdl',

		CustomWheelPosFL = Vector(93,44,-4),
		CustomWheelPosFR = Vector(93,-44,-4),
		CustomWheelPosRL = Vector(-93,44,-4),
		CustomWheelPosRR = Vector(-93,-44,-4),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,25),

		CustomSteerAngle = 35,

		SeatOffset = Vector(20,-30,70),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(30,-29,30),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-131,-40,30),
				ang = Angle(0,0,0),
				noMirrors = true,
			},
			{
				pos = Vector(-105,-40,30),
				ang = Angle(0,0,0),
				noMirrors = true,
			},
			{
				pos = Vector(-131,40,30),
				ang = Angle(0,180,0),
				noMirrors = true,
			},
			{
				pos = Vector(-105,40,30),
				ang = Angle(0,180,0),
				noMirrors = true,
			},
			{
				pos = Vector(-160,-20,-6),
				ang = Angle(0,90,0),
				noMirrors = true,
			},
			{
				pos = Vector(-160,20,-6),
				ang = Angle(0,90,0),
				noMirrors = true,
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-56.1,-46.4,-11.3),
				ang = Angle(-90,90,0),
			},
			{
				pos = Vector(-52.1,-46.4,-11.3),
				ang = Angle(-90,90,0),
			},
		},

		StrengthenSuspension = true,

		FrontHeight = 10,
		FrontConstant = 35000,
		FrontDamping = 4000,
		FrontRelativeDamping = 4000,

		RearHeight = 10,
		RearConstant = 35000,
		RearDamping = 4000,
		RearRelativeDamping = 4000,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 90,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = true,

		IdleRPM = 800,
		LimitRPM = 4500,
		PeakTorque = 75,
		PowerbandStart = 1700,
		PowerbandEnd = 4300,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 2,

		FuelFillPos = Vector(-10.1,50.6,6.7),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 100,

		PowerBias = 0,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/stockade_idle.wav',

		snd_low = 'octoteam/vehicles/stockade_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/stockade_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/stockade_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/stockade_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/stockade_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/stockade_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/DUMP_VALVE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.1,0,0.1,0.16,0.23,0.32,0.42},

		Dash = { pos = Vector(56.072, 29.429, 53.880), ang = Angle(0.0, -90.0, 71.9) },
		Radio = { pos = Vector(60.643, 3.031, 55.760), ang = Angle(-25.4, 156.2, 3.7) },
		Plates = {
			Front = { pos = Vector(140.167, 0.014, 4.973), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-146.770, 18.756, 7.788), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			left = {
				pos = Vector(53.704, 57.466, 67.447),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(53.932, -57.128, 69.094),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_nstockade', V )

local light_table = {
	L_HeadLampPos = Vector(128,41,19),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(128,-41,19),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-148.7,42.6,33.4),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-148.7,-42.6,33.4),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(128,41,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(128,-41,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(58,37,55),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(128,41,19),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(128,-41,19),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(58,38,55),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-148.7,42.6,33.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-148.7,-42.6,33.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-148.7,42.6,78.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-148.7,-42.6,78.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},

	ems_sounds = {'octoteam/vehicles/swat/siren1.wav','octoteam/vehicles/swat/siren2.wav'},
	ems_sprites = {
		{
			pos = Vector(70.7,36,92.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 80,
			Colors = {
						Color(255,0,0,150),
						Color(255,0,0,255),
						Color(255,0,0,150),
						--
						Color(255,0,0,100),
						Color(255,0,0,50),
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
						Color(255,0,0,50),
						Color(255,0,0,100),
					},
			Speed = 0.035
		},
		{
			pos = Vector(70.7,24,92.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			Colors = {
						Color(0,0,0,0),
						Color(0, 0, 255,50),
						Color(0, 0, 255,100),
						--
						Color(0, 0, 255,150),
						Color(0, 0, 255,255),
						Color(0, 0, 255,150),
						--
						Color(0, 0, 255,100),
						Color(0, 0, 255,50),
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
					},
			Speed = 0.035
		},
		{
			pos = Vector(70.7,12,92.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 80,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(255,0,0,50),
						Color(255,0,0,100),
						--
						Color(255,0,0,150),
						Color(255,0,0,255),
						Color(255,0,0,150),
						--
						Color(255,0,0,100),
						Color(255,0,0,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(70.7,0,92.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0, 0, 255,50),
						Color(0, 0, 255,100),
						--
						Color(0, 0, 255,150),
						Color(0, 0, 255,255),
						Color(0, 0, 255,150),
						--
						Color(0, 0, 255,100),
						Color(0, 0, 255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(70.7,-12,92.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 80,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(255,0,0,50),
						Color(255,0,0,100),
						--
						Color(255,0,0,150),
						Color(255,0,0,255),
						Color(255,0,0,150),
						--
						Color(255,0,0,100),
						Color(255,0,0,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(70.7,-24,92.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			Colors = {
						Color(0,0,0,0),
						Color(0, 0, 255,50),
						Color(0, 0, 255,100),
						--
						Color(0, 0, 255,150),
						Color(0, 0, 255,255),
						Color(0, 0, 255,150),
						--
						Color(0, 0, 255,100),
						Color(0, 0, 255,50),
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
					},
			Speed = 0.035
		},
		{
			pos = Vector(70.7,-36,92.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 80,
			Colors = {
						Color(255,0,0,150),
						Color(255,0,0,255),
						Color(255,0,0,150),
						--
						Color(255,0,0,100),
						Color(255,0,0,50),
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
						Color(255,0,0,50),
						Color(255,0,0,100),
					},
			Speed = 0.035
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(-148.7,42.6,23.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(60,35,57),
				material = 'gta4/dash_left',
				size = 1,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(-148.7,-42.6,23.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(60,22,57),
				material = 'gta4/dash_right',
				size = 1,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[2] = '',
				[3] = ''
			},
			Brake = {
				[2] = '',
				[3] = 'models/gta4/vehicles/stockade/detail2_on'
			},
		},
		on_lowbeam = {
			Base = {
				[2] = 'models/gta4/vehicles/stockade/detail2_on',
				[3] = ''
			},
			Brake = {
				[2] = 'models/gta4/vehicles/stockade/detail2_on',
				[3] = 'models/gta4/vehicles/stockade/detail2_on'
			},
		},
		on_highbeam = {
			Base = {
				[2] = 'models/gta4/vehicles/stockade/detail2_on',
				[3] = ''
			},
			Brake = {
				[2] = 'models/gta4/vehicles/stockade/detail2_on',
				[3] = 'models/gta4/vehicles/stockade/detail2_on'
			},
		},
		turnsignals = {
			left = {
				[11] = 'models/gta4/vehicles/stockade/detail2_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/stockade/detail2_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_nstockade', light_table)