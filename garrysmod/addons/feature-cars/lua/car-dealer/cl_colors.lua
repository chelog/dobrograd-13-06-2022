netstream.Hook('car-dealer.firstColor', function(id, colors)
	if IsValid(carDealer.firstColorPanel) then
		carDealer.firstColorPanel:Remove()
	end

	local o, o2 = octolib.overlay(nil, 'DPanel', true)
	o:SetSize(306, 250)
	o2:MakePopup()
	carDealer.firstColorPanel = o

	local lbl = octolib.label(o, 'Поздравляем с покупкой! Этот автомобиль доступен в нескольких цветах. Выбери тот, который подходит тебе больше всего:')
	lbl:DockMargin(10, 10, 10, 10)
	lbl:SetAutoStretchVertical(true)
	lbl:SetMultiline(true)
	lbl:SetWrap(true)

	local grid = o:Add('DIconLayout')
	grid:Dock(FILL)
	grid:DockMargin(10, 5, 10, 0)
	grid:SetSpaceX(10)
	grid:SetSpaceY(10)

	local function paintFunc(self, w, h)
		draw.NoTexture()
		surface.SetDrawColor(self.col.r, self.col.g, self.col.b)
		draw.Circle(w/2, h/2, 32, 64)
	end
	local function clickFunc(self)
		netstream.Start('car-dealer.firstColor', id, self.index)
		o:Remove()
	end

	for i, v in ipairs(colors) do
		local pan = grid:Add('DButton')
		pan:SetSize(64, 64)
		pan:SetText('')
		pan.col = Color(v[2], v[3], v[4])
		pan.index = i
		pan.Paint, pan.DoClick = paintFunc, clickFunc
		pan:AddHint(v[1])
	end

	lbl = octolib.label(o, 'В любой момент ты сможешь перекрасить за деньги автомобиль у механика. Эта покраска бесплатная')
	lbl:Dock(BOTTOM)
	lbl:DockMargin(10, 10, 10, 10)
	lbl:SetMultiline(true)
	lbl:SetWrap(true)
	lbl:SetAutoStretchVertical(true)

end)
