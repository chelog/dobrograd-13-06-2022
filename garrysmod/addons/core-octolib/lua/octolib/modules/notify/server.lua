octolib.notify.actions = octolib.notify.actions or {}

function octolib.notify.registerActions(id, handlers)
	octolib.notify.actions[id] = handlers
end

local function getActions(t, ply, data)

	local out = {}
	for i, handler in ipairs(octolib.notify.actions[t]) do
		local name, action = handler(ply, data)
		if not name then continue end

		out[i] = { name, action }
	end

	return out

end

local function getClientData(notif)

	local t, date, data = unpack(notif)
	return {
		data.text or '', date or 0,
		octolib.table.map(getActions(t, ply, data), function(v) return v[1] end) -- {[actionID] = actionName}
	}

end

local offlineNotifyQueue = octolib.queue.create(function(data, done)
	local sid, notif = unpack(data)
	octolib.getDBVar(sid, 'notifs')
		:Then(function(notifs)
			notifs = notifs or {}
			notifs[#notifs + 1] = notif
			octolib.setDBVar(sid, 'notifs', notifs)
				:Finally(done)
		end)
		:Catch(function()
			octolib.setDBVar(sid, 'notifs', { notif })
				:Finally(done)
		end)
end)

local function doNotify(ply, sid, type, args)

	if octolib.notify.actions[type] then -- notification with actions
		local data = args[2] or {}
		local notif = { type, os.time(), data }
		if not data.text then data.text = args[1] end

		if IsValid(ply) then
			ply:Notify(args[1])
			netstream.Start(ply, 'octolib-notifs.add', getClientData(notif))
		end

		offlineNotifyQueue:Add({ sid, notif })
		return
	end

	if not isstring(ply) then -- fire'n'forget notification
		if not args[1] then
			-- first argument is message, use _generic type
			args = { type }
			type = nil
		end
		type = type or '_generic'

		netstream.Start(ply, 'octolib.notify', type, unpack(args))
	end

end

function octolib.notify.send(plyOrSid, type, ...)

	type = type or '_generic'
	local args = {...}
	if not plyOrSid then
		return doNotify(nil, sid, type, args)
	end

	local ply, sid = octolib.players.resolve(plyOrSid)

	if not IsValid(ply) then
		octolib.getPlayerOnline(sid, function(serverID)
			if serverID then
				octolib.sendCmd(serverID, 'notifyPlayer', { sid, type, unpack(args) })
			else
				doNotify(ply, sid, type, args)
			end
		end)
	else
		doNotify(ply, sid, type, args)
	end

end

function octolib.notify.sendAll(type, ...)
	octolib.notify.send(nil, type, ...)
end

function octolib.notify.sync(ply)

	local toSend = octolib.table.mapSequential(ply:GetDBVar('notifs') or {}, function(notif) return getClientData(notif) end)
	netstream.Start(ply, 'octolib-notifs.sync', toSend)

end
hook.Add('PlayerFinishedLoading', 'octolib.notify', octolib.notify.sync)

netstream.Listen('octolib-notify.read', function(reply, ply, id, actionID)

	local notifs = ply:GetDBVar('notifs')
	local notif = notifs and notifs[id]
	if not notif then return octolib.notify.sync(ply) end

	local t, date, data = unpack(notif)

	local remove = false
	local actions = getActions(t, ply, data)
	if #actions < 1 then
		remove = true
	else
		local name, action = unpack(actions[actionID])
		if not name then return octolib.notify.sync(ply) end

		remove = action(ply, data)
	end

	if remove then
		table.remove(notifs, id)
	end

	ply:SetDBVar('notifs', notifs)
	reply(remove or false)

end)

hook.Add('octolib.event:notifyPlayer', 'octolib.notify', function(data)
	octolib.notify.send(unpack(data))
end)

local ply = FindMetaTable 'Player'
ply.Notify = octolib.notify.send
