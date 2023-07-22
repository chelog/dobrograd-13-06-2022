local V = {
	Name = 'Pinnacle',
	Model = 'models/octoteam/vehicles/pinnacle.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1700.0,

		EnginePos = Vector(60,0,10),

		LightsTable = 'gta4_pinnacle',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(2,2,108)}
				-- CarCols[2] =  {REN.GTA4ColorTable(3,3,108)}
				-- CarCols[3] =  {REN.GTA4ColorTable(7,7,55)}
				-- CarCols[4] =  {REN.GTA4ColorTable(9,9,48)}
				-- CarCols[5] =  {REN.GTA4ColorTable(10,10,12)}
				-- CarCols[6] =  {REN.GTA4ColorTable(14,14,12)}
				-- CarCols[7] =  {REN.GTA4ColorTable(17,17,12)}
				-- CarCols[8] =  {REN.GTA4ColorTable(20,20,12)}
				-- CarCols[9] =  {REN.GTA4ColorTable(25,25,12)}
				-- CarCols[10] = {REN.GTA4ColorTable(31,31,28)}
				-- CarCols[11] = {REN.GTA4ColorTable(33,33,91)}
				-- CarCols[12] = {REN.GTA4ColorTable(53,53,60)}
				-- CarCols[13] = {REN.GTA4ColorTable(62,62,60)}
				-- CarCols[14] = {REN.GTA4ColorTable(70,70,63)}
				-- CarCols[15] = {REN.GTA4ColorTable(78,78,18)}
				-- CarCols[16] = {REN.GTA4ColorTable(16,16,76)}
				-- CarCols[17] = {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[18] = {REN.GTA4ColorTable(15,15,93)}
				-- CarCols[19] = {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[20] = {REN.GTA4ColorTable(13,13,80)}
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

		CustomWheelModel = 'models/octoteam/vehicles/pinnacle_wheel.mdl',

		CustomWheelPosFL = Vector(60,33,-10),
		CustomWheelPosFR = Vector(60,-33,-10),
		CustomWheelPosRL = Vector(-60,33,-10),
		CustomWheelPosRR = Vector(-60,-33,-10),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-7,-20,20),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(7,-19,-13),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-33,19,-13),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-33,-19,-13),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-106,18.5,-10.5),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-106,-18.5,-10.5),
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
		BrakePower = 18,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 135.0,
		PowerbandStart = 2500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-74,-36,17),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 90,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/feltzer_idle.wav',

		snd_low = 'octoteam/vehicles/feltzer_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/feltzer_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/feltzer_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/feltzer_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/feltzer_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/banshee_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.15,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_pinnacle', V )

local light_table = {
	L_HeadLampPos = Vector(84,30,8),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(84,-30,8),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-98,33,14),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-98,-33,14),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(84,30,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},
		{
			pos = Vector(84,-30,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},

--[[		{
			pos = Vector(25,18,13.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(84,30,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(84,-30,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(25,19,13.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(92,27,-8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(92,-27,-8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-98,33,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-98,-33,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-100.5,30,9.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-100.5,-30,9.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-101.5,24.7,18.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-101.5,-24.7,18.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-97,32,16.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-97,-32,16.5),
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
				pos = Vector(80,33,10),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-98,36,9.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(25,20,13.5),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(80,-33,10),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-98,-36,9.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(25,17,13.5),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[3] = '',
				[10] = '',
				[11] = '',
			},
			Brake = {
				[3] = '',
				[10] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
				[11] = '',
			},
			Reverse = {
				[3] = '',
				[10] = '',
				[11] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
			},
			Brake_Reverse = {
				[3] = '',
				[10] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
				[11] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
				[10] = '',
				[11] = '',
			},
			Brake = {
				[3] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
				[10] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
				[11] = '',
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
				[10] = '',
				[11] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
				[10] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
				[11] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
				[10] = '',
				[11] = '',
			},
			Brake = {
				[3] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
				[10] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
				[11] = '',
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
				[10] = '',
				[11] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
				[10] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
				[11] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on',
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/pinnacle/pinnacle_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_pinnacle', light_table)