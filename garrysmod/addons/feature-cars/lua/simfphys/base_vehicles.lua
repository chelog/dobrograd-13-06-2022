local V = {
	Name = "HL2 Jeep",
	Model = "models/buggy.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Half Life 2 / Synergy",
	
	Members = {
		Mass = 1700,
		
		--OnTick = function(ent) print("hi") end,
		--OnSpawn = function(ent) print("i spawned") end,
		--OnDelete = function(ent) print("im removed :(") end,
		--OnDestroyed = function(ent) print("im destroyed :((((") end,
		
		LightsTable = "jeep",
		
		FrontWheelRadius = 18,
		RearWheelRadius = 20,
		
		CustomMassCenter = Vector(0,0,0),
		
		SeatOffset = Vector(0,0,-2),
		SeatPitch = 0,
		
		SpeedoMax = 120,

		StrengthenSuspension = false,
		
		FrontHeight = 13.5,
		FrontConstant = 27000,
		FrontDamping = 2800,
		FrontRelativeDamping = 2800,
		
		RearHeight = 13.5,
		RearConstant = 32000,
		RearDamping = 2900,
		RearRelativeDamping = 2900,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 44,
		Efficiency = 1.337,
		GripOffset = 0,
		BrakePower = 40,
		
		IdleRPM = 750,
		LimitRPM = 6500,

		PeakTorque = 100,
		PowerbandStart = 2200,
		PowerbandEnd = 6300,
		
		FuelFillPos = Vector(17.64,-14.55,30.06),
		
		PowerBias = 0.5,
		
		EngineSoundPreset = -1,
		
		snd_pitch = 1,
		snd_idle = "simulated_vehicles/jeep/jeep_idle.wav",
		
		snd_low = "simulated_vehicles/jeep/jeep_low.wav",
		snd_low_revdown = "simulated_vehicles/jeep/jeep_revdown.wav",
		snd_low_pitch = 0.9,
		
		snd_mid = "simulated_vehicles/jeep/jeep_mid.wav",
		snd_mid_gearup = "simulated_vehicles/jeep/jeep_second.wav",

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
		
		snd_horn = "simulated_vehicles/horn_1.wav", 
		
		DifferentialGear = 0.3,
		Gears = {-0.15,0,0.15,0.25,0.35,0.45}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_jeep", V )


local V = {
	Name = "HL2 Combine APC",
	Model = "models/combine_apc.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Half Life 2 / Synergy",

	Members = {
		Mass = 3500,
		MaxHealth = 3000,
		
		FrontWheelRadius = 28,
		RearWheelRadius = 28,
		
		SeatOffset = Vector(-25,0,104),
		SeatPitch = 0,
		
		PassengerSeats = {
		},
		
		FrontHeight = 10,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 3000,
		
		RearHeight = 10,
		RearConstant = 50000,
		RearDamping = 3000,
		RearRelativeDamping = 3000,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 70,
		Efficiency = 1.8,
		GripOffset = 0,
		BrakePower = 70,
		BulletProofTires = true,
		
		IdleRPM = 750,
		LimitRPM = 6000,
		PeakTorque = 100,
		PowerbandStart = 1500,
		PowerbandEnd = 5800,
		Turbocharged = false,
		Supercharged = false,
		
		FuelFillPos = Vector(32.82,-78.31,81.89),
		
		PowerBias = 0,
		
		EngineSoundPreset = 0,
		
		Sound_Idle = "simulated_vehicles/c_apc/apc_idle.wav",
		Sound_IdlePitch = 1,
		
		Sound_Mid = "simulated_vehicles/c_apc/apc_mid.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 100,
		Sound_MidFadeOutRate = 1,
		
		Sound_High = "",
		
		Sound_Throttle = "",
		
		snd_horn = "ambient/alarms/apc_alarm_pass1.wav",
		
		DifferentialGear = 0.3,
		Gears = {-0.1,0,0.1,0.2,0.3}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_combineapc", V )


local V = {
	Name = "HL2:EP2 Jalopy",
	Model = "models/vehicle.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Half Life 2 / Synergy",

	Members = {
		Mass = 1700,
		LightsTable = "jalopy",
		
		FrontWheelRadius = 18,
		RearWheelRadius = 20,
		
		SeatOffset = Vector(-1,0,5),
		SeatPitch = 3,
		
		PassengerSeats = {
			{
				pos = Vector(21,-22,21),
				ang = Angle(0,0,9)
			}
		},
		
		ExhaustPositions = {
			{
				pos = Vector(-21.63,-142.52,37.55),
				ang = Angle(90,-90,0)
			},
			{
				pos = Vector(19.65,-144.09,38.03),
				ang = Angle(90,-90,0)
			}
		},
		
		FrontHeight = 11.5,
		FrontConstant = 27000,
		FrontDamping = 2800,
		FrontRelativeDamping = 2800,
		
		RearHeight = 8.5,
		RearConstant = 32000,
		RearDamping = 2900,
		RearRelativeDamping = 2900,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 45,
		Efficiency = 1.22,
		GripOffset = -0.5,
		BrakePower = 50,
		
		IdleRPM = 750,
		LimitRPM = 6000,
		PeakTorque = 130,
		PowerbandStart = 2200,
		PowerbandEnd = 5800,
		Turbocharged = false,
		Supercharged = false,
		
		FuelFillPos = Vector(-39.07,-108.1,60.81),
		FuelTankSize = 80,
		
		PowerBias = 1,
		
		EngineSoundPreset = -1,
		
		snd_pitch = 0.9,
		snd_idle = "simulated_vehicles/jalopy/jalopy_idle.wav",
		
		snd_low = "simulated_vehicles/jalopy/jalopy_low.wav",
		snd_low_revdown = "simulated_vehicles/jalopy/jalopy_revdown.wav",
		snd_low_pitch = 0.95,
		
		snd_mid = "simulated_vehicles/jalopy/jalopy_mid.wav",
		snd_mid_gearup = "simulated_vehicles/jalopy/jalopy_second.wav",
		snd_mid_pitch = 1.1,
		
		Sound_Idle = "simulated_vehicles/jalopy/jalopy_idle.wav",
		Sound_IdlePitch = 0.95,
		
		Sound_Mid = "simulated_vehicles/jalopy/jalopy_mid.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 55,
		Sound_MidFadeOutRate = 0.25,
		
		Sound_High = "simulated_vehicles/jalopy/jalopy_high.wav",
		Sound_HighPitch = 0.75,
		Sound_HighVolume = 0.9,
		Sound_HighFadeInRPMpercent = 55,
		Sound_HighFadeInRate = 0.4,
		
		Sound_Throttle = "",
		Sound_ThrottlePitch = 0,
		Sound_ThrottleVolume = 0,
		
		DifferentialGear = 0.3,
		Gears = {-0.15,0,0.15,0.25,0.35,0.45}
	}
}
if (file.Exists( "models/vehicle.mdl", "GAME" )) then
	list.Set( "simfphys_vehicles", "sim_fphys_jalopy", V )
end


local V = {
	Name = "Driveable Couch",
	Model = "models/props_c17/FurnitureCouch002a.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Base",
	SpawnAngleOffset = 90,

	Members = {
		Mass = 500,

		CustomWheels = true,
		CustomSuspensionTravel = 10,

		CustomWheelModel = "models/props_phx/wheels/magnetic_small_base.mdl",
		
		CustomWheelPosFL = Vector(12,22,-15),
		CustomWheelPosFR = Vector(12,-22,-15),
		CustomWheelPosRL = Vector(-12,22,-15),
		CustomWheelPosRR = Vector(-12,-22,-15),
		CustomWheelAngleOffset = Angle(90,0,0),
		
		CustomMassCenter = Vector(0,0,0),
		
		CustomSteerAngle = 35,
		
		SeatOffset = Vector(-3,-13.5,21),
		SeatPitch = 15,
		SeatYaw = 90,
		
		PassengerSeats = {
			{
				pos = Vector(0,-14,-12),
				ang = Angle(0,-90,0)
			}
		},
		
		FrontHeight = 7,
		FrontConstant = 12000,
		FrontDamping = 400,
		FrontRelativeDamping = 50,
		
		RearHeight = 7,
		RearConstant = 12000,
		RearDamping = 400,
		RearRelativeDamping = 50,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 120,
		
		TurnSpeed = 8,
		
		MaxGrip = 20,
		Efficiency = 1,
		GripOffset = 0,
		BrakePower = 5,
		BulletProofTires = true,
		
		IdleRPM = 600,
		LimitRPM = 10000,
		PeakTorque = 40,
		PowerbandStart = 650,
		PowerbandEnd = 700,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = true,
		
		FuelType = FUELTYPE_ELECTRIC,
		FuelTankSize = 80,
		
		PowerBias = 0,
		
		EngineSoundPreset = 0,
		
		Sound_Idle = "",
		Sound_IdlePitch = 0,
		
		Sound_Mid = "vehicles/apc/apc_idle1.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 100,
		Sound_MidFadeOutRate = 1,
		
		Sound_High = "",
		
		Sound_Throttle = "",
		
		snd_horn = "simulated_vehicles/horn_0.wav",
		
		DifferentialGear = 0.7,
		Gears = {-0.1,0,0.1}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_couch", V )


local V = {
	Name = "HL2 APC",
	Model = "models/props_vehicles/apc001.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Half Life 2 / Synergy",
	SpawnOffset = Vector(0,0,50),

	Members = {
		Mass = 4800,
		MaxHealth = 2800,
		
		EnginePos = Vector(-16.1,-81.68,47.25),
		
		LightsTable = "conapc",
		
		CustomWheels = true,
		CustomSuspensionTravel = 10,
		
		CustomWheelModel = "models/props_vehicles/apc_tire001.mdl",
		CustomWheelPosFL = Vector(-45,77,-22),
		CustomWheelPosFR = Vector(45,77,-22),
		CustomWheelPosRL = Vector(-45,-74,-22),
		CustomWheelPosRR = Vector(45,-74,-22),
		CustomWheelAngleOffset = Angle(0,180,0),
		
		CustomMassCenter = Vector(0,0,0),
		
		CustomSteerAngle = 35,
		
		SeatOffset = Vector(65,-13,50),
		SeatPitch = 15,
		SeatYaw = 0,
		
		PassengerSeats = {
			{
				pos = Vector(13,75,-2),
				ang = Angle(0,0,0)
			},
		},
		
		Attachments = {
			{
				model = "models/hunter/plates/plate075x105.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				pos = Vector(0.04,57.5,16.74),
				ang = Angle(90,-90,0)
			},
			{
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				pos = Vector(-25.08,91.34,29.46),
				ang = Angle(4.2,-109.19,68.43)
			},
			{
				pos = Vector(-24.63,77.76,8.65),
				ang = Angle(24.05,-12.81,-1.87),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255)
			},
			{
				pos = Vector(24.63,77.76,8.65),
				ang = Angle(24.05,-167.19,1.87),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255)
			},
			{
				pos = Vector(-30.17,61.36,32.79),
				ang = Angle(-1.21,-92.38,-130.2),
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255)
			},
			{
				pos = Vector(30.17,61.36,32.79),
				ang = Angle(-1.21,-87.62,130.2),
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255)
			},
			{
				pos = Vector(0,72.92,40.54),
				ang = Angle(0,-180,0.79),
				model = "models/hunter/plates/plate1x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255)
			},
			{
				pos = Vector(25.08,91.34,29.46),
				ang = Angle(4.2,-70.81,-68.43),
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255)
			},
			{
				pos = Vector(-29.63,79.02,19.28),
				ang = Angle(90,-18,0),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255)
			},
			{
				pos = Vector(29.63,79.02,19.28),
				ang = Angle(90,-162,0),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255)
			},
			{
				pos = Vector(0,75.33,5.91),
				ang = Angle(0,0,0),
				model = "models/hunter/plates/plate1x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255)
			},
			{
				pos = Vector(0,98.02,35.74),
				ang = Angle(63,90,0),
				model = "models/hunter/plates/plate025x025.mdl",
				material = "lights/white",
				color = Color(0,0,0,255)
			},
			{
				pos = Vector(0,100.55,7.41),
				ang = Angle(90,-90,0),
				model = "models/hunter/plates/plate1x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255)
			}
		},
		
		FrontHeight = 20,
		FrontConstant = 50000,
		FrontDamping = 4000,
		FrontRelativeDamping = 3000,
		
		RearHeight = 20,
		RearConstant = 50000,
		RearDamping = 4000,
		RearRelativeDamping = 3000,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 140,
		Efficiency = 1.25,
		GripOffset = -14,
		BrakePower = 120,
		BulletProofTires = true,
		
		IdleRPM = 750,
		LimitRPM = 5500,
		PeakTorque = 180,
		PowerbandStart = 1000,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		
		FuelFillPos = Vector(-61.39,49.54,15.79),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 120,
		
		PowerBias = 0,
		
		EngineSoundPreset = 0,
		
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
		
		snd_horn = "simulated_vehicles/horn_2.wav",
		
		DifferentialGear = 0.27,
		Gears = {-0.09,0,0.09,0.18,0.28,0.35}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_conscriptapc", V )