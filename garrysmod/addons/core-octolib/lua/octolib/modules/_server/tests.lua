octolib.testSectionMap = {}
octolib.tests = {}

function octolib.registerTests(data, sectionName)
	if not CFG.dev then return end -- save some memory in production

	local children = sectionName and octolib.testSectionMap[sectionName].children or octolib.tests
	if data.children then
		local section = octolib.testSectionMap[data.name]
		if not section then
			section = {
				name = data.name,
				children = {},
			}

			octolib.testSectionMap[section.name] = section
			table.insert(children, section)
		end

		for _, v in ipairs(data.children) do
			octolib.registerTests(v, section.name)
		end
	else
		local test = {
			name = data.name,
			timeout = data.timeout,
			run = data.run,
		}

		local _, oldKey = octolib.table.find(children, function(v)
			return v.name == test.name
		end)
		if oldKey then
			children[oldKey] = test
		else
			table.insert(children, test)
		end

	end
end

function octolib.runTests(callback)
	local curLevel = -1
	local queue = {}

	local function addToQueue(data)
		curLevel = curLevel + 1
		if data.children then
			local sectionLevel = curLevel
			queue[#queue + 1] = function(done)
				TESTER_SOCKET:Request('printSection', {
					name = data.name,
					level = sectionLevel,
				})
				done()
			end

			for _, v in ipairs(data.children) do
				addToQueue(v)
			end
		else
			queue[#queue + 1] = function(done)
				local startTime = SysTime()
				timer.Create('testTimeout', data.timeout or 5, 1, function()
					TESTER_SOCKET:Request('testResult', {
						name = data.name,
						time = SysTime() - startTime,
						error = 'Timeout',
					})
					done()
				end)

				local function completed(error)
					TESTER_SOCKET:Request('testResult', {
						name = data.name,
						time = SysTime() - startTime,
						error = error,
					})
					timer.Remove('testTimeout')
					done()
				end

				-- we want completed to be called on both success and failure
				xpcall(data.run, completed, completed)
			end
		end
		curLevel = curLevel - 1
	end

	for _, v in ipairs(octolib.tests) do
		addToQueue(v)
	end

	local function nextJob()
		local job = table.remove(queue, 1)
		if job then
			job(nextJob)
		else
			callback()
		end
	end
	nextJob()
end

if not CFG.dev or not CFG.keys.services then return end

local errors = {}
hook.Add('octolib.error', 'tester', function(msg, ply)
	if IsValid(ply) then msg = ('[%s | %s]\n'):format(ply:Name(), ply:SteamID()) .. msg end
	errors[#errors + 1] = msg
end)

octolib.registerTests({
	name = 'octolib',
	children = {
		{
			name = 'No startup errors',
			run = function(done)
				if #errors > 0 then
					done(table.concat(errors, '\n\n'))
				else
					done()
				end
			end,
		},
	},
})

local reconnectInterval = 5
local reconnectTimer = 'tester.reconnect'
local shouldLog = true
local uri = system.IsLinux() and 'ws://localhost:8888' or 'ws://my.app:8888'

if TESTER_SOCKET then TESTER_SOCKET:Close() end

TESTER_SOCKET = octolib.socket(uri, CFG.keys.services)
TESTER_SOCKET:Connect()

function TESTER_SOCKET:OnConnect()
	shouldLog = true
	print('Socket connected to server')
	timer.Remove(reconnectTimer)
end

function TESTER_SOCKET:OnDisconnect()
	if shouldLog then
		print('Socket disconnected, retrying every ' .. reconnectInterval .. ' seconds...')
		shouldLog = false
	end

	timer.Create(reconnectTimer, reconnectInterval, 1, function()
		self:Clear()
		self:Connect()
		timer.Remove(reconnectTimer)
	end)
end

function TESTER_SOCKET:OnError(msg)
	-- print('Socket error: ' .. msg)
end

local evalID = 0
TESTER_SOCKET.evalReplies = {}

TESTER_SOCKET:Listen('eval', function(reply, data)
	evalID = evalID + 1

	TESTER_SOCKET.evalReplies[evalID] = function(data)
		reply({ data = data })
		TESTER_SOCKET.evalReplies[evalID] = nil
	end

	local code = ('local reply = TESTER_SOCKET.evalReplies[%s]\n'):format(evalID) .. data.code
	local func = CompileString(code, 'socket', true)
	local ok, returns = xpcall(func, function(err)
		reply({
			error = err .. '\n' .. debug.traceback()
				:gsub('(stack traceback:\n).-\n', '%1')
				:gsub('%[C%]: in function \'xpcall\'.+', ''),
		})
	end)

	if ok and returns ~= nil then
		reply({ data = returns })
	end
end)

TESTER_SOCKET:Listen('runTests', function(reply)
	octolib.runTests(function()
		TESTER_SOCKET:Request('finish')
	end)
	reply()
end)
