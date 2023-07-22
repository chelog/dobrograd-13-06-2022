local V = {
	Name = "Ambulance",
	Model = "models/octocar/government/ambulan.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Government",
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2600,

		EnginePos = Vector(90,0,10),

		LightsTable = "ambulan",

		CustomWheels = true,
		CustomSuspensionTravel = 1,
		StrengthenSuspension = true,

		CustomWheelModel = "models/octocar/government/ambulan_wheel.mdl",
		CustomWheelPosFL = Vector(79.5,34.5,-23.7),
		CustomWheelPosFR = Vector(79.5,-34.5,-23.7),
		CustomWheelPosRL = Vector(-78.1,42,-23.7),
		CustomWheelPosRR = Vector(-78.1,-42,-23.7),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,10),

		CustomSteerAngle = 32,

		SeatOffset = Vector(27,-15,30),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(35,-17,-7),
				ang = Angle(0,-90,8),
				hasRadio = true,
			},
			{
				pos = Vector(-110,-1,-7),
				ang = Angle(0,0,0),
			},
			{
				pos = Vector(-90,30,-4),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(-50,30,-4),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(-4,-2,-7),
				ang = Angle(0,90,0),
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-137.5,-18,-28.4),
				ang = Angle(90,180,0),
			}
		},

		Plates = {
			Front = {
				pos = Vector(112, -10, -14),
				ang = Angle(0, 90, 90),
				bgCol = Color(127,0,0),
				textCol = Color(230,230,230),
			},
			Back = {
				pos = Vector(-132, -5, -12.5),
				ang = Angle(0, -90, 90),
				bgCol = Color(127,0,0),
				textCol = Color(230,230,230),
			},
		},

		FrontHeight = 6,
		FrontConstant = 50000,
		FrontDamping = 6000,
		FrontRelativeDamping = 3000,

		RearHeight = 6,
		RearConstant = 50000,
		RearDamping = 6000,
		RearRelativeDamping = 3000,

		FastSteeringAngle = 21,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 3,

		MaxGrip = 96,
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

		PowerBias = 0.5,

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
		snd_horn = "simulated_vehicles/horn_2.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.14,0.24,0.36,0.48,0.6},

		RadioPos = Vector(55.2, 0, 14),
		RadioAng = Angle(-14, 180, 0),

		HUDPos = Vector(0, 34.4, 34.1),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(51, 52, 19.5),
				h = 2 / 5,
				ratio = 9 / 13,
			},
			right = {
				pos = Vector(51, -52, 19.5),
				h = 2 / 5,
				ratio = 9 / 13,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_ambulan", V )

local V = {
	Name = "Barracks",
	Model = "models/octocar/government/barracks.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Government",
	SpawnOffset = Vector(0,0,50),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 10500,

		ModelInfo = {
			Color = Color(60,74,59,255)
		},

		EnginePos = Vector(120,0,0),

		LightsTable = "barracks",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/government/barracks_wheel.mdl",
		CustomWheelPosFL = Vector(107.6,46.4,-35),
		CustomWheelPosFR = Vector(107.6,-46.4,-35),
		CustomWheelPosML = Vector(-56.1,46.4,-35),
		CustomWheelPosMR = Vector(-56.1,-46.4,-35),
		CustomWheelPosRL = Vector(-107.2,46.4,-35),
		CustomWheelPosRR = Vector(-107.2,-46.4,-35),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,12),

		CustomSteerAngle = 45,

		SeatOffset = Vector(30,-18,51),
		SeatPitch = 12,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(41,-18,10),
				ang = Angle(0,-90,8)
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

		StrengthenSuspension = true,

		FrontHeight = 2,
		FrontConstant = 50000,
		FrontDamping = 2000,
		FrontRelativeDamping = 1000,

		RearHeight = 0,
		RearConstant = 50000,
		RearDamping = 2000,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 40,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 3,

		MaxGrip = 120,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 60,

		IdleRPM = 500,
		LimitRPM = 3200,
		PeakTorque = 120,
		PowerbandStart = 650,
		PowerbandEnd = 3000,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(5.7,54,-24.1),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 90,

		PowerBias = 0.8,

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
		Gears = {-0.1,0,0.1,0.18,0.27,0.39,0.52}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_barracks", V )

local V = {
	Name = "Enforcer",
	Model = "models/octocar/government/enforcer.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Government",
	SpawnOffset = Vector(0,0,50),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 5500,

		EnginePos = Vector(100,0,0),

		Plates = {
			Front = {
				pos = Vector(122.5, -10, -17.5),
				ang = Angle(0, 90, 90),
				bgCol = Color(40,40,100),
				textCol = Color(230,230,230),
			},
			Back = {
				pos = Vector(-129.5, 22.5, 3.75),
				ang = Angle(0, -90, 90),
				bgCol = Color(40,40,100),
				textCol = Color(230,230,230),
			},
		},

		LightsTable = "enforcer",

		CustomWheels = true,
		CustomSuspensionTravel = 0,

		CustomWheelModel = "models/octocar/government/enforcer_wheel.mdl",
		CustomWheelPosFL = Vector(90.7,32.7,-28),
		CustomWheelPosFR = Vector(90.7,-32.7,-28),
		CustomWheelPosRL = Vector(-82,36.3,-28),
		CustomWheelPosRR = Vector(-82,-36.3,-28),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(3,0,15),

		CustomSteerAngle = 45,

		SeatOffset = Vector(30,-14,40),
		SeatPitch = 12,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(41,-15,0),
				ang = Angle(0,-90,8),
				hasRadio = true,
			},
			{
				pos = Vector(-40,-27,0),
				ang = Angle(0,0,8),
				noMirrors = true,
			},
			{
				pos = Vector(-40,27,0),
				ang = Angle(0,180,8),
				noMirrors = true,
			},
			{
				pos = Vector(-70,-27,0),
				ang = Angle(0,0,8),
				noMirrors = true,
			},
			{
				pos = Vector(-70,27,0),
				ang = Angle(0,180,8),
				noMirrors = true,
			},
			{
				pos = Vector(-100,-27,0),
				ang = Angle(0,0,8),
				noMirrors = true,
			},
			{
				pos = Vector(-100,27,0),
				ang = Angle(0,180,8),
				noMirrors = true,
			},
		},

		ExhaustPositions = {
			{
				pos = Vector(-139.3,-21.2,-25.9),
				ang = Angle(90,180,0),
			}
		},

		StrengthenSuspension = true,

		FrontHeight = 0,
		FrontConstant = 50000,
		FrontDamping = 7500,
		FrontRelativeDamping = 3500,

		RearHeight = 0,
		RearConstant = 50000,
		RearDamping = 7500,
		RearRelativeDamping = 3500,

		FastSteeringAngle = 40,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 3,
		BulletProofTires = true,

		MaxGrip = 120,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 60,

		IdleRPM = 500,
		LimitRPM = 5000,
		PeakTorque = 128,
		PowerbandStart = 650,
		PowerbandEnd = 4700,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-114.8,42.8,-5.7),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 90,

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
		snd_horn = "simulated_vehicles/horn_2.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.1,0,0.1,0.18,0.27,0.39,0.52},

		RadioPos = Vector(61.1, 0, 22),
		RadioAng = Angle(-5, 180, 0),

		HUDPos = Vector(0, 32, 32.5),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(48.5, 47.5, 35),
				h = 3 / 5,
				ratio = 9 / 22,
			},
			right = {
				pos = Vector(48.5, -47.5, 35),
				h = 3 / 5,
				ratio = 9 / 22,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_enforcer", V )

local V = {
	Name = "FBI Truck",
	Model = "models/octocar/government/fbitruck.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Government",
	SpawnOffset = Vector(0,0,50),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 4000,

		ModelInfo = {
			Color = Color(47,54,85,255)
		},

		EnginePos = Vector(60,0,0),

		LightsTable = "fbitruck",

		CustomWheels = true,
		CustomSuspensionTravel = 0,

		CustomWheelModel = "models/octocar/government/fbitruck_wheel.mdl",
		CustomWheelPosFL = Vector(62.2,33.8,-27),
		CustomWheelPosFR = Vector(62.2,-33.8,-27),
		CustomWheelPosRL = Vector(-55,33.8,-27),
		CustomWheelPosRR = Vector(-55,-33.8,-27),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(3,0,5),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-13,-17,20),
		SeatPitch = 12,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(1,-17,-12),
				ang = Angle(0,-90,8),
				hasRadio = true,
			},
			{
				pos = Vector(-64,-20,-12),
				ang = Angle(0,90,8),
				noMirrors = true,
			},
			{
				pos = Vector(-64,-7,-12),
				ang = Angle(0,90,8),
				noMirrors = true,
			},
			{
				pos = Vector(-64,7,-12),
				ang = Angle(0,90,8),
				noMirrors = true,
			},
			{
				pos = Vector(-64,20,-12),
				ang = Angle(0,90,8),
				noMirrors = true,
			},
		},

		ExhaustPositions = {
			{
				pos = Vector(-91,22.3,-24.4),
				ang = Angle(90,180,0),
			}
		},

		StrengthenSuspension = true,

		FrontHeight = 0,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 2000,

		RearHeight = 0,
		RearConstant = 50000,
		RearDamping = 3000,
		RearRelativeDamping = 2000,

		FastSteeringAngle = 40,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 3,

		BulletProofTires = true,

		MaxGrip = 120,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 60,

		IdleRPM = 500,
		LimitRPM = 5000,
		PeakTorque = 128,
		PowerbandStart = 650,
		PowerbandEnd = 4700,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-72.7,38.8,3.9),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 90,

		PowerBias = 0.7,

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
		snd_horn = "simulated_vehicles/horn_2.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.1,0,0.1,0.18,0.27,0.39,0.52},

		HUDPos = Vector(0, 38, 35),
		HUDAng = Angle(0, 0, 80),

		Mirrors = {
			left = {
				pos = Vector(77.5, 46.5, 13),
				h = 1 / 3,
				ratio = 1 / 1,
			},
			right = {
				pos = Vector(77.5, -46.5, 13),
				h = 1 / 3,
				ratio = 1 / 1,
			},
		}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_fbitruck", V )

