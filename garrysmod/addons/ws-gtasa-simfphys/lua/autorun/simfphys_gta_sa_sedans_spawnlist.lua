local V = {
	Name = "Admiral",
	Model = "models/octocar/sedans/admiral.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1650,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(93.1, -10, -10),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-102, 10, 1),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "admiral",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/admiral_wheel.mdl",
		CustomWheelPosFL = Vector(62.5,32.7,-16.5),
		CustomWheelPosFR = Vector(62.5,-32.7,-16.5),
		CustomWheelPosRL = Vector(-62.7,32.7,-16.5),
		CustomWheelPosRR = Vector(-62.7,-32.7,-16.5),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-5,-16,15),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(4,-17,-15),
				ang = Angle(0,-90,20),
				hasRadio = true,
			},
			{
				pos = Vector(-35,17,-15),
				ang = Angle(0,-90,18),
			},
			{
				pos = Vector(-35,-17,-15),
				ang = Angle(0,-90,18),
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-90,-17,-15),
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
		GripOffset = -0.8,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7400,
		PeakTorque = 60,
		PowerbandStart = 900,
		PowerbandEnd = 6900,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-69.9,37.3,4.5),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = -1,

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
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		RadioPos = Vector(23, 0, 5),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(0, 38.5, 30),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(20.5, 43, 11),
				w = 1 / 5,
				ratio = 3 / 2,
			},
			top = {
				pos = Vector(9, 0, 23),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			right = {
				pos = Vector(20.5, -43, 11),
				w = 1 / 5,
				ratio = 3 / 2,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_admiral", V )

local V = {
	Name = "Elegant",
	Model = "models/octocar/sedans/elegant.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2200,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(104.75, -10, -11),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-112, 10, 0.5),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "elegant",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/elegant_wheel.mdl",
		CustomWheelPosFL = Vector(64.8,37.1,-16.2),
		CustomWheelPosFR = Vector(64.8,-37.1,-16.2),
		CustomWheelPosRL = Vector(-65.2,37.1,-16.2),
		CustomWheelPosRR = Vector(-65.2,-37.1,-16.2),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-5,-19.5,15),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(4,-17,-15),
				ang = Angle(0,-90,20),
				hasRadio = true,
			},
			{
				pos = Vector(-35,17,-16),
				ang = Angle(0,-90,18),
			},
			{
				pos = Vector(-35,-17,-16),
				ang = Angle(0,-90,18),
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-106.6,-17.6,-23),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 11,
		FrontConstant = 50000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 10,
		RearConstant = 50000,
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

		FuelFillPos = Vector(-82.8,41.7,4),
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
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		RadioPos = Vector(27.6, 0, 6),
		RadioAng = Angle(-5, 180, 0),

		HUDPos = Vector(0, 42.25, 28),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(25, 48, 8.3),
				w = 1 / 5,
				ratio = 4 / 3,
			},
			top = {
				pos = Vector(7.5, 0, 21.5),
				ang = Angle(5, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			right = {
				pos = Vector(25, -48, 8.3),
				w = 1 / 5,
				ratio = 4 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_elegant", V )

local V = {
	Name = "Emperor",
	Model = "models/octocar/sedans/emperor.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1800,

		EnginePos = Vector(60,0,10),

		LightsTable = "emperor",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/emperor_wheel.mdl",
		CustomWheelPosFL = Vector(64.8,36,-8),
		CustomWheelPosFR = Vector(64.8,-36,-8),
		CustomWheelPosRL = Vector(-64.4,36,-8),
		CustomWheelPosRR = Vector(-64.4,-36,-8),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-5,-18,18),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(4,-17,-12),
				ang = Angle(0,-90,20),
				hasRadio = true,
			},
			{
				pos = Vector(-35,17,-12),
				ang = Angle(0,-90,18)
			},
			{
				pos = Vector(-35,-17,-12),
				ang = Angle(0,-90,18)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-113,17,-10),
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
		PeakTorque = 74,
		PowerbandStart = 900,
		PowerbandEnd = 6900,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-82.8,-40.5,7.2),
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

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		RadioPos = Vector(28.1, 0, 12.5),
		RadioAng = Angle(-8, 180, 0),

		Mirrors = {
			left = {
				pos = Vector(27, 45, 17),
				w = 1 / 5,
				ratio = 5 / 3,
			},
			right = {
				pos = Vector(27, -45, 17),
				w = 1 / 5,
				ratio = 5 / 3,
			},
		},

		Plates = {
			Front = {
				pos = Vector(107.75, -10, -2.5),
				ang = Angle(0, 90, 97),
			},
			Back = {
				pos = Vector(-110.25, 10, -2.5),
				ang = Angle(0, -90, 90),
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_emperor", V )

local V = {
	Name = "Glendale",
	Model = "models/octocar/sedans/glendale.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		LightsTable = "glendale",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/glendale_wheel.mdl",
		CustomWheelPosFL = Vector(64.5,32.9,-12.6),
		CustomWheelPosFR = Vector(64.5,-32.9,-12.6),
		CustomWheelPosRL = Vector(-64.2,32.9,-12.6),
		CustomWheelPosRR = Vector(-64.2,-32.9,-12.6),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(0,-18,14),
		SeatPitch = -10,
		SeatYaw = 90,

		Plates = {
			Front = {
				pos = Vector(99.8, -10, -11),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-109.05, 10, -0.5),
				ang = Angle(0, -90, 90),
			},
		},

		Mirrors = {
			left = {
				pos = Vector(40, 43, 12.5),
				w = 1 / 6,
				ratio = 1 / 1,
			},
			top = {
				pos = Vector(18, 0, 23.5),
				ang = Angle(6, 0, 0),
				w = 1 / 3,
				ratio = 3 / 1,
			},
			right = {
				pos = Vector(40, -43, 12.5),
				w = 1 / 6,
				ratio = 1 / 1,
			},
		},

		HUDPos = Vector(0, 35, 30),

		RadioPos = Vector(27.1, 0, 8.5),
		RadioAng = Angle(0, 180, 0),

		PassengerSeats = {
			{
				pos = Vector(10,-17,-18),
				ang = Angle(0,-90,20),
				hasRadio = true,
			},
			{
				pos = Vector(-25,17,-18),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-25,-17,-18),
				ang = Angle(0,-90,20)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-104,-15.8,-18),
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

		MaxGrip = 44,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 6400,
		PeakTorque = 56,
		PowerbandStart = 900,
		PowerbandEnd = 6100,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-108,0,-4.3),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_010/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_010/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_011/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_011/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_glendale", V )

local V = {
	Name = "Glendale Beater",
	Model = "models/octocar/sedans/glenshit.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		LightsTable = "glendale",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/glenshit_wheel.mdl",
		CustomWheelPosFL = Vector(64.5,32.9,-12.6),
		CustomWheelPosFR = Vector(64.5,-32.9,-12.6),
		CustomWheelPosRL = Vector(-64.2,32.9,-12.6),
		CustomWheelPosRR = Vector(-64.2,-32.9,-12.6),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(0,-18,14),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(10,-17,-15),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-25,17,-15),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-25,-17,-15),
				ang = Angle(0,-90,20)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-104,-15.8,-18),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 9,
		FrontConstant = 35000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 8,
		RearConstant = 35000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 44,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 6400,
		PeakTorque = 52,
		PowerbandStart = 900,
		PowerbandEnd = 6100,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-108,0,-4.3),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_010/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_010/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_011/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_011/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_glenshit", V )

