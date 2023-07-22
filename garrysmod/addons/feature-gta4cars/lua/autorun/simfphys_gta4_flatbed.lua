local V = {
	Name = 'Flatbed',
	Model = 'models/octoteam/vehicles/flatbed.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Индустриальные',
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Индустриальные',

	Members = {
		Mass = 12000.0,

		EnginePos = Vector(140,0,50),

		LightsTable = 'gta4_flatbed',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(1,1,8)}
				-- CarCols[2] =  {REN.GTA4ColorTable(6,6,8)}
				-- CarCols[3] =  {REN.GTA4ColorTable(11,11,12)}
				-- CarCols[4] =  {REN.GTA4ColorTable(12,12,12)}
				-- CarCols[5] =  {REN.GTA4ColorTable(31,31,31)}
				-- CarCols[6] =  {REN.GTA4ColorTable(40,40,40)}
				-- CarCols[7] =  {REN.GTA4ColorTable(52,53,53)}
				-- CarCols[8] =  {REN.GTA4ColorTable(54,54,54)}
				-- CarCols[9] =  {REN.GTA4ColorTable(56,56,56)}
				-- CarCols[10] = {REN.GTA4ColorTable(70,70,70)}
				-- CarCols[11] = {REN.GTA4ColorTable(73,73,73)}
				-- CarCols[12] = {REN.GTA4ColorTable(77,77,76)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4Flatbed(ent, math.random(0,2))
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

		CustomWheelPosFL = Vector(147,50,-12),
		CustomWheelPosFR = Vector(147,-50,-12),
		CustomWheelPosML = Vector(-88,43,-12),
		CustomWheelPosMR = Vector(-88,-43,-12),
		CustomWheelPosRL = Vector(-146,43,-12),
		CustomWheelPosRR = Vector(-146,-43,-12),
		CustomWheelAngleOffset = Angle(0,-90,0),

		FrontWheelRadius = 24.4,
		RearWheelRadius = 22.3,

		CustomMassCenter = Vector(0,0,25),

		CustomSteerAngle = 40,

		SeatOffset = Vector(45,-27,90),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(65,-25,45),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(47,53,149),
				ang = Angle(0,0,0),
			},
			{
				pos = Vector(47,-53,149),
				ang = Angle(0,0,0),
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
		LimitRPM = 4500,
		PeakTorque = 115.0,
		PowerbandStart = 1700,
		PowerbandEnd = 4000,
		Turbocharged = false,
		Supercharged = true,
		DoNotStall = false,

		FuelFillPos = Vector(60,55,10),
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

		DifferentialGear = 0.10,
		Gears = {-0.6,0,0.2,0.35,0.5,0.75,1,1.25},

		Dash = { pos = Vector(91.652, 25.123, 69.482), ang = Angle(-0.0, -90.0, 62.5) },
		Radio = { pos = Vector(93.214, 2.981, 68.736), ang = Angle(-26.7, 155.1, 3.3) },
		Plates = {
			Front = { pos = Vector(184.269, 0, -9.726), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-195.942, 0, 5.937), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			left = {
				pos = Vector(78.544, 64.902, 86.892),
				h = 3 / 4,
				ratio = 1 / 2.5,
			},
			right = {
				pos = Vector(78.544, -64.902, 86.892),
				h = 3 / 4,
				ratio = 1 / 2.5,
			},
		},

		CanAttachPackages = true,
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_flatbed', V )

local light_table = {
	L_HeadLampPos = Vector(171,46,31),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(171,-46,31),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-197,28,17),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-197,-28,17),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(171,46,31),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(171,-46,31),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(92,18,70),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(171,46,31),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(171,-46,31),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(92.8,18,71.4),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-197,28,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-197,-28,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-197,38,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-197,-38,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(165,54,31),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-197,48,17),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(92.8,30,71.4),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(165,-54,31),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-197,-48,17),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(92.8,24,71.4),
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
				[9] = '',
			},
			Brake = {
				[5] = '',
				[9] = 'models/gta4/vehicles/flatbed/detail2_on',
			},
		},
		on_lowbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/flatbed/detail2_on',
				[9] = '',
			},
			Brake = {
				[5] = 'models/gta4/vehicles/flatbed/detail2_on',
				[9] = 'models/gta4/vehicles/flatbed/detail2_on',
			},
		},
		on_highbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/flatbed/detail2_on',
				[9] = '',
			},
			Brake = {
				[5] = 'models/gta4/vehicles/flatbed/detail2_on',
				[9] = 'models/gta4/vehicles/flatbed/detail2_on',
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/flatbed/detail2_on'
			},
			right = {
				[11] = 'models/gta4/vehicles/flatbed/detail2_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_flatbed', light_table)
