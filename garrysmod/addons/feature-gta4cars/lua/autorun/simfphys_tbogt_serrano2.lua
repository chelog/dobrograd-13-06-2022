local V = {
	Name = 'Serrano Custom',
	Model = 'models/octoteam/vehicles/serrano2.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 3000.0,

		EnginePos = Vector(70,0,10),

		LightsTable = 'gta4_serrano2',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			ent.CarCol = math.random(1,14)

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,1)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,0,82)}
				-- CarCols[3] =  {REN.GTA4ColorTable(0,0,133)}
				-- CarCols[4] =  {REN.GTA4ColorTable(38,0,34)}
				-- CarCols[5] =  {REN.GTA4ColorTable(4,0,4)}
				-- CarCols[6] =  {REN.GTA4ColorTable(24,24,24)}
				-- CarCols[7] =  {REN.GTA4ColorTable(31,0,28)}
				-- CarCols[8] =  {REN.GTA4ColorTable(34,34,27)}
				-- CarCols[9] =  {REN.GTA4ColorTable(37,37,28)}
				-- CarCols[10] = {REN.GTA4ColorTable(89,0,89)}
				-- CarCols[11] = {REN.GTA4ColorTable(2,2,133)}
				-- CarCols[12] = {REN.GTA4ColorTable(6,6,133)}
				-- CarCols[13] = {REN.GTA4ColorTable(11,11,89)}
				-- CarCols[14] = {REN.GTA4ColorTable(21,21,128)}
				ent:SetProxyColors(CarCols[ent.CarCol] )

				for i = 1,table.Count(ent.Wheels) do --this is a horrible way of doing this, yandere dev tier coding
					if ent.Wheels != nil then
						if ent.CarCol == 1 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(0))
						elseif ent.CarCol == 2 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(133))
						elseif ent.CarCol == 3 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(133))
						elseif ent.CarCol == 4 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(0))
						elseif ent.CarCol == 5 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(0))
						elseif ent.CarCol == 6 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(0))
						elseif ent.CarCol == 7 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(0))
						elseif ent.CarCol == 8 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(133))
						elseif ent.CarCol == 9 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(133))
						elseif ent.CarCol == 10 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(0))
						elseif ent.CarCol == 11 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(133))
						elseif ent.CarCol == 12 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(0))
						elseif ent.CarCol == 13 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(0))
						elseif ent.CarCol == 14 then
							ent.Wheels[i]:SetColor(REN.GTA4ColorTable(133))
						end
					end
				end
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

		CustomWheelModel = 'models/octoteam/vehicles/serrano2_wheel.mdl',

		CustomWheelPosFL = Vector(61,34,-6),
		CustomWheelPosFR = Vector(61,-34,-6),
		CustomWheelPosRL = Vector(-61,34,-6),
		CustomWheelPosRR = Vector(-61,-34,-6),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,10),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-8,-19,31),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(0,-19,-2),
				ang = Angle(0,-90,10),
				hasRadio = true
			},
			{
				pos = Vector(-40,19,-2),
				ang = Angle(0,-90,10)
			},
			{
				pos = Vector(-40,-19,-2),
				ang = Angle(0,-90,10)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-98,20,-8),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-98,-20,-8),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 12,
		FrontConstant = 32000,
		FrontDamping = 1250,
		FrontRelativeDamping = 350,

		RearHeight = 12,
		RearConstant = 32000,
		RearDamping = 1250,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3,

		MaxGrip = 80,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 20,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 145.0,
		PowerbandStart = 2000,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-73,-36,24),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 100,

		PowerBias = 0,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/serrano_idle.wav',

		snd_low = 'octoteam/vehicles/serrano_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/serrano_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/serrano_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/serrano_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/serrano_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/huntley_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.21,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tbogt_serrano2', V )

local light_table = {
	L_HeadLampPos = Vector(83,33.5,17),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(83,-33.5,17),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-93,22,17),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-93,-22,17),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(83,33.5,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(83,-33.5,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(24.6,19,23),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(76,240,255,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(85.5,28,17),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(85.5,-28,17),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(24.6,17,23),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(76,240,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(92,27.2,-0.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(92,-27.2,-0.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-95,31,23),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-95,-31,23),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-95,31,23),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-95,-31,23),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-96,31,17.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-96,-31,17.5),
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
				pos = Vector(91,30,12.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-92,32,27),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(25,20.5,25.8),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(91,-30,12.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-92,-32,27),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(25,15.4,25.8),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[5] = '',
				[6] = '',
				[13] = '',
				[9] = ''
			},
			Brake = {
				[5] = '',
				[6] = '',
				[13] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[9] = ''
			},
			Reverse = {
				[5] = '',
				[6] = '',
				[13] = '',
				[9] = 'models/gta4/vehicles/serrano/serrano_lights_on'
			},
			Brake_Reverse = {
				[5] = '',
				[6] = '',
				[13] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[9] = 'models/gta4/vehicles/serrano/serrano_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[6] = '',
				[13] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[9] = ''
			},
			Brake = {
				[5] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[6] = '',
				[13] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[9] = ''
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[6] = '',
				[13] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[9] = 'models/gta4/vehicles/serrano/serrano_lights_on'
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[6] = '',
				[13] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[9] = 'models/gta4/vehicles/serrano/serrano_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[6] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[13] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[9] = ''
			},
			Brake = {
				[5] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[6] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[13] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[9] = ''
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[6] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[13] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[9] = 'models/gta4/vehicles/serrano/serrano_lights_on'
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[6] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[13] = 'models/gta4/vehicles/serrano/serrano_lights_on',
				[9] = 'models/gta4/vehicles/serrano/serrano_lights_on'
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/serrano/serrano_lights_on'
			},
			right = {
				[8] = 'models/gta4/vehicles/serrano/serrano_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_serrano2', light_table)