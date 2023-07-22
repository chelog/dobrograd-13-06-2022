CreateConVar("sv_simfphys_devmode", "1", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"1 = enabled, 0 = disabled   (requires a restart)")
CreateConVar("sv_simfphys_enabledamage", "1", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"1 = enabled, 0 = disabled")
CreateConVar("sv_simfphys_gib_lifetime", "30", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"How many seconds before removing the gibs (0 = never remove)")
CreateConVar("sv_simfphys_playerdamage", "1", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"should players take damage from collisions in vehicles?")
CreateConVar("sv_simfphys_damagemultiplicator", "1", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"vehicle damage multiplicator")
CreateConVar("sv_simfphys_fuel", "1", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"enable fuel? 1 = enabled, 0 = disabled")
CreateConVar("sv_simfphys_fuelscale", "0.1", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"fuel tank size multiplier. 1 = Realistic fuel tank size (about 2-3 hours of fullthrottle driving, Lol, have fun)")
CreateConVar("sv_simfphys_teampassenger", "0", {FCVAR_REPLICATED , FCVAR_ARCHIVE},"allow players of different teams to enter the same vehicle?, 0 = allow everyone, 1 = team only")

simfphys = istable(simfphys) and simfphys or {}
simfphys.DamageEnabled = false
simfphys.DamageMul = 1
simfphys.pDamageEnabled = false
simfphys.Fuel = true
simfphys.FuelMul = 0.1

FUELTYPE_NONE = 0
FUELTYPE_PETROL = 1
FUELTYPE_DIESEL = 2
FUELTYPE_ELECTRIC = 3

game.AddParticles("particles/vehicle.pcf")
game.AddParticles("particles/fire_01.pcf")

PrecacheParticleSystem("fire_large_01")
PrecacheParticleSystem("WheelDust")
PrecacheParticleSystem("smoke_gib_01")
PrecacheParticleSystem("burning_engine_01")

cvars.AddChangeCallback("sv_simfphys_enabledamage", function(convar, oldValue, newValue) simfphys.DamageEnabled = (tonumber(newValue)~=0) end)
cvars.AddChangeCallback("sv_simfphys_damagemultiplicator", function(convar, oldValue, newValue) simfphys.DamageMul = tonumber(newValue) end)
cvars.AddChangeCallback("sv_simfphys_playerdamage", function(convar, oldValue, newValue) simfphys.pDamageEnabled = (tonumber(newValue)~=0) end)
cvars.AddChangeCallback("sv_simfphys_fuel", function(convar, oldValue, newValue) simfphys.Fuel = (tonumber(newValue)~=0) end)
cvars.AddChangeCallback("sv_simfphys_fuelscale", function(convar, oldValue, newValue) simfphys.FuelMul = tonumber(newValue) end)

simfphys.DamageEnabled = GetConVar("sv_simfphys_enabledamage"):GetBool()
simfphys.DamageMul = GetConVar("sv_simfphys_damagemultiplicator"):GetFloat()
simfphys.pDamageEnabled = GetConVar("sv_simfphys_playerdamage"):GetBool()
simfphys.Fuel = GetConVar("sv_simfphys_fuel"):GetBool()
simfphys.FuelMul = GetConVar("sv_simfphys_fuelscale"):GetFloat()

