local stored = netstream.stored
local cache = netstream.cache

function netstream.Start(name, ...)
	local encodedData = pon.encode({...})

	if (encodedData and #encodedData > 0) then
		net.Start('NetStreamDS')
			net.WriteString(name)
			net.WriteUInt(#encodedData, 32)
			net.WriteData(encodedData, #encodedData)
		net.SendToServer()
	end
end

function netstream.Heavy(name, ...)
	local dataTable = {...}
	local encodedData = pon.encode(dataTable)
	local split = netstream.Split(encodedData)

	if (encodedData and #encodedData > 0) then
		for k, v in ipairs(split) do
			net.Start('NetStreamHeavy')
				net.WriteString(name)
				net.WriteUInt(#v, 32)
				net.WriteData(v, #v)
				net.WriteUInt(k, 8)
				net.WriteUInt(#split, 8)
			net.SendToServer()
		end
	end
end

function netstream.Request(name, ...)
	local args = {...}
	return util.Promise(function(res, rej)
		local reqID = netstream.nextReqID
		netstream.nextReqID = netstream.nextReqID + 1

		local msgName = 'nsr-' .. reqID
		netstream.Hook(msgName, function(data)
			netstream.Hook(msgName, nil)
			res(data)
		end)
		netstream.Start('nsr', name, reqID, unpack(args))

		timer.Create(msgName, netstream.requestTimeout, 1, function()
			rej('timeout')
			netstream.Hook(msgName, nil)
			timer.Remove(msgName)
		end)
	end)
end

net.Receive('NetStreamDS', function(_)
	local NS_DS_NAME = net.ReadString()
	local NS_DS_LENGTH = net.ReadUInt(32)
	local NS_DS_DATA = net.ReadData(NS_DS_LENGTH)

	if NS_DS_NAME and NS_DS_DATA and NS_DS_LENGTH and stored[NS_DS_NAME] then
		local bStatus, value = pcall(pon.decode, NS_DS_DATA)

		if (bStatus) then
			stored[NS_DS_NAME](unpack(value))
		else
			ErrorNoHalt('NetStream: ' .. NS_DS_NAME .. '\n' .. value .. '\n')
		end
	end

	NS_DS_NAME, NS_DS_DATA, NS_DS_LENGTH = nil, nil, nil
end)

net.Receive('NetStreamHeavy', function(_)
	local NS_DS_NAME = net.ReadString()
	local NS_DS_LENGTH = net.ReadUInt(32)
	local NS_DS_DATA = net.ReadData(NS_DS_LENGTH)
	local NS_DS_PIECE = net.ReadUInt(8)
	local NS_DS_TOTAL = net.ReadUInt(8)

	if not cache[NS_DS_NAME] then
		cache[NS_DS_NAME] = ''
	end

	if (NS_DS_NAME and NS_DS_DATA and NS_DS_LENGTH) then
		if (NS_DS_PIECE < NS_DS_TOTAL) then
			if (NS_DS_PIECE == 1) then
				cache[NS_DS_NAME] = ''
			end

			cache[NS_DS_NAME] = cache[NS_DS_NAME] .. NS_DS_DATA
		else
			cache[NS_DS_NAME] = cache[NS_DS_NAME] .. NS_DS_DATA

			if (stored[NS_DS_NAME]) then
				local bStatus, value = pcall(pon.decode, cache[NS_DS_NAME])

				if (bStatus) then
					stored[NS_DS_NAME](unpack(value))
				else
					ErrorNoHalt('NetStream Heavy: ' .. NS_DS_NAME .. '\n' .. value .. '\n')
				end

				cache[NS_DS_NAME] = nil
			end
		end
	end

	NS_DS_NAME, NS_DS_DATA, NS_DS_LENGTH, NS_DS_PIECE, NS_DS_TOTAL = nil, nil, nil, nil, nil
end)

netstream.Hook('nsr', function(name, reqID, ...)
	local callback = netstream.requestCallbacks[name]
	if not callback then return end

	local reply = function(...)
		netstream.Start('nsr-' .. reqID, ...)
	end

	callback(reply, ...)
end)
