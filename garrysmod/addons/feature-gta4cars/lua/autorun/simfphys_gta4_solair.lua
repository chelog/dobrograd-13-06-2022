local V = {
	Name = 'Solair',
	Model = 'models/octoteam/vehicles/solair.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,0),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 2100.0,

		EnginePos = Vector(70,0,10),

		LightsTable = 'gta4_solair',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(72,72,1)}
				-- CarCols[2] =  {REN.GTA4ColorTable(30,30,1)}
				-- CarCols[3] =  {REN.GTA4ColorTable(34,34,1)}
				-- CarCols[4] =  {REN.GTA4ColorTable(37,37,1)}
				-- CarCols[5] =  {REN.GTA4ColorTable(43,43,1)}
				-- CarCols[6] =  {REN.GTA4ColorTable(52,52,1)}
				-- CarCols[7] =  {REN.GTA4ColorTable(54,54,1)}
				-- CarCols[8] =  {REN.GTA4ColorTable(55,55,1)}
				-- CarCols[9] =  {REN.GTA4ColorTable(52,52,1)}
				-- CarCols[10] = {REN.GTA4ColorTable(65,65,1)}
				-- CarCols[11] = {REN.GTA4ColorTable(69,69,1)}
				-- CarCols[12] = {REN.GTA4ColorTable(70,70,1)}
				-- CarCols[13] = {REN.GTA4ColorTable(72,72,1)}
				-- CarCols[14] = {REN.GTA4ColorTable(75,75,1)}
				-- CarCols[15] = {REN.GTA4ColorTable(84,84,1)}
				-- CarCols[16] = {REN.GTA4ColorTable(88,88,1)}
				-- CarCols[17] = {REN.GTA4ColorTable(90,90,1)}
				-- CarCols[18] = {REN.GTA4ColorTable(106,106,1)}
				-- CarCols[19] = {REN.GTA4ColorTable(119,119,1)}
				-- CarCols[20] = {REN.GTA4ColorTable(111,111,1)}
				-- CarCols[21] = {REN.GTA4ColorTable(22,22,72)}
				-- CarCols[22] = {REN.GTA4ColorTable(13,11,91)}
				-- CarCols[23] = {REN.GTA4ColorTable(19,19,93)}
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

		CustomWheelModel = 'models/octoteam/vehicles/solair_wheel.mdl',

		CustomWheelPosFL = Vector(60,31,-4),
		CustomWheelPosFR = Vector(60,-31,-4),
		CustomWheelPosRL = Vector(-60,31,-4),
		CustomWheelPosRR = Vector(-60,-31,-4),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-7,-19,25),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(6,-18,-5),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-40,18,-5),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-40,-18,-5),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-98,-21,-4.5),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 10,
		FrontConstant = 28000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 10,
		RearConstant = 28000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 77,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 18,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 130.0,
		PowerbandStart = 2500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-75,-35,17.5),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 90,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/lokus_idle.wav',

		snd_low = 'octoteam/vehicles/lokus_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/lokus_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/lokus_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/lokus_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/lokus_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/solair_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.15,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_solair', V )

local light_table = {
	L_HeadLampPos = Vector(92,24,9.5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(92,-24,9.5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-103,16,15.5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-103,-16,15.5),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(92,24,9.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},
		{
			pos = Vector(92,-24,9.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},

--[[		{
			pos = Vector(29,11,20),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(92,24,9.5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(92,-24,9.5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(29,11,21),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(96,26,-2.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(96,-26,-2.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-103,16,15.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-103,-16,15.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-102,18,20),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-103,0,20),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-102,-18,20),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-102,21,15.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-102,-21,15.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(90,27.9,9.7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-100,30,20),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-100,31,15.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(29.4,22.5,23),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(90,-27.9,9.7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-100,-30,20),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-100,-31,15.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(29.4,16,23),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[6] = '',
				[3] = '',
				[11] = '',
			},
			Brake = {
				[6] = '',
				[3] = 'models/gta4/vehicles/solair/solair_lights_on',
				[11] = '',
			},
			Reverse = {
				[6] = '',
				[3] = '',
				[11] = 'models/gta4/vehicles/solair/solair_lights_on',
			},
			Brake_Reverse = {
				[6] = '',
				[3] = 'models/gta4/vehicles/solair/solair_lights_on',
				[11] = 'models/gta4/vehicles/solair/solair_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[6] = 'models/gta4/vehicles/solair/solair_lights_on',
				[3] = '',
				[11] = '',
			},
			Brake = {
				[6] = 'models/gta4/vehicles/solair/solair_lights_on',
				[3] = 'models/gta4/vehicles/solair/solair_lights_on',
				[11] = '',
			},
			Reverse = {
				[6] = 'models/gta4/vehicles/solair/solair_lights_on',
				[3] = '',
				[11] = 'models/gta4/vehicles/solair/solair_lights_on',
			},
			Brake_Reverse = {
				[6] = 'models/gta4/vehicles/solair/solair_lights_on',
				[3] = 'models/gta4/vehicles/solair/solair_lights_on',
				[11] = 'models/gta4/vehicles/solair/solair_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[6] = 'models/gta4/vehicles/solair/solair_lights_on',
				[3] = '',
				[11] = '',
			},
			Brake = {
				[6] = 'models/gta4/vehicles/solair/solair_lights_on',
				[3] = 'models/gta4/vehicles/solair/solair_lights_on',
				[11] = '',
			},
			Reverse = {
				[6] = 'models/gta4/vehicles/solair/solair_lights_on',
				[3] = '',
				[11] = 'models/gta4/vehicles/solair/solair_lights_on',
			},
			Brake_Reverse = {
				[6] = 'models/gta4/vehicles/solair/solair_lights_on',
				[3] = 'models/gta4/vehicles/solair/solair_lights_on',
				[11] = 'models/gta4/vehicles/solair/solair_lights_on',
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/solair/solair_lights_on'
			},
			right = {
				[13] = 'models/gta4/vehicles/solair/solair_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_solair', light_table)