simfphys.ice = CreateConVar("sv_simfphys_traction_ice", "0.35", {FCVAR_REPLICATED , FCVAR_ARCHIVE})
simfphys.gmod_ice = CreateConVar("sv_simfphys_traction_gmod_ice", "0.1", {FCVAR_REPLICATED , FCVAR_ARCHIVE})
simfphys.snow = CreateConVar("sv_simfphys_traction_snow", "0.7", {FCVAR_REPLICATED , FCVAR_ARCHIVE})
simfphys.slipperyslime  = CreateConVar("sv_simfphys_traction_slipperyslime", "0.2", {FCVAR_REPLICATED , FCVAR_ARCHIVE})
simfphys.grass = CreateConVar("sv_simfphys_traction_grass", "1", {FCVAR_REPLICATED , FCVAR_ARCHIVE})
simfphys.sand = CreateConVar("sv_simfphys_traction_sand", "1", {FCVAR_REPLICATED , FCVAR_ARCHIVE})
simfphys.dirt = CreateConVar("sv_simfphys_traction_dirt", "1", {FCVAR_REPLICATED , FCVAR_ARCHIVE})
simfphys.concrete = CreateConVar("sv_simfphys_traction_concrete", "1", {FCVAR_REPLICATED , FCVAR_ARCHIVE})
simfphys.metal = CreateConVar("sv_simfphys_traction_metal", "1", {FCVAR_REPLICATED , FCVAR_ARCHIVE})
simfphys.glass = CreateConVar("sv_simfphys_traction_glass", "1", {FCVAR_REPLICATED , FCVAR_ARCHIVE})
simfphys.gravel = CreateConVar("sv_simfphys_traction_gravel", "1", {FCVAR_REPLICATED , FCVAR_ARCHIVE})
simfphys.rock = CreateConVar("sv_simfphys_traction_rock", "1", {FCVAR_REPLICATED , FCVAR_ARCHIVE})
simfphys.wood = CreateConVar("sv_simfphys_traction_wood", "1", {FCVAR_REPLICATED , FCVAR_ARCHIVE})

local carClasses = {
	gmod_sent_vehicle_fphysics_base = true,
	gmod_sent_vehicle_fphysics_wheel = true,
}
local noCollisionClasses = {
	octoinv_item = true,
	ent_dbg_workproblem = true,
}

hook.Add('ShouldCollide', 'dbg-cars', function(ent1, ent2)

	local c1, c2 = ent1:GetClass(), ent2:GetClass()
	if (carClasses[c1] or carClasses[c2]) and (ent1.APG_Ghosted or ent2.APG_Ghosted) then
		return false
	end
	if (carClasses[c1] or carClasses[c2]) and (noCollisionClasses[c1] or noCollisionClasses[c2]) then
		return false
	end
	if (carClasses[c1] or carClasses[c2]) and (c1 == 'prop_effect' or c2 == 'prop_effect') then
		-- local effect = c1 == 'prop_effect' and ent1 or ent2
		-- local owner = effect:CPPIGetOwner()
		-- if IsValid(owner) then badBoy(owner) end
		return false
	end

end)

function simfphys.IsCar(ent)
	if not IsValid(ent) then return false end

	local IsVehicle = ent:GetClass():lower() == "gmod_sent_vehicle_fphysics_base"

	return IsVehicle
end

