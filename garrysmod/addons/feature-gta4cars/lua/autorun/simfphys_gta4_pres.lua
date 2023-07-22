local V = {
	Name = 'Presidente',
	Model = 'models/octoteam/vehicles/pres.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 2200.0,

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_pres',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,6,0)}
				-- CarCols[3] =  {REN.GTA4ColorTable(0,133,12)}
				-- CarCols[4] =  {REN.GTA4ColorTable(4,133,12)}
				-- CarCols[5] =  {REN.GTA4ColorTable(6,97,12)}
				-- CarCols[6] =  {REN.GTA4ColorTable(10,133,12)}
				-- CarCols[7] =  {REN.GTA4ColorTable(21,133,12)}
				-- CarCols[8] =  {REN.GTA4ColorTable(23,133,12)}
				-- CarCols[9] =  {REN.GTA4ColorTable(25,133,12)}
				-- CarCols[10] = {REN.GTA4ColorTable(33,133,35)}
				-- CarCols[11] = {REN.GTA4ColorTable(34,97,34)}
				-- CarCols[12] = {REN.GTA4ColorTable(47,133,35)}
				-- CarCols[13] = {REN.GTA4ColorTable(49,133,63)}
				-- CarCols[14] = {REN.GTA4ColorTable(52,133,56)}
				-- CarCols[15] = {REN.GTA4ColorTable(54,133,55)}
				-- CarCols[16] = {REN.GTA4ColorTable(65,133,63)}
				-- CarCols[17] = {REN.GTA4ColorTable(67,133,118)}
				-- CarCols[18] = {REN.GTA4ColorTable(70,133,65)}
				-- CarCols[19] = {REN.GTA4ColorTable(98,133,90)}
				-- CarCols[20] = {REN.GTA4ColorTable(16,133,76)}
				-- CarCols[21] = {REN.GTA4ColorTable(9,1,91)}
				-- CarCols[22] = {REN.GTA4ColorTable(15,133,93)}
				-- CarCols[23] = {REN.GTA4ColorTable(19,1,93)}
				-- CarCols[24] = {REN.GTA4ColorTable(13,133,80)}
				-- ent:SetProxyColors(CarCols[math.random(2,table.Count(CarCols))] )
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

		CustomWheelModel = 'models/octoteam/vehicles/pres_wheel.mdl',

		CustomWheelPosFL = Vector(60,30,-14),
		CustomWheelPosFR = Vector(60,-30,-14),
		CustomWheelPosRL = Vector(-60,30,-14),
		CustomWheelPosRR = Vector(-60,-30,-14),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 34,

		SeatOffset = Vector(-5,-18,18),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(7,-17,-12),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-38,17,-12),
				ang = Angle(0,-90,10)
			},
			{
				pos = Vector(-38,-17,-12),
				ang = Angle(0,-90,10)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-102,22.5,-11),
				ang = Angle(-80,0,0),
			},
			{
				pos = Vector(-102,19,-11),
				ang = Angle(-80,0,0),
			},
			{
				pos = Vector(-102,-22.5,-11),
				ang = Angle(-80,0,0),
			},
			{
				pos = Vector(-102,-19,-11),
				ang = Angle(-80,0,0),
			},
		},

		FrontHeight = 10,
		FrontConstant = 30000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 10,
		RearConstant = 30000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 83,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 24,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 145.0,
		PowerbandStart = 2500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-73,-31,18),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 90,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/feroci_idle.wav',

		snd_low = 'octoteam/vehicles/feroci_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/feroci_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/feroci_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/feroci_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/feroci_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/huntley_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.17,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_pres', V )

local V2 = {}
V2.Name = 'Korean Mob Presidente'
V2.Model = 'models/octoteam/vehicles/pres.mdl'
V2.Class = 'gmod_sent_vehicle_fphysics_base'
V2.Category = 'Доброград - Особые'
V2.SpawnOffset = Vector(0,0,20)
V2.SpawnAngleOffset = 90
V2.NAKGame = 'Доброград'
V2.NAKType = 'Седаны'

local V2Members = {}
for k,v in pairs(V.Members) do
	V2Members[k] = v
end
V2.Members = V2Members
V2.Members.OnSpawn = function(ent)
	-- ent:SetSkin(math.random(0,2))
	ent:SetBodyGroups('011'	 )

	if (ProxyColor ) then
		-- local CarCols = {}
		-- CarCols[1] =  {REN.GTA4ColorTable(0,1,75)}
		-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
	end

	REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
end
V2.Members.ModelInfo = {
	WheelColor = Color(10,10,10),
}
V2.Members.Supercharged = true
list.Set('simfphys_vehicles', 'sim_fphys_gta4_pres2', V2 )

local light_table = {
	L_HeadLampPos = Vector(82,28,5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(82,-28,5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-97,28,10),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-97,-28,10),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(82,28,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},
		{
			pos = Vector(82,-28,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},

--[[		{
			pos = Vector(29,25,13),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(85,23,3),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(85,-23,3),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(29,25,12),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(91,24,-12.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(91,-24,-12.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-97,28,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-97,-28,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-97,28,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-97,-28,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-97,0,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-97,29,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-97,-29,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(91,25,-1.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-95,28,16),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(30,21,15),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(91,-25,-1.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-95,-28,16),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(30,15,15),
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
				[9] = '',
				[11] = '',
				[12] = '',
				[13] = '',
			},
			Brake = {
				[10] = '',
				[9] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[11] = '',
				[12] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[13] = '',
			},
			Reverse = {
				[10] = '',
				[9] = '',
				[11] = '',
				[12] = '',
				[13] = 'models/gta4/vehicles/pres/presidente_lights_on',
			},
			Brake_Reverse = {
				[10] = '',
				[9] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[11] = '',
				[12] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[13] = 'models/gta4/vehicles/pres/presidente_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[9] = '',
				[11] = '',
				[12] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[13] = '',
			},
			Brake = {
				[10] = '',
				[9] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[11] = '',
				[12] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[13] = '',
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[9] = '',
				[11] = '',
				[12] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[13] = 'models/gta4/vehicles/pres/presidente_lights_on',
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[9] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[11] = '',
				[12] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[13] = 'models/gta4/vehicles/pres/presidente_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[9] = '',
				[11] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[12] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[13] = '',
			},
			Brake = {
				[10] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[9] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[11] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[12] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[13] = '',
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[9] = '',
				[11] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[12] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[13] = 'models/gta4/vehicles/pres/presidente_lights_on',
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[9] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[11] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[12] = 'models/gta4/vehicles/pres/presidente_lights_on',
				[13] = 'models/gta4/vehicles/pres/presidente_lights_on',
			},
		},
		turnsignals = {
			left = {
				[4] = 'models/gta4/vehicles/pres/presidente_lights_on'
			},
			right = {
				[8] = 'models/gta4/vehicles/pres/presidente_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_pres', light_table)