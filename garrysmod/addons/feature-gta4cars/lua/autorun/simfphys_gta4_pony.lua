local V = {
	Name = 'Pony',
	Model = 'models/octoteam/vehicles/pony.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 2500,
		Trunk = { 200 },

		EnginePos = Vector(85,0,10),

		LightsTable = 'gta4_pony',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,11))
			-- ent:SetBodyGroups('0'..math.random(0,1)..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =   {REN.GTA4ColorTable(11,11,12)}
				-- CarCols[2] =   {REN.GTA4ColorTable(13,13,12)}
				-- CarCols[3] =   {REN.GTA4ColorTable(20,20,12)}
				-- CarCols[4] =   {REN.GTA4ColorTable(23,23,12)}
				-- CarCols[5] =   {REN.GTA4ColorTable(31,31,12)}
				-- CarCols[6] =   {REN.GTA4ColorTable(56,56,12)}
				-- CarCols[7] =   {REN.GTA4ColorTable(77,77,12)}
				-- CarCols[8] =   {REN.GTA4ColorTable(95,95,12)}
				-- CarCols[9] =   {REN.GTA4ColorTable(41,41,41)}
				-- CarCols[10] =  {REN.GTA4ColorTable(48,48,48)}
				-- CarCols[11] =  {REN.GTA4ColorTable(64,64,64)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 2) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/pony_wheel.mdl',

		CustomWheelPosFL = Vector(75,38,-22),
		CustomWheelPosFR = Vector(75,-38,-22),
		CustomWheelPosRL = Vector(-75,38,-22),
		CustomWheelPosRR = Vector(-75,-38,-22),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,10),

		CustomSteerAngle = 35,

		SeatOffset = Vector(26,-23,30),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(32,-23,-3),
				ang = Angle(0,-90,10),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-108,14,-23),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 6,
		FrontConstant = 40000,
		FrontDamping = 2500,
		FrontRelativeDamping = 2500,

		RearHeight = 6,
		RearConstant = 40000,
		RearDamping = 2500,
		RearRelativeDamping = 2500,

		StrengthenSuspension = true,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 90,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 35,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 42,
		PowerbandStart = 1700,
		PowerbandEnd = 4800,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 3,

		FuelFillPos = Vector(-47,45,-14),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 90,

		AirFriction = -15,
		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/burrito_idle.wav',

		snd_low = 'octoteam/vehicles/burrito_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/burrito_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/burrito_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/burrito_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/burrito_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/speedo_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.1,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(55.160, 23.2, 23.322), ang = Angle(-0.0, -90.0, 79.2) },
		Radio = { pos = Vector(59.099, -0.065, 19.415), ang = Angle(-16.4, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(108.571, -0.008, -9.883), ang = Angle(-0.2, -0.0, 0.0) },
			Back = { pos = Vector(-111.838, 0.030, -14.323), ang = Angle(3.3, 180.0, -0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(44.949, 0.014, 42.977),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(55.039, 47.047, 29.117),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(55.253, -46.805, 30.006),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},

		CanAttachPackages = true,
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_pony', V )

local light_table = {
	L_HeadLampPos = Vector(102,30,7),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(102,-30,7),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-108,42,9),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-108,-42,9),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(102,30,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(102,-30,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(55.7,25,22.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(102,30,7),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(102,-30,7),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(55.7,26,22.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-108,42,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-108,-42,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-108,42,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-108,-42,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-107,42,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-107,-42,3),
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
				pos = Vector(101,38,7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(101,38,-1.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 20,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-108,42,15),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(56,28,24),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(101,-38,7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(101,-38,-1.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 20,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-108,-42,15),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(56,19,24),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[6] = '',
				[9] = '',
				[11] = '',
			},
			Brake = {
				[6] = '',
				[9] = 'models/gta4/vehicles/pony/pony_lights_on',
				[11] = '',
			},
			Reverse = {
				[6] = '',
				[9] = '',
				[11] = 'models/gta4/vehicles/pony/pony_lights_on'
			},
			Brake_Reverse = {
				[6] = '',
				[9] = 'models/gta4/vehicles/pony/pony_lights_on',
				[11] = 'models/gta4/vehicles/pony/pony_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[6] = 'models/gta4/vehicles/pony/pony_lights_on',
				[9] = 'models/gta4/vehicles/pony/pony_lights_on',
				[11] = '',
			},
			Brake = {
				[6] = 'models/gta4/vehicles/pony/pony_lights_on',
				[9] = 'models/gta4/vehicles/pony/pony_lights_on',
				[11] = '',
			},
			Reverse = {
				[6] = 'models/gta4/vehicles/pony/pony_lights_on',
				[9] = 'models/gta4/vehicles/pony/pony_lights_on',
				[11] = 'models/gta4/vehicles/pony/pony_lights_on'
			},
			Brake_Reverse = {
				[6] = 'models/gta4/vehicles/pony/pony_lights_on',
				[9] = 'models/gta4/vehicles/pony/pony_lights_on',
				[11] = 'models/gta4/vehicles/pony/pony_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[6] = 'models/gta4/vehicles/pony/pony_lights_on',
				[9] = 'models/gta4/vehicles/pony/pony_lights_on',
				[11] = '',
			},
			Brake = {
				[6] = 'models/gta4/vehicles/pony/pony_lights_on',
				[9] = 'models/gta4/vehicles/pony/pony_lights_on',
				[11] = '',
			},
			Reverse = {
				[6] = 'models/gta4/vehicles/pony/pony_lights_on',
				[9] = 'models/gta4/vehicles/pony/pony_lights_on',
				[11] = 'models/gta4/vehicles/pony/pony_lights_on'
			},
			Brake_Reverse = {
				[6] = 'models/gta4/vehicles/pony/pony_lights_on',
				[9] = 'models/gta4/vehicles/pony/pony_lights_on',
				[11] = 'models/gta4/vehicles/pony/pony_lights_on'
			},
		},
		turnsignals = {
			left = {
				[7] = 'models/gta4/vehicles/pony/pony_lights_on'
			},
			right = {
				[10] = 'models/gta4/vehicles/pony/pony_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_pony', light_table)