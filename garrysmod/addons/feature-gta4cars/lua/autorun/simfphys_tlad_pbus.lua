local V = {
	Name = 'Prison Bus',
	Model = 'models/octoteam/vehicles/pbus.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Службы',
	SpawnOffset = Vector(0,0,40),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Службы',

	Members = {
		Mass = 7500.0,

		EnginePos = Vector(110,0,0),

		LightsTable = 'gta4_pbus',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(65,66,65)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 1, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 1, 1, 3) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		IsArmored = true,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/pbus_wheel.mdl',

		CustomWheelPosFL = Vector(97,43,-32),
		CustomWheelPosFR = Vector(97,-43,-32),
		CustomWheelPosRL = Vector(-97,43,-32),
		CustomWheelPosRR = Vector(-97,-43,-32),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,25),

		CustomSteerAngle = 35,

		SeatOffset = Vector(29,-18,40),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(0,-33,3),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
			{
				pos = Vector(0,33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-38,-33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-38,33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-75,-33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-75,33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-112,-33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-112,33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-149,-33,3),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-149,33,3),
				ang = Angle(0,-90,0)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-57,-46,-32),
				ang = Angle(-100,90,0),
			},
			{
				pos = Vector(-53,-46,-32),
				ang = Angle(-100,90,0),
			},
		},

		StrengthenSuspension = true,

		FrontHeight = 10,
		FrontConstant = 35000,
		FrontDamping = 4000,
		FrontRelativeDamping = 4000,

		RearHeight = 10,
		RearConstant = 35000,
		RearDamping = 4000,
		RearRelativeDamping = 4000,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 90,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = true,

		IdleRPM = 800,
		LimitRPM = 4500,
		PeakTorque = 75,
		PowerbandStart = 1700,
		PowerbandEnd = 4300,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-59,-50,-17),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 160,

		AirFriction = -60,
		PowerBias = 0,

		EngineSoundPreset = -1,

		snd_pitch = 1.1,
		snd_idle = 'octoteam/vehicles/bus_idle.wav',

		snd_low = 'octoteam/vehicles/bus_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/bus_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/bus_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/bus_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/bus_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'BUS_HORN',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.16,
		Gears = {-0.4,0,0.2,0.35,0.5,0.75,1},

		Dash = { pos = Vector(71.261, 18.322, 25.553), ang = Angle(0.0, -90.0, 79.6) },
		Radio = { pos = Vector(66.316, -10.450, 24.861), ang = Angle(0.0, 90.0, 0.0) },
		Plates = {
			Front = { pos = Vector(139.954, 0, -26.187), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-201.927, 0, -22.796), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(70.085, -11.008, 47.725),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(58.821, 62.320, 45.287),
				w = 1 / 6,
				ratio = 3 / 6,
			},
			right = {
				pos = Vector(58.821, -62.320, 45.287),
				w = 1 / 6,
				ratio = 3 / 6,
			},
		},

	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tlad_pbus', V )

local light_table = {
	L_HeadLampPos = Vector(134,39.5,-4.5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(134,-39.5,-4.5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-202,42,11),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-202,-42,11),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(134,39.5,-4.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(134,-39.5,-4.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(72,21.3,21.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(134,39.5,-4.5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(134,-39.5,-4.5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(72,22,21.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-202,42,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-202,-42,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-202,31.5,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-202,-31.5,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-201,23,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-201,-23,11),
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
				pos = Vector(134,39.5,-9.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-201,43.3,-4.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-201,43.3,-9.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(71,21.3,20.5),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(134,-39.5,-9.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-201,-43.3,-4.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-201,-43.3,-9.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(71,13.5,20.5),
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
				[5] = '',
				[10] = ''
			},
			Brake = {
				[4] = '',
				[5] = 'models/gta4/vehicles/pbus/pbus_lights_on',
				[10] = '',
			},
			Reverse = {
				[4] = '',
				[5] = '',
				[10] = 'models/gta4/vehicles/pbus/pbus_lights_on',
			},
			Brake_Reverse = {
				[4] = '',
				[5] = 'models/gta4/vehicles/pbus/pbus_lights_on',
				[10] = 'models/gta4/vehicles/pbus/pbus_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/pbus/pbus_lights_on',
				[5] = '',
				[10] = ''
			},
			Brake = {
				[4] = 'models/gta4/vehicles/pbus/pbus_lights_on',
				[5] = 'models/gta4/vehicles/pbus/pbus_lights_on',
				[10] = '',
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/pbus/pbus_lights_on',
				[5] = '',
				[10] = 'models/gta4/vehicles/pbus/pbus_lights_on',
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/pbus/pbus_lights_on',
				[5] = 'models/gta4/vehicles/pbus/pbus_lights_on',
				[10] = 'models/gta4/vehicles/pbus/pbus_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/pbus/pbus_lights_on',
				[5] = '',
				[10] = ''
			},
			Brake = {
				[4] = 'models/gta4/vehicles/pbus/pbus_lights_on',
				[5] = 'models/gta4/vehicles/pbus/pbus_lights_on',
				[10] = '',
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/pbus/pbus_lights_on',
				[5] = '',
				[10] = 'models/gta4/vehicles/pbus/pbus_lights_on',
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/pbus/pbus_lights_on',
				[5] = 'models/gta4/vehicles/pbus/pbus_lights_on',
				[10] = 'models/gta4/vehicles/pbus/pbus_lights_on',
			},
		},
		turnsignals = {
			left = {
				[7] = 'models/gta4/vehicles/pbus/pbus_lights_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/pbus/pbus_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_pbus', light_table)
