local V = {
	Name = 'Bobcat',
	Model = 'models/octoteam/vehicles/bobcat.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 1800,
		Trunk = {
			nil,
			{15, 2, 1},
			{50, 2, 2},
		},

		EnginePos = Vector(70,0,10),

		LightsTable = 'gta4_bobcat',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,4)..math.random(0,2)..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(11,11,12)}
				-- CarCols[2] =  {REN.GTA4ColorTable(1,11,5)}
				-- CarCols[3] =  {REN.GTA4ColorTable(5,5,5)}
				-- CarCols[4] =  {REN.GTA4ColorTable(34,34,32)}
				-- CarCols[5] =  {REN.GTA4ColorTable(53,53,54)}
				-- CarCols[6] =  {REN.GTA4ColorTable(54,54,55)}
				-- CarCols[7] =  {REN.GTA4ColorTable(57,57,57)}
				-- CarCols[8] =  {REN.GTA4ColorTable(69,69,67)}
				-- CarCols[9] =  {REN.GTA4ColorTable(76,76,67)}
				-- CarCols[10] = {REN.GTA4ColorTable(95,95,95)}
				-- CarCols[11] = {REN.GTA4ColorTable(102,102,103)}
				-- CarCols[12] = {REN.GTA4ColorTable(16,16,76)}
				-- CarCols[13] = {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[14] = {REN.GTA4ColorTable(15,15,93)}
				-- CarCols[15] = {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[16] = {REN.GTA4ColorTable(13,13,80)}
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

		CustomWheelModel = 'models/octoteam/vehicles/bobcat_wheel.mdl',

		CustomWheelPosFL = Vector(70,36,-14),
		CustomWheelPosFR = Vector(70,-36,-14),
		CustomWheelPosRL = Vector(-72,36,-14),
		CustomWheelPosRR = Vector(-72,-36,-14),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,10),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-1,-19,26),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(6,-18,-6),
				ang = Angle(0,-90,10),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-36,37,-18.5),
				ang = Angle(-100,-70,0),
			},
			{
				pos = Vector(-39.5,37,-18.5),
				ang = Angle(-100,-70,0),
			},
		},

		FrontHeight = 9,
		FrontConstant = 32000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 9,
		RearConstant = 32000,
		RearDamping = 800,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3,

		MaxGrip = 60,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 28,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 30,
		PowerbandStart = 1700,
		PowerbandEnd = 4600,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 2,

		FuelFillPos = Vector(-17,43,-7	),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		AirFriction = -35,
		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/rancher_idle.wav',
		BrakeSqueal = true,

		snd_low = 'octoteam/vehicles/rancher_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/rancher_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/rancher_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/rancher_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/rancher_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/rancher_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.1,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(29.880, 18.970, 18.408), ang = Angle(0.0, -90.0, 90.0) },
		Radio = { pos = Vector(33.423, 0.490, 12.959), ang = Angle(0.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(104.949, 0, -11.772), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-113.898, -25.011, -16.542), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(21.243, 0.000, 39.467),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(34.139, 43.608, 26.021),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(33.912, -43.490, 26.065),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},

		CanAttachPackages = true,
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_bobcat', V )

local light_table = {
	L_HeadLampPos = Vector(103,32,10),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(103,-32,10),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-103,35,2),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-103,-35,2),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(103,32,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},
		{
			pos = Vector(103,-32,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},
	},

	Headlamp_sprites = {
		{pos = Vector(102,32,2),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(102,-32,2),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
	},

	Rearlight_sprites = {
		{
			pos = Vector(-103,35,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-103,-35,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-103,35,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-103,-35,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-103,35,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-103,-35,-3),
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
				pos = Vector(103,32,-4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-103,35,-8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(30,23,16.8),
				material = 'gta4/dash_left',
				size = 1,
				color = Color(255,57,50,255),
			},]]
		},
		Right = {
			{
				pos = Vector(103,-32,-4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-103,-35,-8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(30,16.8,16.8),
				material = 'gta4/dash_right',
				size = 1,
				color = Color(255,57,50,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[10] = '',
				[11] = '',
				[9] = '',
			},
			Reverse = {
				[10] = '',
				[11] = '',
				[9] = 'models/gta4/vehicles/bobcat/bobcat_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/bobcat/bobcat_lights_on',
				[11] = '',
				[9] = '',
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/bobcat/bobcat_lights_on',
				[11] = '',
				[9] = 'models/gta4/vehicles/bobcat/bobcat_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/bobcat/bobcat_lights_on',
				[11] = 'models/gta4/vehicles/bobcat/bobcat_lights_on',
				[9] = '',
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/bobcat/bobcat_lights_on',
				[11] = 'models/gta4/vehicles/bobcat/bobcat_lights_on',
				[9] = 'models/gta4/vehicles/bobcat/bobcat_lights_on',
			},
		},
		turnsignals = {
			left = {
				[5] = 'models/gta4/vehicles/bobcat/bobcat_lights_on'
			},
			right = {
				[8] = 'models/gta4/vehicles/bobcat/bobcat_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_bobcat', light_table)