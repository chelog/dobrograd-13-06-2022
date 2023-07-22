local V = {
	Name = 'Forklift',
	Model = 'models/octoteam/vehicles/forklift.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Индустриальные',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Индустриальные',

	Members = {
		Mass = 1400.0,
		NAKTankerHB = {
            Tank = {
                OBBMax = Vector(-35,-20,28),
                OBBMin = Vector(-47,20,46),
            },
		},

		EnginePos = Vector(-30,0,10),

		LightsTable = 'gta4_forklift',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(89,28,89)}
				-- CarCols[2] = {REN.GTA4ColorTable(89,74,89)}
				-- CarCols[3] = {REN.GTA4ColorTable(90,74,89)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.ForkliftHitbox(ent)

			REN.GTA4Forklift(ent)
			REN.GTA4SimfphysInit(ent, 2, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		SteerFront = false,
		SteerRear = true,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/forklift_wheel.mdl',

		CustomWheelPosFL = Vector(32,20,-8),
		CustomWheelPosFR = Vector(32,-20,-8),
		CustomWheelPosRL = Vector(-33,20,-8),
		CustomWheelPosRR = Vector(-33,-20,-8),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,-2),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-25,0,50),
		SeatPitch = 10,
		SeatYaw = 90,

		ExhaustPositions = {
			{
				pos = Vector(-52,21.3,5),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-52,-21.3,5),
				ang = Angle(-90,0,0),
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
		SteeringFadeFastSpeed = 100,

		TurnSpeed = 3,

		MaxGrip = 65,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 10,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 4000,
		PeakTorque = 50.0,
		PowerbandStart = 1500,
		PowerbandEnd = 3000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = true,

		FuelFillPos = Vector(18,28,1),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 45,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/forklift_idle.wav',

		snd_low = 'octoteam/vehicles/forklift_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/forklift_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/forklift_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/forklift_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/forklift_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/airtug_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.30,
		Gears = {-0.25,0,0.35}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_forklift', V )

local light_table = {
	L_HeadLampPos = Vector(20,14.3,71),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(20,-14.3,71),
	R_HeadLampAng = Angle(5,0,0),

	Headlight_sprites = {
		{
			pos = Vector(20,14.3,71),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(20,-14.3,71),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
	},

	Headlamp_sprites = {
		{pos = Vector(20,14.3,71),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(20,-14.3,71),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
	},

	DelayOn = 0,
	DelayOff = 0,

	SubMaterials = {
		off = {
			Base = {
				[3] = '',
			},
		},
		on_lowbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/forklift/forklift_stickers_on',
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_forklift', light_table)