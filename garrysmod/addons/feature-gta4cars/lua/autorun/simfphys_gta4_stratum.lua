local V = {
	Name = 'Stratum',
	Model = 'models/octoteam/vehicles/stratum.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,0),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1900.0,

		EnginePos = Vector(60,0,10),

		LightsTable = 'gta4_stratum',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1)..math.random(0,1)..math.random(0,1)..math.random(0,1) )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,6,0)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,112,12)}
				-- CarCols[3] =  {REN.GTA4ColorTable(4,112,12)}
				-- CarCols[4] =  {REN.GTA4ColorTable(6,97,12)}
				-- CarCols[5] =  {REN.GTA4ColorTable(10,112,12)}
				-- CarCols[6] =  {REN.GTA4ColorTable(21,112,12)}
				-- CarCols[7] =  {REN.GTA4ColorTable(23,112,12)}
				-- CarCols[8] =  {REN.GTA4ColorTable(25,112,12)}
				-- CarCols[9] =  {REN.GTA4ColorTable(33,112,35)}
				-- CarCols[10] = {REN.GTA4ColorTable(34,97,34)}
				-- CarCols[11] = {REN.GTA4ColorTable(47,112,35)}
				-- CarCols[12] = {REN.GTA4ColorTable(49,112,63)}
				-- CarCols[13] = {REN.GTA4ColorTable(52,112,56)}
				-- CarCols[14] = {REN.GTA4ColorTable(54,112,55)}
				-- CarCols[15] = {REN.GTA4ColorTable(65,112,63)}
				-- CarCols[16] = {REN.GTA4ColorTable(67,112,118)}
				-- CarCols[17] = {REN.GTA4ColorTable(70,112,65)}
				-- CarCols[18] = {REN.GTA4ColorTable(98,112,90)}
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

		CustomWheelModel = 'models/octoteam/vehicles/stratum_wheel.mdl',

		CustomWheelPosFL = Vector(59,33,-4),
		CustomWheelPosFR = Vector(59,-33,-4),
		CustomWheelPosRL = Vector(-59,33,-4),
		CustomWheelPosRR = Vector(-59,-33,-4),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-11,-16,25),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(3,-16,-5),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-30,16,-5),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-30,-16,-5),
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
		BrakePower = 20,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 135.0,
		PowerbandStart = 2500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-74,-37,17),
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

		snd_horn = 'octoteam/vehicles/horns/stratum_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.14,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_stratum', V )

local light_table = {
	L_HeadLampPos = Vector(94,23,11),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(94,-23,11),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-101,32,14),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-101,-32,14),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(94,23,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},
		{
			pos = Vector(94,-23,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},

--[[		{
			pos = Vector(19,15,20),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(94,23,11),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(94,-23,11),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(19,14,20),
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
			pos = Vector(-101,32,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-101,-32,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-104,17,14.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-104,-17,14.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-104,24,11.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-104,-24,11.3),
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
				pos = Vector(88,33,10.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-101,32,11.3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(19,21,22),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(88,-33,10.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-101,-32,11.3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(19,12,22),
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
				[3] = 'models/gta4/vehicles/stratum/stratum_lights_on',
				[11] = '',
			},
			Reverse = {
				[6] = '',
				[3] = '',
				[11] = 'models/gta4/vehicles/stratum/stratum_lights_on',
			},
			Brake_Reverse = {
				[6] = '',
				[3] = 'models/gta4/vehicles/stratum/stratum_lights_on',
				[11] = 'models/gta4/vehicles/stratum/stratum_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[6] = 'models/gta4/vehicles/stratum/stratum_lights_on',
				[3] = '',
				[11] = '',
			},
			Brake = {
				[6] = 'models/gta4/vehicles/stratum/stratum_lights_on',
				[3] = 'models/gta4/vehicles/stratum/stratum_lights_on',
				[11] = '',
			},
			Reverse = {
				[6] = 'models/gta4/vehicles/stratum/stratum_lights_on',
				[3] = '',
				[11] = 'models/gta4/vehicles/stratum/stratum_lights_on',
			},
			Brake_Reverse = {
				[6] = 'models/gta4/vehicles/stratum/stratum_lights_on',
				[3] = 'models/gta4/vehicles/stratum/stratum_lights_on',
				[11] = 'models/gta4/vehicles/stratum/stratum_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[6] = 'models/gta4/vehicles/stratum/stratum_lights_on',
				[3] = '',
				[11] = '',
			},
			Brake = {
				[6] = 'models/gta4/vehicles/stratum/stratum_lights_on',
				[3] = 'models/gta4/vehicles/stratum/stratum_lights_on',
				[11] = '',
			},
			Reverse = {
				[6] = 'models/gta4/vehicles/stratum/stratum_lights_on',
				[3] = '',
				[11] = 'models/gta4/vehicles/stratum/stratum_lights_on',
			},
			Brake_Reverse = {
				[6] = 'models/gta4/vehicles/stratum/stratum_lights_on',
				[3] = 'models/gta4/vehicles/stratum/stratum_lights_on',
				[11] = 'models/gta4/vehicles/stratum/stratum_lights_on',
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/stratum/stratum_lights_on'
			},
			right = {
				[12] = 'models/gta4/vehicles/stratum/stratum_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_stratum', light_table)