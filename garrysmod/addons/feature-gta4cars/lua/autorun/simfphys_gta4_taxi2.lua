local V = {
	Name = 'Taxi',
	Model = 'models/octoteam/vehicles/taxi2.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Сервис',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Сервис',

	Members = {
		Mass = 1450,
		Trunk = { 30 },

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_taxi2',

		OnSpawn = function(ent)
			-- ent:SetBodyGroups('0'..math.random(0,4)..math.random(0,1)..math.random(0,1)..math.random(0,1) )

			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(89,89,1)}
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

		CustomWheelModel = 'models/octoteam/vehicles/taxi2_wheel.mdl',

		ModelInfo = {
			WheelColor = Color(10,10,10),
		},

		CustomWheelPosFL = Vector(65,32,-16),
		CustomWheelPosFR = Vector(65,-32,-16),
		CustomWheelPosRL = Vector(-59,32,-16),
		CustomWheelPosRR = Vector(-59,-32,-16),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(0,-19.5,15),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(8,-20,-18),
				ang = Angle(0,-90,15),
				hasRadio = true
			},
			{
				pos = Vector(-27,20,-15),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-27,-20,-15),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-104.4,21.3,-15.2),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 7,
		FrontConstant = 28000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 7,
		RearConstant = 28000,
		RearDamping = 800,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3.5,

		MaxGrip = 45,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 25,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 39,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-82.4,-34.3,9.8),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 45,

		AirFriction = -45,
		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = .95,
		snd_idle = 'octoteam/vehicles/merit_idle.wav',

		snd_low = 'octoteam/vehicles/merit_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/merit_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/merit_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/merit_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/merit_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/taxi2_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(30.752, 18.121, 11.628), ang = Angle(-0.0, -90.0, 70.6) },
		Radio = { pos = Vector(33.077, 1.293, 2.084), ang = Angle(-21.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(105.428, 13.770, -11.570), ang = Angle(9.1, 12.8, -0.0) },
			Back = { pos = Vector(-102.606, -0.002, 6.751), ang = Angle(-9.2, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(18.062, 0.002, 25.635),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(28.599, 40.558, 12.955),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(28.430, -40.797, 12.255),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_taxi2', V )

local light_table = {
	L_HeadLampPos = Vector(95.5,29.2,-1.6),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(95.5,-29.2,-1.6),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-101.7,28,5.9),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-101.7,-28,5.9),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(95.5,29.2,-1.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(95.5,-29.2,-1.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(30.6,24.7,10.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(97.7,23.7,-2),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(97.7,-23.7,-2),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(30.6,24.7,9.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(98.7,29.4,-13.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(98.7,-29.4,-13.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-101.7,28,5.9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-101.7,-28,5.9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-102.7,20.7,5.9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-102.7,-20.7,5.9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-102.2,21.2,10.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-102.2,-21.2,10.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	ems_sounds = {'octoteam/vehicles/police/siren1.wav','octoteam/vehicles/police/siren2.wav','octoteam/vehicles/police/siren3.wav'},
	ems_sprites = {
		{
			pos = Vector(100.7, 15.2, 0.0),
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
			pos = Vector(100.7, -15.2, 0.0),
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
			Speed = 0.034
		},
		{
			pos = Vector(-9.9, -10.1, 34.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 45,
			Colors = {
				Color(255, 145, 0),
				Color(255, 145, 0),
				Color(0,0,0,0),
				--
				Color(255, 145, 0),
				Color(255, 145, 0),
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
				Color(255, 145, 0),
				Color(255, 145, 0),
				Color(0,0,0,0),
			},
			Speed = 0.035
		},
		{
			pos = Vector(-9.9, 10.1, 34.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 45,
			Colors = {
				Color(0,0,0,0),
				Color(0,0,0,0),
				Color(0,0,0,0),
				--
				Color(0,0,0,0),
				Color(0,0,0,0),
				Color(0,0,0,0),
				--
				Color(255, 145, 0),
				Color(255, 145, 0),
				Color(0,0,0,0),
				--
				Color(255, 145, 0),
				Color(255, 145, 0),
				Color(0,0,0,0),
				--
				Color(255, 145, 0),
				Color(255, 145, 0),
				Color(0,0,0,0),
				--
				Color(0,0,0,0),
				Color(0,0,0,0),
				Color(0,0,0,0),
			},
			Speed = 0.035
		},
		{
			pos = Vector(102.4, 11.1, -2.1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(255, 145, 0),
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
			pos = Vector(102.4, -11.1, -2.1),
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
			pos = Vector(-101.9, 8.6, 6.9),
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
			pos = Vector(-101.9, -8.6, 6.9),
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
			pos = Vector(-12.2, 33.4, 13.0),
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
			pos = Vector(-12.2, -33.4, 13.0),
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
			pos = Vector(29.6, -38.8, 9.0),
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
			pos = Vector(29.6, 38.8, 9.0),
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
			pos = Vector(15.9, 22.7, 27.1),
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
			pos = Vector(15.9, 18.7, 27.1),
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
			pos = Vector(15.9, 14.7, 27.1),
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
			pos = Vector(15.9, 10.7, 27.1),
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
			pos = Vector(15.9, -22.7, 27.1),
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
			pos = Vector(15.9, -18.7, 27.1),
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
			pos = Vector(15.9, -14.7, 27.1),
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
			pos = Vector(15.9, -10.7, 27.1),
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
			pos = Vector(-43.0, 22.9, 28.2),
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
			pos = Vector(-43.0, 18.9, 28.2),
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
			pos = Vector(-43.0, 14.9, 28.2),
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
			pos = Vector(-43.0, 10.9, 28.2),
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
			pos = Vector(-43.0, -22.9, 28.2),
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
			pos = Vector(-43.0, -18.9, 28.2),
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
			pos = Vector(-43.0, -14.9, 28.2),
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
			pos = Vector(-43.0, -10.9, 28.2),
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
				pos = Vector(92.4,33.4,-1.1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-100.8,29.6,10.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(31.3,20.8,12.4),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(92.4,-33.4,-1.1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-100.8,-29.6,10.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(31.3,15.5,12.4),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[11] = '',
				[10] = '',
				[9] = '',
				[12] = ''
			},
			Brake = {
				[11] = '',
				[10] = 'models/gta4/vehicles/merit/police2_lights_on',
				[9] = '',
				[12] = ''
			},
			Reverse = {
				[11] = '',
				[10] = '',
				[9] = 'models/gta4/vehicles/merit/police2_lights_on',
				[12] = ''
			},
			Brake_Reverse = {
				[11] = '',
				[10] = 'models/gta4/vehicles/merit/police2_lights_on',
				[9] = 'models/gta4/vehicles/merit/police2_lights_on',
				[12] = ''
			},
		},
		on_lowbeam = {
			Base = {
				[11] = 'models/gta4/vehicles/merit/police2_lights_on',
				[10] = '',
				[9] = '',
				[12] = ''
			},
			Brake = {
				[11] = 'models/gta4/vehicles/merit/police2_lights_on',
				[10] = 'models/gta4/vehicles/merit/police2_lights_on',
				[9] = '',
				[12] = ''
			},
			Reverse = {
				[11] = 'models/gta4/vehicles/merit/police2_lights_on',
				[10] = '',
				[9] = 'models/gta4/vehicles/merit/police2_lights_on',
				[12] = ''
			},
			Brake_Reverse = {
				[11] = 'models/gta4/vehicles/merit/police2_lights_on',
				[10] = 'models/gta4/vehicles/merit/police2_lights_on',
				[9] = 'models/gta4/vehicles/merit/police2_lights_on',
				[12] = ''
			},
		},
		on_highbeam = {
			Base = {
				[11] = 'models/gta4/vehicles/merit/police2_lights_on',
				[10] = '',
				[9] = '',
				[12] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
			Brake = {
				[11] = 'models/gta4/vehicles/merit/police2_lights_on',
				[10] = 'models/gta4/vehicles/merit/police2_lights_on',
				[9] = '',
				[12] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
			Reverse = {
				[11] = 'models/gta4/vehicles/merit/police2_lights_on',
				[10] = '',
				[9] = 'models/gta4/vehicles/merit/police2_lights_on',
				[12] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
			Brake_Reverse = {
				[11] = 'models/gta4/vehicles/merit/police2_lights_on',
				[10] = 'models/gta4/vehicles/merit/police2_lights_on',
				[9] = 'models/gta4/vehicles/merit/police2_lights_on',
				[12] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
		},
		turnsignals = {
			left = {
				[13] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
			right = {
				[8] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_taxi2', light_table)