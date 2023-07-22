local defaultAnswers = {{'Вариант 1'}, {'Вариант 2'}, {'Вариант 3'}, {'Вариант 4'}}
local defaultQuestion = { question = 'Текст вопроса', data = defaultAnswers }
local hintFormat = 'Чтобы пройти тест, понадобится ответить правильно хотя бы на %d вопрос%s из %d.'

local function buildQuestion(fr, pnl, line, q)

	local lbl = pnl:Add 'DLabelEditable'
	lbl:DockMargin(0, 0, 0, 15)
	lbl:Dock(TOP)
	lbl:SetAutoStretchVertical(true)
	lbl:SetAutoStretch(true)
	lbl:SetWrap(true)
	lbl:SetMouseInputEnabled(true)
	lbl:SetKeyboardInputEnabled(true)
	lbl:SetText(q.question)
	lbl:SetFont('dbg-test.small')
	function lbl:OnLabelTextChanged(txt)
		if q.question ~= txt then
			fr:OnContentChange()
		end
		q.question = txt
		line:SetColumnText(1, txt)
	end

	for i, ans in ipairs(q.data) do
		local cbp = pnl:Add 'DPanel'
		cbp:Dock(TOP)
		cbp:DockMargin(0, 0, 0, 5)
		cbp:SetTall(30)
		cbp:SetPaintBackground(false)
		
		local isCorrect = ans[2]

		local cb = cbp:Add 'DButton'
		cb:DockMargin(0, 0, 10, 0)
		cb:Dock(LEFT)
		cb:SetWide(24)
		cb:SetText('')
		cb:SetPaintBackground(false)
		function cb:DoClick()
			isCorrect = not isCorrect
			self:UpdateValue()
			ans[2] = isCorrect or nil
			fr:OnContentChange()
		end
		function cb:UpdateValue()
			self:SetIcon(isCorrect and 'icon16/tick.png' or 'icon16/cross.png')
		end
		cb:UpdateValue()
	
		local cbl = cbp:Add 'DLabelEditable'
		cbl:Dock(FILL)
		cbl:SetContentAlignment(4)
		cbl:SetWrap(true)
		cbl:SetMouseInputEnabled(true)
		cbl:SetKeyboardInputEnabled(true)
		cbl:SetText(ans[1])
		function cbl:OnLabelTextChanged(txt)
			if ans[1] ~= txt then
				fr:OnContentChange()
			end
			ans[1] = txt
		end
		
	end

end

