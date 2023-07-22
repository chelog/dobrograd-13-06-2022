local V = {
	Name = "Bandito",
	Model = "models/octocar/novelty/bandito.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Novelty",
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1000,

		EnginePos = Vector(-35,0,8),

		LightsTable = "bandito",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/novelty/bandito_wheel.mdl",
		CustomWheelModel_R = "models/octocar/novelty/bandito_r_wheel.mdl",
		FrontWheelRadius = 9,
		RearWheelRadius = 14,
		CustomWheelPosFL = Vector(62.6,30.2,-18),
		CustomWheelPosFR = Vector(62.6,-30.2,-18),
		CustomWheelPosRL = Vector(-32.4,31.3,-15.4),
		CustomWheelPosRR = Vector(-32.4,-31.3,-15.4),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-11,0,16),
		SeatPitch = -7,
		SeatYaw = 90,

		PassengerSeats = {

		},

		ExhaustPositions = {
			{
				pos = Vector(-57.9,-15.8,-2.8),
				ang = Angle(70,180,0),
			},
			{
				pos = Vector(-57.9,15.8,-2.8),
				ang = Angle(70,180,0),
			},
			{
				pos = Vector(-49.6,-19,-1.4),
				ang = Angle(70,180,0),
			},
			{
				pos = Vector(-49.6,19,-1.4),
				ang = Angle(70,180,0),
			}
		},

		FrontHeight = 7,
		FrontConstant = 30000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 6,
		RearConstant = 30000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 4,

		MaxGrip = 44,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 40,

		IdleRPM = 300,
		LimitRPM = 5000,
		PeakTorque = 80,
		PowerbandStart = 600,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-25.5,11.5,13.3),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 30,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_108/sound_002.wav",
		Sound_IdlePitch = 1.3,

		Sound_Mid = "dbg/cars/bank_108/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_108/sound_001.wav",
		Sound_HighPitch = 1.2,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_108/sound_001.wav",
		Sound_ThrottlePitch = 1.1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.17,0,0.15,0.28,0.44,0.61}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_bandito", V )

local V = {
	Name = "BF Injection",
	Model = "models/octocar/novelty/bfinject.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Novelty",
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1200,

		EnginePos = Vector(-40,0,8),

		LightsTable = "bfinject",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/novelty/bfinject_wheel.mdl",
		CustomWheelPosFL = Vector(38.8,35.6,-9.7),
		CustomWheelPosFR = Vector(38.8,-35.6,-9.7),
		CustomWheelPosRL = Vector(-38.8,36,-10),
		CustomWheelPosRR = Vector(-38.8,-36,-10),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-11,-14,19),
		SeatPitch = -7,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(0,-14,-10),
				ang = Angle(0,-90,26)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-59,-18.3,-8.2),
				ang = Angle(70,180,0),
			},
			{
				pos = Vector(-59,18.3,-8.2),
				ang = Angle(70,180,0),
			},
			{
				pos = Vector(-59,-18.3,-8.2),
				ang = Angle(70,180,0),
			},
			{
				pos = Vector(-59,18.3,-8.2),
				ang = Angle(70,180,0),
			}
		},

		FrontHeight = 7,
		FrontConstant = 30000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 6,
		RearConstant = 30000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 4,

		MaxGrip = 44,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 40,

		IdleRPM = 300,
		LimitRPM = 5000,
		PeakTorque = 80,
		PowerbandStart = 600,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(38.5,-6.4,12.2),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 30,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_069/sound_002.wav",
		Sound_IdlePitch = 1.3,

		Sound_Mid = "dbg/cars/bank_069/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_069/sound_001.wav",
		Sound_HighPitch = 1.2,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_069/sound_001.wav",
		Sound_ThrottlePitch = 1.1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.17,0,0.15,0.28,0.44,0.61}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_bfinject", V )

local V = {
	Name = "Caddy",
	Model = "models/octocar/novelty/caddy.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Novelty",
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1000,

		EnginePos = Vector(30,0,8),

		LightsTable = "caddy",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/novelty/caddy_wheel.mdl",
		CustomWheelPosFL = Vector(34.9,19.8,-9.7),
		CustomWheelPosFR = Vector(34.9,-19.8,-9.7),
		CustomWheelPosRL = Vector(-34.9,19.8,-10),
		CustomWheelPosRR = Vector(-34.9,-19.8,-10),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-19,-12,30),
		SeatPitch = 6,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-10,-12,-1),
				ang = Angle(0,-90,9)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-48.9,-16.9,-10),
				ang = Angle(70,180,0),
			}
		},

		FrontHeight = 7,
		FrontConstant = 40000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 6,
		RearConstant = 40000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 3,

		MaxGrip = 40,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 30,

		IdleRPM = 300,
		LimitRPM = 5000,
		PeakTorque = 36,
		PowerbandStart = 600,
		PowerbandEnd = 4999,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-25.5,11.5,13.3),
		FuelType = FUELTYPE_ELECTRIC,
		FuelTankSize = 50,

		PowerBias = 0.2,

		EngineSoundPreset = 0,


		Sound_Idle = "",
		Sound_IdlePitch = 0.5,

		Sound_Mid = "dbg/cars/bank_057/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_057/sound_001.wav",
		Sound_HighPitch = 1.2,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_057/sound_001.wav",
		Sound_ThrottlePitch = 1.1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.2,0,0.2,0.36,0.6}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_caddy", V )

