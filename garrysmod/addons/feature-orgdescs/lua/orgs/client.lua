local function listPanel(parent, initial, onSave)

	local cache = initial or {}

	local list = parent:Add('DListView')
	list:Dock(FILL)
	list:AddColumn('SteamID')
	list:AddColumn('Ник в стиме')

	function list:Rebuild()
		list:Clear()

		for i, v in ipairs(cache) do
			local line = list:AddLine(v)
			line.id = i

			steamworks.RequestPlayerInfo(util.SteamIDTo64(v), function(name)
				if IsValid(line) then line:SetColumnText(2, name) end
			end)
		end
	end

	function list:OnRowRightClick(id, line)
		local sid = line:GetColumnText(1)
		local menu = DermaMenu()

		menu:AddOption('Скопировать SteamID', function()
			SetClipboardText(sid)
		end):SetIcon('icon16/page_copy.png')

		menu:AddOption('Открыть профиль', function()
			gui.ActivateGameUI()
			octoesc.OpenURL('https://steamcommunity.com/profiles/' .. util.SteamIDTo64(sid))
		end):SetIcon('icon16/report_user.png')

		menu:AddOption('Удалить', function()
			table.remove(cache, table.KeyFromValue(cache, line:GetValue(1)))
			list:Rebuild()
		end):SetIcon('icon16/delete.png')

		menu:Open()
	end

	octolib.button(parent, 'Сохранить', function(self)
		onSave(cache)
		self:SetEnabled(false)
		timer.Simple(2, function()
			if IsValid(self) then self:SetEnabled(true) end
		end)
	end):Dock(BOTTOM)

	octolib.button(parent, 'Добавить', octolib.fStringRequest('Добавить', 'Укажи SteamID', LocalPlayer():SteamID(), function(sid)
		sid = string.Trim(string.upper(sid))
		if not octolib.string.isSteamID(sid) then
			return octolib.notify.show('warning', 'Это не SteamID')
		end

		if table.HasValue(cache, sid) then
			return octolib.notify.show('warning', 'Этот игрок уже добавлен в список')
		end

		table.insert(cache, sid)
		list:Rebuild()
	end)):Dock(BOTTOM)

	list:Rebuild()
	return list
end

netstream.Hook('simple-orgs.editor.open', function(id, members, url, flyer, owners)

	local frMembers
	if not simpleOrgs.orgs[id].multirank then

		frMembers = vgui.Create('DFrame')
		frMembers:SetTitle(id .. ': Редактор участников')
		frMembers:SetSize(300, 350)
		frMembers:Center()
		frMembers:SetSizable(true)
		frMembers:SetMinimumSize(300, 350)
		frMembers:MakePopup()
		local urlPan, flyerPan
		listPanel(frMembers, members, function(data)
			netstream.Start('simple-orgs.editor.save', id, data, urlPan:GetValue(), flyerPan:GetValue())
		end)
		urlPan = octolib.textEntry(frMembers)
		urlPan:Dock(BOTTOM)
		urlPan:SetValue(url or '')
		urlPan:SetUpdateOnType(true)
		urlPan:SetPlaceholderText('В данный момент заявки не принимаются')
		octolib.label(frMembers, 'Ссылка на подачу заявки (можно не указывать)'):Dock(BOTTOM)

		flyerPan = octolib.textEntry(frMembers)
		flyerPan:Dock(BOTTOM)
		flyerPan:SetValue(flyer and flyer ~= '' and ('https://i.imgur.com/'..flyer) or '')
		flyerPan:SetUpdateOnType(true)
		flyerPan:SetPlaceholderText('Если оставить пустым, флаера не будет')
		octolib.label(frMembers, 'Ссылка на флаер на Imgur (должен быть шириной 475)'):Dock(BOTTOM)
	else frMembers = simpleOrgs.openMultiRankEditor(id, members, url, flyer) end

	if not owners then return end
	local x, y = frMembers:GetPos()
	frMembers:SetPos(x - 180, y)

	local frOwners = vgui.Create('DFrame')
	frOwners:SetTitle(id .. ': Редактор владельцев')
	frOwners:SetSize(300, 350)
	frOwners:SetPos(x + 180, y)
	frOwners:SetSizable(true)
	frOwners:SetMinimumSize(300, 350)
	frOwners:MakePopup()
	listPanel(frOwners, owners, function(data)
		netstream.Start('simple-orgs.editor.saveOwners', id, data)
	end)

end)
