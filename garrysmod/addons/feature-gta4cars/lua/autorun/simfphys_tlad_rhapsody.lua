local V = {
	Name = 'Rhapsody',
	Model = 'models/octoteam/vehicles/rhapsody.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Хетчбеки',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Хетчбеки',

	Members = {
		Mass = 1250,
		Trunk = { 40 },

		EnginePos = Vector(55,0,10),

		LightsTable = 'gta4_rhapsody',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,33)}
				-- CarCols[2] =  {REN.GTA4ColorTable(7,7,8)}
				-- CarCols[3] =  {REN.GTA4ColorTable(10,10,8)}
				-- CarCols[4] =  {REN.GTA4ColorTable(23,23,8)}
				-- CarCols[5] =  {REN.GTA4ColorTable(57,57,56)}
				-- CarCols[6] =  {REN.GTA4ColorTable(62,62,62)}
				-- CarCols[7] =  {REN.GTA4ColorTable(66,66,66)}
				-- CarCols[8] =  {REN.GTA4ColorTable(72,72,72)}
				-- CarCols[9] =  {REN.GTA4ColorTable(78,78,78)}
				-- CarCols[10] = {REN.GTA4ColorTable(95,95,95)}
				-- CarCols[11] = {REN.GTA4ColorTable(104,104,104)}
				-- CarCols[12] = {REN.GTA4ColorTable(107,107,107)}
				-- CarCols[13] = {REN.GTA4ColorTable(2,2,63)}
				-- CarCols[14] = {REN.GTA4ColorTable(21,21,72)}
				-- CarCols[15] = {REN.GTA4ColorTable(22,22,72)}
				-- CarCols[16] = {REN.GTA4ColorTable(13,11,91)}
				-- CarCols[17] = {REN.GTA4ColorTable(19,19,93)}
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

		CustomWheelModel = 'models/octoteam/vehicles/rhapsody_wheel.mdl',

		CustomWheelPosFL = Vector(54,32,1),
		CustomWheelPosFR = Vector(54,-32,1),
		CustomWheelPosRL = Vector(-53,32,1),
		CustomWheelPosRR = Vector(-53,-32,1),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0.02,-2.4),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-15,-17,27),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-1,-17,-5),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-84,-19,-0.5),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 10,
		FrontConstant = 22000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 10,
		RearConstant = 22000,
		RearDamping = 800,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3.5,
		CounterSteeringMul = 0.8,

		MaxGrip = 45,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 25,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 45,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-54,-36.5,19),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 35,

		AirFriction = -50,
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

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(15.752, 17.290, 21.695), ang = Angle(-0.0, -90.0, 82.0) },
		Radio = { pos = Vector(20.884, -0.310, 17.569), ang = Angle(13.0, 180.0, -0.0) },
		Plates = {
			Front = { pos = Vector(84.035, 0.005, 2.049), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-90.521, 0.000, 3.615), ang = Angle(3.3, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(5.641, 0.001, 39.931),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(13.081, 37.777, 24.480),
				w = 1 / 6,
				ratio = 1,
			},
			right = {
				pos = Vector(12.839, -37.898, 24.809),
				w = 1 / 6,
				ratio = 1,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tlad_rhapsody', V )

local light_table = {
	L_HeadLampPos = Vector(80,28,11),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(80,-28,11),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-86,18.5,14),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-86,-18.5,14),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(80,28,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(80,-28,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
	},

	Headlamp_sprites = {
		{pos = Vector(80,28,11),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(80,-28,11),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
	},

	Rearlight_sprites = {
		{
			pos = Vector(-86,18.5,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-86,-18.5,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-86,18.5,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-86,-18.5,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-86,23.5,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-86,-23.5,14),
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
				pos = Vector(78,25,0),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-83,29.5,14),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},
		},
		Right = {
			{
				pos = Vector(78,-25,0),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-83,-29.5,14),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[14] = '',
				[8] = '',
				[13] = '',
			},
			Brake = {
				[14] = '',
				[8] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[13] = '',
			},
			Reverse = {
				[14] = '',
				[8] = '',
				[13] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
			},
			Brake_Reverse = {
				[14] = '',
				[8] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[13] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[14] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[8] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[13] = '',
			},
			Brake = {
				[14] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[8] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[13] = '',
			},
			Reverse = {
				[14] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[8] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[13] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
			},
			Brake_Reverse = {
				[14] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[8] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[13] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[14] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[8] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[13] = '',
			},
			Brake = {
				[14] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[8] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[13] = '',
			},
			Reverse = {
				[14] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[8] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[13] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
			},
			Brake_Reverse = {
				[14] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[8] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
				[13] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on',
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/rhapsody/rhapsody_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_rhapsody', light_table)