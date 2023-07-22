local V = {
	Name = 'Admiral',
	Model = 'models/octoteam/vehicles/admiral.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1650,
		Trunk = { 35 },

		EnginePos = Vector(70,0,5),

		LightsTable = 'gta4_admiral',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,22)}
				-- CarCols[2] =  {REN.GTA4ColorTable(7,7,79)}
				-- CarCols[3] =  {REN.GTA4ColorTable(16,16,93)}
				-- CarCols[4] =  {REN.GTA4ColorTable(34,34,32)}
				-- CarCols[5] =  {REN.GTA4ColorTable(52,52,50)}
				-- CarCols[6] =  {REN.GTA4ColorTable(54,54,53)}
				-- CarCols[7] =  {REN.GTA4ColorTable(62,62,65)}
				-- CarCols[8] =  {REN.GTA4ColorTable(70,70,63)}
				-- CarCols[9] =  {REN.GTA4ColorTable(72,72,64)}
				-- CarCols[10] = {REN.GTA4ColorTable(102,102,105)}
				-- CarCols[11] = {REN.GTA4ColorTable(104,104,105)}
				-- CarCols[12] = {REN.GTA4ColorTable(116,116,122)}
				-- CarCols[13] = {REN.GTA4ColorTable(16,16,76)}
				-- CarCols[14] = {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[15] = {REN.GTA4ColorTable(15,15,93)}
				-- CarCols[16] = {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[17] = {REN.GTA4ColorTable(13,13,80)}
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

		CustomWheelModel = 'models/octoteam/vehicles/admiral_wheel.mdl',

		CustomWheelPosFL = Vector(65,35.35,-16),
		CustomWheelPosFR = Vector(65,-35.35,-16),
		CustomWheelPosRL = Vector(-65,35.35,-16),
		CustomWheelPosRR = Vector(-65,-35.35,-16),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 40,

		SeatOffset = Vector(-8,-19.5,13),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(4,-20,-18),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-36,20,-18),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-36,-20,-18),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-117.4,18.7,-17.6),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-117.4,23,-17.6),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 7,
		FrontConstant = 34000,
		FrontDamping = 1000,
		FrontRelativeDamping = 1000,

		RearHeight = 7,
		RearConstant = 34000,
		RearDamping = 1000,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 15,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 4.5,

		MaxGrip = 52,
		Efficiency = 0.9,
		GripOffset = 0,
		BrakePower = 32,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 48,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-91,-39,6),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/admiral_idle.wav',

		snd_low = 'octoteam/vehicles/admiral_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/admiral_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/admiral_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/admiral_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/admiral_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/admiral_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(24.1, 18.958, 10.751), ang = Angle(-0.0, -90.0, 79.6) },
		Radio = { pos = Vector(26.065, 0.010, 1.051), ang = Angle(-19.1, -180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(107.712, -0.000, -10.633), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-116.884, -0.001, 0.997), ang = Angle(-26.3, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(3.524, -0.002, 23.213),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(20.625, 38.713, 12.755),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(19.786, -38.372, 12.884),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_admiral', V )

local light_table = {
	L_HeadLampPos = Vector(101,26,-1),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(101,-26,-1),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-114,29,4),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-114,-29,4),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(101,26,-1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(101,-26,-1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(23.6,26.2,8.6),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(101,26,-1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(101,-26,-1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(23.8,26.2,9.7),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-114,29,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-116,16,4),
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
		{
			pos = Vector(-116,-16,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-118,16,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-116,29,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-118,-16,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-116,-29,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-115.8,22.8,2.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-115.8,-22.8,2.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	ems_sounds = {'octoteam/vehicles/police/siren1.wav','octoteam/vehicles/police/siren2.wav','octoteam/vehicles/police/siren3.wav'},
	ems_sprites = {
		{
			pos = Vector(21.4, -38.1, 11.1),
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
			pos = Vector(21.4, 38.1, 11.1),
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
			pos = Vector(102.6, -12.3, -1.2),
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
			pos = Vector(102.6, 12.3, -1.2),
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
			pos = Vector(-76.6, -28.9, 13.2),
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
			pos = Vector(-76.6, 28.9, 13.2),
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
			pos = Vector(-115.7, -8.4, 0.5),
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
			pos = Vector(-115.7, 8.4, 0.5),
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
			pos = Vector(105.6, -9.3, -11.3),
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
			pos = Vector(105.6, 9.3, -11.3),
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
			pos = Vector(5.8, 22, 25),
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
			pos = Vector(5.8, 18, 25),
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
			pos = Vector(5.8, 14, 25),
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
			pos = Vector(5.8, 10, 25),
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
			pos = Vector(5.8, -22, 25),
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
			pos = Vector(5.8, -18, 25),
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
			pos = Vector(5.8, -14, 25),
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
			pos = Vector(5.8, -10, 25),
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
	},
	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(95.2,35.5,-0.8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-111.6,37.4,2.2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(24.4,22,12),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(95.2,-35.5,-0.8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-111.6,-37.4,2.2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(24.4,16.3,12),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[4] = '',
				[5] = '',
				[10] = ''
			},
			Brake = {
				[4] = '',
				[5] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[10] = ''
			},
			Reverse = {
				[4] = '',
				[5] = '',
				[10] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
			Brake_Reverse = {
				[4] = '',
				[5] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[10] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[5] = '',
				[10] = ''
			},
			Brake = {
				[4] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[5] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[10] = ''
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[5] = '',
				[10] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[5] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[10] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[5] = '',
				[10] = ''
			},
			Brake = {
				[4] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[5] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[10] = ''
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[5] = '',
				[10] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[5] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[10] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
		},
		turnsignals = {
			left = {
				[8] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_admiral', light_table)