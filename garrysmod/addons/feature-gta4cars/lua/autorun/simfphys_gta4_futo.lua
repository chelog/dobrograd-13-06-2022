local V = {
	Name = 'Futo',
	Model = 'models/octoteam/vehicles/futo.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Хетчбеки',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Хетчбеки',

	Members = {
		Mass = 1250,
		Trunk = { 25 },

		EnginePos = Vector(60,0,5),

		LightsTable = 'gta4_futo',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(32,0,30)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,0,8)}
				-- CarCols[3] =  {REN.GTA4ColorTable(0,3,12)}
				-- CarCols[4] =  {REN.GTA4ColorTable(3,3,8)}
				-- CarCols[5] =  {REN.GTA4ColorTable(4,0,0)}
				-- CarCols[6] =  {REN.GTA4ColorTable(13,1,8)}
				-- CarCols[7] =  {REN.GTA4ColorTable(34,0,30)}
				-- CarCols[8] =  {REN.GTA4ColorTable(36,36,30)}
				-- CarCols[9] =  {REN.GTA4ColorTable(40,40,40)}
				-- CarCols[10] = {REN.GTA4ColorTable(52,52,50)}
				-- CarCols[11] = {REN.GTA4ColorTable(54,52,2)}
				-- CarCols[12] = {REN.GTA4ColorTable(62,61,62)}
				-- CarCols[13] = {REN.GTA4ColorTable(68,0,2)}
				-- CarCols[14] = {REN.GTA4ColorTable(79,79,79)}
				-- CarCols[15] = {REN.GTA4ColorTable(85,85,2)}
				-- CarCols[16] = {REN.GTA4ColorTable(86,1,86)}
				-- CarCols[17] = {REN.GTA4ColorTable(87,0,2)}
				-- CarCols[18] = {REN.GTA4ColorTable(98,1,98)}
				-- CarCols[19] = {REN.GTA4ColorTable(108,106,2)}
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

		CustomWheelModel = 'models/octoteam/vehicles/futo_wheel.mdl',

		CustomWheelPosFL = Vector(55,28,-8),
		CustomWheelPosFR = Vector(55,-28,-8),
		CustomWheelPosRL = Vector(-45,28,-8),
		CustomWheelPosRR = Vector(-45,-28,-8),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(8,0,-2.4),

		CustomSteerAngle = 45,

		SeatOffset = Vector(-14,-14,18),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-1,-15,-14),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-83,-13.5,-9.5),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 8,
		FrontConstant = 30000,
		FrontDamping = 1000,
		FrontRelativeDamping = 1000,

		RearHeight = 7,
		RearConstant = 30000,
		RearDamping = 1000,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 15,
		SteeringFadeFastSpeed = 700,

		TurnSpeed = 8,
		CounterSteeringMul = 0.85,

		MaxGrip = 30,
		Efficiency = 1.3,
		GripOffset = 3,
		BrakePower = 30,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 8000,
		PeakTorque = 50,
		PowerbandStart = 1200,
		PowerbandEnd = 6800,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-60,-31,13),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 40,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1.1,
		snd_idle = 'octoteam/vehicles/blista_idle.wav',

		snd_low = 'octoteam/vehicles/blista_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/blista_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/blista_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/blista_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/blista_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/minivan_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.12,0.27,0.38,0.45,0.55},

		Dash = { pos = Vector(18.620, 13.255, 14.250), ang = Angle(-0.0, -90.0, 72.9) },
		Radio = { pos = Vector(23.938, -2.792, 10.563), ang = Angle(0.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(90.380, 0.007, -3.712), ang = Angle(1.7, -0.0, -0.0) },
			Back = { pos = Vector(-82.380, -0.000, 6.627), ang = Angle(-15.4, -180.0, -0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(8.597, -0.008, 27.446),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(19.050, 34.465, 16.453),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(18.522, -34.593, 16.828),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_futo', V )

local V2 = {}
V2.Name = 'Futo GT'
V2.Model = 'models/octoteam/vehicles/futo.mdl'
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
		-- CarCols[1] =  {REN.GTA4ColorTable(32,0,30)}
		-- CarCols[2] =  {REN.GTA4ColorTable(0,0,8)}
		-- CarCols[3] =  {REN.GTA4ColorTable(0,3,12)}
		-- CarCols[4] =  {REN.GTA4ColorTable(3,3,8)}
		-- CarCols[5] =  {REN.GTA4ColorTable(4,0,0)}
		-- CarCols[6] =  {REN.GTA4ColorTable(13,1,8)}
		-- CarCols[7] =  {REN.GTA4ColorTable(34,0,30)}
		-- CarCols[8] =  {REN.GTA4ColorTable(36,36,30)}
		-- CarCols[9] =  {REN.GTA4ColorTable(40,40,40)}
		-- CarCols[10] = {REN.GTA4ColorTable(52,52,50)}
		-- CarCols[11] = {REN.GTA4ColorTable(54,52,2)}
		-- CarCols[12] = {REN.GTA4ColorTable(62,61,62)}
		-- CarCols[13] = {REN.GTA4ColorTable(68,0,2)}
		-- CarCols[14] = {REN.GTA4ColorTable(79,79,79)}
		-- CarCols[15] = {REN.GTA4ColorTable(85,85,2)}
		-- CarCols[16] = {REN.GTA4ColorTable(86,1,86)}
		-- CarCols[17] = {REN.GTA4ColorTable(87,0,2)}
		-- CarCols[18] = {REN.GTA4ColorTable(98,1,98)}
		-- CarCols[19] = {REN.GTA4ColorTable(108,106,2)}
		-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
	end

	REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
end
V2.Members.ModelInfo = {
	WheelColor = Color(10,10,10),
},
list.Set('simfphys_vehicles', 'sim_fphys_gta4_futo2', V2 )

local light_table = {
	L_HeadLampPos = Vector(83,23,5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(83,-23,5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-82,16,9),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-82,-16,9),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(83,23,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(83,-23,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(19,20.2,15.6),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(83,23,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(83,-23,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(19,20.2,14.6),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-82,16,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-82,-16,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-82,25,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-82,-25,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 90,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-81.5,18.5,12.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-81.5,-18.5,12.5),
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
				pos = Vector(-78,29.5,8.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(19,14.2,15.65),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(-78,-29.5,8.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(19,12.7,15.65),
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
				[10] = '',
				[11] = '',
			},
			Brake = {
				[5] = '',
				[10] = 'models/gta4/vehicles/futo/futo_lights_on',
				[11] = '',
			},
			Reverse = {
				[5] = '',
				[10] = '',
				[11] = 'models/gta4/vehicles/futo/futo_lights_on',
			},
			Brake_Reverse = {
				[5] = '',
				[10] = 'models/gta4/vehicles/futo/futo_lights_on',
				[11] = 'models/gta4/vehicles/futo/futo_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/futo/futo_lights_on',
				[10] = '',
				[11] = '',
			},
			Brake = {
				[5] = 'models/gta4/vehicles/futo/futo_lights_on',
				[10] = 'models/gta4/vehicles/futo/futo_lights_on',
				[11] = '',
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/futo/futo_lights_on',
				[10] = '',
				[11] = 'models/gta4/vehicles/futo/futo_lights_on',
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/futo/futo_lights_on',
				[10] = 'models/gta4/vehicles/futo/futo_lights_on',
				[11] = 'models/gta4/vehicles/futo/futo_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/futo/futo_lights_on',
				[10] = '',
				[11] = '',
			},
			Brake = {
				[5] = 'models/gta4/vehicles/futo/futo_lights_on',
				[10] = 'models/gta4/vehicles/futo/futo_lights_on',
				[11] = '',
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/futo/futo_lights_on',
				[10] = '',
				[11] = 'models/gta4/vehicles/futo/futo_lights_on',
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/futo/futo_lights_on',
				[10] = 'models/gta4/vehicles/futo/futo_lights_on',
				[11] = 'models/gta4/vehicles/futo/futo_lights_on',
			},
		},
		turnsignals = {
			left = {
				[13] = 'models/gta4/vehicles/futo/futo_lights_on'
			},
			right = {
				[4] = 'models/gta4/vehicles/futo/futo_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_futo', light_table)