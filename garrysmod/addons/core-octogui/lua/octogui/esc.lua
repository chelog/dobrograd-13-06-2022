hook.Add('Think', 'octoesc.init', function()
hook.Remove('Think', 'octoesc.init')

surface.CreateFont('octoesc.large', {
	font = 'Calibri',
	extended = true,
	size = 42,
	weight = 350,
})

local refreshInterval = 3 * 60
local pw, ph = ScrW(), ScrH()

octoesc = octoesc or {}
if IsValid(octoesc.pnl) then octoesc.pnl:Remove() end

local p = vgui.Create 'DPanel'
octoesc.pnl = p
p:SetSize(pw, ph)
p:SetPaintBackground(false)
p:MakePopup()
p:Center()
p.al = 0

local wasOpened, showConsole, forceMenu = nil, nil, nil
hook.Add('Think', 'octoesc', function()

	if gui.IsGameUIVisible() and not forceMenu then
		if (gui.IsConsoleVisible() and input.IsKeyDown(KEY_BACKQUOTE)) or showConsole then showConsole = true return end

		if not wasOpened then wasOpened = true return end
		p:Toggle(not p.active)
		gui.HideGameUI()
	elseif not forceMenu then
		wasOpened = nil
		showConsole = nil
	else
		forceMenu = nil
	end

end)

p.Toggle = function(self, val)

	if val == nil then val = self.active end

	if val then self:SetVisible(true) end
	self:SetMouseInputEnabled(val)
	self:SetKeyboardInputEnabled(val)
	self.active = val

	if val then
		self:PerformLayout()
		if octoinv then octoinv.show(false) end
	end

end

p.Think = function(self)

	self.al = math.Approach(self.al, self.active and 1 or 0, FrameTime() / 0.3)
	self:SetAlpha(self.al * 255)

	if self:IsVisible() and self.al == 0 then
		self:SetVisible(false)
	end

	if CurTime() >= (self.nextRefresh or 0) then
		p:RefreshServers()
	end

end

local blur = Material('pp/blurscreen')
local colors = CFG.skinColors
hook.Add('RenderScreenspaceEffects', 'octoesc', function()

	local state = p.al
	local a = 1 - math.pow(1 - state, 2)

	if a > 0 then
		local colMod = {
			['$pp_colour_addr'] = 0,
			['$pp_colour_addg'] = 0,
			['$pp_colour_addb'] = 0,
			['$pp_colour_mulr'] = 0,
			['$pp_colour_mulg'] = 0,
			['$pp_colour_mulb'] = 0,
			['$pp_colour_brightness'] = -a * 0.2,
			['$pp_colour_contrast'] = 1 + 0.5 * a,
			['$pp_colour_colour'] = 1 - a,
		}

		if GetConVar('octolib_blur'):GetBool() then
			DrawColorModify(colMod)

			surface.SetDrawColor(255, 255, 255, a * 255)
			surface.SetMaterial(blur)

			for i = 1, 3 do
				blur:SetFloat('$blur', a * i * 2)
				blur:Recompute()

				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRect(-1, -1, ScrW() + 2, ScrH() + 2)
			end
		else
			colMod['$pp_colour_brightness'] = -0.4 * a
			colMod['$pp_colour_contrast'] = 1 + 0.2 * a
			DrawColorModify(colMod)
		end

		draw.NoTexture()
		surface.SetDrawColor(colors.bg.r, colors.bg.g, colors.bg.b, a * 100)
		surface.DrawRect(-1, -1, ScrW() + 1, ScrH() + 1)
	end

end)

local buts = p:Add 'DPanel'
buts:Dock(LEFT)
buts:SetWide(250)
buts:SetPaintBackground(false)

local function hangClosed()

	forceMenu = true
	showConsole = true
	p:Toggle(false)

end

_oldOpenURL = _oldOpenURL or gui.OpenURL
function gui.OpenURL(url)

	hangClosed()
	_oldOpenURL(url)

end
octoesc.OpenURL = gui.OpenURL

_oldEnableVoiceChat = _oldEnableVoiceChat or permissions.EnableVoiceChat
function permissions.EnableVoiceChat(enable)

	hangClosed()
	_oldEnableVoiceChat(enable)

end

local function paintServer(self, w, h)
	draw.RoundedBox(8, 0, 0, w, h, colors.bg_d)
	draw.RoundedBox(8, 1, 1, w-2, h-2, colors.bg)
end
local function paintDivider(self, w, h) end

for i, v in ipairs({
	{'Продолжить', function() p:Toggle(false) end},
	{'spacer'},
	{'Форум', function() octoesc.OpenURL('https://forum.octothorp.team') end},
	{'Сайт', function() octoesc.OpenURL('https://www.octothorp.team') end},
	{'Вики', function() octoesc.OpenURL('https://wiki.octothorp.team') end},
	{'spacer'},
	{'Главное меню', function() hangClosed() gui.ActivateGameUI() end},
	{'Отключиться', function()
		local eID = LocalPlayer():EntIndex()
		if octoinv and octoinv.invs[eID]._hand and octoinv.invs[eID]._hand.items[1] then
			Derma_Query('У тебя в руках что-то есть. Если ты выйдешь, содержимое пропадет. Ты уверен?', 'Выход с сервера', L.yes, function() RunConsoleCommand('disconnect') end, L.no)
		else
			RunConsoleCommand('disconnect')
		end
	end},
}) do
	if v[1] == 'spacer' then
		local s = buts:Add 'DPanel'
		s:Dock(TOP)
		s:SetTall(20)
		s.Paint = paintDivider
	else
		local b = buts:Add 'DButton'
		b:Dock(TOP)
		b:SetTall(40)
		b:DockMargin(0, 0, 0, 10)
		b:SetFont('octoesc.large')
		b:SetText(v[1])
		b:SetContentAlignment(4)
		b:SetPaintBackground(false)
		b.DoClick = v[2]
	end
end

local scrollPanel = p:Add 'DScrollPanel'
scrollPanel:Dock(FILL)

if pw > 800 then
	buts:DockMargin(100, 150, 100, 150)
	scrollPanel.pnlCanvas:DockPadding(50, 100, 50, 100)
else
	buts:DockMargin(50, 50, 50, 50)
	scrollPanel.pnlCanvas:DockPadding(10, 20, 10, 20)
end

local iconLayout = scrollPanel:Add 'DIconLayout'
iconLayout:Dock(FILL)
-- iconLayout:DockMargin(50, 100, 50, 100)
iconLayout:SetPaintBackground(false)
iconLayout:SetSpaceX(10)
iconLayout:SetSpaceY(10)

p.RefreshServers = function(self)

	self.nextRefresh = CurTime() + refreshInterval

	local pnls = {}
	octoservices:get('/servers/status'):Then(function(res)
		iconLayout:Clear()
		for _, group in ipairs(res.data or {}) do
			local srvPanel = pnls[group.slug]
			if not IsValid(srvPanel) then
				srvPanel = iconLayout:Add 'DPanel'
				srvPanel:DockPadding(15, 15, 15, 15)
				srvPanel.Paint = paintServer
				if pw <= 800 then
					srvPanel:SetSize(pw - 400, 200)
				elseif pw <= 1024 then
					srvPanel:SetSize(pw - 600, 200)
				else
					srvPanel:SetSize((pw - 650) / 2, 180)
				end

				local name = srvPanel:Add 'DLabel'
				name:Dock(TOP)
				name:SetTall(35)
				name:SetFont('octoesc.large')
				name:SetText(group.name)

				local desc = srvPanel:Add 'DLabel'
				desc:Dock(FILL)
				desc:SetWrap(true)
				desc:SetContentAlignment(4)
				desc:SetText(group.desc)

				local bot = srvPanel:Add 'DPanel'
				bot:Dock(BOTTOM)
				bot:SetTall(30 * #group.servers - 5)
				bot:SetPaintBackground(false)
				srvPanel.bot = bot

				pnls[group.slug] = srvPanel
			end

			for srvID, server in ipairs(group.servers) do
				local status = server.status
				local contStatus = srvPanel.bot:Add 'DPanel'
				contStatus:Dock(TOP)
				contStatus:DockMargin(0, 0, 0, 5)
				contStatus:SetTall(25)
				contStatus:SetPaintBackground(false)

				local frac, barText
				local butJoin = contStatus:Add 'DButton'
				butJoin:Dock(RIGHT)
				if status then
					if status.connect == game.GetIPAddress() then
						butJoin:SetText('Ты здесь')
						butJoin:SetEnabled(false)
					elseif status.password then
						butJoin:SetText('Под паролем')
						butJoin:SetEnabled(false)
					elseif #status.players < status.maxplayers then
						butJoin:SetText('На сервер #' .. srvID)
						function butJoin:DoClick()
							Derma_Query('Подключение к серверу отключит тебя от текущей игры, продолжить?', 'Ты уверен?', 'Подключиться', function()
								hangClosed() gui.ActivateGameUI()
								LocalPlayer():ConCommand('connect ' .. status.connect)
							end, L.no)
						end
					else
						butJoin:SetText('Нет мест')
						butJoin:SetEnabled(false)
					end
					frac = math.min(#status.players / status.maxplayers, 1)
					barText = ('%s – %s из %s'):format(status.map or '???', #status.players, status.maxplayers)
				else
					butJoin:SetText('Не в сети')
					butJoin:SetEnabled(false)
					frac = 0
					barText = 'Сервер не работает'
				end
				butJoin:SizeToContentsX(20)

				local bar = contStatus:Add 'DProgress'
				bar:Dock(FILL)
				bar:DockMargin(0,0,10,0)
				bar:SetFraction(frac)

				local barLbl = bar:Add 'DLabel'
				barLbl:Dock(FILL)
				barLbl:SetContentAlignment(5)
				barLbl:SetText(barText)
			end
		end
	end):Catch(function(err)
		print(err)
		print('Произошла ошибка обновления статуса серверов, пробуем еще раз через минуту...')
		self.nextRefresh = CurTime() + 60
	end)

end

end)
