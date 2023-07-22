local V = {
	Name = 'Schafter 2nd Gen Custom',
	Model = 'models/octoteam/vehicles/schafter2.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1700.0,

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_schafter2',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,0)}
				-- CarCols[2] =  {REN.GTA4ColorTable(21,1,24)}
				-- CarCols[3] =  {REN.GTA4ColorTable(4,0,24)}
				-- CarCols[4] =  {REN.GTA4ColorTable(24,0,24)}
				-- CarCols[5] =  {REN.GTA4ColorTable(24,24,24)}
				-- CarCols[6] =  {REN.GTA4ColorTable(3,3,24)}
				-- CarCols[7] =  {REN.GTA4ColorTable(7,7,24)}
				-- CarCols[8] =  {REN.GTA4ColorTable(0,0,29)}
				-- CarCols[9] =  {REN.GTA4ColorTable(30,30,29)}
				-- CarCols[10] = {REN.GTA4ColorTable(34,34,29)}
				-- CarCols[11] = {REN.GTA4ColorTable(49,49,63)}
				-- CarCols[12] = {REN.GTA4ColorTable(52,52,63)}
				-- CarCols[13] = {REN.GTA4ColorTable(69,69,59)}
				-- CarCols[14] = {REN.GTA4ColorTable(74,74,77)}
				-- CarCols[15] = {REN.GTA4ColorTable(77,77,77)}
				-- CarCols[16] = {REN.GTA4ColorTable(85,85,83)}
				-- CarCols[17] = {REN.GTA4ColorTable(89,0,89)}
				-- CarCols[18] = {REN.GTA4ColorTable(97,97,97)}
				-- CarCols[19] = {REN.GTA4ColorTable(32,0,131)}
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

		CustomWheelModel = 'models/octoteam/vehicles/schafter2_wheel.mdl',

		CustomWheelPosFL = Vector(65,33,-10),
		CustomWheelPosFR = Vector(65,-33,-10),
		CustomWheelPosRL = Vector(-65,33,-10),
		CustomWheelPosRR = Vector(-65,-33,-10),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-10,-19,21),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(0,-19,-10),
				ang = Angle(0,-90,15),
				hasRadio = true
			},
			{
				pos = Vector(-42,19,-10),
				ang = Angle(0,-90,15)
			},
			{
				pos = Vector(-42,-19,-10),
				ang = Angle(0,-90,15)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-112,16.5,-13),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-112,-16.5,-13),
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

		MaxGrip = 93,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 27,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 141.0,
		PowerbandStart = 1700,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = true,
		DoNotStall = false,

		FuelFillPos = Vector(-80,-33.5,17),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 90,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/buffalo_idle.wav',

		snd_low = 'octoteam/vehicles/buffalo_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/buffalo_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/buffalo_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/buffalo_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/buffalo_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/huntley_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.17,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tbogt_schafter2', V )

local light_table = {
	L_HeadLampPos = Vector(87,31,6.5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(87,-31,6.5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-106,30,12.5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-106,-30,12.5),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(87,31,6.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(87,-31,6.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(25,19.5,19),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(91,26,5.2),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(91,-26,5.2),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(25,18,19),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(95,27,-9.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(95,-27,-9.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-106,30,12.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-106,-30,12.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-109,22,11.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-109,-22,11.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-110,18,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-110,-18,11),
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
				pos = Vector(84,34,7.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-105,31,9),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(25,21.5,21),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(84,-34,7.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-105,-31,9),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(25,16,21),
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
				[13] = '',
				[10] = '',
				[5] = '',
			},
			Brake = {
				[8] = '',
				[13] = '',
				[10] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[5] = '',
			},
			Reverse = {
				[8] = '',
				[13] = '',
				[10] = '',
				[5] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
			},
			Brake_Reverse = {
				[8] = '',
				[13] = '',
				[10] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[5] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[13] = '',
				[10] = '',
				[5] = '',
			},
			Brake = {
				[8] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[13] = '',
				[10] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[5] = '',
			},
			Reverse = {
				[8] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[13] = '',
				[10] = '',
				[5] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
			},
			Brake_Reverse = {
				[8] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[13] = '',
				[10] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[5] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[13] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[10] = '',
				[5] = '',
			},
			Brake = {
				[8] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[13] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[10] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[5] = '',
			},
			Reverse = {
				[8] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[13] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[10] = '',
				[5] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
			},
			Brake_Reverse = {
				[8] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[13] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[10] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[5] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/schafter2/limo2_lights_on'
			},
			right = {
				[4] = 'models/gta4/vehicles/schafter2/limo2_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_schafter2', light_table)