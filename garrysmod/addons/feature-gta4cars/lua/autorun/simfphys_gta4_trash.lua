local V = {
	Name = 'Trashmaster',
	Model = 'models/octoteam/vehicles/trash.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Сервис',
	SpawnOffset = Vector(0,0,40),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Сервис',

	Members = {
		Mass = 6500.0,

		EnginePos = Vector(150,0,30),

		LightsTable = 'gta4_trash',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(113,113,113)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 1, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 1, 1, 2) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/trash_wheel.mdl',
		CustomWheelModel_R = 'models/octoteam/vehicles/trash_wheel_r.mdl',

		CustomWheelPosFL = Vector(110,44,-7),
		CustomWheelPosFR = Vector(110,-44,-7),
		CustomWheelPosML = Vector(-51,40,-7),
		CustomWheelPosMR = Vector(-51,-40,-7),
		CustomWheelPosRL = Vector(-111,40,-7),
		CustomWheelPosRR = Vector(-111,-40,-7),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,25),

		CustomSteerAngle = 40,

		SeatOffset = Vector(128,-29,70),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(140,-30,15),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(112,-53,112),
				ang = Angle(0,0,0),
			},
		},

		StrengthenedSuspension = true,

		FrontHeight = 20,
		FrontConstant = 50000,
		FrontDamping = 2000,
		FrontRelativeDamping = 350,

		RearHeight = 12,
		RearConstant = 50000,
		RearDamping = 2000,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 700,

		TurnSpeed = 3,

		MaxGrip = 85,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = false,

		IdleRPM = 700,
		LimitRPM = 4500,
		PeakTorque = 100.0,
		PowerbandStart = 1700,
		PowerbandEnd = 4000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(34,41,18),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 150,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 0.9,
		snd_idle = 'octoteam/vehicles/phantom_idle.wav',

		snd_low = 'octoteam/vehicles/phantom_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/phantom_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/phantom_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/phantom_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/phantom_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'TRUCK_HORN',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/DUMP_VALVE.wav',

		DifferentialGear = 0.11,
		Gears = {-0.4,0,0.2,0.35,0.5,0.75,1,1.25}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_trash', V )

local light_table = {
	L_HeadLampPos = Vector(179,40,19),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(179,-40,19),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-152,34.3,98.6),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-152,-34.3,98.6),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(179,40,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(179,-40,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(159.4,39,39.3),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(179,32,19),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(179,-32,19),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(159.4,38,39.3),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-152,41.3,98.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-152,34.3,98.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-152,27.3,98.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-152,-41.3,98.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-152,-34.3,98.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-152,-27.3,98.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-208,31,-12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-208,-31,-12),
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
				pos = Vector(179,46.5,19),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},
			{
				pos = Vector(-208,41,-12),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(162,33.5,42.5),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(179,-46.5,19),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},
			{
				pos = Vector(-208,-41,-12),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(162,27.3,42.5),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[7] = '',
				[6] = '',
				[5] = '',
			},
			Brake = {
				[7] = '',
				[6] = '',
				[5] = 'models/gta4/vehicles/trash/detail2_on',
			},
		},
		on_lowbeam = {
			Base = {
				[7] = 'models/gta4/vehicles/trash/detail2_on',
				[6] = '',
				[5] = '',
			},
			Brake = {
				[7] = 'models/gta4/vehicles/trash/detail2_on',
				[6] = '',
				[5] = 'models/gta4/vehicles/trash/detail2_on',
			},
		},
		on_highbeam = {
			Base = {
				[7] = 'models/gta4/vehicles/trash/detail2_on',
				[6] = 'models/gta4/vehicles/trash/detail2_on',
				[5] = '',
			},
			Brake = {
				[7] = 'models/gta4/vehicles/trash/detail2_on',
				[6] = 'models/gta4/vehicles/trash/detail2_on',
				[5] = 'models/gta4/vehicles/trash/detail2_on',
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/trash/detail2_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/trash/detail2_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_trash', light_table)