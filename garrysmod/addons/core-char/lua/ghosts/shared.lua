octodeath = octodeath or {}
octodeath.config = {
	spawnTime = 5 * 60, -- time (s) after death to spawn (default: 10 minutes)
	ghostTime = 5, -- time (s) after death to spawn as ghost (default: 5 seconds)
	ragdollsPerPlayer = 1, -- max death ragdolls per one player (default: 1)
	ragdollsPerServer = 8, -- max death ragdolls per server (default: 8)
	fadeOutDeath = 1, -- time (ms) how long screen fades out after death (default: 1)
	fadeInGhost = 4, -- time (ms) how long screen fades in after death (default: 4)
	fadeOutGhost = 0.2, -- time (ms) how long screen fades out before spawn (default: 0.2)
	fadeInSpawn = 4, -- time (ms) how long screen fades in after spawn (default: 4)
	minCorpseTime = 20 * 60,
}

local classes = {
	prop_physics = true,
	prop_physics_multiplayer = true,
	prop_dynamic = true,
	prop_static = true,
	func_door = true,
	func_lookdoor = true,
	func_door_rotating = true,
	prop_door_rotating = true,
	prop_ragdoll = true,
	--func_movelinear = true,
	func_breakable = true,
	func_physbox = true,
	func_breakable_surf = true,
	extended_money_printer = true,
	standard_money_printer = true,
	printer_battery = true,
	spawned_shipment = true,
	itemstore_bag = true,
	itemstore_box_large = true,
	itemstore_box_small = true,
	itemstore_briefcase = true,
	itemstore_suitcase_large = true,
	itemstore_suitcase_small = true,
	m9k_css_thrown_knife = true,
	gmod_wire_wheel = true,
	gmod_sent_vehicle_fphysics_base = true,
	gmod_sent_vehicle_fphysics_wheel = true,
	ent_dbg_radio = true,
	ent_dbg_grenade_gas = true,
	ent_dbg_grenade_shock = true,
	ent_dbg_grenade_air = true,
	ent_dbg_grenade_frag = true,
	ent_dbg_grenade_smoke = true,
	ent_dbg_petard = true,
	dbg_jobs_package = true,
	letter = true,
	keypad = true,
}

local function handleCollide( ent1, ent2 )
	-- disable collision between ghosts and players
	if ent1:IsPlayer() and ent2:IsPlayer() then
		if ent1:GetNetVar('Ghost') or ent2:GetNetVar('Ghost') then
			return false
		end
	elseif ent1:IsPlayer() and ent1:GetNetVar('Ghost') then
		return not (classes[ ent2:GetClass() ] or ent2:GetClass():StartWith('octoinv_'))
	elseif ent2:IsPlayer() and ent2:GetNetVar('Ghost') then
		return not (classes[ ent1:GetClass() ] or ent1:GetClass():StartWith('octoinv_'))
	end
end
hook.Add('ShouldCollide', 'GhostCollisions', handleCollide)

hook.Add('PlayerFootstep', 'GhostsMakeNoSound', function(ply)
	if ply:GetNetVar('Ghost') then return true end
end)

hook.Add('EntityEmitSound', 'ghosts', function(data)
	local ent = data.Entity
	if IsValid(ent) and ent:IsPlayer() and ent:GetNetVar('Ghost') then return false end
end)

hook.Add('Think', 'toolgun-nosound', function()

	hook.Remove('Think', 'toolgun-nosound')
	weapons.GetStored('gmod_tool').ShootSound = ''

end)

local PM = FindMetaTable 'Player'

function PM:IsGhost()
	return self:GetNetVar('Ghost', false)
end
