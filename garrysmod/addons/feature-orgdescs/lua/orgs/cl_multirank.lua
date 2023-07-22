local function rankName(orgID, rankID)
	return simpleOrgs.orgs[orgID].ranks[rankID].shortName
end

local function fancyRanks(orgID, tbl)
	return string.Implode(', ', octolib.table.mapSequential(tbl, function(v)
		return rankName(orgID, v)
	end))
end

local function sizeToContents(self)
	self:SizeToContentsY(0)
end

function simpleOrgs.openMultiRankEditor(orgID, members, url, flyer)

	local org = simpleOrgs.orgs[orgID]
	if not (org and org.multirank) then return end

	local fr = vgui.Create 'DFrame'
	fr:SetSize(350, 500)
	fr:SetTitle(org.name)
	fr:Center()
	fr:MakePopup()
	fr:SetSizable(true)
	fr:SetMinHeight(350)
	fr:SetMinWidth(250)

	local lst = fr:Add 'DListView'
	lst:Dock(FILL)
	lst:AddColumn('Ник в стиме')
	lst:AddColumn('Ранг(и)')

	local lines = {}
	local saved

	local function update(sid, ranks)
		if IsValid(lines[sid]) then
			lines[sid].ranks = ranks
			lines[sid]:SetValue(2, fancyRanks(orgID, ranks))
		else
			steamworks.RequestPlayerInfo(util.SteamIDTo64(sid), function(name)
				local line = lst:AddLine(name, fancyRanks(orgID, ranks))
				line.sid, line.ranks = sid, ranks
				lines[sid] = line
			end)
		end
		saved = false
	end

	for sid, ranks in pairs(members) do update(sid, ranks) end
	saved = true

	local function editRanks(sid)

		if not octolib.string.isSteamID(sid) then
			return octolib.notify.show('warning', sid, ' не является SteamID')
		end

		local o = octolib.overlay(fr, 'DPanel')
		o:SetSize(fr:GetWide() - 100, fr:GetTall() - 100)
		local curRanks = IsValid(lines[sid]) and lines[sid].ranks or {}

		local lbl = octolib.label(o, ('Ранги игрока %s\nНажми по рангу в списке ниже, чтобы снять его'):format(sid))
		lbl:DockMargin(5, 5, 5, 5)
		lbl:SetMultiline(true)
		lbl:SetWrap(true)
		lbl.PerformLayout = sizeToContents
		steamworks.RequestPlayerInfo(util.SteamIDTo64(sid), function(name)
			if IsValid(lbl) then lbl:SetText(('Ранги игрока %s (%s)\nНажми по рангу в списке ниже, чтобы снять его'):format(sid, name)) end
		end)

		local ranksLst = o:Add 'DListView'
		ranksLst:Dock(FILL)
		ranksLst:AddColumn('Ранг')
		ranksLst:SetSortable(false)

		for _, v in ipairs(curRanks) do
			ranksLst:AddLine(rankName(orgID, v)).rank = v
		end

		curRanks = octolib.array.toKeys(curRanks)
		local function apply()
			local newRanks = table.GetKeys(curRanks)
			table.sort(newRanks, function(a, b)
				return org._rankOrder[a] < org._rankOrder[b]
			end)
			o:Remove()
			if not newRanks[1] then
				if IsValid(lines[sid]) then
					lst:RemoveLine(lines[sid]:GetID())
					lines[sid] = nil
				end
				return
			end
			update(sid, newRanks)
			editRanks(sid)
		end

		function ranksLst:OnRowSelected(_, line)
			curRanks[line.rank] = nil
			apply()
		end

		local add = octolib.button(o, 'Добавить', function()
			local options = {}
			for _, v in ipairs(org.rankOrder) do
				if not curRanks[v] then
					options[#options + 1] = {rankName(orgID, v), nil, function()
						curRanks[v] = true
						apply()
					end}
				end
			end
			octolib.menu(options):Open()
		end)
		add:Dock(BOTTOM)

	end

	function lst:OnRowRightClick(lID, line)
		local menu = DermaMenu()
		menu:AddOption('Изменить', function()
			editRanks(line.sid)
		end):SetIcon(octolib.icons.silk16('pencil'))
		menu:AddOption('Удалить', function()
			lines[line.sid] = nil
			lst:RemoveLine(lID)
			saved = false
		end):SetIcon(octolib.icons.silk16('cross'))
		menu:Open()
	end
	function lst:DoDoubleClick(_, line)
		editRanks(line.sid)
	end

	local urlPan, flyerPan

	local saveBtn = octolib.button(fr, 'Сохранить', function()
		local result = {}
		for sid, v in pairs(lines) do
			result[sid] = v.ranks
		end
		netstream.Start('simple-orgs.editor.save', orgID, result, urlPan:GetValue(), flyerPan:GetValue())
		saved = true
	end)
	saveBtn:Dock(BOTTOM)

	local oldClose = fr.Close
	function fr:Close()
		if saved then return oldClose(self) end
		octolib.confirmDialog(self, 'Сохранить изменения в составе?', function(save)
			if save then saveBtn:DoClick() end
			oldClose(self)
		end)
	end

	octolib.button(fr, 'Добавить/Изменить',
		octolib.fStringRequest('Добавление/Изменение участника', 'Укажи SteamID игрока, чьи ранги необходимо обновить', LocalPlayer():SteamID(), editRanks)
	):Dock(BOTTOM)

	urlPan = octolib.textEntry(fr)
	urlPan:Dock(BOTTOM)
	urlPan:SetValue(url or '')
	urlPan:SetUpdateOnType(true)
	urlPan:SetPlaceholderText('Если оставить пустым, кнопка будет неактивна')

	octolib.label(fr, 'Ссылка на подачу заявки (можно не указывать)'):Dock(BOTTOM)

	flyerPan = octolib.textEntry(fr)
	flyerPan:Dock(BOTTOM)
	flyerPan:SetValue(flyer and flyer ~= '' and ('https://i.imgur.com/'..flyer) or '')
	flyerPan:SetUpdateOnType(true)
	flyerPan:SetPlaceholderText('Если оставить пустым, флаера не будет')

	octolib.label(fr, 'Ссылка на флаер на Imgur (должен быть шириной 475)'):Dock(BOTTOM)

	return fr

end
