local V = {
	Name = 'Coquette',
	Model = 'models/octoteam/vehicles/coquette.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Спортивные',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Спортивные',

	Members = {
		Mass = 1600.0,

		EnginePos = Vector(60,0,0),

		LightsTable = 'gta4_coquette',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,50)}
				-- CarCols[2] =  {REN.GTA4ColorTable(1,1,8)}
				-- CarCols[3] =  {REN.GTA4ColorTable(11,11,92)}
				-- CarCols[4] =  {REN.GTA4ColorTable(13,13,98)}
				-- CarCols[5] =  {REN.GTA4ColorTable(33,33,89)}
				-- CarCols[6] =  {REN.GTA4ColorTable(34,34,27)}
				-- CarCols[7] =  {REN.GTA4ColorTable(49,49,53)}
				-- CarCols[8] =  {REN.GTA4ColorTable(53,53,58)}
				-- CarCols[9] =  {REN.GTA4ColorTable(57,57,60)}
				-- CarCols[10] = {REN.GTA4ColorTable(113,35,113)}
				-- CarCols[11] = {REN.GTA4ColorTable(74,74,63)}
				-- CarCols[12] = {REN.GTA4ColorTable(80,80,84)}
				-- CarCols[13] = {REN.GTA4ColorTable(2,2,63)}
				-- CarCols[14] = {REN.GTA4ColorTable(21,21,72)}
				-- CarCols[15] = {REN.GTA4ColorTable(22,22,72)}
				-- CarCols[16] = {REN.GTA4ColorTable(13,13,91)}
				-- CarCols[17] = {REN.GTA4ColorTable(19,19,93)}
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

		CustomWheelModel = 'models/octoteam/vehicles/coquette_wheel.mdl',

		CustomWheelPosFL = Vector(54,33,-6),
		CustomWheelPosFR = Vector(54,-33,-6),
		CustomWheelPosRL = Vector(-54,34,-6),
		CustomWheelPosRR = Vector(-54,-34,-6),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-27,-19,15),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-13,-17,-15),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-88,22,-4),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-88,-22,-4),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 12,
		FrontConstant = 20000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 12,
		RearConstant = 20000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3,

		MaxGrip = 95,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 35,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 160.0,
		PowerbandStart = 1500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-61,37,17),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 70,

		PowerBias = 0,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/coquette_idle.wav',

		snd_low = 'octoteam/vehicles/coquette_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/coquette_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/coquette_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/coquette_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/coquette_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/huntley_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.25,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_coquette', V )

local light_table = {
	L_HeadLampPos = Vector(71,27,7),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(71,-27,7),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-90,19,13),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-90,-19,13),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(71,27,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(71,-27,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(71,22,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(71,-22,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(9,10,11),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(71,22,7),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(71,-22,7),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(71,27,7),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(71,-27,7),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(9,10,12),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-90,19,13),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-90,-19,13),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-88,27,15),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-88,-27,15),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-90,0,18),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-90,19,13),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-90,-19,13),
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
				pos = Vector(72,31,8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-88,27,12),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(9,20.7,13.2),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(72,-31,8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-88,-27,12),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(9,13.4,13.2),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[5] = '',
				[10] = '',
				[9] = ''
			},
			Brake = {
				[5] = '',
				[10] = 'models/gta4/vehicles/coquette/coquette_lights_on',
				[9] = ''
			},
			Reverse = {
				[5] = '',
				[10] = '',
				[9] = 'models/gta4/vehicles/coquette/coquette_lights_on'
			},
			Brake_Reverse = {
				[5] = '',
				[10] = 'models/gta4/vehicles/coquette/coquette_lights_on',
				[9] = 'models/gta4/vehicles/coquette/coquette_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/coquette/coquette_lights_on',
				[10] = '',
				[9] = ''
			},
			Brake = {
				[5] = 'models/gta4/vehicles/coquette/coquette_lights_on',
				[10] = 'models/gta4/vehicles/coquette/coquette_lights_on',
				[9] = ''
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/coquette/coquette_lights_on',
				[10] = '',
				[9] = 'models/gta4/vehicles/coquette/coquette_lights_on'
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/coquette/coquette_lights_on',
				[10] = 'models/gta4/vehicles/coquette/coquette_lights_on',
				[9] = 'models/gta4/vehicles/coquette/coquette_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/coquette/coquette_lights_on',
				[10] = '',
				[9] = ''
			},
			Brake = {
				[5] = 'models/gta4/vehicles/coquette/coquette_lights_on',
				[10] = 'models/gta4/vehicles/coquette/coquette_lights_on',
				[9] = ''
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/coquette/coquette_lights_on',
				[10] = '',
				[9] = 'models/gta4/vehicles/coquette/coquette_lights_on'
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/coquette/coquette_lights_on',
				[10] = 'models/gta4/vehicles/coquette/coquette_lights_on',
				[9] = 'models/gta4/vehicles/coquette/coquette_lights_on'
			},
		},
		turnsignals = {
			left = {
				[8] = 'models/gta4/vehicles/coquette/coquette_lights_on'
			},
			right = {
				[13] = 'models/gta4/vehicles/coquette/coquette_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_coquette', light_table)