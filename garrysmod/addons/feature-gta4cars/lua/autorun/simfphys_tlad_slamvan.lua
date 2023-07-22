local V = {
	Name = 'Slamvan',
	Model = 'models/octoteam/vehicles/slamvan.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 2500.0,

		EnginePos = Vector(70,0,10),

		BackFire = true,

		LightsTable = 'gta4_slamvan',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			ent.CarCol = math.random(1,4)

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(0,0,2)}
				-- CarCols[2] = {REN.GTA4ColorTable(1,1,1)}
				-- CarCols[3] = {REN.GTA4ColorTable(11,4,10)}
				-- CarCols[4] = {REN.GTA4ColorTable(30,30,10)}
				ent:SetProxyColors(CarCols[ent.CarCol] )

				for i = 1,table.Count(ent.Wheels) do
					if ent.Wheels != nil then
						if ent.CarCol == 1 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(35))
						elseif ent.CarCol == 2 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(1))
						elseif ent.CarCol == 3 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(3))
						elseif ent.CarCol == 4 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(3))
						end
					end
				end
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 2) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/slamvan_wheel.mdl',

		CustomWheelPosFL = Vector(60,37,-15),
		CustomWheelPosFR = Vector(60,-37,-15),
		CustomWheelPosRL = Vector(-60,37,-15),
		CustomWheelPosRR = Vector(-60,-37,-15),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,10),

		CustomSteerAngle = 35,

		SeatOffset = Vector(3,-17,27),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(7,-17,-5),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-35,36,-19),
				ang = Angle(-90,-80,0),
			},
			{
				pos = Vector(-31.5,36,-19),
				ang = Angle(-90,-80,0),
			},
		},

		FrontHeight = 10,
		FrontConstant = 25000,
		FrontDamping = 500,
		FrontRelativeDamping = 350,

		RearHeight = 10,
		RearConstant = 25000,
		RearDamping = 500,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 100,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 19,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 125.0,
		PowerbandStart = 2200,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-25,-38,-11),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 70,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/slamvan_idle.wav',

		snd_low = 'octoteam/vehicles/slamvan_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/slamvan_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/slamvan_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/slamvan_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/slamvan_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/slamvan_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.18,
		Gears = {-0.3,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tlad_slamvan', V )

local light_table = {
	L_HeadLampPos = Vector(92,33,-3),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(92,-33,-3),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-105.5,26.5,-1.5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-105.5,-26.5,-1.5),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(92,33,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(92,-33,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
	},

	Headlamp_sprites = {
		{pos = Vector(92,33,-3),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(92,-33,-3),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
	},

	Rearlight_sprites = {
		{
			pos = Vector(-105.5,26.5,-1.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-105.5,-26.5,-1.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-105.5,15,-1.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-105.5,-15,-1.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(-105.5,20,-1.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 20,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(33.5,20.4,19.3),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(255,0,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(-105.5,-20,-1.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 20,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(33.5,14.8,19.3),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(255,0,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[8] = '',
				[5] = '',
			},
			Brake = {
				[8] = '',
				[5] = 'models/gta4/vehicles/slamvan/slamvan_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/slamvan/slamvan_lights_on',
				[5] = '',
			},
			Brake = {
				[8] = 'models/gta4/vehicles/slamvan/slamvan_lights_on',
				[5] = 'models/gta4/vehicles/slamvan/slamvan_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/slamvan/slamvan_lights_on',
				[5] = '',
			},
			Brake = {
				[8] = 'models/gta4/vehicles/slamvan/slamvan_lights_on',
				[5] = 'models/gta4/vehicles/slamvan/slamvan_lights_on',
			},
		},
		turnsignals = {
			left = {
				[9] = 'models/gta4/vehicles/slamvan/slamvan_lights_on'
			},
			right = {
				[10] = 'models/gta4/vehicles/slamvan/slamvan_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_slamvan', light_table)