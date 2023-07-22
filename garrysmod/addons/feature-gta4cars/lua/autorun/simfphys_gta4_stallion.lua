local V = {
	Name = 'Stallion',
	Model = 'models/octoteam/vehicles/stallion.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Маслкары',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Маслкары',

	Members = {
		Mass = 1700.0,

		EnginePos = Vector(70,0,10),

		LightsTable = 'gta4_stallion',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,2)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,1)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,0,124)}
				-- CarCols[3] =  {REN.GTA4ColorTable(33,0,28)}
				-- CarCols[4] =  {REN.GTA4ColorTable(34,0,35)}
				-- CarCols[5] =  {REN.GTA4ColorTable(38,0,44)}
				-- CarCols[6] =  {REN.GTA4ColorTable(49,0,66)}
				-- CarCols[7] =  {REN.GTA4ColorTable(53,0,51)}
				-- CarCols[8] =  {REN.GTA4ColorTable(56,0,51)}
				-- CarCols[9] =  {REN.GTA4ColorTable(58,0,106)}
				-- CarCols[10] = {REN.GTA4ColorTable(59,0,51)}
				-- CarCols[11] = {REN.GTA4ColorTable(62,0,71)}
				-- CarCols[12] = {REN.GTA4ColorTable(64,0,71)}
				-- CarCols[13] = {REN.GTA4ColorTable(69,0,74)}
				-- CarCols[14] = {REN.GTA4ColorTable(74,0,74)}
				-- CarCols[15] = {REN.GTA4ColorTable(76,0,74)}
				-- CarCols[16] = {REN.GTA4ColorTable(84,0,74)}
				-- CarCols[17] = {REN.GTA4ColorTable(106,0,106)}
				-- CarCols[18] = {REN.GTA4ColorTable(21,0,75)}
				-- CarCols[19] = {REN.GTA4ColorTable(16,0,93)}
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

		CustomWheelModel = 'models/octoteam/vehicles/stallion_wheel.mdl',

		CustomWheelPosFL = Vector(62,34,-8),
		CustomWheelPosFR = Vector(62,-34,-8),
		CustomWheelPosRL = Vector(-61,34,-8),
		CustomWheelPosRR = Vector(-61,-34,-8),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-19,-19,23),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-5,-17,-10),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-109,14,-7),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 13,
		FrontConstant = 18000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 13,
		RearConstant = 18000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 73,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 15,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 140.0,
		PowerbandStart = 1500,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-60,39,18),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 80,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/vigero_idle.wav',

		snd_low = 'octoteam/vehicles/vigero_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/vigero_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/vigero_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/vigero_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/vigero_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/stallion_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.20,
		Gears = {-0.3,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_stallion', V )

local light_table = {
	L_HeadLampPos = Vector(100,35,8),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(100,-35,8),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-114,29,4),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-114,-29,4),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(100,35,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(100,-35,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
	},

	Headlamp_sprites = {
		{pos = Vector(100,35,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(100,-35,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
	},

	Rearlight_sprites = {
		{
			pos = Vector(-114,29,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-114,-29,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-114,29,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-114,-29,4),
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
				pos = Vector(-114,17,4.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 60,
				color = Color(255,0,0,150),
			},
		},
		Right = {
			{
				pos = Vector(-114,-17,4.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 60,
				color = Color(255,0,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[11] = '',
				[7] = '',
			},
			Brake = {
				[11] = '',
				[7] = 'models/gta4/vehicles/stallion/stallion_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[11] = 'models/gta4/vehicles/stallion/stallion_lights_on',
				[7] = 'models/gta4/vehicles/stallion/stallion_lights_on',
			},
			Brake = {
				[11] = 'models/gta4/vehicles/stallion/stallion_lights_on',
				[7] = 'models/gta4/vehicles/stallion/stallion_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[11] = 'models/gta4/vehicles/stallion/stallion_lights_on',
				[7] = 'models/gta4/vehicles/stallion/stallion_lights_on',
			},
			Brake = {
				[11] = 'models/gta4/vehicles/stallion/stallion_lights_on',
				[7] = 'models/gta4/vehicles/stallion/stallion_lights_on',
			},
		},
		turnsignals = {
			left = {
				[6] = 'models/gta4/vehicles/stallion/stallion_lights_on',
			},
			right = {
				[8] = 'models/gta4/vehicles/stallion/stallion_lights_on',
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_stallion', light_table)