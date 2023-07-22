local V = {
	Name = 'Manana',
	Model = 'models/octoteam/vehicles/manana.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Маслкары',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Маслкары',

	Members = {
		Mass = 1500,
		Trunk = { 35 },

		EnginePos = Vector(60,0,0),

		LightsTable = 'gta4_manana',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,12)}
				-- CarCols[2] =  {REN.GTA4ColorTable(1,1,12)}
				-- CarCols[3] =  {REN.GTA4ColorTable(3,3,12)}
				-- CarCols[9] =  {REN.GTA4ColorTable(6,6,12)}
				-- CarCols[7] =  {REN.GTA4ColorTable(7,7,12)}
				-- CarCols[6] =  {REN.GTA4ColorTable(10,10,12)}
				-- CarCols[7] =  {REN.GTA4ColorTable(16,16,12)}
				-- CarCols[8] =  {REN.GTA4ColorTable(31,31,31)}
				-- CarCols[9] =  {REN.GTA4ColorTable(41,41,41)}
				-- CarCols[10] = {REN.GTA4ColorTable(57,57,57)}
				-- CarCols[11] = {REN.GTA4ColorTable(62,62,62)}
				-- CarCols[12] = {REN.GTA4ColorTable(67,67,67)}
				-- CarCols[13] = {REN.GTA4ColorTable(86,86,86)}
				-- CarCols[14] = {REN.GTA4ColorTable(88,88,88)}
				-- CarCols[15] = {REN.GTA4ColorTable(95,95,95)}
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

		CustomWheelModel = 'models/octoteam/vehicles/manana_wheel.mdl',

		CustomWheelPosFL = Vector(62,33,-10),
		CustomWheelPosFR = Vector(62,-33,-10),
		CustomWheelPosRL = Vector(-64,33,-10),
		CustomWheelPosRR = Vector(-64,-33,-10),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-25,-18,17),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-10,-18,-14),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-110,28,-11.5),
				ang = Angle(-120,0,0),
			},
			{
				pos = Vector(-110,-28,-11.5),
				ang = Angle(-120,0,0),
			},
		},

		FrontHeight = 6,
		FrontConstant = 27000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 6,
		RearConstant = 27000,
		RearDamping = 800,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3.5,

		MaxGrip = 45,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 25,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 40,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-78,36,13.5),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 40,

		AirFriction = -50,
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

		snd_horn = 'octoteam/vehicles/horns/manana_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(7.566, 18.065, 12.497), ang = Angle(-0.0, -90.0, 74.3) },
		Radio = { pos = Vector(13.549, -0.866, 8.229), ang = Angle(0.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(99.400, 0.001, -8.514), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-114.732, -0.006, 4.896), ang = Angle(-19.7, 180.0, -0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(3.439, -0.000, 26.633),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(17.101, 40.335, 15.533),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(17.554, -40.878, 16.050),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_manana', V )

local light_table = {
	L_HeadLampPos = Vector(92,32,5.5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(92,-32,5.5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-118,11,-3.5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-118,-11,-3.5),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(92,32,5.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(92,-32,5.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(92,24.5,5.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(92,-24.5,5.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(8,27.5,13.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(92,32,5.5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(92,-32,5.5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(92,24.5,5.5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(92,-24.5,5.5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(8,27.5,12.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-118,11,-3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-118,29,-3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-118,-11,-3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-118,-29,-3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-118,11,-3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-118,29,-3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-118,-11,-3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-118,-29,-3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-118,20,-3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-118,-20,-3.5),
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
				pos = Vector(87,37,2.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-113,38,1.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(8,19.2,14.5),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(87,-37,2.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-113,-38,1.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(8,18.5,14.5),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[9] = '',
				[8] = '',
				[10] = ''
			},
			Brake = {
				[9] = '',
				[8] = 'models/gta4/vehicles/manana/manana_lights_on',
				[10] = ''
			},
			Reverse = {
				[9] = '',
				[8] = '',
				[10] = 'models/gta4/vehicles/manana/manana_lights_on'
			},
			Brake_Reverse = {
				[9] = '',
				[8] = 'models/gta4/vehicles/manana/manana_lights_on',
				[10] = 'models/gta4/vehicles/manana/manana_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/manana/manana_lights_on',
				[8] = 'models/gta4/vehicles/manana/manana_lights_on',
				[10] = ''
			},
			Brake = {
				[9] = 'models/gta4/vehicles/manana/manana_lights_on',
				[8] = 'models/gta4/vehicles/manana/manana_lights_on',
				[10] = ''
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/manana/manana_lights_on',
				[8] = 'models/gta4/vehicles/manana/manana_lights_on',
				[10] = 'models/gta4/vehicles/manana/manana_lights_on'
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/manana/manana_lights_on',
				[8] = 'models/gta4/vehicles/manana/manana_lights_on',
				[10] = 'models/gta4/vehicles/manana/manana_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/manana/manana_lights_on',
				[8] = 'models/gta4/vehicles/manana/manana_lights_on',
				[10] = ''
			},
			Brake = {
				[9] = 'models/gta4/vehicles/manana/manana_lights_on',
				[8] = 'models/gta4/vehicles/manana/manana_lights_on',
				[10] = ''
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/manana/manana_lights_on',
				[8] = 'models/gta4/vehicles/manana/manana_lights_on',
				[10] = 'models/gta4/vehicles/manana/manana_lights_on'
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/manana/manana_lights_on',
				[8] = 'models/gta4/vehicles/manana/manana_lights_on',
				[10] = 'models/gta4/vehicles/manana/manana_lights_on'
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/manana/manana_lights_on'
			},
			right = {
				[5] = 'models/gta4/vehicles/manana/manana_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_manana', light_table)