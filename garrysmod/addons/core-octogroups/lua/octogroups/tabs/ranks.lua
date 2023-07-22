local colHover = Color(0,0,0, 50)
og.tabBuilds['ranks'] = function(ps, g)

	local gID = g.id
	if not og.hasPerm(gID, 'editRank') then return end

	local p = vgui.Create 'DScrollPanel'
	ps:AddSheet('Ранги', p, 'icon16/group.png')

	local function rankPaint(self, w, h)
		if self.Hovered then draw.RoundedBox(0, 0, 0, w, h, colHover) end
		if self.icon then
			surface.SetDrawColor(255,255,255, 255)
			surface.SetMaterial(self.icon)
			surface.DrawTexturedRect(12, 12, 16, 16)
		end
	end

	local function rankClick(self)
		octolib.menu({
			{'Редактировать', 'icon16/pencil.png', function() og.openEditRank(gID, self.rID) end},
			{'Удалить', 'icon16/delete.png', octolib.fQuery('Ты уверен? Это действие необратимо', 'Удалить ранг', 'Да', function() og.editRank(gID, self.rID, nil) end, 'Нет')},
		}):Open()
	end

	local function setupButton(text, icon, doClick, rID)
		local b = p:Add 'DButton'
		b:Dock(TOP)
		b:DockMargin(2,0,2,0)
		b:SetTall(40)
		b:SetText(text)
		b:SetContentAlignment(4)
		b:SetTextInset(40, 0)
		b:SetFont('og.normal')
		b.Paint = rankPaint
		b.DoClick = doClick
		b.icon = icon and Material(icon)
		b.rID = rID
	end

	for rID, r in SortedPairsByMemberValue(g.ranks, 'order', true) do
		setupButton(r.name or '???', r.icon or 'icon16/error.png', rankClick, rID)
	end

	setupButton('Создать ранг', nil, function() og.openEditRank(gID) end)

end

function og.openEditRank(gID, rID)

	if not IsValid(pnl) then return end

	local r = rID and og.groupsOwn[gID].ranks[rID]
	local name = r and r.name or ''
	local icon = r and r.icon or ''
	local order = r and r.order or 1
	local perms = r and octolib.array.toKeys(r.perms) or {}
	local check

	local p = octolib.overlay(pnl, 'DScrollPanel')
	p:SetSize(400, 400)
	p:SetPaintBackground(true)
	p.pnlCanvas:DockPadding(10, 5, 10, 10)

	local eR = octolib.textEntry(p, 'ID ранга')
	if rID then
		eR:SetValue(rID)
		eR:SetEnabled(false)
	else
		eR:SetUpdateOnType(true)
		function eR:OnValueChange(v) rID = string.Trim(v) check() end
	end

	local eN = octolib.textEntry(p, 'Название')
	eN:SetValue(name)
	eN:SetUpdateOnType(true)
	function eN:OnValueChange(v) name = v check() end

	local eI = octolib.textEntryIcon(p, 'Иконка', 'materials/icon16/')
	eI:SetValue(icon)
	eI:SetUpdateOnType(true)
	function eI:OnValueChange(v) icon = v check() end

	local sO = octolib.slider(p, 'Старшинство', 1, 100, 0)
	sO:SetValue(order)
	function sO:OnValueChanged(v) order = math.Clamp(math.Round(v), 1, 100) end

	local cat = p:Add 'DCollapsibleCategory'
	cat:Dock(TOP)
	cat:DockMargin(0, 5, 0, 0)
	cat:SetExpanded(false)
	cat:SetLabel('Разрешения')

	local catP = vgui.Create 'DPanel'
	catP:DockPadding(5, 5, 5, 5)
	catP:SetPaintBackgroundEnabled(false)
	cat:SetContents(catP)

	for i, perm in ipairs({
		{'setMember', 'Приглашать участников'},
		{'setRank', 'Выдавать ранг / исключать'},
		{'post', 'Писать новости'},
		{'useMoney', 'Снимать со счета'},
		{'storage', 'Ставить хранилище'},
		{'setSetting', 'Изменять настройки'},
		{'editRank', 'Настраивать ранги'},
	}) do
		local c = octolib.checkBox(catP, perm[2])
		c:SetChecked(perms[perm[1]])
		function c:OnChange(v) perms[perm[1]] = v or nil end
	end

	local b = octolib.button(p, 'Сохранить', function()
		p:Remove()
		netstream.Start('og.editRank', gID, rID, {
			name = name,
			icon = icon,
			order = order,
			perms = table.GetKeys(perms),
		})
	end)
	b:DockMargin(0, 10, 0, 0)

	check = function()
		local ok = true
		if string.Trim(name) == '' then ok = false end
		if string.Trim(icon) == '' then ok = false end
		local rID, g = rID or '', og.groupsOwn[gID]
		if rID == '' or rID == 'member' or rID == 'owner' then ok = false end
		if g.ranks[rID] and g.ranks[rID] ~= r then ok = false end
		b:SetEnabled(ok)
	end
	check()

end
