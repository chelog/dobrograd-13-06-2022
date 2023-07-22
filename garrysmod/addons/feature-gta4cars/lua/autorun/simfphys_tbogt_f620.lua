local V = {
	Name = 'F620',
	Model = 'models/octoteam/vehicles/f620.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Спортивные',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Спортивные',

	Members = {
		Mass = 1700.0,

		EnginePos = Vector(60,0,0),

		LightsTable = 'gta4_f620',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(31,31,89)}
				-- CarCols[2] =  {REN.GTA4ColorTable(7,7,8)}
				-- CarCols[3] =  {REN.GTA4ColorTable(0,0,7)}
				-- CarCols[4] =  {REN.GTA4ColorTable(24,24,4)}
				-- CarCols[5] =  {REN.GTA4ColorTable(52,52,50)}
				-- CarCols[6] =  {REN.GTA4ColorTable(69,69,65)}
				-- CarCols[7] =  {REN.GTA4ColorTable(74,74,72)}
				-- CarCols[8] =  {REN.GTA4ColorTable(85,85,82)}
				-- CarCols[9] =  {REN.GTA4ColorTable(113,113,133)}
				-- CarCols[10] = {REN.GTA4ColorTable(89,89,113)}
				-- CarCols[11] = {REN.GTA4ColorTable(83,83,113)}
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

		CustomWheelModel = 'models/octoteam/vehicles/f620_wheel.mdl',

		CustomWheelPosFL = Vector(58,33,-11),
		CustomWheelPosFR = Vector(58,-33,-11),
		CustomWheelPosRL = Vector(-58,33,-11),
		CustomWheelPosRR = Vector(-58,-33,-11),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-15,-18,13),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-3,-18,-18),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-93,16,-10),
				ang = Angle(-100,0,0),
			},
			{
				pos = Vector(-93,-16,-10),
				ang = Angle(-100,0,0),
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

		MaxGrip = 102,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 30,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 4500,
		PeakTorque = 155.0,
		PowerbandStart = 1500,
		PowerbandEnd = 4000,
		Turbocharged = false,
		Supercharged = true,
		DoNotStall = false,

		FuelFillPos = Vector(-66,-36,15),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 70,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/infernus_idle.wav',

		snd_low = 'octoteam/vehicles/infernus_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/infernus_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/infernus_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/infernus_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/infernus_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/infernus_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.23,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1,1.25}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tbogt_f620', V )

local light_table = {
	L_HeadLampPos = Vector(77,34,3),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(77,-34,3),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-91,28,9),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-91,-28,9),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(77,34,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,100),
		},
		{
			pos = Vector(77,-34,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,100),
		},
		{
			pos = Vector(80,27.5,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,100),
		},
		{
			pos = Vector(80,-27.5,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,100),
		},

--[[		{
			pos = Vector(19.7,16.9,11.3),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(77,34,3),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(77,-34,3),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(80,27.5,3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(80,-27.5,3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(19.7,16.1,12),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(89,25,-10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(89,-25,-10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-91,28,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-91,-28,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-93,18,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-93,-18,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-93,19,13),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-93,-19,13),
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
				pos = Vector(86,24,0.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-91,27,12.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(20,20,13),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(86,-24,0.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-91,-27,12.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(20,16,13),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[4] = '',
				[8] = '',
				[12] = ''
			},
			Brake = {
				[4] = '',
				[8] = 'models/gta4/vehicles/f620/f620_on',
				[12] = ''
			},
			Reverse = {
				[4] = '',
				[8] = '',
				[12] = 'models/gta4/vehicles/f620/f620_on'
			},
			Brake_Reverse = {
				[4] = '',
				[8] = 'models/gta4/vehicles/f620/f620_on',
				[12] = 'models/gta4/vehicles/f620/f620_on'
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/f620/f620_on',
				[8] = '',
				[12] = ''
			},
			Brake = {
				[4] = 'models/gta4/vehicles/f620/f620_on',
				[8] = 'models/gta4/vehicles/f620/f620_on',
				[12] = ''
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/f620/f620_on',
				[8] = '',
				[12] = 'models/gta4/vehicles/f620/f620_on'
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/f620/f620_on',
				[8] = 'models/gta4/vehicles/f620/f620_on',
				[12] = 'models/gta4/vehicles/f620/f620_on'
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/f620/f620_on',
				[8] = '',
				[12] = ''
			},
			Brake = {
				[4] = 'models/gta4/vehicles/f620/f620_on',
				[8] = 'models/gta4/vehicles/f620/f620_on',
				[12] = ''
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/f620/f620_on',
				[8] = '',
				[12] = 'models/gta4/vehicles/f620/f620_on'
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/f620/f620_on',
				[8] = 'models/gta4/vehicles/f620/f620_on',
				[12] = 'models/gta4/vehicles/f620/f620_on'
			},
		},
		turnsignals = {
			left = {
				[9] = 'models/gta4/vehicles/f620/f620_on'
			},
			right = {
				[13] = 'models/gta4/vehicles/f620/f620_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_f620', light_table)