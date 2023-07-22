local V = {
	Name = 'Stretch',
	Model = 'models/octoteam/vehicles/stretch.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 2500.0,

		EnginePos = Vector(123,0,4),

		LightsTable = 'gta4_stretch',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1) )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(0,0,8)}
				-- CarCols[2] = {REN.GTA4ColorTable(1,1,12)}
				-- CarCols[3] = {REN.GTA4ColorTable(113,113,113)}
				-- CarCols[4] = {REN.GTA4ColorTable(16,16,76)}
				-- CarCols[5] = {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[6] = {REN.GTA4ColorTable(15,15,93)}
				-- CarCols[7] = {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[8] = {REN.GTA4ColorTable(13,13,80)}
				-- CarCols[9] = {REN.GTA4ColorTable(0,0,1)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/stretch_wheel.mdl',

		CustomWheelPosFL = Vector(118,35.35,-16),
		CustomWheelPosFR = Vector(118,-35.35,-16),
		CustomWheelPosRL = Vector(-118,35.35,-16),
		CustomWheelPosRR = Vector(-118,-35.35,-16),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(45,-19.5,17),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(57,-20,-14),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-89,20,-14),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-89,-20,-14),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-170.4,18.7,-13.6),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-170.4,23,-13.6),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 12,
		FrontConstant = 20000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 12,
		RearConstant = 20000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3,

		MaxGrip = 73,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 22,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 140.0,
		PowerbandStart = 2500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-144,-39,10),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 90,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/admiral_idle.wav',

		snd_low = 'octoteam/vehicles/admiral_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/admiral_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/admiral_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/admiral_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/admiral_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/admiral_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.14,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_stretch', V )

local light_table = {
	L_HeadLampPos = Vector(154,26,3),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(154,-26,3),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-167,29,8),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-167,-29,8),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(154,26,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(154,-26,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(76.6,26.2,12.6),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(154,26,3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(154,-26,3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(76.8,26.2,13.7),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-167,29,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-169,16,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-167,-29,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-169,-16,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-171,16,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-169,29,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-171,-16,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-169,-29,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-168.8,22.8,6.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-168.8,-22.8,6.2),
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
				pos = Vector(148.2,35.5,3.2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-164.6,37.4,6.2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(77.4,22,16),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(148.2,-35.5,3.2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-164.6,-37.4,6.2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(77.4,16.3,16),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[3] = '',
				[7] = '',
				[10] = ''
			},
			Brake = {
				[3] = '',
				[7] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[10] = ''
			},
			Reverse = {
				[3] = '',
				[7] = '',
				[10] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
			Brake_Reverse = {
				[3] = '',
				[7] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[10] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
		},
		on_lowbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[7] = '',
				[10] = ''
			},
			Brake = {
				[3] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[7] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[10] = ''
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[7] = '',
				[10] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[7] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[10] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
		},
		on_highbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[7] = '',
				[10] = ''
			},
			Brake = {
				[3] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[7] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[10] = ''
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[7] = '',
				[10] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[7] = 'models/gta4/vehicles/admiral/limo_lights_glass_on',
				[10] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
		},
		turnsignals = {
			left = {
				[9] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
			right = {
				[11] = 'models/gta4/vehicles/admiral/limo_lights_glass_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_stretch', light_table)