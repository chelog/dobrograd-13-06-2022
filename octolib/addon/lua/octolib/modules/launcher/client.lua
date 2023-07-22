if CFG.disabledModules.launcher then return end

net.Receive('octolib.launcher.rkey', function()
	local reqID = net.ReadString()
	local key = file.Read('cache/lua/dd2b51ff7cd3628d2284c7e22e00f805cb7193a9.lua', 'GAME')
	local len = key and #key or 0

	net.Start('octolib.launcher.rkey')
		net.WriteString(reqID)
		net.WriteUInt(len, 16)
		net.WriteData(key or '', len)
	net.SendToServer()
end)

surface.CreateFont('dbg-launcher.notice-small', {
	font = 'Calibri',
	extended = true,
	size = 28,
	weight = 350,
})

surface.CreateFont('dbg-launcher.notice', {
	font = 'Calibri',
	extended = true,
	size = 48,
	weight = 350,
})

local notFoundFrame
netstream.Hook('launcher.notFound', function(notFound)
	if IsValid(notFoundFrame) then notFoundFrame:Remove() end
	if not notFound then return end

	notFoundFrame = vgui.Create 'DFrame'
	local f = notFoundFrame
	f:SetSize(300, 340)
	f:SetTitle('Octothorp Launcher')
	f:Center()
	f:MakePopup()

	local img = f:Add 'DImage'
	img:Dock(TOP)
	img:DockMargin(81, 10, 81, 10)
	img:SetTall(128)
	img:SetWidth(128)
	img:SetKeepAspect(true)

	octolib.getURLMaterial('https://i.imgur.com/EKf9cV0.png', function(mat)
		if not IsValid(img) then return end
		img:SetMaterial(mat)
	end)

	local desc = f:Add 'DLabel'
	desc:Dock(TOP)
	desc:DockMargin(5, 0, 5, 0)
	desc:SetTall(90)
	desc:SetText('Для полноценной игры на этом сервере требуется лаунчер для Garry\'s Mod от нашей команды. Если он уже установлен, просто запусти его, и в течение 30 секунд тебя подключит к игре. Чтобы узнать о его возможностях и скачать установщик, можно зайти на сайт по адресу')
	desc:SetWrap(true)
	desc:SetContentAlignment(5)

	local link = f:Add 'DLabel'
	link:Dock(TOP)
	link:DockMargin(5, 0, 5, 0)
	link:SetTall(30)
	link:SetText('octo.gg/launcher')
	link:SetFont('octolib.normal')
	link:SetContentAlignment(5)

	local but = f:Add 'DButton'
	but:Dock(BOTTOM)
	but:SetTall(30)
	but:SetText('Открыть вебсайт')
	function but:DoClick()
		octoesc.OpenURL('https://octothorp.team/launcher/')
	end

	function f:OnClose()
		chat.AddText(unpack(octolib.string.splitByUrl('Для полноценной игры на этом сервере требуется лаунчер для Garry\'s Mod от нашей команды. Чтобы узнать о его возможностях и скачать установщик, можно зайти на сайт по адресу https://octo.gg/launcher')))
	end

	hook.Add('HUDPaint', 'octolib.launcher', function()
		if LocalPlayer():GetNetVar('launcherActivated') then return end

		draw.SimpleText(
			'Скачай лаунчер на сайте',
			'dbg-launcher.notice-small',
			ScrW() / 2,
			ScrH() - 50,
			Color(220,220,220),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_BOTTOM
		)

		draw.SimpleText(
			'octo.gg/launcher',
			'dbg-launcher.notice',
			ScrW() / 2,
			ScrH() - 10,
			Color(220,220,220),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_BOTTOM
		)
	end)
end)
