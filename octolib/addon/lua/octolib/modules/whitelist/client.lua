local w
concommand.Add('dbg_whitelist', function()

	if IsValid(w) then w:Remove() return end

	w = vgui.Create 'DFrame'
	w:SetSize(400, 600)
	w:SetSizable(true)
	w:SetTitle(L.manage_whitelist)
	w:MakePopup()
	w:Center()

	local b = w:Add 'DButton'
	b:Dock(BOTTOM)
	b:SetTall(25)
	b:SetText(L.add_in_whitelist)
	function b:DoClick()
		Derma_StringRequest(L.add_in_whitelist2, L.print_steamid_hint, '', function(s)
			Derma_StringRequest('Причина', 'Введи причину добавления в вайтлист', '', function(s2)
				netstream.Start('whitelist.add', s, s2)
			end, nil, L.add, L.cancel)
		end, function() end, L.ok, L.cancel)
	end

	local l = w:Add 'DListView'
	l:Dock(FILL)
	l:AddColumn('SteamID')
	l:AddColumn('SteamID64')
	l:AddColumn(L.name_octoinv)
	l:AddColumn('Причина')
	function l:OnRowRightClick(i, line)
		if not line.sid then return end
		local m = DermaMenu()
		m:AddOption('Изменить причину', function()
			Derma_StringRequest('Причина', 'Введи причину добавления в вайтлист', '', function(s)
				netstream.Start('whitelist.add', line.sid, s)
			end, nil, L.add, L.cancel)
		end):SetImage('icon16/page_edit.png')
		m:AddOption(L.delete, function()
			netstream.Start('whitelist.remove', line.sid)
		end):SetImage('icon16/delete.png')
		m:Open()
	end
	w.l = l

	l:AddLine(L.loading)
	netstream.Start('whitelist.get')

end)

netstream.Hook('whitelist.get', function(data)

	if not IsValid(w) then return end

	w.l:Clear()
	for sid, reason in pairs(data) do
		local line = w.l:AddLine(util.SteamIDFrom64(sid), sid, L.loading, reason)
		line.sid = sid
		steamworks.RequestPlayerInfo(sid, function(name) line:SetColumnText(3, name) end)
	end

end)
