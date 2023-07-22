local V = {
	Name = 'Ruiner',
	Model = 'models/octoteam/vehicles/ruiner.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Маслкары',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Маслкары',

	Members = {
		Mass = 1400,
		Trunk = {
			25,
			{30, 3, 0},
		},

		EnginePos = Vector(60,0,0),

		LightsTable = 'gta4_ruiner',

		OnSpawn = function(ent)
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

		CustomWheelModel = 'models/octoteam/vehicles/ruiner_wheel.mdl',

		CustomWheelPosFL = Vector(58,29,-18),
		CustomWheelPosFR = Vector(58,-29,-18),
		CustomWheelPosRL = Vector(-55,29,-18),
		CustomWheelPosRR = Vector(-55,-29,-18),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-20,-17,10),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-10,-17,-23),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-100,22.3,-16.6),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-100,18,-16.6),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 7,
		FrontConstant = 27000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 7,
		RearConstant = 27000,
		RearDamping = 800,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 4,
		CounterSteeringMul = 0.8,

		MaxGrip = 46,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 28,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 49,
		PowerbandStart = 1200,
		PowerbandEnd = 5600,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-70,34,5),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 45,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 0.9,
		snd_idle = 'octoteam/vehicles/faction_idle.wav',

		snd_low = 'octoteam/vehicles/faction_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/faction_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/faction_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/faction_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/faction_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/ruiner_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(11.294, 16.815, 2.816), ang = Angle(0.0, -90.0, 90.0) },
		Radio = { pos = Vector(23.087, 1.655, 0.963), ang = Angle(0.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(102.531, -0.004, -15.657), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-100.392, -0.005, -10.817), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(-3.732, 0.002, 18.203),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(15.149, 37.626, 8.769),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(15.401, -37.765, 8.911),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_ruiner', V )

local light_table = {
	L_HeadLampPos = Vector(88,21,-5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(88,-21,-5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-96,18,1),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-96,-18,1),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(88,21,-5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(88,-21,-5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(11,26.5,2),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(99,247,247,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(88,21,-5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(88,-21,-5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(11,26.5,3),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(99,247,247,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-96,25,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-96,18,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-96,11,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
		--
		{
			pos = Vector(-96,-11,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-96,-18,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-96,-25,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-96,25,3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-96,18,3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-96,11,3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
		--
		{
			pos = Vector(-96,-11,3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-96,-18,3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-96,-25,3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-96,11,-1.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-96,-11,-1.3),
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
				pos = Vector(101,21,-11),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-96,25,-1.3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,100,0,150),
			},
			{
				pos = Vector(-95,32,-1.3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,100,0,150),
			},
			{
				pos = Vector(-95,32,1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,100,0,150),
			},

--[[			{
				pos = Vector(11,18,5),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(99,247,247,255),
			},]]
		},
		Right = {
			{
				pos = Vector(101,-21,-11),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-96,-25,-1.3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,100,0,150),
			},
			{
				pos = Vector(-95,-32,-1.3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,100,0,150),
			},{
				pos = Vector(-95,-32,1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,100,0,150),
			},

--[[			{
				pos = Vector(11,15,5),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(99,247,247,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[9] = '',
				[14] = '',
				[5] = '',
			},
			Brake = {
				[9] = '',
				[14] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
				[5] = '',
			},
			Reverse = {
				[9] = '',
				[14] = '',
				[5] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
			},
			Brake_Reverse = {
				[9] = '',
				[14] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
				[5] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
				[14] = '',
				[5] = '',
			},
			Brake = {
				[9] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
				[14] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
				[5] = '',
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
				[14] = '',
				[5] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
				[14] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
				[5] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
				[14] = '',
				[5] = '',
			},
			Brake = {
				[9] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
				[14] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
				[5] = '',
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
				[14] = '',
				[5] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
				[14] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
				[5] = 'models/gta4/vehicles/ruiner/ruiner_lights_on',
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/ruiner/ruiner_lights_on'
			},
			right = {
				[8] = 'models/gta4/vehicles/ruiner/ruiner_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_ruiner', light_table)