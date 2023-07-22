local V = {
	Name = 'Feroci (FlyUS)',
	Model = 'models/octoteam/vehicles/feroci2.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1600.0,

		EnginePos = Vector(70,0,10),

		LightsTable = 'gta4_feroci2',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

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

		CustomWheelModel = 'models/octoteam/vehicles/feroci2_wheel.mdl',

		CustomWheelPosFL = Vector(60,29,-4),
		CustomWheelPosFR = Vector(60,-29,-4),
		CustomWheelPosRL = Vector(-59,29,-4),
		CustomWheelPosRR = Vector(-59,-29,-4),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 32,

		SeatOffset = Vector(-9,-17,25),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(2,-17,-8),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-27,17,-6),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-27,-17,-6),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-103,22,-5),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 10,
		FrontConstant = 25000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 10,
		RearConstant = 25000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 77,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 22,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 140.0,
		PowerbandStart = 2500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-80,32,20),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 80,

		PowerBias = 1,

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

		snd_horn = 'octoteam/vehicles/horns/feroci_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.17,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_feroci2', V )

local light_table = {
	L_HeadLampPos = Vector(93,21,10),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(93,-21,10),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-103,26,20.8),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-103,-26,20.8),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(93,21,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(93,-21,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(23,17.5,17),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(76,240,255,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(93,21,10),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(93,-21,10),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(23,15.7,17),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(76,240,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(95,22,-4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(95,-22,-4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-103,26,20.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-103,-26,20.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-103,26,20.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-103,0,24.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-103,-26,20.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-104,22,16.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-104,-22,16.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	ems_sounds = {'common/null.wav'},
	ems_sprites = {
		{
			pos = Vector(-2,0,46),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 80,
			Colors = {
						Color(255,135,0,255),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.1
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(91,30,8.3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-103,29,16.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,18.9,19.3),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(91,-30,8.3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-103,-29,16.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,14.4,19.3),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[8] = '',
				[10] = '',
				[11] = '',
			},
			Brake = {
				[8] = '',
				[10] = 'models/gta4/vehicles/feroci/feroci_lights_on',
				[11] = '',
			},
			Reverse = {
				[8] = '',
				[10] = '',
				[11] = 'models/gta4/vehicles/feroci/feroci_lights_on',
			},
			Brake_Reverse = {
				[8] = '',
				[10] = 'models/gta4/vehicles/feroci/feroci_lights_on',
				[11] = 'models/gta4/vehicles/feroci/feroci_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/feroci/feroci_lights_on',
				[10] = '',
				[11] = '',
			},
			Brake = {
				[8] = 'models/gta4/vehicles/feroci/feroci_lights_on',
				[10] = 'models/gta4/vehicles/feroci/feroci_lights_on',
				[11] = '',
			},
			Reverse = {
				[8] = 'models/gta4/vehicles/feroci/feroci_lights_on',
				[10] = '',
				[11] = 'models/gta4/vehicles/feroci/feroci_lights_on',
			},
			Brake_Reverse = {
				[8] = 'models/gta4/vehicles/feroci/feroci_lights_on',
				[10] = 'models/gta4/vehicles/feroci/feroci_lights_on',
				[11] = 'models/gta4/vehicles/feroci/feroci_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/feroci/feroci_lights_on',
				[10] = '',
				[11] = '',
			},
			Brake = {
				[8] = 'models/gta4/vehicles/feroci/feroci_lights_on',
				[10] = 'models/gta4/vehicles/feroci/feroci_lights_on',
				[11] = '',
			},
			Reverse = {
				[8] = 'models/gta4/vehicles/feroci/feroci_lights_on',
				[10] = '',
				[11] = 'models/gta4/vehicles/feroci/feroci_lights_on',
			},
			Brake_Reverse = {
				[8] = 'models/gta4/vehicles/feroci/feroci_lights_on',
				[10] = 'models/gta4/vehicles/feroci/feroci_lights_on',
				[11] = 'models/gta4/vehicles/feroci/feroci_lights_on',
			},
		},
		turnsignals = {
			left = {
				[7] = 'models/gta4/vehicles/feroci/feroci_lights_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/feroci/feroci_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_feroci2', light_table)