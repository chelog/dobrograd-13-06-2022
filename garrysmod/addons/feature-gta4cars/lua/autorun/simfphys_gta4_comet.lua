local V = {
	Name = 'Comet',
	Model = 'models/octoteam/vehicles/comet.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Спортивные',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Спортивные',

	Members = {
		Mass = 1450,
		Trunk = { 25 },

		EnginePos = Vector(-60,0,10),

		LightsTable = 'gta4_comet',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,63)}
				-- CarCols[2] =  {REN.GTA4ColorTable(1,1,12)}
				-- CarCols[3] =  {REN.GTA4ColorTable(33,33,27)}
				-- CarCols[4] =  {REN.GTA4ColorTable(46,46,127)}
				-- CarCols[5] =  {REN.GTA4ColorTable(6,6,8)}
				-- CarCols[6] =  {REN.GTA4ColorTable(49,49,59)}
				-- CarCols[7] =  {REN.GTA4ColorTable(127,127,123)}
				-- CarCols[8] =  {REN.GTA4ColorTable(62,62,63)}
				-- CarCols[9] =  {REN.GTA4ColorTable(22,22,64)}
				-- CarCols[10] = {REN.GTA4ColorTable(56,56,59)}
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

		CustomWheelModel = 'models/octoteam/vehicles/comet_wheel.mdl',

		CustomWheelPosFL = Vector(50,30,-10),
		CustomWheelPosFR = Vector(50,-30,-10),
		CustomWheelPosRL = Vector(-49,34,-10),
		CustomWheelPosRR = Vector(-49,-34,-10),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,-5),

		CustomSteerAngle = 40,

		SeatOffset = Vector(-16,-17,15),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-2,-17,-15),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-88,20,-13),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-88,-20,-13),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 6,
		FrontConstant = 38000,
		FrontDamping = 1100,
		FrontRelativeDamping = 1100,

		RearHeight = 6,
		RearConstant = 38000,
		RearDamping = 1100,
		RearRelativeDamping = 1100,

		FastSteeringAngle = 15,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 4,
		CounterSteeringMul = 0.95,

		MaxGrip = 78,
		Efficiency = 1.1,
		GripOffset = -4,
		BrakePower = 40,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 70,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = true,
		Supercharged = true,
		DoNotStall = false,

		FuelFillPos = Vector(-60,-37,10),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 55,

		PowerBias = 0.65,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/infernus_idle.wav',

		snd_low = 'octoteam/vehicles/infernus_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/infernus_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/infernus_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/infernus_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/infernus_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/infernus_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.45,
		Gears = {-0.12,0,0.12,0.21,0.3,0.45,0.6},

		Dash = { pos = Vector(15.366, 15.588, 8.8), ang = Angle(-0.0, -90.0, 74.9) },
		Radio = { pos = Vector(20.677, -0.027, 4.173), ang = Angle(-10.3, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(90.552, 0.003, -8.097), ang = Angle(9.9, 0.0, -0.0) },
			Back = { pos = Vector(-91.049, -0.002, -6.423), ang = Angle(2.4, -180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(9.557, 0.037, 23.938),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(16.511, 33.585, 13.793),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(16.959, -32.668, 14.338),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_comet', V )

local light_table = {
	L_HeadLampPos = Vector(70,28,4),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(70,-28,4),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-86,23,5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-86,-23,5),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(70,28,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,100),
		},
		{
			pos = Vector(70,-28,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,100),
		},
		{
			pos = Vector(71,24,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,100),
		},
		{
			pos = Vector(71,-24,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,100),
		},

--[[		{
			pos = Vector(18,22,9),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(71,24,0),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(71,-24,0),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(18,22,10),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(82,21,-10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(82,-21,-10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-86,23,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-86,-23,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-87,23,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-87,-23,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-86,20.5,6.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-86,-20.5,6.5),
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
				pos = Vector(71,28,0),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-86,26,6.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(18,21,11),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(71,-28,0),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-86,-26,6.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(18,11,11),
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
				[9] = '',
				[11] = ''
			},
			Brake = {
				[8] = '',
				[9] = 'models/gta4/vehicles/comet/comet_lights_on',
				[11] = ''
			},
			Reverse = {
				[8] = '',
				[9] = '',
				[11] = 'models/gta4/vehicles/comet/comet_lights_on'
			},
			Brake_Reverse = {
				[8] = '',
				[9] = 'models/gta4/vehicles/comet/comet_lights_on',
				[11] = 'models/gta4/vehicles/comet/comet_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/comet/comet_lights_on',
				[9] = '',
				[11] = ''
			},
			Brake = {
				[8] = 'models/gta4/vehicles/comet/comet_lights_on',
				[9] = 'models/gta4/vehicles/comet/comet_lights_on',
				[11] = ''
			},
			Reverse = {
				[8] = 'models/gta4/vehicles/comet/comet_lights_on',
				[9] = '',
				[11] = 'models/gta4/vehicles/comet/comet_lights_on'
			},
			Brake_Reverse = {
				[8] = 'models/gta4/vehicles/comet/comet_lights_on',
				[9] = 'models/gta4/vehicles/comet/comet_lights_on',
				[11] = 'models/gta4/vehicles/comet/comet_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/comet/comet_lights_on',
				[9] = '',
				[11] = ''
			},
			Brake = {
				[8] = 'models/gta4/vehicles/comet/comet_lights_on',
				[9] = 'models/gta4/vehicles/comet/comet_lights_on',
				[11] = ''
			},
			Reverse = {
				[8] = 'models/gta4/vehicles/comet/comet_lights_on',
				[9] = '',
				[11] = 'models/gta4/vehicles/comet/comet_lights_on'
			},
			Brake_Reverse = {
				[8] = 'models/gta4/vehicles/comet/comet_lights_on',
				[9] = 'models/gta4/vehicles/comet/comet_lights_on',
				[11] = 'models/gta4/vehicles/comet/comet_lights_on'
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/comet/comet_lights_on'
			},
			right = {
				[6] = 'models/gta4/vehicles/comet/comet_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_comet', light_table)
