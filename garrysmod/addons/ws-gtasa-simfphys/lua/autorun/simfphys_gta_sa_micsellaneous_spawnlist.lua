local V = {
	Name = "Bloodring Banger",
	Model = "models/octocar/miscellaneous/bloodra.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Miscellaneous",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		LightsTable = "bloodra",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/miscellaneous/bloodra_wheel.mdl",
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

		FuelFillPos = Vector(-65.83032,40.38588,3.819456),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		PowerBias = 1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_064/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_064/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_064/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_065/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_bloodra", V )

local V = {
	Name = "Bloodring Banger 2",
	Model = "models/octocar/miscellaneous/bloodrb.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Miscellaneous",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		LightsTable = "bloodrb",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/miscellaneous/bloodrb_wheel.mdl",
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


		Sound_Idle = "dbg/cars/bank_064/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_064/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_064/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_065/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_bloodrb", V )

local V = {
	Name = "Hotring Racer",
	Model = "models/octocar/miscellaneous/hotring.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Miscellaneous",
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		LightsTable = "hotring",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/miscellaneous/hotring_wheel.mdl",
		CustomWheelPosFL = Vector(52.308,29.916,-18),
		CustomWheelPosFR = Vector(52.308,-29.916,-18),
		CustomWheelPosRL = Vector(-64.2348,29.916,-18),
		CustomWheelPosRR = Vector(-64.2348,-29.916,-18),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(5,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-18,-15,14),
		SeatPitch = -5,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-6,-15,-21),
				ang = Angle(0,-90,17)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-48.36672,-37.55772,-26.840412),
				ang = Angle(90,165,0),
			},
			{
				pos = Vector(-48.36672,37.55772,-26.840412),
				ang = Angle(90,165,0),
			}
		},

		FrontHeight = 5,
		FrontConstant = 38000,
		FrontDamping = 1200,
		FrontRelativeDamping = 1000,

		RearHeight = 5,
		RearConstant = 38000,
		RearDamping = 1200,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 3,

		MaxGrip = 52,
		Efficiency = 0.85,
		GripOffset = 1,
		BrakePower = 35,

		IdleRPM = 1100,
		LimitRPM = 5600,
		PeakTorque = 96,
		PowerbandStart = 1200,
		PowerbandEnd = 5400,
		Turbocharged = true,
		Supercharged = true,

		FuelFillPos = Vector(-79.12404,35.343072,4.337532),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		PowerBias = 1,
		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_031/sound_002.wav",
		Sound_IdlePitch = 1,
		Sound_IdleVolume = 3,

		Sound_Mid = "dbg/cars/bank_031/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 3,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_031/sound_001.wav",
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 3.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_032/sound_001.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 5,
		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.53333333333333,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_hotring", V )

local V = {
	Name = "Hotring Racer 2",
	Model = "models/octocar/miscellaneous/hotrina.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Miscellaneous",
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		LightsTable = "hotrina",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/miscellaneous/hotring_wheel.mdl",
		CustomWheelPosFL = Vector(58.34736,31.13946,-18),
		CustomWheelPosFR = Vector(58.34736,-31.13946,-18),
		CustomWheelPosRL = Vector(-53.68176,31.13946,-18),
		CustomWheelPosRR = Vector(-53.68176,-31.13946,-18),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(5,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-9,-15,14),
		SeatPitch = -5,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-1,-15,-21),
				ang = Angle(0,-90,17)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-40.78512,-35.75988,-26.840412),
				ang = Angle(90,165,0),
			},
			{
				pos = Vector(-40.78512,35.75988,-26.840412),
				ang = Angle(90,165,0),
			}
		},

		FrontHeight = 5,
		FrontConstant = 38000,
		FrontDamping = 1200,
		FrontRelativeDamping = 1000,

		RearHeight = 5,
		RearConstant = 38000,
		RearDamping = 1200,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 3,

		MaxGrip = 52,
		Efficiency = 0.85,
		GripOffset = 1,
		BrakePower = 35,

		IdleRPM = 1100,
		LimitRPM = 5600,
		PeakTorque = 96,
		PowerbandStart = 1200,
		PowerbandEnd = 5400,
		Turbocharged = true,
		Supercharged = true,

		FuelFillPos = Vector(-67.54716,35,5.021928),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		PowerBias = 1,
		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_031/sound_002.wav",
		Sound_IdlePitch = 1,
		Sound_IdleVolume = 3,

		Sound_Mid = "dbg/cars/bank_031/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 3,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_031/sound_001.wav",
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 3.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_032/sound_001.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 5,
		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.53333333333333,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_hotrina", V )

local V = {
	Name = "Hotring Racer 3",
	Model = "models/octocar/miscellaneous/hotrinb.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Miscellaneous",
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		LightsTable = "hotrinb",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/miscellaneous/hotring_wheel.mdl",
		CustomWheelPosFL = Vector(52.308,31.13946,-18),
		CustomWheelPosFR = Vector(52.308,-31.13946,-18),
		CustomWheelPosRL = Vector(-59.30064,31.13946,-18),
		CustomWheelPosRR = Vector(-59.30064,-31.13946,-18),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(5,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-14,-15,14),
		SeatPitch = -5,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-7,-15,-21),
				ang = Angle(0,-90,17)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-48.6612,-37.04544,-26.297532),
				ang = Angle(90,165,0),
			},
			{
				pos = Vector(-48.6612,37.04544,-26.297532),
				ang = Angle(90,165,0),
			}
		},

		FrontHeight = 5,
		FrontConstant = 38000,
		FrontDamping = 1200,
		FrontRelativeDamping = 1000,

		RearHeight = 5,
		RearConstant = 38000,
		RearDamping = 1200,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 3,

		MaxGrip = 52,
		Efficiency = 0.85,
		GripOffset = 1,
		BrakePower = 35,

		IdleRPM = 1100,
		LimitRPM = 5600,
		PeakTorque = 96,
		PowerbandStart = 1200,
		PowerbandEnd = 5400,
		Turbocharged = true,
		Supercharged = true,

		FuelFillPos = Vector(-73.76544,36.40248,1),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		PowerBias = 1,
		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_094/sound_002.wav",
		Sound_IdlePitch = 1,
		Sound_IdleVolume = 3,

		Sound_Mid = "dbg/cars/bank_094/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 3,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_094/sound_001.wav",
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 3.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_095/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 5,
		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.53333333333333,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_hotrinb", V )