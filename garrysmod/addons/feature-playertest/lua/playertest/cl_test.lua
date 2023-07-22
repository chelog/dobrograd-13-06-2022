if dbgTest then dbgTest.remove() end

local test = {}
dbgTest = test

local cols = CFG.skinColors

surface.CreateFont('dbg-test.icons', {
	font = 'FontAwesome',
	extended = true,
	size = 24,
	weight = 400,
})

surface.CreateFont('dbg-test.title', {
	font = 'Calibri',
	extended = true,
	size = 52,
	weight = 350,
})

surface.CreateFont('dbg-test.medium', {
	font = 'Calibri',
	extended = true,
	size = 36,
	weight = 350,
})

surface.CreateFont('dbg-test.normal', {
	font = 'Calibri',
	extended = true,
	size = 24,
	weight = 350,
})

surface.CreateFont('dbg-test.small', {
	font = 'Calibri',
	extended = true,
	size = 21,
	weight = 350,
})

local servers = {
	['37.230.137.242:27017'] = {
		name = 'Центральный Доброград',
		desc = [[Самый развитый район, построенный в период бурного экономического развития города. Он размещается возле исторического района и имеет специфическую архитектуру, сочетая высотные здания и живописную загородную часть, в которую входит шахта, озеро, ранчо, элитный жилой район, мотель и трейлерный парк. Является социально-экономическим центром всего города, из-за чего и происходит его название

Благодаря просторной карте автомобильная инфраструктура развита, а слоты для игроков увеличены]],
	},
	['37.230.137.242:27018'] = {
		name = 'Новый Доброград',
		desc = [[С ходом времени Доброград стал расширяться, и у него появился пригород. Новый Доброград – современный район города, расположившийся на обширной территории. Здесь есть районный центр, озеро с загородными коттеджами, а также промышленная зона

Благодаря просторной карте автомобильная инфраструктура развита, а слоты для игроков увеличены]],
	},
-- 	['37.230.137.242:27019'] = {
-- 		name = 'Новый Доброград #2',
-- 		desc = [[Изначально здесь было шахтерское поселение, находящееся вблизи Доброграда, но спустя время из-за бурного роста оно вошло в состав города как новый район. Богатая природными ресурсами, здешняя местность дает мощный толчок развитию различной промышленности

-- Благодаря просторной карте автомобильная инфраструктура развита, а слоты для игроков увеличены. Несмотря на слегка более лояльный тест и отношения к правилам, здесь требуется следовать понятиям ролевой игры]],
-- 	},
	default = {
		name = 'Тестовый Доброград',
		desc = [[Самая новая часть города отдана в руки чудаковатых инженеров, любящих экспериментальные инновации. Здесь редко можно встретить других людей, потому что из-за постоянных изменений опасность для жизни и спокойствия в буквальном смысле поджидает на каждом углу

На этом сервере стоят последние и почти всегда недоделанные обновления, в связи с чем многие вещи еще работают не совсем, как надо. Вход выполняется по вайтлисту, а прогресс не переносится на остальные сервера]],
	},
}

