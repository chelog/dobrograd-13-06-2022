local V = {
	Name = "Blista Compact",
	Model = "models/octocar/coupes_hatchbacks/blistac.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1150,

		EnginePos = Vector(60,0,10),

		LightsTable = "blistac",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/blistac_wheel.mdl",
		CustomWheelPosFL = Vector(51.4,32,-11.1),
		CustomWheelPosFR = Vector(51.4,-32,-11.1),
		CustomWheelPosRL = Vector(-50,32,-11.1),
		CustomWheelPosRR = Vector(-50,-32,-11.1),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-13,-18,16),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(0,-17,-16),
				ang = Angle(0,-90,25),
				hasRadio = true,
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-77,-19.8,-17.2),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 36000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 5,
		RearConstant = 36000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 6,

		MaxGrip = 32,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7400,
		PeakTorque = 60,
		PowerbandStart = 900,
		PowerbandEnd = 7000,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-66.6,-37,5),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_086/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_086/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_086/sound_001.wav",
		Sound_HighPitch = 0.9,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_087/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.4,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		RadioPos = Vector(18.8, -1, 4.7),
		RadioAng = Angle(-10, 180, 0),

		Mirrors = {
			left = {
				pos = Vector(14, 43, 13),
				w = 1 / 5,
				ratio = 4 / 3,
			},
			top = {
				pos = Vector(6, 0, 23),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			right = {
				pos = Vector(14, -43, 13),
				w = 1 / 5,
				ratio = 4 / 3,
			},
		},

		Plates = {
			Front = {
				pos = Vector(84.75, -10, -3),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-79.75, 10, -4),
				ang = Angle(0, -90, 90),
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_blistac", V )

local V = {
	Name = "Bravura",
	Model = "models/octocar/coupes_hatchbacks/bravura.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1300,

		EnginePos = Vector(60,0,10),

		LightsTable = "bravura",

		Plates = {
			Front = {
				pos = Vector(103, -10, -8),
				ang = Angle(0, 90, 110),
			},
			Back = {
				pos = Vector(-87.75, 10, 4.25),
				ang = Angle(0, -90, 90),
			},
		},

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/bravura_wheel.mdl",
		CustomWheelPosFL = Vector(58.3,35.2,-12.2),
		CustomWheelPosFR = Vector(58.3,-35.2,-12.2),
		CustomWheelPosRL = Vector(-53.6,35.2,-12.2),
		CustomWheelPosRR = Vector(-53.6,-35.2,-12.2),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-6,-17,16),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(5,-17,-15),
				ang = Angle(0,-90,25),
				hasRadio = true,
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-88.9,-15.8,-16.5),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 36000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 5,
		RearConstant = 36000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 48,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 5300,
		PeakTorque = 60,
		PowerbandStart = 900,
		PowerbandEnd = 4900,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-33.8,-38.8,0),
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

		DifferentialGear = 0.38666666666667,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		RadioPos = Vector(24, 0, 9.5),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(0, 39, 28),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(19, 45, 13.5),
				w = 1 / 5,
				ratio = 4 / 3,
			},
			top = {
				pos = Vector(10, 0, 20),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			right = {
				pos = Vector(19, -45, 13.5),
				w = 1 / 5,
				ratio = 4 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_bravura", V )

local V = {
	Name = "Buccaneer",
	Model = "models/octocar/coupes_hatchbacks/buccanee.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1700,

		EnginePos = Vector(60,0,10),

		LightsTable = "buccanee",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/buccanee_wheel.mdl",
		CustomWheelPosFL = Vector(64.8,33.8,-13),
		CustomWheelPosFR = Vector(64.8,-33.8,-13),
		CustomWheelPosRL = Vector(-52.5,33.8,-13),
		CustomWheelPosRR = Vector(-52.5,-33.8,-13),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-4,-19,13),
		SeatPitch = -5,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(6,-18,-16),
				ang = Angle(0,-90,25)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-102.5,15.1,-16.2),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 8,
		FrontConstant = 38000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 7,
		RearConstant = 38000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 47,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 30,

		IdleRPM = 700,
		LimitRPM = 4800,
		PeakTorque = 76,
		PowerbandStart = 800,
		PowerbandEnd = 4600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-78.4,-42,-2.1),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 55,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_039/sound_002.wav",
		Sound_IdlePitch = 0.8,

		Sound_Mid = "dbg/cars/bank_039/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_039/sound_001.wav",
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_039/sound_001.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.12,0.23,0.40,0.6}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_buccanee", V )

