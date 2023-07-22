local V = {
	Name = 'Primo',
	Model = 'models/octoteam/vehicles/primo.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1700.0,

		EnginePos = Vector(70,0,10),

		LightsTable = 'gta4_primo',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1)..'000'	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable2(0,0,0,127)}
				-- CarCols[2] =  {REN.GTA4ColorTable2(0,0,0,133)}
				-- CarCols[3] =  {REN.GTA4ColorTable2(0,1,12,133)}
				-- CarCols[4] =  {REN.GTA4ColorTable2(1,4,12,133)}
				-- CarCols[5] =  {REN.GTA4ColorTable2(16,17,12,133)}
				-- CarCols[6] =  {REN.GTA4ColorTable2(17,17,12,133)}
				-- CarCols[7] =  {REN.GTA4ColorTable2(21,21,12,133)}
				-- CarCols[8] =  {REN.GTA4ColorTable2(22,23,12,133)}
				-- CarCols[9] =  {REN.GTA4ColorTable2(31,34,30,133)}
				-- CarCols[10] = {REN.GTA4ColorTable2(33,33,32,133)}
				-- CarCols[11] = {REN.GTA4ColorTable2(36,36,32,133)}
				-- CarCols[12] = {REN.GTA4ColorTable2(52,52,55,133)}
				-- CarCols[13] = {REN.GTA4ColorTable2(57,52,12,133)}
				-- CarCols[14] = {REN.GTA4ColorTable2(62,55,12,133)}
				-- CarCols[15] = {REN.GTA4ColorTable2(70,69,63,133)}
				-- CarCols[16] = {REN.GTA4ColorTable2(97,93,90,133)}
				-- CarCols[17] = {REN.GTA4ColorTable2(54,54,55,133)}
				-- CarCols[18] = {REN.GTA4ColorTable2(67,67,118,133)}
				-- CarCols[19] = {REN.GTA4ColorTable2(70,70,65,133)}
				-- CarCols[20] = {REN.GTA4ColorTable2(98,98,90,133)}
				-- CarCols[21] = {REN.GTA4ColorTable2(16,16,76,133)}
				-- CarCols[22] = {REN.GTA4ColorTable2(9,9,91,133)}
				-- CarCols[23] = {REN.GTA4ColorTable2(15,15,93,133)}
				-- CarCols[24] = {REN.GTA4ColorTable2(19,19,93,133)}
				-- CarCols[25] = {REN.GTA4ColorTable2(13,13,80,133)}
				-- CarCols[26] = {REN.GTA4ColorTable2(12,12,80,127)}
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

		CustomWheelModel = 'models/octoteam/vehicles/primo_wheel.mdl',

		CustomWheelPosFL = Vector(62,32,-11),
		CustomWheelPosFR = Vector(62,-32,-11),
		CustomWheelPosRL = Vector(-61,32,-11),
		CustomWheelPosRR = Vector(-61,-32,-11),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(0,-18,20),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(13,-18,-13),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-35,18,-13),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-35,-18,-13),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-107,23,-10.5),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-107,-23,-10.5),
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

		MaxGrip = 77,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 23,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 140.0,
		PowerbandStart = 2500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-80,32,20),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 80,

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

		snd_horn = 'octoteam/vehicles/horns/merit_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.14,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_primo', V )

local V2 = {}
V2.Name = 'Spanish Lords Primo'
V2.Model = 'models/octoteam/vehicles/primo.mdl'
V2.Class = 'gmod_sent_vehicle_fphysics_base'
V2.Category = 'Доброград - Особые'
V2.SpawnOffset = Vector(0,0,10)
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
	ent:SetBodyGroups('02111'	 )

	if (ProxyColor ) then
		-- local CarCols = {}
		-- CarCols[1] =  {REN.GTA4ColorTable2(34,34,28,127)}
		-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
	end

	REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
end
V2.Members.ModelInfo = {
	WheelColor = Color(215,142,16),
}
V2.Members.Supercharged = true
list.Set('simfphys_vehicles', 'sim_fphys_gta4_primo2', V2 )

local light_table = {
	L_HeadLampPos = Vector(97,24,4.5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(97,-24,4.5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-107,23,10.5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-107,-23,10.5),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(97,24,4.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(97,-24,4.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(35,19.3,15.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(97,24,4.5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(97,-24,4.5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(34,19.3,14.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(101,22,-9.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(101,-22,-9.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-107,23,10.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-107,-23,10.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-107,23,10.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-107,-23,10.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-109,0,10.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-108,15,6.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,200,200,150),
		},
		{
			pos = Vector(-108,-15,6.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,200,200,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(84,35,-3.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-94,35,-0.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-107,26,6.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,200,200,150),
			},

--[[			{
				pos = Vector(35.4,20,16.6),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(84,-35,-3.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-94,-35,-0.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-107,-26,6.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,200,200,150),
			},

--[[			{
				pos = Vector(35.4,18.5,16.6),
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
				[11] = '',
				[12] = '',
				[14] = '',
			},
			Brake = {
				[10] = '',
				[11] = 'models/gta4/vehicles/primo/primo_lights_on',
				[12] = 'models/gta4/vehicles/primo/primo_lights_on',
				[14] = '',
			},
			Reverse = {
				[10] = '',
				[11] = '',
				[12] = '',
				[14] = 'models/gta4/vehicles/primo/primo_lights_on',
			},
			Brake_Reverse = {
				[10] = '',
				[11] = 'models/gta4/vehicles/primo/primo_lights_on',
				[12] = 'models/gta4/vehicles/primo/primo_lights_on',
				[14] = 'models/gta4/vehicles/primo/primo_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/primo/primo_lights_on',
				[11] = '',
				[12] = 'models/gta4/vehicles/primo/primo_lights_on',
				[14] = '',
			},
			Brake = {
				[10] = 'models/gta4/vehicles/primo/primo_lights_on',
				[11] = 'models/gta4/vehicles/primo/primo_lights_on',
				[12] = 'models/gta4/vehicles/primo/primo_lights_on',
				[14] = '',
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/primo/primo_lights_on',
				[11] = '',
				[12] = 'models/gta4/vehicles/primo/primo_lights_on',
				[14] = 'models/gta4/vehicles/primo/primo_lights_on',
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/primo/primo_lights_on',
				[11] = 'models/gta4/vehicles/primo/primo_lights_on',
				[12] = 'models/gta4/vehicles/primo/primo_lights_on',
				[14] = 'models/gta4/vehicles/primo/primo_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/primo/primo_lights_on',
				[11] = '',
				[12] = 'models/gta4/vehicles/primo/primo_lights_on',
				[14] = '',
			},
			Brake = {
				[10] = 'models/gta4/vehicles/primo/primo_lights_on',
				[11] = 'models/gta4/vehicles/primo/primo_lights_on',
				[12] = 'models/gta4/vehicles/primo/primo_lights_on',
				[14] = '',
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/primo/primo_lights_on',
				[11] = '',
				[12] = 'models/gta4/vehicles/primo/primo_lights_on',
				[14] = 'models/gta4/vehicles/primo/primo_lights_on',
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/primo/primo_lights_on',
				[11] = 'models/gta4/vehicles/primo/primo_lights_on',
				[12] = 'models/gta4/vehicles/primo/primo_lights_on',
				[14] = 'models/gta4/vehicles/primo/primo_lights_on',
			},
		},
		turnsignals = {
			left = {
				[9] = 'models/gta4/vehicles/primo/primo_lights_on'
			},
			right = {
				[6] = 'models/gta4/vehicles/primo/primo_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_primo', light_table)