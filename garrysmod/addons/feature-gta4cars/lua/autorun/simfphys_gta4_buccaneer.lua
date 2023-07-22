local V = {
	Name = 'Buccaneer',
	Model = 'models/octoteam/vehicles/buccaneer.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Маслкары',
	SpawnOffset = Vector(0,0,15),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Маслкары',

	Members = {
		Mass = 1700.0,

		EnginePos = Vector(80,0,0),

		LightsTable = 'gta4_buccaneer',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(19,19,19)}
				-- CarCols[2] =  {REN.GTA4ColorTable(16,16,16)}
				-- CarCols[3] =  {REN.GTA4ColorTable(38,38,38)}
				-- CarCols[4] =  {REN.GTA4ColorTable(50,50,50)}
				-- CarCols[5] =  {REN.GTA4ColorTable(57,57,57)}
				-- CarCols[6] =  {REN.GTA4ColorTable(72,72,72)}
				-- CarCols[7] =  {REN.GTA4ColorTable(77,77,77)}
				-- CarCols[8] =  {REN.GTA4ColorTable(88,88,88)}
				-- CarCols[9] =  {REN.GTA4ColorTable(94,94,94)}
				-- CarCols[10] = {REN.GTA4ColorTable(97,97,97)}
				-- CarCols[11] = {REN.GTA4ColorTable(102,102,102)}
				-- CarCols[10] = {REN.GTA4ColorTable(16,16,76)}
				-- CarCols[13] = {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[14] = {REN.GTA4ColorTable(15,15,93)}
				-- CarCols[15] = {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[16] = {REN.GTA4ColorTable(13,13,80)}
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

		CustomWheelModel = 'models/octoteam/vehicles/buccaneer_wheel.mdl',

		CustomWheelPosFL = Vector(76,32,-16),
		CustomWheelPosFR = Vector(76,-32,-16),
		CustomWheelPosRL = Vector(-60,33,-16),
		CustomWheelPosRR = Vector(-60,-33,-16),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-11,-17,10),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(3,-17,-20),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-113,21.7,-21.4),
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

		MaxGrip = 72,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 20,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 140.0,
		PowerbandStart = 1700,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-62,35,14),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 80,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 0.9,
		snd_idle = 'octoteam/vehicles/merit_idle.wav',

		snd_low = 'octoteam/vehicles/merit_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/merit_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/merit_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/merit_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/merit_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/buccaneer_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.17,
		Gears = {-0.5,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_buccaneer', V )

local light_table = {
	L_HeadLampPos = Vector(114,27,-2),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(114,-27,-2),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-119,33.5,-9),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-119,-33.5,-9),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(114,27,-2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(114,-27,-2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(115,21,-2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(115,-21,-2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(18.9,25,6),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(114,27,-2),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(114,-27,-2),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(115,21,-2),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(115,-21,-2),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(19.1,25,6.8),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-119,33.5,-9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-119,-33.5,-9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-119,33.5,-10.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-119,-33.5,-10.5),
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
				pos = Vector(119,24,-12.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(107,36,-12.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,100,0,150),
			},

--[[			{
				pos = Vector(19.4,17.7,8.5),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeLeft = {
			{
				pos = Vector(-119,33.5,-5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
		Right = {
			{
				pos = Vector(119,-24,-12.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(107,-36,-12.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,100,0,150),
			},

--[[			{
				pos = Vector(19.4,17,8.5),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeRight = {
			{
				pos = Vector(-119,-33.5,-5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[3] = '',
				[10] = '',
				[4] = '',
			},
			Brake = {
				[3] = '',
				[10] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
				[4] = '',
			},
			Reverse = {
				[3] = '',
				[10] = '',
				[4] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
			},
			Brake_Reverse = {
				[3] = '',
				[10] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
				[4] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
				[10] = '',
				[4] = '',
			},
			Brake = {
				[3] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
				[10] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
				[4] = '',
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
				[10] = '',
				[4] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
				[10] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
				[4] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
				[10] = '',
				[4] = '',
			},
			Brake = {
				[3] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
				[10] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
				[4] = '',
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
				[10] = '',
				[4] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
				[10] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
				[4] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on',
			},
		},
		turnsignals = {
			left = {
				[11] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on'
			},
			right = {
				[7] = 'models/gta4/vehicles/buccaneer/buccaneer_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_buccaneer', light_table)