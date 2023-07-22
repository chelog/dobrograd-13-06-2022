local V = {
	Name = "Benson",
	Model = "models/octocar/industrial/benson.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	Members = {
		Mass = 3500,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(94.5, -10, -13.5),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-128, 10, -10),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "benson",

		CustomWheels = true,
		CustomSuspensionTravel = 2,
		StrengthenSuspension = true,

		CustomWheelModel = "models/octocar/industrial/benson_wheel.mdl",
		CustomWheelPosFL = Vector(62,31,-24),
		CustomWheelPosFR = Vector(62,-31,-24),
		CustomWheelPosRL = Vector(-77,33,-24),
		CustomWheelPosRR = Vector(-77,-33,-24),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,6),

		CustomSteerAngle = 30,

		SeatOffset = Vector(5,-16,17),
		SeatPitch = 2,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(12,-17,-12),
				ang = Angle(0,-90,8),
				hasRadio = true,
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-120,-17,-25),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 3000,

		RearHeight = 8,
		RearConstant = 50000,
		RearDamping = 3000,
		RearRelativeDamping = 3000,

		FastSteeringAngle = 20,
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

		FuelFillPos = Vector(-40,37,-13),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_077/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_077/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_077/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_078/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.14,0.24,0.36,0.48,0.6},

		RadioPos = Vector(30.9, 0, 11),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(0, 35, 36.5),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(17.5, 43.3, 22),
				h = 3 / 5,
				ratio = 9 / 24,
			},
			right = {
				pos = Vector(17.5, -43.3, 22),
				h = 3 / 5,
				ratio = 9 / 24,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_benson", V )
local V = {
	Name = "Boxville",
	Model = "models/octocar/industrial/boxville.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	Members = {
		Mass = 5500,

		EnginePos = Vector(100,0,10),

		Plates = {
			Front = {
				pos = Vector(116, -8, -16.5),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-114, 10, -17),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "boxville",

		CustomWheels = true,
		CustomSuspensionTravel = 1,
		StrengthenSuspension = true,

		CustomWheelModel = "models/octocar/industrial/boxville_wheel.mdl",
		CustomWheelPosFL = Vector(86,39,-30),
		CustomWheelPosFR = Vector(86,-39,-30),
		CustomWheelPosRL = Vector(-62,39,-30),
		CustomWheelPosRR = Vector(-62,-39,-30),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(0,0,2),

		CustomSteerAngle = 30,

		SeatOffset = Vector(44,-25,39),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(53,-25,-2),
				ang = Angle(0,-90,0),
				hasRadio = true,
			},
			{
				pos = Vector(-89,-25,-8),
				ang = Angle(0,0,0),
				noMirrors = true,
			},
			{
				pos = Vector(-59,-25,-8),
				ang = Angle(0,0,0),
				noMirrors = true,
			},
			{
				pos = Vector(-29,-25,-8),
				ang = Angle(0,0,0),
				noMirrors = true,
			},
			{
				pos = Vector(1,-25,-8),
				ang = Angle(0,0,0),
				noMirrors = true,
			},
			{
				pos = Vector(-89,25,-8),
				ang = Angle(0,180,0),
				noMirrors = true,
			},
			{
				pos = Vector(-59,25,-8),
				ang = Angle(0,180,0),
				noMirrors = true,
			},
			{
				pos = Vector(-29,25,-8),
				ang = Angle(0,180,0),
				noMirrors = true,
			},
			{
				pos = Vector(1,25,-8),
				ang = Angle(0,180,0),
				noMirrors = true,
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-110,17,-25),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 2,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 3000,

		RearHeight = 2,
		RearConstant = 50000,
		RearDamping = 3000,
		RearRelativeDamping = 3000,

		FastSteeringAngle = 25,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 88,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 50,

		IdleRPM = 600,
		LimitRPM = 4000,
		PeakTorque = 112,
		PowerbandStart = 700,
		PowerbandEnd = 3800,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(0,41,3),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 65,

		PowerBias = 1,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_135/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_135/sound_001.wav",
		Sound_MidPitch = 1.2,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_135/sound_001.wav",
		Sound_HighPitch = 1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_136/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.24,0.36,0.48,0.6},

		RadioPos = Vector(77.1, 0, 25),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(3, 30, 35),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(70, 51.5, 32),
				h = 3 / 5,
				ratio = 9 / 24,
			},
			right = {
				pos = Vector(70, -51.5, 32),
				h = 3 / 5,
				ratio = 9 / 24,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_boxville", V )
local V = {
	Name = "Cement Truck",
	Model = "models/octocar/industrial/cement.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,70),
	SpawnAngleOffset = 90,
	Members = {
		Mass = 5500,

		EnginePos = Vector(110,0,10),

		LightsTable = "cement",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/industrial/cement_wheel.mdl",
		CustomWheelPosFL = Vector(104,47,-59),
		CustomWheelPosFR = Vector(104,-47,-59),
		CustomWheelPosML = Vector(-69,47,-57),
		CustomWheelPosMR = Vector(-69,-47,-57),
		CustomWheelPosRL = Vector(-111,47,-57),
		CustomWheelPosRR = Vector(-111,-47,-57),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(-10,0,2),

		CustomSteerAngle = 30,

		SeatOffset = Vector(44,-17,22),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(53,-17,-15),
				ang = Angle(0,-90,8)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(31,-36,50),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(30,-36,50),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(29,-36,50),
				ang = Angle(0,180,0),
			}
		},

		FrontHeight = 2,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 3000,

		RearHeight = 2,
		RearConstant = 45000,
		RearDamping = 3000,
		RearRelativeDamping = 3000,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 72,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 50,

		IdleRPM = 500,
		LimitRPM = 3400,
		PeakTorque = 88,
		PowerbandStart = 650,
		PowerbandEnd = 3200,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(17,-57,-34),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 70,

		PowerBias = 1,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_077/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_077/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_077/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_078/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.07,0.15,0.24,0.34,0.42}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_cement", V )
