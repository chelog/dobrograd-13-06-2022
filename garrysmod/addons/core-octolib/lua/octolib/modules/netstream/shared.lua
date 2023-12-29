netstream = netstream or {}
netstream.stored = netstream.stored or {}
netstream.cache = netstream.cache or {}

netstream.requestTimeout = 15
netstream.requestCallbacks = netstream.requestCallbacks or {}
netstream.nextReqID = netstream.nextReqID or 0

function netstream.Split(data)
	local index = 1
	local result = {}
	local buffer = {}

	for i = 0, string.len(data) do
		buffer[#buffer + 1] = string.sub(data, i, i)

		if (#buffer == 32768) then
			result[#result + 1] = table.concat(buffer)
				index = index + 1
			buffer = {}
		end
	end

	result[#result + 1] = table.concat(buffer)

	return result
end

function netstream.Hook(name, Callback)
	netstream.stored[name] = Callback
end

function netstream.Listen(name, callback)
	netstream.requestCallbacks[name] = callback
end
