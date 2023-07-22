local V = {
	Name = 'Emperor',
	Model = 'models/octoteam/vehicles/emperor.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1600.0,
		Trunk = { 30 },

		EnginePos = Vector(65,0,5),

		LightsTable = 'gta4_emperor',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(1,0,3)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,0,3 )}
				-- CarCols[3] =  {REN.GTA4ColorTable(7,0,7 )}
				-- CarCols[4] =  {REN.GTA4ColorTable(10,0,10)}
				-- CarCols[5] =  {REN.GTA4ColorTable(11,1,11)}
				-- CarCols[6] =  {REN.GTA4ColorTable(16,1,16)}
				-- CarCols[7] =  {REN.GTA4ColorTable(21,2,21)}
				-- CarCols[8] =  {REN.GTA4ColorTable(31,31,31 )}
				-- CarCols[9] =  {REN.GTA4ColorTable(48,38,48 )}
				-- CarCols[10] = {REN.GTA4ColorTable(55,1,55)}
				-- CarCols[11] = {REN.GTA4ColorTable(57,10,57)}
				-- CarCols[12] = {REN.GTA4ColorTable(61,16,61)}
				-- CarCols[13] = {REN.GTA4ColorTable(68,102,68)}
				-- CarCols[14] = {REN.GTA4ColorTable(78,108,79)}
				-- CarCols[15] = {REN.GTA4ColorTable(95,102,95)}
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

		CustomWheelModel = 'models/octoteam/vehicles/emperor_wheel.mdl',

		CustomWheelPosFL = Vector(63,34,-11),
		CustomWheelPosFR = Vector(63,-34,-11),
		CustomWheelPosRL = Vector(-65,34,-11),
		CustomWheelPosRR = Vector(-65,-34,-11),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-10,-17.5,20),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(4,-18,-13),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-36,20,-13),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-36,-20,-13),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-112.7,-28,-11.7),
				ang = Angle(-110,0,0),
			},
		},

		FrontHeight = 6,
		FrontConstant = 29000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 6,
		RearConstant = 29000,
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
		PeakTorque = 41,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-90,39,10),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 45,

		AirFriction = -65,
		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1.1,
		snd_idle = 'octoteam/vehicles/stainer_idle.wav',

		snd_low = 'octoteam/vehicles/stainer_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/stainer_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/stainer_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/stainer_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/stainer_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/emperor_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(22.464, 17.350, 13.474), ang = Angle(0.0, -90.0, 90.0) },
		Radio = { pos = Vector(28.947, 0.007, 8.110), ang = Angle(-0.0, 175.6, 0.0) },
		Plates = {
			Front = { pos = Vector(100.350, -0.003, -8.412), ang = Angle(-0.8, 0.0, 0.0) },
			Back = { pos = Vector(-115.711, -0.008, 4.021), ang = Angle(-1.5, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(6.247, -0.006, 29.563),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(15.777, 41.186, 15.818),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(16.516, -41.216, 15.833),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_emperor', V )

local light_table = {
	L_HeadLampPos = Vector(95,24,4),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(95,-24,4),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-124,35,-2),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-124,-35,-2),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(95,24,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(95,-24,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(95,32,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(95,-32,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
	},

	Headlamp_sprites = {
		{pos = Vector(95,24,4),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(95,-24,4),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(95,32,4),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(95,-32,4),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
	},

	Rearlight_sprites = {
		{
			pos = Vector(-124,35,-2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-124,-35,-2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-123.6,35,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-123.6,-35,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-116,9,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-116,-9,4),
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
				pos = Vector(93,37.2,4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-123,35,8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(23.5,18.4,15.3),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(93,-37.2,4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-123,-35,8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(23.5,17.4,15.3),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[4] = '',
				[9] = '',
				[12] = ''
			},
			Brake = {
				[4] = '',
				[9] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[12] = ''
			},
			Reverse = {
				[4] = '',
				[9] = '',
				[12] = 'models/gta4/vehicles/emperor/emperor_lights_on'
			},
			Brake_Reverse = {
				[4] = '',
				[9] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[12] = 'models/gta4/vehicles/emperor/emperor_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[9] = '',
				[12] = ''
			},
			Brake = {
				[4] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[9] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[12] = ''
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[9] = '',
				[12] = 'models/gta4/vehicles/emperor/emperor_lights_on'
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[9] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[12] = 'models/gta4/vehicles/emperor/emperor_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[9] = '',
				[12] = ''
			},
			Brake = {
				[4] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[9] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[12] = ''
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[9] = '',
				[12] = 'models/gta4/vehicles/emperor/emperor_lights_on'
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[9] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[12] = 'models/gta4/vehicles/emperor/emperor_lights_on'
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/emperor/emperor_lights_on'
			},
			right = {
				[11] = 'models/gta4/vehicles/emperor/emperor_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_emperor', light_table)