local V = {
	Name = "Combine Harvester",
	Model = "models/octocar/industrial/combine.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,70),
	SpawnAngleOffset = 90,
	Members = {
		Mass = 8500,

		EnginePos = Vector(50,0,30),

		LightsTable = "combine",

		CustomWheels = true,
		CustomSuspensionTravel = 0,
		StrengthenSuspension = true,

		//CustomWheelModel_R = "models/octocar/industrial/combine_wheel_medium.mdl",
		CustomWheelModel = "models/octocar/industrial/combine_wheel_large.mdl",
		CustomWheelPosFL = Vector(80,67,-60),
		CustomWheelPosFR = Vector(80,-67,-60),
		CustomWheelPosRL = Vector(-60,67,-60),
		CustomWheelPosRR = Vector(-60,-67,-60),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(-10,0,2),

		CustomSteerAngle = 50,

		SeatOffset = Vector(94,-36,66),
		SeatPitch = 12,
		SeatYaw = 90,

		PassengerSeats = {


		},

		ExhaustPositions = {
			{
				pos = Vector(84,-34,80),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(84,-34,80),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(84,-34,80),
				ang = Angle(0,180,0),
			}
		},

		FrontHeight = 2,
		FrontConstant = 50000,
		FrontDamping = 5000,
		FrontRelativeDamping = 5000,

		RearHeight = 2,
		RearConstant = 50000,
		RearDamping = 5000,
		RearRelativeDamping = 5000,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 136,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 50,

		IdleRPM = 500,
		LimitRPM = 3400,
		PeakTorque = 120,
		PowerbandStart = 650,
		PowerbandEnd = 3200,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-58,0,-45),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 95,

		PowerBias = 0,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_062/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_062/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_062/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_063/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.16,0.24,0.34,0.42}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_combine", V )
