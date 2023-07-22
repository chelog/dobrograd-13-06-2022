local V = {
	Name = 'Mr Tasty',
	Model = 'models/octoteam/vehicles/mrtasty.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Индустриальные',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Индустриальные',

	Members = {
		Mass = 3000.0,

		EnginePos = Vector(80,0,20),

		LightsTable = 'gta4_mrtasty',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,8))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(113,66,113)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 2, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/mrtasty_wheel.mdl',

		CustomWheelPosFL = Vector(65,33,-8),
		CustomWheelPosFR = Vector(65,-33,-8),
		CustomWheelPosRL = Vector(-65,33,-8),
		CustomWheelPosRR = Vector(-65,-33,-8),
		CustomWheelAngleOffset = Angle(0,-90,0),

		FrontWheelRadius = 13.3,
		RearWheelRadius = 13.3,

		CustomMassCenter = Vector(0,0,20),

		CustomSteerAngle = 30,

		SeatOffset = Vector(15,-22,50),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(30,-22,13),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-117,-28.3,-13.6),
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

		MaxGrip = 80,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 20,
		BulletProofTires = false,

		IdleRPM = 700,
		LimitRPM = 4500,
		PeakTorque = 110.0,
		PowerbandStart = 1500,
		PowerbandEnd = 4000,
		Turbocharged = true,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-94,-39,2),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 80,

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

		DifferentialGear = 0.11,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_mrtasty', V )

local light_table = {
	L_HeadLampPos = Vector(94,31.7,9.2),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(94,-31.7,9.2),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-123.5,22.8,-2.4),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-123.5,-22.8,-2.4),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(94,31.7,9.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(94,26.6,9.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 20,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(94,-26.6,9.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 20,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(94,-31.7,9.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(53,17,34),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(95,26.6,9.2),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(95,-26.6,9.2),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(53,25,34),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-123.5,22.8,-2.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-123.5,-22.8,-2.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-123.5,22.8,-2.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 50,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-123.5,-22.8,-2.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 50,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-123.5,16.2,-2.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 20,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-123.5,-16.2,-2.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 20,
			color = Color(255,255,255,150),
		},
	},

	ems_sounds = {
		'octoteam/vehicles/mrtasty_song_1.wav',
		'octoteam/vehicles/mrtasty_song_2.wav',
		'octoteam/vehicles/mrtasty_song_3.wav',
		'octoteam/vehicles/mrtasty_song_4.wav',
		'octoteam/vehicles/mrtasty_song_5.wav',
		'octoteam/vehicles/mrtasty_song_6.wav',
		'octoteam/vehicles/mrtasty_song_gtasa.wav',
	},
	ems_sprites = {
		{
			pos = Vector(0,0,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 0,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 1
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(94,29.2,4.6),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-123.5,29.2,-2.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(54,25,35),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(94,-29.2,4.6),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-123.5,-29.2,-2.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(54,17,35),
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
				[7] = ''
			},
			Reverse = {
				[4] = '',
				[7] = 'models/gta4/vehicles/boxville/detail2_on'
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/boxville/detail2_on',
				[7] = ''
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/boxville/detail2_on',
				[7] = 'models/gta4/vehicles/boxville/detail2_on'
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/boxville/detail2_on',
				[7] = ''
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/boxville/detail2_on',
				[7] = 'models/gta4/vehicles/boxville/detail2_on'
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/boxville/detail2_on'
			},
			right = {
				[8] = 'models/gta4/vehicles/boxville/detail2_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_mrtasty', light_table)