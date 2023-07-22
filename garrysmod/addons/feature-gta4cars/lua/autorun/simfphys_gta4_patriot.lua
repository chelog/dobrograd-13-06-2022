local V = {
	Name = 'Patriot',
	Model = 'models/octoteam/vehicles/patriot.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 3200,
		Trunk = { 100 },

		EnginePos = Vector(70,0,20),

		LightsTable = 'gta4_patriot',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,5))
			-- ent:SetBodyGroups('0'..math.random(0,1)..math.random(0,1) )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,1)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,0,0   )}
				-- CarCols[3] =  {REN.GTA4ColorTable(6,6,8)}
				-- CarCols[4] =  {REN.GTA4ColorTable(0,0,74)}
				-- CarCols[5] =  {REN.GTA4ColorTable(1,1,92)}
				-- CarCols[6] =  {REN.GTA4ColorTable(7,7,93)}
				-- CarCols[7] =  {REN.GTA4ColorTable(10,10,93)}
				-- CarCols[8] =  {REN.GTA4ColorTable(13,13,79)}
				-- CarCols[9] =  {REN.GTA4ColorTable(15,15,8)}
				-- CarCols[10] = {REN.GTA4ColorTable(21,21,8)}
				-- CarCols[11] = {REN.GTA4ColorTable(36,36,35)}
				-- CarCols[12] = {REN.GTA4ColorTable(57,57,51)}
				-- CarCols[13] = {REN.GTA4ColorTable(62,62,64)}
				-- CarCols[14] = {REN.GTA4ColorTable(64,64,58)}
				-- CarCols[15] = {REN.GTA4ColorTable(78,78,84)}
				-- CarCols[16] = {REN.GTA4ColorTable(88,88,51)}
				-- CarCols[17] = {REN.GTA4ColorTable(0,0,1)}
				-- CarCols[18] = {REN.GTA4ColorTable(1,1,2)}
				-- CarCols[19] = {REN.GTA4ColorTable(4,4,2)}
				-- CarCols[20] = {REN.GTA4ColorTable(21,21,2)}
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

		CustomWheelModel = 'models/octoteam/vehicles/patriot_wheel.mdl',

		CustomWheelPosFL = Vector(72,36,-10),
		CustomWheelPosFR = Vector(72,-36,-10),
		CustomWheelPosRL = Vector(-71,36,-10),
		CustomWheelPosRR = Vector(-71,-36,-10),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,-2),

		CustomSteerAngle = 35,

		SeatOffset = Vector(5,-19,35),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(15,-20,3),
				ang = Angle(0,-90,10),
				hasRadio = true
			},
			{
				pos = Vector(-35,20,3),
				ang = Angle(0,-90,10)
			},
			{
				pos = Vector(-35,-20,3),
				ang = Angle(0,-90,10)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-39,43,-9),
				ang = Angle(-90,-90,0),
				OnBodyGroups = {
					[1] = {0},
				}
			},
			{
				pos = Vector(-13.7,46.4,-9.9),
				ang = Angle(-90,-90,0),
				OnBodyGroups = {
					[1] = {1},
				}
			},
			{
				pos = Vector(-15.8,46.4,-7.6),
				ang = Angle(-90,-90,0),
				OnBodyGroups = {
					[1] = {1},
				}
			},
			{
				pos = Vector(-13.7,-46.4,-9.9),
				ang = Angle(-90,90,0),
				OnBodyGroups = {
					[1] = {1},
				}
			},
			{
				pos = Vector(-15.8,-46.4,-7.6),
				ang = Angle(-90,90,0),
				OnBodyGroups = {
					[1] = {1},
				}
			},
		},

		FrontHeight = 15,
		FrontConstant = 28000,
		FrontDamping = 2000,
		FrontRelativeDamping = 2000,

		RearHeight = 15,
		RearConstant = 28000,
		RearDamping = 2000,
		RearRelativeDamping = 2000,

		StrengthenSuspension = true,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3.5,

		MaxGrip = 78,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 4500,
		PeakTorque = 75,
		PowerbandStart = 1700,
		PowerbandEnd = 4300,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 3,

		FuelFillPos = Vector(-80,43,22),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 100,

		AirFriction = -45,
		PowerBias = 0,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/patriot_idle.wav',

		snd_low = 'octoteam/vehicles/patriot_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/patriot_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/patriot_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/patriot_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/patriot_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/patriot_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.1,0,0.1,0.16,0.23,0.32,0.42},

		Dash = { pos = Vector(32.123, 18.146, 28.268), ang = Angle(-0.0, -90.0, 73.9) },
		Radio = { pos = Vector(39.646, -0.013, 27.583), ang = Angle(-24.6, -180.0, -0.0) },
		Plates = {
			Front = { pos = Vector(108.397, -0.000, -0.832), ang = Angle(1.3, 0.0, -0.0) },
			Back = { pos = Vector(-103.991, 0.021, 16.574), ang = Angle(-0.9, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(41.931, 0.005, 46.332),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(38.821, 46.975, 32.626),
				w = 1 / 5,
				ratio = 3 / 5,
			},
			right = {
				pos = Vector(38.886, -46.202, 31.039),
				w = 1 / 5,
				ratio = 3 / 5,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_patriot', V )

local light_table = {
	L_HeadLampPos = Vector(104,24,17),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(104,-24,17),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-102.7,33.6,39.6),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-102.7,-33.6,39.6),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(104,24,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(104,-24,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(37,19,27),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(255,57,50,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(104,24,17),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(104,-24,17),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(37,20,27),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(255,57,50,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-102.7,33.6,39.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-102.7,-33.6,39.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-103.7,34.4,34.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-103.7,-34.4,34.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-104,35,31.1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-104,-35,31.1),
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
				pos = Vector(101,35.9,15.8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-102,32.9,44.8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(37,21,27),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(255,57,50,255),
			},]]
		},
		Right = {
			{
				pos = Vector(101,-35.9,15.8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-102,-32.9,44.8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(37,17,27),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(255,57,50,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[6] = '',
				[9] = '',
				[11] = ''
			},
			Brake = {
				[6] = '',
				[9] = 'models/gta4/vehicles/patriot/patriot_lights_on',
				[11] = ''
			},
			Reverse = {
				[6] = '',
				[9] = '',
				[11] = 'models/gta4/vehicles/patriot/patriot_lights_on'
			},
			Brake_Reverse = {
				[6] = '',
				[9] = 'models/gta4/vehicles/patriot/patriot_lights_on',
				[11] = 'models/gta4/vehicles/patriot/patriot_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[6] = 'models/gta4/vehicles/patriot/patriot_lights_on',
				[9] = '',
				[11] = ''
			},
			Brake = {
				[6] = 'models/gta4/vehicles/patriot/patriot_lights_on',
				[9] = 'models/gta4/vehicles/patriot/patriot_lights_on',
				[11] = ''
			},
			Reverse = {
				[6] = 'models/gta4/vehicles/patriot/patriot_lights_on',
				[9] = '',
				[11] = 'models/gta4/vehicles/patriot/patriot_lights_on'
			},
			Brake_Reverse = {
				[6] = 'models/gta4/vehicles/patriot/patriot_lights_on',
				[9] = 'models/gta4/vehicles/patriot/patriot_lights_on',
				[11] = 'models/gta4/vehicles/patriot/patriot_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[6] = 'models/gta4/vehicles/patriot/patriot_lights_on',
				[9] = '',
				[11] = ''
			},
			Brake = {
				[6] = 'models/gta4/vehicles/patriot/patriot_lights_on',
				[9] = 'models/gta4/vehicles/patriot/patriot_lights_on',
				[11] = ''
			},
			Reverse = {
				[6] = 'models/gta4/vehicles/patriot/patriot_lights_on',
				[9] = '',
				[11] = 'models/gta4/vehicles/patriot/patriot_lights_on'
			},
			Brake_Reverse = {
				[6] = 'models/gta4/vehicles/patriot/patriot_lights_on',
				[9] = 'models/gta4/vehicles/patriot/patriot_lights_on',
				[11] = 'models/gta4/vehicles/patriot/patriot_lights_on'
			},
		},
		turnsignals = {
			left = {
				[7] = 'models/gta4/vehicles/patriot/patriot_lights_on'
			},
			right = {
				[10] = 'models/gta4/vehicles/patriot/patriot_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_patriot', light_table)