local V = {
	Name = "DFT-30",
	Model = "models/octocar/industrial/dft30.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,70),
	SpawnAngleOffset = 90,
	Members = {
		Mass = 5500,

		EnginePos = Vector(130,0,-20),

		LightsTable = "dft30",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/industrial/dft30_wheel.mdl",
		CustomWheelPosFL = Vector(107,47,-47),
		CustomWheelPosFR = Vector(107,-47,-47),
		CustomWheelPosML = Vector(-103,47,-45),
		CustomWheelPosMR = Vector(-103,-47,-45),
		CustomWheelPosRL = Vector(-145,47,-45),
		CustomWheelPosRR = Vector(-145,-47,-45),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,6),

		CustomSteerAngle = 30,

		SeatOffset = Vector(117,-17,41),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(126,-18,-11),
				ang = Angle(0,-90,8)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-170,-10,-30),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-170,-10,-30),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 3000,

		RearHeight = 2,
		RearConstant = 45000,
		RearDamping = 3000,
		RearRelativeDamping = 3000,

		FastSteeringAngle = 34,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 96,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 50,

		IdleRPM = 500,
		LimitRPM = 3200,
		PeakTorque = 92,
		PowerbandStart = 650,
		PowerbandEnd = 3000,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(105,45,0),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 70,

		PowerBias = 1,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_026/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_026/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_026/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_027/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.1,0.15,0.24,0.34,0.46}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_dft30", V )