local V = {
	Name = "FBI Rancher",
	Model = "models/octocar/government/fbiranch.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Government",
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 3500,

		EnginePos = Vector(80,0,10),

		LightsTable = "fbiranch",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/government/fbiranch_wheel.mdl",
		CustomWheelPosFL = Vector(82.4,37,-33),
		CustomWheelPosFR = Vector(82.4,-37,-33),
		CustomWheelPosRL = Vector(-69.4,37,-33),
		CustomWheelPosRR = Vector(-69.4,-37,-33),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(6,0,18),

		CustomSteerAngle = 45,

		SeatOffset = Vector(16,-18,23),
		SeatPitch = -2,
		SeatYaw = 90,

		Plates = {
			Front = {
				pos = Vector(121.75, -10, -10.5),
				ang = Angle(0, 90, 90),
				bgCol = Color(0,0,0),
				textCol = Color(230,230,230),
			},
			Back = {
				pos = Vector(-113.75, -15, 3),
				ang = Angle(0, -89, 90),
				bgCol = Color(0,0,0),
				textCol = Color(230,230,230),
			},
		},

		Mirrors = {
			left = {
				pos = Vector(38, 49, 19),
				w = 1.5 / 5,
				ratio = 15 / 9,
			},
			right = {
				pos = Vector(38, -49, 19),
				w = 1.5 / 5,
				ratio = 15 / 9,
			},
		},

		PassengerSeats = {
			{
				pos = Vector(22,-18,-10),
				ang = Angle(0,-90,15),
				hasRadio = true,
			},
			{
				pos = Vector(-18,18,-10),
				ang = Angle(0,-90,15)
			},
			{
				pos = Vector(-18,-18,-10),
				ang = Angle(0,-90,15)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-115.5,-13.6,-22),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-115.5,-17,-22),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 1,
		FrontConstant = 50000,
		FrontDamping = 6300,
		FrontRelativeDamping = 600,

		RearHeight = 0,
		RearConstant = 50000,
		RearDamping = 6300,
		RearRelativeDamping = 600,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 5,

		MaxGrip = 68,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 30,

		IdleRPM = 700,
		LimitRPM = 4800,
		PeakTorque = 96,
		PowerbandStart = 800,
		PowerbandEnd = 4600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-44.6,-43.8,0),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 58,

		PowerBias = 0.1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_092/sound_002.wav",
		Sound_IdlePitch = 0.8,

		Sound_Mid = "dbg/cars/bank_092/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_092/sound_001.wav",
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_093/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "simulated_vehicles/horn_2.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.08,0.17,0.28,0.39,0.5},

		RadioPos = Vector(44.5, 0, 13.2),
		RadioAng = Angle(0, 180, 0)
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_fbiranch", V )

