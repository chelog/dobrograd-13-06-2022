local unbanConsentFrame

local performLayout = function(self)
	timer.Simple(0.2, function()
		if IsValid(self) then
			self:SizeToChildren(false, true)
		end
	end)
end
local sizeToY = function(self)
	self:SizeToContentsY()
end

local function panel(parent, name, desc)

	local pan = parent:Add 'DPanel'
	pan:Dock(TOP)
	pan:DockMargin(0,0,0,5)
	pan:DockPadding(5,5,5,5)
	pan.PerformLayout = performLayout

	if name then
		local l = pan:Add 'DLabel'
		l:Dock(TOP)
		l:DockMargin(5,0,5,5)
		l:SetTall(25)
		l:SetFont('octolib.normal')
		l:SetText(name)
		pan.name = l
	end

	if desc then
		local l = pan:Add 'DLabel'
		l:Dock(TOP)
		l:DockMargin(5,0,5,0)
		l:SetText(desc)
		l:SetWrap(true)
		l.PerformLayout = sizeToY
		pan.desc = l
	end

	return pan
end

netstream.Hook('dbg-unban.consent', function(data)
	if IsValid(unbanConsentFrame) then unbanConsentFrame:Close() end

	local height = 550
	local fr = vgui.Create 'DFrame'
	fr:SetSize(500, 550)
	fr:SetSizable(true)
	function fr:OnSizeChanged(w, h)
		if w ~= 500 then fr:SetWide(500) end
		if h > height then fr:SetTall(height) end
	end
	fr:Center()
	fr:SetTitle('Разбан игрока ' .. data.target)
	fr:SetAlpha(0)
	fr:MakePopup()
	unbanConsentFrame = fr

	local scr = fr:Add('DScrollPanel')
	scr:Dock(FILL)

	panel(scr, nil, 'Ты собираешься разбанить игрока. Пожалуйста, проверь всю информацию о нем, чтобы убедиться в отсутствии последствий')
	local nick = panel(scr, 'Ник игрока', '')
	steamworks.RequestPlayerInfo(util.SteamIDTo64(data.target), function(name)
		nick.desc:SetText(name)
	end)
	panel(scr, 'SteamID', data.target)

	local profile = panel(scr, 'Профиль в Steam', 'https://steamcommunity.com/profiles/' .. util.SteamIDTo64(data.target))
	profile.desc:SetMouseInputEnabled(true)
	profile.desc:SetCursor('hand')
	profile.desc:SetColor(Color(0,130,255))
	profile.desc.DoClick = function(self)
		octoesc.OpenURL(self:GetText())
	end


	panel(scr, 'Блокировку выдал админ', data.admin)
	if data.length == 0 then
		panel(scr, 'БЛОКИРОВКА БЕССРОЧНАЯ!', 'Особенно внимательно просмотри связанные аккаунты')
	else
		panel(scr, 'Примерный срок блокировки', octolib.time.formatDuration(data.length))
	end
	panel(scr, 'Причина', data.reason)
	panel(scr, 'Примерное время в блокировке', octolib.time.formatDuration(data.spent))

	local unbanReason, unbanBtn = panel(scr, 'Причина снятия блокировки', 'Пожалуйста, укажи причину снятия блокировки аккаунта')
	data.unbanReason = data.unbanReason ~= '' and data.unbanReason or nil
	local e = unbanReason:Add 'DTextEntry'
	e:Dock(TOP)
	e:DockMargin(5,5,5,0)
	e:SetUpdateOnType(true)
	e:SetValue(data.unbanReason or '')
	e.OnValueChange = function(e)
		local val = string.Trim(e:GetText())
		data.unbanReason = val ~= '' and val or nil
	end

	local familyPan = panel(scr, 'Связанные аккаунты', not data.family[1] and 'Нет связанных аккаунтов' or 'ПКМ или двойной ЛКМ по строке откроет профиль игрока в Steam')
	local lst = familyPan:Add('DListView')
	lst:Dock(TOP)
	lst:DockMargin(5,5,5,0)
	lst:AddColumn('Ник в стиме')
	lst:AddColumn('SteamID')
	lst:SetMultiSelect(false)
	for i, v in ipairs(data.family) do
		if v ~= data.target then
			local line = lst:AddLine('', v)
			steamworks.RequestPlayerInfo(util.SteamIDTo64(v), function(name)
				if IsValid(line) then line:SetColumnText(1, name) end
			end)
		end
	end
	function lst:OnRowRightClick(_, line)
		octolib.menu({{'Открыть профиль', 'icon16/user_go.png', function()
			octoesc.OpenURL('https://steamcommunity.com/profiles/' .. util.SteamIDTo64(line:GetColumnText(2)))
		end}}):Open()
	end
	function lst:OnDoubleClick(_, line)
		octoesc.OpenURL('https://steamcommunity.com/profiles/' .. util.SteamIDTo64(line:GetColumnText(2)))
	end
	lst:SetTall(lst:GetHeaderHeight() + lst:GetDataHeight() * #lst:GetLines())

	panel(scr, nil, 'Нажми на кнопку ниже, чтобы выдать разбан. Об этом будет уведомлена старшая администрация\nЧтобы отменить снятие блокировки, закрой это окно')

	local sec = data.length == 0 and 30 or 15
	unbanBtn = octolib.button(scr, 'Снять блокировку (' .. sec .. ')', function()
		if data.unbanReason == nil then return end
		netstream.Start('dbg-unban.consent', data.target, data.unbanReason)
		fr:Close()
	end)
	unbanBtn:SetFont('f4.normal')
	unbanBtn:SetTall(45)
	unbanBtn:SetEnabled(false)
	timer.Create('serverguard.unban.confirm-think', 1, 0, function()
		if not unbanBtn:IsValid() then return timer.Remove('serverguard.unban.confirm-think') end
		if data.unbanReason ~= nil then
			if sec == 0 then
				unbanBtn:SetText('Снять блокировку')
				unbanBtn:SetEnabled(true)
			else 
				unbanBtn:SetText('Снять блокировку (' .. sec .. ')') 
				sec = sec - 1 
			end
		else
			unbanBtn:SetText('Укажи причину снятия блокировки')
			unbanBtn:SetEnabled(false)
		end
	end)
	fr:InvalidateChildren(true)
	timer.Simple(1, function()
		local h = octolib.table.reduce(scr:GetCanvas():GetChildren(), function(ch, child)
			return ch + child:GetTall() + select(2, child:GetDockMargin()) + select(4, child:GetDockMargin())
		end, 0)
		if fr:IsValid() then fr:AlphaTo(255, 0.5) end
		height = h + select(2, fr:GetDockPadding()) + select(4, fr:GetDockPadding())
	end)

end)