local V = {
	Name = "Dozer",
	Model = "models/octocar/industrial/dozer.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,70),
	SpawnAngleOffset = 90,
	Members = {
		Mass = 10000,

		ModelInfo = {
			Color = Color(59,75,77,255)
		},

		EnginePos = Vector(-110,0,0),

		LightsTable = "dozer",

		CustomWheels = true,
		CustomSuspensionTravel = 1,
		StrengthenSuspension =true,

		CustomWheelModel = "models/octocar/industrial/dozer_wheel.mdl",
		CustomWheelPosFL = Vector(60,45,-32),
		CustomWheelPosFR = Vector(60,-45,-32),
		CustomWheelPosRL = Vector(-62,45,-30),
		CustomWheelPosRR = Vector(-62,-45,-30),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-35,0,58),
		SeatPitch = 14,
		SeatYaw = 90,

		PassengerSeats = {

		},

		ExhaustPositions = {
			{
				pos = Vector(-104,12,77),
				ang = Angle(45,180,0),
			},
			{
				pos = Vector(-104,12,77),
				ang = Angle(45,180,0),
			},
			{
				pos = Vector(-104,12,77),
				ang = Angle(45,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 3000,

		RearHeight = 6,
		RearConstant = 45000,
		RearDamping = 3000,
		RearRelativeDamping = 3000,

		FastSteeringAngle = 34,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 160,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 60,

		IdleRPM = 500,
		LimitRPM = 3000,
		PeakTorque = 140,
		PowerbandStart = 650,
		PowerbandEnd = 2800,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-114,20,20),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 80,

		PowerBias = 0,

		EngineSoundPreset = 0,
		--

		Sound_Idle = "dbg/cars/bank_082/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_082/sound_001.wav",
		Sound_MidPitch = 1.8,
		Sound_MidVolume = 3,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_082/sound_001.wav",
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 3,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_083/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 6,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.07,0.13,0.18,0.24,0.3}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_dozer", V )
local V = {
	Name = "Dumper",
	Model = "models/octocar/industrial/dumper.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,90),
	SpawnAngleOffset = 90,
	Members = {
		Mass = 20000,

		EnginePos = Vector(180,0,-10),

		LightsTable = "dumper",

		CustomWheels = true,
		CustomSuspensionTravel = 1,
		StrengthenSuspension = true,

		CustomWheelModel = "models/octocar/industrial/dumper_wheel.mdl",
		CustomWheelPosFL = Vector(115,83,-66),
		CustomWheelPosFR = Vector(115,-83,-66),
		CustomWheelPosRL = Vector(-72,83,-66),
		CustomWheelPosRR = Vector(-72,-83,-66),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 35,

		SeatOffset = Vector(80,-49,61),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {

		},

		ExhaustPositions = {
			{
				pos = Vector(-90,0,-30),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-90,0,-30),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-90,0,-30),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 50000,
		FrontDamping = 9000,
		FrontRelativeDamping = 9000,

		RearHeight = 5,
		RearConstant = 50000,
		RearDamping = 9000,
		RearRelativeDamping = 9000,

		FastSteeringAngle = 40,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 200,
		Efficiency = 0.85,
		GripOffset = 0.1,
		BrakePower = 80,

		IdleRPM = 500,
		LimitRPM = 3200,
		PeakTorque = 152,
		PowerbandStart = 650,
		PowerbandEnd = 3000,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(25,-65,-30),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 150,

		PowerBias = 0.2,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_077/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_077/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_077/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_078/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.05,0,0.04,0.1,0.18,0.24}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_dumper", V )
local V = {
	Name = "Flatbed",
	Model = "models/octocar/industrial/flatbed.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,50),
	SpawnAngleOffset = 90,
	Members = {
		Mass = 8500,

		EnginePos = Vector(120,0,0),

		LightsTable = "flatbed",

		Plates = {
			Front = {
				pos = Vector(151.25, -12, -13),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-166, 10, -18),
				ang = Angle(0, -90, 90),
			},
		},

		CustomWheels = true,
		CustomSuspensionTravel = 1,
		StrengthenSuspension = true,

		CustomWheelModel = "models/octocar/industrial/flatbed_wheel.mdl",
		CustomWheelPosFL = Vector(106,50,-41),
		CustomWheelPosFR = Vector(106,-50,-41),
		CustomWheelPosML = Vector(-54,50,-39),
		CustomWheelPosMR = Vector(-54,-50,-39),
		CustomWheelPosRL = Vector(-108,50,-39),
		CustomWheelPosRR = Vector(-108,-50,-39),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,6),

		CustomSteerAngle = 45,

		SeatOffset = Vector(30,-18,51),
		SeatPitch = 12,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(41,-18,10),
				ang = Angle(0,-90,8),
				hasRadio = true,
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(24,36,60),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(24,36,60),
				ang = Angle(0,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 3000,

		RearHeight = 2,
		RearConstant = 45000,
		RearDamping = 3000,
		RearRelativeDamping = 3000,

		FastSteeringAngle = 40,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 120,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 60,

		IdleRPM = 500,
		LimitRPM = 3200,
		PeakTorque = 92,
		PowerbandStart = 650,
		PowerbandEnd = 3000,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(0,54,-28),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 80,

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

		DifferentialGear = 0.33333333333333,
		Gears = {-0.1,0,0.09,0.16,0.26,0.38,0.49},

		RadioPos = Vector(66.1, 0, 30),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(0, 35, 32),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(56, 64, 42),
				h = 3 / 5,
				ratio = 9 / 22,
			},
			right = {
				pos = Vector(56, -64, 42),
				h = 3 / 5,
				ratio = 9 / 22,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_flatbed", V )
local V = {
	Name = "Forklift",
	Model = "models/octocar/industrial/forklift.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,50),
	SpawnAngleOffset = 90,
	Members = {
		Mass = 1000,

		EnginePos = Vector(-20,0,0),

		LightsTable = "forklift",

		CustomWheels = true,
		CustomSuspensionTravel = 0,

		CustomWheelModel = "models/octocar/industrial/forklift_wheel.mdl",
		CustomWheelPosFL = Vector(20,20,-16),
		CustomWheelPosFR = Vector(20,-20,-16),
		CustomWheelPosRL = Vector(-26,20,-16),
		CustomWheelPosRR = Vector(-26,-20,-16),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(1,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-24,0,36),
		SeatPitch = 12,
		SeatYaw = 90,

		PassengerSeats = {
		},

		ExhaustPositions = {
		},

		FrontHeight = 6,
		FrontConstant = 35000,
		FrontDamping = 2000,
		FrontRelativeDamping = 2000,

		RearHeight = 6,
		RearConstant = 35000,
		RearDamping = 2000,
		RearRelativeDamping = 2000,

		FastSteeringAngle = 34,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 48,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 45,

		IdleRPM = 500,
		LimitRPM = 3200,
		PeakTorque = 24,
		PowerbandStart = 650,
		PowerbandEnd = 3000,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-35,0,-10),
		FuelType = FUELTYPE_ELECTRIC,
		FuelTankSize = 70,

		PowerBias = -1,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_051/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_051/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_051/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_052/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.1,0,0.1,0.3,0.57}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_forklift", V )
local V = {
	Name = "Linerunner",
	Model = "models/octocar/industrial/linerun.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,50),
	SpawnAngleOffset = 90,
	Members = {
		Mass = 3800,

		EnginePos = Vector(130,0,0),

		LightsTable = "linerun",

		CustomWheels = true,
		CustomSuspensionTravel = 1,
		StrengthenSuspension = true,

		CustomWheelModel = "models/octocar/industrial/linerun_f_wheel.mdl",
		CustomWheelModel_R = "models/octocar/industrial/linerun_r_wheel.mdl",
		CustomWheelPosFL = Vector(129,48,-38),
		CustomWheelPosFR = Vector(129,-48,-38),
		CustomWheelPosML = Vector(-80,48,-38),
		CustomWheelPosMR = Vector(-80,-48,-38),
		CustomWheelPosRL = Vector(-124,48,-38),
		CustomWheelPosRR = Vector(-124,-48,-38),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(43,-16,41),
		SeatPitch = 12,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(56,-16,0),
				ang = Angle(0,-90,8)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(35,40,85),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(35,40,85),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(35,40,85),
				ang = Angle(0,180,0),
			},{
				pos = Vector(35,-40,85),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(35,-40,85),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(35,-40,85),
				ang = Angle(0,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 3000,

		RearHeight = 3,
		RearConstant = 45000,
		RearDamping = 3000,
		RearRelativeDamping = 3000,

		FastSteeringAngle = 40,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 112,
		Efficiency = 0.85,
		GripOffset = 5,
		BrakePower = 60,

		IdleRPM = 400,
		LimitRPM = 3000,
		PeakTorque = 112,
		PowerbandStart = 550,
		PowerbandEnd = 2800,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(2,43,-28),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 130,

		PowerBias = 1,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_077/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_077/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_077/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_078/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.1,0,0.09,0.16,0.26,0.38,0.5},
//For trailers
		OnSpawn = function(ent)
            if ent:SimfIsTrailer() != nil then
                ent:SetActive(true) -- makes avtive
                ent:SetSimfIsTrailer(false)
                ent:SetTrailerCenterposition(Vector(6,6,6))
                ent:SetCenterposition(Vector(-111.026,0,-2.45154))
            else
                print("INSTALL TRAILERS BASE FIRST")
            end
        end
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_linerun", V )
local V = {
	Name = "Mule",
	Model = "models/octocar/industrial/mule.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	Members = {
		Mass = 3500,

		EnginePos = Vector(90,0,10),

		Plates = {
			Front = {
				pos = Vector(105, -10, -15),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-125, 10, -10),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "mule",

		CustomWheels = true,
		CustomSuspensionTravel = 1,
		StrengthenSuspension = true,

		CustomWheelModel = "models/octocar/industrial/mule_wheel.mdl",
		CustomWheelPosFL = Vector(78,35,-28),
		CustomWheelPosFR = Vector(78,-35,-28),
		CustomWheelPosRL = Vector(-77,36,-28),
		CustomWheelPosRR = Vector(-77,-36,-28),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,7),

		CustomSteerAngle = 32,

		SeatOffset = Vector(30,-17,32),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(39,-17,-7),
				ang = Angle(0,-90,8),
				hasRadio = true,
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-114,-17,-26),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 3000,

		RearHeight = 6,
		RearConstant = 50000,
		RearDamping = 3000,
		RearRelativeDamping = 3000,

		FastSteeringAngle = 21,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 88,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 50,

		IdleRPM = 600,
		LimitRPM = 4000,
		PeakTorque = 112,
		PowerbandStart = 700,
		PowerbandEnd = 3800,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-27,27,-24),
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
		Gears = {-0.12,0,0.14,0.24,0.36,0.48,0.6},

		RadioPos = Vector(62.9, 0, 18),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(0, 32, 35.5),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(41, 48, 27),
				h = 3 / 5,
				ratio = 9 / 24,
			},
			right = {
				pos = Vector(41, -48, 27),
				h = 3 / 5,
				ratio = 9 / 24,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_mule", V )
local V = {
	Name = "Packer",
	Model = "models/octocar/industrial/packer.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,50),
	SpawnAngleOffset = 90,
	Members = {
		Mass = 8000,

		EnginePos = Vector(180,0,0),

		LightsTable = "packer",

		CustomWheels = true,
		CustomSuspensionTravel = 1,
		StrengthenSuspension = true,

		CustomWheelModel = "models/octocar/industrial/packer_f_wheel.mdl",
		CustomWheelModel_R = "models/octocar/industrial/packer_r_wheel.mdl",
		CustomWheelPosFL = Vector(175,48,-52),
		CustomWheelPosFR = Vector(175,-48,-52),
		CustomWheelPosML = Vector(-144,48,-48),
		CustomWheelPosMR = Vector(-144,-48,-48),
		CustomWheelPosRL = Vector(-188,48,-48),
		CustomWheelPosRR = Vector(-188,-48,-48),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(95,-15,52),
		SeatPitch = 12,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(108,-16,-2),
				ang = Angle(0,-90,8)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(75,-40,-25),
				ang = Angle(90,235,0),
			},
			{
				pos = Vector(75,-40,-25),
				ang = Angle(90,235,0),
			},
			{
				pos = Vector(75,-40,-25),
				ang = Angle(90,235,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 3000,

		RearHeight = 0,
		RearConstant = 45000,
		RearDamping = 3000,
		RearRelativeDamping = 3000,

		FastSteeringAngle = 43,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 120,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 60,

		IdleRPM = 400,
		LimitRPM = 3000,
		PeakTorque = 112,
		PowerbandStart = 550,
		PowerbandEnd = 2800,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(44,53,-30),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 120,

		PowerBias = 1,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_077/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_077/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_077/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_078/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.1,0,0.09,0.17,0.28,0.4,0.6}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_packer", V )
local V = {
	Name = "Roadtrain",
	Model = "models/octocar/industrial/rdtrain.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,70),
	SpawnAngleOffset = 90,
	Members = {
		Mass = 5000,

		EnginePos = Vector(130,0,0),

		LightsTable = "rdtrain",

		CustomWheels = true,
		CustomSuspensionTravel = 1,
		StrengthenSuspension = true,

		CustomWheelModel = "models/octocar/industrial/rdtrain_f_wheel.mdl",
		CustomWheelModel_R = "models/octocar/industrial/rdtrain_r_wheel.mdl",
		CustomWheelPosFL = Vector(129,57,-64),
		CustomWheelPosFR = Vector(129,-57,-64),
		CustomWheelPosML = Vector(-93,57,-64),
		CustomWheelPosMR = Vector(-93,-57,-64),
		CustomWheelPosRL = Vector(-144,57,-64),
		CustomWheelPosRR = Vector(-144,-57,-64),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(39,-19,33),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(48,-18,-6),
				ang = Angle(0,-90,8)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-34,48,66),
				ang = Angle(45,180,0),
			},
			{
				pos = Vector(-34,48,66),
				ang = Angle(45,180,0),
			},
			{
				pos = Vector(-34,48,66),
				ang = Angle(45,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 50000,
		FrontDamping = 4000,
		FrontRelativeDamping = 4000,

		RearHeight = 0,
		RearConstant = 45000,
		RearDamping = 4000,
		RearRelativeDamping = 4000,

		FastSteeringAngle = 40,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 96,
		Efficiency = 0.85,
		GripOffset = 5,
		BrakePower = 60,

		IdleRPM = 400,
		LimitRPM = 3000,
		PeakTorque = 112,
		PowerbandStart = 550,
		PowerbandEnd = 2800,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(18,58,-46),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 130,

		PowerBias = 1,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_077/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_077/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_077/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_078/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.1,0,0.09,0.16,0.26,0.38,0.5},
//For trailers
		OnSpawn = function(ent)
            if ent:SimfIsTrailer() != nil then
                ent:SetActive(true) -- makes avtive
                ent:SetSimfIsTrailer(false)
                ent:SetTrailerCenterposition(Vector(6,6,6))
                ent:SetCenterposition(Vector(-119.7648,0,-21.468348))
            else
                print("INSTALL TRAILERS BASE FIRST")
            end
        end
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_rdtrain", V )
local V = {
	Name = "Tanker",
	Model = "models/octocar/industrial/petro.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,70),
	SpawnAngleOffset = 90,
	Members = {
		Mass = 3800,

		EnginePos = Vector(130,0,0),

		LightsTable = "petro",

		CustomWheels = true,
		CustomSuspensionTravel = 1,
		StrengthenSuspension = true,

		CustomWheelModel = "models/octocar/industrial/petro_wheel.mdl",
		CustomWheelPosFL = Vector(128,50,-40),
		CustomWheelPosFR = Vector(128,-50,-40),
		CustomWheelPosML = Vector(-116,50,-40),
		CustomWheelPosMR = Vector(-116,-50,-40),
		CustomWheelPosRL = Vector(-160,50,-40),
		CustomWheelPosRR = Vector(-160,-50,-40),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(48,-16,37),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(55,-17,-4),
				ang = Angle(0,-90,8)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(27,43,75),
				ang = Angle(45,180,0),
			},
			{
				pos = Vector(27,43,75),
				ang = Angle(45,180,0),
			},
			{
				pos = Vector(27,43,75),
				ang = Angle(45,180,0),
			},
			{
				pos = Vector(27,-43,75),
				ang = Angle(45,180,0),
			},
			{
				pos = Vector(27,-43,75),
				ang = Angle(45,180,0),
			},
			{
				pos = Vector(27,-43,75),
				ang = Angle(45,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 50000,
		FrontDamping = 4000,
		FrontRelativeDamping = 4000,

		RearHeight = 0,
		RearConstant = 45000,
		RearDamping = 4000,
		RearRelativeDamping = 4000,

		FastSteeringAngle = 40,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 96,
		Efficiency = 0.85,
		GripOffset = 5,
		BrakePower = 60,

		IdleRPM = 400,
		LimitRPM = 3000,
		PeakTorque = 112,
		PowerbandStart = 550,
		PowerbandEnd = 2800,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(14,-50,-24),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 130,

		PowerBias = 1,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_077/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_077/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_077/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_078/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.1,0,0.09,0.16,0.26,0.38,0.5},
//For trailers
		OnSpawn = function(ent)
            if ent:SimfIsTrailer() != nil then
                ent:SetActive(true) -- makes avtive
                ent:SetSimfIsTrailer(false)
                ent:SetTrailerCenterposition(Vector(6,6,6))
                ent:SetCenterposition(Vector(-133.70652,0,-3.660696))
            else
                print("INSTALL TRAILERS BASE FIRST")
            end
        end
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_petro", V )
local V = {
	Name = "Tractor",
	Model = "models/octocar/industrial/tractor.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,70),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2000,

		EnginePos = Vector(30,0,8),

		LightsTable = "tractor",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/industrial/tractor_f_wheel.mdl",
		CustomWheelModel_R = "models/octocar/industrial/tractor_r_wheel.mdl",
		FrontWheelRadius = 11,
		RearWheelRadius = 21,
		CustomWheelPosFL = Vector(51,29,-20),
		CustomWheelPosFR = Vector(51,-29,-20),
		CustomWheelPosRL = Vector(-38,28,-10),
		CustomWheelPosRR = Vector(-38,-28,-10),
		CustomWheelAngleOffset = Angle(0,90,0),


		CustomMassCenter = Vector(10,0,0),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-27,0,24),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {

		},

		ExhaustPositions = {
			{
				pos = Vector(20,17,41),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(20,17,41),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(20,17,41),
				ang = Angle(0,180,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 50000,
		FrontDamping = 4000,
		FrontRelativeDamping = 4000,

		RearHeight = 6,
		RearConstant = 45000,
		RearDamping = 4000,
		RearRelativeDamping = 4000,

		FastSteeringAngle = 40,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 48,
		Efficiency = 0.85,
		GripOffset = 5,
		BrakePower = 20,

		IdleRPM = 300,
		LimitRPM = 2400,
		PeakTorque = 48,
		PowerbandStart = 400,
		PowerbandEnd = 2200,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(14,-10,7),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 50,

		PowerBias = 1,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_082/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_082/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_082/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_083/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.1,0,0.09,0.16,0.26,0.38},
//For trailers
		OnSpawn = function(ent)
            if ent:SimfIsTrailer() != nil then
                ent:SetActive(true) -- makes avtive
                ent:SetSimfIsTrailer(false)
                ent:SetTrailerCenterposition(Vector(6,6,6))
                ent:SetCenterposition(Vector(-87.6885,0,-1.67973))
            else
                print("INSTALL TRAILERS BASE FIRST")
            end
        end
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_tractor", V )
local V = {
	Name = "Yankee",
	Model = "models/octocar/industrial/yankee.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Industrial",
	SpawnOffset = Vector(0,0,40),
	SpawnAngleOffset = 90,
	Members = {
		Mass = 4500,

		EnginePos = Vector(100,0,10),

		Plates = {
			Front = {
				pos = Vector(131, -10, -12),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-165, 10, -14),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "yankee",

		CustomWheels = true,
		CustomSuspensionTravel = 2,
		StrengthenSuspension = true,

		CustomWheelModel = "models/octocar/industrial/yankee_wheel.mdl",
		CustomWheelPosFL = Vector(92,38,-30),
		CustomWheelPosFR = Vector(92,-38,-30),
		CustomWheelPosRL = Vector(-100,44,-30),
		CustomWheelPosRR = Vector(-100,-44,-30),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(5,0,8),

		CustomSteerAngle = 32,

		SeatOffset = Vector(43,-15,34),
		SeatPitch = 6,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(52,-15,-6),
				ang = Angle(0,-90,8),
				hasRadio = true,
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-36,23,-28),
				ang = Angle(90,135,0),
			}
		},

		FrontHeight = 6,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 3000,

		RearHeight = 8,
		RearConstant = 50000,
		RearDamping = 3000,
		RearRelativeDamping = 3000,

		FastSteeringAngle = 23,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 96,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 50,

		IdleRPM = 600,
		LimitRPM = 4000,
		PeakTorque = 120,
		PowerbandStart = 700,
		PowerbandEnd = 3800,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-2,-32,-20),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 69,

		PowerBias = 1,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_135/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_135/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_135/sound_001.wav",
		Sound_HighPitch = 1.1,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_136/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "dbg/cars/bank_068/sound_002.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.13,0.24,0.36,0.48,0.6},

		RadioPos = Vector(76.3, 0, 19.5),
		RadioAng = Angle(-2, 180, 0),

		HUDPos = Vector(0, 36, 33),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(58, 44, 28),
				h = 3 / 5,
				ratio = 9 / 22,
			},
			right = {
				pos = Vector(58, -44, 28),
				h = 3 / 5,
				ratio = 9 / 22,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_yankee", V )
