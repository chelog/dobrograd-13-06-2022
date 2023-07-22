local V = {
	Name = 'Perennial (FlyUS)',
	Model = 'models/octoteam/vehicles/perennial2.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 2500.0,

		EnginePos = Vector(80,0,10),

		LightsTable = 'gta4_perennial2',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {Color(255,255,255)}
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

		CustomWheelModel = 'models/octoteam/vehicles/perennial_wheel.mdl',

		CustomWheelPosFL = Vector(63,33,-9),
		CustomWheelPosFR = Vector(63,-33,-9),
		CustomWheelPosRL = Vector(-64,33,-9),
		CustomWheelPosRR = Vector(-64,-33,-9),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,10),

		CustomSteerAngle = 33,

		SeatOffset = Vector(0,-19.5,26),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(10,-20,-8),
				ang = Angle(0,-90,10),
				hasRadio = true
			},
			{
				pos = Vector(-33,20,-8),
				ang = Angle(0,-90,10)
			},
			{
				pos = Vector(-33,-20,-8),
				ang = Angle(0,-90,10)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-107.4,26.7,-4.7),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-107.4,-26.7,-4.7),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 12,
		FrontConstant = 25000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 12,
		RearConstant = 25000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3,

		MaxGrip = 80,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 30,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 130.0,
		PowerbandStart = 2500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-80,40,20),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 90,

		PowerBias = 1,

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

		snd_horn = 'octoteam/vehicles/horns/perennial_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.13,
		Gears = {-0.3,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_perennial2', V )

local light_table = {
	L_HeadLampPos = Vector(93,29,9),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(93,-29,9),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-106.3,29,20.7),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-106.3,-29,20.7),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(93,29,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(93,-29,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(39,17,17),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(255,57,50,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(93,29,9),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(93,-29,9),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(39,18,17),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(255,57,50,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(93,30,-7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(93,-30,-7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},

	Rearlight_sprites = {
		{
			pos = Vector(-106.3,29,20.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-106.3,-29,20.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-107.7,20,20.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-107.7,-20,20.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-108.7,0,20.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-108.7,9.2,19.9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-108.7,-9.2,19.9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	ems_sounds = {'common/null.wav'},
	ems_sprites = {
		{
			pos = Vector(-4,0,54),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 80,
			Colors = {
						Color(255,135,0,255),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.1
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(86,38,10),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-100,37,21),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(39,19,17),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(255,57,50,255),
			},]]
		},
		Right = {
			{
				pos = Vector(86,-38,10),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-100,-37,21),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(39,16,17),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(255,57,50,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[11] = '',
				[12] = '',
				[6] = ''
			},
			Brake = {
				[11] = '',
				[12] = 'models/gta4/vehicles/perennial/perennial_lights_on',
				[6] = ''
			},
			Reverse = {
				[11] = '',
				[12] = '',
				[6] = 'models/gta4/vehicles/perennial/perennial_lights_on'
			},
			Brake_Reverse = {
				[11] = '',
				[12] = 'models/gta4/vehicles/perennial/perennial_lights_on',
				[6] = 'models/gta4/vehicles/perennial/perennial_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[11] = 'models/gta4/vehicles/perennial/perennial_lights_on',
				[12] = '',
				[6] = ''
			},
			Brake = {
				[11] = 'models/gta4/vehicles/perennial/perennial_lights_on',
				[12] = 'models/gta4/vehicles/perennial/perennial_lights_on',
				[6] = ''
			},
			Reverse = {
				[11] = 'models/gta4/vehicles/perennial/perennial_lights_on',
				[12] = '',
				[6] = 'models/gta4/vehicles/perennial/perennial_lights_on'
			},
			Brake_Reverse = {
				[11] = 'models/gta4/vehicles/perennial/perennial_lights_on',
				[12] = 'models/gta4/vehicles/perennial/perennial_lights_on',
				[6] = 'models/gta4/vehicles/perennial/perennial_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[11] = 'models/gta4/vehicles/perennial/perennial_lights_on',
				[12] = '',
				[6] = ''
			},
			Brake = {
				[11] = 'models/gta4/vehicles/perennial/perennial_lights_on',
				[12] = 'models/gta4/vehicles/perennial/perennial_lights_on',
				[6] = ''
			},
			Reverse = {
				[11] = 'models/gta4/vehicles/perennial/perennial_lights_on',
				[12] = '',
				[6] = 'models/gta4/vehicles/perennial/perennial_lights_on'
			},
			Brake_Reverse = {
				[11] = 'models/gta4/vehicles/perennial/perennial_lights_on',
				[12] = 'models/gta4/vehicles/perennial/perennial_lights_on',
				[6] = 'models/gta4/vehicles/perennial/perennial_lights_on'
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/perennial/perennial_lights_on'
			},
			right = {
				[7] = 'models/gta4/vehicles/perennial/perennial_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_perennial2', light_table)