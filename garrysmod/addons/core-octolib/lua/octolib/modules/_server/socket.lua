require('gwsockets')

local requestTimeout = 15
local MSG_REQUEST = 0
local MSG_REPLY = 1

octolib.metaSocket = octolib.metaSocket or {}
local SocketClient = octolib.metaSocket
SocketClient = SocketClient or {}
SocketClient.__index = SocketClient

function octolib.socket(url, key)

	local inst = GWSockets.createWebSocket(url)
	local client = setmetatable({
		instance = inst,
		url = url,
		key = key or '',
		handlers = {},
		pending = {},
		connected = false,
		nextReqID = 0,
	}, SocketClient)

	function inst:onMessage(data) client:HandleMessage(data) end
	function inst:onConnected()
		self.connected = false
		self:write(key or '')
	end
	function inst:onError(data)
		self.connected = false
		client:HandleError(data)
	end
	function inst:onDisconnected()
		self.connected = false
		client:OnDisconnect()
	end
	client:Listen('_hb', function(reply) reply(true) end)

	return client

end

function SocketClient:Connect()

	self.instance:open()

end

function SocketClient:Disconnect(force)

	if force then
		self.instance:closeNow()
	else
		self.instance:close()
	end

end

function SocketClient:HandleMessage(data)

	if data == 'ok' then
		self.connected = true
		self:OnConnect()
		return
	end

	if self:OnMessage(data) then return end

	local msg = util.JSONToTable(data)
	if not msg then
		print('Unknown socket message: ' .. data)
		return
	end

	if msg[1] == MSG_REQUEST then
		local reqID, name, data = unpack(msg, 2)
		local handler = self.handlers[name]
		if handler then
			local function reply(data)
				self.instance:write(util.TableToJSON({ MSG_REPLY, reqID, data }))
			end
			handler(reply, data)
		end
	elseif msg[1] == MSG_REPLY then
		local reqID, data = unpack(msg, 2)
		local resolve = self.pending[reqID]
		if resolve then resolve(data) end
		self.pending[reqID] = nil
		timer.Remove('socket.req' .. reqID)
	end

end

function SocketClient:Listen(name, callback)

	self.handlers[name] = callback

end

function SocketClient:Request(name, data)

	return util.Promise(function(res, rej)
		local reqID = self.nextReqID
		self.nextReqID = self.nextReqID + 1
		self.instance:write(util.TableToJSON({ MSG_REQUEST, reqID, name, data }))

		self.pending[reqID] = res
		timer.Create('socket.req' .. reqID, requestTimeout, 1, function()
			rej('timeout')
			self.pending[reqID] = nil
		end)
	end)

end

function SocketClient:HandleError(msg)

	self:OnError(msg)

end

function SocketClient:IsConnected()

	return self.instance:isConnected()

end

function SocketClient:Clear()

	return self.instance:clearQueue()

end

function SocketClient:Close(force)

	if force then
		return self.instance:closeNow()
	else
		return self.instance:close()
	end

end

--
-- overridables
--
function SocketClient:OnConnect()
	print('Auth success for ' .. self.url)
end

function SocketClient:OnDisconnect()
	print('Disconnected from ' .. self.url)
end

function SocketClient:OnError(msg)
	print('Error from ' .. self.url .. ': ' .. msg)
end

function SocketClient:OnMessage(msg)
	-- return true to abort default
end
