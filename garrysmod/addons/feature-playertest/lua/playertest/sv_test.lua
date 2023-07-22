local test = dbgTest or {}
dbgTest = test

test.config = {
	id = 'dbg3',
	attempts = 2,
}

local dbvar = 'quiz_' .. test.config.id

local storageApi = octolib.api({
	url = 'https://dbgtest.octo.gg/api',
	headers = { ['Authorization'] = CFG.keys.test },
})

local function tomorrow()

	local dateTime = os.date('*t', os.time())
	dateTime.hour = 0
	dateTime.min = 0
	dateTime.sec = 0
	return os.time(dateTime) + 60 * 60 * 24

end

function test.getAttempts(ply)

	local data = ply:GetDBVar(dbvar) or {}
	return data[1] or test.config.attempts

end

function test.takeAttempt(ply)

	local data = ply:GetDBVar(dbvar) or {}
	ply:SetDBVar(dbvar, {
		(data[1] or test.config.attempts) - 1,
		tomorrow(),
	})

end

local function playTime(time)
	local h, m, s =
		math.floor(time / 60 / 60),
		math.floor(time / 60) % 60,
		math.floor(time) % 60
	return string.format('%02i:%02i:%02i', h, m, s)
end

function test.saveAttempt(ply, questions, answers, total)
	local length = CurTime() - ply.dbg_playertest.start
	local ptime = playTime(ply:GetTimeTotal())

	local quiz = {}
	for qID, q in ipairs(ply.dbg_playertest.quiz) do
		local ans = {q.question}
		for i = 1, #q.data do
			ans[#ans + 1] = { q.data[i][1], answers[qID][i] and 1 or 0, q.data[i][2] and 1 or 0 }
		end
		quiz[#quiz + 1] = ans
	end
	local sid, playerinfo = ply:SteamID()
	local req = octolib.vars.get('dbgTest.required')
	octolib.func.chain({
		function(nxt)
			octolib.getSteamData({ util.SteamIDTo64(ply:SteamID()) }, nxt)
		end,
		function(nxt, result)
			playerinfo = result[1]
			storageApi:post('/post', {
				user = {
					name = playerinfo.name,
					sid64 = playerinfo.steamid64,
				},
				total = total,
				req = req,
				quiz = quiz,
			}):Then(nxt):Catch(ErrorNoHalt)
		end,
		function(nxt, response)			
			local embed = {
				title = playerinfo.name,
				url = 'https://steamcommunity.com/profiles/' .. playerinfo.steamid64,
				description = 'Игрок ' .. (total >= req and 'прошел' or 'провалил') .. ' тест\nhttps://dbgtest.octo.gg/' .. response.data.key,
				color = total >= req and 0x00ff00 or 0xff0000,
				thumbnail = { url = playerinfo.avatar },
				fields = {
					{
						name = 'SteamID',
						value = sid,
					}, {
						name = 'Набрано баллов',
						value = total..' / '..#questions..' ('..total..' / '..req..')',
					}, {
						name = 'Наигранное время',
						value = ptime,
					}, {
						name = 'Время прохождения',
						value = octolib.time.formatDuration(length),
					},
				},
				footer = {
					text = 'Ссылка с результатами действительна в течение 10 дней',
				}
			}

			if CFG.webhooks.unban then
				octoservices:post('/discord/webhook/' .. CFG.webhooks.unban, {
					embeds = { embed },
				})
			end

		end,
	})

end

function test.reset(steamID)

	octolib.setDBVar(steamID, dbvar, nil)

end

function test.generate(questions, maxInBatch)
	questions = questions or test.questions
	maxInBatch = maxInBatch or octolib.vars.get('dbgTest.maxInBatch')

	local quiz = {}
	local forUs, forThem = {}, {}

	-- create quiz, shuffling questions and answers
	local src = table.Copy(questions)
	for catID, cat in pairs(src) do
		octolib.array.shuffle(cat)
		for i = 1, math.min(maxInBatch, #cat) do
			octolib.array.shuffle(cat[i].data)
			quiz[#quiz + 1] = cat[i]
		end
	end
	octolib.array.shuffle(quiz)

	for qID, q in ipairs(quiz) do
		forThem[qID] = {q.question}
		forUs[qID] = q
		for i = 1, #q.data do
			forThem[qID][i+1] = q.data[i][1] -- send them questions only
		end
	end

	return forUs, forThem

end

function test.spawned(ply)

	local ip = ply:IPAddress():gsub('%:.+', '')
	local ips = ply:GetDBVar('ips') or {}
	if ip ~= '172.18.0.1' and not table.HasValue(ips, ip) then
		ips[#ips + 1] = ip
		while #ips > 3 do table.remove(ips, 1) end

		ply:SetDBVar('ips', ips)
	end

	if CFG.requireLauncher and not ply:GetNetVar('launcherActivated') then
		return
	else
		ply:SetNetVar('launcherActivated', true)
	end

	if CFG.dev and not CFG.testEnabled then
		netstream.Start(ply, 'dbg-test.welcomeScreen')
		return
	end -- no test for dev

	ply:Freeze(true)
	ply:SetNoDraw(true)
	ply:SetNotSolid(true)

	local data = ply:GetDBVar(dbvar) or {}
	if data == true then
		netstream.Start(ply, 'dbg-test.welcomeScreen')
	else
		if data[2] and os.time() > data[2] then
			ply:SetDBVar(dbvar, { test.config.attempts, tomorrow() })
		end
		ply.dbg_playertest = {}
		test.welcome(ply)
	end

end
hook.Add('PlayerFinishedLoading', 'dbg-test', test.spawned)

function test.welcome(ply, showMsg)

	local attempts = test.getAttempts(ply)
	local msg = (attempts == 0 and L.msgTryTomorrow or attempts == test.config.attempts and L.msgWelcome or L.msgTryAgain):format(attempts)
	netstream.Start(ply, 'dbg-test.welcomeScreen', attempts, msg, showMsg)

end

function test.start(ply)

	if ply.dbg_playertest and CurTime() < (ply.dbg_playertest.nextAttempt or 0) then
		ply:Notify('warning', 'Ты уже проходишь тест! Если он не появился, подожди немного')
		return
	end

	local attemptsLeft = test.getAttempts(ply)
	if attemptsLeft <= 0 then
		netstream.Start(ply, 'dbg-test.welcomeScreen', 0, L.msgTryTomorrow, true)
		return
	end
	test.takeAttempt(ply)

	local forUs, forThem = test.generate()
	netstream.Start(ply, 'dbg-test.start', forThem, octolib.vars.get('dbgTest.required'))

	ply.dbg_playertest = ply.dbg_playertest or {}
	ply.dbg_playertest.start = CurTime()
	ply.dbg_playertest.nextAttempt = CurTime() + 20
	ply.dbg_playertest.quiz = forUs

end
netstream.Hook('dbg-test.start', test.start)

function test.calcScore(answers, correct)
	local total, scores = 0, {}
	for qID, q in ipairs(correct) do
		local right, should = 0, 0
		for i = 1, #q.data do
			if q.data[i][2] then
				should = should + 1
				if answers[qID][i] then
					right = right + 1
				end
			elseif answers[qID][i] then
				should = should + 1
			end
		end
		scores[qID] = {q.question, right, should}
		total = total + (right / should)
	end
	return total, scores
end

function test.answer(ply, answers)

	if not ply.dbg_playertest or not ply.dbg_playertest.quiz then
		return test.pass(ply)
	end

	if test.getAttempts(ply) < 0 then
		return test.catchExploit(ply)
	end

	local total, scores = test.calcScore(answers, ply.dbg_playertest.quiz)
	test.saveAttempt(ply, ply.dbg_playertest.quiz, answers, total)
	if total >= octolib.vars.get('dbgTest.required') then
		test.pass(ply, true, scores)
	else
		test.welcome(ply, true)
	end

end
netstream.Hook('dbg-test.answer', test.answer)

function test.catchExploit(ply)

	ply.dbg_playertest.expAtt = (ply.dbg_playertest.expAtt or 0) + 1
	ply:Notify('warning', L.exploits_not_here2)

	if ply.dbg_playertest.expAtt >= 3 then
		ply:Kick(L.exploits_not_here)
	end

end

function test.pass(ply, justPassed, data)

	if ply.passedTest then
		return ply:addExploitAttempt()
	end

	if justPassed then
		ply:SetDBVar(dbvar, true)
	end

	ply.dbg_playertest = nil
	ply.passedTest = true
	netstream.Start(ply, 'dbg-test.answer', data)

	ply:Spawn()
	ply:Freeze(false)
	ply:SetNoDraw(false)
	ply:SetNotSolid(false)
	ply:SetMoveType(MOVETYPE_WALK)

	hook.Run('dbg-test.complete', ply, justPassed, data)
end

netstream.Hook('dbg-flyover.requestPos', function(ply, pos)
	if ply.passedTest then return end
	ply:SetPos(pos)
	ply:Freeze(true)
	ply:SetNoDraw(true)
	ply:SetNotSolid(true)
	ply:SetMoveType(MOVETYPE_NOCLIP)
	-- timer.Create('resetPVS_' .. ply:SteamID(), 5, 1, function()
	-- 	if not IsValid(ply) then return end
	-- 	ply.extendPVS = nil
	-- end)
end)

-- hook.Add('SetupPlayerVisibility', 'dbg-flyover', function(ply)
-- 	if not ply.extendPVS then return end
-- 	AddOriginToPVS(ply.extendPVS)
-- end)