local V = {
	Name = "Greenwood",
	Model = "models/octocar/sedans/greenwoo.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(96.75, -10, -11),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-109.25, 10, -7),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "greenwoo",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/greenwoo_wheel.mdl",
		CustomWheelPosFL = Vector(61.2,33.3,-12.6),
		CustomWheelPosFR = Vector(61.2,-33.3,-12.6),
		CustomWheelPosRL = Vector(-61.2,33.3,-12.6),
		CustomWheelPosRR = Vector(-61.2,-33.3,-12.6),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(0,-18,14),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(10,-17,-15),
				ang = Angle(0,-90,20),
				hasRadio = true,
			},
			{
				pos = Vector(-30,17,-15),
				ang = Angle(0,-90,20),
			},
			{
				pos = Vector(-30,-17,-15),
				ang = Angle(0,-90,20),
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-93.6,-20.5,-17.6),
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

		MaxGrip = 47,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 6400,
		PeakTorque = 66,
		PowerbandStart = 900,
		PowerbandEnd = 6100,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-74.8,34.9,5),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_088/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_088/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_088/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_088/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.23,0.38,0.45},

		RadioPos = Vector(29.5, 0, 10),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(0, 40, 27.5),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(20, 40.5, 12.5),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			top = {
				pos = Vector(11, 0, 26),
				ang = Angle(6, 0, 0),
				w = 1 / 3,
				ratio = 3 / 1,
			},
			right = {
				pos = Vector(20, -40.5, 12.5),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_greenwoo", V )

local V = {
	Name = "Intruder",
	Model = "models/octocar/sedans/intruder.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1800,

		EnginePos = Vector(60,0,10),

		LightsTable = "intruder",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/intruder_wheel.mdl",
		CustomWheelPosFL = Vector(58.6,35.6,-12.2),
		CustomWheelPosFR = Vector(58.6,-35.6,-12.2),
		CustomWheelPosRL = Vector(-68.7,35.6,-12.2),
		CustomWheelPosRR = Vector(-67.7,-35.6,-12.2),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-8,-19,16),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(1,-17,-15),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-38,17,-17),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-38,-17,-17),
				ang = Angle(0,-90,20)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-101.1,-20.8,-14),
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
		LimitRPM = 6400,
		PeakTorque = 68,
		PowerbandStart = 900,
		PowerbandEnd = 6100,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-72.7,-38.8,5),
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

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.18,0.25,0.38,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_intruder", V )