local V = {
	Name = "Camper",
	Model = "models/octocar/novelty/camper.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Novelty",
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1900,

		EnginePos = Vector(-60,0,8),

		LightsTable = "camper",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/novelty/camper_wheel.mdl",
		CustomWheelPosFL = Vector(60.8,28.4,-23.7),
		CustomWheelPosFR = Vector(60.8,-28.4,-23.7),
		CustomWheelPosRL = Vector(-74.1,27.7,-23.7),
		CustomWheelPosRR = Vector(-74.1,-27.7,-23.7),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(-1,0,5),

		CustomSteerAngle = 45,

		SeatOffset = Vector(54,-12,23),
		SeatPitch = 6,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(60,-12,-17),
				ang = Angle(0,-90,9)
			},
			{
				pos = Vector(2,-16,-19),
				ang = Angle(0,-90,9)
			},
			{
				pos = Vector(2,7,-19),
				ang = Angle(0,-90,9)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-101,11.8,-32),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 8,
		FrontConstant = 45000,
		FrontDamping = 2300,
		FrontRelativeDamping = 1300,

		RearHeight = 7,
		RearConstant = 45000,
		RearDamping = 2300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 3,

		MaxGrip = 40,
		Efficiency = 0.85,
		GripOffset = -2,
		BrakePower = 30,

		IdleRPM = 300,
		LimitRPM = 5000,
		PeakTorque = 64,
		PowerbandStart = 600,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-90.3,-33.4,-1),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 40,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_135/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_135/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_135/sound_001.wav",
		Sound_HighPitch = 1.2,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_135/sound_002.wav",
		Sound_ThrottlePitch = 1.1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.15,0,0.15,0.25,0.32,0.41,0.52}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_camper", V )

local V = {
	Name = "Dune",
	Model = "models/octocar/novelty/duneride.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Novelty",
	SpawnOffset = Vector(0,0,40),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 10000,

		EnginePos = Vector(80,0,0),

		LightsTable = "duneride",

		CustomWheels = true,
		CustomSuspensionTravel = 0,


		CustomWheelModel = "models/octocar/novelty/duneride_wheel.mdl",
		CustomWheelPosFL = Vector(63.3,37.8,-33.4),
		CustomWheelPosFR = Vector(63.3,-37.8,-33.4),
		CustomWheelPosRL = Vector(-63.3,34.5,-34.9),
		CustomWheelPosRR = Vector(-63.3,-34.5,-34.9),

		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(5,0,2),

		CustomSteerAngle = 35,

		SeatOffset = Vector(69,-19,42),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(79,-19,-1),
				ang = Angle(0,-90,8)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(38.5,41,60.8),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(38.5,41,60.8),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(38.5,-41,60.8),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(38.5,-41,60.8),
				ang = Angle(0,180,0),
			}
		},

		StrengthenSuspension = true,

		FrontHeight = 22,
		FrontConstant = 60000,
		FrontDamping = 12000,
		FrontRelativeDamping = 1000,

		RearHeight = 18,
		RearConstant = 60000,
		RearDamping = 12000,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 23,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 3,

		MaxGrip = 208,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 70,

		IdleRPM = 500,
		LimitRPM = 3500,
		PeakTorque = 180,
		PowerbandStart = 650,
		PowerbandEnd = 3100,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(46.4,41,-23.7),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 160,

		PowerBias = 0.1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_074/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_074/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_074/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_075/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.3,
		Gears = {-0.1,0,0.08,0.19,0.27,0.37,0.49}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_duneride", V )