local setupInfo = {}
local nl = string.char(10)
function test.welcomeScreen(attempts, hint, showMsg)

	if not isfunction(octolib.label)  then
		timer.Simple(0.1, function() test.welcomeScreen(attempts, hint, showMsg) end)
		return
	end

	test.remove()

	test.hint = hint
	test.attempts = attempts

	local w = vgui.Create 'DPanel'
	test.frame = w
	w:Dock(LEFT)
	w:DockPadding(30, 20, 30, 20)
	w:SetWide(600)
	w:MakePopup()
	function w:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(cols.bg_d, 250))
	end

	timer.Simple(0.2, test.enableFlyover) -- TODO:
	w.OnRemove = test.disableFlyover

	local server = servers[game.GetIPAddress()] or servers.default

	local cont = w:Add 'DScrollPanel'
	cont:Dock(FILL)

	local title = octolib.label(cont, server.name)
	title:Dock(TOP)
	title:SetContentAlignment(5)
	title:SetTall(50)
	title:SetFont('dbg-test.title')

	local subtitle = octolib.label(cont, ('%s игрок%s'):format(player.GetCount(), octolib.string.formatCount(player.GetCount(), '', 'а', 'ов')))
	subtitle:Dock(TOP)
	subtitle:SetContentAlignment(8)
	subtitle:SetTall(60)
	subtitle:SetFont('dbg-test.medium')
	setupInfo[game.GetIPAddress()] = function(info)
		if not IsValid(subtitle) or not info.players then return end
		subtitle:SetText(('%s игрок%s'):format(#info.players, octolib.string.formatCount(info.players, '', 'а', 'ов')))
	end
	timer.Create('dbg-test.updatePlayerCount', 1, 0, function()
		if not IsValid(subtitle) then
			return timer.Remove('dbg-test.updatePlayerCount')
		end

		subtitle:SetText(('%s игрок%s'):format(player.GetCount(), octolib.string.formatCount(player.GetCount(), '', 'а', 'ов')))
	end)

	local desc = cont:Add 'DMarkup'
	desc:Dock(TOP)
	desc:SetText('<font=dbg-test.normal>' .. server.desc .. '</font>')

	local play = octolib.button(cont, 'Начать игру', function(self)
		if not test.attempts then
			netstream.Start('dbg-test.answer')
			self:SetEnabled(false)
			self:SetText('Загрузка...')
		elseif test.attempts > 0 then
			Derma_Query(test.hint, 'Нужно пройти тест', 'Начать', function()
				netstream.Start('dbg-test.start')
			end, 'Назад')
		elseif test.attempts == 0 then
			Derma_Message(test.hint, 'Эх...', 'Понятно')
		end
	end)
	play:SetFont('dbg-test.medium')
	play:SetTall(45)
	play:DockMargin(150, 30, 150, 0)

	local bp = cont:Add 'DPanel'
	bp:SetPaintBackground(false)
	bp:Dock(TOP)
	bp:SetTall(30)
	bp:DockMargin(150, 10, 150, 0)

	local links = octolib.button(bp, 'Ссылки', function()
		local m = DermaMenu()
		m:AddOption(L.rules_server, function() octoesc.OpenURL('https://wiki.octothorp.team/dobrograd/rules') end)
		m:AddOption(L.forum, function() octoesc.OpenURL('https://forum.octothorp.team') end)
		m:AddOption(L.wiki, function() octoesc.OpenURL('https://wiki.octothorp.team') end)
		m:AddOption(L.we_in_steam, function() octoesc.OpenURL('https://steamcommunity.com/groups/octothorp-team') end)
		m:AddOption(L.we_in_vk, function() octoesc.OpenURL('https://vk.com/octoteam') end)
		m:AddOption(L.our_site, function() octoesc.OpenURL('https://www.octothorp.team') end)
		m:AddOption(L.write_us_in_vk, function() octoesc.OpenURL('https://vk.me/octoteam') end)
		m:Open()
	end)
	links:SetWide(115)
	links:Dock(LEFT)

	local quit = octolib.button(bp, 'Отключиться', function()
		Derma_Query('Ты уверен? Это отсоединит тебя от текущей игры', 'Выйти с сервера',
			'Уйти', function() LocalPlayer():ConCommand('disconnect') end,
		'Остаться')
	end)
	quit:SetWide(115)
	quit:Dock(RIGHT)

	for address, otherServer in pairs(servers) do
		if otherServer ~= server and address ~= 'default' then
			local card = w:Add 'DPanel'
			card:Dock(BOTTOM)
			card:DockMargin(0, 10, 0, 0)
			card:DockPadding(15, 10, 15, 10)
			card:SetTall(80)

			local title = octolib.label(card, otherServer.name)
			title:SetFont('dbg-test.medium')
			title:SetTall(30)

			local progress = card:Add 'DProgressLabel'
			progress:Dock(BOTTOM)
			progress:SetText('Загрузка...')

			local playerCountText = 'Загрузка...'
			local serverStatus
			setupInfo[address] = function(status)
				if not IsValid(title) then return end
				if status then
					status.players = status.players or 0
					playerCountText = ('%s игрок%s'):format(#status.players, octolib.string.formatCount(#status.players, '', 'а', 'ов'))
					serverStatus = status
					progress:SetText(playerCountText .. ' - ' .. status.map)
					progress:SetFraction(math.min(#status.players / status.maxplayers, 1))
				else
					playerCountText = 'Сервер не отвечает'
					serverStatus = 'Не в сети'
					progress:SetText(playerCountText)
					progress:SetFraction(0)
				end
			end

			local join = card:Add 'DButton'
			join:SetText('')
			function join:Paint(w, h)
				if self.Depressed then return draw.RoundedBox(4, 0, 0, w, h, cols.hvr) end
				if self.Hovered then return draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(color_white, 5)) end
			end
			function join:PerformLayout()
				self:SetSize(self:GetParent():GetSize())
			end
			function join:DoClick()
				local popup = octolib.overlay(w, 'DPanel')
				popup:SetSize(570, 450)
				popup:DockPadding(15, 10, 15, 10)

				local title = octolib.label(popup, otherServer.name)
				title:Dock(TOP)
				title:SetContentAlignment(5)
				title:SetTall(50)
				title:SetFont('dbg-test.title')

				local subtitle = octolib.label(popup, playerCountText)
				subtitle:Dock(TOP)
				subtitle:SetContentAlignment(8)
				subtitle:SetTall(60)
				subtitle:SetFont('dbg-test.medium')

				local desc = popup:Add 'DMarkup'
				desc:Dock(TOP)
				desc:SetText('<font=dbg-test.normal>' .. otherServer.desc .. '</font>')

				local play = octolib.button(popup, 'Подключиться', function()
					Derma_Query('Это отключит тебя от текущего сервера', 'Ты уверен?',
						'Продолжить', function() LocalPlayer():ConCommand('connect ' .. address) end,
					'Отмена')
				end)
				play:SetFont('dbg-test.medium')
				play:SetTall(45)
				play:DockMargin(150, 30, 150, 0)

				if serverStatus then
					if isstring(serverStatus) then
						play:SetText(serverStatus)
						play:SetEnabled(false)
					elseif #serverStatus.players >= serverStatus.maxplayers then
						play:SetText('Сервер полон')
						play:SetEnabled(false)
					end
				end
			end
		end
	end

	local othersLabel = octolib.label(w, 'Другие сервера')
	othersLabel:Dock(BOTTOM)
	othersLabel:SetContentAlignment(5)
	othersLabel:SetTall(25)
	othersLabel:SetFont('dbg-test.normal')

	local function fetch()
		octoservices:get('/servers/status'):Then(function(res)
			for _, group in ipairs(res.data or {}) do
				for _, server in ipairs(group.servers or {}) do
					local setup = setupInfo[server.ip]
					if setup then setup(server.status) end
				end
			end
		end)
	end
	if octoservices then
		fetch()
	else
		hook.Add('octoservices.init', 'octolib.test', fetch)
	end

	if showMsg then
		Derma_Message(test.hint, 'Эх...', 'Понятно')
	end

end
netstream.Hook('dbg-test.welcomeScreen', test.welcomeScreen)

function test.intro(toPass)
	local window = vgui.Create 'DFrame'
	window:SetTitle('Памятка')
	window:SetDraggable(false)
	window:ShowCloseButton(false)
	window:SetBackgroundBlur(true)
	window:SetDrawOnTop(true)
	window:SetSize(555, 450)
	
	local timeLeft = 30
	local lbl = window:Add 'DPanel'
	lbl:Dock(TOP)
	lbl:DockMargin(5, 0, 5, 0)
	local txt = L.test_intro1:gsub('*%*(.-)*%*', '<font=DermaDefaultBold>%1</font>'):format(10)
	local mp = markup.Parse(txt, 475)
	function lbl:Paint(w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(255,243,224))
		draw.RoundedBoxEx(8, 0, 0, 55, h, Color(255,183,77), true, false, true)
		draw.SimpleText(utf8.char(0xf071), 'dbg-test.icons', 28, h/2, Color(255,234,202), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		mp:Draw(60, 5)
	end
	
	local description = window:Add 'DLabel'
	description:Dock(TOP)
	description:DockMargin(10, 10, 10, 10)
	description:SetWrap(true)
	description:SetAutoStretchVertical(true)
	description:SetText(L.test_intro2:format(toPass))
	
	local btnPanel = window:Add 'DPanel'
	btnPanel:Dock(TOP)
	btnPanel:SetTall(21)
	btnPanel:SetPaintBackground(false)
	
	local btn = btnPanel:Add 'DButton'
	btn:SetText('Начать (' .. timeLeft .. ')')
	btn:SizeToContents()
	btn:SetTall(21)
	btn:SetWide(btn:GetWide() + 20)
	btn.DoClick = function() window:Close() end
	btn:SetDisabled(true)
	function btn:Think()
		local newX = (self:GetParent():GetWide() - self:GetWide()) / 2
		if newX ~= self:GetX() then
			self:SetX(newX)
			self.Think = nil
		end
	end
	timer.Create('dbg-test.note.begin', 1, 0, function()
		if not btn:IsValid() then
			return timer.Remove('dbg-test.note.begin')
		end
		timeLeft = timeLeft - 1
		if timeLeft <= 0 then
			btn:SetDisabled(false)
			btn:SetText('Начать')
			timer.Remove('dbg-test.note.begin')
		else
			btn:SetText('Начать (' .. timeLeft .. ')')
		end
	end)
	
	local w, h = mp:Size()
	lbl:SetTall(h + 10)
	window:MakePopup()
	window:DoModal()
	window:Center()
	function window:PerformLayout(w, h)
		self:SizeToChildren(false, true)
		self:SetY((ScrH()-self:GetTall())/2)
	end
end

function test.create(quiz, toPass, onCancel, onSubmit)

	test.frame:Clear()
	test.frame.Paint = octolib.func.zero
	test.frame:SetWide(ScrW())

	local f = test.frame:Add 'DPanel'
	f:DockPadding(10, 10, 10, 10)
	f:SetSize(400, 450)
	f:Center()
	function f:PerformLayout()
		self:Center()
	end

	local answers = {}

	local qp = f:Add 'DPanel'
	qp:Dock(FILL)
	qp:SetPaintBackground(false)

	local butFinish, butNext, butPrev
	curQID = 0
	local function changeQuestion(delta)
		qp:Clear()
		curQID = curQID + delta
		local q = quiz[curQID]

		local lbl = qp:Add 'DLabel'
		lbl:DockMargin(0, 0, 0, 15)
		lbl:Dock(TOP)
		lbl:SetAutoStretchVertical(true)
		lbl:SetWrap(true)
		lbl:SetText(('Вопрос %s/%s:' .. nl .. '%s'):format(curQID, #quiz, q[1]))
		lbl:SetFont('dbg-test.small')

		answers[curQID] = answers[curQID] or {}
		for i = 2, #q do
			local curAnswers = answers[curQID]
			curAnswers[i-1] = curAnswers[i-1] or false

			local cbp = qp:Add 'DPanel'
			cbp:Dock(TOP)
			cbp:DockMargin(0, 0, 0, 5)
			cbp:SetTall(30)
			cbp:SetPaintBackground(false)

			local cb = cbp:Add 'DButton'
			cb:DockMargin(0, 0, 10, 0)
			cb:Dock(LEFT)
			cb:SetWide(24)
			cb:SetText('')
			cb:SetIcon(val and 'icon16/tick.png' or 'icon16/cross.png')
			cb:SetPaintBackground(false)
			function cb:DoClick() curAnswers[i-1] = not curAnswers[i-1] self:UpdateValue() end
			function cb:UpdateValue() self:SetIcon(curAnswers[i-1] and 'icon16/tick.png' or 'icon16/cross.png') end
			curAnswers[i-1] = answers[curQID][i-1]
			cb:UpdateValue()

			local cbl = cbp:Add 'DLabel'
			cbl:Dock(FILL)
			cbl:SetContentAlignment(4)
			cbl:SetWrap(true)
			cbl:SetText(q[i])
			cbl:SetMouseInputEnabled(true)
			function cbl:DoClick() cb:DoClick() end
		end

		butNext:SetEnabled(curQID ~= #quiz)
		butPrev:SetEnabled(curQID ~= 1)

		if curQID == #quiz then
			butFinish:SetEnabled(true)
		end
	end

	local bp1 = f:Add 'DPanel'
	bp1:Dock(BOTTOM)
	bp1:DockMargin(0, 5, 0, 0)
	bp1:SetTall(30)
	bp1:SetPaintBackground(false)

	butFinish = octolib.button(bp1, L.answer_hint, onSubmit or octolib.func.zero)
	butFinish:Dock(RIGHT)
	butFinish:SetWide(100)
	butFinish:SetEnabled(false)

	local butExit = octolib.button(bp1, 'Выйти', onCancel or octolib.func.zero)
	butExit:Dock(LEFT)
	butExit:SetWide(83)

	local butRules = octolib.button(bp1, 'Правила', function()
		octoesc.OpenURL('https://wiki.octothorp.team/dobrograd/rules')
	end)
	butRules:Dock(LEFT)
	butRules:DockMargin(5, 0, 5, 0)
	butRules:SetWide(100)

	local butRules = octolib.button(bp1, 'РП-гайд', function()
		octoesc.OpenURL('https://wiki.octothorp.team/ru/dobrograd/info/roleplay')
	end)
	butRules:Dock(FILL)
	butRules:DockMargin(0, 0, 5, 0)
	butRules:SetWide()

	local bp2 = f:Add 'DPanel'
	bp2:Dock(BOTTOM)
	bp2:DockMargin(0, 10, 0, 0)
	bp2:SetTall(30)
	bp2:SetPaintBackground(false)

	butNext = octolib.button(bp2, '>>>', function() changeQuestion(1) end)
	butNext:Dock(RIGHT)
	butNext:SetWide(188)
	butNext:DockMargin(5, 0, 0, 0)

	butPrev = octolib.button(bp2, '<<<', function() changeQuestion(-1) end)
	butPrev:Dock(FILL)

	test.answers = answers
	changeQuestion(1)

	test.intro(toPass)

end

function test.results(resultsTbl, add)
	local window = vgui.Create 'DFrame'
	window:SetTitle(L.test_success2)
	window:SetDraggable(false)
	window:ShowCloseButton(false)
	window:SetBackgroundBlur(true)
	window:SetDrawOnTop(true)

	local lbl = window:Add 'DPanel'
	lbl:Dock(FILL)
	lbl:DockMargin(5, 0, 5, 0)
	local txt = L.test_success:format(table.concat(resultsTbl, nl)) .. (add or '')
	local mp = markup.Parse(txt, ScrW() - 100)
	function lbl:Paint(w, h)
		mp:Draw(0, 0)
	end

	local btnPanel = window:Add 'DPanel'
	btnPanel:SetTall(30)
	btnPanel:SetPaintBackground(false)

	local btn = btnPanel:Add 'DButton'
	btn:SetText(L.test_success3)
	btn:SizeToContents()
	btn:SetTall(20)
	btn:SetWide(btn:GetWide() + 20)
	btn.DoClick = function() window:Close() end
	
	btnPanel:SetWide(btn:GetWide() + 10)

	local w, h = mp:Size()
	window:SetSize(w + 20, h + 25 + 45 + 10)
	btnPanel:Dock(BOTTOM)
	window:Center()
	btn:SetPos((w + 20 - btn:GetWide()) / 2 - 5, 5)

	lbl:StretchToParent(5, 5, 5, 5)

	window:MakePopup()
	window:DoModal()
end

function test.start(quiz, toPass)
	test.create(quiz, toPass, function()
		Derma_Query('Ты уверен? Это отсоединит тебя от текущей игры' .. nl .. 'Твоя попытка будет потеряна', 'Выйти с сервера',
			'Уйти', function() LocalPlayer():ConCommand('disconnect') end,
		'Остаться')
	end, function(self)
		self:SetEnabled(false)
		self:SetText(L.loading)
		netstream.Start('dbg-test.answer', test.answers)
	end)
end
netstream.Hook('dbg-test.start', test.start)

function test.remove()

	if IsValid(test.frame) then
		test.frame:Remove()
	end

end

netstream.Hook('dbg-test.answer', function(results)
	test.remove()
	if results then
		Derma_Query('Отправляя ответы, ты подтверждаешь, что...\n• Знаешь правила сервера;\n• Осознаешь последствия возможного их нарушения', 'Последнее уточнение', 'ОК', function()
			local total = 0
			for i, v in ipairs(results) do
				results[i] = ('%s%% - %s из %s - %s'):format(math.Round(v[2] / v[3] * 100), v[2], v[3], v[1])
				total = total + v[2] / v[3]
			end
			results[#results + 1] = 'Набрано баллов за тест: ' .. total
			test.results(results)
		end)
	end
end)

--
-- FLYOVER
--

local config = {
	rp_eastcoast = {
		{
			start = { Vector(-921, -206, 92), Angle(18, 0, 0), 80 },
			finish = { Vector(967, -84, 92), Angle(14, -21, 0), 80 },
			time = 20,
		},
		{
			start = { Vector(777, -3231, 70), Angle(3, 23, 0), 80 },
			finish = { Vector(1334, -3157, 35), Angle(-1, -12, 0), 54 },
			time = 20,
		},
		{
			start = { Vector(4239, -1503, -20), Angle(-11, 141, 0), 55 },
			finish = { Vector(4739, -1501, -20), Angle(-11, 59, 0), 60 },
			time = 20,
		},
		{
			start = { Vector(-2900, 828, 190), Angle(-18, -35, 0), 70 },
			finish = { Vector(-2131, 832, -116), Angle(4, 40, 0), 80 },
			time = 20,
		},
		{
			start = { Vector(-3530, 2863, 66), Angle(0, -89, 0), 40 },
			finish = { Vector(-3522, 2407, 68), Angle(0, -89, 0), 80 },
			time = 20,
		},
	},
	rp_evocity_dbg = {
		{
			start = { Vector(-9562, -11912, 136), Angle(-9, -162, 0), 80 },
			finish = { Vector(-9569, -12473, 136), Angle(-3, -122, 0), 60 },
			time = 20,
		},
		{
			start = { Vector(-5750, -5584, 1050), Angle(90, -90, 0), 80 },
			finish = { Vector(-5750, -8876, 1050), Angle(90, -90, 0), 80 },
			time = 20,
		},
		{
			start = { Vector(3635, 5023, 127), Angle(-1, 162, 0), 80 },
			finish = { Vector(3658, 5710, 132), Angle(-1, 106, 0), 60 },
			time = 20,
		},
		{
			start = { Vector(-6864, 13700, 232), Angle(0, -170, 0), 80 },
			finish = { Vector(-6302, 13700, 232), Angle(-5, -100, 0), 40 },
			time = 20,
		},
		{
			start = { Vector(658, 4162, 141), Angle(18, -0, 0), 80 },
			finish = { Vector(1219, 4157, 99), Angle(-18, -0, 0), 60 },
			time = 20,
		},
	},
	rp_truenorth = {
		{
			start = { Vector(770, 14699, 180), Angle(-10, -120, 0), 57 },
			finish = { Vector(900, 13600, 180), Angle(-10, -160, 0), 57 },
			time = 20,
		},
		{
			start = { Vector(10582, -10243, 5492), Angle(0, 110, 0), 60 },
			finish = { Vector(10549, -11242, 5491), Angle(1, 168, 0), 60 },
			time = 20,
		},
		{
			start = { Vector(5600, 4450, 100), Angle(-19, -100, 0), 96 },
			finish = { Vector(5600, 5500, 100), Angle(-11, -100, 0), 40 },
			time = 20,
		},
		{
			start = { Vector(10304, 7721, 28), Angle(-10, 23, 0), 60 },
			finish = { Vector(10272, 7019, 28), Angle(-5, -62, 0), 40 },
			time = 20,
		},
		{
			start = { Vector(4903, -2187, 4195), Angle(2, -154, 0), 55 },
			finish = { Vector(6487, -2200, 4561), Angle(-2, -119, 0), 55 },
			time = 20,
		},
	},
	rp_riverden = {
		{
			start = { Vector(-11383, 10269, 42), Angle(-9, 85, 0), 57 },
			finish = { Vector(-12079, 10332, 46), Angle(-9, 62, 0), 42 },
			time = 20,
		},
		{
			start = { Vector(-11546, 4250, -131), Angle(6, -26, 0), 68 },
			finish = { Vector(-11650, 3954, -176), Angle(-3, 31, -0), 55 },
			time = 20,
		},
		{
			start = { Vector(-5261, 7272, 886), Angle(89, -180, 0), 105 },
			finish = { Vector(-5262, 10115, 886), Angle(89, -180, 0), 105 },
			time = 20,
		},
		{
			start = { Vector(6130, 1668, -171), Angle(-6, 5, 0), 65 },
			finish = { Vector(8166, 1489, -174), Angle(0, 7, 0), 60 },
			time = 20,
		},
		{
			start = { Vector(9336, -2742, 694), Angle(-1, -74, 0), 70 },
			finish = { Vector(9585, -3655, 698), Angle(-3, -94, 0), 65 },
			time = 20,
		},
	},
	default = {{
		start = { Vector(), Angle(), 60 },
		finish = { Vector(), Angle(), 60 },
		time = 60,
	}}
}

function dbgTest.enableFlyover()

	local mapData
	for map, data in pairs(config) do if game.GetMap():find(map) then mapData = data break end end
	if not mapData then mapData = config.default end

	local curPartID, startTime, finishTime = 0, 0, 0
	local nextRequestPos = 0
	hook.Add('CalcView', 'dbg-flyover', function(ply, pos, ang, fov)
		local ct = RealTime()
		local curPart = mapData[curPartID]
		if ct > finishTime then
			curPartID = curPartID + 1
			if curPartID > #mapData then curPartID = 1 end

			curPart = mapData[curPartID]
			finishTime = ct + curPart.time
			startTime = ct

			nextRequestPos = 0
		end

		local posStart, angStart, fovStart = unpack(curPart.start)
		local posFinish, angFinish, fovFinish = unpack(curPart.finish)
		local st = (finishTime - ct) / curPart.time -- lerp backwards to simplify math
		pos = LerpVector(st, posFinish, posStart)
		ang = LerpAngle(st, angFinish, angStart)
		fov = Lerp(st, fovFinish, fovStart)

		if ct >= nextRequestPos then
			netstream.Start('dbg-flyover.requestPos', pos)
			nextRequestPos = ct + 3
		end

		return {
			origin = pos,
			angles = ang,
			fov = fov,
			znear = 5,
		}
	end, -5)

	hook.Add('ShouldDrawLocalPlayer', 'dbg-flyover', function()
		return true
	end, -5)

	local colBG = CFG.skinColors.bg
	hook.Add('RenderScreenspaceEffects', 'dbg-flyover', function()

		local colMod = {
			['$pp_colour_addr'] = 0,
			['$pp_colour_addg'] = 0,
			['$pp_colour_addb'] = 0,
			['$pp_colour_mulr'] = 0,
			['$pp_colour_mulg'] = 0,
			['$pp_colour_mulb'] = 0,
			['$pp_colour_brightness'] = -0.15,
			['$pp_colour_contrast'] = 1.5,
			['$pp_colour_colour'] = 0.3,
		}

		DrawColorModify(colMod)

		local ct = RealTime()
		local al = 100 + math.min(math.max(ct - finishTime + 2.1, startTime - ct + 2.1, 0) / 2, 1) * 155

		draw.NoTexture()
		surface.SetDrawColor(colBG.r, colBG.g, colBG.b, al)
		surface.DrawRect(-1, -1, ScrW() + 1, ScrH() + 1)

		return true -- prevent other effects

	end, -5)

	local hide = octolib.array.toKeys { 'CHudGMod', 'CHudCrosshair', 'CHudMenu' }
	hook.Add('HUDShouldDraw', 'dbg-flyover', function(name)
		if hide[name] then return false end
	end, -5)

end

function dbgTest.disableFlyover()
	hook.Remove('CalcView', 'dbg-flyover')
	hook.Remove('RenderScreenspaceEffects', 'dbg-flyover')
	hook.Remove('ShouldDrawLocalPlayer', 'dbg-flyover')
	hook.Remove('HUDShouldDraw', 'dbg-flyover')
end
