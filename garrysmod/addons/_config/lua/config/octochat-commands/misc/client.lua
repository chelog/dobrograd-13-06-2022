octochat.defineCommand('/advert', {
	aliases = {'/ad'},
})

octochat.defineCommand('/radio', {
	aliases = {'/r'},
})

octochat.defineCommand('/wradio', {
	aliases = {'/wr'},
})

octochat.defineCommand('/yradio', {
	aliases = {'/yr'},
})

octochat.defineCommand('/lradio', {
	aliases = {'/lr'},
})

octochat.defineCommand('/callmed', true)
octochat.defineCommand('/callmech', true)
octochat.defineCommand('/callfire', true)
octochat.defineCommand('/callworker', true)

octochat.defineCommand('/givecert', true)
octochat.defineCommand('/delcert', true)

octochat.defineCommand('/ammo', true)
octochat.defineCommand('/bank', true)
octochat.defineCommand('/getbank', true)
octochat.defineCommand('/time', true)

-- rewards
octochat.defineCommand('/rewards', true)
octochat.defineCommand('/forum', true)

octochat.defineCommand('/title', true)

octochat.defineCommand('/write', true)
octochat.defineCommand('/removewrite', true)
octochat.defineCommand('/removewrites', true)

octochat.defineCommand('/dropweapon', {
	aliases = {'/drop'},
})
octochat.defineCommand('/holsterweapon', {
	aliases = {'/holster'},
})

local function niceTime(time)

	local h, m, s
	h = math.floor(time / 60 / 60)
	m = math.floor(time / 60) % 60
	s = math.floor(time) % 60

	return string.format("%02i:%02i:%02i", h, m, s)

end

local textRules = [[<font=dbg-test.normal>Правила использования команды /advert</font>
Этот чат используется исключительно для рекламы и объявлений, стоимость публикации - 250Р

Реклама или объявления, поданные через этот чат, не могут быть анонимными, являться "слухами", содержать в себе нелегальные новости или услуги, а также любую неролевую информацию

За несоблюдение правил пользования чатом тебе может быть выдано наказание]]

netstream.Hook('octochat.advert', function(text, timeLeft)
	local f = vgui.Create 'DFrame'
	f:SetSize(400, 355)
	f:SetTitle('Отправить рекламу')
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
		netstream.Start('octochat.advert', e:GetValue())
		f:Remove()
	end)
	b:SetTall(27)
	b:SetEnabled(false)

	local function updateName()
		b:SetText('Сообщение можно будет отправить через ' .. niceTime(timeLeft))
	end
	updateName()

	timer.Create('octochat.advert.confirm', 1, 0, function()
		if not IsValid(f) then return timer.Remove('octochat.advert.confirm') end
		timeLeft = timeLeft - 1

		if timeLeft <= 0 then
			timer.Remove('octochat.advert.confirm')
			b:SetEnabled(true)
			b:SetText('Отправить сообщение')
		else
			updateName()
		end
	end)
end)