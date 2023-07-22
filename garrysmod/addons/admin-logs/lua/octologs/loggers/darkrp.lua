hook.Add('playerArrested', 'octologs', function(ply, time, cop, reason)

	octologs.createLog(octologs.CAT_POLICE)
		:Add(octologs.ply(cop), ' arrested ', octologs.ply(ply, {'loc'}), ': ', octologs.string(reason or 'no reason'))
	:Save()

end)

hook.Add('playerUnArrested', 'octologs', function(ply, cop)

	octologs.createLog(octologs.CAT_POLICE)
		:Add(octologs.ply(cop), ' unarrested ', octologs.ply(ply, {'loc'}))
	:Save()

end)

hook.Add('onDoorRamUsed', 'octologs', function(succ, ply, tr)

	local ent = tr.Entity
	if not IsValid(ent) then return end

	local owner = ent:GetPlayerOwner()
	if owner then
		owner = player.GetBySteamID(owner)
	end

	local log = octologs.createLog(octologs.CAT_POLICE)
		log:Add(octologs.ply(ply, {'loc', 'wep'}), ' rammed ')
		if IsValid(owner) then log:Add(octologs.ply(owner, {'loc', 'wep'}), '\'s ') end
		log:Add(octologs.ent(ent), ', success: ' .. tostring(succ))
	:Save()

end)

hook.Add('onPlayerDemoted', 'octologs', function(demoter, ply, reason)

	octologs.createLog(octologs.CAT_POLICE)
		:Add(octologs.ply(demoter), ' demoted ', octologs.ply(ply), ': ', octologs.string(reason or 'no reason'))
	:Save()

end)

local function estate(ply, estIdx, msg)
	local estData = dbgEstates.getData(estIdx)
	local logEstDat = octologs.table(estData.name or '', {
		id = estIdx,
		pos = estData.doors[1]:GetPos(),
	}, true)

	local logPlyDat = octologs.string(ply)
	if octolib.string.isSteamID(ply) then
		local realPly = player.GetBySteamID(ply)
		if IsValid(realPly) then logPlyDat = octologs.ply(realPly) end
	end

	octologs.createLog(octologs.CAT_PROPERTY)
		:Add(logPlyDat, msg, logEstDat)
	:Save()
end

hook.Add('dbg-estates.unowned', 'octologs', function(ply, estIdx)
	estate(ply, estIdx, ' unowned estate ')
end)

hook.Add('dbg-estates.owned', 'octologs', function(ply, estIdx)
	estate(ply, estIdx, ' owned estate ')
end)

hook.Add('DarkRPGiveLicence', 'octologs', function(cop, ply, reason)

	octologs.createLog(octologs.CAT_POLICE)
		:Add(octologs.ply(cop, {'wep'}), ' gave licence to ', octologs.ply(ply, {'loc', 'wep'}), ': ', octologs.string(reason or '???'))
	:Save()

end)

hook.Add('DarkRPTakeLicence', 'octologs', function(cop, ply)

	octologs.createLog(octologs.CAT_POLICE)
		:Add(octologs.ply(cop, {'wep'}), ' took licence from ', octologs.ply(ply, {'loc', 'wep'}))
	:Save()

end)

hook.Add('addLaw', 'octologs', function(_, law, ply)

	octologs.createLog(octologs.CAT_POLICE)
		:Add(octologs.ply(ply, {'loc', 'wep'}), ' added law: ', octologs.string(law))
	:Save()

end)

hook.Add('removeLaw', 'octologs', function(_, law, ply)

	octologs.createLog(octologs.CAT_POLICE)
		:Add(octologs.ply(ply, {'loc', 'wep'}), ' removed law: ', octologs.string(law))
	:Save()

end)

hook.Add('playerWanted', 'octologs', function(ply, cop, reason)

	octologs.createLog(octologs.CAT_POLICE)
		:Add(octologs.ply(cop, {'loc', 'wep'}), ' set wanted ', octologs.ply(ply, {'loc', 'wep'}), ': ', octologs.string(reason or 'no reason'))
	:Save()

end)

hook.Add('playerUnWanted', 'octologs', function(ply, cop, reason)

	octologs.createLog(octologs.CAT_POLICE)
		:Add(octologs.ply(cop, {'loc', 'wep'}), ' set unwanted ', octologs.ply(ply, {'loc', 'wep'}), ': ', octologs.string(reason or 'no reason'))
	:Save()

end)

hook.Add('playerWarranted', 'octologs', function(ply, cop, reason)

	octologs.createLog(octologs.CAT_POLICE)
		:Add(octologs.ply(cop), ' warranted ', octologs.ply(ply), ': ', octologs.string(reason or 'no reason'))
	:Save()

end)

hook.Add('playerUnWarranted', 'octologs', function(ply, cop)

	octologs.createLog(octologs.CAT_POLICE)
		:Add(octologs.ply(cop), ' unwarranted ', octologs.ply(ply))
	:Save()

end)

hook.Add('fspectate.start', 'octologs', function(ply, target)

	local log = octologs.createLog(octologs.CAT_ADMIN)
		:Add(octologs.ply(ply), ' started spectating')
	if IsValid(target) then log:Add(' ', octologs.ply(target)) end
	log:Save()

end)

hook.Add('fspectate.end', 'octologs', function(ply)

	octologs.createLog(octologs.CAT_ADMIN)
		:Add(octologs.ply(ply), ' stopped spectating')
	:Save()

end)
