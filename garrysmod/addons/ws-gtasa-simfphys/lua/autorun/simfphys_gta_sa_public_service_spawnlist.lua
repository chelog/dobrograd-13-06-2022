local V = {
	Name = "Baggage",
	Model = "models/octocar/public_service/baggage.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Public Service",
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1000,

		EnginePos = Vector(38,0,8),

		LightsTable = "baggage",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/public_service/baggage_wheel.mdl",
		CustomWheelPosFL = Vector(47.1,22.3,-10.8),
		CustomWheelPosFR = Vector(47.1,-22.3,-10.8),
		CustomWheelPosRL = Vector(-35.2,22.3,-10.8),
		CustomWheelPosRR = Vector(-35.2,-22.3,-10.8),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-21,-5,33),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {

		},

		ExhaustPositions = {
			{
				pos = Vector(42.1,-9.3,34.2),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(42.1,-9.3,34.2),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(42.1,-9.3,34.2),
				ang = Angle(0,180,0),
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

		TurnSpeed = 2,

		MaxGrip = 32,
		Efficiency = 0.85,
		GripOffset = 3,
		BrakePower = 40,

		IdleRPM = 300,
		LimitRPM = 5000,
		PeakTorque = 32,
		PowerbandStart = 600,
		PowerbandEnd = 4999,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(25.5,29.8,0.3),
		FuelType = FUELTYPE_ELECTRIC,
		FuelTankSize = 50,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_004/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_004/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_004/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_004/sound_001.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.2,0,0.1,0.3,0.5}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_baggage", V )

local V = {
	Name = "Bus",
	Model = "models/octocar/public_service/bus.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Public Service",
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 5500,

		EnginePos = Vector(-200,0,10),

		LightsTable = "bus",

		CustomWheels = true,
		CustomSuspensionTravel = 0,

		CustomWheelModel = "models/octocar/public_service/bus_wheel.mdl",
		CustomWheelPosFL = Vector(141.4,39.9,-18),
		CustomWheelPosFR = Vector(141.4,-39.9,-18),
		CustomWheelPosML = Vector(-102.6,39.9,-18),
		CustomWheelPosMR = Vector(-102.6,-39.9,-18),
		CustomWheelPosRL = Vector(-140.4,39.9,-18),
		CustomWheelPosRR = Vector(-140.4,-39.9,-18),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(0,0,20),

		CustomSteerAngle = 40,

		SeatOffset = Vector(163,-25,60),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(140,30,12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(140,-30,12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(140,10,12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(140,-10,12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(130,0,12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(130,0,12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(130,0,12),
				ang = Angle(0,-90,8)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-199,-28,-28),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 20,
		FrontConstant = 50000,
		FrontDamping = 8000,
		FrontRelativeDamping = 1000,

		RearHeight = 12,
		RearConstant = 50000,
		RearDamping = 8000,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 34,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 136,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 50,

		IdleRPM = 600,
		LimitRPM = 4000,
		PeakTorque = 88,
		PowerbandStart = 700,
		PowerbandEnd = 3800,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-196.9,48.6,-4.6),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 85,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_026/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_026/sound_001.wav",
		Sound_MidPitch = 1.2,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_026/sound_001.wav",
		Sound_HighPitch = 1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_027/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.11,0.22,0.32,0.52}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_bus", V )

local V = {
	Name = "Cabbie",
	Model = "models/octocar/public_service/cabbie.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Public Service",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2200,

		ModelInfo = {
			Color = Color(215,142,16,255)
		},

		EnginePos = Vector(60,0,10),

		LightsTable = "cabbie",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/public_service/cabbie_wheel.mdl",
		CustomWheelPosFL = Vector(68.7,34.2,-19.8),
		CustomWheelPosFR = Vector(68.7,-34.2,-19.8),
		CustomWheelPosRL = Vector(-68.4,34.2,-19.8),
		CustomWheelPosRR = Vector(-68.4,-34.2,-19.8),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(10,-17,9),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(18,-17,-19),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-18,17,-19),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-18,-17,-19),
				ang = Angle(0,-90,20)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-96.8,-17.2,-27),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 9,
		FrontConstant = 42000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 8,
		RearConstant = 42000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 56,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7400,
		PeakTorque = 72,
		PowerbandStart = 900,
		PowerbandEnd = 6900,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-69.4,39.2,-0.3),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_019/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_019/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_019/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_020/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.42,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		RadioPos = Vector(38,0,2),
		RadioAng = Angle(0,180,0),

		Plates = {
			Front = {
				pos = Vector(102, -10.5, -18),
				ang = Angle(0, 90, 93),
				bgCol = Color(255,191,0),
			},
			Back = {
				pos = Vector(-100.5, 10, -9),
				ang = Angle(0, -90, 90),
				bgCol = Color(255,191,0),
			},
		},

		Mirrors = {
			left = {
				pos = Vector(30, 42, 9),
				h = 1 / 4,
				ratio = 4.5 / 3,
			},
			top = {
				pos = Vector(34, 0, 21),
				w = 1.75 / 5,
				ratio = 3.5 / 1,
			},
			right = {
				pos = Vector(30, -42, 9),
				h = 1 / 4,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_cabbie", V )

local V = {
	Name = "Coach",
	Model = "models/octocar/public_service/coach.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Public Service",
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 9500,

		EnginePos = Vector(-200,0,10),

		LightsTable = "coach",

		CustomWheels = true,
		CustomSuspensionTravel = 0,

		CustomWheelModel = "models/octocar/public_service/coach_wheel.mdl",
		CustomWheelPosFL = Vector(142.2,43.5,-18),
		CustomWheelPosFR = Vector(142.2,-43.5,-18),
		CustomWheelPosML = Vector(-101.2,43.5,-18),
		CustomWheelPosMR = Vector(-101.2,-43.5,-18),
		CustomWheelPosRL = Vector(-141.8,43.5,-18),
		CustomWheelPosRR = Vector(-141.8,-43.5,-18),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(0,0,20),

		CustomSteerAngle = 40,

		SeatOffset = Vector(159,-25,50),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(140,30,12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(140,-30,12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(140,10,12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(140,-10,12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(130,0,12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(130,0,12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(130,0,12),
				ang = Angle(0,-90,8)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-199,-28,-28),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 27,
		FrontConstant = 50000,
		FrontDamping = 9000,
		FrontRelativeDamping = 1000,

		RearHeight = 19,
		RearConstant = 50000,
		RearDamping = 9000,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 34,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 152,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 60,

		IdleRPM = 600,
		LimitRPM = 4000,
		PeakTorque = 140,
		PowerbandStart = 700,
		PowerbandEnd = 3800,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-178.9,48.6,-18),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 85,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_026/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_026/sound_001.wav",
		Sound_MidPitch = 1.2,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_026/sound_001.wav",
		Sound_HighPitch = 1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_027/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.11,0.22,0.32,0.52}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_coach", V )

local V = {
	Name = "Sweeper",
	Model = "models/octocar/public_service/sweeper.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Public Service",
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 800,

		EnginePos = Vector(-38,0,8),

		LightsTable = "sweeper",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/public_service/sweeper_wheel.mdl",
		CustomWheelPosFL = Vector(28.4,20.1,-15.8),
		CustomWheelPosFR = Vector(28.4,-20.1,-15.8),
		CustomWheelPosRL = Vector(-28.4,20.1,-15.8),
		CustomWheelPosRR = Vector(-28.4,-20.1,-15.8),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(14,-8,34),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {

		},

		ExhaustPositions = {
			{
				pos = Vector(-41.7,-20.8,-18.3),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 30000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 6,
		RearConstant = 30000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 32,
		Efficiency = 0.85,
		GripOffset = 3,
		BrakePower = 40,

		IdleRPM = 300,
		LimitRPM = 5000,
		PeakTorque = 12,
		PowerbandStart = 600,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-34.5,24.8,10),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_004/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_004/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_004/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_004/sound_001.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.2,0,0.13,0.22,0.31}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_sweeper", V )

local V = {
	Name = "Taxi",
	Model = "models/octocar/public_service/taxi.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Public Service",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		ModelInfo = {
			Color = Color(215,142,16,255)
		},

		EnginePos = Vector(60,0,10),

		LightsTable = "taxi",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/public_service/taxi_wheel.mdl",
		CustomWheelPosFL = Vector(58.6,33.1,-12.6),
		CustomWheelPosFR = Vector(58.6,-33.1,-12.6),
		CustomWheelPosRL = Vector(-59,33.1,-12.6),
		CustomWheelPosRR = Vector(-59,-33.1,-12.6),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-4,-18,15),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(5,-17,-15),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-34,17,-16),
				ang = Angle(0,-90,18)
			},
			{
				pos = Vector(-34,-17,-16),
				ang = Angle(0,-90,18)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-93.9,-20.1,-18.7),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 9,
		FrontConstant = 40000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 8,
		RearConstant = 40000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 52,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7400,
		PeakTorque = 76,
		PowerbandStart = 900,
		PowerbandEnd = 6900,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-77,39.2,2.8),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_080/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_080/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_080/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_081/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.42,
		Gears = {-0.12,0,0.1,0.17,0.28,0.39,0.5},

		RadioPos = Vector(30,0,8),
		RadioAng = Angle(0,180,0),

		Plates = {
			Front = {
				pos = Vector(92.5, -10.5, -7.5),
				ang = Angle(0, 90, 93),
				bgCol = Color(255,191,0),
			},
			Back = {
				pos = Vector(-98, 10, -1.5),
				ang = Angle(0, -90, 90),
				bgCol = Color(255,191,0),
			},
		},

		Mirrors = {
			left = {
				pos = Vector(21, 44.5, 12),
				h = 1 / 4,
				ratio = 4.5 / 3,
			},
			top = {
				pos = Vector(8, 0, 25),
				ang = Angle(10, 0, 0),
				w = 1.75 / 5,
				ratio = 3 / 1,
			},
			right = {
				pos = Vector(21, -44.5, 12),
				h = 1 / 4,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_taxi", V )

local V = {
	Name = "Towtruck",
	Model = "models/octocar/public_service/towtruck.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Public Service",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 3500,

		EnginePos = Vector(90,0,10),

		Plates = {
			Front = {
				pos = Vector(117.3, -10.5, -1.8),
				ang = Angle(0, 90, 93),
			},
			Back = {
				pos = Vector(-109.5, 10, -2),
				ang = Angle(0, -90, 101),
			},
		},

		LightsTable = "towtruck",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/public_service/towtruck_wheel.mdl",
		CustomWheelPosFL = Vector(74.8,37,-13.6),
		CustomWheelPosFR = Vector(74.8,-37,-13.6),
		CustomWheelPosRL = Vector(-75.2,37,-13.6),
		CustomWheelPosRR = Vector(-75.2,-37,-13.6),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 32,

		SeatOffset = Vector(1,-18,34),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(12,-17,1),
				ang = Angle(0,-90,8),
				hasRadio = true,
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-101.2,-17,-16.9),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 8,
		FrontConstant = 150000,
		FrontDamping = 1800,
		FrontRelativeDamping = 1000,

		RearHeight = 6,
		RearConstant = 120000,
		RearDamping = 5000,
		RearRelativeDamping = 1800,
		StrengthenRearSuspension = true,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 4,

		MaxGrip = 72,
		Efficiency = 0.85,
		GripOffset = 0.8,
		BrakePower = 34,

		IdleRPM = 700,
		LimitRPM = 4800,
		PeakTorque = 100,
		PowerbandStart = 800,
		PowerbandEnd = 4600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-18.3,47.1,-3.2),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 60,

		PowerBias = 0.2,

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
		Gears = {-0.12,0,0.14,0.24,0.36,0.48,0.65},

		RadioPos = Vector(36.8, 0, 23.9),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(0, 37, 33),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(27, 53, 32),
				ang = Angle(0, 20, 0),
				h = 2 / 5,
				ratio = 3 / 4,
			},
			top = {
				pos = Vector(-26, -31, 32),
				ang = Angle(10, -10, 0),
				w = 1 / 5,
				ratio = 1 / 1,
				noFlip = true,
			},
			right = {
				pos = Vector(27, -50, 32),
				h = 2 / 5,
				ratio = 3 / 4,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_towtruck", V )

local V = {
	Name = "Trashmaster",
	Model = "models/octocar/public_service/trash.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Public Service",
	SpawnOffset = Vector(0,0,90),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 10000,

		ModelInfo = {
			Color = Color(165,169,167,255)
		},

		EnginePos = Vector(170,0,10),

		LightsTable = "trash",

		CustomWheels = true,
		CustomSuspensionTravel = 0,

		CustomWheelModel = "models/octocar/public_service/trash_wheel.mdl",
		CustomWheelPosFL = Vector(145.4,39.2,-34.9),
		CustomWheelPosFR = Vector(145.4,-39.2,-34.9),
		CustomWheelPosML = Vector(-38.5,39.2,-34.9),
		CustomWheelPosMR = Vector(-38.5,-39.2,-34.9),
		CustomWheelPosRL = Vector(-79.9,39.2,-34.9),
		CustomWheelPosRR = Vector(-79.9,-39.2,-34.9),

		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(0,0,20),

		CustomSteerAngle = 35,

		SeatOffset = Vector(88,-16,31),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(98,-16,-15),
				ang = Angle(0,-90,8)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(69.8,32.4,74),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(69.8,32.4,74),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(69.8,32.4,74),
				ang = Angle(0,180,0),
			}
		},

		StrengthenSuspension = true,

		FrontHeight = 22,
		FrontConstant = 60000,
		FrontDamping = 10000,
		FrontRelativeDamping = 1000,

		RearHeight = 18,
		RearConstant = 60000,
		RearDamping = 10000,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 120,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 70,

		IdleRPM = 500,
		LimitRPM = 3500,
		PeakTorque = 88,
		PowerbandStart = 650,
		PowerbandEnd = 3100,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(46.4,41,-23.7),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 110,

		PowerBias = 1,

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
		Gears = {-0.1,0,0.08,0.2,0.32,0.48}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_trash", V )

local V = {
	Name = "Tug",
	Model = "models/octocar/public_service/tug.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Public Service",
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 800,

		EnginePos = Vector(38,0,8),

		LightsTable = "tug",

		CustomWheels = true,
		CustomSuspensionTravel = 0,

		CustomWheelModel = "models/octocar/public_service/tug_wheel.mdl",
		CustomWheelPosFL = Vector(40.3,22.6,-7.5),
		CustomWheelPosFR = Vector(40.3,-22.6,-7.5),
		CustomWheelPosRL = Vector(-39.9,22.6,-7.5),
		CustomWheelPosRR = Vector(-39.9,-22.6,-7.5),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-45,0,38),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {

		},

		ExhaustPositions = {
			{
				pos = Vector(28.4,30.2,2.8),
				ang = Angle(90,90,0),
			},
			{
				pos = Vector(28.4,30.2,2.8),
				ang = Angle(90,90,0),
			},
			{
				pos = Vector(28.4,30.2,2.8),
				ang = Angle(90,90,0),
			}
		},

		FrontHeight = 7,
		FrontConstant = 30000,
		FrontDamping = 1500,
		FrontRelativeDamping = 1000,

		RearHeight = 6,
		RearConstant = 30000,
		RearDamping = 1500,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 29,
		Efficiency = 0.85,
		GripOffset = 3,
		BrakePower = 40,

		IdleRPM = 300,
		LimitRPM = 5200,
		PeakTorque = 30,
		PowerbandStart = 600,
		PowerbandEnd = 4800,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(14.7,27.3,-1.8),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_004/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_004/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_004/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_004/sound_001.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.2,0,0.1,0.3,0.5}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_tug", V )

local V = {
	Name = "Utility Van",
	Model = "models/octocar/public_service/utility.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Public Service",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2600,

		EnginePos = Vector(90,0,10),

		LightsTable = "utility",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/public_service/utility_wheel.mdl",
		CustomWheelPosFL = Vector(81.3,37.4,-6.1),
		CustomWheelPosFR = Vector(81.3,-37.4,-6.1),
		CustomWheelPosRL = Vector(-51.4,37.4,-6.1),
		CustomWheelPosRR = Vector(-51.4,-37.4,-6.1),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 32,

		SeatOffset = Vector(17,-21,34),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(25,-21,1),
				ang = Angle(0,-90,8)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-109,-15.8,-11.1),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 8,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 1000,

		RearHeight = 7,
		RearConstant = 50000,
		RearDamping = 3000,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 64,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 50,

		IdleRPM = 600,
		LimitRPM = 4000,
		PeakTorque = 108,
		PowerbandStart = 700,
		PowerbandEnd = 3800,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-18.3,47.1,-3.2),
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
		Gears = {-0.12,0,0.14,0.24,0.36,0.48,0.65}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_utility", V )