local V = {
	Name = "FD Rancher",
	Model = "models/octocar/government/rancher_fd.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Government",
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2500,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(101, -10, -11),
				ang = Angle(0, 90, 90),
				bgCol = Color(127,0,0),
				textCol = Color(230,230,230),
			},
			Back = {
				pos = Vector(-97.25, -15, 2.5),
				ang = Angle(0, -90, 90),
				bgCol = Color(127,0,0),
				textCol = Color(230,230,230),
			},
		},

		LightsTable = "copcarru",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/government/copcarru_wheel.mdl",
		CustomWheelPosFL = Vector(61,38,-28),
		CustomWheelPosFR = Vector(61,-38,-28),
		CustomWheelPosRL = Vector(-54,38,-28),
		CustomWheelPosRR = Vector(-54,-38,-28),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(5,0,15),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-6,-18,23),
		SeatPitch = -2,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(2,-18,-10),
				ang = Angle(0,-90,15),
				hasRadio = true,
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-100,-14,-22),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-100,-18,-22),
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

		MaxGrip = 66,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 30,

		IdleRPM = 700,
		LimitRPM = 4800,
		PeakTorque = 96,
		PowerbandStart = 800,
		PowerbandEnd = 4600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-26,-40,0),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 58,

		PowerBias = 0.1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_092/sound_002.wav",
		Sound_IdlePitch = 0.8,

		Sound_Mid = "dbg/cars/bank_092/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_092/sound_001.wav",
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_093/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "simulated_vehicles/horn_2.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.08,0.17,0.28,0.4,0.53},

		RadioPos = Vector(23.7, 0, 15),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(3, 32, 31),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(18, 48, 19),
				w = 1 / 5,
				ratio = 5 / 3,
			},
			right = {
				pos = Vector(18, -48, 19),
				w = 1 / 5,
				ratio = 5 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_fdranch", V )

local V = {
	Name = "Fire Truck",
	Model = "models/octocar/government/firetruk.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Government",
	SpawnOffset = Vector(0,0,50),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 6500,

		EnginePos = Vector(140,0,10),

		LightsTable = "firetruk",

		CustomWheels = true,
		CustomSuspensionTravel = 2,

		CustomWheelModel = "models/octocar/government/firetruk_wheel.mdl",
		CustomWheelPosFL = Vector(88.2,37.4,-29),
		CustomWheelPosFR = Vector(88.8,-37.4,-29),
		CustomWheelPosRL = Vector(-73.4,37.4,-29),
		CustomWheelPosRR = Vector(-73.4,-37.4,-29),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(5,0,15),

		CustomSteerAngle = 45,

		SeatOffset = Vector(100,-21.5,47),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(109,-20,-7),
				ang = Angle(0,-90,0),
				hasRadio = true,
			},
			{
				pos = Vector(53,20,-7),
				ang = Angle(0,-90,0),
			},
			{
				pos = Vector(71,10,-7),
				ang = Angle(0,90,0),
			},
			{
				pos = Vector(53,0,-7),
				ang = Angle(0,-90,0),
			},
			{
				pos = Vector(71,-10,-7),
				ang = Angle(0,90,0),
			},
			{
				pos = Vector(53,-20,-7),
				ang = Angle(0,-90,0),
			},
			{
				pos = Vector(-125,-11,-3),
				ang = Angle(0,90,0),
				noMirrors = true,
			},
			{
				pos = Vector(-125,11,-3),
				ang = Angle(0,90,0),
				noMirrors = true,
			},
		},

		ExhaustPositions = {
			{
				pos = Vector(-132,-20,-32.4),
				ang = Angle(90,180,0),
			}
		},

		Plates = {
			Front = {
				pos = Vector(163, -10, -20),
				ang = Angle(0, 90, 90),
				bgCol = Color(127,0,0),
				textCol = Color(230,230,230),
			},
			Back = {
				pos = Vector(-138, 10, -25),
				ang = Angle(0, -90, 90),
				bgCol = Color(127,0,0),
				textCol = Color(230,230,230),
			},
		},

		StrengthenSuspension = true,

		FrontHeight = 2,
		FrontConstant = 60000,
		FrontDamping = 9000,
		FrontRelativeDamping = 4000,

		RearHeight = 2,
		RearConstant = 60000,
		RearDamping = 9000,
		RearRelativeDamping = 4000,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 3,

		MaxGrip = 120,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 50,

		IdleRPM = 600,
		LimitRPM = 5600,
		PeakTorque = 128,
		PowerbandStart = 700,
		PowerbandEnd = 5300,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-127,39.9,-19),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 90,

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
		snd_horn = "simulated_vehicles/horn_2.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.1,0,0.1,0.2,0.32,0.48,0.6},

		RadioPos = Vector(128, 0, 16),
		RadioAng = Angle(-25, 180, 0),

		HUDPos = Vector(0, 33.5, 33.5),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(120, 52, 30),
				h = 3 / 5,
				ratio = 9 / 17,
			},
			right = {
				pos = Vector(120, -52, 30),
				h = 3 / 5,
				ratio = 9 / 17,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_firetruk", V )

local V = {
	Name = "Fire Truck Ladder (old)",
	Model = "models/octocar/government/firela.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Government",
	SpawnOffset = Vector(0,0,50),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 6500,

		EnginePos = Vector(110,0,0),

		LightsTable = "firela",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/government/firela_wheel.mdl",
		CustomWheelPosFL = Vector(88.2,37.4,-29),
		CustomWheelPosFR = Vector(88.8,-37.4,-29),
		CustomWheelPosRL = Vector(-73.4,37.4,-29),
		CustomWheelPosRR = Vector(-73.4,-37.4,-29),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(5,0,15),

		CustomSteerAngle = 45,

		SeatOffset = Vector(80,-20,47),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(91,-20,0),
				ang = Angle(0,-90,8)
			}

		},

		ExhaustPositions = {
			{
				pos = Vector(-132,-20,-32.4),
				ang = Angle(90,180,0),
			}
		},

		Plates = {
			Front = {
				pos = Vector(144.2, -10, -19),
				ang = Angle(0, 90, 90),
				bgCol = Color(127,0,0),
				textCol = Color(230,230,230),
			},
			Back = {
				pos = Vector(-149.72, 10, -23.7),
				ang = Angle(0, -90, 90),
				bgCol = Color(127,0,0),
				textCol = Color(230,230,230),
			},
		},

		StrengthenSuspension = true,

		FrontHeight = 2,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 1000,

		RearHeight = 2,
		RearConstant = 50000,
		RearDamping = 3000,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 28,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 3,

		MaxGrip = 120,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 50,

		IdleRPM = 600,
		LimitRPM = 5600,
		PeakTorque = 128,
		PowerbandStart = 700,
		PowerbandEnd = 5300,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(74.1,42,11.5),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 90,

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
		snd_horn = "dbg/cars/bank_068/sound_012.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.1,0,0.1,0.2,0.32,0.48,0.6}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_firela", V )