local V = {
	Name = "Merit",
	Model = "models/octocar/sedans/merit.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1800,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(104, -10, -7),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-113, 10, 3.5),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "merit",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/merit_wheel.mdl",
		CustomWheelPosFL = Vector(65.5,33.8,-15.1),
		CustomWheelPosFR = Vector(65.5,-33.8,-15.1),
		CustomWheelPosRL = Vector(-63.7,33.8,-15.1),
		CustomWheelPosRR = Vector(-63.7,-33.8,-15.1),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(0,-17,16),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(8,-17,-15),
				ang = Angle(0,-90,20),
				hasRadio = true,
			},
			{
				pos = Vector(-35,17,-17),
				ang = Angle(0,-90,20),
			},
			{
				pos = Vector(-35,-17,-17),
				ang = Angle(0,-90,20),
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-116,-21.2,-17.2),
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
		LimitRPM = 6500,
		PeakTorque = 68,
		PowerbandStart = 900,
		PowerbandEnd = 6300,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-95.7,41.8,3.2),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_001/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_001/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_001/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_002/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.18,0.25,0.38,0.45},

		RadioPos = Vector(28.3, 0, 7.5),
		RadioAng = Angle(-8, 180, 0),

		HUDPos = Vector(0, 37, 29),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(25.5, 40, 14),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			top = {
				pos = Vector(10, 0, 22),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			right = {
				pos = Vector(25.5, -40, 14),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_merit", V )

local V = {
	Name = "Nebula",
	Model = "models/octocar/sedans/nebula.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1400,

		EnginePos = Vector(60,0,10),

		LightsTable = "nebula",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/nebula_wheel.mdl",
		CustomWheelPosFL = Vector(59.7,32.7,-15.1),
		CustomWheelPosFR = Vector(59.7,-32.7,-15.1),
		CustomWheelPosRL = Vector(-57.6,32.7,-15.1),
		CustomWheelPosRR = Vector(-57.6,-32.7,-15.1),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(0,-17,16),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(8,-17,-15),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-33,17,-17),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-33,-17,-17),
				ang = Angle(0,-90,20)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-107,-15.8,-18.7),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 8,
		FrontConstant = 35000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 7,
		RearConstant = 35000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 45,
		Efficiency = 0.85,
		GripOffset = 0.5,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 6600,
		PeakTorque = 60,
		PowerbandStart = 900,
		PowerbandEnd = 6300,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-88.2,39.6,1.1),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = -1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_001/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_001/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_001/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_002/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.18,0.25,0.38,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_nebula", V )

