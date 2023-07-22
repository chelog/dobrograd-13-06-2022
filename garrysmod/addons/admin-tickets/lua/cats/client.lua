--#################################################
-- Main frame
--#################################################

---------------------------------------------------
-- FONTS
---------------------------------------------------

surface.CreateFont("cats.small", {
	font = "Roboto Bold",
	extended = true,
	size = 16,
	weight = 500,
})
surface.CreateFont("cats.small-underline", {
	font = "Roboto Bold",
	extended = true,
	underline = true,
	size = 16,
	weight = 500,
})

---------------------------------------------------
-- HELPER FUNCTIONS
---------------------------------------------------

-- apply table to action button
local buttons -- declare here, fill later
local function applyButton(pnl, name, ply, steamID)
	local data = buttons[name]
	if not data then data = {
		tooltip = 'error',
		icon = Material(octolib.icons.silk16('error')),
		click = function() end
	} end

	pnl:SetToolTip(data.tooltip)
	pnl.icon = data.icon
	pnl.DoClick = function(self) data.click(self, ply, steamID) end
end

-- nice time
local function niceTime(time)

	local h, m, s
	h = math.floor(time / 60 / 60)
	m = math.floor(time / 60) % 60
	s = math.floor(time) % 60

	return string.format("%02i:%02i:%02i", h, m, s)

end

---------------------------------------------------
-- CACHE
---------------------------------------------------

-- icons cache
local icons = {
	action_claim = Material(octolib.icons.silk16('accept_button')),
	action_unclaim = Material(octolib.icons.silk16('cancel')),
	actions = Material(octolib.icons.silk16('text_list_bullets')),
	action_callon = Material(octolib.icons.silk16('lightbulb_off')),
	action_calloff = Material(octolib.icons.silk16('lightbulb')),
	action_close = Material(octolib.icons.silk16('application_form_delete')),
	noStar = Material(octolib.icons.silk16('bullet_white')),
	star = Material(octolib.icons.silk16('star')),
}

-- button tables
buttons = {
	action_claim = {
		tooltip = cats.lang.action_claim,
		icon = icons.action_claim,
		click = function(self, ply, steamID)
			netstream.Start('cats.claimTicket', steamID, true)
			applyButton(self, 'action_unclaim', ply, steamID)
		end
	},
	action_unclaim = {
		tooltip = cats.lang.action_unclaim,
		icon = icons.action_unclaim,
		click = function(self, ply, steamID)
			netstream.Start('cats.claimTicket', steamID, false)
			applyButton(self, 'action_claim', ply, steamID)
		end
	},
	actions = {
		tooltip = cats.lang.actions,
		icon = icons.actions,
		click = function(self, ply)
			local m = DermaMenu()
			for i, act in ipairs( cats.config.commands ) do
				m:AddOption( act.text, function()
					act.click(ply)
				end):SetIcon(octolib.icons.silk16(act.icon or 'wand'))
			end
			m:SetPos( input.GetCursorPos() )
			m:Open()
		end
	},
	action_callon = {
		tooltip = cats.lang.action_callon,
		icon = icons.action_callon,
		click = function(self, ply)
			applyButton(self, 'action_calloff', ply, steamID)
		end
	},
	action_calloff = {
		tooltip = cats.lang.action_calloff,
		icon = icons.action_calloff,
		click = function(self, ply)
			applyButton(self, 'action_callon', ply, steamID)
		end
	},
	action_close = {
		tooltip = cats.lang.action_close,
		icon = icons.action_close,
		click = function(self, ply, steamID)
			netstream.Start('cats.closeTicket', steamID)
		end
	},
}

-- default button list
local actionList = {
	'action_claim',
	'actions',
	-- 'action_callon',
	'action_close',
}

-- debug ticket data
local debugTicket = {
	user = LocalPlayer(),
	userID = 'STEAM_X:X:XXXXXXXX',
	admin = LocalPlayer(),
	adminID = 'STEAM_X:X:XXXXXXXX',
	chatLog = {
		{"Зюзя", "Админ тп, застрял", false},
		{"СуперВася", "Ща, погоди", true},
		{"Зюзя", "Ну где вы???", false},
		{"УберПетя", "Бля, Вася, да вытащи ты его уже, наконец, он заебал вопить, как малое дите, сука, ебаный в рот", true},
		{"СуперВася", "Ну ща-ща, я дорешаю жалобу", true},
		{"УберПетя", "Да с хера ли ты берешь столько жалоб? Разберись сначала с одной, потом уж на другие иди", true},
		{"СуперВася", "Да хорошо, блять, но дай сейчас-то разберусь", true},
		{"Зюзя", "Идите оба нахуй, я выбрался уже", false},
	}
}

