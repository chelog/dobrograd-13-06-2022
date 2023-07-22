local V = {
	Name = 'Roman\'s Taxi',
	Model = 'models/octoteam/vehicles/rom.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1700.0,

		EnginePos = Vector(70,0,5),

		LightsTable = 'gta4_rom',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,104,8)}
				-- CarCols[2] =  {REN.GTA4ColorTable(26,26,8)}
				-- CarCols[3] =  {REN.GTA4ColorTable(34,34,33)}
				-- CarCols[9] =  {REN.GTA4ColorTable(19,19,12)}
				-- CarCols[7] =  {REN.GTA4ColorTable(21,21,12)}
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

		CustomWheelModel = 'models/octoteam/vehicles/esperanto_wheel.mdl',

		CustomWheelPosFL = Vector(60,33,-10),
		CustomWheelPosFR = Vector(60,-33,-10),
		CustomWheelPosRL = Vector(-60,33,-10),
		CustomWheelPosRR = Vector(-60,-33,-10),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-8,-18,20),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(4,-18,-12),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-36,18,-12),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-36,-18,-12),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-100,28.5,-11.7),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-100,-28.5,-11.7),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 12,
		FrontConstant = 20000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 12,
		RearConstant = 20000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3,

		MaxGrip = 81,
		Efficiency = 0.6,
		GripOffset = 0,
		BrakePower = 20,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 140.0,
		PowerbandStart = 1800,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-80,36,10),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 80,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/esperanto_idle.wav',

		snd_low = 'octoteam/vehicles/esperanto_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/esperanto_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/esperanto_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/esperanto_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/esperanto_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/patriot_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.14,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_rom', V )

local light_table = {
	L_HeadLampPos = Vector(93,26,5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(93,-26,5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-101,33,4),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-101,-33,4),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(93,26,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(93,-26,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(94,18,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(94,-18,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(23,18,15),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(94,18,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(94,-18,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(93,26,5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(93,-26,5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(23,18,14.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-101,33,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-101,-33,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-101,13,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-101,-13,4),
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
				pos = Vector(94,18,0),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,19,15),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeLeft = {
			{
				pos = Vector(-101,21,4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
		Right = {
			{
				pos = Vector(94,-18,0),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,17,15),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeRight = {
			{
				pos = Vector(-101,-21,4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[9] = '',
				[7] = '',
				[10] = ''
			},
			Brake = {
				[9] = '',
				[7] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[10] = ''
			},
			Reverse = {
				[9] = '',
				[7] = '',
				[10] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
			Brake_Reverse = {
				[9] = '',
				[7] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[10] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = '',
				[10] = ''
			},
			Brake = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[10] = ''
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = '',
				[10] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[10] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = '',
				[10] = ''
			},
			Brake = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[10] = ''
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = '',
				[10] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[7] = 'models/gta4/vehicles/esperanto/esperanto_lights_on',
				[10] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
			right = {
				[13] = 'models/gta4/vehicles/esperanto/esperanto_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_rom', light_table)