local V = {
	Name = "Cadrona",
	Model = "models/octocar/coupes_hatchbacks/cadrona.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1200,

		EnginePos = Vector(60,0,10),

		LightsTable = "cadrona",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/cadrona_wheel.mdl",
		CustomWheelPosFL = Vector(57.6,32.4,-12.6),
		CustomWheelPosFR = Vector(57.6,-32.4,-12.6),
		CustomWheelPosRL = Vector(-47.8,32.4,-12.6),
		CustomWheelPosRR = Vector(-47.8,-32.4,-12.6),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-3,-14,16),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(4,-14,-16),
				ang = Angle(0,-90,14),
				hasRadio = true,
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-83.1,-16.9,-13.6),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 26000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 5,
		RearConstant = 26000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 27,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 4.8,

		MaxGrip = 40,
		Efficiency = 0.85,
		GripOffset = -1,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 5300,
		PeakTorque = 70,
		PowerbandStart = 900,
		PowerbandEnd = 4900,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-60.8,37,5.2),
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

		DifferentialGear = 0.37,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		HUDPos = Vector(0, 36, 30),
		HUDAng = Angle(0, 0, 65),

		Plates = {
			Front = {
				pos = Vector(102.5, -10, -3),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-85, 10, 6.5),
				ang = Angle(0, -90, 75),
			},
		},

		RadioPos = Vector(26.5, 0, 9),
		RadioAng = Angle(-13, 180, 0),

		Mirrors = {
			left = {
				pos = Vector(23, 42, 14),
				w = 1 / 5,
				ratio = 3 / 2,
			},
			top = {
				pos = Vector(11, 0, 24.5),
				w = 1 / 3,
				ratio = 3 / 1,
			},
			right = {
				pos = Vector(23, -42, 14),
				w = 1 / 5,
				ratio = 3 / 2,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_cadrona", V )

local V = {
	Name = "Clover",
	Model = "models/octocar/coupes_hatchbacks/clover.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		LightsTable = "clover",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/clover_wheel.mdl",
		CustomWheelPosFL = Vector(57.9,32,-13.3),
		CustomWheelPosFR = Vector(57.9,-32,-13.3),
		CustomWheelPosRL = Vector(-56.8,32,-13.3),
		CustomWheelPosRR = Vector(-56.8,-32,-13.3),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-10,-18,15),
		SeatPitch = -5,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(2,-18,-14),
				ang = Angle(0,-90,21)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-101.1,-21.2,-13.6),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 8,
		FrontConstant = 38000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 7,
		RearConstant = 38000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 42,
		Efficiency = 0.85,
		GripOffset = 3,
		BrakePower = 30,

		IdleRPM = 700,
		LimitRPM = 4800,
		PeakTorque = 76,
		PowerbandStart = 800,
		PowerbandEnd = 4600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-69.1,36,11.1),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 55,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_039/sound_002.wav",
		Sound_IdlePitch = 0.8,

		Sound_Mid = "dbg/cars/bank_039/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_039/sound_001.wav",
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_039/sound_001.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.12,0.23,0.40,0.6}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_clover", V )