local V = {
	Name = "Oceanic",
	Model = "models/octocar/sedans/oceanic.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1800,

		EnginePos = Vector(60,0,10),

		LightsTable = "oceanic",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/oceanic_wheel.mdl",
		CustomWheelPosFL = Vector(64.8,32.4,-12.6),
		CustomWheelPosFR = Vector(64.8,-32.4,-12.6),
		CustomWheelPosRL = Vector(-64.1,32.4,-12.6),
		CustomWheelPosRR = Vector(-64.1,-32.4,-12.6),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(0,-18,14),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(10,-17,-15),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-22,17,-16),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-22,-17,-16),
				ang = Angle(0,-90,20)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-104,-15.8,-18),
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

		MaxGrip = 48,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 6400,
		PeakTorque = 58,
		PowerbandStart = 900,
		PowerbandEnd = 6100,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-82.8,38.1,4),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_010/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_010/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_011/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_011/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_oceanic", V )

local V = {
	Name = "Perennial",
	Model = "models/octocar/sedans/peren.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1400,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(85.75, -10, -7),
				ang = Angle(0, 90, 100),
			},
			Back = {
				pos = Vector(-99, 10, -8.5),
				ang = Angle(0, -90, 100),
			},
		},

		LightsTable = "peren",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/peren_wheel.mdl",
		CustomWheelPosFL = Vector(55.4,28.8,-11.8),
		CustomWheelPosFR = Vector(55.4,-28.8,-11.8),
		CustomWheelPosRL = Vector(-56.1,28.8,-11.8),
		CustomWheelPosRR = Vector(-56.1,-28.8,-11.8),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-7,-17,18),
		SeatPitch = -6,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(5,-17,-11),
				ang = Angle(0,-90,20),
				hasRadio = true,
			},
			{
				pos = Vector(-29,17,-15),
				ang = Angle(0,-90,20),
			},
			{
				pos = Vector(-29,-17,-15),
				ang = Angle(0,-90,20),
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-104,-15.8,-18),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 9,
		FrontConstant = 34000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 8,
		RearConstant = 34000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 36,
		Efficiency = 0.85,
		GripOffset = 1,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 5800,
		PeakTorque = 40,
		PowerbandStart = 900,
		PowerbandEnd = 5600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-84.9,33.8,1,0.3),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		PowerBias = -1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_088/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_088/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_088/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_089/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.38,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		RadioPos = Vector(19, 0, 13),
		RadioAng = Angle(-5, 180, 0),

		HUDPos = Vector(1, 33, 31),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(16, 35, 15.5),
				w = 1 / 5,
				ratio = 5 / 3,
			},
			top = {
				pos = Vector(10, 0, 27),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			right = {
				pos = Vector(16, -35, 15.5),
				w = 1 / 5,
				ratio = 5 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_peren", V )

local V = {
	Name = "Premier",
	Model = "models/octocar/sedans/premier.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(92.5, -10, -7),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-97.75, 10, -1),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "premier",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/premier_wheel.mdl",
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
				hasRadio = true,
			},
			{
				pos = Vector(-34,17,-16),
				ang = Angle(0,-90,18),
			},
			{
				pos = Vector(-34,-17,-16),
				ang = Angle(0,-90,18),
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

		RadioPos = Vector(30, 0, 9),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(0, 38.5, 29),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(21, 44, 12),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			top = {
				pos = Vector(8, 0, 22),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3 / 1,
			},
			right = {
				pos = Vector(21, -44, 12),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_premier", V )

local V = {
	Name = "Primo",
	Model = "models/octocar/sedans/primo.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		LightsTable = "primo",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/primo_wheel.mdl",
		CustomWheelPosFL = Vector(57.6,32.7,-12.6),
		CustomWheelPosFR = Vector(57.6,-32.7,-12.6),
		CustomWheelPosRL = Vector(-53.2,32.7,-12.6),
		CustomWheelPosRR = Vector(-53.2,-32.7,-12.6),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(0,-18,16),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(10,-17,-15),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-30,17,-15),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-30,-17,-15),
				ang = Angle(0,-90,20)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-94,-22.3,-16.2),
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

		MaxGrip = 47,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 6400,
		PeakTorque = 66,
		PowerbandStart = 900,
		PowerbandEnd = 6100,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-72,37,4.3),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_001/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_001/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_001/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_002/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.22,0.38,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_primo", V )

local V = {
	Name = "Regina",
	Model = "models/octocar/sedans/regina.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1500,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(100.5, -10, -9),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-105.25, 10, -9.5),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "regina",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/regina_wheel.mdl",
		CustomWheelPosFL = Vector(61.2,32.7,-13.6),
		CustomWheelPosFR = Vector(61.2,-32.7,-13.6),
		CustomWheelPosRL = Vector(-57.2,32.7,-13.6),
		CustomWheelPosRR = Vector(-57.2,-32.7,-13.6),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-4,-18,18),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(8,-17,-12),
				ang = Angle(0,-90,20),
				hasRadio = true,
			},
			{
				pos = Vector(-30,17,-11),
				ang = Angle(0,-90,20),
			},
			{
				pos = Vector(-30,-17,-11),
				ang = Angle(0,-90,20),
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-101,-16.2,-16.5),
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

		MaxGrip = 44,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 6400,
		PeakTorque = 62,
		PowerbandStart = 900,
		PowerbandEnd = 6100,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-71,36,0.7),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 0.8,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_088/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_088/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_088/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_089/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.34666666666667,
		Gears = {-0.12,0,0.1,0.22,0.38,0.45},

		RadioPos = Vector(23.1, 0, 11),
		RadioAng = Angle(-8, 180, 0),

		HUDPos = Vector(0, 38.5, 29),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(24, 42, 14),
				w = 1 / 5,
				ratio = 5 / 3,
			},
			top = {
				pos = Vector(8, 0, 28),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 4 / 1,
			},
			right = {
				pos = Vector(24, -42, 14),
				w = 1 / 5,
				ratio = 5 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_regina", V )

local V = {
	Name = "Romero",
	Model = "models/octocar/sedans/romero.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2500,

		ModelInfo = {
			Color = Color(0,0,0,255)
		},

		EnginePos = Vector(60,0,10),

		LightsTable = "romero",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/romero_wheel.mdl",
		CustomWheelPosFL = Vector(71.6,34.9,-16.2),
		CustomWheelPosFR = Vector(71.6,-34.9,-16.2),
		CustomWheelPosRL = Vector(-72,34.9,-16.2),
		CustomWheelPosRR = Vector(-72,-34.9,-16.2),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(4,-18,12),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(16,-17,-19),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-30,17,-11),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-30,-17,-11),
				ang = Angle(0,-90,20)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-101,-16.2,-16.5),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 12,
		FrontConstant = 50000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 11,
		RearConstant = 50000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 60,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 6200,
		PeakTorque = 70,
		PowerbandStart = 900,
		PowerbandEnd = 5600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-79.5,40.3,2.1),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 0.8,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_088/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_088/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_088/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_089/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.34666666666667,
		Gears = {-0.12,0,0.08,0.19,0.27,0.38,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_romero", V )

local V = {
	Name = "Sentinel",
	Model = "models/octocar/sedans/sentinel.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		LightsTable = "sentinel",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/sentinel_wheel.mdl",
		CustomWheelPosFL = Vector(59,29.8,-16.2),
		CustomWheelPosFR = Vector(59,-29.8,-16.2),
		CustomWheelPosRL = Vector(-58.6,29.8,-16.2),
		CustomWheelPosRR = Vector(-58.6,-29.8,-16.2),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-5,-14,14),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(4,-16,-18),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-32,17,-19),
				ang = Angle(0,-90,18)
			},
			{
				pos = Vector(-32,-17,-19),
				ang = Angle(0,-90,18)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-96,-17.2,-18),
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
		PeakTorque = 60,
		PowerbandStart = 900,
		PowerbandEnd = 6900,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-78,37.3,-1),
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

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_sentinel", V )

