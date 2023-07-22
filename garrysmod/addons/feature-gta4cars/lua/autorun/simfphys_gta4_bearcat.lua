
local V = {
	Name = "BearCat",
	Model = "models/perrynsvehicles/bearcat_g3/bearcat_g3.mdl",
	Category = "Доброград - Службы",
	SpawnAngleOffset = -90,

	Members = {
		Mass = 4600,

		LightsTable = "bearcat",

		MaxHealth = 5000,
		IsArmored = true,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/perrynsvehicles/bearcat_g3/bearcatwheel.mdl',

		CustomWheelPosFL = Vector(47, 60.9, 24),
		CustomWheelPosFR = Vector(-47, 60.9, 24),
		CustomWheelPosRL = Vector(47, -66, 24),
		CustomWheelPosRR = Vector(-47, -66, 24),

		CustomWheelAngleOffset = Angle(0, 0, 0),

		CustomMassCenter = Vector(0,0,2),
		CustomSteerAngle = 40,

		EnginePos = Vector(0,70,63),

		SeatOffset = Vector(-10,0,-4),
		SeatPitch = 0,

		PassengerSeats = {
			{
				pos = Vector(23,13,35),
				ang = Angle(0,0,14),
				hasRadio = true
			},

			{
				pos = Vector(23,-22,46),
				ang = Angle(0,180,14),
				noMirrors = true
			},
			{
				pos = Vector(-23,-22,46),
				ang = Angle(0,180,14),
				noMirrors = true
			},
			{
				pos = Vector(-26,-55,46),
				ang = Angle(0,-90,14),
				noMirrors = true
			},
			{
				pos = Vector(26,-55,46),
				ang = Angle(0,90,14),
				noMirrors = true,
			},
			{
				pos = Vector(-26,-80,46),
				ang = Angle(0,-90,14),
				noMirrors = true,
			},
			{
				pos = Vector(26,-80,46),
				ang = Angle(0,90,14),
				noMirrors = true
			},
			{
				pos = Vector(-26,-105,46),
				ang = Angle(0,-90,14),
				noMirrors = true
			},
			{
				pos = Vector(26,-105,46),
				ang = Angle(0,90,14),
				noMirrors = true
			},
		},

		ExhaustPositions = {
			{
				pos = Vector(46.942,-113.798,22.144),
				ang = Angle(90,0,0),
			},
			{
				pos = Vector(46.942,-118.55,22.144),
				ang = Angle(90,0,0),
			},
		},

		StrengthenSuspension = true,

		FrontHeight = 13,
		FrontConstant = 100000,
		FrontDamping = 10000,
		FrontRelativeDamping = 10000,

		RearHeight = 13,
		RearConstant = 100000,
		RearDamping = 10000,
		RearRelativeDamping = 10000,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3.5,

		MaxGrip = 90,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 80,
		BulletProofTires = true,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 70,
		PowerbandStart = 1700,
		PowerbandEnd = 5300,
		Turbocharged = false,
		Supercharged = false,
		PowerBoost = 2.5,

		FuelFillPos = Vector(-42.734,-116.155,45.938),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 100,

		PowerBias = 0,

		EngineSoundPreset = -1,
		snd_pitch = 1,
		snd_idle = "vehicles/perryn/bearcat_g3/idle.wav",

		snd_low = "vehicles/perryn/bearcat_g3/first.wav",
		snd_low_revdown = "vehicles/perryn/bearcat_g3/first.wav",
		snd_low_pitch = 1,

		snd_mid = "vehicles/perryn/bearcat_g3/second.wav",
		snd_mid_gearup = "vehicles/perryn/bearcat_g3/second.wav",
		snd_mid_geardown = "vehicles/perryn/bearcat_g3/second.wav",
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/stockade_horn.wav',

		DifferentialGear = 0.3,
		Gears = {-0.1,0,0.1,0.16,0.23,0.32,0.42},

		Dash = { pos = Vector(-23.423, 25.145, 64.612), ang = Angle(0, 0, 67.7) },
		Radio = { pos = Vector(0.120, 29.209, 62.969), ang = Angle(-22.3, -86.5, -1.3) },
		Plates = {
			Back = { pos = Vector(-34.009, -127.657, 41.582), ang = Angle(0, -90, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(-0.117, 25.5, 83),
				ang = Angle(0, 90, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(-60.297, 32.532, 74.323),
				ang = Angle(0, 90, 0),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(61.104, 33.109, 74.527),
				ang = Angle(0, 90, 0),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_bearcat', V)

local light_table = {
	L_HeadLampPos = Vector(-29,92,31.7),
	L_HeadLampAng = Angle(180,-90,0),

	R_HeadLampPos = Vector(29,92,31.7),
	R_HeadLampAng = Angle(180,-90,0),

	L_RearLampPos = Vector(28,-111,31.5),
	L_RearLampAng = Angle(0,-90,0),

	R_RearLampPos = Vector(-28,-111,31.5),
	R_RearLampAng = Angle(0,-90,0),

	Headlight_sprites = {
		{pos =  Vector(-38.369,89.847,53.994),size = 45,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos =  Vector(38.369,89.847,53.994),size = 45,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},

	},
	Headlamp_sprites = {
		{pos =  Vector(-38.369,89.847,53.994),size = 45,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos =  Vector(38.369,89.847,53.994),size = 45,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos =  Vector(-33.699,-122.366,103.461),size = 45,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos =  Vector(33.699,-122.366,103.461),size = 45,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos =  Vector(-33.74,7.665,103.478),size = 45,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos =  Vector(33.74,7.665,103.478),size = 45,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
	},

	FogLight_sprites = {
		{pos = Vector(-35.327,97.56,38.025), size = 40,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(35.327,97.56,38.025), size = 40,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(0,13.847,96.667), size = 10,material="octoteam/sprites/lights/gta4_corona",color=Color(255,200,0)},
		{pos = Vector(-10.826,13.847,96.667), size = 10,material="octoteam/sprites/lights/gta4_corona",color=Color(255,200,0)},
		{pos = Vector(10.826,13.847,96.667), size = 10,material="octoteam/sprites/lights/gta4_corona",color=Color(255,200,0)},
		{pos = Vector(-33.761,13.847,95.893), size = 10,material="octoteam/sprites/lights/gta4_corona",color=Color(255,200,0)},
		{pos = Vector(33.761,13.847,95.893), size = 10,material="octoteam/sprites/lights/gta4_corona",color=Color(255,200,0)},
	},
	Rearlight_sprites = {
		{pos = Vector(-37.999,-126.711,50.993),size = 40,material="octoteam/sprites/lights/gta4_corona"},
		{pos = Vector(37.999,-126.711,50.993),size = 40,material="octoteam/sprites/lights/gta4_corona"},
	},

	Brakelight_sprites = {
		{pos = Vector(-7.684,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(-7.684 + 1*1.024,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(-7.684 + 2*1.024,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(-7.684 + 3*1.024,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(-7.684 + 4*1.024,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(-7.684 + 5*1.024,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(-7.684 + 6*1.024,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(-7.684 + 7*1.024,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(-7.684 + 8*1.024,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(-7.684 + 9*1.024,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(-7.684 + 10*1.024,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(-7.684 + 11*1.024,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(-7.684 + 12*1.024,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(-7.684 + 13*1.024,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(-7.684 + 14*1.024,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(7.684,-126.969,94.392),size = 10,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
	},

	Reverselight_sprites = {
		{pos = Vector(-31.552,-126.664,50.993),size = 40,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},
		{pos = Vector(31.552,-126.664,50.993),size = 40,material="octoteam/sprites/lights/gta4_corona", color=Color(255,255,255)},

	},
	Turnsignal_sprites = {
		Left = {
			{pos = Vector(-38.037,89.151,47.113),size = 25,color=Color(255,120,0),material="octoteam/sprites/lights/gta4_corona"},
			{pos = Vector(-50.799,82.77,49.458),size = 25,color=Color(255,120,0),material="octoteam/sprites/lights/gta4_corona"},
			{pos = Vector(-62.517,36.393,68.662),size = 40,color=Color(255,120,0),material="octoteam/sprites/lights/gta4_corona"},

		},
		TurnBrakeLeft = {
			{pos = Vector(-37.999,-126.711,50.993),size = 40,material="octoteam/sprites/lights/gta4_corona",color = Color(255,80,0,255)},
		},
		Right = {
			{pos = Vector(38.037,89.151,47.113),size = 25,color=Color(255,120,0),material="octoteam/sprites/lights/gta4_corona"},
			{pos = Vector(50.799,82.77,49.458),size = 25,color=Color(255,120,0),material="octoteam/sprites/lights/gta4_corona"},
			{pos = Vector(62.517,36.393,68.662),size = 40,color=Color(255,120,0),material="octoteam/sprites/lights/gta4_corona"},

		},
		TurnBrakeRight = {
			{pos = Vector(37.999,-126.711,50.993),size = 40,material="octoteam/sprites/lights/gta4_corona",color = Color(255,80,0,255)},
		},
	},
	ems_sounds = {'octoteam/vehicles/swat/siren1.wav','octoteam/vehicles/swat/siren2.wav'},
	ems_sprites = {
		-- Roof front
		{
			pos = Vector(-19.17,22.999,94.815),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(255,50,0),Color(0,0,0),Color(255,50,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),},
			Speed = 0.1,
		},
		{
			pos = Vector(-14.593,22.999,94.815),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(255,50,0),Color(0,0,0),Color(255,50,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),},
			Speed = 0.1,
		},
		{
			pos = Vector(19.17,22.999,94.815),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,100,255),Color(0,0,0),Color(0,100,255),Color(0,0,0),},
			Speed = 0.1,
		},
		{
			pos = Vector(14.593,22.999,94.815),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,100,255),Color(0,0,0),Color(0,100,255),Color(0,0,0),},
			Speed = 0.1,
		},


		-- Grille Color(0,100,255)
		{
			pos = Vector(-12.265,98.25,55.855),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,100,255),Color(0,0,0),Color(0,100,255),Color(0,0,0),Color(0,0,0),Color(0,100,255),Color(0,0,0),Color(0,100,255),Color(0,0,0),Color(0,100,255)},
			Speed = 0.1,
		},
		-- Grille Color(255,50,0)
		{
			pos = Vector(12.265,98.25,55.855),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(255,50,0),Color(0,0,0),Color(255,50,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(255,50,0),Color(0,0,0),Color(255,50,0),Color(0,0,0),Color(255,50,0),Color(0,0,0),},
			Speed = 0.1,
		},


		--Back Color(255,50,0)
		{
			pos = Vector(21.255,-131.564,94.949),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(255,50,0),Color(0,0,0),Color(255,50,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(255,50,0),Color(0,0,0),Color(255,50,0),Color(0,0,0),},
			Speed = 0.1,
		},
		--Back Color(0,100,255)
		{
			pos = Vector(-21.255,-131.564,94.949),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,100,255),Color(0,0,0),Color(0,100,255),Color(0,0,0),Color(0,0,0),Color(0,100,255),Color(0,0,0),Color(0,100,255),Color(0,0,0),},
			Speed = 0.1,
		},

		--Side Color(255,50,0)
		{
			pos = Vector(44.298,-123.747,93.241),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(255,50,0),Color(0,0,0),Color(0,0,0)},
			Speed = 0.1,
		},
		--Side Color(0,100,255)
		{
			pos = Vector(-44.298,-123.747,93.241),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(255,50,0),Color(0,0,0),Color(0,0,0)},
			Speed = 0.1,
		},

		--Fog left
		{
			pos = Vector(-35.327,97.56,38.025),
			material = "sprites/light_glow02_add_noz",
			size = 40,
			Colors = {Color(255,255,255),Color(0,0,0),Color(255,255,255),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),},
			Speed = 0.1,
		},
		--Fog right
		{
			pos = Vector(35.327,97.56,38.025),
			material = "sprites/light_glow02_add_noz",
			size = 40,
			Colors = {Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(255,255,255),Color(0,0,0),Color(255,255,255),Color(0,0,0),},
			Speed = 0.1,
		},

		--Reverse left
		{
			pos = Vector(-31.552,-126.664,50.993),
			material = "sprites/light_glow02_add_noz",
			size = 40,
			Colors = {Color(255,255,255),Color(0,0,0),Color(255,255,255),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),},
			Speed = 0.1,
		},
		--Reverse right
		{
			pos = Vector(31.552,-126.664,50.993),
			material = "sprites/light_glow02_add_noz",
			size = 40,
			Colors = {Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(255,255,255),Color(0,0,0),Color(255,255,255),Color(0,0,0),},
			Speed = 0.1,
		},
		{
			pos = Vector(44.298,-110.747,93.241),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(0,0,0),Color(0,100,255),Color(0,0,0),},
			Speed = 0.1,
		},
		{
			pos = Vector(-44.298,-107.747,93.241),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(0,0,0),Color(0,100,255),Color(0,0,0),},
			Speed = 0.1,
		},
		{
			pos = Vector(44.298,-104.747,93.241),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(255,255,255),Color(0,0,0),Color(255,255,255),Color(0,0,0),},
			Speed = 0.2,
		},
		{
			pos = Vector(44.298,-7.747,93.241),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(255,255,255),Color(0,0,0),Color(255,255,255),Color(0,0,0),},
			Speed = 0.2,
		},
		{
			pos = Vector(44.298,-1.547,93.241),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(255,50,0),Color(0,0,0),Color(0,0,0)},
			Speed = 0.2,
		},
		{
			pos = Vector(-44.298,-7.747,93.241),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(255,255,255),Color(0,0,0),Color(255,255,255),Color(0,0,0),},
			Speed = 0.2,
		},
		{
			pos = Vector(-44.298,-1.547,93.241),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(255,50,0),Color(0,0,0),Color(0,0,0)},
			Speed = 0.2,
		},
		{
			pos = Vector(-44.298,-101.747,93.241),
			material = "sprites/light_glow02_add_noz",
			size = 20,
			Colors = {Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(0,0,0),Color(255,255,255),Color(0,0,0),Color(255,255,255),Color(0,0,0),},
			Speed = 0.2,
		},
	}
}
list.Set("simfphys_lights", "bearcat", light_table)