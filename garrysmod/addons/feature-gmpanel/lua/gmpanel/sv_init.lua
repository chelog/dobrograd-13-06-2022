gmpanel = gmpanel or {}

local permission, permissionGlobal = 'DBG: Панель ивентов', 'DBG: Расширенный доступ к панели ивентов'

function gmpanel.checkPermissions(ply)
	return ply:query(permission) or ply:query(permissionGlobal)
end

function gmpanel.buildTargets(opts)
	local targets = {}
	for _,id in ipairs(opts) do
		local pl = player.GetBySteamID(id)
		if IsValid(pl) then
			targets[#targets + 1] = pl
		end
	end
	return targets
end

local actions = {}

function gmpanel.registerAction(action, callback)
	actions[action] = callback
end

hook.Add('dbg-event.testExecution', 'dbg-event.checkPermissions', function(ply, action)
	if action == 'global' and not ply:query(permissionGlobal) then return false end
	if not ply:query(permission) then return false end
end)

netstream.Hook('dbg-event.execute', function(ply, action, opts)

	local can, msg = hook.Run('dbg-event.testExecution', ply, action, opts)
	if can == false then
		ply:Notify('warning', msg or L.not_have_access)
		return
	end
	local func = actions[action]
	if not func then
		ply:Notify('warning', 'Неизвестный метод')
		return
	end

	if func(opts, ply) == false then return end
	local log = octologs.createLog(octologs.CAT_GMPANEL)
		:Add(octologs.ply(ply), ' performed action on gmpanel: ', octologs.string(action), ', ')
	local players = opts.players
	if players then
		log:Add(octologs.table('players', players), ', ')
		opts.players = nil
	end
	log:Add(octologs.table('data', opts, true)):Save()

end)

netstream.Listen('dbg-event.mapPlayerNames', function(reply, ply, sids)
	if not (istable(sids) and gmpanel.checkPermissions(ply)) then return reply({}) end
	reply(octolib.table.mapSequential(gmpanel.buildTargets(sids), function(pl)
		return pl:Name()
	end))
end)
