gameevent.Listen('player_connect')
gameevent.Listen('player_disconnect')

hook.Add('player_connect', 'octologs', function(data)

	if (tonumber(data.bot) == 1) then return end

	local sID
	if octolib.string.isSteamID(data.networkid) then
		sID = data.networkid
	elseif (data.networkid:find('^7656119%d+$')) then
		sID = util.SteamIDFrom64(data.networkid)
	else
		return
	end

	octologs.createLog(octologs.CAT_OTHER)
		:Add('Player connected: ', { data.name, { ply = sID }})
	:Save()

end)

hook.Add('PlayerInitialSpawn', 'octologs', function(ply)

	ply.nextSpawnLog = CurTime() + 3
	octologs.createLog(octologs.CAT_OTHER)
		:Add(octologs.ply(ply, {'wep', 'job'}), ' finished spawning')
	:Save()

end)

hook.Add('player_disconnect', 'octologs', function(data)

	local sID
	if octolib.string.isSteamID(data.networkid) then
		sID = data.networkid
	elseif (data.networkid:find('^7656119%d+$')) then
		sID = util.SteamIDFrom64(data.networkid)
	else
		return
	end

	local ply = player.GetBySteamID(sID)
	if IsValid(ply) then
		octologs.createLog(octologs.CAT_OTHER)
			:Add('Player disconnected: ', octologs.ply(ply), ', ', octologs.string(data.reason))
		:Save()
	else
		octologs.createLog(octologs.CAT_OTHER)
			:Add('Player disconnected: ', { data.name, { ply = sID }}, ', ', octologs.string(data.reason))
		:Save()
	end

end)

hook.Add('PlayerSpawn', 'octologs', function(ply)

	if (ply.nextSpawnLog or 0) < CurTime() then return end
	ply.nextSpawnLog = CurTime() + 3

	octologs.createLog(octologs.CAT_OTHER)
		:Add(octologs.ply(ply, {'wep'}), ' spawned')
	:Save()

end)

hook.Add('OnPlayerChangedTeam', 'octologs', function(ply,before,after)

	octologs.createLog(octologs.CAT_OTHER)
		:Add(octologs.ply(ply), ' changed team: ', octologs.string(team.GetName(before)), ' ➞ ', octologs.string(team.GetName(after)))
	:Save()

end)


--
-- SANDBOX
--

hook.Add('PlayerSpawnedEffect', 'octologs', function(ply, mdl, ent)

	octologs.createLog(octologs.CAT_BUILD)
		:Add(octologs.ply(ply, {'wep','loc','job'}), ' spawned effect: ', octologs.ent(ent))
	:Save()

end)

hook.Add('PlayerSpawnedProp', 'octologs', function(ply, mdl, ent)

	octologs.createLog(octologs.CAT_BUILD)
		:Add(octologs.ply(ply, {'wep','loc','job'}), ' spawned prop: ', octologs.ent(ent))
	:Save()

end)

hook.Add('PlayerSpawnedRagdoll', 'octologs', function(ply, mdl, ent)

	octologs.createLog(octologs.CAT_BUILD)
		:Add(octologs.ply(ply, {'wep','loc','job'}), ' spawned ragdoll: ', octologs.ent(ent))
	:Save()

end)

hook.Add('PlayerSpawnedNPC', 'octologs', function(ply, ent)

	octologs.createLog(octologs.CAT_BUILD)
		:Add(octologs.ply(ply, {'wep','loc','job'}), ' spawned NPC: ', octologs.ent(ent))
	:Save()

end)

hook.Add('PlayerSpawnedSENT', 'octologs', function(ply, ent)

	octologs.createLog(octologs.CAT_BUILD)
		:Add(octologs.ply(ply, {'wep','loc','job'}), ' spawned entity: ', octologs.ent(ent))
	:Save()

end)

hook.Add('PlayerSpawnedSWEP', 'octologs', function(ply, wep)

	octologs.createLog(octologs.CAT_BUILD)
		:Add(octologs.ply(ply, {'wep','loc','job'}), ' spawned weapon: ', octologs.ent(wep))
	:Save()

end)

hook.Add('PlayerSpawnedVehicle', 'octologs', function(ply, veh)

	octologs.createLog(octologs.CAT_BUILD)
		:Add(octologs.ply(ply, {'wep','loc','job'}), ' spawned vehicle: ', octologs.ent(veh))
	:Save()

end)

local dontLogTools = octolib.array.toKeys({ 'remover','precision','material','submaterial','weld','rope','colour','advmat','shadowremover', 'imgscreen' })
hook.Add('CanTool', 'octologs', function(ply, tr, tool)

	if dontLogTools[tool] then return end

	octologs.createLog(octologs.CAT_BUILD)
		:Add(octologs.ply(ply, {'wep','loc','job'}), ' used tool ', octologs.string(tool))
	:Save()

end)

hook.Add('OnEntityCreated', 'dbg-tools.imgscreen', function(ent)
	timer.Simple(0, function()
		if not IsValid(ent) or not ent.imgURL then return end
		local ply = ent:CPPIGetOwner()
		if not IsValid(ply) then return end
		local info = {
			['Размеры'] = ('%s x %s'):format(ent.imgW, ent.imgH),
			['Ссылка'] = ent.imgURL,
			['Цвет'] = ent.imgColor,
		}

		octologs.createLog(octologs.CAT_BUILD)
			:Add(octologs.ply(ply, {'wep','loc','job'}), ' used tool ', octologs.table('imgscreen', info, true))
		:Save()
	end)
end)