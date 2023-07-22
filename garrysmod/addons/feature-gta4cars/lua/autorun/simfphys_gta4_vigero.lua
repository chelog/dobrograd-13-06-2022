local V = {
	Name = 'Vigero',
	Model = 'models/octoteam/vehicles/vigero.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Маслкары',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Маслкары',

	Members = {
		Mass = 1450,
		Trunk = { 30 },

		EnginePos = Vector(60,0,0),

		LightsTable = 'gta4_vigero',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(9,9,1)}
				-- CarCols[2] =  {REN.GTA4ColorTable(13,13,1)}
				-- CarCols[3] =  {REN.GTA4ColorTable(17,17,1)}
				-- CarCols[4] =  {REN.GTA4ColorTable(25,25,1)}
				-- CarCols[5] =  {REN.GTA4ColorTable(30,30,1)}
				-- CarCols[6] =  {REN.GTA4ColorTable(37,37,1)}
				-- CarCols[7] =  {REN.GTA4ColorTable(40,40,1)}
				-- CarCols[8] =  {REN.GTA4ColorTable(54,54,1)}
				-- CarCols[9] =  {REN.GTA4ColorTable(57,57,1)}
				-- CarCols[10] = {REN.GTA4ColorTable(65,65,1)}
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

		CustomWheelModel = 'models/octoteam/vehicles/vigero_wheel.mdl',

		CustomWheelPosFL = Vector(60,32,-16),
		CustomWheelPosFR = Vector(60,-32,-16),
		CustomWheelPosRL = Vector(-60,32,-16),
		CustomWheelPosRR = Vector(-60,-32,-16),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-18,-17,12),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-5,-17,-20),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-96,15,-17),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-96,-15,-17),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 8,
		FrontConstant = 26000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 8,
		RearConstant = 26000,
		RearDamping = 800,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 4,

		MaxGrip = 35,
		Efficiency = 0.9,
		GripOffset = 0,
		BrakePower = 28,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 7000,
		PeakTorque = 44,
		PowerbandStart = 1200,
		PowerbandEnd = 6800,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-68,37,3),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 45,

		AirFriction = -50,
		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/vigero_idle.wav',

		snd_low = 'octoteam/vehicles/vigero_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/vigero_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/vigero_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/vigero_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/vigero_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/vigero_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.35,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(13.282, 16.775, 4.307), ang = Angle(0.0, -90.0, 68.9) },
		Radio = { pos = Vector(18.391, 0.957, 1.129), ang = Angle(-17.8, -180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(89.608, -0.016, -15.341), ang = Angle(6.3, 0.0, -0.0) },
			Back = { pos = Vector(-98.307, 0.000, -9.121), ang = Angle(-0.8, 180.0, -0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(7.009, 0.477, 19.400),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(46.534, 31.608, 11.712),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(46.149, -32.543, 12.628),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_vigero', V )

local light_table = {
	L_HeadLampPos = Vector(90,28,-4),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(90,-28,-4),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-99,26,4),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-99,-26,4),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(90,28,-4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(90,-28,-4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(13.8,16.8,5.4),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(90,20,-4),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(90,-20,-4),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(13.8,16.2,5.4),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-99,26,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-99,-26,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-99,26,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-99,-26,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-99,27,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-99,-27,0),
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
				pos = Vector(-99,32,0),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(13.8,17.5,5.4),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(-99,-32,0),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(13.8,15.5,5.4),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[12] = '',
				[11] = '',
				[8] = '',
				[4] = '',
			},
			Brake = {
				[12] = '',
				[11] = '',
				[8] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = '',
			},
			Reverse = {
				[12] = '',
				[11] = '',
				[8] = '',
				[4] = 'models/gta4/vehicles/vigero/vigero_lights_on',
			},
			Brake_Reverse = {
				[12] = '',
				[11] = '',
				[8] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = 'models/gta4/vehicles/vigero/vigero_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[12] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[11] = '',
				[8] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = '',
			},
			Brake = {
				[12] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[11] = '',
				[8] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = '',
			},
			Reverse = {
				[12] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[11] = '',
				[8] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = 'models/gta4/vehicles/vigero/vigero_lights_on',
			},
			Brake_Reverse = {
				[12] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[11] = '',
				[8] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = 'models/gta4/vehicles/vigero/vigero_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[12] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[11] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[8] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = '',
			},
			Brake = {
				[12] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[11] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[8] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = '',
			},
			Reverse = {
				[12] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[11] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[8] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = 'models/gta4/vehicles/vigero/vigero_lights_on',
			},
			Brake_Reverse = {
				[12] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[11] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[8] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = 'models/gta4/vehicles/vigero/vigero_lights_on',
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/vigero/vigero_lights_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/vigero/vigero_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_vigero', light_table)