if SERVER then
	util.AddNetworkString("simfphys_settings")
	util.AddNetworkString("simfphys_turnsignal")

	net.Receive("simfphys_turnsignal", function(length, ply)
		local ent = net.ReadEntity()
		local mode = net.ReadInt(32)

		if not IsValid(ent) or not ent.TurnSignal then return end
		ent:TurnSignal(mode)
	end)

	net.Receive("simfphys_settings", function(length, ply)
		if not IsValid(ply) or not ply:IsSuperAdmin() then return end

		local dmgEnabled = tostring(net.ReadBool() and 1 or 0)
		local giblifetime = tostring(net.ReadFloat())

		local dmgMul = tostring(net.ReadFloat())
		local pdmgEnabled = tostring(net.ReadBool() and 1 or 0)

		local fuel = tostring(net.ReadBool() and 1 or 0)
		local fuelscale = tostring(net.ReadFloat())

		local newtraction = net.ReadTable()

		local teamonly = tostring(net.ReadBool() and 1 or 0)

		RunConsoleCommand("sv_simfphys_enabledamage", dmgEnabled)
		RunConsoleCommand("sv_simfphys_gib_lifetime", giblifetime)
		RunConsoleCommand("sv_simfphys_damagemultiplicator", dmgMul)
		RunConsoleCommand("sv_simfphys_playerdamage", pdmgEnabled)
		RunConsoleCommand("sv_simfphys_fuel", fuel)
		RunConsoleCommand("sv_simfphys_fuelscale", fuelscale)

		RunConsoleCommand("sv_simfphys_teampassenger", teamonly)

		for k, v in pairs(newtraction) do
			RunConsoleCommand("sv_simfphys_traction_"..k, v)
		end
		simfphys.UpdateFrictionData()
	end)

	function simfphys.SpawnVehicleSimple(spawnname, pos, ang)

		if not isstring(spawnname) then print("invalid spawnname") return NULL end
		if not isvector(pos) then print("invalid spawn position") return NULL end
		if not isangle(ang) then print("invalid spawn angle") return NULL end

		local vehicle = list.Get("simfphys_vehicles")[ spawnname ]

		if not vehicle then print("vehicle \""..spawnname.."\" does not exist!") return NULL end

		local Ent = simfphys.SpawnVehicle(nil, pos, ang, vehicle.Model, vehicle.Class, spawnname, vehicle, true)

		return Ent
	end

	function simfphys.SpawnVehicle(Player, Pos, Ang, Model, Class, VName, VTable, bNoOwner)

		if not bNoOwner then
			if not gamemode.Call("PlayerSpawnVehicle", Player, Model, VName, VTable) then return end
		end

		if not file.Exists(Model, "GAME") then
			if IsValid(Player) then
				Player:PrintMessage(HUD_PRINTTALK, "ERROR: \""..Model.."\" does not exist! (Class: "..VName..")")
			end
			ErrorNoHalt(Player, ' attempted to spawn vehicle ', VName, ' with invalid model ', Model)
			return
		end

		local Ent = ents.Create("gmod_sent_vehicle_fphysics_base")
		if not Ent then return NULL end

		Ent:SetModel(Model)
		Ent:SetAngles(Ang)
		Ent:SetPos(Pos)

		Ent:Spawn()
		Ent:Activate()

		Ent.VehicleName = VName
		Ent.VehicleTable = VTable
		Ent.EntityOwner = Player
		Ent:SetSpawn_List(VName)

		if IsValid(Player) then
			gamemode.Call("PlayerSpawnedVehicle", Player, Ent)
		end

		if VTable.Members then
			table.Merge(Ent, VTable.Members)

			if Ent.ModelInfo then
				if Ent.ModelInfo.Bodygroups then
					for i = 1, table.Count(Ent.ModelInfo.Bodygroups) do
						Ent:SetBodygroup(i, Ent.ModelInfo.Bodygroups[i])
					end
				end

				if Ent.ModelInfo.Skin then
					Ent:SetSkin(Ent.ModelInfo.Skin)
				end

				if Ent.ModelInfo.Color then
					Ent:SetColor(Ent.ModelInfo.Color)

					local Color = Ent.ModelInfo.Color
					local dot = Color.r * Color.g * Color.b * Color.a
					Ent.OldColor = dot

					local data = {
						Color = Color,
						RenderMode = 0,
						RenderFX = 0
					}
					duplicator.StoreEntityModifier(Ent, "colour", data)
				end
			end

			Ent:SetTireSmokeColor(Vector(180,180,180) / 255)

			Ent.Turbocharged = Ent.Turbocharged or false
			Ent.Supercharged = Ent.Supercharged or false

			Ent:SetEngineSoundPreset(Ent.EngineSoundPreset)
			Ent:SetMaxTorque(Ent.PeakTorque)

			Ent:SetDifferentialGear(Ent.DifferentialGear)

			Ent:SetSteerSpeed(Ent.TurnSpeed)
			Ent:SetFastSteerConeFadeSpeed(Ent.SteeringFadeFastSpeed)
			Ent:SetFastSteerAngle(Ent.FastSteeringAngle)

			Ent:SetEfficiency(Ent.Efficiency)
			Ent:SetMaxTraction(Ent.MaxGrip)
			Ent:SetTractionBias(Ent.GripOffset / Ent.MaxGrip)
			Ent:SetPowerDistribution(Ent.PowerBias)

			Ent:SetBackFire(Ent.Backfire or false)
			Ent:SetDoNotStall(Ent.DoNotStall or false)

			Ent:SetIdleRPM(Ent.IdleRPM)
			Ent:SetLimitRPM(Ent.LimitRPM)
			Ent:SetRevlimiter(Ent.Revlimiter or false)
			Ent:SetPowerBandEnd(Ent.PowerbandEnd)
			Ent:SetPowerBandStart(Ent.PowerbandStart)

			Ent:SetTurboCharged(Ent.Turbocharged)
			Ent:SetSuperCharged(Ent.Supercharged)
			Ent:SetBrakePower(Ent.BrakePower)

			Ent:SetLights_List(Ent.LightsTable or "no_lights")

			Ent:SetBulletProofTires(Ent.BulletProofTires or false)

			Ent:SetBackfireSound(Ent.snd_backfire or "")

			duplicator.StoreEntityModifier(Ent, "VehicleMemDupe", VTable.Members)
		end

		return Ent
	end

	function simfphys.SetOwner(ply, ent)
		if not IsValid(ent) or not IsValid(ply) then return end

		if CPPI then ent:CPPISetOwner(ply) end
		ent.EntityOwner = ply
		gamemode.Call("PlayerSpawnedVehicle", ply, ent)
	end
