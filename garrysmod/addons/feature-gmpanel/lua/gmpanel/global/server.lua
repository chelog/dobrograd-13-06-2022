local callsCommands = octolib.array.toKeys {
	'/sms',
	'/med',
	'/callmech',
	'/callfire',
	'/callworker',
	'/calltaxi',
}

local data = {
	karma = true,
	inventories = true,
	storages = true,
	ooc = true,
	fogdef = true,
	radio = true,
	ems = true,
	calls = true,
	sms = true,
	advert = true,
}

local function toVector(col)
	return Vector(col.r / 255, col.g / 255, col.b / 255)
end

local function copy(tbl)
	if tbl.karma ~= nil then data.karma = tbl.karma data.respawn = nil end
	if tbl.respawn ~= nil then data.respawn = tbl.respawn end
	if tbl.inventories ~= nil then data.inventories = tbl.inventories end
	if tbl.storages ~= nil then data.storages = tbl.storages end
	if tbl.fogdef ~= nil then
		data.fogdef = tbl.fogdef
		if not tbl.fogdef then
			data.fogcolor = toVector(tbl.fogcolor)
			data.fogdst = tbl.fogdst
		end
	end
	if tbl.ooc ~= nil then data.ooc = tbl.ooc end
	if tbl.radio ~= nil then data.radio = tbl.radio end
	if tbl.ems ~= nil then data.ems = tbl.ems end
	if tbl.calls ~= nil then data.calls = tbl.calls end
	if tbl.sms ~= nil then data.sms = tbl.sms end
	if tbl.advert ~= nil then data.advert = tbl.advert end
end

local function save(ply, opts)
	if opts.fogdef ~= nil then
		ply:Notify('Настройки тумана применяются до минуты')
	end

	if opts.storages == false then
		ply:Notify('Удаляем все хранилища')
		for i, v in ipairs(ents.FindByClass('octoinv_storage')) do v:Remove() end
	end

	if opts.inventories == false and data.inventories then
		opts.inventories = true
		ply:Notify('Сохраняем инвентари игроков')
		octolib.func.throttle(player.GetAll(), 10, 0.1, function(ply)
			data.inventories = true
			ply:SaveInventory()
			data.inventories = false
			ply:ImportInventory(octoinv.defaultInventory)
			ply:GetInventory():AddContainer('_hand', octoinv.defaultHand):QueueSync()
			data.inventories = true
		end):Then(function()
			data.inventories = false
			ply:Notify('Инвентари игроков сохранены')
		end)
	end

	if opts.inventories and data.inventories == false then
		ply:Notify('Сохраняем инвентари игроков')
		octolib.func.throttle(player.GetAll(), 10, 0.1, function(ply)
			data.inventories = true
			ply:LoadInventory()
			ply:GetInventory():AddContainer('_hand', octoinv.defaultHand):QueueSync()
			data.inventories = false
		end):Then(function()
			ply:Notify('Инвентари игроков загружены')
			data.inventories = true
		end)
	end

	copy(opts)
end

local function fetch(ply)
	netstream.Start(ply, 'dbg-event.global.fetch', data)
end

gmpanel.registerAction('global', function(opts, ply)
	local cmd = opts.command
	if not cmd then return end
	if cmd == 'save' then save(ply, opts)
	elseif cmd == 'fetch' then fetch(ply) end
end)

hook.Add('PlayerCanOOC', 'dbg-event.global.ooc', function(ply)
	if ply:Team() == TEAM_ADMIN then return end
	if data.ooc == false then return false, L.config_disabled:format('OOC', '') end
end)

hook.Add('octoinv.overrideStorages', 'dbg-event.global', function(ply)
	if ply:Team() == TEAM_ADMIN then return end
	if data.storages == false then return false end
end)

hook.Add('dbg-ghosts.overrideTime', 'dbg-event.global', function(ply)
	if data.karma == false then return data.respawn or 0 end
end)

hook.Add('octoinv.overrideInventories', 'dbg-event.global', function()
	if data.inventories == false then return false end
end)

hook.Add('dbg-fog.update', 'dbg-event.global', function(col, dist, dist2)
	if data.fogdef then return end
	return data.fogcolor, data.fogdst + 200, data.fogdst
end)

hook.Add('dbg-karma.override', 'dbg-event.global', function(ply)
	if data.karma == false then return false end
	if ply.karmaDisabled then return false end
end)

hook.Add('dbg-talkie.canSpeak', 'dbg-event.global', function()
	if data.radio == false then return false end
end)

hook.Add('octochat.canExecute', 'dbg-event.global', function(ply, cmd)
	if data.calls == false and callsCommands[cmd] then return false end
	if data.sms == false and cmd == '/sms' then return false end
	if data.advert == false and (cmd == '/advert' or cmd == '/ad') then return false end
end)

hook.Add('dbg.canCallEMS', 'dbg-event.global', function()
	if data.ems == false then return false end
end)