local V = {
	Name = "Solair",
	Model = "models/octocar/sedans/solair.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2000,

		EnginePos = Vector(60,0,10),

		LightsTable = "solair",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/solair_wheel.mdl",
		CustomWheelPosFL = Vector(60.8,33.4,-15.8),
		CustomWheelPosFR = Vector(60.8,-33.4,-15.8),
		CustomWheelPosRL = Vector(-61.9,33.4,-15.8),
		CustomWheelPosRR = Vector(-61.9,-33.4,-15.8),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(3,-16.5,8),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(13,-17,-21.5),
				ang = Angle(0,-90,20),
				hasRadio = true,
			},
			{
				pos = Vector(-30,17,-22),
				ang = Angle(0,-90,20),
			},
			{
				pos = Vector(-30,-17,-22),
				ang = Angle(0,-90,20)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-99,-18.7,-21.9),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 12,
		FrontConstant = 50000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 11,
		RearConstant = 50000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 63,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 6400,
		PeakTorque = 74,
		PowerbandStart = 900,
		PowerbandEnd = 6100,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-73.8,39.9,-3.6),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_001/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_001/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_001/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_002/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.22,0.38,0.45},

		Plates = {
			Front = {
				pos = Vector(98, -10, -10.5),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-102, 10, -1),
				ang = Angle(0, -90, 90),
			},
		},

		RadioPos = Vector(31, 3, 1),
		RadioAng = Angle(-11, 180, 0),

		Mirrors = {
			left = {
				pos = Vector(30, 41, 8),
				w = 1 / 5.5,
				ratio = 3 / 2,
			},
			top = {
				pos = Vector(13, 0, 18),
				w = 1 / 3,
				ratio = 3 / 1,
			},
			right = {
				pos = Vector(30, -41, 8),
				w = 1 / 5.5,
				ratio = 3 / 2,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_solair", V )

local V = {
	Name = "Stafford",
	Model = "models/octocar/sedans/stafford.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2200,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(102, -10, -10),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-102.1, 10, 3),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "stafford",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/stafford_wheel.mdl",
		CustomWheelPosFL = Vector(63.7,38.5,-10.4),
		CustomWheelPosFR = Vector(63.7,-38.5,-10.4),
		CustomWheelPosRL = Vector(-63.7,38.5,-10.4),
		CustomWheelPosRR = Vector(-63.7,-38.5,-10.4),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-1,-18,21),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(8,-17,-8),
				ang = Angle(0,-90,20),
				hasRadio = true,
			},
			{
				pos = Vector(-29,17,-9),
				ang = Angle(0,-90,20),
			},
			{
				pos = Vector(-29,-17,-9),
				ang = Angle(0,-90,20),
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-99.7,14.4,-16.9),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 12,
		FrontConstant = 50000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 11,
		RearConstant = 50000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 65,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 6400,
		PeakTorque = 75,
		PowerbandStart = 900,
		PowerbandEnd = 6100,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-65.5,-42,8.6),
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

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.08,0.19,0.28,0.38,0.45},

		RadioPos = Vector(27, 0, 14),
		RadioAng = Angle(-18, 180, 0),

		HUDPos = Vector(0, 36, 30),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(32, 45, 18),
				w = 1 / 5,
				ratio = 1.75 / 1,
			},
			right = {
				pos = Vector(32, -45, 18),
				w = 1 / 5,
				ratio = 1.75 / 1,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_stafford", V )

local V = {
	Name = "Stretch",
	Model = "models/octocar/sedans/stretch.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2200,

		EnginePos = Vector(100,0,10),

		LightsTable = "stretch",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/stretch_wheel.mdl",
		CustomWheelPosFL = Vector(98.6,32,-12.6),
		CustomWheelPosFR = Vector(98.6,-32,-12.6),
		CustomWheelPosRL = Vector(-98.6,32,-12.6),
		CustomWheelPosRR = Vector(-98.6,-32,-12.6),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(15,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(32,-17,9),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(44,-16,-16),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-65,17,-16),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-65,-17,-16),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-9,-17,-16),
				ang = Angle(0,90,20)
			},
			{
				pos = Vector(-9,17,-16),
				ang = Angle(0,90,20)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-136,-22.3,-17.2),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 12,
		FrontConstant = 50000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 11,
		RearConstant = 50000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 63,
		Efficiency = 0.85,
		GripOffset = 2.5,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7600,
		PeakTorque = 78,
		PowerbandStart = 900,
		PowerbandEnd = 7200,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-101.5,35.2,4),
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

		DifferentialGear = 0.36666666666667,
		Gears = {-0.12,0,0.08,0.19,0.28,0.38,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_stretch", V )

local V = {
	Name = "Sunrise",
	Model = "models/octocar/sedans/sunrise.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		LightsTable = "sunrise",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/sunrise_wheel.mdl",
		CustomWheelPosFL = Vector(60.4,34.9,-15.1),
		CustomWheelPosFR = Vector(60.4,-34.9,-15.1),
		CustomWheelPosRL = Vector(-67.3,34.9,-15.1),
		CustomWheelPosRR = Vector(-67.3,-34.9,-15.1),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(0,-17,12),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(8,-17,-19),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-30,17,-20),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-30,-17,-20),
				ang = Angle(0,-90,20)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-104,22.3,-23),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 9,
		FrontConstant = 38000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 8,
		RearConstant = 38000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 48,
		Efficiency = 0.85,
		GripOffset = 0.5,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 6600,
		PeakTorque = 60,
		PowerbandStart = 900,
		PowerbandEnd = 6300,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-88.2,39.5,1),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = -1,

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

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.18,0.25,0.38,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_sunrise", V )