local V = {
	Name = "Club",
	Model = "models/octocar/coupes_hatchbacks/club.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1400,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(90.5, -10, -2),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-82.5, 9.5, 7.5),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "club",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/club_wheel.mdl",
		CustomWheelPosFL = Vector(58.6,34.5,-8.5),
		CustomWheelPosFR = Vector(58.6,-34.5,-8.5),
		CustomWheelPosRL = Vector(-58.3,34.5,-8.5),
		CustomWheelPosRR = Vector(-58.3,-34.5,-8.5),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-6,-15,21),
		SeatPitch = -4,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(2,-17,-9),
				ang = Angle(0,-90,15),
				hasRadio = true,
			},
			{
				pos = Vector(-34,-17,-7),
				ang = Angle(0,-90,15),
			},
			{
				pos = Vector(-34,17,-7),
				ang = Angle(0,-90,15),
			},
		},

		ExhaustPositions = {
			{
				pos = Vector(-84.2,-20.52,-12.6),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-84.2,20.52,-12.6),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 8,
		FrontConstant = 36000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 7,
		RearConstant = 36000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 44,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7400,
		PeakTorque = 56,
		PowerbandStart = 900,
		PowerbandEnd = 7000,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-31.93,-35.16,4.28),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = -1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_086/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_086/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_086/sound_001.wav",
		Sound_HighPitch = 0.9,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_087/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.4,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		RadioPos = Vector(26.6, 0, 16),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(15, 36, 32.5),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(23, 38.5, 20),
				w = 1 / 5,
				ratio = 17 / 9,
			},
			top = {
				pos = Vector(10, 0, 32),
				ang = Angle(5, 0, 0),
				w = 1 / 3,
				ratio = 3 / 1,
			},
			right = {
				pos = Vector(23, -38.5, 20),
				w = 1 / 5,
				ratio = 17 / 9,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_club", V )

local V = {
	Name = "Esperanto",
	Model = "models/octocar/coupes_hatchbacks/esperant.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1800,

		EnginePos = Vector(60,0,10),

		LightsTable = "esperant",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/esperant_wheel.mdl",
		CustomWheelPosFL = Vector(58.18392,32.4,-18),
		CustomWheelPosFR = Vector(58.18392,-32.4,-18),
		CustomWheelPosRL = Vector(-58.176,32.4,-18),
		CustomWheelPosRR = Vector(-58.176,-32.4,-18),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-11,-16,13),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(0,-17,-18),
				ang = Angle(0,-90,25)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-105.44004,-20.379816,-19.357704),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 36000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 5,
		RearConstant = 36000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 44,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7400,
		PeakTorque = 76,
		PowerbandStart = 900,
		PowerbandEnd = 7000,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-71.5572,38.77308,1.01574),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 54,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_086/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_086/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_086/sound_001.wav",
		Sound_HighPitch = 0.9,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_087/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.38666666666667,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_esperant", V )

