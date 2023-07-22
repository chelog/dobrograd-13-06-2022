local V = {
	Name = 'Sabre GT',
	Model = 'models/octoteam/vehicles/sabregt.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Маслкары',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Маслкары',

	Members = {
		Mass = 1550,
		Trunk = { 30 },

		EnginePos = Vector(60,0,0),

		LightsTable = 'gta4_sabregt',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,2)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,49)}
				-- CarCols[2] =  {REN.GTA4ColorTable(38,38,85)}
				-- CarCols[3] =  {REN.GTA4ColorTable(0,97,102)}
				-- CarCols[4] =  {REN.GTA4ColorTable(3,0,12)}
				-- CarCols[5] =  {REN.GTA4ColorTable(6,6,4)}
				-- CarCols[6] =  {REN.GTA4ColorTable(11,4,12)}
				-- CarCols[7] =  {REN.GTA4ColorTable(13,13,12)}
				-- CarCols[8] =  {REN.GTA4ColorTable(16,95,90)}
				-- CarCols[9] =  {REN.GTA4ColorTable(24,1,12)}
				-- CarCols[10] = {REN.GTA4ColorTable(21,21,12)}
				-- CarCols[11] = {REN.GTA4ColorTable(23,23,2)}
				-- CarCols[12] = {REN.GTA4ColorTable(31,31,27)}
				-- CarCols[13] = {REN.GTA4ColorTable(32,113,34)}
				-- CarCols[14] = {REN.GTA4ColorTable(34,12,34)}
				-- CarCols[15] = {REN.GTA4ColorTable(49,13,41)}
				-- CarCols[16] = {REN.GTA4ColorTable(52,0,59)}
				-- CarCols[17] = {REN.GTA4ColorTable(62,13,69)}
				-- CarCols[18] = {REN.GTA4ColorTable(76,4,76)}
				-- CarCols[19] = {REN.GTA4ColorTable(82,85,76)}
				-- CarCols[20] = {REN.GTA4ColorTable(87,8,76)}
				-- CarCols[21] = {REN.GTA4ColorTable(89,0,4)}
				-- CarCols[22] = {REN.GTA4ColorTable(92,95,90)}
				-- CarCols[23] = {REN.GTA4ColorTable(95,95,2)}
				-- CarCols[24] = {REN.GTA4ColorTable(106,103,2)}
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

		CustomWheelModel = 'models/octoteam/vehicles/sabregt_wheel.mdl',

		CustomWheelPosFL = Vector(60,32,-9),
		CustomWheelPosFR = Vector(60,-32,-9),
		CustomWheelPosRL = Vector(-59,32,-9),
		CustomWheelPosRR = Vector(-59,-32,-9),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-15,-20,18),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(0,-18,-13),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-110.5,22.9,-5.4),
				ang = Angle(-90,-10,0),
			},
			{
				pos = Vector(-110.5,-22.9,-5.4),
				ang = Angle(-90,10,0),
			},
		},

		FrontHeight = 7,
		FrontConstant = 29000,
		FrontDamping = 850,
		FrontRelativeDamping = 850,

		RearHeight = 7,
		RearConstant = 29000,
		RearDamping = 850,
		RearRelativeDamping = 850,

		FastSteeringAngle = 12,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 4.5,
		CounterSteeringMul = 0.83,

		MaxGrip = 44,
		Efficiency = 0.92,
		GripOffset = 0,
		BrakePower = 32,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 7000,
		PeakTorque = 58,
		PowerbandStart = 1200,
		PowerbandEnd = 6800,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 1.25,

		FuelFillPos = Vector(-58,-38,15),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/dukes_idle.wav',

		snd_low = 'octoteam/vehicles/vigero_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/vigero_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/vigero_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/vigero_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/vigero_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/sabre_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.35,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(11.600, 18.997, 12.176), ang = Angle(-0.0, -90.0, 66.6) },
		Radio = { pos = Vector(14.656, 2.860, 8.776), ang = Angle(11.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(99.402, 0.011, -6.936), ang = Angle(10.5, -0.0, 0.0) },
			Back = { pos = Vector(-110.567, -0.000, -1.501), ang = Angle(-0.3, 180.0, -0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(7.644, -0.000, 27.300),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(16.751, 37.706, 16.879),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(16.516, -37.297, 19.299),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_sabregt', V )

local light_table = {
	L_HeadLampPos = Vector(92,31.4,4.6),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(92,-31.4,4.6),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-111,22.8,5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-111,-22.8,5),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(92,31.4,4.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(92,-31.4,4.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(93,24.4,4.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(93,-24.4,4.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(12,28,13),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(92,31.4,4.6),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(92,-31.4,4.6),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(93,24.4,4.6),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(93,-24.4,4.6),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(11,28,12),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-111,22.8,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-111,-22.8,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-111,22.8,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-111,-22.8,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-111,27,2.1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-111,22.8,2.1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-111,-27,2.1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-111,-22.8,2.1),
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
				pos = Vector(95,27.9,-4.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 60,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-111,27,5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 60,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(12,20.5,13),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(95,-27.9,-4.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 60,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-111,-27,5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 60,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(12,17,13),
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
				[10] = ''
			},
			Reverse = {
				[5] = '',
				[10] = 'models/gta4/vehicles/sabre/sabreturbo_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/sabre/sabreturbo_lights_on',
				[10] = ''
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/sabre/sabreturbo_lights_on',
				[10] = 'models/gta4/vehicles/sabre/sabreturbo_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/sabre/sabreturbo_lights_on',
				[10] = ''
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/sabre/sabreturbo_lights_on',
				[10] = 'models/gta4/vehicles/sabre/sabreturbo_lights_on'
			},
		},
		turnsignals = {
			left = {
				[8] = 'models/gta4/vehicles/sabre/sabreturbo_lights_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/sabre/sabreturbo_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_sabregt', light_table)