local V = {
	Name = "Vincent",
	Model = "models/octocar/sedans/vincent.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1850,

		EnginePos = Vector(60,0,10),

		LightsTable = "vincent",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/vincent_wheel.mdl",
		CustomWheelPosFL = Vector(64.4,36,-16.5),
		CustomWheelPosFR = Vector(64.4,-36,-16.5),
		CustomWheelPosRL = Vector(-68.4,36,-16.5),
		CustomWheelPosRR = Vector(-68.4,-36,-16.5),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-5,-19,10),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(8,-17,-19),
				ang = Angle(0,-90,20),
				hasRadio = true,
			},
			{
				pos = Vector(-38,17,-20),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-38,-17,-20),
				ang = Angle(0,-90,20)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-98.2,14.4,-22.6),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 9,
		FrontConstant = 38000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 8,
		RearConstant = 38000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 63,
		Efficiency = 0.85,
		GripOffset = 2.5,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7600,
		PeakTorque = 80,
		PowerbandStart = 900,
		PowerbandEnd = 7200,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-90.3,42,-0.3),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = -1,

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

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.22,0.36,0.45},

		Mirrors = {
			left = {
				pos = Vector(22.7, 46, 6),
				ang = Angle(0, 5, 0),
				h = 1 / 4,
				ratio = 4 / 2.75,
			},
			right = {
				pos = Vector(22.7, -46, 6),
				ang = Angle(0, 5, 0),
				h = 1 / 4,
				ratio = 4 / 2.75,
			},
		},

		Plates = {
			Front = {
				pos = Vector(100, -10, -11),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-104.5, 10, -12),
				ang = Angle(0, -90, 90),
			},
		},

		HUDPos = Vector(20, 38, 27.5),
		HUDAng = Angle(0, 0, 65),

		RadioPos = Vector(23, 2.5, 1),
		RadioAng = Angle(0, 180, 0),

	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_vincent", V )

