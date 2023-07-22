sound.Add({
	name = 'TRUCK_HORN',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 95,
	sound = 'octoteam/vehicles/horns/phantom_horn.wav'
} )

local V = {
	Name = 'Phantom',
	Model = 'models/octoteam/vehicles/phantom.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Индустриальные',
	SpawnOffset = Vector(0,0,40),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Индустриальные',
	FLEX = {
		Trailers = {
			outputPos = Vector(-134,0,16),
			outputType = 'axis'
		}
	},

	Members = {
		Mass = 10000.0,

		EnginePos = Vector(150,0,30),

		LightsTable = 'gta4_phantom',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,12)}
				-- CarCols[2] =  {REN.GTA4ColorTable(26,26,12)}
				-- CarCols[3] =  {REN.GTA4ColorTable(34,34,34)}
				-- CarCols[4] =  {REN.GTA4ColorTable(33,33,34)}
				-- CarCols[5] =  {REN.GTA4ColorTable(38,38,34)}
				-- CarCols[6] =  {REN.GTA4ColorTable(62,62,56)}
				-- CarCols[7] =  {REN.GTA4ColorTable(60,60,56)}
				-- CarCols[8] =  {REN.GTA4ColorTable(77,77,75)}
				-- CarCols[9] =  {REN.GTA4ColorTable(90,90,75)}
				-- CarCols[10] = {REN.GTA4ColorTable(85,85,75)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 1, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 1, 1, 2) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/phantom_wheel.mdl',
		CustomWheelModel_R = 'models/octoteam/vehicles/phantom_wheel_r.mdl',

		CustomWheelPosFL = Vector(158,50,-27),
		CustomWheelPosFR = Vector(158,-50,-27),
		CustomWheelPosML = Vector(-100,43,-27),
		CustomWheelPosMR = Vector(-100,-43,-27),
		CustomWheelPosRL = Vector(-158,43,-27),
		CustomWheelPosRR = Vector(-158,-43,-27),
		CustomWheelAngleOffset = Angle(0,-90,0),

		FrontWheelRadius = 24.4,
		RearWheelRadius = 22.3,

		CustomMassCenter = Vector(0,0,25),

		CustomSteerAngle = 40,

		SeatOffset = Vector(60,-27,70),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(75,-25,25),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(55,53.2,110.5),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(55,-53.2,110.5),
				ang = Angle(-90,0,0),
			},
		},

		StrengthenedSuspension = true,

		FrontHeight = 22,
		FrontConstant = 50000,
		FrontDamping = 2000,
		FrontRelativeDamping = 350,

		RearHeight = 12,
		RearConstant = 50000,
		RearDamping = 2000,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 700,

		TurnSpeed = 3,

		MaxGrip = 148,
		Efficiency = 0.8,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = false,

		IdleRPM = 700,
		LimitRPM = 4000,
		PeakTorque = 135.0,
		PowerbandStart = 1700,
		PowerbandEnd = 3500,
		Turbocharged = false,
		Supercharged = true,
		DoNotStall = false,

		FuelFillPos = Vector(20,56,-10),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 200,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/phantom_idle.wav',

		snd_low = 'octoteam/vehicles/phantom_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/phantom_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/phantom_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/phantom_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/phantom_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'TRUCK_HORN',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/DUMP_VALVE.wav',

		DifferentialGear = 0.14,
		Gears = {-0.35,0,0.2,0.35,0.5,0.75,1,1.25,1.5}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_phantom', V )

local light_table = {
	L_HeadLampPos = Vector(192,49,8),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(192,-49,8),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-191,31,-3),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-191,-31,-3),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(192,49,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(192,-49,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(100,35.3,50),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(192,41,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(192,-41,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(99,35.3,49),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-191,31,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-191,-31,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-191,37.5,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-191,-37.5,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-191,11.5,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-191,-11.5,-3),
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
				pos = Vector(-191,46,-3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(100.5,33.3,51.7),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(-191,-46,-3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(100.5,18.3,51.7),
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
				[11] = '',
				[8] = '',
				[10] = ''
			},
			Brake = {
				[4] = '',
				[11] = '',
				[8] = 'models/gta4/vehicles/phantom/detail2_on',
				[10] = ''
			},
			Reverse = {
				[4] = '',
				[11] = '',
				[8] = '',
				[10] = 'models/gta4/vehicles/phantom/detail2_on'
			},
			Brake_Reverse = {
				[4] = '',
				[11] = '',
				[8] = 'models/gta4/vehicles/phantom/detail2_on',
				[10] = 'models/gta4/vehicles/phantom/detail2_on'
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/phantom/detail2_on',
				[11] = '',
				[8] = '',
				[10] = ''
			},
			Brake = {
				[4] = 'models/gta4/vehicles/phantom/detail2_on',
				[11] = '',
				[8] = 'models/gta4/vehicles/phantom/detail2_on',
				[10] = ''
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/phantom/detail2_on',
				[11] = '',
				[8] = '',
				[10] = 'models/gta4/vehicles/phantom/detail2_on'
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/phantom/detail2_on',
				[11] = '',
				[8] = 'models/gta4/vehicles/phantom/detail2_on',
				[10] = 'models/gta4/vehicles/phantom/detail2_on'
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/phantom/detail2_on',
				[11] = 'models/gta4/vehicles/phantom/detail2_on',
				[8] = '',
				[10] = ''
			},
			Brake = {
				[4] = 'models/gta4/vehicles/phantom/detail2_on',
				[11] = 'models/gta4/vehicles/phantom/detail2_on',
				[8] = 'models/gta4/vehicles/phantom/detail2_on',
				[10] = ''
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/phantom/detail2_on',
				[11] = 'models/gta4/vehicles/phantom/detail2_on',
				[8] = '',
				[10] = 'models/gta4/vehicles/phantom/detail2_on'
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/phantom/detail2_on',
				[11] = 'models/gta4/vehicles/phantom/detail2_on',
				[8] = 'models/gta4/vehicles/phantom/detail2_on',
				[10] = 'models/gta4/vehicles/phantom/detail2_on'
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/phantom/detail2_on'
			},
			right = {
				[5] = 'models/gta4/vehicles/phantom/detail2_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_phantom', light_table)