local function buildCategory(fr, pnl, catID, questions)
	local leftWrap = pnl:Add 'DPanel'
	leftWrap:Dock(FILL)
	leftWrap:DockMargin(0, 0, 5, 0)

	local l = leftWrap:Add 'DListView'
	l:Dock(FILL)
	l:AddColumn('Название')
	l:SetHideHeaders(true)
	l:SetMultiSelect(false)
	pnl.lst = l

	for _, v in ipairs(questions) do
		local line = l:AddLine(v.question)
		line.question = v
	end

	local testPnl = pnl:Add 'DPanel'
	testPnl:Dock(RIGHT)
	testPnl:SetWide(400)
	testPnl:SetPaintBackground(false)
	testPnl:DockPadding(5, 5, 5, 5)

	function l:OnClickLine(line, clear)
		if not clear then return end
		if line.lastClick then
			local fTimeDistance = SysTime() - line.lastClick
			if fTimeDistance < 0.3 then
				return self:DoDoubleClick(line:GetID(), line)
			end
	
		end
		line.lastClick = SysTime()	
	end

	function l:DoDoubleClick(_, line)
		self:ClearSelection()
		line:SetSelected(true)
		testPnl:Clear()
		buildQuestion(fr, testPnl, line, line.question)
	end

	function l:OnRowRightClick(lineID, line)
		local menu = DermaMenu()
			menu:AddOption('Редактировать', function() self:DoDoubleClick(lineID, line) end):SetIcon(octolib.icons.silk16('pencil'))
			menu:AddOption('Удалить', function()
				self:RemoveLine(lineID)
				table.RemoveByValue(fr.cache[catID], line.question)
				if #fr.cache[catID] < 1 then
					fr.cache[catID] = nil
					pnl:DoRemove()
				end
				fr:OnContentChange()
			end):SetIcon(octolib.icons.silk16('cross'))
		menu:Open()
	end

	local createBtn = leftWrap:Add 'DButton'
	createBtn:Dock(BOTTOM)
	createBtn:SetText('Создать')
	createBtn.DoClick = octolib.fStringRequest('Новый вопрос', 'Введи вопрос', 'Текст вопроса', function(str)
		local data = { question = str, data = table.Copy(defaultAnswers) }
		local line = l:AddLine(str)
		line.question = data
		l:ClearSelection()
		l:SelectItem(line)
		fr.cache[catID][#fr.cache[catID] + 1] = data
		fr:OnContentChange()
	end)
end

local function drawBlur(self, w, h)
	draw.RoundedBox(0, 0, 0, w, h, CFG.skinColors.bg60)
end
netstream.Hook('dbg-test.edit', function(data, questionsAmount, required)
	if IsValid(dbgTest.editFr) then
		dbgTest.editFr:Remove()
	end

	local fr = vgui.Create 'DFrame'
	fr:SetSize(600, 500)
	fr:SetTitle('Редактор теста')
	fr:Center()
	fr:MakePopup()

	local cache = table.Copy(data)
	fr.cache = cache
	fr.saved = true
	local qaPnl = octolib.slider(fr, 'Количество пачек вопросов в тесте:', 1, math.huge, 0)
	qaPnl:SetValue(questionsAmount)
	local totalPnl, reqPnl
	function qaPnl:UpdateData()
		local maxBatches = math.huge
		for _, cat in pairs(cache) do
			if next(cat) then
				maxBatches = math.min(maxBatches, table.Count(cat))
			end
		end
		self:SetMax(maxBatches)
		local val = self:GetValue()
		self:SetValue(self:GetMax()) -- update slider pos
		self:SetValue(math.min(val, self:GetMax()))
		if totalPnl then totalPnl:UpdateData() end
	end
	qaPnl:UpdateData()
	function qaPnl:OnValueChanged()
		reqPnl:UpdateData()
	end

	reqPnl = octolib.slider(fr, 'Проходной балл:', 0, math.Round(qaPnl:GetValue()), 0)
	reqPnl:SetValue(required)
	function reqPnl:UpdateData()
		local batches = 0
		for _, cat in pairs(cache) do
			if next(cat) then
				batches = batches + 1
			end
		end
		self:SetMax(batches * math.floor(qaPnl:GetValue()))
		local val = self:GetValue()
		self:SetValue(self:GetMax()) -- update slider pos
		self:SetValue(math.min(val, self:GetMax()))
		totalPnl:UpdateData()
	end
	function reqPnl:OnValueChanged()
		totalPnl:UpdateData()
		if fr.OnChange then fr:OnChange() end -- right after creation, it's not neccessary to enable save button
	end

	totalPnl = octolib.label(fr, '')
	totalPnl:DockMargin(0, 0, 0, 20)
	totalPnl:SetContentAlignment(5)
	function totalPnl:UpdateData()
		self:SetText(hintFormat:format(reqPnl:GetValue(), octolib.string.formatCount(reqPnl:GetValue(), '', 'а', 'ов'), reqPnl:GetMax()))
	end
	reqPnl:UpdateData()

	
	local catsCont = fr:Add 'DPropertySheet'
	catsCont:Dock(FILL)
	
	local btmCont = fr:Add 'DPanel'
	btmCont:Dock(BOTTOM)
	btmCont:SetTall(30)

	local saveBtn = btmCont:Add 'DButton'
	saveBtn:Dock(FILL)
	saveBtn:SetText('Сохранено')
	saveBtn:SetEnabled(false)
	function saveBtn:DoClick()
		netstream.Start('dbg-test.edit', fr.cache, math.Round(qaPnl:GetValue()), math.Round(reqPnl:GetValue()))
		fr.saved = true
		self:SetEnabled(false)
		self:SetText('Сохранено')
	end

	local test = btmCont:Add 'DButton'
	test:Dock(LEFT)
	test:DockMargin(0, 0, 5, 0)
	test:SetText('Пример теста')
	test:SetWide(185)

	function test:DoClick()
		local w = vgui.Create 'DPanel'
		dbgTest.frame = w
		w:Dock(FILL)
		w:DockPadding(30, 20, 30, 20)
		w:MakePopup()
		self:SetEnabled(false)

		local required = math.Round(reqPnl:GetValue())
		local correct
		local function onError(err)
			ErrorNoHaltWithStack(err)
			w:Remove()
			if self:IsValid() then
				self:SetEnabled(true)
			end
		end
		netstream.Request('dbg-test.sample', cache, math.Round(qaPnl:GetValue())):Then(function(data)
			correct = data.answers
			dbgTest.create(data.questions, required, function()
				dbgTest.remove()
				if self:IsValid() then
					self:SetEnabled(true)
				end
			end, function()
				octolib.func.chain({
					function(nxt)
						Derma_Query('Отправляя ответы, ты подтверждаешь, что...\n• Знаешь правила сервера;\n• Осознаешь последствия возможного их нарушения', 'Последнее уточнение', 'ОК', nxt, 'Отмена')
					end,
					function(nxt)
						dbgTest.remove()
						netstream.Request('dbg-test.sampleScore', dbgTest.answers, correct):Then(nxt):Catch(onError)
					end,
					function(nxt, data)
						local scores = octolib.array.map(data.scores, function(score)
							return ('%s%% - %s из %s - %s'):format(math.Round(score[2] / score[3] * 100), score[2], score[3], score[1])
						end)
						Derma_Message(
							('%s\nИтого: %.1f/%d (тест %sпройден)'):format(table.concat(scores, '\n'), data.total, required, data.total < required and 'не ' or ''),
							'Результат',
							'OK')
						if self:IsValid() then
							self:SetEnabled(true)
						end
					end,
				})
			end)
		end):Catch(onError)
		w.Paint = drawBlur
	end

	function fr:OnChange()
		self.saved = false
		saveBtn:SetEnabled(true)
		saveBtn:SetText('Сохранить')
	end

	function fr:OnContentChange()
		self:OnChange()
		qaPnl:UpdateData()
		reqPnl:UpdateData()
	end
	
	local function removeTab(self)
		local items = catsCont:GetItems()
		for i, tab in ipairs(items) do
			if tab.Panel == self then
				table.remove(items, i)
				table.RemoveByValue(catsCont.tabScroller.Panels, tab.Tab)
				tab.Tab:Remove()
				catsCont.tabScroller:InvalidateLayout(true)
				if items[i] then
					catsCont:SetActiveTab(items[i].Tab)
				end
				break
			end
		end
		self:Remove()
	end
	for cat, v in pairs(cache) do
		local pnl = catsCont:Add 'DPanel'
		pnl.DoRemove = removeTab
		buildCategory(fr, pnl, cat, v)
		catsCont:AddSheet(cat, pnl)
	end

	local newCat = catsCont:Add 'DPanel'
	local createCatBtn = newCat:Add 'DButton'
	createCatBtn:Dock(FILL)
	createCatBtn:SetText('Нажми, чтобы создать категорию вопросов')
	function createCatBtn:Paint(w, h)
		derma.SkinHook('Paint', 'Panel', self, w, h)
	end
	createCatBtn:SetContentAlignment(5)
	createCatBtn:SetFont('dbg-test.medium')
	local sheet = catsCont:AddSheet('', newCat, octolib.icons.silk16('plus'))

	function createCatBtn:DoClick()
		Derma_StringRequest('Новая категория', 'Укажи название категории', 'Категория ' .. (table.Count(cache)+1), function(str)
			if cache[str] then return end
			table.remove(catsCont.Items)
			table.remove(catsCont.tabScroller.Panels)
			sheet.Tab:Remove()
			local pnl = catsCont:Add 'DPanel'
			pnl.DoRemove = removeTab
			cache[str] = {table.Copy(defaultQuestion)}
			buildCategory(fr, pnl, str, cache[str])
			catsCont:SetActiveTab(catsCont:AddSheet(str, pnl).Tab)
			sheet = catsCont:AddSheet('', newCat, octolib.icons.silk16('plus'))
			fr:OnContentChange()
		end)
	end

	local oClose = fr.Close
	function fr:Close()
		if not self.saved then
			octolib.confirmDialog(self, 'Сохранить изменения?', function(b)
				self.saved = true
				if b then saveBtn:DoClick() end
				oClose(self)
			end)
		else oClose(self) end
	end

end)