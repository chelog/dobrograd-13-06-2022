local V = {
	Name = 'Mule',
	Model = 'models/octoteam/vehicles/mule.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Индустриальные',
	SpawnOffset = Vector(0,0,40),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Индустриальные',

	Members = {
		Mass = 4000,
		Trunk = { 600 },

		EnginePos = Vector(110,0,20),

		LightsTable = 'gta4_mule',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,11))
			-- ent:SetBodyGroups('0'..math.random(0,6)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(112,2,113)}
				-- CarCols[2] = {REN.GTA4ColorTable(116,1,115)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

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

		CustomWheelModel = 'models/octoteam/vehicles/mule_wheel.mdl',
		CustomWheelModel_R = 'models/octoteam/vehicles/mule_wheel_r.mdl',

		CustomWheelPosFL = Vector(100,40,-31),
		CustomWheelPosFR = Vector(100,-40,-31),
		CustomWheelPosRL = Vector(-88,42,-31),
		CustomWheelPosRR = Vector(-88,-42,-31),
		CustomWheelAngleOffset = Angle(0,-90,0),

		FrontWheelRadius = 20.1,
		RearWheelRadius = 20.2,

		CustomMassCenter = Vector(0,0,25),

		CustomSteerAngle = 40,

		SeatOffset = Vector(93,-25,51),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(105,-25,0),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-29,14,-32),
				ang = Angle(-120,-25,0),
			},
		},

		FrontHeight = 20,
		FrontConstant = 25000,
		FrontDamping = 3000,
		FrontRelativeDamping = 3000,

		RearHeight = 20,
		RearConstant = 25000,
		RearDamping = 3000,
		RearRelativeDamping = 3000,

		StrengthenSuspension = true,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 110,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 35,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 45,
		PowerbandStart = 1700,
		PowerbandEnd = 4800,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 3,

		FuelFillPos = Vector(49,39,-17),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 100,

		AirFriction = -60,
		PowerBias = 1,

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

		snd_horn = 'octoteam/vehicles/horns/benson_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/DUMP_VALVE.wav',

		DifferentialGear = 0.11,
		Gears = {-0.4,0,0.2,0.35,0.5,0.75,1,1.25},

		Dash = { pos = Vector(128.397, 23.858, 28.242), ang = Angle(-0.0, -90.0, 66.4) },
		Radio = { pos = Vector(133.440, 0.006, 27.802), ang = Angle(-23.4, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(155.232, -0.001, -25.789), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-157.296, 13.530, -18.833), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			left = {
				pos = Vector(125.490, 49.212, 37.553),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(124.891, -49.048, 36.249),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},

		CanAttachPackages = true,
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_mule', V )

local light_table = {
	L_HeadLampPos = Vector(150,35,-13),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(150,-35,-13),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-158,28,-22),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-158,-28,-22),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(150,35,-13),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(150,-35,-13),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(128,27,27.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(151,28,-13),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(151,-28,-13),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(128,26,27.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-158,28,-22),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-158,-28,-22),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-158,28,-15),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-158,-28,-15),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-158,29,-27),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-158,-29,-27),
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
				pos = Vector(149,41,-13),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-175,43,-6),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(129,28,29.5),
				material = 'gta4/dash_left',
				size = 1,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(149,-41,-13),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-175,-43,-6),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(129,19,29.5),
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
				[11] = '',
				[7] = '',
				[10] = '',
			},
			Brake = {
				[2] = '',
				[11] = '',
				[7] = 'models/gta4/vehicles/mule/detail2_on',
				[10] = '',
			},
			Reverse = {
				[2] = '',
				[11] = '',
				[7] = '',
				[10] = 'models/gta4/vehicles/mule/detail2_on',
			},
			Brake_Reverse = {
				[2] = '',
				[11] = '',
				[7] = 'models/gta4/vehicles/mule/detail2_on',
				[10] = 'models/gta4/vehicles/mule/detail2_on',
			},
		},
		on_lowbeam = {
			Base = {
				[2] = 'models/gta4/vehicles/mule/detail2_on',
				[11] = '',
				[7] = '',
				[10] = '',
			},
			Brake = {
				[2] = 'models/gta4/vehicles/mule/detail2_on',
				[11] = '',
				[7] = 'models/gta4/vehicles/mule/detail2_on',
				[10] = '',
			},
			Reverse = {
				[2] = 'models/gta4/vehicles/mule/detail2_on',
				[11] = '',
				[7] = '',
				[10] = 'models/gta4/vehicles/mule/detail2_on',
			},
			Brake_Reverse = {
				[2] = 'models/gta4/vehicles/mule/detail2_on',
				[11] = '',
				[7] = 'models/gta4/vehicles/mule/detail2_on',
				[10] = 'models/gta4/vehicles/mule/detail2_on',
			},
		},
		on_highbeam = {
			Base = {
				[2] = 'models/gta4/vehicles/mule/detail2_on',
				[11] = 'models/gta4/vehicles/mule/detail2_on',
				[7] = '',
				[10] = '',
			},
			Brake = {
				[2] = 'models/gta4/vehicles/mule/detail2_on',
				[11] = 'models/gta4/vehicles/mule/detail2_on',
				[7] = 'models/gta4/vehicles/mule/detail2_on',
				[10] = '',
			},
			Reverse = {
				[2] = 'models/gta4/vehicles/mule/detail2_on',
				[11] = 'models/gta4/vehicles/mule/detail2_on',
				[7] = '',
				[10] = 'models/gta4/vehicles/mule/detail2_on',
			},
			Brake_Reverse = {
				[2] = 'models/gta4/vehicles/mule/detail2_on',
				[11] = 'models/gta4/vehicles/mule/detail2_on',
				[7] = 'models/gta4/vehicles/mule/detail2_on',
				[10] = 'models/gta4/vehicles/mule/detail2_on',
			},
		},
		turnsignals = {
			left = {
				[6] = 'models/gta4/vehicles/mule/detail2_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/mule/detail2_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_mule', light_table)