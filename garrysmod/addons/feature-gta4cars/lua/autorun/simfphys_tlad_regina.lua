local V = {
	Name = 'Regina',
	Model = 'models/octoteam/vehicles/regina.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,0),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1500,
		Trunk = { 80 },

		EnginePos = Vector(60,0,10),

		LightsTable = 'gta4_regina',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,0)}
				-- CarCols[2] =  {REN.GTA4ColorTable(28,1,0)}
				-- CarCols[3] =  {REN.GTA4ColorTable(44,1,0)}
				-- CarCols[4] =  {REN.GTA4ColorTable(51,1,0)}
				-- CarCols[5] =  {REN.GTA4ColorTable(57,1,0)}
				-- CarCols[6] =  {REN.GTA4ColorTable(67,1,0)}
				-- CarCols[7] =  {REN.GTA4ColorTable(128,1,0)}
				-- CarCols[8] =  {REN.GTA4ColorTable(131,1,0)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
			-- REN.GTA4BeaterInit(ent)
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
			-- REN.GTA4Beater(ent)
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/regina_wheel.mdl',

		CustomWheelPosFL = Vector(64,36,-2),
		CustomWheelPosFR = Vector(64,-36,-2),
		CustomWheelPosRL = Vector(-64,36,-2),
		CustomWheelPosRR = Vector(-64,-36,-2),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-10,-21,25),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(3,-20,-7),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-40,20,-7),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-40,-20,-7),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-118,29,-3.5),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-118,-29,-3.5),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 8,
		FrontConstant = 28000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 8,
		RearConstant = 28000,
		RearDamping = 800,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3.5,

		MaxGrip = 45,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 25,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 39,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-80,-40,20),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 60,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/rancher_idle.wav',

		snd_low = 'octoteam/vehicles/rancher_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/rancher_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/rancher_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/rancher_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/rancher_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/rancher_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(16.855, 20.243, 19.761), ang = Angle(-0.0, -90.0, 68.5) },
		Radio = { pos = Vector(22.396, -0.005, 11.531), ang = Angle(0.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(102.422, -0.004, -0.803), ang = Angle(20.6, -0.0, -0.0) },
			Back = { pos = Vector(-122.795, -0.011, 1.970), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(5.165, -0.033, 35.563),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(10.784, 43.757, 23.194),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(12.086, -43.591, 23.623),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tlad_regina', V )

local light_table = {
	L_HeadLampPos = Vector(96,34,12),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(96,-34,12),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-119,36,12),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-119,-36,12),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(96,34,12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(96,-34,12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(96,27.5,12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(96,-27.5,12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
	},

	Headlamp_sprites = {
		{pos = Vector(96,34,12),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(96,-34,12),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(96,27.5,12),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(96,-27.5,12),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
	},

	Rearlight_sprites = {
		{
			pos = Vector(-119,36,12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-119,-36,12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-102,21,15.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-102,-21,15.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(99,36,2.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
		},
		TurnBrakeLeft = {
			{
				pos = Vector(-119,36,12),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
		Right = {
			{
				pos = Vector(99,-36,2.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
		},
		TurnBrakeRight = {
			{
				pos = Vector(-119,-36,12),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[13] = '',
				[12] = '',
				[10] = '',
			},
			Brake = {
				[13] = '',
				[12] = 'models/gta4/vehicles/regina/regina_lights_on',
				[10] = '',
			},
			Reverse = {
				[13] = '',
				[12] = '',
				[10] = 'models/gta4/vehicles/regina/regina_lights_on',
			},
			Brake_Reverse = {
				[13] = '',
				[12] = 'models/gta4/vehicles/regina/regina_lights_on',
				[10] = 'models/gta4/vehicles/regina/regina_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[13] = 'models/gta4/vehicles/regina/regina_lights_on',
				[12] = 'models/gta4/vehicles/regina/regina_lights_on',
				[10] = '',
			},
			Brake = {
				[13] = 'models/gta4/vehicles/regina/regina_lights_on',
				[12] = 'models/gta4/vehicles/regina/regina_lights_on',
				[10] = '',
			},
			Reverse = {
				[13] = 'models/gta4/vehicles/regina/regina_lights_on',
				[12] = 'models/gta4/vehicles/regina/regina_lights_on',
				[10] = 'models/gta4/vehicles/regina/regina_lights_on',
			},
			Brake_Reverse = {
				[13] = 'models/gta4/vehicles/regina/regina_lights_on',
				[12] = 'models/gta4/vehicles/regina/regina_lights_on',
				[10] = 'models/gta4/vehicles/regina/regina_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[13] = 'models/gta4/vehicles/regina/regina_lights_on',
				[12] = 'models/gta4/vehicles/regina/regina_lights_on',
				[10] = '',
			},
			Brake = {
				[13] = 'models/gta4/vehicles/regina/regina_lights_on',
				[12] = 'models/gta4/vehicles/regina/regina_lights_on',
				[10] = '',
			},
			Reverse = {
				[13] = 'models/gta4/vehicles/regina/regina_lights_on',
				[12] = 'models/gta4/vehicles/regina/regina_lights_on',
				[10] = 'models/gta4/vehicles/regina/regina_lights_on',
			},
			Brake_Reverse = {
				[13] = 'models/gta4/vehicles/regina/regina_lights_on',
				[12] = 'models/gta4/vehicles/regina/regina_lights_on',
				[10] = 'models/gta4/vehicles/regina/regina_lights_on',
			},
		},
		turnsignals = {
			left = {
				[14] = 'models/gta4/vehicles/regina/regina_lights_on'
			},
			right = {
				[11] = 'models/gta4/vehicles/regina/regina_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_regina', light_table)