local V = {
	Name = "Feltzer",
	Model = "models/octocar/coupes_hatchbacks/feltzer.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(92.75, -10, -7.5),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-92.75, 10, 4),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "feltzer",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/feltzer_wheel.mdl",
		CustomWheelPosFL = Vector(56.34288,32,-13),
		CustomWheelPosFR = Vector(56.34288,-32,-13),
		CustomWheelPosRL = Vector(-56.41524,32,-13),
		CustomWheelPosRR = Vector(-56.41524,-32,-13),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-10,-17.5,17),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(2,-17,-16),
				ang = Angle(0,-90,25),
				hasRadio = true,
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-87.58188,-18.42318,-15.377904),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-87.58188,18.42318,-15.377904),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 42000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 5,
		RearConstant = 42000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 48,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7400,
		PeakTorque = 76,
		PowerbandStart = 900,
		PowerbandEnd = 7000,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-70.48764,-36.71568,5),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_086/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_086/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_086/sound_001.wav",
		Sound_HighPitch = 0.9,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_087/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.4,
		Gears = {-0.12,0,0.1,0.17,0.25,0.35,0.5},

		RadioPos = Vector(21.8, 0, 2.4),
		RadioAng = Angle(-25, 180, 0),

		HUDPos = Vector(0, 38.5, 29),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(17, 38.5, 13.5),
				w = 1 / 5,
				ratio = 5 / 3,
			},
			top = {
				pos = Vector(11.5, 0, 21),
				w = 1 / 3,
				ratio = 4 / 1,
			},
			right = {
				pos = Vector(17, -38.5, 13.5),
				w = 1 / 5,
				ratio = 5 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_feltzer", V )

local V = {
	Name = "Fortune",
	Model = "models/octocar/coupes_hatchbacks/fortune.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1700,

		EnginePos = Vector(60,0,10),

		LightsTable = "fortune",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/fortune_wheel.mdl",
		CustomWheelPosFL = Vector(53.81676,31.5,-14.4),
		CustomWheelPosFR = Vector(53.81676,-31.5,-14.4),
		CustomWheelPosRL = Vector(-53.85564,31.5,-14.4),
		CustomWheelPosRR = Vector(-53.85564,-31.5,-14.4),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(8,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-8,-17,11),
		SeatPitch = -5,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(6,-17,-18),
				ang = Angle(0,-90,26)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-82.84644,-17.413524,-18.26802),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 8,
		FrontConstant = 38000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 7,
		RearConstant = 38000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 42,
		Efficiency = 0.85,
		GripOffset = 3,
		BrakePower = 30,

		IdleRPM = 700,
		LimitRPM = 4800,
		PeakTorque = 76,
		PowerbandStart = 800,
		PowerbandEnd = 4600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-70.40916,35.625672,2.179836),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_019/sound_002.wav",
		Sound_IdlePitch = 0.8,

		Sound_Mid = "dbg/cars/bank_019/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_019/sound_001.wav",
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_020/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.12,0.23,0.40,0.6}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_fortune", V )

local V = {
	Name = "Hermes",
	Model = "models/octocar/coupes_hatchbacks/hermes.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1950,

		EnginePos = Vector(60,0,10),

		LightsTable = "hermes",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/hermes_wheel.mdl",
		CustomWheelPosFL = Vector(65.19672,34.202844,-18),
		CustomWheelPosFR = Vector(65.19672,-34.202844,-18),
		CustomWheelPosRL = Vector(-65.09448,34.202844,-18),
		CustomWheelPosRR = Vector(-65.09448,-34.202844,-18),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-14,-18,16),
		SeatPitch = -5,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-9,-17,-17),
				ang = Angle(0,-90,15)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-101.6928,-21.169584,-21.07944),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-101.6928,21.169584,-21.07944),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 45000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 5,
		RearConstant = 45000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 52,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7400,
		PeakTorque = 80,
		PowerbandStart = 900,
		PowerbandEnd = 7000,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-101.6928,0,-13.493088),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 54,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_028/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_028/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_028/sound_001.wav",
		Sound_HighPitch = 0.9,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_028/sound_001.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.38666666666667,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_hermes", V )

local V = {
	Name = "Hustler",
	Model = "models/octocar/coupes_hatchbacks/hustler.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1700,

		EnginePos = Vector(40,0,10),

		LightsTable = "hustler",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/hustler_wheel.mdl",
		CustomWheelPosFL = Vector(51.0138,30.592116,-18),
		CustomWheelPosFR = Vector(51.0138,-30.592116,-18),
		CustomWheelPosRL = Vector(-51.01416,30.592116,-18),
		CustomWheelPosRR = Vector(-51.01416,-30.592116,-18),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-14,-12,16),
		SeatPitch = -5,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-7,-13,-18),
				ang = Angle(0,-90,15)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-81.54576,-11.132064,-23.331672),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-81.54576,11.132064,-23.331672),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 45000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 5,
		RearConstant = 45000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 52,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7400,
		PeakTorque = 80,
		PowerbandStart = 900,
		PowerbandEnd = 7000,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-79.99236,0,-11.630952),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 54,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_069/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_069/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_069/sound_001.wav",
		Sound_HighPitch = 0.9,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_069/sound_001.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.38666666666667,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_hustler", V )