local V = {
	Name = "Washington",
	Model = "models/octocar/sedans/washing.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1850,

		EnginePos = Vector(100,0,10),

		Plates = {
			Front = {
				pos = Vector(103.05, -10, -12.5),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-105, 10, -4.5),
				ang = Angle(0, -90, 60),
			},
		},

		LightsTable = "washing",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/washing_wheel.mdl",
		CustomWheelPosFL = Vector(62.2,29.8,-16.9),
		CustomWheelPosFR = Vector(62.2,-29.8,-16.9),
		CustomWheelPosRL = Vector(-62.6,29.8,-16.9),
		CustomWheelPosRR = Vector(-62.6,-29.8,-16.9),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(2,-16.75,12),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(12,-16,-19),
				ang = Angle(0,-90,20),
				hasRadio = true,
			},
			{
				pos = Vector(-32,17,-19),
				ang = Angle(0,-90,20),
			},
			{
				pos = Vector(-32,-17,-19),
				ang = Angle(0,-90,20),
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-106.5,-15.8,-20.5),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 8,
		FrontConstant = 42000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 7,
		RearConstant = 42000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 63,
		Efficiency = 0.85,
		GripOffset = 2.5,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7600,
		PeakTorque = 80,
		PowerbandStart = 900,
		PowerbandEnd = 7200,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-87.4,34.9,-6.1),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_088/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_088/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_088/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_089/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.45,
		Gears = {-0.12,0,0.08,0.18,0.29,0.40,0.48},

		RadioPos = Vector(29.6, 0, 4),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(22, 30, 27),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(21.5, 39.5, 8),
				w = 1 / 5,
				ratio = 3 / 2,
			},
			top = {
				pos = Vector(16.5, 0, 18),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			right = {
				pos = Vector(21.5, -39.5, 8),
				w = 1 / 5,
				ratio = 3 / 2,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_washing", V )

local V = {
	Name = "Willard",
	Model = "models/octocar/sedans/willard.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Sedans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1800,

		EnginePos = Vector(60,0,10),

		LightsTable = "willard",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/sedans/willard_wheel.mdl",
		CustomWheelPosFL = Vector(51.8,34.2,-8.6),
		CustomWheelPosFR = Vector(51.8,-34.2,-8.6),
		CustomWheelPosRL = Vector(-59.7,34.2,-8.6),
		CustomWheelPosRR = Vector(-59.7,-34.2,-8.6),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-4,-17,18),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(4,-17,-13),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-29,17,-12),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-29,-17,-12),
				ang = Angle(0,-90,20)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-95.7,15.1,-13.6),
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
		LimitRPM = 6400,
		PeakTorque = 74,
		PowerbandStart = 900,
		PowerbandEnd = 6100,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-79.5,40.3,6.8),
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

		DifferentialGear = 0.32,
		Gears = {-0.12,0,0.1,0.22,0.38,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_willard", V )
