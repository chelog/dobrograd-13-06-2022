local V = {
	Name = "Elegy",
	Model = "models/octocar/tuners/elegy.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Tuners",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1500,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(93, -10, -5),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-85, 10, -7),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "elegy",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/tuners/elegy_wheel.mdl",
		CustomWheelPosFL = Vector(56,33,-14),
		CustomWheelPosFR = Vector(56,-33,-14),
		CustomWheelPosRL = Vector(-47,33,-14),
		CustomWheelPosRR = Vector(-47,-33,-14),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-10,-19.15,15),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(2,-17,-15),
				ang = Angle(0,-90,25),
				hasRadio = true,
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-87,-17,-15),
				ang = Angle(90,180,0),
			},{
				pos = Vector(-87,17,-15),
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

		MaxGrip = 55,
		Efficiency = 0.85,
		GripOffset = 1,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7800,
		PeakTorque = 76,
		PowerbandStart = 900,
		PowerbandEnd = 7600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-25,-37,3),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 0.95,

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

		DifferentialGear = 0.4,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		RadioPos = Vector(22.8, 0, 7),
		RadioAng = Angle(-20, 180, 0),

		HUDPos = Vector(20, 37, 27.5),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(20.2, 37, 13),
				w = 1 / 5,
				ratio = 4 / 3,
			},
			top = {
				pos = Vector(3.5, 0, 22),
				w = 1 / 3,
				ratio = 3 / 1,
			},
			right = {
				pos = Vector(20.2, -37, 13),
				w = 1 / 5,
				ratio = 4 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_elegy", V )

local V = {
	Name = "Flash",
	Model = "models/octocar/tuners/flash.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Tuners",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1400,

		EnginePos = Vector(60,0,10),

		LightsTable = "flash",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/tuners/flash_wheel.mdl",
		CustomWheelPosFL = Vector(50,30,-12),
		CustomWheelPosFR = Vector(50,-30,-12),
		CustomWheelPosRL = Vector(-50,30,-12),
		CustomWheelPosRR = Vector(-50,-30,-12),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-10,-16,15),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(2,-17,-17),
				ang = Angle(0,-90,25)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-75,-17,-15),
				ang = Angle(90,180,0),
			},{
				pos = Vector(-75,17,-15),
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
		GripOffset = -1,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7800,
		PeakTorque = 76,
		PowerbandStart = 900,
		PowerbandEnd = 7600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-31,-34,4),
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
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_flash", V )

local V = {
	Name = "Jester",
	Model = "models/octocar/tuners/jester.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Tuners",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1350,

		EnginePos = Vector(60,0,10),

		LightsTable = "jester",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/tuners/jester_wheel.mdl",
		CustomWheelPosFL = Vector(53,35,-12),
		CustomWheelPosFR = Vector(53,-35,-12),
		CustomWheelPosRL = Vector(-52,35,-12),
		CustomWheelPosRR = Vector(-52,-35,-12),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-13,-16,15),
		SeatPitch = -10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-1,-17,-17),
				ang = Angle(0,-90,25),
				hasRadio = true,
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-84,-21,-13),
				ang = Angle(90,180,0),
			},{
				pos = Vector(-84,21,-13),
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

		MaxGrip = 55,
		Efficiency = 0.85,
		GripOffset = -0.9,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7800,
		PeakTorque = 80,
		PowerbandStart = 900,
		PowerbandEnd = 7600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-64,37,7),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = -0.2,

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

		RadioPos = Vector(18, 0, 2.7),
		RadioAng = Angle(-8, 180, 0),

		Mirrors = {
			left = {
				pos = Vector(20, 41, 13),
				w = 1 / 5,
				ratio = 5 / 3,
			},
			right = {
				pos = Vector(20, -41, 13),
				w = 1 / 5,
				ratio = 5 / 3,
			},
		},

		Plates = {
			Front = {
				pos = Vector(100.5, -10, -7),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-89, 10, -1),
				ang = Angle(0, -90, 95),
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_jester", V )

local V = {
	Name = "Stratum",
	Model = "models/octocar/tuners/stratum.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Tuners",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1800,

		EnginePos = Vector(60,0,10),

		LightsTable = "stratum",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/tuners/stratum_wheel.mdl",
		CustomWheelPosFL = Vector(61,33,-18),
		CustomWheelPosFR = Vector(61,-33,-18),
		CustomWheelPosRL = Vector(-51,33,-18),
		CustomWheelPosRR = Vector(-51,-33,-18),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-2,-18,15),
		SeatPitch = -4,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(10,-17,-17),
				ang = Angle(0,-90,18)
			},
			{
				pos = Vector(-23,-18,-15),
				ang = Angle(0,-90,18)
			},
			{
				pos = Vector(-23,18,-15),
				ang = Angle(0,-90,18)
			},
			{
				pos = Vector(-23,0,-15),
				ang = Angle(0,-90,18)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-100,-17,-18),
				ang = Angle(90,180,0),
			},{
				pos = Vector(-100,17,-18),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 39000,
		FrontDamping = 1600,
		FrontRelativeDamping = 1600,

		RearHeight = 5,
		RearConstant = 39000,
		RearDamping = 1600,
		RearRelativeDamping = 1600,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 56,
		Efficiency = 0.85,
		GripOffset = 1,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7800,
		PeakTorque = 88,
		PowerbandStart = 900,
		PowerbandEnd = 7600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-84,-37,3),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 0.9,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_080/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_080/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_080/sound_001.wav",
		Sound_HighPitch = 0.9,
		Sound_HighVolume = 1,
		Sound_HighFadeInRPMpercent = 50,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_081/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.4,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_stratum", V )

