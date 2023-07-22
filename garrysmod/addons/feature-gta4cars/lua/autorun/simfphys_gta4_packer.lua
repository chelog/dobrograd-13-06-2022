local V = {
	Name = 'Packer',
	Model = 'models/octoteam/vehicles/packer.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Индустриальные',
	SpawnOffset = Vector(0,0,40),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Индустриальные',

	Members = {
		Mass = 12000.0,

		EnginePos = Vector(130,0,10),

		LightsTable = 'gta4_packer',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(76,113,113)}
				-- CarCols[2] = {REN.GTA4ColorTable(64,79,79)}
				-- CarCols[3] = {REN.GTA4ColorTable(56,58,59)}
				-- CarCols[4] = {REN.GTA4ColorTable(1,1,2)}
				-- CarCols[5] = {REN.GTA4ColorTable(8,31,8)}
				-- CarCols[6] = {REN.GTA4ColorTable(1,78,8)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			-- REN.GTA4Packer(ent, math.random(0,2))
			REN.GTA4SimfphysInit(ent, 1, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 1, 1, 2) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/packer_wheel.mdl',
		CustomWheelModel_R = 'models/octoteam/vehicles/packer_wheel_r.mdl',

		CustomWheelPosFL = Vector(126,47,-37),
		CustomWheelPosFR = Vector(126,-47,-37),
		CustomWheelPosML = Vector(-68,40,-37),
		CustomWheelPosMR = Vector(-68,-40,-37),
		CustomWheelPosRL = Vector(-123,40,-37),
		CustomWheelPosRR = Vector(-123,-40,-37),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,25),

		CustomSteerAngle = 40,

		SeatOffset = Vector(105,-34,75),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(120,-32,20),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-32,19,-26),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-32,-19,-26),
				ang = Angle(-90,0,0),
			},
		},

		StrengthenedSuspension = true,

		FrontHeight = 22,
		FrontConstant = 50000,
		FrontDamping = 2000,
		FrontRelativeDamping = 350,

		RearHeight = 12,
		RearConstant = 50000,
		RearDamping = 2000,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 700,

		TurnSpeed = 3,

		MaxGrip = 148,
		Efficiency = 0.8,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = false,

		IdleRPM = 700,
		LimitRPM = 4500,
		PeakTorque = 105.0,
		PowerbandStart = 1700,
		PowerbandEnd = 4000,
		Turbocharged = false,
		Supercharged = true,
		DoNotStall = false,

		FuelFillPos = Vector(50,55,-10),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 140,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/firetruk_idle.wav',

		snd_low = 'octoteam/vehicles/firetruk_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/firetruk_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/firetruk_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/firetruk_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/firetruk_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'BUS_HORN',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/DUMP_VALVE.wav',

		DifferentialGear = 0.1,
		Gears = {-0.6,0,0.2,0.35,0.5,0.75,1,1.25,1.5},

		Dash = { pos = Vector(146.133, 33.316, 47.920), ang = Angle(-0.0, -90.0, 61) },
		Radio = { pos = Vector(149.366, 5.902, 48.122), ang = Angle(-25.3, 158.7, 3.2) },
		Plates = {
			Front = { pos = Vector(162.456, 0, -22.916), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-160.683, 0, -14.038), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			left = {
				pos = Vector(135.762, 66.460, 56.646),
				h = 3 / 4,
				ratio = 1 / 2.5,
			},
			right = {
				pos = Vector(135.762, -66.460, 56.646),
				h = 3 / 4,
				ratio = 1 / 2.5,
			},
		},

		CanAttachPackages = true,
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_packer', V )

local light_table = {
	L_HeadLampPos = Vector(159,47,-5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(159,-47,-5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-163,31,-8),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-163,-31,-8),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(159,47,-5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(159,-47,-5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(147,34,48),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(159,39,-5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(159,-39,-5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(147,35,48),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-163,31,-8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-163,-31,-8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-163,38,-8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-163,-38,-8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-163,31,-8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-163,-31,-8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-163,38,-8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-163,-38,-8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-163,15.5,-8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-163,-15.5,-8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(159,43,-11),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-163,44,-8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(148,38,50),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(159,-43,-11),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-163,-44,-8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(148,26,50),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[11] = '',
				[12] = '',
				[9] = ''
			},
			Reverse = {
				[11] = '',
				[12] = '',
				[9] = 'models/gta4/vehicles/packer/detail2_on'
			},
		},
		on_lowbeam = {
			Base = {
				[11] = 'models/gta4/vehicles/packer/detail2_on',
				[12] = '',
				[9] = ''
			},
			Reverse = {
				[11] = 'models/gta4/vehicles/packer/detail2_on',
				[12] = '',
				[9] = 'models/gta4/vehicles/packer/detail2_on'
			},
		},
		on_highbeam = {
			Base = {
				[11] = 'models/gta4/vehicles/packer/detail2_on',
				[12] = 'models/gta4/vehicles/packer/detail2_on',
				[9] = ''
			},
			Reverse = {
				[11] = 'models/gta4/vehicles/packer/detail2_on',
				[12] = 'models/gta4/vehicles/packer/detail2_on',
				[9] = 'models/gta4/vehicles/packer/detail2_on'
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/packer/detail2_on'
			},
			right = {
				[7] = 'models/gta4/vehicles/packer/detail2_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_packer', light_table)