local V = {
	Name = "Police Car LS",
	Model = "models/octocar/government/copcarla.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Government",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1600,

		EnginePos = Vector(60,0,10),

		LightsTable = "copcarla",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/government/copcarla_wheel.mdl",
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
				ang = Angle(0,-90,20)
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
		snd_horn = "simulated_vehicles/horn_2.wav",

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.28,0.39,0.5}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_copcarla", V )

local V = {
	Name = "Police Car SF",
	Model = "models/octocar/government/copcarsf.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Government",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1900,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(92.5, -10, -7),
				ang = Angle(0, 90, 90),
				bgCol = Color(40,40,100),
				textCol = Color(230,230,230),
			},
			Back = {
				pos = Vector(-97.75, 10, -1),
				ang = Angle(0, -90, 90),
				bgCol = Color(40,40,100),
				textCol = Color(230,230,230),
			},
		},

		LightsTable = "copcarla",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/government/copcarla_wheel.mdl",
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

		MaxGrip = 66,
		Efficiency = 0.9,
		GripOffset = 2,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 5200,
		PeakTorque = 90,
		PowerbandStart = 900,
		PowerbandEnd = 6500,
		Turbocharged = false,
		Supercharged = true,

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
		snd_horn = "simulated_vehicles/horn_2.wav",

		DifferentialGear = 0.42,
		Gears = {-0.12,0,0.1,0.17,0.28,0.39,0.5},

		RadioPos = Vector(29.9, 0, 7.1),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(17.5, 30.5, 30),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(21, 43.4, 12.5),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			top = {
				pos = Vector(8, 0, 22.5),
				ang = Angle(5, 0, 0),
				w = 1 / 3,
				ratio = 2.5 / 1,
			},
			right = {
				pos = Vector(21, -43.4, 12.5),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_copcarsf", V )

local V = {
	Name = "Police Car LV",
	Model = "models/octocar/government/copcarvg.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Government",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1750,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(93, -10, -6.5),
				ang = Angle(0, 90, 90),
				bgCol = Color(40,40,100),
				textCol = Color(230,230,230),
			},
			Back = {
				pos = Vector(-99, 10, 5),
				ang = Angle(0, -90, 80),
				bgCol = Color(40,40,100),
				textCol = Color(230,230,230),
			},
		},

		LightsTable = "copcarvg",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/government/copcarvg_wheel.mdl",
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
				pos = Vector(-95,-21.2,-13.6),
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

		MaxGrip = 56,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 34,

		IdleRPM = 800,
		LimitRPM = 5800,
		PeakTorque = 64,
		PowerbandStart = 900,
		PowerbandEnd = 6900,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-70.2,38.5,5.7),
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
		snd_horn = "simulated_vehicles/horn_2.wav",

		DifferentialGear = 0.42,
		Gears = {-0.12,0,0.1,0.17,0.28,0.39,0.5},

		RadioPos = Vector(27, 0, 10),
		RadioAng = Angle(-3, 180, 0),

		HUDPos = Vector(17.5, 30.5, 30),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(24, 44, 14),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			top = {
				pos = Vector(14, 0, 24),
				ang = Angle(5, 0, 0),
				w = 1 / 3,
				ratio = 4 / 1,
			},
			right = {
				pos = Vector(24, -44, 14),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_copcarvg", V )

local V = {
	Name = "Ranger",
	Model = "models/octocar/government/copcarru.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Government",
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2500,

		EnginePos = Vector(60,0,10),

		Plates = {
			Front = {
				pos = Vector(100, -10, -11),
				ang = Angle(0, 90, 90),
				bgCol = Color(40,40,100),
				textCol = Color(230,230,230),
			},
			Back = {
				pos = Vector(-97.25, -13, 2.5),
				ang = Angle(0, -90, 90),
				bgCol = Color(40,40,100),
				textCol = Color(230,230,230),
			},
		},

		LightsTable = "copcarru",

		CustomWheels = true,
		CustomSuspensionTravel = 5,

		CustomWheelModel = "models/octocar/government/copcarru_wheel.mdl",
		CustomWheelPosFL = Vector(61,38,-28),
		CustomWheelPosFR = Vector(61,-38,-28),
		CustomWheelPosRL = Vector(-54,38,-28),
		CustomWheelPosRR = Vector(-54,-38,-28),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(5,0,15),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-6,-18,23),
		SeatPitch = -2,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(2,-18,-10),
				ang = Angle(0,-90,15),
				hasRadio = true,
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-100,-14,-22),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-100,-18,-22),
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

		MaxGrip = 66,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 30,

		IdleRPM = 700,
		LimitRPM = 4800,
		PeakTorque = 96,
		PowerbandStart = 800,
		PowerbandEnd = 4600,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-26,-40,0),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 58,

		PowerBias = 0.1,

		EngineSoundPreset = 0,


		Sound_Idle = "dbg/cars/bank_092/sound_002.wav",
		Sound_IdlePitch = 0.8,

		Sound_Mid = "dbg/cars/bank_092/sound_001.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 80,
		Sound_MidFadeOutRate = 0.8,

		Sound_High = "dbg/cars/bank_092/sound_001.wav",
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 1.5,
		Sound_HighFadeInRPMpercent = 80,
		Sound_HighFadeInRate = 0.8,

		Sound_Throttle = "dbg/cars/bank_093/sound_002.wav",
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 4,

		--
		snd_horn = "simulated_vehicles/horn_2.wav",

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.08,0.17,0.28,0.4,0.53},

		RadioPos = Vector(23.7, 0, 15),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(3, 32, 31),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(18, 48, 19),
				w = 1 / 5,
				ratio = 5 / 3,
			},
			right = {
				pos = Vector(18, -48, 19),
				w = 1 / 5,
				ratio = 5 / 3,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_copcarru", V )

local V = {
	Name = "S.W.A.T.",
	Model = "models/octocar/government/swatvan.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Government",
	SpawnOffset = Vector(0,0,50),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 5000,

		ModelInfo = {
			Color = Color(47,54,85,255)
		},

		EnginePos = Vector(-80,0,0),

		LightsTable = "swatvan",

		CustomWheels = true,
		CustomSuspensionTravel = 0,

		CustomWheelModel = "models/octocar/government/swatvan_wheel.mdl",
		CustomWheelPosFL = Vector(60.1,33.1,-10),
		CustomWheelPosFR = Vector(60.1,-33.1,-10),
		CustomWheelPosRL = Vector(-60.1,33.1,-10),
		CustomWheelPosRR = Vector(-60.1,-33.1,-10),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(3,0,15),

		CustomSteerAngle = 45,

		SeatOffset = Vector(23,-14,48),
		SeatPitch = 12,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(1,-17,12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(1,0,12),
				ang = Angle(0,90,8)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-114.4,14.4,49.3),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(-114.4,11,49.3),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(-114.4,17,49.3),
				ang = Angle(0,180,0),
			}
		},

		StrengthenSuspension = true,

		FrontHeight = 0,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 2000,

		RearHeight = 0,
		RearConstant = 50000,
		RearDamping = 3000,
		RearRelativeDamping = 2000,

		FastSteeringAngle = 40,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

		MaxGrip = 120,
		Efficiency = 0.85,
		GripOffset = 2,
		BrakePower = 60,

		IdleRPM = 500,
		LimitRPM = 5000,
		PeakTorque = 80,
		PowerbandStart = 650,
		PowerbandEnd = 4700,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-60.8,45.7,33.1),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 90,

		PowerBias = 0.4,

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
		snd_horn = "simulated_vehicles/horn_2.wav",

		DifferentialGear = 0.26666666666667,
		Gears = {-0.1,0,0.08,0.15,0.26,0.39,0.5}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_swatvan", V )

