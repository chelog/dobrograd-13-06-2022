octolib.questions.active = octolib.questions.active or {}

function octolib.questions.finish(uid, silent)
	local q = octolib.questions.active[uid]
	if not q then return end
	local yes, no = {}, {}
	for i,v in pairs(q.replies) do
		if v then yes[#yes + 1] = i else no[#no + 1] = i end
	end
	local szY, szN = #yes, #no
	if not silent then
		local suck, err = pcall(function() q.onFinish(szY - szN, szY, szN, yes, no) end)
		if not suck then ErrorNoHalt(err) end
	end
	octolib.questions.active[uid] = nil
	netstream.Start(q.spectators, 'octolib.question.spectateFinish', uid)
	netstream.Start(q.recipients, 'octolib.question.finish', uid)
	timer.Remove('octolib.question.' .. uid)
end

function octolib.questions.start(data)
	if not istable(data) then return end
	if not isstring(data.text) or not isfunction(data.onFinish) then return end
	if IsEntity(data.recipients) then data.recipients = {data.recipients} end
	if data.recipients ~= nil and not istable(data.recipients) then return end

	local uid = octolib.string.uuid()
	octolib.questions.active[uid] = {
		recipients = data.recipients,
		spectators = data.spectators or {},
		onFinish = data.onFinish,
		onReply = data.onReply,
		replies = {},
	}
	if data.spectators then
		netstream.Start(data.spectators, 'octolib.question.spectateStart', uid, data.text, data.left or 'За', data.right or 'Против', data.time or 60, data.sound)
	end
	timer.Simple(0, function()
		netstream.Start(data.recipients, 'octolib.question.start', uid, data.text, data.left or 'За', data.right or 'Против', data.time or 60, data.sound)
	end)
	timer.Create('octolib.question.' .. uid, data.time or 60, 1, function()
		octolib.questions.finish(uid)
	end)

	return uid
end

netstream.Hook('octolib.question.reply', function(ply, uid, reply)
	if not uid then return end
	local q = octolib.questions.active[uid]
	if not q then return ply:Notify('warning', 'Голосование уже завершилось или не существует') end
	if q.replies[ply:SteamID()] ~= nil then
		return ply:Notify('warning', 'Твой голос уже засчитан')
	end
	if q.recipients and not table.HasValue(q.recipients, ply) then
		return ply:Notify('warning', 'Ты не можешь принимать участие в этом голосовании')
	end

	reply = tobool(reply)

	if isfunction(q.onReply) then
		local executed, ansOverride, msg, notifyType = pcall(function() return q.onReply(ply, reply) end)
		if executed then
			if ansOverride ~= nil then reply = tobool(ansOverride) end
			if msg then
				ply:Notify(notifyType or 'rp', msg)
			end
		else ErrorNoHalt(ansOverride) end
	end

	q.replies[ply:SteamID()] = reply

	local yes, no = 0, 0
	for _,v in pairs(q.replies) do
		if v then yes = yes + 1 else no = no + 1 end
	end
	netstream.Start(q.spectators, 'octolib.question.spectateUpdate', uid, yes, no)

	if table.Count(q.replies) == (q.recipients and #q.recipients or player.GetCount()) then
		octolib.questions.finish(uid)
	end
end)
