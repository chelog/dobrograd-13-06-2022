local plugin = plugin;

plugin:IncludeFile('shared.lua', SERVERGUARD.STATE.SHARED);
plugin:IncludeFile('sh_commands.lua', SERVERGUARD.STATE.SHARED);
plugin:IncludeFile('sh_drp_commands.lua', SERVERGUARD.STATE.SHARED);

-- temp stuff to allow Niteko spawning car seats
local temp = {
	['STEAM_0:1:57045688'] = true,
}

hook.Add('PlayerGiveSWEP', 'dbg.restrictSpawn', function(ply, class, ent)
	return serverguard.player:HasPermission(ply, 'DBG: SpawnSWEP') == true
end)

hook.Add('PlayerSpawnSWEP', 'dbg.restrictSpawn', function(ply, class, ent)
	return serverguard.player:HasPermission(ply, 'DBG: SpawnSWEP') == true
end)

hook.Add('PlayerSpawnNPC', 'dbg.restrictSpawn', function(ply, npc, wep)
	return serverguard.player:HasPermission(ply, 'DBG: SpawnNPC') == true
end)

hook.Add('PlayerSpawnVehicle', 'dbg.restrictSpawn', function(ply, mdl, name, tbl)
	if tbl.Class == 'gmod_sent_vehicle_fphysics_base' then
		return serverguard.player:HasPermission(ply, 'DBG: SpawnSimfphys') == true or ply:IsSuperAdmin()
	end
	return serverguard.player:HasPermission(ply, 'DBG: SpawnVehicle') == true or temp[ply:SteamID()] == true
end)

hook.Add('PlayerSpawnRagdoll', 'dbg.restrictSpawn', function(ply, model)
	return serverguard.player:HasPermission(ply, 'DBG: SpawnRagdoll') == true
end)

local wireClasses, traceData = {}, {
	["AllSolid"] = false,
	["Entity"] = Entity(0),
	["Fraction"] = 0.5,
	["FractionLeftSolid"] = 0,
	["Hit"] = true,
	["HitBox"] = 0,
	["HitGroup"] = 0,
	["HitNoDraw"] = false,
	["HitNonWorld"] = false,
	["HitNormal"] = Vector(0,0,1),
	["HitPos"] = Vector(0,0,0),
	["HitSky"] = false,
	["HitTexture"] = "**displacement**",
	["HitWorld"] = true,
	["MatType"] = 67,
	["Normal"] = Vector(0,0,1),
	["PhysicsBone"] = 0,
	["StartPos"] = Vector(0,0,0),
	["StartSolid"] = false,
	["SurfaceProps"] = 30,
}

hook.Add('PostGamemodeLoaded', 'dbg.restrictSpawn', function()

	for tool, t in pairs(weapons.GetStored('gmod_tool').Tool) do
		if t.WireClass then wireClasses[t.WireClass] = tool end
	end

end)

hook.Add('PlayerSpawnSENT', 'dbg.restrictSpawn', function(ply, class)

	local tool = wireClasses[class]
	if tool then
		local override = hook.Run('CanTool', ply, traceData, tool)
		if override ~= nil then
			return override
		else
			return true
		end
	end

	return serverguard.player:HasPermission(ply, 'DBG: SpawnSENT') == true

end)

local buildTools = {
	ballsocket = true,
	axis = true,
	elastic = true,
	hydraulic = true,
	rope = true,
	winch = true,
	wire_hydraulic = true,
	imgscreen = true,
	-- particlecontrol_builder = true,
}

local storyTools = {
	octo_desc = true,
	octo_trigger = true,
	lookable = true,
}

hook.Add('sg.tool-override', 'os-tools', function(ply, trace, tool, ENT)

	if not IsValid(ply) then return end
	tool = tool or ''
	if buildTools[tool] and ply:GetNetVar('os_build') then return true end
	if storyTools[tool] and ply:GetNetVar('os_story') then return true end

end)

local constraintTools = {
	AdvBallsocket = 'ballsocket',
	AttachParticleControllerBeam = 'particlecontrol',
	Axis = 'axis',
	Ballsocket = 'ballsocket',
	Elastic = 'elastic',
	Hydraulic = 'hydraulic',
	Motor = 'motor',
	Muscle = 'muscle',
	NoCollide = 'nocollide',
	Pulley = 'pulley',
	Rope = 'rope',
	Slider = 'slider',
	Weld = 'weld',
	Winch = 'winch',
}

for id, data in pairs(duplicator.ConstraintType) do
	data.Tool = constraintTools[id]
end

hook.Add('octolib.dbvars-loaded', 'dbg-admin.crimeAndPolice', function(ply)
	local ot, ct = os.time(), CurTime()
	local noCrime, noPolice = ply:GetDBVar('nocrime', 0), ply:GetDBVar('nopolice', 0)

	if noCrime == true then
		ply:SetNetVar('nocrime', true)
	elseif noCrime > ot then
		ply:SetNetVar('nocrime', ct + (noCrime - ot))
	else ply:SetDBVar('nocrime', nil) end

	if noPolice == true then
		ply:SetNetVar('nopolice', true)
	elseif noPolice > ot then
		ply:SetNetVar('nopolice', ct + (noPolice - ot))
	else ply:SetDBVar('nopolice', nil) end

end)