local V = {
	Name = 'Fire Ladder Truck',
	Model = 'models/left4dead/vehicles/fire_truck.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = "GTA SA Government",
	SpawnOffset = Vector(10,0,120),

	Members = {
		Mass = 4500,

		EnginePos = Vector(217,0,-23.6),
		
		LightsTable = 'l4d_fire_truck',
		
		CustomWheels = true,
		CustomSuspensionTravel = 1.5,
		
		CustomWheelModel = 'models/left4dead/vehicles/wheel_fire_truck.mdl',
		
		CustomWheelPosFL = Vector(138,43,-53),
		CustomWheelPosFR = Vector(138,-43,-53),
		CustomWheelPosML = Vector(-80,43,-47),
		CustomWheelPosMR = Vector(-80,-43,-47),		
		CustomWheelPosRL = Vector(-138,43,-50),
		CustomWheelPosRR = Vector(-138,-43,-50),
		CustomWheelAngleOffset = Angle(0,-90,0),
		
		CustomMassCenter = Vector(0,0,0),		
		
		CustomSteerAngle = 50,
		
		SeatOffset = Vector(160,-32,38),
		SeatPitch = 10,
		SeatYaw = 90,
		
		ExhaustPositions = {
			{
				pos = Vector(21,-48,-57.9),
				ang = Angle(-90,90,0),
			},
			{
				pos = Vector(21,48,-57.9),
				ang = Angle(-90,-90,0),
			},
		},
		
		PassengerSeats = {
			{
				pos = Vector(170,-32,-22),
				ang = Angle(0,-90,0),
				hasRadio = true,
			},
			{
				pos = Vector(90,32,-22),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(90,-32,-22),
				ang = Angle(0,-90,0)
			},
		},
		
		FrontHeight = 16,
		FrontConstant = 50000,
		FrontDamping = 2000,
		FrontRelativeDamping = 5,
		
		RearHeight = 16,
		RearConstant = 50000,
		RearDamping = 2000,
		RearRelativeDamping = 5,
		
		FastSteeringAngle = 25,
		SteeringFadeFastSpeed = 700,
		
		TurnSpeed = 3.5,
		
		MaxGrip = 100,
		Efficiency = 1,
		GripOffset = 0,
		BrakePower = 45,
		BulletProofTires = false,
		
		IdleRPM = 1100,
		LimitRPM = 5000,
		PeakTorque = 30,
		PowerbandStart = 1600,
		PowerbandEnd = 3000,
		Turbocharged = false,
		Supercharged = true,
		DoNotStall = false,
		
		FuelFillPos = Vector(48.4,-37,-24.6),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 170,
		
		PowerBias = 0,
		
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
		snd_horn = 'octoteam/vehicles/fire/warning.wav',

		DifferentialGear = 0.14,
		Gears = {-0.19,0,0.19,0.24,0.29,0.37,0.49,0.6,0.79},

		Dash = { pos = Vector(199.345, 32.5, -2.5), ang = Angle(-0.7, -91.4, 62.3) },
		Radio = { pos = Vector(198.5, 0, -15), ang = Angle(0,180,0) },

		Mirrors = {
			left = {
				pos = Vector(207.7, 61.3, 4.5),
				h = 2 / 4,
				ratio = 3.5 / 5,
			},
			right = {
				pos = Vector(207.7, -61.3, 4.5),
				h = 2 / 4,
				ratio = 3.5 / 5,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_l4d_fire_truck', V)