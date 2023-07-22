local V = {
	Name = 'Moonbeam',
	Model = 'models/octoteam/vehicles/moonbeam.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 2600,
		Trunk = {
			nil,
			{80, 1, 2},
		},

		EnginePos = Vector(70,0,10),

		LightsTable = 'gta4_moonbeam',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,2)..math.random(0,3)..math.random(0,1)..math.random(0,1)..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =   {REN.GTA4ColorTable(102,104,104)}
				-- CarCols[2] =   {REN.GTA4ColorTable(103,102,103)}
				-- CarCols[3] =   {REN.GTA4ColorTable(108,109,108)}
				-- CarCols[4] =   {REN.GTA4ColorTable(11,102,12)}
				-- CarCols[5] =   {REN.GTA4ColorTable(10,1,12)}
				-- CarCols[6] =   {REN.GTA4ColorTable(1,7,12)}
				-- CarCols[7] =   {REN.GTA4ColorTable(20,17,12)}
				-- CarCols[8] =   {REN.GTA4ColorTable(31,33,27)}
				-- CarCols[9] =   {REN.GTA4ColorTable(40,41,30)}
				-- CarCols[10] =  {REN.GTA4ColorTable(52,53,51)}
				-- CarCols[11] =  {REN.GTA4ColorTable(60,57,53)}
				-- CarCols[12] =  {REN.GTA4ColorTable(67,64,63)}
				-- CarCols[13] =  {REN.GTA4ColorTable(77,73,68)}
				-- CarCols[14] =  {REN.GTA4ColorTable(16,16,76)}
				-- CarCols[15] =  {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[16] =  {REN.GTA4ColorTable(15,15,93)}
				-- CarCols[17] =  {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[18] =  {REN.GTA4ColorTable(13,13,80)}
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

		CustomWheelModel = 'models/octoteam/vehicles/moonbeam_wheel.mdl',

		CustomWheelPosFL = Vector(62,32,-13),
		CustomWheelPosFR = Vector(62,-32,-13),
		CustomWheelPosRL = Vector(-62,34,-13),
		CustomWheelPosRR = Vector(-62,-34,-13),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,15),

		CustomSteerAngle = 30,

		SeatOffset = Vector(2,-19,30),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(14,-19,-3),
				ang = Angle(0,-90,10),
				hasRadio = true
			},
			{
				pos = Vector(-33,20,-4),
				ang = Angle(0,-90,10)
			},
			-- {
			-- 	pos = Vector(-33,0,-3),
			-- 	ang = Angle(0,-90,10)
			-- },
			{
				pos = Vector(-33,-19,-5),
				ang = Angle(0,-90,10)
			},
			{
				pos = Vector(-75,20,4),
				ang = Angle(0,-90,10)
			},
			{
				pos = Vector(-75,0,4),
				ang = Angle(0,-90,10)
			},
			{
				pos = Vector(-75,-20,4),
				ang = Angle(0,-90,10)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-101.7,-17.8,-13.5),
				ang = Angle(-120,0,0),
			},
		},

		FrontHeight = 6,
		FrontConstant = 60000,
		FrontDamping = 1500,
		FrontRelativeDamping = 1500,

		RearHeight = 6,
		RearConstant = 60000,
		RearDamping = 1500,
		RearRelativeDamping = 1500,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3,

		MaxGrip = 70,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 35,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 42,
		PowerbandStart = 1700,
		PowerbandEnd = 4800,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 2,

		FuelFillPos = Vector(-80,40,20),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 80,

		AirFriction = -15,
		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/burrito_idle.wav',

		snd_low = 'octoteam/vehicles/burrito_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/burrito_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/burrito_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/burrito_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/burrito_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/moonbeam_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.1,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(39.974, 19.916, 24.007), ang = Angle(-0.0, -90.0, 79.0) },
		Radio = { pos = Vector(39.335, -1.035, 17.923), ang = Angle(-0.0, 155.8, 0.0) },
		Plates = {
			Front = { pos = Vector(93.231, -0.002, -6.893), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-108.438, -0.007, -7.804), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(30.283, -0.007, 45.993),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(43.020, 40.054, 31.419),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(43.707, -40.297, 30.792),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_moonbeam', V )

local light_table = {
	L_HeadLampPos = Vector(85,26,11),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(85,-26,11),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-103,36,18),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-103,-36,18),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(85,26,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},
		{
			pos = Vector(85,-26,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},

--[[		{
			pos = Vector(41,22.3,26),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(85,26,11),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(85,-26,11),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(41,23.1,26),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-103,36,18),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-103,-36,18),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-103,36,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-103,-36,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-103,36,18),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-103,-36,18),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-103,36,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-103,-36,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-103,36,14.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-103,-36,14.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	ems_sounds = {'octoteam/vehicles/police/siren1.wav','octoteam/vehicles/police/siren2.wav','octoteam/vehicles/police/siren3.wav'},
	ems_sprites = {
		{
			pos = Vector(33.6, 21.7, 49.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
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
			pos = Vector(33.6, -21.7, 49.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,0,0),
				Color(0,0,0,0),
				Color(0,0,0,0),
				--
				Color(0,0,0,0),
				Color(0,0,0,0),
				Color(0,0,0,0),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
				Color(0,0,0,0),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
				Color(0,0,0,0),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
				Color(0,0,0,0),
				--
				Color(0,0,0,0),
				Color(0,0,0,0),
				Color(0,0,0,0),
			},
			Speed = 0.034
		},
		{
			pos = Vector(33.6, 6.4, 49.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 45,
			Colors = {
				Color(255, 0, 0),
				Color(255, 0, 0),
				Color(0,0,0,0),
				--
				Color(255, 0, 0),
				Color(255, 0, 0),
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
				Color(255, 0, 0),
				Color(255, 0, 0),
				Color(0,0,0,0),
			},
			Speed = 0.035
		},
		{
			pos = Vector(33.6, -6.4, 49.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 45,
			Colors = {
				Color(0,0,0,0),
				Color(0,0,0,0),
				Color(0,0,0,0),
				--
				Color(0,0,0,0),
				Color(0,0,0,0),
				Color(0,0,0,0),
				--
				Color(255, 0, 0),
				Color(255, 0, 0),
				Color(0,0,0,0),
				--
				Color(255, 0, 0),
				Color(255, 0, 0),
				Color(0,0,0,0),
				--
				Color(255, 0, 0),
				Color(255, 0, 0),
				Color(0,0,0,0),
				--
				Color(0,0,0,0),
				Color(0,0,0,0),
				Color(0,0,0,0),
			},
			Speed = 0.035
		},
		{
			pos = Vector(-98.1, 19.5, 46.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,255),
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
			pos = Vector(-98.1, -19.5, 46.2),
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
			Speed = 0.033
		},
		{
			pos = Vector(-98.1, -4.1, 46.2),
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
			pos = Vector(-98.1, 4.1, 46.2),
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
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(84,34,10),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-103,36,10.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,135,150),
			},

--[[			{
				pos = Vector(41,23.7,25.4),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(84,-34,10),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-103,-36,10.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,135,150),
			},

--[[			{
				pos = Vector(41,18.6,25.4),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[12] = '',
				[10] = '',
				[11] = '',
			},
			Brake = {
				[12] = '',
				[10] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[11] = '',
			},
			Reverse = {
				[12] = '',
				[10] = '',
				[11] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on'
			},
			Brake_Reverse = {
				[12] = '',
				[10] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[11] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[12] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[10] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[11] = '',
			},
			Brake = {
				[12] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[10] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[11] = '',
			},
			Reverse = {
				[12] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[10] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[11] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on'
			},
			Brake_Reverse = {
				[12] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[10] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[11] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[12] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[10] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[11] = '',
			},
			Brake = {
				[12] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[10] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[11] = '',
			},
			Reverse = {
				[12] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[10] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[11] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on'
			},
			Brake_Reverse = {
				[12] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[10] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on',
				[11] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on'
			},
		},
		turnsignals = {
			left = {
				[6] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/moonbeam/moonbeam_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_moonbeam', light_table)