local V = {
	Name = "Majestic",
	Model = "models/octocar/coupes_hatchbacks/majestic.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1400,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(111, -10, -9),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-100.75, 10, -1),
				ang = Angle(0, -90, 70),
			},
		},

		LightsTable = "majestic",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/majestic_wheel.mdl",
		CustomWheelPosFL = Vector(60.59232,33.264,-14.4),
		CustomWheelPosFR = Vector(60.59232,-33.264,-14.4),
		CustomWheelPosRL = Vector(-53.43264,33.264,-14.4),
		CustomWheelPosRR = Vector(-53.43264,-33.264,-14.4),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-8,-18.05,16),
		SeatPitch = -5,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(1,-16,-14),
				ang = Angle(-4,-90,17),
				hasRadio = true,
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-103.55292,-18.006732,-18.407232),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 8,
		FrontConstant = 38000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 7,
		RearConstant = 38000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 42,
		Efficiency = 0.85,
		GripOffset = 3,
		BrakePower = 30,

		IdleRPM = 700,
		LimitRPM = 4800,
		PeakTorque = 78,
		PowerbandStart = 800,
		PowerbandEnd = 4600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-70.30656,39.48228,2.396448),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_086/sound_002.wav",
		Sound_IdlePitch = 0.8,

		Sound_Mid = "dbg/cars/bank_086/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_086/sound_001.wav",
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_086/sound_001.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.12,0.23,0.43,0.62},

		RadioPos = Vector(25, 0, 6),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(-1.05, 45, 27),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(21, 43, 11.5),
				w = 1 / 5,
				ratio = 4 / 3,
			},
			right = {
				pos = Vector(21, -43, 11.5),
				w = 1 / 5,
				ratio = 4 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_majestic", V )

local V = {
	Name = "Manana",
	Model = "models/octocar/coupes_hatchbacks/manana.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1000,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(87, -10, -4),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-81.5, 10, 8),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "manana",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/manana_wheel.mdl",
		CustomWheelPosFL = Vector(49.94604,29.628,-10),
		CustomWheelPosFR = Vector(49.94604,-29.628,-10),
		CustomWheelPosRL = Vector(-49.55148,29.628,-10),
		CustomWheelPosRR = Vector(-49.55148,-29.628,-10),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-9,-14,18),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(1,-14,-14),
				ang = Angle(0,-90,21),
				hasRadio = true,
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-83.70504,-14.16996,-16.001676),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 34000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 5,
		RearConstant = 34000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 40,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 5300,
		PeakTorque = 60,
		PowerbandStart = 900,
		PowerbandEnd = 4900,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-60.1128,34.872048,7.709868),
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

		DifferentialGear = 0.38666666666667,
		Gears = {-0.12,0,0.1,0.21,0.38,0.45},

		RadioPos = Vector(18, 0, 10),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(0, 33, 31),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(18.5, 38, 14.5),
				w = 1 / 5,
				ratio = 16 / 9,
			},
			top = {
				pos = Vector(8.5, 0, 23),
				ang = Angle(5, 0, 0),
				w = 1 / 3,
				ratio = 3 / 1,
			},
			right = {
				pos = Vector(18.5, -38, 14.5),
				w = 1 / 5,
				ratio = 16 / 9,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_manana", V )

local V = {
	Name = "Previon",
	Model = "models/octocar/coupes_hatchbacks/previon.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1400,

		EnginePos = Vector(60,0,10),

		LightsTable = "previon",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/previon_wheel.mdl",
		CustomWheelPosFL = Vector(49.644,30.661884,-13),
		CustomWheelPosFR = Vector(49.644,-30.661884,-13),
		CustomWheelPosRL = Vector(-50.44176,30.661884,-13),
		CustomWheelPosRR = Vector(-50.44176,-30.661884,-13),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-9,-14,18),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(1,-14,-14),
				ang = Angle(0,-90,21)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-91.1772,-17.542584,-18.029088),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 34000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 5,
		RearConstant = 34000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 40,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 5300,
		PeakTorque = 60,
		PowerbandStart = 900,
		PowerbandEnd = 4900,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-65.62872,35.564004,5.074308),
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

		DifferentialGear = 0.38666666666667,
		Gears = {-0.12,0,0.1,0.21,0.38,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_previon", V )

local V = {
	Name = "Sabre",
	Model = "models/octocar/coupes_hatchbacks/sabre.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1700,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(92.5, -10, -9),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-103, 10, -7),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "sabre",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/sabre_wheel.mdl",
		CustomWheelPosFL = Vector(55.5552,33.3,-14),
		CustomWheelPosFR = Vector(55.5552,-33.3,-14),
		CustomWheelPosRL = Vector(-55.9422,33.3,-14),
		CustomWheelPosRR = Vector(-55.9422,-33.3,-14),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-9,-16,11),
		SeatPitch = -5,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(4,-16,-21),
				ang = Angle(0,-90,25),
				hasRadio = true,
			}, {
				pos = Vector(-22,0,-21),
				ang = Angle(0,-90,25),
			},
		},

		ExhaustPositions = {
			{
				pos = Vector(-92.96496,-17.457084,-17.96292),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 8,
		FrontConstant = 38000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 7,
		RearConstant = 38000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 52,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 30,

		IdleRPM = 700,
		LimitRPM = 5200,
		PeakTorque = 85,
		PowerbandStart = 800,
		PowerbandEnd = 4900,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-57.6054,38.3652,4.681116),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 55,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_039/sound_002.wav",
		Sound_IdlePitch = 0.8,

		Sound_Mid = "dbg/cars/bank_039/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_039/sound_001.wav",
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_039/sound_001.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.12,0.23,0.40,0.6},

		RadioPos = Vector(19.2, 0, 6),
		RadioAng = Angle(-5, 180, 0),

		HUDPos = Vector(0, 38.5, 32.5),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(10.5, 41.5, 11.5),
				w = 1 / 5,
				ratio = 14 / 9,
			},
			top = {
				pos = Vector(7, 0, 19.5),
				--ang = Angle(5, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			right = {
				pos = Vector(10.5, -41.5, 11.5),
				w = 1 / 5,
				ratio = 14 / 9,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_sabre", V )

local V = {
	Name = "Stallion",
	Model = "models/octocar/coupes_hatchbacks/stallion.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		LightsTable = "stallion",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/stallion_wheel.mdl",
		CustomWheelPosFL = Vector(56.052,31.5,-17),
		CustomWheelPosFR = Vector(56.052,-31.5,-17),
		CustomWheelPosRL = Vector(-54.468,31.5,-17),
		CustomWheelPosRR = Vector(-54.468,-31.5,-17),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(7,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-20,-18,14),
		SeatPitch = -5,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-8,-16,-19),
				ang = Angle(0,-90,25),
				hasRadio = true,
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-92.12508,12.439548,-15.322356),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-92.12508,-12.439548,-15.322356),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 8,
		FrontConstant = 38000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 7,
		RearConstant = 38000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 47,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 30,

		IdleRPM = 700,
		LimitRPM = 5600,
		PeakTorque = 66,
		PowerbandStart = 800,
		PowerbandEnd = 5400,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-54.468,39.79656,2.226204),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 55,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_039/sound_002.wav",
		Sound_IdlePitch = 0.8,

		Sound_Mid = "dbg/cars/bank_039/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_039/sound_001.wav",
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_039/sound_001.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.12,0.23,0.40,0.6},

		RadioPos = Vector(11.7, -0.5, 1.5),
		RadioAng = Angle(0, 180, 0),

		Mirrors = {
			left = {
				pos = Vector(8, 42, 7.5),
				w = 1 / 5,
				ratio = 5 / 3,
			},
			top = {
				pos = Vector(5, 0, 20.5),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			right = {
				pos = Vector(8, -42, 7.5),
				w = 1 / 5,
				ratio = 5 / 3,
			},
		},

		Plates = {
			Front = {
				pos = Vector(91.75, -10, -14),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-94.75, 10, -10),
				ang = Angle(0, -90, 90),
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_stallion", V )

local V = {
	Name = "Tampa",
	Model = "models/octocar/coupes_hatchbacks/tampa.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1700,

		EnginePos = Vector(60,0,10),

		LightsTable = "tampa",

		Plates = {
			Front = {
				pos = Vector(94.5, -10, -6.5),
				ang = Angle(10, 90, 95),
			},
			Back = {
				pos = Vector(-93, 10, 5),
				ang = Angle(-5, -90, 90),
			},
		},

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/tampa_wheel.mdl",
		CustomWheelPosFL = Vector(62.64396,34.733088,-13),
		CustomWheelPosFR = Vector(62.64396,-34.733088,-13),
		CustomWheelPosRL = Vector(-52.38036,34.733088,-13),
		CustomWheelPosRR = Vector(-52.38036,-34.733088,-13),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(0,-16,13),
		SeatPitch = -5,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(13,-16,-16),
				ang = Angle(0,-90,25),
				hasRadio = true,
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-88.90524,-16.130484,-15.043212),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 8,
		FrontConstant = 38000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 7,
		RearConstant = 38000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 47,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 30,

		IdleRPM = 700,
		LimitRPM = 4800,
		PeakTorque = 76,
		PowerbandStart = 800,
		PowerbandEnd = 4600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-42.33816,38.8134,7.956108),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 55,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_088/sound_002.wav",
		Sound_IdlePitch = 0.8,

		Sound_Mid = "dbg/cars/bank_088/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_088/sound_001.wav",
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_089/sound_001.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.12,0.23,0.40,0.6},

		RadioPos = Vector(33, 0, 10),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(0, 35.4, 32.1),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(38, 41, 11.5),
				w = 1 / 7,
				ratio = 1 / 1,
			},
			right = {
				pos = Vector(38, -41, 11.5),
				w = 1 / 7,
				ratio = 1 / 1,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_tampa", V )

local V = {
	Name = "Virgo",
	Model = "models/octocar/coupes_hatchbacks/virgo.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Coupes & Hatchbacks",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1700,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(97, 12.5, -12.5),
				ang = Angle(0, 90, 105),
			},
			Back = {
				pos = Vector(-110, 10, -12.5),
				ang = Angle(0, -90, 100),
			},
		},

		LightsTable = "virgo",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/coupes_hatchbacks/virgo_wheel.mdl",
		CustomWheelPosFL = Vector(56.41236,30.024,-16),
		CustomWheelPosFR = Vector(56.41236,-30.024,-16),
		CustomWheelPosRL = Vector(-56.56968,30.024,-16),
		CustomWheelPosRR = Vector(-56.56968,-30.024,-16),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-14,-15,13),
		SeatPitch = -5,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(0,-15,-18),
				ang = Angle(0,-90,25),
				hasRadio = true,
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-104.70924,-20.864628,-20.425896),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 8,
		FrontConstant = 38000,
		FrontDamping = 1300,
		FrontRelativeDamping = 1300,

		RearHeight = 7,
		RearConstant = 38000,
		RearDamping = 1300,
		RearRelativeDamping = 1300,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 47,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 30,

		IdleRPM = 700,
		LimitRPM = 4800,
		PeakTorque = 76,
		PowerbandStart = 800,
		PowerbandEnd = 4600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-78.40908,35.563968,0),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 55,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_088/sound_002.wav",
		Sound_IdlePitch = 0.8,

		Sound_Mid = "dbg/cars/bank_088/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_088/sound_001.wav",
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_089/sound_001.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.12,0.23,0.40,0.6},

		RadioPos = Vector(14, 0, 5),
		RadioAng = Angle(-11, 180, 0),

		HUDPos = Vector(3, 38.5, 30),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(6, 38, 10.5),
				w = 1 / 5,
				ratio = 4 / 3,
			},
			top = {
				pos = Vector(1.5, 0, 18),
				ang = Angle(5, 0, 0),
				w = 1 / 3,
				ratio = 3 / 1,
			},
			right = {
				pos = Vector(6, -38, 10.5),
				w = 1 / 5,
				ratio = 4 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_virgo", V )