-- my ticket
local myTicket

---------------------------------------------------
-- MAIN CODE
---------------------------------------------------

-- add a ticket frame to container
local function addTicketToFrame( data )

	-- sound notification
	surface.PlaySound(cats.config.newTicketSound)

	-- ticket panel
	local t = cats.ticketContainer:Add("DButton")
	t:SetSize(cats.config.spawnSize[1], 180)
	t:SetText('')
	t.expanded = true
	t.ticket = data -- apply ticket
	t.Paint = function(self, w, h)
		local user, admin = self.ticket.user, self.ticket.admin

		surface.SetDrawColor(30,40,50, 220)
		surface.DrawRect(0, 0, w, h)
		if self.Hovered then
			surface.SetDrawColor(255,255,255, 2)
			surface.DrawRect(0, 0, w, h)
		end
		surface.SetDrawColor(0,0,0, 255)
		surface.DrawLine(0, -1, 0, h)
		surface.DrawLine(-1, h-1, w, h-1)
		surface.DrawLine(w-1, h, w-1, -1)

		local time = '(' .. os.date( "%M:%S", CurTime() - self.ticket.created ) .. ')'
		local userName = IsValid(user) and user:Name() or cats.lang.userDisconnected
		draw.SimpleText(time .. ' ' .. userName, 'cats.small', 8, 15, Color(220,220,220), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		if IsValid(admin) then
			draw.SimpleText(admin:Name(), 'cats.small', w-8, 15, Color(180,200,240), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end
	end
	t.DoClick = function(self)
		self.expanded = not self.expanded
		for i,v in ipairs(cats.ticketContainer:GetChildren()) do
			-- if self ~= v then v.expanded = false end
			v:InvalidateLayout(true)
		end
		cats.ticketContainer:Layout()
		timer.Simple(0, function()
			self.chatLog:GotoTextEnd()
		end)
	end
	t.PerformLayout = function(self)
		self:SetSize(self:GetParent():GetWide(), self.expanded and 180 or 30)
		self.controls:SetVisible(self.expanded)

	end

	-- controls for ticket
	local c = vgui.Create("DPanel", t)
	c:DockMargin(1,1,1,1)
	c:Dock(BOTTOM)
	c:SetTall(150)
	c.Paint = function() end
	t.controls = c

	-- action buttons for controls
	t.controls.buttons = {}
	for i, v in pairs(actionList) do
		local b = vgui.Create("DButton", c)
		b:SetSize(30, 30)
		b:SetPos(0, (i-1)*30)
		b:SetText('')
		b.Paint = function(self, w, h)
			if self.Hovered then draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,2)) end
			surface.SetMaterial(self.icon)
			surface.SetDrawColor(255,255,255)
			surface.DrawTexturedRect(7, 7, 16, 16)
		end

		applyButton(b, v, t.ticket.user, t.ticket.userID)
		t.controls.buttons[v] = b
	end

	-- chat
	local cp = vgui.Create("DPanel", t.controls)
	cp:Dock(FILL)
	cp:DockMargin(30,0,0,0)
	cp.Paint = function(self, w, h)
		surface.SetDrawColor(0,0,0, 100)
		surface.DrawRect(0, 0, w, h-20)
		surface.SetDrawColor(0,0,0, 255)
		surface.DrawLine(0, h, 0, 0)
		surface.DrawLine(-1, 0, w, 0)
		surface.DrawLine(-1, h-21, w, h-21)
	end
	t.chat = cp

	-- chat entry
	local ce = vgui.Create("DButton", t.chat)
	ce:Dock(BOTTOM)
	ce:SetText('')
	ce:SetTall(20)
	ce:SetCursor('beam')
	ce.Paint = function(self, w, h)
		if self.Hovered then draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,1)) end
		draw.SimpleText(cats.lang.sendMessage, 'cats.small', 8, 10, Color(220,220,220, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	ce.DoClick = function(self)
		Derma_StringRequest(
			cats.lang.sendMessage, cats.lang.typeYourMessage, '',
			function(val)
				netstream.Start('cats.dispatchMessage', data.userID, val)
			end,
			nil,
			cats.lang.ok, cats.lang.cancel
		)
	end

	-- chat log
	local cl = vgui.Create("RichText", t.chat)
	cl:Dock(FILL)
	cl.Paint = function(self) -- WHAT. THE. FUCK.
		self.m_FontName = "cats.small"
		self:SetFontInternal("cats.small")
		self:SetUnderlineFont("cats.small-underline")
		self:SetBGColor(Color(0,0,0,0))
		self.Paint = nil
	end
	cl.ActionSignal = function(_, name, val)
		if name == "TextClicked" then
			octoesc.OpenURL(val)
		end
	end
	t.chatLog = cl

	cats.ticketContainer[data.userID] = t
	cats.ticketFrame:PerformLayout()

end

local function addTicketChatLog(steamID, sender, msg, isAdmin)

	octolib.func.chain({

		function(reply)
			if not octolib.string.isSteamID(sender) then return reply(sender) end
			steamworks.RequestPlayerInfo(util.SteamIDTo64(sender), reply)
		end,

		function(_, name)

			local cl = cats.ticketContainer[steamID].chatLog
			if not IsValid(cl) then return end

			if isAdmin then
				cl:InsertColorChange(50,120,180, 255)
			else
				cl:InsertColorChange(180,160,50, 255)
			end
			cl:AppendText("\n" .. name)

			cl:InsertColorChange(220,220,220, 255)
			cl:AppendText(": ")

			local data = octolib.string.splitByUrl(msg)
			for _,v in ipairs(data) do
				if type(v) == 'string' then
					cl:AppendText(v)
				else
					cl:InsertClickableTextStart(v[1])
					cl:InsertColorChange(0, 130, 255, 255)
					cl:AppendText(v[1])
					cl:InsertColorChange(220,220,220, 255)
					cl:InsertClickableTextEnd()
				end
			end

		end,

	})

end

-- generate main frame
hook.Add("PlayerFinishedLoading", "cats", function()

	if IsValid(cats.ticketFrame) then cats.ticketFrame:Remove() end
	local w, h = cats.config.spawnSize[1], cats.config.spawnSize[2]
	local x, y = cats.config.spawnPosAdmin[1], cats.config.spawnPosAdmin[2]

	-- main frame
	local p0 = vgui.Create("DFrame")
	p0:SetSize(w, h)
	p0:SetPos(x, y)
	p0:DockPadding(0, 24, 0, 0)
	p0:SetTitle('')
	p0:ShowCloseButton(false)
	cats.ticketFrame = p0

	-- scroll panel
	local p1 = vgui.Create("DScrollPanel", p0)
	p1:Dock(FILL)
	local oldLayout = p1.PerformLayout
	p1.PerformLayout = function(self)
		oldLayout(self)
		for i, v in ipairs(cats.ticketContainer:GetChildren()) do
			v:InvalidateLayout()
		end
	end
	local oldThink = p0.Think
	function p0:Think()
		if isfunction(oldThink) then oldThink(self) end
		p1:SetVisible(hook.Run('HUDShouldDraw', 'cats') ~= false)
	end

	-- icon layout
	local p2 = vgui.Create("DIconLayout", p1)
	p2:Dock(FILL)
	p2:SetSpaceX(0)
	p2:SetSpaceY(0)
	cats.ticketContainer = p2

	-- finish up main frame with some spicy hooks
	local oldLayout = p0.PerformLayout
	p0.PerformLayout = function(self)
		oldLayout(self)
		self:SetTall( math.min(p2:GetTall(), ScrH() - 100, 600) + 27 )
		self:SetVisible(#p2:GetChildren() > 0)
	end
	p0.Paint = function(self, w, h)
		if hook.Run('HUDShouldDraw', 'cats') == false then return end
		surface.SetDrawColor(30,40,50, 255)
		surface.DrawRect(0, 0, w, 24)
		surface.SetDrawColor(0,0,0, 255)
		surface.DrawOutlinedRect(0, 0, w, 24)
		draw.SimpleText(cats.lang.openTickets .. ' (' .. #p2:GetChildren() .. ')', 'cats.small', 8, 12, Color(220,220,220), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

end)

-- my ticket frame
if IsValid(cats.myTicketFrame) then cats.myTicketFrame:Remove() end
local function createMyTicket( data )

	-- sound notification
	surface.PlaySound(cats.config.newTicketSound)

	myTicket = data
	local w, h = cats.config.spawnSize[1], cats.config.spawnSize[2]
	local x, y = cats.config.spawnPosUser[1], cats.config.spawnPosUser[2]

	-- ticket frame
	local t = vgui.Create("DFrame")
	t:ShowCloseButton(false)
	t:SetSize(w, 220)
	t:SetPos(x, y)
	t:DockPadding(0,30,0,0)
	t:SetTitle('')
	t.ticket = myTicket -- apply ticket
	t.Paint = function(self, w, h)
		if not self.visible then return end
		local user, admin = self.ticket.user, self.ticket.admin

		surface.SetDrawColor(30,40,50, 220)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(0,0,0, 255)
		surface.DrawOutlinedRect(0,0,w,h)

		local time = '(' .. os.date( "%M:%S", CurTime() - self.ticket.created ) .. ')'
		draw.SimpleText(time .. ' ' .. cats.lang.myTicket, 'cats.small', 8, 15, Color(220,220,220), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		if IsValid(admin) then
			draw.SimpleText(admin:Name(), 'cats.small', w-8, 15, Color(180,200,240), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end
	end

	-- close ticket button
	surface.SetFont('cats.small')
	local tw, th = surface.GetTextSize(cats.lang.action_close)
	local b = vgui.Create("DButton", t)
	b:SetText('')
	b:SetSize(tw + 16,30)
	b:AlignRight(1)
	b.Paint = function(self, w, h)
		if self.Hovered then draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,1)) end
		draw.SimpleText(cats.lang.action_close, 'cats.small', w/2, h/2, Color(220,220,220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	b.DoClick = function(self)
		netstream.Start('cats.closeTicket', LocalPlayer():SteamID())
	end
	t.closeBut = b

	-- chat
	local cp = vgui.Create("DPanel", t)
	cp:Dock(FILL)
	cp.Paint = function(self, w, h)
		surface.SetDrawColor(0,0,0, 100)
		surface.DrawRect(0, 0, w, h-20)
		surface.SetDrawColor(0,0,0, 255)
		surface.DrawLine(0, h, 0, 0)
		surface.DrawLine(-1, 0, w, 0)
		surface.DrawLine(-1, h-21, w, h-21)
	end
	t.chat = cp

	-- chat entry
	local ce = vgui.Create("DButton", t.chat)
	ce:Dock(BOTTOM)
	ce:SetText('')
	ce:SetTall(20)
	ce:SetCursor('beam')
	ce.Paint = function(self, w, h)
		if self.Hovered then draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,1)) end
		draw.SimpleText(cats.lang.sendMessage, 'cats.small', 8, 10, Color(220,220,220, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	ce.DoClick = function(self)
		Derma_StringRequest(
			cats.lang.sendMessage, cats.lang.typeYourMessage, '',
			function(val)
				netstream.Start('cats.dispatchMessage', LocalPlayer():SteamID(), val)
			end,
			nil,
			cats.lang.ok, cats.lang.cancel
		)
	end

	-- chat log
	local cl = vgui.Create("RichText", t.chat)
	cl:Dock(FILL)
	cl.Paint = function(self) -- WHAT. THE. FUCK.
		self.m_FontName = "cats.small"
		self:SetFontInternal("cats.small")
		self:SetUnderlineFont("cats.small-underline")
		self:SetBGColor(Color(0,0,0,0))
		self.Paint = nil
	end
	cl.ActionSignal = function(_, name, val)
		if name == "TextClicked" then
			octoesc.OpenURL(val)
		end
	end
	t.chatLog = cl

	-- You can't just set visibility for self because it stops thinking
	local oldThink = t.Think
	function t:Think()
		if isfunction(oldThink) then oldThink(self) end
		self.visible = hook.Run('HUDShouldDraw', 'cats') ~= false
		if not (myTicket and myTicket.adminID) then
			b:SetVisible(self.visible)
		end
		cp:SetVisible(self.visible)
		ce:SetVisible(self.visible)
		cl:SetVisible(self.visible)
	end

	cats.myTicketFrame = t

end

local function addMyTicketChatLog(sender, msg, isAdmin)

	octolib.func.chain({

		function(reply)
			if not octolib.string.isSteamID(sender) then return reply(sender) end
			steamworks.RequestPlayerInfo(util.SteamIDTo64(sender), reply)
		end,

		function(_, name)

			local cl = cats.myTicketFrame.chatLog
			if not IsValid(cl) then return end

			if isAdmin then
				cl:InsertColorChange(50,120,180, 255)
			else
				cl:InsertColorChange(180,160,50, 255)
			end
			cl:AppendText("\n" .. name)

			cl:InsertColorChange(220,220,220, 255)
			cl:AppendText(": ")

			local data = octolib.string.splitByUrl(msg)
			for _,v in ipairs(data) do
				if type(v) == 'string' then
					cl:AppendText(v)
				else
					cl:InsertClickableTextStart(v[1])
					cl:InsertColorChange(0, 130, 255, 255)
					cl:AppendText(v[1])
					cl:InsertColorChange(220,220,220, 255)
					cl:InsertClickableTextEnd()
				end
			end

		end,

	})

end

netstream.Hook('cats.dispatchMessage', function(steamID, sender, msg)

	if steamID == LocalPlayer():SteamID() then
		if sender ~= LocalPlayer():SteamID() then surface.PlaySound(cats.config.newTicketSound) end
		if myTicket then
			addMyTicketChatLog(sender, msg, sender ~= LocalPlayer():SteamID())
		else
			createMyTicket({created = CurTime()})
			addMyTicketChatLog(sender, msg, sender ~= LocalPlayer():SteamID())
		end
	elseif IsValid(cats.ticketContainer[steamID]) then
		addTicketChatLog(steamID, sender, msg, sender ~= steamID)
	else
		local user = player.GetBySteamID(steamID)
		-- if not IsValid(user) then return end

		addTicketToFrame({
			user = user,
			userID = steamID,
			created = CurTime(),
		})
		addTicketChatLog(steamID, sender, msg, sender ~= steamID)
	end

end)

netstream.Hook('cats.claimTicket', function(steamID, admin, doClaim)

	if not IsValid(admin) then return end

	if steamID == LocalPlayer():SteamID() and myTicket then
		myTicket.admin = doClaim and admin or nil
		myTicket.adminID = doClaim and admin:SteamID() or nil
		cats.myTicketFrame.closeBut:SetVisible(not doClaim)
	elseif IsValid(cats.ticketContainer[steamID]) then
		local ticket = cats.ticketContainer[steamID].ticket
		ticket.admin = doClaim and admin or nil
		ticket.adminID = doClaim and admin:SteamID() or nil

		if ticket.adminID ~= LocalPlayer():SteamID() then
			local b = cats.ticketContainer[steamID].controls.buttons['action_claim']
			local user = player.GetBySteamID(ticket.userID)
			if doClaim then
				applyButton(b, 'action_unclaim', user, ticket.userID)
				b:SetEnabled(false)
			else
				applyButton(b, 'action_claim', user, ticket.userID)
				b:SetEnabled(true)
			end
		end
	end

end)

netstream.Hook('cats.closeTicket', function(steamID)

	if steamID == LocalPlayer():SteamID() and myTicket then
		cats.myTicketFrame:Remove()
		myTicket = nil
	elseif IsValid(cats.ticketContainer[steamID]) then
		cats.ticketContainer[steamID].ticket = nil
		cats.ticketContainer[steamID]:Remove()
		cats.ticketFrame:PerformLayout()
	end

end)

netstream.Hook('cats.syncTickets', function(tickets)

	for steamID, t in pairs(tickets) do
		local user = player.GetBySteamID(steamID)
		if not IsValid(user) then continue end

		addTicketToFrame({
			user = user,
			userID = steamID,
			created = t.createdGameTime,
			admin = t.admin,
			adminID = t.adminID
		})

		if IsValid(t.admin) then
			local b = cats.ticketContainer[steamID].controls.buttons['action_claim']
			applyButton(b, 'action_unclaim', t.user, steamID)
			b:SetEnabled(false)
		end

		for k, v in pairs(t.chatLog) do
			addTicketChatLog(steamID, v[1], v[2], v[3])
		end
	end

end)

concommand.Add("cats_test_admin", function()

	local steamID = LocalPlayer():SteamID()
	addTicketToFrame({
		user = LocalPlayer(),
		userID = steamID,
		created = CurTime(),
		admin = LocalPlayer(),
		adminID = steamID,
	})
	addTicketChatLog(steamID, "chelog", "Admin let me test my ticket!", false)
	addTicketChatLog(steamID, "Admin", "Alright.", true)

end)

concommand.Add("cats_test_admin_clear", function()

	cats.ticketContainer:Clear()

end)

concommand.Add("cats_test_myticket", function()

	createMyTicket({created = CurTime()})
	addMyTicketChatLog("chelog", "Admin let me test my ticket!", false)
	addMyTicketChatLog("Admin", "Alright.", true)

end)
