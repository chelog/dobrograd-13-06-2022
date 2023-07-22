local V = {
	Name = 'Uranus',
	Model = 'models/octoteam/vehicles/uranus.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Хетчбеки',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Хетчбеки',

	Members = {
		Mass = 1300.0,

		EnginePos = Vector(60,0,10),

		LightsTable = 'gta4_uranus',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(13,1,13)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,133,0)}
				-- CarCols[3] =  {REN.GTA4ColorTable(72,133,1)}
				-- CarCols[4] =  {REN.GTA4ColorTable(54,133,1)}
				-- CarCols[5] =  {REN.GTA4ColorTable(55,133,1)}
				-- CarCols[6] =  {REN.GTA4ColorTable(58,133,1)}
				-- CarCols[7] =  {REN.GTA4ColorTable(65,133,1)}
				-- CarCols[8] =  {REN.GTA4ColorTable(72,133,1)}
				-- CarCols[9] =  {REN.GTA4ColorTable(75,133,1)}
				-- CarCols[10] = {REN.GTA4ColorTable(84,133,1)}
				-- CarCols[11] = {REN.GTA4ColorTable(90,112,1)}
				-- CarCols[12] = {REN.GTA4ColorTable(119,112,1)}
				-- CarCols[13] = {REN.GTA4ColorTable(2,133,63)}
				-- CarCols[14] = {REN.GTA4ColorTable(21,133,72)}
				-- CarCols[15] = {REN.GTA4ColorTable(22,133,72)}
				-- CarCols[16] = {REN.GTA4ColorTable(13,133,91)}
				-- CarCols[17] = {REN.GTA4ColorTable(19,133,93)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 1) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/uranus_wheel.mdl',

		CustomWheelPosFL = Vector(56,28,-5),
		CustomWheelPosFR = Vector(56,-28,-5),
		CustomWheelPosRL = Vector(-56,28,-5),
		CustomWheelPosRR = Vector(-56,-28,-5),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0.02,-2.4),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-16,-14,22),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-5,-14,-10),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-92,-20,-8),
				ang = Angle(-90,0,0),
				OnBodyGroups = {
					[1] = {0},
				}
			},
			{
				pos = Vector(-92,19.5,-8),
				ang = Angle(-90,0,0),
				OnBodyGroups = {
					[1] = {1},
				}
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

		MaxGrip = 80,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 23,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6500,
		PeakTorque = 130.0,
		PowerbandStart = 1700,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-74,31,13),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 65,

		PowerBias = -1,

		EngineSoundPreset = -1,

		snd_pitch = 0.9,
		snd_idle = 'octoteam/vehicles/esperanto_idle.wav',

		snd_low = 'octoteam/vehicles/esperanto_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/esperanto_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/esperanto_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/esperanto_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/esperanto_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/uranus_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.14,
		Gears = {-0.5,0,0.15,0.35,0.5,0.75}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_uranus', V )

local V2 = {}
V2.Name = 'Russian Mafia Uranus'
V2.Model = 'models/octoteam/vehicles/uranus.mdl'
V2.Class = 'gmod_sent_vehicle_fphysics_base'
V2.Category = 'Доброград - Особые'
V2.SpawnOffset = Vector(0,0,10)
V2.SpawnAngleOffset = 90
V2.NAKGame = 'Доброград'
V2.NAKType = 'Хетчбеки'

local V2Members = {}
for k,v in pairs(V.Members) do
	V2Members[k] = v
end
V2.Members = V2Members
V2.Members.OnSpawn = function(ent)
	-- ent:SetSkin(math.random(0,2))
	ent:SetBodyGroups('01111'	 )

	if (ProxyColor ) then
		-- local CarCols = {}
		-- CarCols[1] =  {REN.GTA4ColorTable(13,1,13)}
		-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
	end

	REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
end
V2.Members.ModelInfo = {
	WheelColor = Color(75,75,75),
},
list.Set('simfphys_vehicles', 'sim_fphys_gta4_uranus2', V2 )

local light_table = {
	L_HeadLampPos = Vector(87,20,6),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(87,-20,6),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-93,21,8),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-93,-21,8),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(87,20,6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(87,-20,6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(14.5,15.5,16),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(87,20,6),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(87,-20,6),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(14.5,13.7,16),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(91,23.5,0.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(91,-23.5,0.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-93,21,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-93,-21,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-93,13,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-93,-13,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 90,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-93,18,4.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-93,-18,4.5),
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
				pos = Vector(90,28.5,0.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-93,24,4.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(16,16.5,19.5),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(90,-28.5,0.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-93,-24,4.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(16,13,19.5),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[10] = '',
				[7] = '',
				[11] = '',
			},
			Brake = {
				[10] = '',
				[7] = 'models/gta4/vehicles/uranus/uranus_lights_on',
				[11] = '',
			},
			Reverse = {
				[10] = '',
				[7] = '',
				[11] = 'models/gta4/vehicles/uranus/uranus_lights_on',
			},
			Brake_Reverse = {
				[10] = '',
				[7] = 'models/gta4/vehicles/uranus/uranus_lights_on',
				[11] = 'models/gta4/vehicles/uranus/uranus_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/uranus/uranus_lights_on',
				[7] = '',
				[11] = '',
			},
			Brake = {
				[10] = 'models/gta4/vehicles/uranus/uranus_lights_on',
				[7] = 'models/gta4/vehicles/uranus/uranus_lights_on',
				[11] = '',
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/uranus/uranus_lights_on',
				[7] = '',
				[11] = 'models/gta4/vehicles/uranus/uranus_lights_on',
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/uranus/uranus_lights_on',
				[7] = 'models/gta4/vehicles/uranus/uranus_lights_on',
				[11] = 'models/gta4/vehicles/uranus/uranus_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/uranus/uranus_lights_on',
				[7] = '',
				[11] = '',
			},
			Brake = {
				[10] = 'models/gta4/vehicles/uranus/uranus_lights_on',
				[7] = 'models/gta4/vehicles/uranus/uranus_lights_on',
				[11] = '',
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/uranus/uranus_lights_on',
				[7] = '',
				[11] = 'models/gta4/vehicles/uranus/uranus_lights_on',
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/uranus/uranus_lights_on',
				[7] = 'models/gta4/vehicles/uranus/uranus_lights_on',
				[11] = 'models/gta4/vehicles/uranus/uranus_lights_on',
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/uranus/uranus_lights_on'
			},
			right = {
				[3] = 'models/gta4/vehicles/uranus/uranus_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_uranus', light_table)