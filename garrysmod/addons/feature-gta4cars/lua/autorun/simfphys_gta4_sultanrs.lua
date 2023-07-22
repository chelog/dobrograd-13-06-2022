local V = {
	Name = 'Sultan RS',
	Model = 'models/octoteam/vehicles/sultanrs.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Спортивные',
	SpawnOffset = Vector(0,0,0),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Спортивные',

	Members = {
		Mass = 1600,
		Trunk = { 35 },

		Backfire = true,

		EnginePos = Vector(60,0,10),

		LightsTable = 'gta4_sultanrs',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1) )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable2(0,2,1,0)}
				-- CarCols[2] =  {REN.GTA4ColorTable2(0,0,1,0)}
				-- CarCols[3] =  {REN.GTA4ColorTable2(1,0,2,0)}
				-- CarCols[4] =  {REN.GTA4ColorTable2(5,0,1,5)}
				-- CarCols[5] =  {REN.GTA4ColorTable2(12,0,1,0)}
				-- CarCols[6] =  {REN.GTA4ColorTable2(21,74,112,21)}
				-- CarCols[7] =  {REN.GTA4ColorTable2(29,0,30,0)}
				-- CarCols[8] =  {REN.GTA4ColorTable2(33,112,34,33)}
				-- CarCols[9] =  {REN.GTA4ColorTable2(69,0,59,69)}
				-- CarCols[10] = {REN.GTA4ColorTable2(69,90,56,69)}
				-- CarCols[11] = {REN.GTA4ColorTable2(83,0,59,83)}
				-- CarCols[12] = {REN.GTA4ColorTable2(85,2,88,85)}
				-- CarCols[13] = {REN.GTA4ColorTable2(89,0,89,0)}
				-- CarCols[14] = {REN.GTA4ColorTable2(102,0,101,0)}
				-- CarCols[15] = {REN.GTA4ColorTable2(124,0,124,124)}
				-- CarCols[16] = {REN.GTA4ColorTable2(126,0,126,0)}
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

		CustomWheelModel = 'models/octoteam/vehicles/sultanrs_wheel.mdl',

		CustomWheelPosFL = Vector(56,30,-3),
		CustomWheelPosFR = Vector(56,-30,-3),
		CustomWheelPosRL = Vector(-56,30,-3),
		CustomWheelPosRR = Vector(-56,-30,-3),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(8,0,-1),

		CustomSteerAngle = 40,

		SeatOffset = Vector(-10,-15,25),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(0,-15,-8),
				ang = Angle(0,-90,15),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(14,33,-8.5),
				ang = Angle(-90,-40,0),
			},
		},

		FrontHeight = 6,
		FrontConstant = 42000,
		FrontDamping = 1200,
		FrontRelativeDamping = 1200,

		RearHeight = 4,
		RearConstant = 42000,
		RearDamping = 1200,
		RearRelativeDamping = 1200,

		FastSteeringAngle = 15,
		SteeringFadeFastSpeed = 700,

		TurnSpeed = 7,
		CounterSteeringMul = 0.85,

		MaxGrip = 66,
		Efficiency = 1,
		GripOffset = 4,
		BrakePower = 40,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 8000,
		PeakTorque = 78,
		PowerbandStart = 1200,
		PowerbandEnd = 6800,
		Turbocharged = true,
		Supercharged = true,
		DoNotStall = false,

		FuelFillPos = Vector(-70,33,20),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		AirFriction = -150,
		PowerBias = 0.8,

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

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.12,0.27,0.38,0.45,0.6},

		Dash = { pos = Vector(20.354, 15.223, 19.3), ang = Angle(-0.0, -90.0, 69.9) },
		Radio = { pos = Vector(27.531, -1.430, 17.989), ang = Angle(-22.6, 180.0, -0.0) },
		Plates = {
			Front = { pos = Vector(91.715, 0.001, -3.949), ang = Angle(10.8, 0.0, -0.0) },
			Back = { pos = Vector(-96.149, 0.007, 14.360), ang = Angle(-10.5, 180.0, -0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(6.622, -0.033, 33.191),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(17.672, 33.804, 23.593),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(17.355, -33.862, 23.431),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_sultanrs', V )

local light_table = {
	L_HeadLampPos = Vector(76,29,9),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(76,-29,9),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-94,26,14),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-94,-26,14),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(76,29,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(76,-29,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(21,20,19.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(81,22,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(81,-22,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(21,19.2,19.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-94,26,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-94,-26,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-96,18,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-96,-18,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-95,25,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-95,-25,17),
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
				pos = Vector(-93,27,19),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(21,15.5,22.4),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(-93,-27,19),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(21,14.8,22.4),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[10] = '',
				[15] = '',
				[5] = '',
				[9] = ''
			},
			Brake = {
				[10] = '',
				[15] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[5] = '',
				[9] = ''
			},
			Reverse = {
				[10] = '',
				[15] = '',
				[5] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[9] = ''
			},
			Brake_Reverse = {
				[10] = '',
				[15] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[5] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[9] = ''
			},
		},
		on_lowbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[15] = '',
				[5] = '',
				[9] = ''
			},
			Brake = {
				[10] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[15] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[5] = '',
				[9] = ''
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[15] = '',
				[5] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[9] = ''
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[15] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[5] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[9] = ''
			},
		},
		on_highbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[15] = '',
				[5] = '',
				[9] = 'models/gta4/vehicles/sultan/sultan_lights_on'
			},
			Brake = {
				[10] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[15] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[5] = '',
				[9] = 'models/gta4/vehicles/sultan/sultan_lights_on'
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[15] = '',
				[5] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[9] = 'models/gta4/vehicles/sultan/sultan_lights_on'
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[15] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[5] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[9] = 'models/gta4/vehicles/sultan/sultan_lights_on'
			},
		},
		turnsignals = {
			left = {
				[13] = 'models/gta4/vehicles/sultan/sultan_lights_on'
			},
			right = {
				[6] = 'models/gta4/vehicles/sultan/sultan_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_sultanrs', light_table)