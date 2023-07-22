local V = {
	Name = 'Hakumai',
	Model = 'models/octoteam/vehicles/hakumai.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,0),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1300,
		Trunk = { 30 },

		EnginePos = Vector(60,0,10),

		LightsTable = 'gta4_hakumai',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1)..math.random(0,1)..math.random(0,1)..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(33,30,37)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,0,0)}
				-- CarCols[3] =  {REN.GTA4ColorTable(0,3,8)}
				-- CarCols[4] =  {REN.GTA4ColorTable(4,0,8)}
				-- CarCols[5] =  {REN.GTA4ColorTable(7,0,8)}
				-- CarCols[6] =  {REN.GTA4ColorTable(10,10,8)}
				-- CarCols[7] =  {REN.GTA4ColorTable(16,9,8)}
				-- CarCols[8] =  {REN.GTA4ColorTable(22,22,8)}
				-- CarCols[9] =  {REN.GTA4ColorTable(26,16,18)}
				-- CarCols[10] = {REN.GTA4ColorTable(31,0,1)}
				-- CarCols[11] = {REN.GTA4ColorTable(34,34,34)}
				-- CarCols[12] = {REN.GTA4ColorTable(54,1,54)}
				-- CarCols[13] = {REN.GTA4ColorTable(57,1,57)}
				-- CarCols[14] = {REN.GTA4ColorTable(61,11,61)}
				-- CarCols[15] = {REN.GTA4ColorTable(68,1,65)}
				-- CarCols[16] = {REN.GTA4ColorTable(72,6,1)}
				-- CarCols[17] = {REN.GTA4ColorTable(77,77,77)}
				-- CarCols[18] = {REN.GTA4ColorTable(108,1,109)}
				-- CarCols[19] = {REN.GTA4ColorTable(109,1,109)}
				-- CarCols[20] = {REN.GTA4ColorTable(114,111,111)}
				-- CarCols[21] = {REN.GTA4ColorTable(117,109,1)}
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

		CustomWheelModel = 'models/octoteam/vehicles/hakumai_wheel.mdl',

		CustomWheelPosFL = Vector(57,30,-6),
		CustomWheelPosFR = Vector(57,-30,-6),
		CustomWheelPosRL = Vector(-57,30,-6),
		CustomWheelPosRR = Vector(-57,-30,-6),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-10,-16,25),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(4,-17,-7),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-33,17,-7),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-33,-17,-7),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-100,23,-4),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-100,19.3,-4),
				ang = Angle(-90,0,0),
				OnBodyGroups = {
					[1] = {1},
				}
			},
		},

		FrontHeight = 8,
		FrontConstant = 27000,
		FrontDamping = 900,
		FrontRelativeDamping = 900,

		RearHeight = 8,
		RearConstant = 27000,
		RearDamping = 900,
		RearRelativeDamping = 900,

		FastSteeringAngle = 25,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 7,
		CounterSteeringMul = 0.85,

		MaxGrip = 30,
		Efficiency = 1.3,
		GripOffset = 2,
		BrakePower = 30,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 56,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-80,34,20),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 45,

		PowerBias = -1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/hakumai_idle.wav',

		snd_low = 'octoteam/vehicles/hakumai_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/hakumai_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/hakumai_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/hakumai_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/hakumai_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/hakumai_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.12,0.27,0.38,0.45,0.55},

		Dash = { pos = Vector(18.604, 16.2, 18.1), ang = Angle(-0.0, -90.0, 68.4) },
		Radio = { pos = Vector(24.598, 0.005, 13.223), ang = Angle(0.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(95.386, 0.001, -4.366), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-100.817, 0.001, 0.652), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(7.694, 0.001, 31.367),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(23.054, 37.744, 20.720),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(23.314, -37.920, 20.549),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_hakumai', V )

local light_table = {
	L_HeadLampPos = Vector(88,24,8),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(88,-24,8),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-100,24,14),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-100,-24,14),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(88,24,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},
		{
			pos = Vector(88,-24,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},

--[[		{
			pos = Vector(21,25,18),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(88,24,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(88,-24,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(21,24,18),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-100,24,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-100,-24,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-100,14,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-100,-14,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-99,19,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-99,-19,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
	},

	DelayOn = 0.2,
	DelayOff = 0,
	PoseParameters = {
		name = 'lights',
		min = 0,
		max = 1,
	},

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(93,30,2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-99,33,14),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,21,21),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(93,-30,2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-99,-33,14),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,20,21),
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
				[8] = '',
				[7] = '',
			},
			Brake = {
				[3] = '',
				[8] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
				[7] = '',
			},
			Reverse = {
				[3] = '',
				[8] = '',
				[7] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
			},
			Brake_Reverse = {
				[3] = '',
				[8] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
				[7] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
				[8] = '',
				[7] = '',
			},
			Brake = {
				[3] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
				[8] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
				[7] = '',
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
				[8] = '',
				[7] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
				[8] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
				[7] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
				[8] = '',
				[7] = '',
			},
			Brake = {
				[3] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
				[8] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
				[7] = '',
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
				[8] = '',
				[7] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
				[8] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
				[7] = 'models/gta4/vehicles/hakumai/hakumai_lights_on',
			},
		},
		turnsignals = {
			left = {
				[9] = 'models/gta4/vehicles/hakumai/hakumai_lights_on'
			},
			right = {
				[6] = 'models/gta4/vehicles/hakumai/hakumai_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_hakumai', light_table)