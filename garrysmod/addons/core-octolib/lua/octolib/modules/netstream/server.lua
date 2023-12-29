util.AddNetworkString 'NetStreamDS'
util.AddNetworkString 'NetStreamHeavy'

local stored = netstream.stored
local cache = netstream.cache

function netstream.Start(ply, name, ...)
	local recipients = {}
	local bShouldSend = false

	if (type(ply) ~= 'table') then
		if not ply then
			ply = player.GetAll()
		else
			ply = {ply}
		end
	end

	for _, v in ipairs(ply) do
		if (type(v) == 'Player') then
			recipients[#recipients + 1] = v

			bShouldSend = true
		end
	end

	local encodedData = pon.encode({...})

	if (encodedData and #encodedData > 0 and bShouldSend) then
		net.Start('NetStreamDS')
			net.WriteString(name)
			net.WriteUInt(#encodedData, 32)
			net.WriteData(encodedData, #encodedData)
		net.Send(recipients)
	end
end

function netstream.StartPVS(pos, name, ...)
	local rf = RecipientFilter()
	rf:AddPVS(pos)
	netstream.Start(rf:GetPlayers(), name, ...)
end

function netstream.Heavy(ply, name, ...)
	local recipients = {}
	local bShouldSend = false

	if (type(ply) != 'table') then
		if (!ply) then
			ply = player.GetAll()
		else
			ply = {ply}
		end
	end

	for k, v in ipairs(ply) do
		if (type(v) == 'Player') then
			recipients[#recipients + 1] = v

			bShouldSend = true
		end
	end

	local encodedData = pon.encode({...})
	local split = netstream.Split(encodedData)

	if (encodedData and #encodedData > 0 and bShouldSend) then
		for k, v in ipairs(split) do
			net.Start('NetStreamHeavy')
				net.WriteString(name)
				net.WriteUInt(#v, 32)
				net.WriteData(v, #v)
				net.WriteUInt(k, 8)
				net.WriteUInt(#split, 8)
			net.Send(recipients)
		end
	end
end

function netstream.Request(ply, name, ...)
	local args = {...}
	return util.Promise(function(res, rej)
		local reqID = netstream.nextReqID
		netstream.nextReqID = netstream.nextReqID + 1

		local msgName = 'nsr-' .. reqID
		netstream.Hook(msgName, function(_, data)
			netstream.Hook(msgName, nil)
			res(data)
		end)
		netstream.Start(ply, 'nsr', name, reqID, unpack(args))

		timer.Create(msgName, netstream.requestTimeout, 1, function()
			rej('timeout')
			timer.Remove(msgName)
		end)
	end)
end

net.Receive('NetStreamDS', function(_, ply)
	local NS_DS_NAME = net.ReadString()
	local NS_DS_LENGTH = net.ReadUInt(32)
	local NS_DS_DATA = net.ReadData(NS_DS_LENGTH)

	if (NS_DS_NAME and NS_DS_DATA and NS_DS_LENGTH) then
		ply.nsDataStreamName = NS_DS_NAME
		ply.nsDataStreamData = ''

		if (ply.nsDataStreamName and ply.nsDataStreamData) then
			ply.nsDataStreamData = NS_DS_DATA

			if (stored[ply.nsDataStreamName]) then
				local bStatus, value = pcall(pon.decode, ply.nsDataStreamData)

				if (bStatus) then
					stored[ply.nsDataStreamName](ply, unpack(value))
				else
					ErrorNoHalt('NetStream: ' .. NS_DS_NAME .. '\n' .. value .. '\n')
				end
			end

			ply.nsDataStreamName = nil
			ply.nsDataStreamData = nil
		end
	end

	NS_DS_NAME, NS_DS_DATA, NS_DS_LENGTH = nil, nil, nil
end)

net.Receive('NetStreamHeavy', function(_, ply)
	local NS_DS_NAME = net.ReadString()
	local NS_DS_LENGTH = net.ReadUInt(32)
	local NS_DS_DATA = net.ReadData(NS_DS_LENGTH)
	local NS_DS_PIECE = net.ReadUInt(8)
	local NS_DS_TOTAL = net.ReadUInt(8)

	if (NS_DS_NAME and NS_DS_DATA and NS_DS_LENGTH) then
		ply.nsDataStreamName = NS_DS_NAME
		ply.nsDataStreamData = ''

		if not cache[ply.nsDataStreamName] then
			cache[ply.nsDataStreamName] = ''
		end

		if (ply.nsDataStreamName and ply.nsDataStreamData) then
			ply.nsDataStreamData = NS_DS_DATA

			if (NS_DS_PIECE < NS_DS_TOTAL) then
				if (NS_DS_PIECE == 1) then
					cache[ply.nsDataStreamName] = ''
				end

				cache[ply.nsDataStreamName] = cache[ply.nsDataStreamName] .. ply.nsDataStreamData
			else
				cache[ply.nsDataStreamName] = cache[ply.nsDataStreamName] .. ply.nsDataStreamData

				if (stored[ply.nsDataStreamName]) then
					local bStatus, value = pcall(pon.decode, cache[ply.nsDataStreamName])

					if (bStatus) then
						stored[ply.nsDataStreamName](ply, unpack(value))
					else
						ErrorNoHalt('NetStream: ' .. NS_DS_NAME .. '\n' .. value .. '\n')
					end
				end

				cache[ply.nsDataStreamName] = nil
				ply.nsDataStreamName = nil
				ply.nsDataStreamData = nil
			end
		end
	end

	NS_DS_NAME, NS_DS_DATA, NS_DS_LENGTH, NS_DS_PIECE, NS_DS_TOTAL = nil, nil, nil, nil, nil
end)

netstream.Hook('nsr', function(ply, name, reqID, ...)
	local callback = netstream.requestCallbacks[name]
	if not callback then return end

	local reply = function(...)
		netstream.Start(ply, 'nsr-' .. reqID, ...)
	end

	callback(reply, ply, ...)
end)
