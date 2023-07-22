local V = {
	Name = 'Sentinel',
	Model = 'models/octoteam/vehicles/sentinel.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Хетчбеки',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Хетчбеки',

	Members = {
		Mass = 1600.0,

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_sentinel',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1)..math.random(0,1)..math.random(0,1) )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,1,50)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,1,1)}
				-- CarCols[3] =  {REN.GTA4ColorTable(0,133,1)}
				-- CarCols[4] =  {REN.GTA4ColorTable(7,1,12)}
				-- CarCols[5] =  {REN.GTA4ColorTable(12,1,12)}
				-- CarCols[6] =  {REN.GTA4ColorTable(19,133,19)}
				-- CarCols[7] =  {REN.GTA4ColorTable(34,1,45)}
				-- CarCols[8] =  {REN.GTA4ColorTable(31,133,30)}
				-- CarCols[9] =  {REN.GTA4ColorTable(38,133,34)}
				-- CarCols[10] = {REN.GTA4ColorTable(52,133,56)}
				-- CarCols[11] = {REN.GTA4ColorTable(68,133,103)}
				-- CarCols[12] = {REN.GTA4ColorTable(71,133,103)}
				-- CarCols[13] = {REN.GTA4ColorTable(77,133,77)}
				-- CarCols[14] = {REN.GTA4ColorTable(85,133,77)}
				-- CarCols[15] = {REN.GTA4ColorTable(106,103,90)}
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

		CustomWheelModel = 'models/octoteam/vehicles/sentinel_wheel.mdl',

		CustomWheelPosFL = Vector(60,30,-15),
		CustomWheelPosFR = Vector(60,-30,-15),
		CustomWheelPosRL = Vector(-55,30,-15),
		CustomWheelPosRR = Vector(-55,-30,-15),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-13,-15,15),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-2,-15,-19),
				ang = Angle(0,-90,15),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-92,18.5,-16.6),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-92,-18.5,-16.6),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 10,
		FrontConstant = 25000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 10,
		RearConstant = 25000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 80,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 26,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 150.0,
		PowerbandStart = 1700,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-68,31,9),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 70,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/sultan_idle.wav',

		snd_low = 'octoteam/vehicles/sultan_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/sultan_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/sultan_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/sultan_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/sultan_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/sultanrs_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.2,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_sentinel', V )

local light_table = {
	L_HeadLampPos = Vector(84,21,-1),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(84,-21,-1),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-92,23,5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-92,-23,5),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(84,21,-1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(84,-21,-1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(22,20,9.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(84,21,-1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(84,-21,-1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(22,19.4,9.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(88,21,-14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(88,-21,-14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-92,23,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-92,-23,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-92,23,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-92,-23,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-93,20,1.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-93,-20,1.4),
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
				pos = Vector(79,29,-1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-92,27,1.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(22,16,12.5),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(79,-29,-1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-92,-27,1.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(22,14,12.5),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[7] = '',
				[8] = '',
				[3] = '',
			},
			Brake = {
				[7] = '',
				[8] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[3] = '',
			},
			Reverse = {
				[7] = '',
				[8] = '',
				[3] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
			},
			Brake_Reverse = {
				[7] = '',
				[8] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[3] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[7] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[8] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[3] = '',
			},
			Brake = {
				[7] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[8] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[3] = '',
			},
			Reverse = {
				[7] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[8] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[3] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
			},
			Brake_Reverse = {
				[7] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[8] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[3] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[7] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[8] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[3] = '',
			},
			Brake = {
				[7] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[8] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[3] = '',
			},
			Reverse = {
				[7] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[8] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[3] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
			},
			Brake_Reverse = {
				[7] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[8] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
				[3] = 'models/gta4/vehicles/sentinel/sentinel_lights_on',
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/sentinel/sentinel_lights_on'
			},
			right = {
				[4] = 'models/gta4/vehicles/sentinel/sentinel_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_sentinel', light_table)