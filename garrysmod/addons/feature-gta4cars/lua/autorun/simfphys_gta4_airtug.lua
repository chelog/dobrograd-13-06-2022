local V = {
	Name = 'Airtug',
	Model = 'models/octoteam/vehicles/airtug.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Сервис',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Сервис',
	FLEX = {
		Trailers = {
			outputPos = Vector(-70,0,-5),
			outputType = 'ballsocket'
		}
	},

	Members = {
		Mass = 1400.0,

		EnginePos = Vector(30,0,20),

		LightsTable = 'gta4_airtug',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(113,113,113)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 2, 0) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/airtug_wheel.mdl',
		CustomWheelModel_R = 'models/octoteam/vehicles/airtug_wheel_r.mdl',

		CustomWheelPosFL = Vector(34,21,-11),
		CustomWheelPosFR = Vector(34,-21,-11),
		CustomWheelPosRL = Vector(-34,19,-5),
		CustomWheelPosRR = Vector(-34,-19,-5),
		CustomWheelAngleOffset = Angle(0,-90,0),

		FrontWheelRadius = 9,
		RearWheelRadius = 15,

		CustomMassCenter = Vector(0,0,-2),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-35,-12,45),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-30,-10,15),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},

		FrontHeight = 10,
		FrontConstant = 20000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 10,
		RearConstant = 20000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3,

		MaxGrip = 65,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 10,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 140.0,
		PowerbandStart = 2000,
		PowerbandEnd = 4000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = true,

		FuelFillPos = Vector(18,28,1),
		FuelType = FUELTYPE_ELECTRIC,
		FuelTankSize = 45,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/airtug_idle.wav',

		snd_low = 'octoteam/vehicles/airtug_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/airtug_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/airtug_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/airtug_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/airtug_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/airtug_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.10,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_airtug', V )

local light_table = {
	L_HeadLampPos = Vector(52,21.4,1.3),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(52,-21.4,1.3),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-49.9,20.6,13.1),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-49.9,-20.6,13.1),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(52,21.4,1.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(52,-21.4,1.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(2.4,5.5,35.4),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(52,21.4,1.3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(52,-21.4,1.3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(2.4,7.2,35.4),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-49.9,20.6,13.1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-49.9,-20.6,13.1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-49.9,20.6,13.1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-49.9,-20.6,13.1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-49.9,16,13.1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-49.9,-16,13.1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	SubMaterials = {
		off = {
			Base = {
				[2] = '',
				[3] = ''
			},
			Reverse = {
				[2] = '',
				[3] = 'models/gta4/vehicles/airtug/detail2_on'
			},
		},
		on_lowbeam = {
			Base = {
				[2] = 'models/gta4/vehicles/airtug/detail2_on',
				[3] = ''
			},
			Reverse = {
				[2] = 'models/gta4/vehicles/airtug/detail2_on',
				[3] = 'models/gta4/vehicles/airtug/detail2_on'
			},
		},
		on_highbeam = {
			Base = {
				[2] = 'models/gta4/vehicles/airtug/detail2_on',
				[3] = ''
			},
			Reverse = {
				[2] = 'models/gta4/vehicles/airtug/detail2_on',
				[3] = 'models/gta4/vehicles/airtug/detail2_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_airtug', light_table)