local V = {
	Name = 'Chavos',
	Model = 'models/octoteam/vehicles/chavos.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1550.0,

		EnginePos = Vector(60,0,10),

		LightsTable = 'gta4_chavos',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(1,0,7)}
				-- CarCols[2] =  {REN.GTA4ColorTable(10,0,10)}
				-- CarCols[3] =  {REN.GTA4ColorTable(33,33,27)}
				-- CarCols[4] =  {REN.GTA4ColorTable(45,0,30)}
				-- CarCols[5] =  {REN.GTA4ColorTable(49,49,50)}
				-- CarCols[6] =  {REN.GTA4ColorTable(50,49,51)}
				-- CarCols[7] =  {REN.GTA4ColorTable(57,0,58)}
				-- CarCols[8] =  {REN.GTA4ColorTable(64,64,63)}
				-- CarCols[9] =  {REN.GTA4ColorTable(68,68,43)}
				-- CarCols[10] = {REN.GTA4ColorTable(2,2,63)}
				-- CarCols[11] = {REN.GTA4ColorTable(21,21,72)}
				-- CarCols[12] = {REN.GTA4ColorTable(22,22,72)}
				-- CarCols[13] = {REN.GTA4ColorTable(13,11,91)}
				-- CarCols[14] = {REN.GTA4ColorTable(19,19,93)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

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

		CustomWheelModel = 'models/octoteam/vehicles/chavos_wheel.mdl',

		CustomWheelPosFL = Vector(56,30,-3),
		CustomWheelPosFR = Vector(56,-30,-3),
		CustomWheelPosRL = Vector(-60,30,-3),
		CustomWheelPosRR = Vector(-60,-30,-3),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-11,-15,25),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(0,-15,-7),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-33,15,-7),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-33,-15,-7),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-92,-19,-7),
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

		MaxGrip = 80,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 30,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 145.0,
		PowerbandStart = 1700,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-62,-33,23),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 70,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/sultan_idle.wav',

		snd_low = 'octoteam/vehicles/sultan_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/sultan_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/sultan_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/sultan_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/sultan_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/sultanrs_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.18,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_chavos', V )

local light_table = {
	L_HeadLampPos = Vector(85,26,9),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(85,-26,9),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-89,29,14),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-89,-29,14),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(85,26,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(85,-26,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(19.5,22.5,21),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(87.5,18,8.5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(87.5,-18,8.5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(19.5,22.5,22),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(88,25,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(88,-25,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-89,29,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-89,-29,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-89,22,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-89,-22,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-89,26.5,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-89,-26.5,14),
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
				pos = Vector(81,30.5,9),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-89,29,18),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(20,19,24),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(81,-30.5,9),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-89,-29,18),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(20,14,24),
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
				[7] = '',
				[12] = '',
				[11] = '',
			},
			Brake = {
				[8] = '',
				[7] = '',
				[12] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[11] = '',
			},
			Reverse = {
				[8] = '',
				[7] = '',
				[12] = '',
				[11] = 'models/gta4/vehicles/chavos/chavos_lights_on',
			},
			Brake_Reverse = {
				[8] = '',
				[7] = '',
				[12] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[11] = 'models/gta4/vehicles/chavos/chavos_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[7] = '',
				[12] = '',
				[11] = '',
			},
			Brake = {
				[8] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[7] = '',
				[12] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[11] = '',
			},
			Reverse = {
				[8] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[7] = '',
				[12] = '',
				[11] = 'models/gta4/vehicles/chavos/chavos_lights_on',
			},
			Brake_Reverse = {
				[8] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[7] = '',
				[12] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[11] = 'models/gta4/vehicles/chavos/chavos_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[7] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[12] = '',
				[11] = '',
			},
			Brake = {
				[8] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[7] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[12] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[11] = '',
			},
			Reverse = {
				[8] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[7] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[12] = '',
				[11] = 'models/gta4/vehicles/chavos/chavos_lights_on',
			},
			Brake_Reverse = {
				[8] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[7] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[12] = 'models/gta4/vehicles/chavos/chavos_lights_on',
				[11] = 'models/gta4/vehicles/chavos/chavos_lights_on',
			},
		},
		turnsignals = {
			left = {
				[13] = 'models/gta4/vehicles/chavos/chavos_lights_on'
			},
			right = {
				[6] = 'models/gta4/vehicles/chavos/chavos_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_chavos', light_table)