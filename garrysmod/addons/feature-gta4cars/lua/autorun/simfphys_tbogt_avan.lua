local V = {
	Name = 'Brickade',
	Model = 'models/octoteam/vehicles/avan.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Индустриальные',
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Индустриальные',

	Members = {
		Mass = 6500.0,

		EnginePos = Vector(0,0,0),

		LightsTable = 'gta4_avan',

		OnSpawn = function(ent)
			REN.GTA4SimfphysInit(ent, 1, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 1, 0, 2) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		ModelInfo = {
			WheelColor = Color(10,10,10),
		},

		MaxHealth = 6000,
		IsArmored = true,

		CustomWheelModel = 'models/octoteam/vehicles/avan_wheel.mdl',

		CustomWheelPosFL = Vector(73,45,-20),
		CustomWheelPosFR = Vector(73,-45,-20),
		CustomWheelPosRL = Vector(-73,45,-20),
		CustomWheelPosRR = Vector(-73,-45,-20),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,35),

		CustomSteerAngle = 35,

		SeatOffset = Vector(81,-28,60),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(83,-28,28),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},

		StrengthenedSuspension = true,

		FrontHeight = 18,
		FrontConstant = 50000,
		FrontDamping = 5000,
		FrontRelativeDamping = 500,

		RearHeight = 18,
		RearConstant = 50000,
		RearDamping = 5000,
		RearRelativeDamping = 500,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 400,

		TurnSpeed = 3,

		MaxGrip = 160,
		Efficiency = 0.8,
		GripOffset = 0,
		BrakePower = 60,
		BulletProofTires = true,

		IdleRPM = 700,
		LimitRPM = 4000,
		PeakTorque = 100.0,
		PowerbandStart = 1600,
		PowerbandEnd = 3500,
		Turbocharged = false,
		Supercharged = true,
		DoNotStall = false,

		FuelFillPos = Vector(20,55,-10),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 200,

		PowerBias = 0,

		EngineSoundPreset = 0,

		Sound_Idle = 'octoteam/vehicles/avan_idle.wav',
		Sound_IdlePitch = 0.95,

		Sound_Mid = 'octoteam/vehicles/avan_low.wav',
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 40,
		Sound_MidFadeOutRate = 0.3,

		Sound_High = 'octoteam/vehicles/avan_high.wav',
		Sound_HighPitch = 1.2,
		Sound_HighVolume = 2,
		Sound_HighFadeInRPMpercent = 40,
		Sound_HighFadeInRate = 0.3,

		Sound_Throttle = 'octoteam/vehicles/avan_throttle.wav',
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 5,

		snd_horn = 'octoteam/vehicles/horns/buffalo_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/DUMP_VALVE.wav',

		DifferentialGear = 0.14,
		Gears = {-0.4,0,0.2,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tbogt_avan', V )

local light_table = {
	L_HeadLampPos = Vector(140,47,1),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(140,-47,1),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-130,42.5,64.5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-130,-42.5,64.5),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(140,47,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(140,-47,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(115,22.5,55.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(141,35,1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(141,-35,1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(115,21.5,55.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-130,42.5,64.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-130,-42.5,64.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-130,42.5,9.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-130,-42.5,9.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(-130,42.5,19.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(115,33.5,55.5),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(-130,-42.5,19.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(115,23.5,55.5),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[10] = '',
				[11] = '',
				[8] = '',
			},
			Brake = {
				[10] = '',
				[11] = '',
				[8] = 'models/gta4/vehicles/avan/detail2_on',
			},
		},
		on_lowbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/avan/detail2_on',
				[11] = '',
				[8] = '',
			},
			Brake = {
				[10] = 'models/gta4/vehicles/avan/detail2_on',
				[11] = '',
				[8] = 'models/gta4/vehicles/avan/detail2_on',
			},
		},
		on_highbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/avan/detail2_on',
				[11] = 'models/gta4/vehicles/avan/detail2_on',
				[8] = '',
			},
			Brake = {
				[10] = 'models/gta4/vehicles/avan/detail2_on',
				[11] = 'models/gta4/vehicles/avan/detail2_on',
				[8] = 'models/gta4/vehicles/avan/detail2_on',
			},
		},
		turnsignals = {
			left = {
				[9] = 'models/gta4/vehicles/avan/detail2_on'
			},
			right = {
				[7] = 'models/gta4/vehicles/avan/detail2_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_avan', light_table)