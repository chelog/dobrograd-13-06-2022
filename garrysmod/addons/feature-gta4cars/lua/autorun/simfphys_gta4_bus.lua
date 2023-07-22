sound.Add({
	name = 'BUS_HORN',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 85,
	sound = 'octoteam/vehicles/horns/bus_horn.wav'
} )

local V = {
	Name = 'Bus',
	Model = 'models/octoteam/vehicles/bus.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Сервис',
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Сервис',

	Members = {
		Mass = 3000,
		Trunk = { 100 },

		EnginePos = Vector(-240,0,0),

		LightsTable = 'gta4_bus',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,2)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(53,8,53)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 1, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 1, 1, 3) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/bus_wheel.mdl',
		CustomWheelModel_R = 'models/octoteam/vehicles/bus_wheel_r.mdl',

		CustomWheelPosFL = Vector(145,47,-25),
		CustomWheelPosFR = Vector(145,-47,-25),
		CustomWheelPosRL = Vector(-145,41,-25),
		CustomWheelPosRR = Vector(-145,-41,-25),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,25),

		CustomSteerAngle = 40,

		SeatOffset = Vector(180,-34,70),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(76,-33,3),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
			{
				pos = Vector(76,33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(38,-33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(38,33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(0,-33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(0,33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(36,-33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(36,33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-176,-33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-176,33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-221,-33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-221,33,3),
				ang = Angle(0,-90,0)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-245.1,48.4,77.5),
				ang = Angle(-90,-15,0),
			},
		},

		FrontHeight = 6,
		FrontConstant = 65000,
		FrontDamping = 2000,
		FrontRelativeDamping = 2000,

		RearHeight = 6,
		RearConstant = 65000,
		RearDamping = 2000,
		RearRelativeDamping = 2000,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 90,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 4500,
		PeakTorque = 50,
		PowerbandStart = 1700,
		PowerbandEnd = 4300,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 1.8,

		FuelFillPos = Vector(-240,55,0),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 140,

		PowerBias = 0,

		EngineSoundPreset = -1,

		snd_pitch = 1.1,
		snd_idle = 'octoteam/vehicles/bus_idle.wav',

		snd_low = 'octoteam/vehicles/bus_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/bus_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/bus_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/bus_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/bus_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'BUS_HORN',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.1,0,0.1,0.16,0.23,0.32,0.42},

		Dash = { pos = Vector(221.076, 33.305, 25.619), ang = Angle(-0.0, -90.0, 53.4) },
		Radio = { pos = Vector(226.149, 22.585, 23.061), ang = Angle(-36.3, -180.0, -0.0) },
		Plates = {
			Front = { pos = Vector(237.777, -0.022, -12.570), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-269.402, -0.202, -25.433), ang = Angle(-4.4, -180.0, 0.0) },
		},
		Mirrors = {
			left = {
				pos = Vector(223.264, 61.857, 42.534),
				w = 1 / 5,
				ratio = 1 / 2,
			},
			right = {
				pos = Vector(228.512, -60.299, 42.042),
				w = 1 / 5,
				ratio = 1 / 2,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_bus', V )

local light_table = {
	L_HeadLampPos = Vector(239,41,-15),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(239,-41,-15),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-266.5,50.3,9.8),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-266.5,-50.3,9.8),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(239,41,-15),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(239,-41,-15),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(222.4,35,27.3),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(239,32,-15),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(239,23,-15),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(239,-32,-15),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(239,-23,-15),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(222.4,36,27.3),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-266.5,50.3,9.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-266.5,-50.3,9.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-266.5,50.3,3.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-266.5,-50.3,3.4),
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
				pos = Vector(239,49.1,-15),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-266.5,50.3,-2.9),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(222,37.5,26.9),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(239,-49.1,-15),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-266.5,-50.3,-2.9),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(222,35,26.9),
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
				[10] = '',
				[6] = ''
			},
			Brake = {
				[9] = '',
				[10] = '',
				[6] = 'models/gta4/vehicles/bus/detail2_on'
			},
		},
		on_lowbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/bus/detail2_on',
				[10] = '',
				[6] = ''
			},
			Brake = {
				[9] = 'models/gta4/vehicles/bus/detail2_on',
				[10] = '',
				[6] = 'models/gta4/vehicles/bus/detail2_on'
			},
		},
		on_highbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/bus/detail2_on',
				[10] = 'models/gta4/vehicles/bus/detail2_on',
				[6] = ''
			},
			Brake = {
				[9] = 'models/gta4/vehicles/bus/detail2_on',
				[10] = 'models/gta4/vehicles/bus/detail2_on',
				[6] = 'models/gta4/vehicles/bus/detail2_on'
			},
		},
		turnsignals = {
			left = {
				[11] = 'models/gta4/vehicles/bus/detail2_on'
			},
			right = {
				[7] = 'models/gta4/vehicles/bus/detail2_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_bus', light_table)