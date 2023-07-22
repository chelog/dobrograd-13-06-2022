octochat = octochat or {}
local defaultCol = Color(85, 68, 85)

hook.Add('HUDShouldDraw', 'octochat', function(name)

	if name == 'CHudChat' then return false end

end)

hook.Add('PlayerBindPress', 'octochat', function(ply, bind, press)

	if bind == 'messagemode' or bind == 'messagemode2' then
		if not IsValid(octochat.pnl) then octochat.create() end
		octochat.open()
		octochat.team = bind == 'messagemode2'

		local text, now = hook.Run('octochat.chatOpenText', bind), octochat.pnl.entry:GetText()
		if isstring(text) and utf8.sub(now, 1, utf8.len(text)) ~= text then
			local new = text .. now
			octochat.pnl.entry:SetText(new)
			octochat.pnl.entry:SetCaretPos(utf8.len(new))
		end

		return true
	end

end)

hook.Add('StartCommand', 'octochat', function(ply, cmd)
	if cmd:KeyDown(IN_ATTACK) and input.IsKeyDown(KEY_ENTER) then
		cmd:RemoveKey(IN_ATTACK)
	end
end)

hook.Add('InitPostEntity', 'octochat.noVoice', function()
	if IsValid(g_VoicePanelList) then
		g_VoicePanelList:Remove()
	end
end)

function chat.AddText(...)

	if not IsValid(octochat.pnl) then octochat.create() end
	octochat.msg(...)

end
chat.AddNonParsedText = chat.AddText

function chat.GetChatBoxPos()

	if not IsValid(octochat.pnl) then octochat.create() end
	return octochat.pnl:GetPos()

end

function chat.GetChatBoxSize()

	if not IsValid(octochat.pnl) then octochat.create() end
	return octochat.pnl:GetSize()

end

local ply = FindMetaTable 'Player'
function ply:ChatPrint(str)

	chat.AddText(str)

end

netstream.Hook('octochat.addEntry', chat.AddText)

netstream.Hook('chat', function(txt)

	chat.AddText(txt)

end)

function octochat.say(...)
	netstream.Start('chat', table.concat({...}, ' '))
end

hook.Add('OnPlayerChat', 'octochat', function(ply, text)
	if not IsValid(octochat.pnl) then return end
	if not IsValid(ply) then
		chat.AddText(octochat.textColors.rp, L.console, L.postfix_say, color_white, text)
	end
	return true
end)

function octochat.recreateFont()

	surface.CreateFont('octochat.default', {
		font = 'Roboto ' .. (octochat.settings.bold and 'Bold' or 'Regular'),
		extended = true,
		size = octochat.settings.textSize or 18,
		weight = 300,
		shadow = octochat.settings.shadow,
	})
	surface.CreateFont('octochat.underlined', {
		font = 'Roboto ' .. (octochat.settings.bold and 'Bold' or 'Regular'),
		extended = true,
		size = octochat.settings.textSize or 18,
		weight = 300,
		shadow = octochat.settings.shadow,
		underline = true,
	})

end

