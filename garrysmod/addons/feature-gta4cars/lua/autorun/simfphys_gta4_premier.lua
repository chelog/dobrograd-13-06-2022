local V = {
	Name = 'Premier',
	Model = 'models/octoteam/vehicles/premier.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1100,
		Trunk = { 20 },

		EnginePos = Vector(70,0,10),

		LightsTable = 'gta4_premier',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(6,6,12)}
				-- CarCols[2] =  {REN.GTA4ColorTable(13,13,12)}
				-- CarCols[3] =  {REN.GTA4ColorTable(23,23,12)}
				-- CarCols[9] =  {REN.GTA4ColorTable(21,21,60)}
				-- CarCols[7] =  {REN.GTA4ColorTable(26,26,72)}
				-- CarCols[6] =  {REN.GTA4ColorTable(36,36,39)}
				-- CarCols[7] =  {REN.GTA4ColorTable(38,38,35)}
				-- CarCols[8] =  {REN.GTA4ColorTable(62,62,60)}
				-- CarCols[9] =  {REN.GTA4ColorTable(58,58,59)}
				-- CarCols[10] = {REN.GTA4ColorTable(64,64,59)}
				-- CarCols[11] = {REN.GTA4ColorTable(65,65,58)}
				-- CarCols[12] = {REN.GTA4ColorTable(76,76,50)}
				-- CarCols[13] = {REN.GTA4ColorTable(88,88,63)}
				-- CarCols[14] = {REN.GTA4ColorTable(99,99,27)}
				-- CarCols[15] = {REN.GTA4ColorTable(106,106,90)}
				-- CarCols[16] = {REN.GTA4ColorTable(117,117,59)}
				-- CarCols[17] = {REN.GTA4ColorTable(16,16,76)}
				-- CarCols[18] = {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[19] = {REN.GTA4ColorTable(15,15,93)}
				-- CarCols[20] = {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[21] = {REN.GTA4ColorTable(13,13,80)}
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

		CustomWheelModel = 'models/octoteam/vehicles/premier_wheel.mdl',

		CustomWheelPosFL = Vector(58,30,-9),
		CustomWheelPosFR = Vector(58,-30,-9),
		CustomWheelPosRL = Vector(-58,30,-9),
		CustomWheelPosRR = Vector(-58,-30,-9),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-7,-17,20),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(5,-17,-11),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-30,17,-11),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-30,-17,-11),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-95,17,-7),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-95,-17,-7),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 8,
		FrontConstant = 21000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 8,
		RearConstant = 21000,
		RearDamping = 800,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3.5,

		MaxGrip = 35,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 25,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 25,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-70,-30,20),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 35,

		AirFriction = -35,
		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/esperanto_idle.wav',
		BrakeSqueal = true,

		snd_low = 'octoteam/vehicles/esperanto_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/esperanto_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/esperanto_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/esperanto_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/esperanto_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/moonbeam_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(21.156, 14.869, 16.181), ang = Angle(-0.0, -90.0, 62.8) },
		Radio = { pos = Vector(28.309, 0.007, 7.612), ang = Angle(-19.0, 180.0, -0.0) },
		Plates = {
			Front = { pos = Vector(95.041, -0.011, -6.311), ang = Angle(7.0, 0, 0) },
			Back = { pos = Vector(-93.244, -0.002, 14.595), ang = Angle(-8, 180, 0) },
		},
		Mirrors = {
			top = {
				pos = Vector(14.677, -0.018, 29.757),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(28.433, 35.467, 18.306),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(28.399, -35.731, 18.051),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_premier', V )

local light_table = {
	L_HeadLampPos = Vector(81,26,6),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(81,26,6),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-92,25.5,15.5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-92,-25.5,15.5),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(81,26,6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(81,-26,6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(27,22,18),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(81,26,6),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(81,-26,6),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(26.5,22,17),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(92,20.5,-6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(92,-20.5,-6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-92,25.5,15.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-92,-25.5,15.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-92,25.5,15.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-92,-25.5,15.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-93,21.5,13.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-93,-21.5,13.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	ems_sounds = {'octoteam/vehicles/police/siren1.wav','octoteam/vehicles/police/siren2.wav','octoteam/vehicles/police/siren3.wav'},
	ems_sprites = {
		{
			pos = Vector(93.9, -10.2, -6.1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.035
		},
		{
			pos = Vector(93.9, 10.2, -6.1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(91.5, -9.1, 3.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.03
		},
		{
			pos = Vector(91.5, 9.1, 3.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.025
		},
		{
			pos = Vector(-71.0, -23.4, 22.9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-71.0, 23.4, 22.9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.034
		},
		{
			pos = Vector(16.4, -20.7, 30.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(16.4, -16, 30.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.034
		},
		{
			pos = Vector(16.4, -12, 30.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.033
		},
		{
			pos = Vector(16.4, -8, 30.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.032
		},
		{
			pos = Vector(16.4, 20.7, 30.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.035
		},
		{
			pos = Vector(16.4, 16, 30.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.034
		},
		{
			pos = Vector(16.4, 12, 30.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.033
		},
		{
			pos = Vector(16.4, 8, 30.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.032
		},
		{
			pos = Vector(29.5, -34.4, 15.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.035
		},
		{
			pos = Vector(29.5, 34.4, 15.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.034
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(77,29.5,8.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-93,26.5,12),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(27,19,19),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(77,-29.5,8.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-93,-26.5,12),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(27,13.5,19),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[9] = '',
				[10] = '',
				[11] = ''
			},
			Brake = {
				[9] = '',
				[10] = 'models/gta4/vehicles/premier/premier_lights_on',
				[11] = ''
			},
			Reverse = {
				[9] = '',
				[10] = '',
				[11] = 'models/gta4/vehicles/premier/premier_lights_on'
			},
			Brake_Reverse = {
				[9] = '',
				[10] = 'models/gta4/vehicles/premier/premier_lights_on',
				[11] = 'models/gta4/vehicles/premier/premier_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/premier/premier_lights_on',
				[10] = 'models/gta4/vehicles/premier/premier_lights_on',
				[11] = ''
			},
			Brake = {
				[9] = 'models/gta4/vehicles/premier/premier_lights_on',
				[10] = 'models/gta4/vehicles/premier/premier_lights_on',
				[11] = ''
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/premier/premier_lights_on',
				[10] = 'models/gta4/vehicles/premier/premier_lights_on',
				[11] = 'models/gta4/vehicles/premier/premier_lights_on'
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/premier/premier_lights_on',
				[10] = 'models/gta4/vehicles/premier/premier_lights_on',
				[11] = 'models/gta4/vehicles/premier/premier_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/premier/premier_lights_on',
				[10] = 'models/gta4/vehicles/premier/premier_lights_on',
				[11] = ''
			},
			Brake = {
				[9] = 'models/gta4/vehicles/premier/premier_lights_on',
				[10] = 'models/gta4/vehicles/premier/premier_lights_on',
				[11] = ''
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/premier/premier_lights_on',
				[10] = 'models/gta4/vehicles/premier/premier_lights_on',
				[11] = 'models/gta4/vehicles/premier/premier_lights_on'
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/premier/premier_lights_on',
				[10] = 'models/gta4/vehicles/premier/premier_lights_on',
				[11] = 'models/gta4/vehicles/premier/premier_lights_on'
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/premier/premier_lights_on'
			},
			right = {
				[8] = 'models/gta4/vehicles/premier/premier_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_premier', light_table)