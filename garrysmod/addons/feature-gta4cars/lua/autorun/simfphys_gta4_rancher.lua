local V = {
	Name = 'Rancher',
	Model = 'models/octoteam/vehicles/rancher.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 2000,
		Trunk = {
			nil,
			{100, 1, 1},
		},

		EnginePos = Vector(70,0,15),

		LightsTable = 'gta4_rancher',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,3)..math.random(0,2)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,2)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,4,8)}
				-- CarCols[3] =  {REN.GTA4ColorTable(0,3,3)}
				-- CarCols[4] =  {REN.GTA4ColorTable(1,24,75)}
				-- CarCols[5] =  {REN.GTA4ColorTable(11,5,6)}
				-- CarCols[6] =  {REN.GTA4ColorTable(23,24,75)}
				-- CarCols[7] =  {REN.GTA4ColorTable(30,30,39)}
				-- CarCols[8] =  {REN.GTA4ColorTable(31,36,72)}
				-- CarCols[9] =  {REN.GTA4ColorTable(48,49,48)}
				-- CarCols[10] = {REN.GTA4ColorTable(52,55,61)}
				-- CarCols[11] = {REN.GTA4ColorTable(57,61,61)}
				-- CarCols[12] = {REN.GTA4ColorTable(71,73,85)}
				-- CarCols[13] = {REN.GTA4ColorTable(76,73,85)}
				-- CarCols[14] = {REN.GTA4ColorTable(77,5,85)}
				-- CarCols[15] = {REN.GTA4ColorTable(102,90,80)}
				-- CarCols[16] = {REN.GTA4ColorTable(106,90,80)}
				-- CarCols[17] = {REN.GTA4ColorTable(109,110,80)}
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

		CustomWheelModel = 'models/octoteam/vehicles/rancher_wheel.mdl',

		CustomWheelPosFL = Vector(65,35,-10),
		CustomWheelPosFR = Vector(65,-35,-10),
		CustomWheelPosRL = Vector(-51,35,-10),
		CustomWheelPosRR = Vector(-51,-35,-10),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,10),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-5,-20,33),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(3,-18,0),
				ang = Angle(0,-90,10),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-93,29,-7),
				ang = Angle(-110,0,0),
			},
			{
				pos = Vector(-93,24.6,-7),
				ang = Angle(-110,0,0),
			},
		},

		FrontHeight = 8,
		FrontConstant = 37000,
		FrontDamping = 1000,
		FrontRelativeDamping = 1000,

		RearHeight = 8,
		RearConstant = 37000,
		RearDamping = 1000,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3.5,

		MaxGrip = 60,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 32,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 42,
		PowerbandStart = 1700,
		PowerbandEnd = 4600,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 2,

		FuelFillPos = Vector(-20,40,0),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		AirFriction = -60,
		PowerBias = 0,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/rancher_idle.wav',

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

		Dash = { pos = Vector(24.509, 18.662, 23.368), ang = Angle(0.0, -90.0, 90.0) },
		Radio = { pos = Vector(28.869, 0.714, 18.205), ang = Angle(0.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(96.441, 0.050, 0.976), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-93.884, -18.597, 11.189), ang = Angle(-6.3, 180.0, -0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(15.540, -0.001, 43.671),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(18.865, 43.970, 30.316),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(18.995, -43.810, 30.073),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},

		CanAttachPackages = true,
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_rancher', V )

local light_table = {
	L_HeadLampPos = Vector(91,32,16),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(91,-32,16),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-92,39,6),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-92,-39,6),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(91,32,16),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,50),
		},
		{
			pos = Vector(91,-32,16),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,50),
		},
	},

	Headlamp_sprites = {
		{pos = Vector(91,32,16),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(91,-32,16),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
	},

	Rearlight_sprites = {
		{
			pos = Vector(-92,39,6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-92,-39,6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-92,39,10.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-92,-39,10.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-92,39,6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-92,-39,6),
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
				pos = Vector(91,32,10),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-92,39,14.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(26,22.5,22),
				material = 'gta4/dash_left',
				size = 1,
				color = Color(255,57,50,255),
			},]]
		},
		Right = {
			{
				pos = Vector(91,-32,10),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-92,-39,14.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(26,16.3,22),
				material = 'gta4/dash_right',
				size = 1,
				color = Color(255,57,50,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[4] = '',
				[11] = '',
				[10] = '',
			},
			Brake = {
				[4] = '',
				[11] = 'models/gta4/vehicles/rancher/rancher_lights_on',
				[10] = '',
			},
			Reverse = {
				[4] = '',
				[11] = '',
				[10] = 'models/gta4/vehicles/rancher/rancher_lights_on',
			},
			Brake_Reverse = {
				[4] = '',
				[11] = 'models/gta4/vehicles/rancher/rancher_lights_on',
				[10] = 'models/gta4/vehicles/rancher/rancher_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/rancher/rancher_lights_on',
				[11] = '',
				[10] = '',
			},
			Brake = {
				[4] = 'models/gta4/vehicles/rancher/rancher_lights_on',
				[11] = 'models/gta4/vehicles/rancher/rancher_lights_on',
				[10] = '',
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/rancher/rancher_lights_on',
				[11] = '',
				[10] = 'models/gta4/vehicles/rancher/rancher_lights_on',
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/rancher/rancher_lights_on',
				[11] = 'models/gta4/vehicles/rancher/rancher_lights_on',
				[10] = 'models/gta4/vehicles/rancher/rancher_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/rancher/rancher_lights_on',
				[11] = '',
				[10] = '',
			},
			Brake = {
				[4] = 'models/gta4/vehicles/rancher/rancher_lights_on',
				[11] = 'models/gta4/vehicles/rancher/rancher_lights_on',
				[10] = '',
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/rancher/rancher_lights_on',
				[11] = '',
				[10] = 'models/gta4/vehicles/rancher/rancher_lights_on',
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/rancher/rancher_lights_on',
				[11] = 'models/gta4/vehicles/rancher/rancher_lights_on',
				[10] = 'models/gta4/vehicles/rancher/rancher_lights_on',
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/rancher/rancher_lights_on'
			},
			right = {
				[7] = 'models/gta4/vehicles/rancher/rancher_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_rancher', light_table)