local V = {
	Name = "Sultan",
	Model = "models/octocar/tuners/sultan.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Tuners",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1400,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(97.5, -10, -5),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-87.5, 10, -1.5),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "sultan",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/tuners/sultan_wheel.mdl",
		CustomWheelPosFL = Vector(56,34,-12),
		CustomWheelPosFR = Vector(56,-34,-12),
		CustomWheelPosRL = Vector(-52,34,-12),
		CustomWheelPosRR = Vector(-52,-34,-12),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-2,-18,15),
		SeatPitch = -4,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(10,-17,-17),
				ang = Angle(0,-90,18),
				hasRadio = true,
			},
			{
				pos = Vector(-23,-18,-15),
				ang = Angle(0,-90,18)
			},
			{
				pos = Vector(-23,18,-15),
				ang = Angle(0,-90,18)
			},
			{
				pos = Vector(-23,0,-15),
				ang = Angle(0,-90,18)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-90,-16,-14),
				ang = Angle(90,180,0),
			},{
				pos = Vector(-90,16,-14),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 39000,
		FrontDamping = 1600,
		FrontRelativeDamping = 1600,

		RearHeight = 5,
		RearConstant = 39000,
		RearDamping = 1600,
		RearRelativeDamping = 1600,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 55,
		Efficiency = 0.85,
		GripOffset = 0.5,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7800,
		PeakTorque = 80,
		PowerbandStart = 900,
		PowerbandEnd = 7600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-66,-37,7),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 60,

		PowerBias = 0.2,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_080/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_080/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_080/sound_001.wav",
		Sound_HighPitch = 0.9,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_081/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.4,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		RadioPos = Vector(29.3, 0, 10),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(0, 33.4, 32.6),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(24.5, 40, 15),
				w = 1 / 5,
				ratio = 2 / 1,
			},
			top = {
				pos = Vector(19, 0, 24),
				w = 1 / 3,
				ratio = 4 / 1,
			},
			right = {
				pos = Vector(24.5, -40, 15),
				w = 1 / 5,
				ratio = 2 / 1,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_sultan", V )

local V = {
	Name = "Uranus",
	Model = "models/octocar/tuners/uranus.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Tuners",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1500,

		EnginePos = Vector(60,0,10),

		LightsTable = "uranus",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/tuners/uranus_wheel.mdl",
		CustomWheelPosFL = Vector(49,33,-12),
		CustomWheelPosFR = Vector(49,-33,-12),
		CustomWheelPosRL = Vector(-55,34,-12),
		CustomWheelPosRR = Vector(-55,-34,-12),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-14,-17,18),
		SeatPitch = -4,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-3,-17,-12),
				ang = Angle(0,-90,22)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-90,-16,-14),
				ang = Angle(90,180,0),
			},{
				pos = Vector(-90,16,-14),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 36000,
		FrontDamping = 1600,
		FrontRelativeDamping = 1600,

		RearHeight = 5,
		RearConstant = 36000,
		RearDamping = 1600,
		RearRelativeDamping = 1600,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 48,
		Efficiency = 0.85,
		GripOffset = 0.7,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 7700,
		PeakTorque = 72,
		PowerbandStart = 900,
		PowerbandEnd = 7500,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-70,37,9),
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
		Sound_HighPitch = 0.9,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_002/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.4,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.44}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_uranus", V )
