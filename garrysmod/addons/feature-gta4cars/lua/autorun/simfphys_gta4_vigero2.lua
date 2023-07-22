local V = {
	Name = 'Vigero (Beater)',
	Model = 'models/octoteam/vehicles/vigero2.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Маслкары',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Маслкары',

	Members = {
		Mass = 1700.0,

		EnginePos = Vector(60,0,0),

		LightsTable = 'gta4_vigero2',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,1))
			-- ent:SetBodyGroups('0'..math.random(0,2)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(9,9,1)}
				-- CarCols[2] =  {REN.GTA4ColorTable(13,13,1)}
				-- CarCols[3] =  {REN.GTA4ColorTable(17,17,1)}
				-- CarCols[4] =  {REN.GTA4ColorTable(25,25,1)}
				-- CarCols[5] =  {REN.GTA4ColorTable(30,30,1)}
				-- CarCols[6] =  {REN.GTA4ColorTable(37,37,1)}
				-- CarCols[7] =  {REN.GTA4ColorTable(40,40,1)}
				-- CarCols[8] =  {REN.GTA4ColorTable(54,54,1)}
				-- CarCols[9] =  {REN.GTA4ColorTable(57,57,1)}
				-- CarCols[10] = {REN.GTA4ColorTable(65,65,1)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
			REN.GTA4BeaterInit(ent)
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
			REN.GTA4Beater(ent)
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/vigero2_wheel.mdl',

		CustomWheelPosFL = Vector(60,32,-16),
		CustomWheelPosFR = Vector(60,-32,-16),
		CustomWheelPosRL = Vector(-60,32,-16),
		CustomWheelPosRR = Vector(-60,-32,-16),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-18,-17,12),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-5,-17,-20),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-90.1,20.9,-19.2),
				ang = Angle(-100,-20,0),
				OnBodyGroups = {
					[1] = {0},
				}
			},
			{
				pos = Vector(-94,-17.5,-18.8),
				ang = Angle(-100,20,0),
				OnBodyGroups = {
					[1] = {1},
				}
			},
			{
				pos = Vector(-90.1,20.9,-19.2),
				ang = Angle(-100,-20,0),
				OnBodyGroups = {
					[1] = {2},
				}
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

		MaxGrip = 73,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 30,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6500,
		PeakTorque = 130.0,
		PowerbandStart = 1500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-68,37,3),
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

		snd_horn = 'octoteam/vehicles/horns/vigero2_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.17,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_vigero2', V )

local light_table = {
	L_HeadLampPos = Vector(90.4,27.5,-4.8),
	L_HeadLampAng = Angle(25,-15,0),
	R_HeadLampPos = Vector(90,-28,-4),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-99,26,4),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-99,-26,4),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(90.4,27.5,-4.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(90,-28,-4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
	},

	Headlamp_sprites = {
		{pos = Vector(90,28,-4),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(90,-28,-4),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
	},

	Rearlight_sprites = {
		{
			pos = Vector(-99,26,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-99,-26,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-99,26,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-99,-26,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-99,27,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-99,-27,0),
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
				pos = Vector(-99,32,0),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
		},
		Right = {
			{
				pos = Vector(-99,-32,0),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[9] = '',
				[6] = '',
				[4] = '',
			},
			Brake = {
				[9] = '',
				[6] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = '',
			},
			Reverse = {
				[9] = '',
				[6] = '',
				[4] = 'models/gta4/vehicles/vigero/vigero_lights_on',
			},
			Brake_Reverse = {
				[9] = '',
				[6] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = 'models/gta4/vehicles/vigero/vigero_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[6] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = '',
			},
			Brake = {
				[9] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[6] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = '',
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[6] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = 'models/gta4/vehicles/vigero/vigero_lights_on',
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[6] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = 'models/gta4/vehicles/vigero/vigero_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[6] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = '',
			},
			Brake = {
				[9] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[6] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = '',
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[6] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = 'models/gta4/vehicles/vigero/vigero_lights_on',
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[6] = 'models/gta4/vehicles/vigero/vigero_lights_on',
				[4] = 'models/gta4/vehicles/vigero/vigero_lights_on',
			},
		},
		turnsignals = {
			left = {
				[8] = 'models/gta4/vehicles/vigero/vigero_lights_on'
			},
			right = {
				[7] = 'models/gta4/vehicles/vigero/vigero_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_vigero2', light_table)