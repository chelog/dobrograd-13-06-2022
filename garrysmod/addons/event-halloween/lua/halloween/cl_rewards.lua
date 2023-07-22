local cols = CFG.skinColors
local function paintItem(self, w, h)
	local strokeCol = cols.bg_d

	draw.RoundedBox(4, 0, 0, w, h, strokeCol)
	local bgCol = Color(cols.bg60)
	if self.darker then
		bgCol.r, bgCol.g, bgCol.b = bgCol.r-17, bgCol.g-17, bgCol.b-17
	end
	if self.Depressed then
		bgCol.r, bgCol.g, bgCol.b = bgCol.r-17, bgCol.g-17, bgCol.b-17
	end
	draw.RoundedBox(4, 1, 1, w-2, h-2, bgCol)

	local btm = self.price and 51 or 31
	draw.RoundedBox(0, 1, h-btm, w-2, 1, strokeCol)

	if self.icon then
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(self.icon)
		surface.DrawTexturedRect(w / 2 - 45, 16, 90, 90)
	end

	if self.price then
		draw.DrawText(DarkRP.formatMoney(self.price, ' конфет'), 'dbg-score.small', w-8, h-24, Color(235,235,235), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	surface.SetFont('dbg-score.normal')
	local tw = surface.GetTextSize(self.name)
	local x = 0
	if tw > w-16 and self.Hovered then
		x = (-math.cos((RealTime() - self.animStart) * 1.5) + 1) / 2 * (w-16 - tw)
	end
	draw.DrawText(self.name, 'dbg-score.normal', x + 8, h - btm + 3, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.RoundedBox(0, w-1, h - btm + 1, 1, 45, strokeCol)
	draw.RoundedBox(0, 0, h - btm + 1, 1, 45, strokeCol)
	draw.RoundedBox(0, w-2, h - btm + 1, 1, 45, bgCol)
	draw.RoundedBox(0, 1, h - btm + 1, 1, 45, bgCol)
end

halloween.loadingMat = halloween.loadingMat or Material(octolib.icons.color('jackolantern'))
local function lock()
	halloween.rewardsLocked = true
	local pan = halloween.rewards
	if IsValid(pan) then
		pan.wrap:SetMouseInputEnabled(false)
		pan.PaintOver = function(_, w, h)
			draw.RoundedBoxEx(4, 0, 24, w, h-24, Color(0,0,0,200), false, false, true, true)
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(halloween.loadingMat)
			surface.DrawTexturedRectRotated(w / 2 - 15, h / 2, 64, 64, RealTime() * 100 % 360)
		end
	end
end

local function startAnimation(self)
	self.animStart = RealTime()
end

local function caseClick(self)
	local case = self.data

	local o, o2 = octolib.overlay(nil, 'DPanel')
	o:SetSize(400, 392)
	o2:MakePopup()

	local name = o:Add('DLabel')
	name:Dock(TOP)
	name:DockMargin(3, 3, 3, 3)
	name:SetContentAlignment(5)
	name:SetTall(30)
	name:SetText(case.name)
	name:SetFont('dbg-score.large')

	local descCont = o:Add('DPanel')
	descCont:Dock(TOP)
	descCont:SetTall(100)
	descCont:SetPaintBackground(false)
	descCont:DockMargin(5, 0, 5, 0)

	local icon = descCont:Add('DPanel')
	icon:Dock(LEFT)
	icon:SetWide(100)
	icon.mat = Material(case.icon)
	function icon:Paint(w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(self.mat)
		local sz = math.min(w, h)
		surface.DrawTexturedRect((w-sz) / 2, (h-sz) / 2, sz, sz)
	end

	local desc = descCont:Add('DLabel')
	desc:Dock(FILL)
	desc:DockMargin(5, 0, 0, 0)
	desc:SetText(case.desc or '')
	desc:SetFont('dbg-score.small')
	desc:SetMultiline(true)
	desc:SetWrap(true)

	local itemsCont = o:Add('DPanel')
	itemsCont:Dock(TOP)
	itemsCont:SetTall(192)
	itemsCont:SetPaintBackground(false)
	itemsCont:DockMargin(5, 0, 5, 0)

	local title = itemsCont:Add('DLabel')
	title:Dock(TOP)
	title:SetFont('f4.normal')
	title:SetText('Что я могу положить внутрь:')
	title:SetTall(30)

	local items = itemsCont:Add('DHorizontalScroller')
	items:Dock(FILL)
	items:SetOverlap(-5)

	for _, v in SortedPairsByMemberValue(case.items, 1, true) do
		local caseItem = halloween.caseItems[v[2]]
		if caseItem then
			local item = items:Add('DPanel')
			item:SetWide(116)
			items:AddPanel(item)
			item.Paint = paintItem
			item.name = caseItem.name
			item.icon = Material(caseItem.icon)
			item.OnCursorEntered = startAnimation
		end
	end

	if case.max <= 0 then
		local lbl = octolib.label(o, 'Извини, приятель, не могу продать тебе эту вещь')
		lbl:Dock(BOTTOM)
		lbl:DockMargin(5, 5, 5, 5)
		lbl:SetContentAlignment(5)
		return
	end

	local amount
	local orderButton = octolib.button(o, 'Получить', function()
		local count = math.Round(amount:GetValue())
		Derma_Query(('Ты точно хочешь получить %s x %s за %s?'):format(count, case.name, DarkRP.formatMoney(count * case.price, ' конфет')), 'Подтверждение', 'Да', function()
			netstream.Start('dbg-halloween.claim', halloween.rewards.ent, 'case:' .. case.id, count)
			lock()
			o:Remove()
		end, 'Нет')
	end)
	orderButton:Dock(BOTTOM)

	amount = octolib.slider(o, 'Количество', 1, case.max, 0)
	amount:SetValue(1)
	amount:Dock(BOTTOM)
	amount:DockMargin(10, 0, 0, 0)
end

local function itemClick(self)
	local item = self.data

	local o, o2 = octolib.overlay(nil, 'DPanel')
	o:SetSize(400, 190)
	o2:MakePopup()

	local name = o:Add('DLabel')
	name:Dock(TOP)
	name:DockMargin(3, 3, 3, 3)
	name:SetContentAlignment(5)
	name:SetTall(30)
	name:SetText(item.name)
	name:SetFont('dbg-score.large')

	local descCont = o:Add('DPanel')
	descCont:Dock(TOP)
	descCont:SetTall(100)
	descCont:SetPaintBackground(false)
	descCont:DockMargin(5, 0, 5, 0)

	local icon = descCont:Add('DPanel')
	icon:Dock(LEFT)
	icon:SetWide(100)
	icon.mat = Material(item.icon)
	function icon:Paint(w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(self.mat)
		local sz = math.min(w, h)
		surface.DrawTexturedRect((w-sz) / 2, (h-sz) / 2, sz, sz)
	end

	local desc = descCont:Add('DLabel')
	desc:Dock(FILL)
	desc:DockMargin(5, 0, 0, 0)
	desc:SetText(item.desc or '')
	desc:SetFont('dbg-score.small')
	desc:SetMultiline(true)
	desc:SetWrap(true)

	if item.max <= 0 then
		local lbl = octolib.label(o, 'Извини, приятель, не могу продать тебе эту вещь')
		lbl:Dock(BOTTOM)
		lbl:DockMargin(5, 5, 5, 5)
		lbl:SetContentAlignment(5)
		return
	end

	local amount
	local orderButton = octolib.button(o, 'Получить', function()
		local count = math.Round(amount:GetValue())
		Derma_Query(('Ты точно хочешь получить %s x %s за %s?'):format(count, item.name, DarkRP.formatMoney(count * item.price, ' конфет')), 'Подтверждение', 'Да', function()
			netstream.Start('dbg-halloween.claim', halloween.rewards.ent, item.id, count)
			lock()
			o:Remove()
		end, 'Нет')
	end)
	orderButton:Dock(BOTTOM)

	amount = octolib.slider(o, 'Количество', 1, item.max, 0)
	amount:SetValue(1)
	amount:Dock(BOTTOM)
	amount:DockMargin(10, 0, 0, 0)

end

local function sizeToText(self)
	self:SizeToContentsY(10)
end
local function sortByPriceAndName(a, b)
	if a.price ~= b.price then return a.price < b.price end
	return a.name < b.name
end

function halloween.openRewards(ent, data, unlock)
	if unlock then
		halloween.rewardsLocked = nil
	end
	halloween.caseItems = data.caseItems
	local x, y
	if IsValid(halloween.rewards) then
		x, y = halloween.rewards:GetPos()
		halloween.rewards:Remove()
	end

	local fr = vgui.Create 'DFrame'
	fr:SetTitle('Джек и его лавка')
	fr:SetSize(400, 555)
	if x then
		fr:SetPos(x, y)
	else fr:Center() end
	fr:MakePopup()
	fr:SetSizable(true)
	fr:SetMinWidth(400)
	fr:SetMinHeight(295)
	function fr:OnSizeChanged(w)
		if w ~= 400 then
			self:SetWidth(400)
		end
	end
	fr.ent = ent
	halloween.rewards = fr

	octolib.changeSkinColor(Color(52, 49, 52), Color(222, 132, 38), 0)

	local wrap = fr:Add('DScrollPanel')
	wrap:Dock(FILL)
	fr.wrap = wrap
	if halloween.rewardsLocked then
		lock()
	end

	local lbl = octolib.label(wrap, 'Приве-е-ет! Ты пришел получить от меня подарки за конфеты? Смотри, у меня есть такие коробочки:')
	lbl:SetMultiline(true)
	lbl:SetWrap(true)
	lbl:SetFont('dbg-score.normal')
	lbl.PerformLayout = sizeToText

	local cases = wrap:Add('DIconLayout')
	cases:Dock(TOP)
	cases:SetSpaceX(10)
	cases:SetSpaceY(10)

	table.sort(data.cases, sortByPriceAndName)
	for _, v in ipairs(data.cases) do

		local case = cases:Add('DButton')
		case:SetSize(116, 170)

		case.icon = Material(v.icon)
		case.name = v.name
		case.price = v.price
		case.darker = v.max <= 0
		case.data = v
		case:SetText('')

		case.Paint = paintItem
		case.OnCursorEntered = startAnimation
		case.DoClick = caseClick

	end

	local lbl = octolib.label(wrap, 'Если боишься испытывать удачу и хочешь купить что-то более конкретное, можешь приобрести что-нибудь отсюда:')
	lbl:DockMargin(0, 5, 0, 0)
	lbl:SetMultiline(true)
	lbl:SetWrap(true)
	lbl:SetFont('dbg-score.normal')
	lbl.PerformLayout = sizeToText

	local items = wrap:Add('DIconLayout')
	items:Dock(TOP)
	items:SetSpaceX(10)
	items:SetSpaceY(10)

	table.sort(data.items, sortByPriceAndName)
	for _, v in ipairs(data.items) do

		local item = items:Add('DButton')
		item:SetSize(116, 170)

		item.icon = Material(v.icon)
		item.name = v.name
		item.price = v.price
		item.darker = v.max <= 0
		item.data = v
		item:SetText('')

		item.Paint = paintItem
		item.OnCursorEntered = startAnimation
		item.DoClick = itemClick

	end

	local lbl = octolib.label(wrap, 'Ну а если больше ничего покупать у меня не хочешь, давай мне все свои конфеты, я тебе за них отсыплю денег, и больше мы с тобой не торгуемся')
	lbl:DockMargin(0, 5, 0, 0)
	lbl:SetMultiline(true)
	lbl:SetWrap(true)
	lbl:SetFont('dbg-score.normal')
	lbl.PerformLayout = sizeToText

	local balance = LocalPlayer():GetNetVar('sweets', 0)
	local fancy = octolib.string.separateDigits(balance)
	local btn = octolib.button(wrap, ('Обменять %s %s на %s'):format(fancy, octolib.string.formatCount(balance, 'конфету', 'конфеты', 'конфет'), DarkRP.formatMoney(balance * 65)), function()
		Derma_Query('Ты мне — ВСЕ свои конфеты, я тебе — деньги, и больше я тебе НИЧЕГО НЕ ПРОДАМ. Идет?', 'Конфеты на деньги', 'Да', function()
			netstream.Start('dbg-halloween.flushRewards', ent)
			lock()
		end, 'Нет')
	end)
	btn:SetFont('dbg-score.small')
	btn:DockMargin(0, 0, 0, 5)

	local balWrap = fr:Add('DPanel')
	balWrap:Dock(BOTTOM)
	balWrap:DockMargin(0, 5, 0, 0)
	balWrap:SetTall(27)
	local bal = balWrap:Add('DLabel')
	bal:Dock(FILL)
	bal:SetContentAlignment(5)
	bal:SetFont('f4.normal')
	bal:SetText('Конфет: ' .. fancy)

	function fr:OnClose()
		octolib.changeSkinColor(Color(85,68,85), Color(102,170,170), 0)
	end
end

netstream.Hook('dbg-halloween.openRewards', halloween.openRewards)

netstream.Hook('dbg-halloween.closeRewards', function()
	halloween.rewardsLocked = nil
	local pan = halloween.rewards
	if IsValid(pan) then pan:Remove() end
end)

-- JACK
local function findJack()
	for _, v in ipairs(ents.FindByClass('base_ai')) do
		if v:GetNetVar('Jack') then
			timer.Remove('dbg-halloween.findJack')
			timer.Create('dbg-halloween.updateJack', 5, 0, function()
				if IsValid(v) then v:ResetSequence('idle_all_01')
				else
					timer.Create('dbg-halloween.findJack', 1, 0, findJack)
					timer.Remove('dbg-halloween.updateJack')
				end
			end)
		end
	end
end
timer.Create('dbg-halloween.findJack', 1, 0, findJack)
