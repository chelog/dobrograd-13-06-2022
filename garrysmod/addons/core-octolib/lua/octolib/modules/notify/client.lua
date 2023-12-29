octolib.notify.types = octolib.notify.types or {
	_generic = octolib.func.zero,
}

octolib.notify.cache = octolib.notify.cache or {}

function octolib.notify.registerType(type, handler)
	if type == '_generic' and not handler then
		handler = octolib.func.zero
	end
	octolib.notify.types[type] = handler
end

function octolib.notify.show(type, ...)
	local data = {...}
	if not data[1] then
		data = {type}
		type = '_generic'
	end
	type = type or '_generic'

	if octolib.notify.types[type] then octolib.notify.types[type](unpack(data))
	else octolib.notify.types._generic(unpack(data)) end
end

netstream.Hook('octolib.notify', octolib.notify.show)

netstream.Hook('octolib-notifs.add', function(notif)
	octolib.notify.cache[#octolib.notify.cache + 1] = notif
	hook.Run('octolib.notify.cacheUpdate', octolib.notify.cache)
end)

netstream.Hook('octolib-notifs.sync', function(notifs)
	octolib.notify.cache = notifs
	hook.Run('octolib.notify.cacheUpdate', octolib.notify.cache)
end)
