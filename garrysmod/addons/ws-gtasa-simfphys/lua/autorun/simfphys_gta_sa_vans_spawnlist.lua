local V = {
	Name = "Burrito",
	Model = "models/octocar/vans/burrito_closed.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Vans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1900,

		EnginePos = Vector(90,0,10),

		Plates = {
			Front = {
				pos = Vector(94, -10, -16.5),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-92.25, 23, -7.5),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "burrito",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/vans/burrito_wheel.mdl",
		CustomWheelPosFL = Vector( 64.152, 31.86,-25),
		CustomWheelPosFR = Vector( 64.152,-31.86,-25),
		CustomWheelPosRL = Vector(-64.368, 31.86,-25),
		CustomWheelPosRR = Vector(-64.368,-31.86,-25),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,4),

		CustomSteerAngle = 32,

		SeatOffset = Vector(16,-16,20),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(20,-17,-17),
				ang = Angle(0,-90,8),
				hasRadio = true,
			},
			{
				pos = Vector(-60,18,-15),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(-40,18,-15),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(-20,18,-15),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(-60,-18,-15),
				ang = Angle(0,0,0),
			},
			{
				pos = Vector(-40,-18,-15),
				ang = Angle(0,0,0),
			},
			{
				pos = Vector(-20,-18,-15),
				ang = Angle(0,0,0),
			},

		},

		ExhaustPositions = {
			{
				pos = Vector(-93.59676,-16,-29.7),
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

		MaxGrip = 56,
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

		FuelFillPos = Vector(-82.47564,-36.97488,-0.11),
		FuelType = FUELTYPE_DIESELS,
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

		RadioPos = Vector(46.6, 0, 9),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(0, 30.5, 33),
		HUDAng = Angle(0, 0, 40),

		Mirrors = {
			left = {
				pos = Vector(39, 42.5, 14.5),
				w = 1 / 5,
				ratio = 15 / 9,
			},
			top = {
				pos = Vector(40, 0, 22),
				--ang = Angle(5, 0, 0),
				w = 1 / 2.5,
				ratio = 4.5 / 1,
			},
			right = {
				pos = Vector(39, -42.5, 14.5),
				w = 1 / 5,
				ratio = 15 / 9,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_burrito", V )

local V = {
	Name = "Burrito Coroner",
	Model = "models/octocar/government/burrito_crn.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Vans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1900,

		EnginePos = Vector(90,0,10),

		Plates = {
			Front = {
				pos = Vector(94, -10, -16.5),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-92.25, 23, -7.5),
				ang = Angle(0, -90, 90),
			},
		},

		LightsTable = "burrito_crn",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/vans/burrito_wheel.mdl",
		CustomWheelPosFL = Vector( 64.152, 31.86,-25),
		CustomWheelPosFR = Vector( 64.152,-31.86,-25),
		CustomWheelPosRL = Vector(-64.368, 31.86,-25),
		CustomWheelPosRR = Vector(-64.368,-31.86,-25),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,4),

		CustomSteerAngle = 32,

		SeatOffset = Vector(16,-16,20),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(20,-17,-17),
				ang = Angle(0,-90,8),
				hasRadio = true,
			},
			{
				pos = Vector(-60,18,-15),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(-40,18,-15),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(-20,18,-15),
				ang = Angle(0,180,0),
			},
			{
				pos = Vector(-60,-18,-15),
				ang = Angle(0,0,0),
			},
			{
				pos = Vector(-40,-18,-15),
				ang = Angle(0,0,0),
			},
			{
				pos = Vector(-20,-18,-15),
				ang = Angle(0,0,0),
			},

		},

		ExhaustPositions = {
			{
				pos = Vector(-93.59676,-16,-29.7),
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

		MaxGrip = 56,
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

		FuelFillPos = Vector(-82.47564,-36.97488,-0.11),
		FuelType = FUELTYPE_DIESELS,
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

		RadioPos = Vector(46.6, 0, 9),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(0, 30.5, 33),
		HUDAng = Angle(0, 0, 40),

		Mirrors = {
			left = {
				pos = Vector(39, 42.5, 14.5),
				w = 1 / 5,
				ratio = 15 / 9,
			},
			top = {
				pos = Vector(40, 0, 22),
				--ang = Angle(5, 0, 0),
				w = 1 / 2.5,
				ratio = 4.5 / 1,
			},
			right = {
				pos = Vector(39, -42.5, 14.5),
				w = 1 / 5,
				ratio = 15 / 9,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_burrito_crn", V )

local V = {
	Name = "Hotdog",
	Model = "models/octocar/vans/hotdog.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Vans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 5500,

		EnginePos = Vector(-130,0,-10),

		LightsTable = "hotdog",

		CustomWheels = true,
		CustomSuspensionTravel = 1,
		StrengthenSuspension = true,

		CustomWheelModel = "models/octocar/vans/hotdog_wheel.mdl",
		CustomWheelPosFL = Vector( 76.7390, 46.404,-24),
		CustomWheelPosFR = Vector( 76.7390,-46.404,-24),
		CustomWheelPosRL = Vector(-76.2732, 46.404,-24),
		CustomWheelPosRR = Vector(-76.2732,-46.404,-24),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(-2,0,15),

		CustomSteerAngle = 32,

		SeatOffset = Vector(74,-24,50),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(82,-25,4),
				ang = Angle(0,-90,8),
				hasRadio = true,
			},
			{
				pos = Vector(40,24,22),
				ang = Angle(0,180,0),
				noMirrors = true,
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-144.73836,20.701836,-25.7),
				ang = Angle(90,180,0),
			},
			{
				pos = Vector(-144.73836,20.701836,-25.7),
				ang = Angle(90,180,0),
			}
		},

		FrontHeight = 3,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 3000,

		RearHeight = 3,
		RearConstant = 50000,
		RearDamping = 3000,
		RearRelativeDamping = 3000,

		FastSteeringAngle = 21,
		SteeringFadeFastSpeed = 535,

		TurnSpeed = 2,

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

		FuelFillPos = Vector(-77.66568,49.82112,8.088768),
		FuelType = FUELTYPE_DIESELS,
		FuelTankSize = 60,

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

		DifferentialGear = 0.26666666666667,
		Gears = {-0.12,0,0.11,0.24,0.36,0.48,0.6},

		RadioPos = Vector(105, -10, 24),
		RadioAng = Angle(0,180,0),

		Mirrors = {
			left = {
				pos = Vector(91, 50, 50),
				w = 1 / 6,
				ratio = 2 / 5,
			},
			right = {
				pos = Vector(91, -50, 50),
				w = 1 / 6,
				ratio = 2 / 5,
			},
		},

		Plates = {
			Front = {
				pos = Vector(130.75, -10, -17),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-150.5, 10, -16),
				ang = Angle(0, -90, 90),
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_hotdog", V )

local V = {
	Name = "Moonbeam",
	Model = "models/octocar/vans/moonbeam.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Vans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2000,

		EnginePos = Vector(90,0,10),

		Plates = {
			Front = {
				pos = Vector(96, -10, -20),
				ang = Angle(0, 90, 90),
			},
			Back = {
				pos = Vector(-92.5, -11, -4.5),
				ang = Angle(0, -85, 90),
			},
		},

		LightsTable = "moonbeam",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/vans/moonbeam_wheel.mdl",
		CustomWheelPosFL = Vector( 64.70928, 36.54,-25),
		CustomWheelPosFR = Vector( 64.70928,-36.54,-25),
		CustomWheelPosRL = Vector(-61.31664, 36.54,-25),
		CustomWheelPosRR = Vector(-61.31664,-36.54,-25),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,4),

		CustomSteerAngle = 32,

		SeatOffset = Vector(13,-17,20),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(20,-17,-17),
				ang = Angle(0,-90,8),
				hasRadio = true,
			},
			{
				pos = Vector(-26,18,-15),
				ang = Angle(0,-90,12),
			},
			{
				pos = Vector(-26,-18,-15),
				ang = Angle(0,-90,0),
			},
			{
				pos = Vector(-62,28,-12),
				ang = Angle(0,180,-5),
			},
			{
				pos = Vector(-62,-28,-12),
				ang = Angle(0,0,-5),
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-94.887,-20.478672,-29.7),
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

		MaxGrip = 56,
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

		FuelFillPos = Vector(-63.84096,41.46336,-0.8271),
		FuelType = FUELTYPE_DIESELS,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_088/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_088/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
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

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.14,0.24,0.36,0.48,0.6},

		RadioPos = Vector(44.9, 0, 7),
		RadioAng = Angle(0, 180, 0),

		HUDPos = Vector(0, 31, 31.75),
		HUDAng = Angle(0, 0, 65),

		Mirrors = {
			left = {
				pos = Vector(43, 44.5, 13),
				w = 1 / 5,
				ratio = 3 / 2,
			},
			top = {
				pos = Vector(40, 0, 26),
				ang = Angle(5, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			right = {
				pos = Vector(43, -44.5, 13),
				w = 1 / 5,
				ratio = 3 / 2,
			},
		},
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_moonbeam", V )

local V = {
	Name = "Mr Whoopee",
	Model = "models/octocar/vans/mrwhoop.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Vans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1700,

		EnginePos = Vector(90,0,10),

		LightsTable = "mrwhoop",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/vans/mrwhoop_wheel.mdl",
		CustomWheelPosFL = Vector( 61.54848, 31.968,-23),
		CustomWheelPosFR = Vector( 61.54848,-31.968,-23),
		CustomWheelPosRL = Vector(-46.77264, 31.968,-23),
		CustomWheelPosRR = Vector(-46.77264,-31.968,-23),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,10),

		CustomSteerAngle = 32,

		SeatOffset = Vector(20,-20,32),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(26,-20,-6),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(-13,-5,-8),
				ang = Angle(0,180,-20)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-82.51992,13.469868,-28.22832),
				ang = Angle(90,180,0),
			}
		},

		Plates = {
			Front = {
				pos = Vector(87.5, -10, -20),
				ang = Angle(0, 90, 90),
				bgCol = Color(191,127,255),
				textCol = Color(255,255,255),
			},
			Back = {
				pos = Vector(-80, -16, -7),
				ang = Angle(0, -89, 90),
				bgCol = Color(191,127,255),
				textCol = Color(255,255,255),
			},
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

		MaxGrip = 56,
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

		FuelFillPos = Vector(-68.46984,38.07936,-11.352096),
		FuelType = FUELTYPE_DIESELS,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_088/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_088/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
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

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.14,0.24,0.36,0.48,0.6}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_mrwhoop", V )

local V = {
	Name = "Newsvan",
	Model = "models/octocar/vans/newsvan.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Vans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1900,

		EnginePos = Vector(90,0,10),

		LightsTable = "newsvan",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/vans/newsvan_wheel.mdl",
		CustomWheelPosFL = Vector( 66.99636, 32.256,-23),
		CustomWheelPosFR = Vector( 66.99636,-32.256,-23),
		CustomWheelPosRL = Vector(-74.39112, 32.256,-23),
		CustomWheelPosRR = Vector(-74.39112,-32.256,-23),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,12),

		CustomSteerAngle = 32,

		SeatOffset = Vector(16,-16,26),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(22,-17,-12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(-16,-3,-15),
				ang = Angle(0,0,0)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-121.98672,-15.96402,-26.032032),
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

		MaxGrip = 56,
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

		FuelFillPos = Vector(-82.47564,-36.97488,-0.11),
		FuelType = FUELTYPE_DIESELS,
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
list.Set( "simfphys_vehicles", "simfphys_gta_sa_newsvan", V )

local V = {
	Name = "Pony",
	Model = "models/octocar/vans/pony.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Vans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2600,

		EnginePos = Vector(90,0,10),

		LightsTable = "pony",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/vans/pony_wheel.mdl",
		CustomWheelPosFL = Vector( 64.62216, 31.5,-24),
		CustomWheelPosFR = Vector( 64.62216,-31.5,-24),
		CustomWheelPosRL = Vector(-66.61008, 31.5,-24),
		CustomWheelPosRR = Vector(-66.61008,-31.5,-24),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,12),

		CustomSteerAngle = 32,

		SeatOffset = Vector(20,-18,26),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(28,-16,-12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(-20,21,-11),
				ang = Angle(0,180,0)
			},
			{
				pos = Vector(-50,-21,-11),
				ang = Angle(0,0,0)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-91.03212,-24.380208,-31.067028),
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

		MaxGrip = 72,
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

		FuelFillPos = Vector(12.35916,36.1998,-19.04364),
		FuelType = FUELTYPE_DIESELS,
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
list.Set( "simfphys_vehicles", "simfphys_gta_sa_pony", V )

local V = {
	Name = "Berkley's RC Van",
	Model = "models/octocar/vans/topfun.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Vans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 1900,

		EnginePos = Vector(90,0,10),

		LightsTable = "pony",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/vans/pony_wheel.mdl",
		CustomWheelPosFL = Vector( 64.62216, 31.5,-24),
		CustomWheelPosFR = Vector( 64.62216,-31.5,-24),
		CustomWheelPosRL = Vector(-66.61008, 31.5,-24),
		CustomWheelPosRR = Vector(-66.61008,-31.5,-24),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,12),

		CustomSteerAngle = 32,

		SeatOffset = Vector(20,-18,26),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(28,-16,-12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(-20,21,-11),
				ang = Angle(0,180,0)
			},
			{
				pos = Vector(-50,-21,-11),
				ang = Angle(0,0,0)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-91.03212,-24.380208,-31.067028),
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

		MaxGrip = 72,
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

		FuelFillPos = Vector(12.35916,36.1998,-19.04364),
		FuelType = FUELTYPE_DIESELS,
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
list.Set( "simfphys_vehicles", "simfphys_gta_sa_topfun", V )

local V = {
	Name = "Rumpo",
	Model = "models/octocar/vans/rumpo.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Vans",
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2000,

		EnginePos = Vector(90,0,10),

		LightsTable = "rumpo",

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/vans/rumpo_wheel.mdl",
		CustomWheelPosFL = Vector( 64.24308, 31.5,-28),
		CustomWheelPosFR = Vector( 64.24308,-31.5,-28),
		CustomWheelPosRL = Vector(-66.72276, 31.5,-28),
		CustomWheelPosRR = Vector(-66.72276,-31.5,-28),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(4,0,10),

		CustomSteerAngle = 32,

		SeatOffset = Vector(20,-17,23),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(28,-20,-12),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(-13,27,-15),
				ang = Angle(0,180,0)
			},
			{
				pos = Vector(-40,-27,-15),
				ang = Angle(0,0,0)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-94.55112,-14.890248,-34.333632),
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

		MaxGrip = 60,
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

		FuelFillPos = Vector(-16.691796,37.67544,-15.035616),
		FuelType = FUELTYPE_DIESELS,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = 0,

		Sound_Idle = "dbg/cars/bank_088/sound_002.wav",
		Sound_IdlePitch = 1,

		Sound_Mid = "dbg/cars/bank_088/sound_001.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 2,
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

		DifferentialGear = 0.33333333333333,
		Gears = {-0.12,0,0.14,0.24,0.36,0.48,0.6}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_rumpo", V )

local V = {
	Name = "Securicar",
	Model = "models/octocar/vans/securica.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA SA Vans",
	SpawnOffset = Vector(0,0,40),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 7000,

		EnginePos = Vector(90,0,10),

		LightsTable = "securica",

		CustomWheels = true,
		CustomSuspensionTravel = 1,
		StrengthenSuspension = true,

		CustomWheelModel = "models/octocar/vans/securica_wheel.mdl",
		CustomWheelPosFL = Vector( 70.137, 32.77008,-28),
		CustomWheelPosFR = Vector( 70.137,-32.77008,-28),
		CustomWheelPosRL = Vector(-62.8272, 36.97704,-28),
		CustomWheelPosRR = Vector(-62.8272,-36.97704,-28),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(8,0,12),

		CustomSteerAngle = 32,

		SeatOffset = Vector(18,-22,27),
		SeatPitch = 8,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(28,-20,-9),
				ang = Angle(0,-90,8)
			},
			{
				pos = Vector(-20,0,-11),
				ang = Angle(0,90,0)
			}
		},

		ExhaustPositions = {
			{
				pos = Vector(-106.90452,-21.465576,-30.971916),
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

		MaxGrip = 112,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 50,

		IdleRPM = 600,
		LimitRPM = 4000,
		PeakTorque = 128,
		PowerbandStart = 700,
		PowerbandEnd = 3800,
		Turbocharged = false,
		Supercharged = false,

		FuelFillPos = Vector(-106.2216,36.3816,-17.591292),
		FuelType = FUELTYPE_DIESELS,
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
		Gears = {-0.12,0,0.11,0.24,0.36,0.48,0.6}
	}
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_securica", V )
