local V = {
	Name = 'Emperor (Beater)',
	Model = 'models/octoteam/vehicles/emperor2.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 2100.0,

		EnginePos = Vector(65,0,5),

		LightsTable = 'gta4_emperor2',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,1))
			-- ent:SetBodyGroups('0'..math.random(0,2)	 )

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
			REN.GTA4BeaterInit(ent)
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
			REN.GTA4Beater(ent)
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/emperor2_wheel.mdl',

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
				OnBodyGroups = {
					[1] = {0},
				}
			},
			{
				pos = Vector(-117,-26.5,-16),
				ang = Angle(-110,20,0),
				OnBodyGroups = {
					[1] = {1},
				}
			},
			{
				pos = Vector(-116.7,18.7,-14.2),
				ang = Angle(-110,-5,0),
				OnBodyGroups = {
					[1] = {2},
				}
			},
			{
				pos = Vector(-116.7,22.3,-14.2),
				ang = Angle(-110,-5,0),
				OnBodyGroups = {
					[1] = {2},
				}
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

		MaxGrip = 63,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 15,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 4000,
		PeakTorque = 130.0,
		PowerbandStart = 1700,
		PowerbandEnd = 3500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-90,39,10),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 100,

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

		snd_horn = 'octoteam/vehicles/horns/emperor2_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.14,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_emperor2', V )

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
			pos = Vector(95,-32,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
	},

	Headlamp_sprites = {
		{pos = Vector(95,24,4),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(95,-24,4),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
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
				[13] = '',
				[5] = '',
				[12] = ''
			},
			Brake = {
				[13] = '',
				[5] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[12] = ''
			},
			Reverse = {
				[13] = '',
				[5] = '',
				[12] = 'models/gta4/vehicles/emperor/emperor_lights_on'
			},
			Brake_Reverse = {
				[13] = '',
				[5] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[12] = 'models/gta4/vehicles/emperor/emperor_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[13] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[5] = '',
				[12] = ''
			},
			Brake = {
				[13] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[5] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[12] = ''
			},
			Reverse = {
				[13] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[5] = '',
				[12] = 'models/gta4/vehicles/emperor/emperor_lights_on'
			},
			Brake_Reverse = {
				[13] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[5] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[12] = 'models/gta4/vehicles/emperor/emperor_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[13] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[5] = '',
				[12] = ''
			},
			Brake = {
				[13] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[5] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[12] = ''
			},
			Reverse = {
				[13] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[5] = '',
				[12] = 'models/gta4/vehicles/emperor/emperor_lights_on'
			},
			Brake_Reverse = {
				[13] = 'models/gta4/vehicles/emperor/emperor_lights_on',
				[5] = 'models/gta4/vehicles/emperor/emperor_lights_on',
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
list.Set('simfphys_lights', 'gta4_emperor2', light_table)