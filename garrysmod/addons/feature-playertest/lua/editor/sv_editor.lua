hook.Add('octolib.db.init', 'dbg-test.editor', function()
	octolib.db:RunQuery([[CREATE TABLE IF NOT EXISTS `test_questions` (
		`category` TINYTEXT NOT NULL,
		`question` TEXT NOT NULL,
		`data` MEDIUMTEXT NOT NULL
	)]], dbgTest.updateQuestions)
end)

function dbgTest.updateQuestions()
	dbgTest.questions = {}
	octolib.db:RunQuery([[SELECT * FROM `test_questions`]], function(q, st, res)
		if istable(res) then
			local questions = {}
			for _, v in ipairs(res) do
				if not questions[v.category] then questions[v.category] = {} end
				questions[v.category][#questions[v.category] + 1] = v
				v.data = util.JSONToTable(v.data)
				v.category = nil
			end
			dbgTest.questions = questions
		end
	end)
end

local function updateLogs()
	file.CreateDir('test_fallback')
	local logs = file.Find('test_fallback/*.dat', 'DATA')
	local ct = os.time()
	for _, v in ipairs(logs) do
		local fl = 'test_fallback/' .. v
		if ct - file.Time(fl, 'DATA') > 10 * 24 * 60 * 60 then -- 10 days
			file.Delete(fl)
		end
	end
	file.Write('test_fallback/' .. octolib.string.uuid() .. '.dat', pon.encode(dbgTest.questions))
end

netstream.Listen('dbg-test.sample', function(res, ply, questions, maxInBatch)
	if not (ply:query('DBG: Редактировать тест') and istable(questions) and isnumber(maxInBatch)) then
		return
	end
	local us, them = dbgTest.generate(questions, maxInBatch)
	res({
		questions = them,
		answers = us,
	})
end)

netstream.Listen('dbg-test.sampleScore', function(res, ply, answers, correct)
	if not (ply:query('DBG: Редактировать тест') and istable(answers) and istable(correct)) then
		return
	end
	local total, scores = dbgTest.calcScore(answers, correct)
	res({
		total = total,
		scores = scores,
	})
end)

netstream.Hook('dbg-test.edit', function(ply, data, maxInBatch, required)
	if not ply:query('DBG: Редактировать тест') then
		return
	end

	local questions = {}
	local amount = 0
	for catID, catSrc in pairs(data) do
		if not next(catSrc) then return end
		maxInBatch = math.min(maxInBatch, #catSrc)
		amount = amount + 1
		for _, v in ipairs(catSrc) do
			local question = { question = v.question, data = {}, category = catID }
			for i = 1, 4 do
				question.data[i] = { v.data[i][1], tobool(v.data[i][2]) or nil }
			end
			questions[#questions + 1] = question
		end
	end
	required = math.min(required, maxInBatch * amount)
	if required <= 0 or maxInBatch <= 0 then return end

	octolib.func.chain({
		function(nxt)
			octolib.db:RunQuery([[TRUNCATE TABLE `test_questions`]], nxt)
		end,
		function(nxt)
			local str = table.concat(octolib.array.map(questions, function(q)
				return ([[('%s','%s','%s')]]):format(octolib.db:escape(q.question), octolib.db:escape(q.category), octolib.db:escape(util.TableToJSON(q.data)))
			end), ',')
			octolib.db:RunQuery([[INSERT INTO `test_questions` (`question`, `category`, `data`) VALUES ]] .. str, nxt)
		end,
		function(_, q, st, res)
			updateLogs()
			if not st then
				if IsValid(ply) then ply:Notify('warning', 'Произошла ошибка при сохранении') end
			else
				octolib.vars.set('dbgTest.maxInBatch', maxInBatch)
				octolib.vars.set('dbgTest.required', required)
				octolib.sendCmdToOthers('updateTest')
				dbgTest.updateQuestions()
				ply:Notify('hint', 'Сохранено успешно')
				hook.Run('dbg-test.edit', ply)
			end
		end,
	})
end)

octolib.vars.init('dbgTest.maxInBatch', 4)
octolib.vars.init('dbgTest.required', 5)

concommand.Add('dbg_test_edit', function(ply)
	if not IsValid(ply) or not ply:query('DBG: Редактировать тест') then
		return
	end
	netstream.Heavy(ply, 'dbg-test.edit', dbgTest.questions, octolib.vars.get('dbgTest.maxInBatch'), octolib.vars.get('dbgTest.required'))
end)