local V = {
	Name = 'Taxi',
	Model = 'models/octoteam/vehicles/taxi.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Сервис',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Сервис',

	Members = {
		Mass = 1650,
		Trunk = { 30 },

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_taxi',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(113,74,113)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
			REN.GTA4Bullhorn(ent)
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/police_wheel.mdl',

		ModelInfo = {
			WheelColor = Color(10,10,10),
		},

		CustomWheelPosFL = Vector(60,35,-13),
		CustomWheelPosFR = Vector(60,-35,-13),
		CustomWheelPosRL = Vector(-60,35,-13),
		CustomWheelPosRR = Vector(-60,-35,-13),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-8,-19.5,16),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(5,-20,-15),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-32,20,-15),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-32,-20,-15),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-114.6,22.3,-14.3),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 6,
		FrontConstant = 36000,
		FrontDamping = 1000,
		FrontRelativeDamping = 1000,

		RearHeight = 6,
		RearConstant = 36000,
		RearDamping = 1000,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 15,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 4.5,

		MaxGrip = 56,
		Efficiency = 0.9,
		GripOffset = 0,
		BrakePower = 32,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 7000,
		PeakTorque = 46,
		PowerbandStart = 1200,
		PowerbandEnd = 6600,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 1.2,

		FuelFillPos = Vector(-82.4,-37,9.8),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 65,

		AirFriction = -75,
		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1.05,
		snd_idle = 'octoteam/vehicles/stainer_idle.wav',

		snd_low = 'octoteam/vehicles/stainer_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/stainer_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/stainer_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/stainer_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/stainer_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/taxi2_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(18.956, 19.036, 13.307), ang = Angle(-0.0, -90.0, 80.3) },
		Radio = { pos = Vector(26.232, -0.010, 8.225), ang = Angle(-19.8, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(104.138, -0.031, -7.778), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-114.153, 0.025, 3.693), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(10.393, 0.005, 26.879),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(19.971, 39.204, 17.188),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(21.423, -39.155, 17.184),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_taxi', V )

local light_table = {
	L_HeadLampPos = Vector(98,25,2.3),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(98,-25,2.3),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-114,30,5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-114,-30,5),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(98,25,2.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(98,-25,2.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(23,19,11.3),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(98,25,2.3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(98,-25,2.3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(23,18,11.3),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-114,30,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-114,-30,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-114,21.7,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-114,-21.7,3),
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
				pos = Vector(93.8,34.6,2.3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,20,11.3),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeLeft = {
			{
				pos = Vector(-114,30,5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
		Right = {
			{
				pos = Vector(93.8,-34.6,2.3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,17,11.3),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeRight = {
			{
				pos = Vector(-114,-30,5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[12] = '',
				[10] = '',
				[9] = ''
			},
			Brake = {
				[12] = '',
				[10] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[9] = ''
			},
			Reverse = {
				[12] = '',
				[10] = '',
				[9] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
			Brake_Reverse = {
				[12] = '',
				[10] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[9] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[12] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[10] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[9] = ''
			},
			Brake = {
				[12] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[10] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[9] = ''
			},
			Reverse = {
				[12] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[10] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[9] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
			Brake_Reverse = {
				[12] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[10] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[9] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[12] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[10] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[9] = ''
			},
			Brake = {
				[12] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[10] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[9] = ''
			},
			Reverse = {
				[12] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[10] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[9] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
			Brake_Reverse = {
				[12] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[10] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[9] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
		},
		turnsignals = {
			left = {
				[11] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
			right = {
				[12] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
		},
	},
}
list.Set('simfphys_lights', 'gta4_taxi', light_table)