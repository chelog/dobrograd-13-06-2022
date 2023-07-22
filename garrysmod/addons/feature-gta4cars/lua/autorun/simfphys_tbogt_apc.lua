local V = {
	Name = 'APC',
	Model = 'models/octoteam/vehicles/apc.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Службы',
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Службы',

	Members = {
		Mass = 6500.0,

		EnginePos = Vector(-80,0,40),

		LightsTable = 'gta4_apc',

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

		MaxHealth = 5000,
		IsArmored = true,

		CustomWheelModel = 'models/octoteam/vehicles/apc_wheel.mdl',

		CustomWheelPosFL = Vector(64,45,-5),
		CustomWheelPosFR = Vector(64,-45,-5),
		CustomWheelPosRL = Vector(-64,45,-5),
		CustomWheelPosRR = Vector(-64,-45,-5),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,35),

		CustomSteerAngle = 35,

		SeatOffset = Vector(11,-15,40),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(11,-15,8),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-96,14,52),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-96,-14,52),
				ang = Angle(-90,0,0),
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
		SteeringFadeFastSpeed = 300,

		TurnSpeed = 3,

		MaxGrip = 160,
		Efficiency = 0.8,
		GripOffset = 0,
		BrakePower = 60,
		BulletProofTires = true,

		IdleRPM = 700,
		LimitRPM = 4000,
		PeakTorque = 80.0,
		PowerbandStart = 1600,
		PowerbandEnd = 3500,
		Turbocharged = false,
		Supercharged = true,
		DoNotStall = false,

		FuelFillPos = Vector(-97,43,22),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 200,

		PowerBias = 0,

		EngineSoundPreset = 0,

		Sound_Idle = 'octoteam/vehicles/apc_idle.wav',
		Sound_IdlePitch = 1,

		Sound_Mid = 'octoteam/vehicles/apc_low.wav',
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 40,
		Sound_MidFadeOutRate = 0.3,

		Sound_High = 'octoteam/vehicles/apc_high.wav',
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 2,
		Sound_HighFadeInRPMpercent = 40,
		Sound_HighFadeInRate = 0.3,

		Sound_Throttle = 'octoteam/vehicles/apc_throttle.wav',
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 5,

		snd_horn = 'FIRETRUK_HORN',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/DUMP_VALVE.wav',

		DifferentialGear = 0.12,
		Gears = {-0.4,0,0.2,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tbogt_apc', V )

local light_table = {
	L_HeadLampPos = Vector(115,33,34),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(115,-33,34),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-108,37,45),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-108,-37,45),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(115,33,34),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(115,-33,34),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
	},

	Headlamp_sprites = {
		{pos = Vector(115,33,34),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(115,-33,34),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
	},

	Rearlight_sprites = {
		{
			pos = Vector(-108,37,45),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-108,-37,45),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-108,37,45),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-108,-37,45),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	ems_sounds = {'common/null.wav'},
	ems_sprites = {
		--rotary lights
		{
			pos = Vector(-37,29,58),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 100,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(255,135,0,20),
						Color(255,135,0,60),
						Color(255,135,0,100),
						Color(255,135,0,140),
						Color(255,135,0,180),
						Color(255,135,0,220),
						Color(255,135,0,255),
						Color(255,135,0,180),
						Color(255,135,0,100),
						Color(255,135,0,20),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-37,29,58),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(255,135,0,20),
						Color(255,135,0,60),
						Color(255,135,0,100),
						Color(255,135,0,140),
						Color(255,135,0,180),
						Color(255,135,0,220),
						Color(255,135,0,255),
						Color(255,135,0,180),
						Color(255,135,0,100),
						Color(255,135,0,20),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
	},

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(-108,41,41),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
		},
		Right = {
			{
				pos = Vector(-108,-41,41),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[4] = '',
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/apc/detail2_on',
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/apc/detail2_on',
			},
		},
		turnsignals = {
			left = {
				[5] = 'models/gta4/vehicles/apc/detail2_on'
			},
			right = {
				[6] = 'models/gta4/vehicles/apc/detail2_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_apc', light_table)