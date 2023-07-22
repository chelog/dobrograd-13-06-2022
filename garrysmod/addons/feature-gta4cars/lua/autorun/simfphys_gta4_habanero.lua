local V = {
	Name = 'Habanero',
	Model = 'models/octoteam/vehicles/habanero.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 1650,
		Trunk = { 50 },

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_habanero',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,56)}
				-- CarCols[2] =  {REN.GTA4ColorTable(1,1,11)}
				-- CarCols[3] =  {REN.GTA4ColorTable(3,3,11)}
				-- CarCols[4] =  {REN.GTA4ColorTable(14,14,11)}
				-- CarCols[5] =  {REN.GTA4ColorTable(19,19,14)}
				-- CarCols[6] =  {REN.GTA4ColorTable(42,42,30)}
				-- CarCols[7] =  {REN.GTA4ColorTable(45,45,27)}
				-- CarCols[8] =  {REN.GTA4ColorTable(57,57,126)}
				-- CarCols[9] =  {REN.GTA4ColorTable(54,54,50)}
				-- CarCols[10] = {REN.GTA4ColorTable(52,52,83)}
				-- CarCols[11] = {REN.GTA4ColorTable(70,70,80)}
				-- CarCols[12] = {REN.GTA4ColorTable(82,82,63)}
				-- CarCols[13] = {REN.GTA4ColorTable(85,85,63)}
				-- CarCols[14] = {REN.GTA4ColorTable(90,90,91)}
				-- CarCols[15] = {REN.GTA4ColorTable(94,94,94)}
				-- CarCols[16] = {REN.GTA4ColorTable(104,104,106)}
				-- CarCols[17] = {REN.GTA4ColorTable(16,16,76)}
				-- CarCols[18] = {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[19] = {REN.GTA4ColorTable(15,15,93)}
				-- CarCols[20] = {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[21] = {REN.GTA4ColorTable(13,13,80)}
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

		CustomWheelModel = 'models/octoteam/vehicles/habanero_wheel.mdl',

		CustomWheelPosFL = Vector(57,33,-14),
		CustomWheelPosFR = Vector(57,-33,-14),
		CustomWheelPosRL = Vector(-57,33,-14),
		CustomWheelPosRR = Vector(-57,-33,-14),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,3),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-5,-17,20),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(5,-17,-15),
				ang = Angle(0,-90,10),
				hasRadio = true
			},
			{
				pos = Vector(-31,17,-15),
				ang = Angle(0,-90,10),
			},
			{
				pos = Vector(-31,-17,-15),
				ang = Angle(0,-90,10),
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-98,20,-13.5),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-98,-20,-13.5),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 9,
		FrontConstant = 34000,
		FrontDamping = 950,
		FrontRelativeDamping = 950,

		RearHeight = 9,
		RearConstant = 34000,
		RearDamping = 950,
		RearRelativeDamping = 950,

		TurnSpeed = 4,

		FastSteeringAngle = 15,
		SteeringFadeFastSpeed = 550,

		MaxGrip = 50,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 35,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 42,
		PowerbandStart = 1200,
		PowerbandEnd = 5800,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 1.35,

		FuelFillPos = Vector(-67,-36,14),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		AirFriction = -50,
		PowerBias = 0,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/perennial_idle.wav',

		snd_low = 'octoteam/vehicles/perennial_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/perennial_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/perennial_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/perennial_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/perennial_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/habanero_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(24.810, 16.475, 12.440), ang = Angle(-0.0, -90.0, 86.7) },
		Radio = { pos = Vector(28.662, 0.298, 11.801), ang = Angle(-6.7, 162.5, 2.4) },
		Plates = {
			Front = { pos = Vector(98.436, -0.002, -9.954), ang = Angle(4.6, 0.0, 0.0) },
			Back = { pos = Vector(-103.151, 0.001, -6.594), ang = Angle(-5.1, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(16.800, -0.011, 30.482),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(29.526, 35.754, 19.851),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(30.102, -35.873, 19.718),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_habanero', V )

local light_table = {
	L_HeadLampPos = Vector(84,29,2),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(84,-29,2),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-93,22,17),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-93,-22,17),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(84,29,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(84,-29,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(26.4,17,10.8),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(76,240,255,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(88,24,2),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(88,-24,2),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(26.4,16,10.8),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(76,240,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(101,25,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(101,-25,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-93,22,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-93,-22,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-87,31,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-87,-31,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-94,22,13.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-94,-22,13.5),
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
				pos = Vector(89,27,-2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,255,255,150),
			},
			{
				pos = Vector(-89,32,13.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(26.7,18.8,13.4),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(89,-27,-2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,255,255,150),
			},
			{
				pos = Vector(-89,-32,13.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(26.7,14.3,13.4),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[8] = '',
				[7] = '',
				[10] = '',
				[12] = ''
			},
			Brake = {
				[8] = '',
				[7] = '',
				[10] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[12] = ''
			},
			Reverse = {
				[8] = '',
				[7] = '',
				[10] = '',
				[12] = 'models/gta4/vehicles/habanero/habanero_lights_on'
			},
			Brake_Reverse = {
				[8] = '',
				[7] = '',
				[10] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[12] = 'models/gta4/vehicles/habanero/habanero_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[7] = '',
				[10] = '',
				[12] = ''
			},
			Brake = {
				[8] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[7] = '',
				[10] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[12] = ''
			},
			Reverse = {
				[8] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[7] = '',
				[10] = '',
				[12] = 'models/gta4/vehicles/habanero/habanero_lights_on'
			},
			Brake_Reverse = {
				[8] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[7] = '',
				[10] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[12] = 'models/gta4/vehicles/habanero/habanero_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[7] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[10] = '',
				[12] = ''
			},
			Brake = {
				[8] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[7] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[10] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[12] = ''
			},
			Reverse = {
				[8] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[7] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[10] = '',
				[12] = 'models/gta4/vehicles/habanero/habanero_lights_on'
			},
			Brake_Reverse = {
				[8] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[7] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[10] = 'models/gta4/vehicles/habanero/habanero_lights_on',
				[12] = 'models/gta4/vehicles/habanero/habanero_lights_on'
			},
		},
		turnsignals = {
			left = {
				[11] = 'models/gta4/vehicles/habanero/habanero_lights_on'
			},
			right = {
				[6] = 'models/gta4/vehicles/habanero/habanero_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_habanero', light_table)