local V = {
	Name = "Journey",
	Model = "models/octocar/novelty/journey.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Novelty",
	SpawnOffset = Vector(0,0,40),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 3500,

		EnginePos = Vector(90,0,10),

		LightsTable = "journey",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/novelty/journey_wheel.mdl",
		CustomWheelPosFL = Vector(82,35.6,-32.4),
		CustomWheelPosFR = Vector(82,-35.6,-32.4),
		CustomWheelPosRL = Vector(-82.4,43.5,-32.4),
		CustomWheelPosRR = Vector(-82.4,-43.5,-32.4),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(5,0,10),

		CustomSteerAngle = 35,

		SeatOffset = Vector(48,-17,20),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(55,-17,-20),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(10,31,-16),
				ang = Angle(0,180,8),
				noMirrors = true,
			},
			{
				pos = Vector(-12,31,-16),
				ang = Angle(0,180,8),
				noMirrors = true,
			},
			{
				pos = Vector(-34,31,-16),
				ang = Angle(0,180,8),
				noMirrors = true,
			}
		},

		Plates = {
			Front = {
				pos = Vector(111, -10, -29),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-143.5, 10, -29),
				ang = Angle(0, -90, 90),
			},
		},

		Mirrors = {
			left = {
				pos = Vector(57.5, 55, 17),
				h = 1 / 2,
				ratio = 9 / 19,
			},
			right = {
				pos = Vector(57.5, -55, 17),
				h = 1 / 2,
				ratio = 9 / 19,
			},
		},

		RadioPos = Vector(74.5, 0, 5),
		RadioAng = Angle(-5, 180, 0),

		HUDPos = Vector(16.5, 25, 33),
		HUDAng = Angle(0, 0, 65),

		ExhaustPositions = {
			{
				pos = Vector(-130.6,-16.9,-38.5),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 14,
		FrontConstant = 50000,
		FrontDamping = 8000,
		FrontRelativeDamping = 3000,

		RearHeight = 13,
		RearConstant = 50000,
		RearDamping = 8000,
		RearRelativeDamping = 3000,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 72,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 50,

		IdleRPM = 600,
		LimitRPM = 4000,
		PeakTorque = 112,
		PowerbandStart = 700,
		PowerbandEnd = 3800,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-109.4,49.3,-23.7),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_130/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_130/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_130/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_131/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.14,0.24,0.36,0.48,0.6}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_journey", V )

local V = {
	Name = "Kart",
	Model = "models/octocar/novelty/kart.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Novelty",
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 600,

		EnginePos = Vector(-16.9,-11,-1),

		LightsTable = "kart",

		CustomWheels = true,
		CustomSuspensionTravel = 0,

		CustomWheelModel = "models/octocar/novelty/kart_wheel.mdl",
		CustomWheelPosFL = Vector(20.16,18.7,-5.7),
		CustomWheelPosFR = Vector(20.16,-18.7,-5.7),
		CustomWheelPosRL = Vector(-22.3,19.4,-5.7),
		CustomWheelPosRR = Vector(-22.3,-19.4,-5.7),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(0,0,1),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-17,0,19),
		SeatPitch = -7,
		SeatYaw = 90,

		PassengerSeats = {

		},

		ExhaustPositions = {
			{
				pos = Vector(-27.7,9.3,-2.1),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-27.7,9.3,-2.1),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-27.7,9.3,-2.1),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-27.7,9.3,-2.1),
				ang = Angle(90,180,0),
			}
		},
		StrengthenSuspension = true,

		FrontHeight = 4,
		FrontConstant = 22000,
		FrontDamping = 1200,
		FrontRelativeDamping = 80,

		RearHeight = 4,
		RearConstant = 22000,
		RearDamping = 1200,
		RearRelativeDamping = 80,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 36,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 10,

		IdleRPM = 300,
		LimitRPM = 6000,
		PeakTorque = 32,
		PowerbandStart = 600,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(6.4,0,0.3),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 10,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_055/sound_002.wav",
		Sound_IdlePitch = 1.3,

		Sound_Mid = "dbg/cars/bank_055/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_055/sound_001.wav",
		Sound_HighPitch = 1.2,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_055/sound_001.wav",
		Sound_ThrottlePitch = 1.1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.17,0,0.14,0.29,0.5,0.74}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_kart", V )

local V = {
	Name = "Mower",
	Model = "models/octocar/novelty/mower.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Novelty",
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 900,

		EnginePos = Vector(30,0,5),

		LightsTable = "mower",

		CustomWheels = true,
		CustomSuspensionTravel = 0,

		CustomWheelModel = "models/octocar/novelty/mower_wheel.mdl",
		CustomWheelPosFL = Vector(24.8,16.9,-12.6),
		CustomWheelPosFR = Vector(24.8,-16.9,-12.6),
		CustomWheelPosRL = Vector(-24.4,16.9,-12.6),
		CustomWheelPosRR = Vector(-24.4,-16.9,-12.6),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(1,0,1),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-28,0,26),
		SeatPitch = 17,
		SeatYaw = 90,

		PassengerSeats = {

		},

		ExhaustPositions = {
			{
				pos = Vector(-27.7,-9.3,-10),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-27.7,-9.3,-10),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-27.7,-9.3,-10),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-27.7,-9.3,-10),
				ang = Angle(90,180,0),
			}
		},
		StrengthenSuspension = false,

		FrontHeight = 4,
		FrontConstant = 28000,
		FrontDamping = 1200,
		FrontRelativeDamping = 80,

		RearHeight = 4,
		RearConstant = 28000,
		RearDamping = 1200,
		RearRelativeDamping = 80,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 36,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 10,

		IdleRPM = 300,
		LimitRPM = 5000,
		PeakTorque = 24,
		PowerbandStart = 600,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-32.7,13.6,4.3),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 10,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_055/sound_002.wav",
		Sound_IdlePitch = 1.3,

		Sound_Mid = "dbg/cars/bank_055/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_055/sound_001.wav",
		Sound_HighPitch = 1.2,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_055/sound_001.wav",
		Sound_ThrottlePitch = 1.1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.17,0,0.12,0.22,0.4}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_mower", V )

