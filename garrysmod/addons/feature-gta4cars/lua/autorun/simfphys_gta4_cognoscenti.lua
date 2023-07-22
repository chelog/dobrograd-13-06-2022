local V = {
	Name = 'Cognoscenti',
	Model = 'models/octoteam/vehicles/cognoscenti.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1900,
		Trunk = { 40 },

		EnginePos = Vector(80,0,10),

		LightsTable = 'gta4_cognoscenti',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,8)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,1,8)}
				-- CarCols[3] =  {REN.GTA4ColorTable(1,0,8)}
				-- CarCols[4] =  {REN.GTA4ColorTable(3,1,8)}
				-- CarCols[5] =  {REN.GTA4ColorTable(5,6,8)}
				-- CarCols[6] =  {REN.GTA4ColorTable(6,6,8)}
				-- CarCols[7] =  {REN.GTA4ColorTable(33,0,8)}
				-- CarCols[8] =  {REN.GTA4ColorTable(52,0,54)}
				-- CarCols[9] =  {REN.GTA4ColorTable(85,85,84)}
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

		CustomWheelModel = 'models/octoteam/vehicles/cognoscenti_wheel.mdl',

		CustomWheelPosFL = Vector(83,34,-11),
		CustomWheelPosFR = Vector(83,-34,-11),
		CustomWheelPosRL = Vector(-80,34,-11),
		CustomWheelPosRR = Vector(-80,-34,-11),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 40,

		SeatOffset = Vector(7,-20,20),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(17,-20,-10),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-60,17,-10),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-60,-17,-10),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-128,23,-8),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-128,-23,-8),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 7,
		FrontConstant = 36000,
		FrontDamping = 1100,
		FrontRelativeDamping = 1100,

		RearHeight = 7,
		RearConstant = 36000,
		RearDamping = 1100,
		RearRelativeDamping = 1100,

		FastSteeringAngle = 15,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 4.5,

		MaxGrip = 58,
		Efficiency = 0.9,
		GripOffset = 0,
		BrakePower = 35,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 50,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-96,-36,16),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 65,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/admiral_idle.wav',

		snd_low = 'octoteam/vehicles/admiral_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/admiral_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/admiral_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/admiral_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/admiral_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/admiral_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(41.097, 19.298, 15.755), ang = Angle(-0.0, -90.0, 74.7) },
		Radio = { pos = Vector(43.211, -0.006, 7.809), ang = Angle(8.6, -180.0, -0.0) },
		Plates = {
			Front = { pos = Vector(123.235, 0.006, -9.527), ang = Angle(4.6, -0.0, -0.0) },
			Back = { pos = Vector(-129.770, 0.002, 11.074), ang = Angle(-23.2, -180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(21.262, 0.009, 31.857),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(34.439, 37.977, 22.139),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(35.405, -38.451, 22.029),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_cognoscenti', V )

local light_table = {
	L_HeadLampPos = Vector(110,32,2),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(110,-32,2),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-127,27,7),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-127,-27,7),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(110,32,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,100),
		},
		{
			pos = Vector(110,-32,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,100),
		},
		{
			pos = Vector(113,24,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,100),
		},
		{
			pos = Vector(113,-24,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,100),
		},

--[[		{
			pos = Vector(41,28,14),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(110,32,2),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(110,-32,2),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(113,24,3),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(113,-24,3),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(41,28,15),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(117,27.5,-9.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(117,-27.5,-9.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-127,27,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-127,-27,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-127,27,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-127,-27,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-130,14,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-130,-14,11),
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
				pos = Vector(109,32,5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-122,30,13),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(42,23,17),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(109,-32,5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-122,-30,13),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(42,16,17),
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
				[10] = '',
				[13] = '',
			},
			Brake = {
				[7] = '',
				[10] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on',
				[13] = '',
			},
			Reverse = {
				[7] = '',
				[10] = '',
				[13] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on',
			},
			Brake_Reverse = {
				[7] = '',
				[10] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on',
				[13] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[7] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on',
				[10] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on',
				[13] = '',
			},
			Reverse = {
				[7] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on',
				[10] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on',
				[13] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[7] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on',
				[10] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on',
				[13] = '',
			},
			Reverse = {
				[7] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on',
				[10] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on',
				[13] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on',
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on'
			},
			right = {
				[6] = 'models/gta4/vehicles/cognoscenti/cognoscenti_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_cognoscenti', light_table)