local colors = CFG.skinColors
function octochat.create()

	if not octochat.settings then octochat.load() end
	octochat.recreateFont()

	if IsValid(octochat.pnl) then octochat.pnl:Remove() end
	octochat.pnl = vgui.Create('DFrame')

	local w, h = octochat.settings.size[1], octochat.settings.size[2]
	local x, y = math.Clamp(octochat.settings.pos[1], -(w - 10), ScrW() - 10), math.Clamp(octochat.settings.pos[2], -(h - 10), ScrH() - 10)

	local pnl = octochat.pnl
	pnl:SetPos(x, y)
	pnl:SetSize(w, h)
	pnl:DockPadding(5, 5, 5, 0)
	pnl:SetTitle('')
	pnl:ShowCloseButton(false)
	pnl:SetSizable(true)
	pnl:MakePopup()
	local oldThink = pnl.Think
	function pnl:Think()
		if oldThink then oldThink(self) end
		self.history:SetVisible(octochat.isOpen or (hook.Run('HUDShouldDraw', 'octochat') ~= false))
	end

	pnl.alpha = 0
	pnl.Paint = function(self, w, h)
		if octochat.settings.showHint then
			surface.DisableClipping(true)
			draw.SimpleText(L.chat_settings_hint, 'DermaDefault', 5, -15, Color(255,255,255, self.alpha * 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			surface.DisableClipping(false)
		end

		local col = octochat.settings.color
		if ColorAlpha(col, 255) == defaultCol then
			col = ColorAlpha(colors.bg, col.a)
		end
		draw.RoundedBox(4, 0, 0, w, h, Color(col.r, col.g, col.b, col.a * self.alpha))
		draw.RoundedBoxEx(4, 0, h - 30, w, 30, Color(0,0,0, 80 * self.alpha), false, false, true, true)

		self.alpha = math.Approach(self.alpha, octochat.isOpen and 1 or 0, FrameTime() * 5)
	end

	pnl.history = vgui.Create('RichText', pnl)
	pnl.history:Dock(FILL)
	function pnl.history.PerformLayout(self)
		self:SetFontInternal('octochat.default')
		self:SetUnderlineFont('octochat.underlined')
	end
	function pnl.history:ActionSignal(name, val)
		if name == 'TextClicked' then
			octochat.close()
			gui.ActivateGameUI()
			octoesc.OpenURL(val)
		end
	end

	pnl.entry = vgui.Create('DTextEntry', pnl)
	pnl.entry:Dock(BOTTOM)
	pnl.entry:SetTall(30)
	pnl.entry:SetFont('octochat.default')
	pnl.entry:SetText('')
	pnl.entry:SetTextColor(Color(220,220,220))
	pnl.entry:SetCursorColor(Color(220,220,220))
	pnl.entry:SetHighlightColor(Color(100,100,100))
	pnl.entry:SetDrawBorder(false)
	pnl.entry:SetPaintBackground(false)
	pnl.entry:SetDrawLanguageID(false)
	pnl.entry:SetHistoryEnabled(true)

	pnl.entry.holdingKey = false
	pnl.entry.Think = function(self)
		if not octochat.isOpen then
			if octochat.settings.openEnter and input.IsKeyDown(KEY_ENTER) and (octochat.lastEnter or 0) <= CurTime() - 0.5 and not IsValid(vgui.GetKeyboardFocus()) and not gui.IsGameUIVisible() then
				octochat.open()
			end
			return
		end

		if gui.IsGameUIVisible() then
			gui.HideGameUI()
		end

		if input.IsKeyDown(KEY_TAB) and self:HasFocus() then
			self:RequestFocus()
		end

		if input.IsKeyDown(KEY_F3) then
			if self.holdingKey then return end
			self.holdingKey = true

			local enable = not octochat.clickerOn
			if not enable then octochat.clickerPos = { gui.MousePos() } end
			gui.EnableScreenClicker(enable)
			if enable then gui.SetMousePos(unpack(octochat.clickerPos or {0,0})) end
			timer.Simple(0, function() pnl:SetMouseInputEnabled(enable) end)
			octochat.clickerOn = enable
		elseif input.IsKeyDown(KEY_F4) then
			if self.holdingKey then return end
			self.holdingKey = true

			octochat.openSettings()
		elseif input.IsKeyDown(KEY_ESCAPE) then
			if self.holdingKey then return end
			self.holdingKey = true

			octochat.close()
			gui.HideGameUI()
		else
			self.holdingKey = false
		end
	end
	pnl.entry.OnEnter = function(self)
		if octochat.selAC then
			local ac = octochat.selAC
			self:SetText(ac)
			self:SetCaretPos(utf8.len(ac))
			self:OnTextChanged()
			self:RequestFocus()
		else
			octochat.send()
		end
	end
	pnl.entry.OnTextChanged = function(t, noMenuRemoval)

		t.HistoryPos = 0

		local txt = t:GetText()
		gamemode.Call('ChatTextChanged', txt)
		t:OnValueChange(txt)

		if IsValid(t.Menu) and not noMenuRemoval then
			t.Menu:Remove()
		end

		t:OnChange()
		if t.usingHistory then t.usingHistory = nil return end

		local words = string.Explode(' ', txt)
		if not words and #words == 0 then return end

		local ac = {}
		local cmd = words[1]:lower()
		local fl = cmd:sub(1,1)
		local ply = LocalPlayer()
		if #words == 1 then
			if fl == '!' or fl == '~' then
				local commands = serverguard.command:GetTable()
				for _, data in pairs(commands) do
					local command = data.command:lower()
					if (command and command ~= 'incognito' and (not data.permissions or serverguard.player:HasPermission(ply, data.permissions)))
					and command:find(cmd:sub(2), 1, true) then
						ac[#ac + 1] = fl .. command .. ' '
					end
				end
			end
			if fl ~= '' and octochat then
				for command in pairs(octochat.commands) do
					if string.StartWith(command, cmd) and octochat.canExecuteCommand(ply, command, {}, '') then
						ac[#ac + 1] = command .. ' '
					end
				end
			end
		end

		if not ac[1] then
			local lw = words[#words]
			if lw == '' then return end

			for _, ply in ipairs(player.GetAll()) do
				local name = ply:Name()
				if utf8.lower(name):find(utf8.lower(lw), 1, true) then
					-- table.insert(ac, txt:sub(1, txt:len() - lw:len()) .. name)
					ac[#ac + 1] = utf8.sub(txt, 1, utf8.len(txt) - utf8.len(lw)) .. '"' .. name .. '" '
				end
			end
		end

		table.sort(ac)

		if ac[1] then
			t.Menu = DermaMenu(t)
			for _, v in ipairs(ac) do
				t.Menu:AddOption(v, function() t:SetText(v) t:SetCaretPos(utf8.len(v)) t:RequestFocus() end)
			end

			local x, y = t:LocalToScreen(0, 0)
			t.Menu:SetMinimumWidth(t:GetWide())
			t.Menu:Open(x, y - t.Menu:GetTall(), true, t)
			t.Menu:SetMaxHeight(pnl:GetTall() - 35)
			t.Menu:SetPos(x, y - math.min(t.Menu:GetTall(), pnl:GetTall() - 35))
			t.Menu.OnRemove = function(m)
				octochat.selAC = nil
			end
		end

	end
	pnl.entry.OnKeyCode = function(self, code)
		if code >= 1 and code <= 66 then
			timer.Simple(0, function()
				self.lastEdit = self:GetValue()
			end)
		end
	end
	pnl.entry.UpdateFromHistory = function(self)
		self.usingHistory = true

		if IsValid(self.Menu) then
			self:UpdateFromMenu()
			self.usingHistory = nil
			return
		end

		local text
		local pos = self.HistoryPos
		-- is the pos within bounds?
		if pos < 0 then pos = #self.History end
		if pos > #self.History then pos = 0 end

		text = self.History[pos] or self.lastEdit or ''
		self:SetText(text)
		self:SetCaretPos(utf8.len(text))
		self:OnTextChanged()
		self.HistoryPos = pos

		self.usingHistory = nil -- just in case
	end
	pnl.entry.UpdateFromMenu = function(t)

		local pos = t.HistoryPos
		local num = t.Menu:ChildCount()

		t.Menu:ClearHighlights()

		if (pos < 1) then pos = num end
		if (pos > num) then pos = 1 end

		local item = t.Menu:GetChild(pos)
		if not item then
			t:SetText('')
			t.HistoryPos = pos
			return
		end

		t.Menu:HighlightItem(item)
		t.Menu:ScrollToChild(item)

		local txt = item:GetText()
		octochat.selAC = txt

		t.HistoryPos = pos

	end
	local oldUpdateFromHistory = pnl.entry.UpdateFromHistory
	pnl.entry.UpdateFromHistory = function(t)

		t.usingHistory = true
		oldUpdateFromHistory(t)
		t.usingHistory = nil -- just in case

	end

	-- a hack to make first message appear normally
	pnl.history:AppendText('\n')
	pnl.history:InsertFade(5, 2)
	octochat.close()

end

function octochat.open()

	local pnl = octochat.pnl
	pnl:SetKeyboardInputEnabled(true)
	pnl:SetMouseInputEnabled(octochat.settings.autoCursor or GUIToggled)
	pnl.entry:SetVisible(true)
	pnl.entry:RequestFocus()
	gamemode.Call('ChatTextChanged', pnl.entry:GetText())
	pnl.history:SetVerticalScrollbarEnabled(true)
	pnl.history:ResetAllFades(true, true, -1)

	gamemode.Call('StartChat')
	octochat.isOpen = true
	octochat.lastEnter = CurTime()

end

function octochat.close()

	local pnl = octochat.pnl
	pnl:SetKeyboardInputEnabled(false)
	pnl:SetMouseInputEnabled(false)
	pnl.history:SetVerticalScrollbarEnabled(false)
	pnl.history:ResetAllFades(false, true, 0)
	if not octochat.settings.showEntry then pnl.entry:SetVisible(false) end
	if IsValid(pnl.entry.Menu) then pnl.entry.Menu:Remove() end
	gamemode.Call('ChatTextChanged', '')
	-- pnl.entry:SetText('')

	local pos, size = {pnl:GetPos()}, {pnl:GetSize()}
	if pos[1] ~= octochat.settings.pos[1] or pos[2] ~= octochat.settings.pos[2] then octochat.settings.pos = pos octochat.save() end
	if size[1] ~= octochat.settings.size[1] or size[2] ~= octochat.settings.size[2] then octochat.settings.size = size octochat.save() end

	gamemode.Call('FinishChat')
	octochat.isOpen = false
	octochat.lastEnter = CurTime()

end

function octochat.send()

	local pnl = octochat.pnl
	local text = pnl.entry:GetText()
	if string.Trim(text) == '' then
		pnl.entry:SetText('')
		pnl.entry:RequestFocus()
		if octochat.settings.closeEmptySend and (octochat.lastEnter or 0) < CurTime() - 0.5 then
			octochat.close()
		end
		return
	end

	pnl.entry:AddHistory(text)
	pnl.entry:SetText('')
	pnl.entry:RequestFocus()
	if octochat.settings.closeOnSend then octochat.close() end

	netstream.Start('chat', text, octochat.team)

end

function octochat.msg(...)

	if not IsValid(octochat.pnl) then octochat.create() end

	local pnl = octochat.pnl.history
	local args = { ... }

	if octochat.settings.showTime then
		pnl:InsertColorChange(200,200,200, 255)
		pnl:AppendText(os.date(octochat.settings.showSeconds and '%H:%M:%S - ' or '%H:%M - ', os.time()))
		pnl:InsertFade(octochat.settings.msgLength, octochat.settings.msgFade)
	end

	if not IsColor(args[1]) then
		table.insert(args, 1, Color(235,235,235))
	end

	local lastColor
	for _, arg in pairs(args) do
		if IsColor(arg) then
			pnl:InsertColorChange(arg.r, arg.g, arg.b, 255)
			lastColor = arg
		elseif type(arg) == 'table' then

			if not octochat.settings.noLinks and octolib.string.isUrl(arg[1]) then
				pnl:InsertClickableTextStart(arg[1])
				pnl:InsertColorChange(0, 130, 255, 255)
				pnl:AppendText(arg[1])
				pnl:InsertFade(octochat.settings.msgLength, octochat.settings.msgFade)
				pnl:InsertColorChange(lastColor.r, lastColor.g, lastColor.b, 255)
				pnl:InsertClickableTextEnd()
			else
				pnl:AppendText(arg[1])
				pnl:InsertFade(octochat.settings.msgLength, octochat.settings.msgFade)
			end

		elseif type(arg) == 'string' then
			pnl:AppendText(arg)
			pnl:InsertFade(octochat.settings.msgLength, octochat.settings.msgFade)
		end
	end

	pnl:AppendText('\n')
	chat.PlaySound()

end

function octochat.load()

	local tCol = CFG.skinColors.bg
	local defaultCol = Color(tCol.r, tCol.g, tCol.b, 235)

	if not file.Exists('octochat_settings.dat', 'DATA') then
		file.Write('octochat_settings.dat', pon.encode({
			color = defaultCol,
			pos = {20, ScrH() - 300 - 200},
			size = {600, 300},
			textSize = 18,
			msgLength = 10,
			msgFade = 3,
			autoCursor = true,
			showEntry = true,
			closeOnSend = false,
			showHint = true,
			showTime = false,
			showSeconds = false,
			closeEmptySend = true,
			openEnter = true,
			shadow = true,
			noLinks = false,
		}))
	end

	local succ, res = pcall(pon.decode, file.Read('octochat_settings.dat'))
	if succ then
		octochat.settings = {
			color = res.color or defaultCol,
			pos = res.pos or {20, ScrH() - 300 - 200},
			size = res.size or {600, 300},
			textSize = res.textSize or 18,
			msgLength = res.msgLength or 10,
			msgFade = res.msgFade or 3,
			autoCursor = res.autoCursor == nil and true or res.autoCursor,
			showEntry = res.showEntry == nil and true or res.showEntry,
			closeOnSend = res.closeOnSend == nil and false or res.closeOnSend,
			showHint = res.showHint == nil and true or res.showHint,
			showTime = res.showTime == nil and false or res.showTime,
			showSeconds = res.showSeconds == nil and false or res.showSeconds,
			closeEmptySend = res.closeEmptySend == nil and true or res.closeEmptySend,
			openEnter = res.openEnter == nil and true or res.openEnter,
			shadow = res.shadow == nil and true or res.shadow,
		}
	else
		file.Delete('octochat_settings.dat')
		octochat.load()
	end

end

function octochat.save()

	if not octochat.settings then octochat.load() end
	file.Write('octochat_settings.dat', pon.encode(octochat.settings))

end

function octochat.openSettings()

	if IsValid(octochat.settingsFrame) then octochat.settingsFrame:Remove() end

	local tCol = CFG.skinColors.bg
	local defaultCol = Color(tCol.r, tCol.g, tCol.b, 235)

	local f = vgui.Create 'DFrame'
	octochat.settingsFrame = f

	f:SetSize(350, 600)
	f:SetTitle(L.chat_settings)
	f:Center()
	f:MakePopup()

	local e = {}

	e.c = f:Add 'DColorMixer'
	e.c:Dock(TOP)
	e.c:SetTall(150)
	e.c:SetAlphaBar(true)
	e.c:SetWangs(true)
	e.c:SetPalette(false)
	e.c.ValueChanged = function(c, col)
		octochat.settings.color = col
	end

	e.s1 = f:Add 'DNumSlider'
	e.s1:Dock(TOP)
	e.s1:DockMargin(8,10,0,0)
	e.s1:SetText(L.display_time_sec)
	e.s1:SetTall(30)
	e.s1:SetMinMax(1, 60)
	e.s1:SetDecimals(0)
	e.s1.OnValueChanged = function(s, val)
		local val = math.Clamp(val, 1, 60)
		octochat.settings.msgLength = val
		if e.s2:GetValue() > val then e.s2:SetValue(val) end
	end

	e.s2 = f:Add 'DNumSlider'
	e.s2:Dock(TOP)
	e.s2:DockMargin(8,0,0,0)
	e.s2:SetText(L.damping_time_sec)
	e.s2:SetTall(30)
	e.s2:SetMinMax(1, 15)
	e.s2:SetDecimals(0)
	e.s2.OnValueChanged = function(s, val)
		local val = math.Clamp(val, 1, 15)
		octochat.settings.msgFade = val
		if e.s1:GetValue() < val then e.s1:SetValue(val) end
	end

	e.s3 = f:Add 'DNumSlider'
	e.s3:Dock(TOP)
	e.s3:DockMargin(8,0,0,0)
	e.s3:SetText(L.font_size)
	e.s3:SetTall(30)
	e.s3:SetMinMax(10, 24)
	e.s3:SetDecimals(0)
	e.s3.OnValueChanged = function(s, val)
		octochat.settings.textSize = math.Clamp(val, 10, 24)
		octochat.recreateFont()
	end

	e.cb1 = f:Add 'DCheckBoxLabel'
	e.cb1:Dock(TOP)
	e.cb1:DockMargin(8,10,0,0)
	e.cb1:SetTall(30)
	e.cb1:SetText(L.use_bold)
	e.cb1.OnChange = function(s, val)
		octochat.settings.bold = val
		octochat.recreateFont()
	end

	e.cb2 = f:Add 'DCheckBoxLabel'
	e.cb2:Dock(TOP)
	e.cb2:DockMargin(8,10,0,0)
	e.cb2:SetTall(30)
	e.cb2:SetText(L.show_cursor_open)
	e.cb2.OnChange = function(s, val) octochat.settings.autoCursor = val end

	e.cb3 = f:Add 'DCheckBoxLabel'
	e.cb3:Dock(TOP)
	e.cb3:DockMargin(8,10,0,0)
	e.cb3:SetTall(30)
	e.cb3:SetText(L.show_entering_text)
	e.cb3.OnChange = function(s, val) octochat.settings.showEntry = val end

	e.cb4 = f:Add 'DCheckBoxLabel'
	e.cb4:Dock(TOP)
	e.cb4:DockMargin(8,10,0,0)
	e.cb4:SetTall(30)
	e.cb4:SetText(L.close_sent_msg)
	e.cb4.OnChange = function(s, val) octochat.settings.closeOnSend = val end

	e.cb5 = f:Add 'DCheckBoxLabel'
	e.cb5:Dock(TOP)
	e.cb5:DockMargin(8,10,0,0)
	e.cb5:SetTall(30)
	e.cb5:SetText(L.show_help_manage)
	e.cb5.OnChange = function(s, val) octochat.settings.showHint = val end

	e.cb6 = f:Add 'DCheckBoxLabel'
	e.cb6:Dock(TOP)
	e.cb6:DockMargin(8,10,0,0)
	e.cb6:SetTall(30)
	e.cb6:SetText(L.add_time_msg)
	e.cb6.OnChange = function(s, val) octochat.settings.showTime = val end

	e.cb7 = f:Add 'DCheckBoxLabel'
	e.cb7:Dock(TOP)
	e.cb7:DockMargin(8,10,0,0)
	e.cb7:SetTall(30)
	e.cb7:SetText(L.close_chat_empty)
	e.cb7.OnChange = function(s, val) octochat.settings.closeEmptySend = val end

	e.cb8 = f:Add 'DCheckBoxLabel'
	e.cb8:Dock(TOP)
	e.cb8:DockMargin(8,10,0,0)
	e.cb8:SetTall(30)
	e.cb8:SetText(L.show_seconds_in_time)
	e.cb8.OnChange = function(s, val) octochat.settings.showSeconds = val end

	e.cb9 = f:Add 'DCheckBoxLabel'
	e.cb9:Dock(TOP)
	e.cb9:DockMargin(8,10,0,0)
	e.cb9:SetTall(30)
	e.cb9:SetText(L.enter_open_chat)
	e.cb9.OnChange = function(s, val) octochat.settings.openEnter = val end

	e.cb10 = f:Add 'DCheckBoxLabel'
	e.cb10:Dock(TOP)
	e.cb10:DockMargin(8,10,0,0)
	e.cb10:SetTall(30)
	e.cb10:SetText(L.add_text_shadow)
	e.cb10.OnChange = function(s, val) octochat.settings.shadow = val octochat.recreateFont() end

	e.cb11 = f:Add 'DCheckBoxLabel'
	e.cb11:Dock(TOP)
	e.cb11:DockMargin(8,10,0,0)
	e.cb11:SetTall(30)
	e.cb11:SetText('Не отображать кликабельные ссылки')
	e.cb11.OnChange = function(s, val) octochat.settings.noLinks = val end

	e.c:SetColor(octochat.settings.color)
	e.s1:SetValue(octochat.settings.msgLength)
	e.s2:SetValue(octochat.settings.msgFade)
	e.s3:SetValue(octochat.settings.textSize)
	e.cb1:SetValue(octochat.settings.bold)
	e.cb2:SetValue(octochat.settings.autoCursor)
	e.cb3:SetValue(octochat.settings.showEntry)
	e.cb4:SetValue(octochat.settings.closeOnSend)
	e.cb5:SetValue(octochat.settings.showHint)
	e.cb6:SetValue(octochat.settings.showTime)
	e.cb8:SetValue(octochat.settings.showSeconds)
	e.cb7:SetValue(octochat.settings.closeEmptySend)
	e.cb9:SetValue(octochat.settings.openEnter)
	e.cb10:SetValue(octochat.settings.shadow)
	e.cb11:SetValue(octochat.settings.noLinks)

	local reset = f:Add 'DButton'
	reset:SetText(L.reset_chat)
	reset:SetSize(100, 30)
	reset:AlignBottom(8)
	reset:AlignRight(8)
	function reset:DoClick()
		e.c:SetColor(defaultCol)
		e.s1:SetValue(10)
		e.s2:SetValue(3)
		e.s3:SetValue(18)
		e.cb1:SetValue(false)
		e.cb2:SetValue(true)
		e.cb3:SetValue(true)
		e.cb4:SetValue(false)
		e.cb5:SetValue(true)
		e.cb6:SetValue(false)
		e.cb7:SetValue(true)
		e.cb8:SetValue(false)
		e.cb9:SetValue(true)
		e.cb10:SetValue(true)
		e.cb11:SetValue(true)
	end

	function f:OnClose()
		octochat.save()
	end

end

hook.Add('Think', 'octochat.create', function()

	hook.Remove('Think', 'octochat.create')
	octochat.create()

end)

hook.Add('StartChat', 'crim-compat', function(t)

	netstream.Start('isTyping', true)

end)

hook.Add('FinishChat', 'crim-compat', function()

	netstream.Start('isTyping', false)

end)

octolib.registerBindHandler('chat', {
	name = 'Отправить в чат',
	run = function(data)
		netstream.Start('chat', data)
	end,
	buildBinder = function(cont, bindID, bind)
		cont:SetTall(55)

		local e = octolib.textEntry(cont)
		e:Dock(FILL)
		e:DockMargin(5, 5, 5, 5)
		e:SetMultiline(true)
		e:SetPlaceholderText('Текст сообщения')
		e.PaintOffset = 5
		e:SetDrawLanguageID(false)
		e:SetValue(bind.data or '')

		local onChange = function(self)
			octolib.setBind(bindID, bind.button, bind.action, self:GetValue(), bind.on)
		end
		e.OnValueChange = onChange
		e.OnLoseFocus = onChange
	end,
})
