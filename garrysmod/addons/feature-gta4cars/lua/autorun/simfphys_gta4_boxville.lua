local V = {
	Name = 'Boxville',
	Model = 'models/octoteam/vehicles/boxville.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Индустриальные',
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Индустриальные',

	Members = {
		Mass = 3000.0,

		EnginePos = Vector(80,0,0),

		LightsTable = 'gta4_boxville',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,8))
			-- ent:SetBodyGroups('0'..math.random(0,2)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(113,1,112)}
				-- CarCols[2] = {REN.GTA4ColorTable(113,28,112)}
				-- CarCols[3] = {REN.GTA4ColorTable(113,31,112)}
				-- CarCols[4] = {REN.GTA4ColorTable(113,50,112)}
				-- CarCols[5] = {REN.GTA4ColorTable(113,58,112)}
				-- CarCols[6] = {REN.GTA4ColorTable(92,64,112)}
				-- CarCols[7] = {REN.GTA4ColorTable(92,85,112)}
				-- CarCols[8] = {REN.GTA4ColorTable(93,112,112)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 1, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/ambulance_wheel.mdl',

		CustomWheelPosFL = Vector(66,35,-25),
		CustomWheelPosFR = Vector(66,-35,-25),
		CustomWheelPosRL = Vector(-84,35,-25),
		CustomWheelPosRR = Vector(-84,-35,-25),
		CustomWheelAngleOffset = Angle(0,-90,0),

		FrontWheelRadius = 16.3,
		RearWheelRadius = 16.3,

		CustomMassCenter = Vector(0,0,20),

		CustomSteerAngle = 30,

		SeatOffset = Vector(15,-22,32),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(20,-25,-2),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-142,-32.1,-29.8),
				ang = Angle(-135,35,0),
			},
		},

		FrontHeight = 10,
		FrontConstant = 35000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 10,
		RearConstant = 35000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 70,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 20,
		BulletProofTires = false,

		IdleRPM = 700,
		LimitRPM = 4500,
		PeakTorque = 110.0,
		PowerbandStart = 1500,
		PowerbandEnd = 4000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-55,44,-12),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 90,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1.1,
		snd_idle = 'octoteam/vehicles/ambulance_idle.wav',

		snd_low = 'octoteam/vehicles/ambulance_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/ambulance_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/ambulance_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/ambulance_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/ambulance_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/boxville_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/DUMP_VALVE.wav',

		DifferentialGear = 0.14,
		Gears = {-0.3,0,0.15,0.35,0.5,0.75,1},

		Dash = { pos = Vector(45.649, 21.990, 22.681), ang = Angle(-0.0, -90.0, 66) },
		Radio = { pos = Vector(59.870, 0.0, 12.648), ang = Angle(0.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(103.603, 0, -18.330), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-145.821, 0, -17.810), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			left = {
				pos = Vector(41.004, 49.253, 38.247),
				h = 3 / 4,
				ratio = 1 / 3,
			},
			right = {
				pos = Vector(41.004, -49.253, 38.247),
				h = 3 / 4,
				ratio = 1 / 3,
			},
		},

		CanAttachPackages = true,
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_boxville', V )

local light_table = {
	L_HeadLampPos = Vector(99,33.5,-1.7),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(99,-33.5,-1.7),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-149,34,-17),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-149,-34,-17),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(99,33.5,-1.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(99,-33.5,-1.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(46,20,23),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(99,33.5,-1.7),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(99,-33.5,-1.7),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(45,20,22),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(99,36.3,-9.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,255),
		},
		{
			pos = Vector(99,-36.3,-9.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-149,34,-17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-149,-34,-17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-149,26.5,-17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-149,-26.5,-17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-149,34.2,-7.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-149,-34.2,-7.7),
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
				pos = Vector(95,42,-2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
--[[			{
				pos = Vector(46,29,24),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(95,-42,-2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
--[[			{
				pos = Vector(46,28,24),
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
				[7] = '',
				[11] = ''
			},
			Brake = {
				[3] = '',
				[7] = 'models/gta4/vehicles/boxville/boxville_lights_on',
				[11] = ''
			},
			Reverse = {
				[3] = '',
				[7] = '',
				[11] = 'models/gta4/vehicles/boxville/boxville_lights_on'
			},
			Brake_Reverse = {
				[3] = '',
				[7] = 'models/gta4/vehicles/boxville/boxville_lights_on',
				[11] = 'models/gta4/vehicles/boxville/boxville_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/boxville/boxville_lights_on',
				[7] = '',
				[11] = ''
			},
			Brake = {
				[3] = 'models/gta4/vehicles/boxville/boxville_lights_on',
				[7] = 'models/gta4/vehicles/boxville/boxville_lights_on',
				[11] = ''
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/boxville/boxville_lights_on',
				[7] = '',
				[11] = 'models/gta4/vehicles/boxville/boxville_lights_on'
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/boxville/boxville_lights_on',
				[7] = 'models/gta4/vehicles/boxville/boxville_lights_on',
				[11] = 'models/gta4/vehicles/boxville/boxville_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/boxville/boxville_lights_on',
				[7] = '',
				[11] = ''
			},
			Brake = {
				[3] = 'models/gta4/vehicles/boxville/boxville_lights_on',
				[7] = 'models/gta4/vehicles/boxville/boxville_lights_on',
				[11] = ''
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/boxville/boxville_lights_on',
				[7] = '',
				[11] = 'models/gta4/vehicles/boxville/boxville_lights_on'
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/boxville/boxville_lights_on',
				[7] = 'models/gta4/vehicles/boxville/boxville_lights_on',
				[11] = 'models/gta4/vehicles/boxville/boxville_lights_on'
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/boxville/boxville_lights_on'
			},
			right = {
				[12] = 'models/gta4/vehicles/boxville/boxville_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_boxville', light_table)
