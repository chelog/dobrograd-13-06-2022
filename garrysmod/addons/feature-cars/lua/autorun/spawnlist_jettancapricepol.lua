AddCSLuaFile()
local light_table = {
	L_HeadLampPos = Vector(26,113,30),
	L_HeadLampAng = Angle(18,90,0),

	R_HeadLampPos = Vector(-26,113,30),
	R_HeadLampAng = Angle(18,90,0),

	L_RearLampPos = Vector(26,-113,30),
	L_RearLampAng = Angle(0,270,0),

	R_RearLampPos = Vector(-26,-113,30),
	R_RearLampAng = Angle(0,270,0),

	Headlight_sprites = {
		Vector(26,113,30),
		Vector(-26,113,30),
	},
	Headlamp_sprites = {
		Vector(33,113,30),
		Vector(-33,113,30),
	},
	Rearlight_sprites = {
		Vector(-26,-114,30),
		Vector(26,-114,30),
		Vector(-35,-114,30),
		Vector(35,-114,30),
		Vector(-17,-114,30),
		Vector(17,-114,30),
		Vector(-26,-114,28),
		Vector(26,-114,28),
		Vector(-35,-114,28),
		Vector(35,-114,28),
		Vector(-17,-114,28),
		Vector(17,-114,28),
	},
	Brakelight_sprites = {
		Vector(-26,-114,30),
		Vector(26,-114,30),
		Vector(-35,-114,30),
		Vector(35,-114,30),
		Vector(-17,-114,30),
		Vector(17,-114,30),
		Vector(-26,-114,28),
		Vector(26,-114,28),
		Vector(-35,-114,28),
		Vector(35,-114,28),
		Vector(-17,-114,28),
		Vector(17,-114,28),
		Vector(-26,-114,30),
		Vector(26,-114,30),
		Vector(-35,-114,30),
		Vector(35,-114,30),
		Vector(-17,-114,30),
		Vector(17,-114,30),
		Vector(-26,-114,28),
		Vector(26,-114,28),
		Vector(-35,-114,28),
		Vector(35,-114,28),
		Vector(-17,-114,28),
		Vector(17,-114,28),
	},
	Reverselight_sprites = {
		Vector(-10,-114,28),
		Vector(10,-114,28),
	},
	ems_sounds = {"simulated_vehicles/police/siren_1.wav","simulated_vehicles/police/siren_2.wav"},
	ems_sprites = {
		{
			pos = Vector(9,3,70),
			material = "sprites/light_glow02_add_noz",
			size = 100,
			Colors = {Color(0,5,255,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255)},
			Speed = 0.07,
		},
		{
			pos = Vector(17,3,70),
			material = "sprites/light_glow02_add_noz",
			size = 100,
			Colors = {Color(0,0,0,255),Color(0,5,255,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255)},
			Speed = 0.07,
		},
		{
			pos = Vector(24,3,70),
			material = "sprites/light_glow02_add_noz",
			size = 100,
			Colors = {Color(0,0,0,255),Color(0,0,0,255),Color(0,5,255,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255)},
			Speed = 0.07,
		},
		{
			pos = Vector(30,3,70),
			material = "sprites/light_glow02_add_noz",
			size = 100,
			Colors = {Color(0,0,0,255),Color(0,0,0,255),Color(0,5,255,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255)},
			Speed = 0.07,
		},
		{
			pos = Vector(-9,3,70),
			material = "sprites/light_glow02_add_noz",
			size = 100,
			Colors = {Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(255,0,0,255),Color(0,0,0,255),Color(0,0,0,255)},
			Speed = 0.07,
		},
		{
			pos = Vector(-17,3,70),
			material = "sprites/light_glow02_add_noz",
			size = 100,
			Colors = {Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(255,0,0,255),Color(0,0,0,255)},
			Speed = 0.07,
		},
		{
			pos = Vector(-24,3,70),
			material = "sprites/light_glow02_add_noz",
			size = 100,
			Colors = {Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(255,0,0,255)},
			Speed = 0.07,
		},
		{
			pos = Vector(-30,3,70),
			material = "sprites/light_glow02_add_noz",
			size = 100,
			Colors = {Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(255,0,0,255)},
			Speed = 0.07,
		},
		{
			pos = Vector(-28,0,70),
			material = "sprites/light_glow02_add_noz",
			size = 45,
			Colors = {Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(255,180,0,255)},
			Speed = 0.07,
		},
		{
			pos = Vector(28,0,70),
			material = "sprites/light_glow02_add_noz",
			size = 45,
			Colors = {Color(0,0,0,255),Color(0,0,0,255),Color(255,180,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255)},
			Speed = 0.07,
		},
	}
}
list.Set( "simfphys_lights", "polcaprice", light_table)
local V = {
	Name = "1989 Caprice Police",
	Model = "models/sentry/caprice.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Jettans Cars",

	Members = {
		Mass = 1800,
		FrontWheelMass = 70,
		RearWheelMass = 70,

		LightsTable = "polcaprice",

		FrontWheelRadius = 15,
		RearWheelRadius = 15,

		CustomMassCenter = Vector(0,0,0),
		SeatOffset = Vector(-2,1,-5),
		SeatPitch = 0,

		FuelFillPos = Vector(38,-80.3,35.54),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 75,

		SpeedoMax = 200,
		ModelInfo = {
			Bodygroups = {0,0,0,0,0,0},
			Color = Color(255,255,155,255),
			Skin = 0,
			WheelColor = Color(255,255,255,255)
		},
		PassengerSeats = {
			{
				pos = Vector(19,6,15),
				ang = Angle(0,0,15)
			}, {
				pos = Vector(-19,-29,15),
				ang = Angle(0,0,19)
			}, {
				pos = Vector(0,-29,15),
				ang = Angle(0,0,19)
			}, {
				pos = Vector(19,-29,15),
				ang = Angle(0,0,15)
			}
		},

		Backfire = f,
		ExhaustPositions = {
			{
				pos = Vector(28,-112,16),
				ang = Angle(90,-90,0),
				OnBodyGroups = { [4] = {0,2} }
			}
		},

		StrengthenSuspension = true,
		FrontHeight = 16,
		FrontConstant = 27000,
		FrontDamping = 1500,
		FrontRelativeDamping = 800,

		RearHeight = 16,
		RearConstant = 32000,
		RearDamping = 1500,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 35,
		Efficiency = 1,
		GripOffset = 0.05,
		BrakePower = 15,

		IdleRPM = 750,
		LimitRPM = 5500,

		PeakTorque = 90,
		PowerbandStart = 2000,
		PowerbandEnd = 6000,

		Turbocharged = false,
		Supercharged = false,
		PowerBias = 1,

		EngineSoundPreset = 1,

		snd_pitch = 1,
		snd_idle = "vehicles/sgmcars/caprice/idle.wav",

		snd_low = "simulated_vehicles/jeep/jeep_low.wav",

		snd_low_pitch = 0.9,

		snd_mid = "simulated_vehicles/jeep/jeep_mid.wav",
		snd_mid_gearup = "vehicles/sgmcars/caprice/second.wav",

		snd_mid_pitch = 1,

		Sound_Idle = "simulated_vehicles/misc/nanjing_loop.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "simulated_vehicles/misc/m50.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 58,
		Sound_MidFadeOutRate = 0.476,

		Sound_High = "simulated_vehicles/misc/v8high2.wav",
		Sound_HighPitch = 1,
		Sound_HighVolume = 0.75,
		Sound_HighFadeInRPMpercent = 58,
		Sound_HighFadeInRate = 0.19,

		Sound_Throttle = "",
		Sound_ThrottlePitch = 0,
		Sound_ThrottleVolume = 0,


		snd_horn = "simulated_vehicles/horn_3.wav",

		DifferentialGear = 0.7,
		Gears = {-0.1,0,0.1,0.18,0.25,0.31,0.4,0.52}

	}
}
list.Set( "simfphys_vehicles", "sim_fphys_polcaprice", V )
