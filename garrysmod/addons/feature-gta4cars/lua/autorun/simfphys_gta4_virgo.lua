local V = {
	Name = 'Virgo',
	Model = 'models/octoteam/vehicles/virgo.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Маслкары',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Маслкары',

	Members = {
		Mass = 1600.0,

		EnginePos = Vector(60,0,20),

		LightsTable = 'gta4_virgo',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(4,4,1)}
				-- CarCols[2] =  {REN.GTA4ColorTable(9,9,1)}
				-- CarCols[3] =  {REN.GTA4ColorTable(16,16,1)}
				-- CarCols[4] =  {REN.GTA4ColorTable(19,19,1)}
				-- CarCols[5] =  {REN.GTA4ColorTable(28,28,1)}
				-- CarCols[6] =  {REN.GTA4ColorTable(30,30,1)}
				-- CarCols[7] =  {REN.GTA4ColorTable(37,37,1)}
				-- CarCols[8] =  {REN.GTA4ColorTable(36,36,1)}
				-- CarCols[9] =  {REN.GTA4ColorTable(46,46,1)}
				-- CarCols[10] = {REN.GTA4ColorTable(54,54,1)}
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

		CustomWheelModel = 'models/octoteam/vehicles/virgo_wheel.mdl',

		CustomWheelPosFL = Vector(56,32,1),
		CustomWheelPosFR = Vector(56,-32,1),
		CustomWheelPosRL = Vector(-61,32,1),
		CustomWheelPosRR = Vector(-61,-32,1),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-20,-17,28),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-7,-17,0),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-108,-28,-1),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 10,
		FrontConstant = 22500,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 10,
		RearConstant = 22500,
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
		PeakTorque = 125.0,
		PowerbandStart = 1700,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-78,-37,23),
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

		DifferentialGear = 0.14,
		Gears = {-0.5,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_virgo', V )

local light_table = {
	L_HeadLampPos = Vector(90,28,14),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(90,-28,14),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-108,21,16),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-108,-21,16),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(90,28,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(90,-28,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(90,19,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(90,-19,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(14,26,25),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(90,28,14),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(90,-28,14),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(90,19,14),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(90,-19,14),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(14,26,24),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-108,21,16),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-108,-21,16),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-108,8,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-108,-8,14),
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
				pos = Vector(95,35,13),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(14,18.2,25),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeLeft = {
			{
				pos = Vector(-108,21,14),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
		Right = {
			{
				pos = Vector(95,-35,13),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(14,17.5,25),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeRight = {
			{
				pos = Vector(-108,-21,14),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[4] = '',
				[10] = '',
				[12] = '',
			},
			Brake = {
				[4] = '',
				[10] = 'models/gta4/vehicles/virgo/virgo_lights_on',
				[12] = '',
			},
			Reverse = {
				[4] = '',
				[10] = '',
				[12] = 'models/gta4/vehicles/virgo/virgo_lights_on',
			},
			Brake_Reverse = {
				[4] = '',
				[10] = 'models/gta4/vehicles/virgo/virgo_lights_on',
				[12] = 'models/gta4/vehicles/virgo/virgo_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/virgo/virgo_lights_on',
				[10] = '',
				[12] = '',
			},
			Brake = {
				[4] = 'models/gta4/vehicles/virgo/virgo_lights_on',
				[10] = 'models/gta4/vehicles/virgo/virgo_lights_on',
				[12] = '',
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/virgo/virgo_lights_on',
				[10] = '',
				[12] = 'models/gta4/vehicles/virgo/virgo_lights_on',
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/virgo/virgo_lights_on',
				[10] = 'models/gta4/vehicles/virgo/virgo_lights_on',
				[12] = 'models/gta4/vehicles/virgo/virgo_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/virgo/virgo_lights_on',
				[10] = '',
				[12] = '',
			},
			Brake = {
				[4] = 'models/gta4/vehicles/virgo/virgo_lights_on',
				[10] = 'models/gta4/vehicles/virgo/virgo_lights_on',
				[12] = '',
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/virgo/virgo_lights_on',
				[10] = '',
				[12] = 'models/gta4/vehicles/virgo/virgo_lights_on',
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/virgo/virgo_lights_on',
				[10] = 'models/gta4/vehicles/virgo/virgo_lights_on',
				[12] = 'models/gta4/vehicles/virgo/virgo_lights_on',
			},
		},
		turnsignals = {
			left = {
				[13] = 'models/gta4/vehicles/virgo/virgo_lights_on'
			},
			right = {
				[5] = 'models/gta4/vehicles/virgo/virgo_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_virgo', light_table)