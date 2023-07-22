local function category(cont, name)
	local cat = cont:Add('DCollapsibleCategory')
	cat:Dock(TOP)
	cat:SetTall(100)
	cat:SetExpanded(0)
	cat:SetLabel(name)
	local layout = vgui.Create('DListLayout')
	layout:SetSize(100, 100)
	layout:DockPadding(5, 5, 5, 5)
	layout:SetPaintBackground(true)
	cat:SetContents(layout)
	return cat, layout
end

local function point(cont, title, pr)

	local wrap = cont:Add('DPanel')
	wrap:Dock(TOP)
	wrap:SetTall(30)
	wrap:SetDrawBackground(false)

	local key = wrap:Add('DLabel')
	key:Dock(LEFT)
	key:SetFont('f4.normal')
	key:SetText(title)
	key:SizeToContentsX()

	local value = wrap:Add('DLabel')
	value:Dock(FILL)
	value:SetFont('f4.normal')
	value:SetText(DarkRP.formatMoney(pr or 0))
	value:SetContentAlignment(6)
end

local function openFrame(data)

	if not octolib.label then
		timer.Simple(1, function()
			openFrame(data)
		end)
		return
	end

	local fr = vgui.Create('DFrame')
	fr:SetSize(400, 600)
	fr:SetTitle('Новый автопарк')
	fr:Center()
	fr:MakePopup()
	fr.btnClose:SetVisible(false)
	function fr:OnClose()
		netstream.Start('cd.refundOld')
	end

	fr:SetSizable(true)
	fr:SetMinHeight(250)
	function fr:OnSizeChanged(w, h)
		if w ~= 400 then
			self:SetWide(400)
		end
	end

	local e = octolib.label(fr, 'Привет!')
	e:DockMargin(5, 0, 0, 0)
	e:SetFont('f4.normal')
	e:SetTall(35)

	local e = octolib.label(fr, [[Привет! У нас обновился автопарк, и у тебя в гараже остались старые автомобили. Они будут проданы, а аксессуары возвращены через магазин. Вот подробная информация:]])
	e:SetWrap(true)
	e:SetMultiline(true)
	e:SetTall(70)
	e:DockMargin(5,0,5,0)

	local scr = fr:Add('DScrollPanel')
	scr:Dock(FILL)
	scr:DockMargin(0, 5, 0, 5)

	local total, sum, cat, layout = 0, 0
	for _, pt in ipairs(data) do

		if not pt[1] then
			local div = layout:Add('DVerticalDivider')
			div:Dock(TOP)
			div:DockMargin(0, 2, 0, 2)
			div:SetTall(2)
			function div:Paint(w, h)
				local pos = 0
				local seg = w * 0.0125
				while pos < w do
					draw.RoundedBox(0, pos, 0, seg, h, Color(69,51,69))
					pos = pos + seg*2
				end
			end
			point(layout, 'Итого', sum)
		elseif not pt[2] then
			cat, layout = category(scr, pt[1])
			sum = 0
		else
			point(layout, pt[1], pt[2])
			sum = sum + pt[2]
			total = total + pt[2]
		end

	end

	local butClose = fr:Add 'DButton'
	butClose:Dock(BOTTOM)
	butClose:SetTall(30)
	butClose:SetText('Получить ' .. DarkRP.formatMoney(total))
	function butClose:DoClick()
		fr:Close()
	end
end

netstream.Hook('cd.refundOld', openFrame)
