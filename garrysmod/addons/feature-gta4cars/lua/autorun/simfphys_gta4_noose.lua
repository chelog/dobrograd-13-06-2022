local V = {
	Name = 'NOOSE Cruiser',
	Model = 'models/octoteam/vehicles/noose.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Службы',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Службы',

	Members = {
		Mass = 1700.0,

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_noose',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(113,113,113)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
			REN.GTA4Bullhorn(ent)
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		ModelInfo = {
			WheelColor = Color(10,10,10),
		},

		CustomWheelModel = 'models/octoteam/vehicles/noose_wheel.mdl',

		CustomWheelPosFL = Vector(60,35,-13),
		CustomWheelPosFR = Vector(60,-35,-13),
		CustomWheelPosRL = Vector(-60,35,-13),
		CustomWheelPosRR = Vector(-60,-35,-13),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-8,-19.5,16),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(5,-20,-15),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-32,20,-15),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-32,-20,-15),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-114.6,22.3,-14.3),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 10,
		FrontConstant = 25000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 10,
		RearConstant = 25000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 87,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 22,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 150.0,
		PowerbandStart = 2500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-82.4,-37,9.8),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 80,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1.05,
		snd_idle = 'octoteam/vehicles/stainer_idle.wav',

		snd_low = 'octoteam/vehicles/stainer_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/stainer_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/stainer_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/stainer_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/stainer_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/stainer_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.22,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_noose', V )

local light_table = {
	L_HeadLampPos = Vector(98,25,2.3),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(98,-25,2.3),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-114,30,5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-114,-30,5),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(98,25,2.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(98,-25,2.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(23,19,11.3),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(98,25,2.3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(98,-25,2.3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(23,18,11.3),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-114,30,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-114,-30,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-114,21.7,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-114,-21.7,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	ems_sounds = {'GTA4_SIREN_WAIL','GTA4_SIREN_YELP','GTA4_SIREN_WARNING'},
	ems_sprites = {
		{
			pos = Vector(-17.3,16.5,37),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 80,
			Colors = {
						Color(255,0,0,150),
						Color(255,0,0,255),
						Color(255,0,0,150),
						--
						Color(255,0,0,100),
						Color(255,0,0,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(255,0,0,50),
						Color(255,0,0,100),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-17.3,11.1,37),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			Colors = {
						Color(0,0,0,0),
						Color(255,255,255,50),
						Color(255,255,255,100),
						--
						Color(255,255,255,150),
						Color(255,255,255,255),
						Color(255,255,255,150),
						--
						Color(255,255,255,100),
						Color(255,255,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-17.3,5.6,37),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 80,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(255,0,0,50),
						Color(255,0,0,100),
						--
						Color(255,0,0,150),
						Color(255,0,0,255),
						Color(255,0,0,150),
						--
						Color(255,0,0,100),
						Color(255,0,0,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-17.3,0,37),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(255,255,255,50),
						Color(255,255,255,100),
						--
						Color(255,255,255,150),
						Color(255,255,255,255),
						Color(255,255,255,150),
						--
						Color(255,255,255,100),
						Color(255,255,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-17.3,-5.6,37),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 80,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(255,0,0,50),
						Color(255,0,0,100),
						--
						Color(255,0,0,150),
						Color(255,0,0,255),
						Color(255,0,0,150),
						--
						Color(255,0,0,100),
						Color(255,0,0,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-17.3,-11.1,37),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			Colors = {
						Color(0,0,0,0),
						Color(255,255,255,50),
						Color(255,255,255,100),
						--
						Color(255,255,255,150),
						Color(255,255,255,255),
						Color(255,255,255,150),
						--
						Color(255,255,255,100),
						Color(255,255,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-17.3,-16.5,37),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 80,
			Colors = {
						Color(255,0,0,150),
						Color(255,0,0,255),
						Color(255,0,0,150),
						--
						Color(255,0,0,100),
						Color(255,0,0,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(255,0,0,50),
						Color(255,0,0,100),
					},
			Speed = 0.035
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(93.8,34.6,2.3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,20,11.3),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeLeft = {
			{
				pos = Vector(-114,30,5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
		Right = {
			{
				pos = Vector(93.8,-34.6,2.3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,17,11.3),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeRight = {
			{
				pos = Vector(-114,-30,5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[11] = '',
				[5] = '',
				[4] = ''
			},
			Brake = {
				[11] = '',
				[5] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[4] = ''
			},
			Reverse = {
				[11] = '',
				[5] = '',
				[4] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
			Brake_Reverse = {
				[11] = '',
				[5] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[4] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[11] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[5] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[4] = ''
			},
			Brake = {
				[11] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[5] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[4] = ''
			},
			Reverse = {
				[11] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[5] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[4] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
			Brake_Reverse = {
				[11] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[5] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[4] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[11] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[5] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[4] = ''
			},
			Brake = {
				[11] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[5] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[4] = ''
			},
			Reverse = {
				[11] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[5] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[4] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
			Brake_Reverse = {
				[11] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[5] = 'models/gta4/vehicles/stainer/noose_lights_on',
				[4] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
		},
		turnsignals = {
			left = {
				[6] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/stainer/noose_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_noose', light_table)