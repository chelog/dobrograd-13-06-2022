local V = {
	Name = 'Blista Compact',
	Model = 'models/octoteam/vehicles/blista.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Хетчбеки',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Хетчбеки',

	Members = {
		Mass = 1400.0,

		EnginePos = Vector(65,0,10),

		LightsTable = 'gta4_blista',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1)..math.random(0,2)..math.random(0,1)..math.random(0,1)..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,1)}
				-- CarCols[2] =  {REN.GTA4ColorTable(3,0,1)}
				-- CarCols[3] =  {REN.GTA4ColorTable(4,4,1)}
				-- CarCols[4] =  {REN.GTA4ColorTable(10,10,92)}
				-- CarCols[5] =  {REN.GTA4ColorTable(16,0,1)}
				-- CarCols[6] =  {REN.GTA4ColorTable(31,0,1)}
				-- CarCols[7] =  {REN.GTA4ColorTable(31,31,33)}
				-- CarCols[8] =  {REN.GTA4ColorTable(34,0,1)}
				-- CarCols[9] =  {REN.GTA4ColorTable(36,10,37)}
				-- CarCols[10] = {REN.GTA4ColorTable(36,36,1)}
				-- CarCols[11] = {REN.GTA4ColorTable(49,49,75)}
				-- CarCols[12] = {REN.GTA4ColorTable(52,0,1)}
				-- CarCols[13] = {REN.GTA4ColorTable(56,56,57)}
				-- CarCols[14] = {REN.GTA4ColorTable(55,0,1)}
				-- CarCols[15] = {REN.GTA4ColorTable(62,55,1)}
				-- CarCols[16] = {REN.GTA4ColorTable(64,0,1)}
				-- CarCols[17] = {REN.GTA4ColorTable(68,0,72)}
				-- CarCols[18] = {REN.GTA4ColorTable(72,0,2)}
				-- CarCols[19] = {REN.GTA4ColorTable(95,0,1)}
				-- CarCols[20] = {REN.GTA4ColorTable(103,104,1)}
				-- CarCols[21] = {REN.GTA4ColorTable(106,0,1)}
				-- CarCols[22] = {REN.GTA4ColorTable(109,109,1)}
				-- CarCols[23] = {REN.GTA4ColorTable(1,109,1)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 1) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/blista_wheel.mdl',

		CustomWheelPosFL = Vector(58,29,-7),
		CustomWheelPosFR = Vector(58,-29,-7),
		CustomWheelPosRL = Vector(-58,29,-7),
		CustomWheelPosRR = Vector(-58,-29,-7),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0.02,-2.4),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-14,-15,22),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-1,-15,-10),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-91,-21,-6),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-91,-16.8,-6),
				ang = Angle(-90,0,0),
				OnBodyGroups = {
					[1] = {1},
				}
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

		MaxGrip = 72,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 30,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 150.0,
		PowerbandStart = 1700,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-60,35,16),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 65,

		PowerBias = -1,

		EngineSoundPreset = -1,

		snd_pitch = 1.1,
		snd_idle = 'octoteam/vehicles/blista_idle.wav',

		snd_low = 'octoteam/vehicles/blista_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/blista_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/blista_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/blista_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/blista_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/blista_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.18,
		Gears = {-0.5,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_blista', V )

local light_table = {
	L_HeadLampPos = Vector(91,23,8),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(91,-23,8),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-86,23,13),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-86,-23,13),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(91,23,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(91,-23,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(21.6,14.4,21.3),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(91,23,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(91,-23,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(21.6,15.2,21.3),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-86,23,13),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-86,-23,13),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-86,23,9.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-86,0,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 90,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-86,-23,9.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-86,18,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-86,-18,11),
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
				pos = Vector(94,22,-3.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-81,34,11),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(21.6,17.4,21.3),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(94,-22,-3.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-81,-34,11),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(21.6,12.4,21.3),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[11] = '',
				[12] = '',
				[9] = '',
			},
			Brake = {
				[11] = '',
				[12] = 'models/gta4/vehicles/blista/blista_lights_on',
				[9] = '',
			},
			Reverse = {
				[11] = '',
				[12] = '',
				[9] = 'models/gta4/vehicles/blista/blista_lights_on',
			},
			Brake_Reverse = {
				[11] = '',
				[12] = 'models/gta4/vehicles/blista/blista_lights_on',
				[9] = 'models/gta4/vehicles/blista/blista_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[11] = 'models/gta4/vehicles/blista/blista_lights_on',
				[12] = '',
				[9] = '',
			},
			Brake = {
				[11] = 'models/gta4/vehicles/blista/blista_lights_on',
				[12] = 'models/gta4/vehicles/blista/blista_lights_on',
				[9] = '',
			},
			Reverse = {
				[11] = 'models/gta4/vehicles/blista/blista_lights_on',
				[12] = '',
				[9] = 'models/gta4/vehicles/blista/blista_lights_on',
			},
			Brake_Reverse = {
				[11] = 'models/gta4/vehicles/blista/blista_lights_on',
				[12] = 'models/gta4/vehicles/blista/blista_lights_on',
				[9] = 'models/gta4/vehicles/blista/blista_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[11] = 'models/gta4/vehicles/blista/blista_lights_on',
				[12] = '',
				[9] = '',
			},
			Brake = {
				[11] = 'models/gta4/vehicles/blista/blista_lights_on',
				[12] = 'models/gta4/vehicles/blista/blista_lights_on',
				[9] = '',
			},
			Reverse = {
				[11] = 'models/gta4/vehicles/blista/blista_lights_on',
				[12] = '',
				[9] = 'models/gta4/vehicles/blista/blista_lights_on',
			},
			Brake_Reverse = {
				[11] = 'models/gta4/vehicles/blista/blista_lights_on',
				[12] = 'models/gta4/vehicles/blista/blista_lights_on',
				[9] = 'models/gta4/vehicles/blista/blista_lights_on',
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/blista/blista_lights_on'
			},
			right = {
				[6] = 'models/gta4/vehicles/blista/blista_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_blista', light_table)