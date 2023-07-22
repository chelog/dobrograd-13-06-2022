if CFG.disabledModules.rewards then return end

hook.Add('octolib.db.init', 'octolib.rewards', function()
	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS rewards_forum (
			steamID VARCHAR(30) NOT NULL,
			received DATE NOT NULL,
			PRIMARY KEY (steamID)
		)
	]])
end)

local postUrl = 'https://vk.com/octoteam?w=wall-155454901_1667'

local function checkForumReward(ply, handler)

	local family = octolib.table.map(ply:GetDBVar('family', {}), function(sid)
		return '\'' .. octolib.db:escape(sid) .. '\''
	end)
	family[#family + 1] = '\'' .. octolib.db:escape(ply:SteamID()) .. '\''

	octolib.db:RunQuery('SELECT steamID FROM rewards_forum WHERE steamID IN (' .. table.concat(family, ',') .. ')', function(q, st, res)
		handler(istable(res) and res[1])
	end)
end

local function checkVkPostPinned(ply, handler)
	octoservices:get('/vk/pinned/' .. util.SteamIDTo64(ply:SteamID())):Then(function(resp)
		local data = resp and resp.data

		if not data or resp.code == 500 then return handler(false, 'internal') end
		if resp.code == 401 or resp.code == 404 then return handler(false, 'not_attached') end
		if resp.code == 400 then return handler(false, data.error) end
		return handler(data.pinned, not data.pinned and 'wrong_post' or nil)

	end):Catch(function(err)
		ErrorNoHalt(err)
		handler(false, err)
	end)
end

local function notifyAboutRewards(ply, forumID, forumRewardClaimed, vkPinned, vkError)

	if not forumRewardClaimed then
		ply:Notify('warning', ('Форум: %sприкреплен, награда не получена\n'):format(forumID and '' or 'не '),
			'Чтобы получить награду за регистрацию на форуме:\n',
			'1. Зарегистрируйся на форуме и подтверди электронную почту: ', {'https://forum.octothorp.team/'}, '\n',
			'2. Авторизуйся на сайте и зайди в Настройки: ', {'https://octothorp.team/'}, '\n',
			'3. Выбери вкладку "Аккаунт" и нажми "Прикрепить форум"\n',
			'4. Вставь ссылку на свой аккаунт и нажми "Готово"\n',
			'5. Вернись в игру и введи в чат команду /forum')
	else ply:Notify('hint', ('Форум: %sприкреплен, награда получена'):format(forumID and '' or 'не ')) end

	if not vkPinned then
		local title = ('VK: %sприкреплен, награда неактивна (обновляется не чаще 1 раза в 30 минут)\n'):format(vkError == 'not_attached' and 'не ' or '')
		local msg
		if vkError == 'internal' then
			msg = { title, 'Мы не можем проверить, привязан ли твой ВК, из-за внутренней технической ошибки :(' }
		elseif vkError == 'not_attached' then
			msg = {title, 'Чтобы получать бесплатную фишку за каждые полчаса игры, выполни эту инструкцию: ', {'http://vk.cc/86kQOA'}}
		elseif vkError == 15 or vkError == 30 then
			msg = {title, 'Сделай страницу в VK открытой, чтобы мы смогли проверить закрепленный пост. Подробности в этой инструкции: ', {'http://vk.cc/86kQOA'}}
		else
			msg = {title, 'Чтобы получать бесплатную фишку за каждые полчаса игры, сделай репост этой записи себе на страницу и закрепи ее: ', {postUrl}}
		end
		ply:Notify('warning', unpack(msg))
	else ply:Notify('hint', 'VK: прикреплен, награда активна') end
end

octolib.rewardCommands = {}

function octolib.rewardCommands.forum(ply)

	local id = ply:SteamID()
	octolib.func.chain({
		function(nxt)
			checkForumReward(ply, nxt)
		end,
		function(nxt, claimed)
			if not IsValid(ply) then return end
			if claimed then
				return ply:Notify('warning', L.already_reward)
			end
			octoservices:post('/users/search', { steamID = id }):Then(nxt):Catch(ErrorNoHalt)
		end,
		function(nxt, resp)
			if not IsValid(ply) then return end
			local user = resp.data and resp.data[1] or {}
			if not user.forumID then
				return ply:Notify('warning', 'Для этого тебе нужно прикрепить аккаунт форума во вкладке "Аккаунт" настроек на сайте https://octothorp.team/')
			end

			CFG.forumRewardHandler(ply, user, function()
				octolib.db:PrepareQuery([[INSERT INTO rewards_forum (steamID, received) VALUES (?, NOW())]], { id })
			end)
		end,
	})

end

function octolib.rewardCommands.rewards(ply)

	ply:Notify('Собираем данные, секундочку...')
	local forumID, forumRewardClaimed
	octolib.func.chain({
		function(nxt)
			octoservices:post('/users/search', { steamID = ply:SteamID() }):Then(nxt):Catch(ErrorNoHalt)
		end,
		function(nxt, resp)
			if not IsValid(ply) then return end
			local user = resp and resp.data and resp.data[1]
			if not user then
				return ply:Notify('warning', 'Чтобы проверить свои награды, авторизуйся на сайте https://octothorp.team/')
			end
			forumID = user.forumID
			checkForumReward(ply, nxt)
		end,
		function(nxt, claimed)
			if not IsValid(ply) then return end
			forumRewardClaimed = claimed
			checkVkPostPinned(ply, nxt)
		end,
		function(nxt, pinned, error)
			if IsValid(ply) then notifyAboutRewards(ply, forumID, forumRewardClaimed, pinned, error) end
		end,
	})

end

octolib.ptime.createTimer('octolib.rewards', 30, function(ply)
	checkVkPostPinned(ply, function(pinned, error)
		if not IsValid(ply) then return end
		if pinned then
			ply:osAddMoney(1)
			ply:Notify('hint', L.vk_salary)
		end
	end)
end)

hook.Add('PlayerFinishedLoading', 'octolib.rewards', function(ply)

	local forumRewardClaimed
	octolib.func.chain({
		function(nxt)
			timer.Simple(120, nxt)
		end,
		function(nxt)
			if not IsValid(ply) then return end
			checkForumReward(ply, nxt)
		end,
		function(nxt, claimed)
			if not IsValid(ply) then return end
			forumRewardClaimed = true
			checkVkPostPinned(ply, nxt)
		end,
		function(nxt, vkPostPinned)
			if not (forumRewardClaimed and vkPostPinned) and IsValid(ply) then
				ply:Notify('ooc', L.bonus_hint)
			end
		end,
	})

end)
