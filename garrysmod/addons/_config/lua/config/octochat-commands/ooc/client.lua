octochat.defineCommand('/ooc', {
	aliases = {'//', '/a'},
	cooldownBypass = 'DBG: Нет ограничения на OOC',
})
octochat.defineCommand('/looc', {
	aliases = {'/'}
})
octochat.defineCommand('/pm', true)
octochat.defineCommand('/demote', true)

local function niceTime(time)

	local h, m, s
	h = math.floor(time / 60 / 60)
	m = math.floor(time / 60) % 60
	s = math.floor(time) % 60

	return string.format("%02i:%02i:%02i", h, m, s)

end

local textRules = [[<font=dbg-test.normal>Правила использования OOC-чата</font>
В глобальный ООС-чат можно писать не чаще одного раза в 30 минут

Его можно использовать только для того, чтобы узнать, закончилась ли с игроком ролевая ситуация, а также статус ролевой ситуации, в которой погиб твой персонаж

Если у тебя имеется какой-либо вопрос, то попробуй обратиться к администрации через @
Когда администраторов нет в игре, ты можешь попробовать найти ответ на свой вопрос с помощью справочного материала по адресу wiki.octothorp.team; чтобы было проще найти что-то конкретное, можно использовать поиск

Нарушение правил использования ООС-чата приведет к длительному муту]]

netstream.Hook('octochat.ooc', function(text, timeLeft)
	local f = vgui.Create 'DFrame'
	f:SetSize(400, 355)
	f:SetTitle('Отправить глобальное ООС-сообщение')
	f:Center()
	f:MakePopup()

	local e = octolib.textEntry(f, 'Текст сообщения')
	e:SetTall(100)
	e:SetDrawLanguageID(false)
	e:SetContentAlignment(7)
	e:SetText(text)
	e:SetMultiline(true)
	e:DockMargin(5,5,5,5)
	e.PaintOffset = 5

	local cont = f:Add 'DScrollPanel'
	cont:Dock(TOP)
	cont:DockMargin(0, 5, 0, 5)
	cont:SetTall(150)
	cont:SetPaintBackground(true)

	local rules = cont:Add 'DMarkup'
	rules:DockMargin(5, 5, 5, 5)
	rules:Dock(TOP)
	rules:SetText(textRules)

	timeLeft = timeLeft or 15
	local b = octolib.button(f, '...', function()
		netstream.Start('octochat.ooc', e:GetValue())
		f:Remove()
	end)
	b:SetTall(27)
	b:SetEnabled(false)

	local function updateName()
		b:SetText('Сообщение можно будет отправить через ' .. niceTime(timeLeft))
	end
	updateName()

	timer.Create('octochat.ooc.confirm', 1, 0, function()
		if not IsValid(f) then return timer.Remove('octochat.ooc.confirm') end
		timeLeft = timeLeft - 1

		if timeLeft <= 0 then
			timer.Remove('octochat.ooc.confirm')
			b:SetEnabled(true)
			b:SetText('Отправить сообщение')
		else
			updateName()
		end
	end)
end)
