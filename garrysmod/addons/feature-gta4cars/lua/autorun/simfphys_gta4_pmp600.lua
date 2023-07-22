local V = {
	Name = 'PMP 600',
	Model = 'models/octoteam/vehicles/pmp600.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1700.0,

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_pmp600',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1)..math.random(0,1)..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,37)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,0,0)}
				-- CarCols[3] =  {REN.GTA4ColorTable(0,0,76)}
				-- CarCols[4] =  {REN.GTA4ColorTable(1,1,95)}
				-- CarCols[5] =  {REN.GTA4ColorTable(6,6,97)}
				-- CarCols[6] =  {REN.GTA4ColorTable(11,11,97)}
				-- CarCols[7] =  {REN.GTA4ColorTable(20,20,12)}
				-- CarCols[8] =  {REN.GTA4ColorTable(21,21,24)}
				-- CarCols[9] =  {REN.GTA4ColorTable(23,23,24)}
				-- CarCols[10] = {REN.GTA4ColorTable(28,28,126)}
				-- CarCols[11] = {REN.GTA4ColorTable(45,45,35)}
				-- CarCols[12] = {REN.GTA4ColorTable(53,53,58)}
				-- CarCols[13] = {REN.GTA4ColorTable(54,54,55)}
				-- CarCols[14] = {REN.GTA4ColorTable(62,62,51)}
				-- CarCols[15] = {REN.GTA4ColorTable(69,69,65)}
				-- CarCols[16] = {REN.GTA4ColorTable(70,70,63)}
				-- CarCols[17] = {REN.GTA4ColorTable(78,78,63)}
				-- CarCols[18] = {REN.GTA4ColorTable(85,85,123)}
				-- CarCols[19] = {REN.GTA4ColorTable(16,16,76)}
				-- CarCols[20] = {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[21] = {REN.GTA4ColorTable(15,15,93)}
				-- CarCols[22] = {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[23] = {REN.GTA4ColorTable(13,13,80)}
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

		CustomWheelModel = 'models/octoteam/vehicles/pmp600_wheel.mdl',

		CustomWheelPosFL = Vector(67,32,-8),
		CustomWheelPosFR = Vector(67,-32,-8),
		CustomWheelPosRL = Vector(-67,32,-8),
		CustomWheelPosRR = Vector(-67,-32,-8),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-5,-18,20),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(7,-17,-10),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-37,17,-10),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-37,-17,-10),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-107,22,-9),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-107,-22,-9),
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

		MaxGrip = 83,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 30,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 140.0,
		PowerbandStart = 2500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-76,34,20),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 90,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/admiral_idle.wav',

		snd_low = 'octoteam/vehicles/admiral_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/admiral_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/admiral_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/admiral_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/admiral_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/admiral_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.17,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_pmp600', V )

local light_table = {
	L_HeadLampPos = Vector(93,19,7),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(93,-19,7),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-102,31,16),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-102,-31,16),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(93,19,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},
		{
			pos = Vector(93,-19,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},

--[[		{
			pos = Vector(30,23,20),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(93,19,7),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(93,-19,7),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(30,14.5,20),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(98,18,-10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(98,-18,-10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-102,31,16),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-102,-31,16),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-102,31,16),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-102,-31,16),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-103,31,12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-103,-31,12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(93,19,4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-104,31,9.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(30,22,20),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(93,-19,4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-104,-31,9.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(30,15.5,20),
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
				[10] = '',
			},
			Reverse = {
				[4] = '',
				[10] = 'models/gta4/vehicles/pmp600/pmp600_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/pmp600/pmp600_lights_on',
				[10] = '',
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/pmp600/pmp600_lights_on',
				[10] = 'models/gta4/vehicles/pmp600/pmp600_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/pmp600/pmp600_lights_on',
				[10] = '',
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/pmp600/pmp600_lights_on',
				[10] = 'models/gta4/vehicles/pmp600/pmp600_lights_on',
			},
		},
		turnsignals = {
			left = {
				[7] = 'models/gta4/vehicles/pmp600/pmp600_lights_on'
			},
			right = {
				[11] = 'models/gta4/vehicles/pmp600/pmp600_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_pmp600', light_table)