end

function simfphys.UpdateFrictionData()
	simfphys.TractionData = {}

	timer.Simple(0.1,function()
		simfphys.TractionData["ice"] = simfphys.ice:GetFloat()
		simfphys.TractionData["gmod_ice"] = simfphys.gmod_ice:GetFloat()
		simfphys.TractionData["snow"] = simfphys.snow:GetFloat()
		simfphys.TractionData["slipperyslime"] = simfphys.slipperyslime:GetFloat()
		simfphys.TractionData["grass"] = simfphys.grass:GetFloat()
		simfphys.TractionData["sand"] = simfphys.sand:GetFloat()
		simfphys.TractionData["dirt"] = simfphys.dirt:GetFloat()
		simfphys.TractionData["concrete"] = simfphys.concrete:GetFloat()
		simfphys.TractionData["metal"] = simfphys.metal:GetFloat()
		simfphys.TractionData["glass"] = simfphys.glass:GetFloat()
		simfphys.TractionData["gravel"] = simfphys.gravel:GetFloat()
		simfphys.TractionData["rock"] = simfphys.rock:GetFloat()
		simfphys.TractionData["wood"] = simfphys.wood:GetFloat()
	end)
end
simfphys.UpdateFrictionData()

simfphys.SoundPresets = {
	{
		"simulated_vehicles/gta5_dukes/dukes_idle.wav",
		"simulated_vehicles/gta5_dukes/dukes_low.wav",
		"simulated_vehicles/gta5_dukes/dukes_mid.wav",
		"simulated_vehicles/gta5_dukes/dukes_revdown.wav",
		"simulated_vehicles/gta5_dukes/dukes_second.wav",
		"simulated_vehicles/gta5_dukes/dukes_second.wav",
		0.8,
		1,
		0.8
	},
	{
		"simulated_vehicles/master_chris_charger69/charger_idle.wav",
		"simulated_vehicles/master_chris_charger69/charger_low.wav",
		"simulated_vehicles/master_chris_charger69/charger_mid.wav",
		"simulated_vehicles/master_chris_charger69/charger_revdown.wav",
		"simulated_vehicles/master_chris_charger69/charger_second.wav",
		"simulated_vehicles/master_chris_charger69/charger_shiftdown.wav",
		0.75,
		0.9,
		0.95
	},
	{
		"simulated_vehicles/shelby/shelby_idle.wav",
		"simulated_vehicles/shelby/shelby_low.wav",
		"simulated_vehicles/shelby/shelby_mid.wav",
		"simulated_vehicles/shelby/shelby_revdown.wav",
		"simulated_vehicles/shelby/shelby_second.wav",
		"simulated_vehicles/shelby/shelby_shiftdown.wav",
		0.8,
		1,
		0.85
	},
	{
		"simulated_vehicles/jeep/jeep_idle.wav",
		"simulated_vehicles/jeep/jeep_low.wav",
		"simulated_vehicles/jeep/jeep_mid.wav",
		"simulated_vehicles/jeep/jeep_revdown.wav",
		"simulated_vehicles/jeep/jeep_second.wav",
		"simulated_vehicles/jeep/jeep_second.wav",
		0.9,
		1,
		1
	},
	{
		"simulated_vehicles/v8elite/v8elite_idle.wav",
		"simulated_vehicles/v8elite/v8elite_low.wav",
		"simulated_vehicles/v8elite/v8elite_mid.wav",
		"simulated_vehicles/v8elite/v8elite_revdown.wav",
		"simulated_vehicles/v8elite/v8elite_second.wav",
		"simulated_vehicles/v8elite/v8elite_second.wav",
		0.8,
		1,
		1
	},
	{
		"simulated_vehicles/4banger/4banger_idle.wav",
		"simulated_vehicles/4banger/4banger_low.wav",
		"simulated_vehicles/4banger/4banger_mid.wav",
		"simulated_vehicles/4banger/4banger_low.wav",
		"simulated_vehicles/4banger/4banger_second.wav",
		"simulated_vehicles/4banger/4banger_second.wav",
		0.8,
		0.9,
		1
	},
	{
		"simulated_vehicles/jalopy/jalopy_idle.wav",
		"simulated_vehicles/jalopy/jalopy_low.wav",
		"simulated_vehicles/jalopy/jalopy_mid.wav",
		"simulated_vehicles/jalopy/jalopy_revdown.wav",
		"simulated_vehicles/jalopy/jalopy_second.wav",
		"simulated_vehicles/jalopy/jalopy_shiftdown.wav",
		0.95,
		1.1,
		0.9
	},
	{
		"simulated_vehicles/alfaromeo/alfaromeo_idle.wav",
		"simulated_vehicles/alfaromeo/alfaromeo_low.wav",
		"simulated_vehicles/alfaromeo/alfaromeo_mid.wav",
		"simulated_vehicles/alfaromeo/alfaromeo_low.wav",
		"simulated_vehicles/alfaromeo/alfaromeo_second.wav",
		"simulated_vehicles/alfaromeo/alfaromeo_second.wav",
		0.65,
		0.8,
		1
	},
	{
		"simulated_vehicles/generic1/generic1_idle.wav",
		"simulated_vehicles/generic1/generic1_low.wav",
		"simulated_vehicles/generic1/generic1_mid.wav",
		"simulated_vehicles/generic1/generic1_revdown.wav",
		"simulated_vehicles/generic1/generic1_second.wav",
		"simulated_vehicles/generic1/generic1_second.wav",
		0.8,
		1.1,
		1
	},
	{
		"simulated_vehicles/generic2/generic2_idle.wav",
		"simulated_vehicles/generic2/generic2_low.wav",
		"simulated_vehicles/generic2/generic2_mid.wav",
		"simulated_vehicles/generic2/generic2_revdown.wav",
		"simulated_vehicles/generic2/generic2_second.wav",
		"simulated_vehicles/generic2/generic2_second.wav",
		1,
		1.1,
		1
	},
	{
		"simulated_vehicles/generic3/generic3_idle.wav",
		"simulated_vehicles/generic3/generic3_low.wav",
		"simulated_vehicles/generic3/generic3_mid.wav",
		"simulated_vehicles/generic3/generic3_revdown.wav",
		"simulated_vehicles/generic3/generic3_second.wav",
		"simulated_vehicles/generic3/generic3_second.wav",
		0.9,
		0.9,
		1
	},
	{
		"simulated_vehicles/generic4/generic4_idle.wav",
		"simulated_vehicles/generic4/generic4_low.wav",
		"simulated_vehicles/generic4/generic4_mid.wav",
		"simulated_vehicles/generic4/generic4_revdown.wav",
		"simulated_vehicles/generic4/generic4_gear.wav",
		"simulated_vehicles/generic4/generic4_shiftdown.wav",
		1,
		1.1,
		1
	},
	{
		"simulated_vehicles/generic5/generic5_idle.wav",
		"simulated_vehicles/generic5/generic5_low.wav",
		"simulated_vehicles/generic5/generic5_mid.wav",
		"simulated_vehicles/generic5/generic5_revdown.wav",
		"simulated_vehicles/generic5/generic5_gear.wav",
		"simulated_vehicles/generic5/generic5_gear.wav",
		0.7,
		0.7,
		1
	},
	{
		"simulated_vehicles/gta5_gauntlet/gauntlet_idle.wav",
		"simulated_vehicles/gta5_gauntlet/gauntlet_low.wav",
		"simulated_vehicles/gta5_gauntlet/gauntlet_mid.wav",
		"simulated_vehicles/gta5_gauntlet/gauntlet_revdown.wav",
		"simulated_vehicles/gta5_gauntlet/gauntlet_gear.wav",
		"simulated_vehicles/gta5_gauntlet/gauntlet_gear.wav",
		0.95,
		1.1,
		1
	}
}