local V = {
	Name = "Quad",
	Model = "models/octocar/novelty/quad.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Novelty",
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 800,

		EnginePos = Vector(0,0,5),

		LightsTable = "quad",

		CustomWheels = true,
		CustomSuspensionTravel = 0,

		CustomWheelModel = "models/octocar/novelty/quad_wheel.mdl",
		CustomWheelPosFL = Vector(21.9,14.7,-10),
		CustomWheelPosFR = Vector(21.9,-14.7,-10),
		CustomWheelPosRL = Vector(-21.6,14.7,-10),
		CustomWheelPosRR = Vector(-21.6,-14.7,-10),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(0,0,2),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-18,0,29),
		SeatPitch = 20,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-25,0,-1),
				ang = Angle(0,-90,-5)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-27,-6.1,2.8),
				ang = Angle(130,180,0),
			},
			{
				pos = Vector(-27,-6.1,2.8),
				ang = Angle(130,180,0),
			},
			{
				pos = Vector(-27,6.1,2.8),
				ang = Angle(130,180,0),
			},
			{
				pos = Vector(-27,6.1,2.8),
				ang = Angle(130,180,0),
			}
		},
		StrengthenSuspension = true,

		FrontHeight = 2,
		FrontConstant = 22000,
		FrontDamping = 1200,
		FrontRelativeDamping = 80,

		RearHeight = 2,
		RearConstant = 22000,
		RearDamping = 1200,
		RearRelativeDamping = 80,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 44,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 10,

		IdleRPM = 300,
		LimitRPM = 7000,
		PeakTorque = 32,
		PowerbandStart = 600,
		PowerbandEnd = 6300,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-32.7,13.6,4.3),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 20,

		PowerBias = 0,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_041/sound_002.wav",
		Sound_IdlePitch = 1.3,

		Sound_Mid = "dbg/cars/bank_041/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_041/sound_001.wav",
		Sound_HighPitch = 1.2,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_041/sound_001.wav",
		Sound_ThrottlePitch = 1.1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.17,0,0.12,0.22,0.37,0.48}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_quad", V )

local V = {
	Name = "Vortex",
	Model = "models/octocar/novelty/vortex.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Novelty",
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 900,

		EnginePos = Vector(-30,0,5),

		LightsTable = "vortex",

		CustomWheels = true,
		CustomSuspensionTravel = 0,

		CustomWheelModel = "models/octocar/novelty/kart_wheel.mdl",
		CustomWheelPosFL = Vector(-10,18,-10),
		CustomWheelPosFR = Vector(-10,-18,-10),
		CustomWheelPosRL = Vector(-45,18,-10),
		CustomWheelPosRR = Vector(-45,-18,-10),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(0,0,1),

		CustomSteerAngle = 45,

		SeatOffset = Vector(1,0,25),
		SeatPitch = 1,
		SeatYaw = 90,

		PassengerSeats = {

		},

		ExhaustPositions = {
			{
				pos = Vector(-57,25.9,20.1),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-57,25.9,20.1),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-57,25.9,20.1),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-57,25.9,20.1),
				ang = Angle(90,180,0),
			}
		},
		StrengthenSuspension = false,

		FrontHeight = 3,
		FrontConstant = 20000,
		FrontDamping = 1200,
		FrontRelativeDamping = 80,

		RearHeight = 3,
		RearConstant = 20000,
		RearDamping = 1200,
		RearRelativeDamping = 80,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 8,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 0,

		IdleRPM = 300,
		LimitRPM = 5000,
		PeakTorque = 112,
		PowerbandStart = 600,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-25,0,10),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 30,

		PowerBias = 0,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_071/sound_002.wav",
		Sound_IdlePitch = 1.3,

		Sound_Mid = "dbg/cars/bank_071/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_071/sound_001.wav",
		Sound_HighPitch = 1.2,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_071/sound_001.wav",
		Sound_ThrottlePitch = 1.1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.6,0,0.6}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_vortex", V )
