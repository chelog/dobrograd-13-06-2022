---------------------------------------------------
-- CACHE STORAGE
---------------------------------------------------

cats.currentTickets = cats.currentTickets or {}
cats.adminDataCache = cats.adminDataCache or {}
cats.lastNotifiedTickets = cats.lastNotifiedTickets or {}

-- build receivers list
local function getAdmins(steamID)

	local admins = {}
	for i, ply in ipairs(player.GetAll()) do
		if cats.config.playerCanSeeTicket(ply, steamID) then table.insert(admins, ply) end
	end

	return admins

end

---------------------------------------------------
-- BASE CODE
---------------------------------------------------

-- create api interface

cats.api = octolib.api({
	url = 'https://octothorp.team/cats/api',
	headers = { ['Authorization'] = CFG.keys.cats },
})

local ignoreMsgsTime = {}

-- log in console
function cats:Log(text)

	print('[# CATS] ' .. os.date('%H:%M:%S - ', os.time()) .. text)

end

local discordMaxEmbedFields = 25
cats.NotifyDiscord = octolib.func.debounceStart(function(self)
	if table.IsEmpty(self.currentTickets) then return end

	local admins = octolib.array.toKeys(getAdmins(), 'Не занят')
	local adminDescriptions = table.Copy(admins)

	-- remove busy admins
	for _, ticket in pairs(self.currentTickets) do
		if IsValid(ticket.admin) then
			admins[ticket.admin] = nil
			adminDescriptions[ticket.admin] = 'Занят жалобой ' .. ticket.userID
		end
	end

	-- remove afk admins
	for admin in pairs(admins) do
		if admin:GetAFKTime() > CFG.afkAdminNotActive then
			admins[admin] = nil
			adminDescriptions[admin] = 'AFK'
		end

		if not self.config.actualAdminRanks[admin:GetUserGroup()] then
			admins[admin] = nil
			adminDescriptions[admin] = 'Ранг не обязывает'
		end
	end

	-- count active tickets
	local notClaimed = {}
	for userID, ticket in pairs(self.currentTickets) do
		if not IsValid(ticket.admin) then
			notClaimed[#notClaimed + 1] = userID
		end
	end
	if not self.config.iDiffers(notClaimed, self.lastNotifiedTickets) then return end
	self.lastNotifiedTickets = notClaimed
	if not notClaimed[1] then return end

	for _, userID in ipairs(notClaimed) do
		local user = player.GetBySteamID(userID)
		if IsValid(user) then
			self.config.notify(user, self.lang.ticket_noAdmins)
		end
	end

	local webhook = CFG.webhooks.cats
	if not webhook then return end

	local fields = octolib.table.mapSequential(notClaimed, function(sid)
		return {
			name = 'https://octothorp.team/cats/' .. sid,
			value = self.currentTickets[sid].chatLog[1][2],
		}
	end)
	if #fields+1 > discordMaxEmbedFields then
		local missing = #fields - (discordMaxEmbedFields-3)
		fields = octolib.array.page(fields, discordMaxEmbedFields - 3)
		fields[#fields + 1] = {
			value = ('+ Еще %d %s'):format(missing, octolib.string.formatCount(missing, 'жалоба', 'жалобы', 'жалоб')),
		}
	end

	fields[#fields + 1] = { name = '​', value = '​' } -- divider
	fields[#fields + 1] = {
		name = 'Админы на сервере',
		value = next(adminDescriptions) == nil and 'Никого' or table.concat(octolib.table.mapSequential(adminDescriptions, function(status, admin)
			return admin:SteamName() .. ' – ' .. status
		end), '\n'),
	}

	local embed = {
		-- author = {
		-- 	name = GetHostName(),
		-- 	url = 'https://octothorp.team/join-' .. CFG.serverID,
		-- },
		title = GetHostName(),
		description = ('**%d** %s, но активных админов нет'):format(#notClaimed, octolib.string.formatCount(#notClaimed, 'открытая жалоба', 'открытые жалобы', 'открытых жалоб')),
		fields = fields,
		thumbnail = { url = ('https://img.icons8.com/color/184/%d.png'):format(#notClaimed) },
	}

	if #notClaimed > 8 then
		embed.color = 0xA52019
		if #notClaimed > 10 then
			embed.footer = {
				text = 'Это какой-то апокалипсис! Пожалуйста, срочно зайдите!',
				icon_url = 'https://img.icons8.com/color/48/skull.png',
			}
		end
	elseif #notClaimed > 4 then
		embed.color = 0xFF4F00
	elseif #notClaimed > 2 then
		embed.color = 0xE5BE01
	end

	octoservices:post('/discord/webhook/' .. webhook, {
		content = #notClaimed > 5 and CFG.adminMention or nil,
		embeds = { embed },
	})

	if not table.IsEmpty(admins) then
		RunConsoleCommand('sg', 'a', ('Пожалуйста, разберите %d %s или позовите других админов на помощь'):format(#notClaimed, octolib.string.formatCount(#notClaimed, 'жалобу', 'жалобы', 'жалоб')))
	end

end, cats.config.notificationDelay)

timer.Create('cats.oldTicketsChecker', 60, 0, function()
	local currentTime = os.time()
	local callAdmins = false
	for userID, ticket in pairs(cats.currentTickets) do
		if currentTime - ticket.createdTime > cats.config.oldTicketTrigger and not IsValid(ticket.admin) then
			callAdmins = true
			break
		end
	end
	if callAdmins then cats:NotifyDiscord() end
end)

-- process & broadcast new ticket message
function cats:DispatchMessage(sender, steamID, msg, sendToAPI)

	local ply = player.GetBySteamID(sender)
	if msg == '' then
		ply:Notify('warning', 'Укажи текст админ-запроса')
		return
	end
	local admins = getAdmins(steamID)

	if self.currentTickets[steamID] then
		-- ticket exists, append chat message
		table.insert(self.currentTickets[steamID].chatLog, {sender, msg, sender ~= steamID})

		if sendToAPI then
			self.api:post('/msg/' .. steamID, {
				owner = sender,
				text = msg,
			}):Then(function(res)
				local msg = res.data
				if msg and msg.time then
					ignoreMsgsTime[msg.time] = true
				end
			end)
		end
	else
		-- create new ticket
		self.currentTickets[steamID] = {
			createdTime = os.time(),
			createdGameTime = CurTime(),
			chatLog = {{sender, msg}},
			userID = steamID
		}

		if sendToAPI then
			self.api:post('/chat', {
				owner = steamID,
				text = msg,
			}):Then(function(res)
				local ticket = res.data
				if ticket and ticket.created then
					ignoreMsgsTime[ticket.created] = true
				end
			end)
		end

		hook.Run('cats.created', sender)
	end

	hook.Run('cats.message', sender, steamID, msg)

	-- do networking
	netstream.Start(admins, 'cats.dispatchMessage', steamID, sender, msg)

end
netstream.Hook('cats.dispatchMessage', function(ply, steamID, msg)

	local user = player.GetBySteamID(steamID)

	-- check if user exists
	if not IsValid(user) then
		cats.config.notify(ply, 'warning', cats.lang.error_playerNotFound)
		return
	end

	-- check access
	if not cats.config.playerCanSeeTicket(ply, steamID) then
		cats.config.notify(ply, 'warning', cats.lang.error_noAccess)
		return
	end

	-- dispatch
	cats:DispatchMessage(ply:SteamID(), steamID, msg, true)

end)

netstream.Hook('cats.closeTicket', function(ply, steamID)

	local ticket = cats.currentTickets[steamID]

	-- ticket doesn't exist
	if not ticket then
		cats.config.notify(ply, 'warning', cats.lang.error_ticketNotFound)
		return
	end

	-- ticket already ended
	if ticket.ended then
		cats.config.notify(ply, 'warning', cats.lang.error_ticketEnded)
		return
	end

	if ticket.adminID == ply:SteamID() then
		-- admin closed the ticket
		local user = player.GetBySteamID(steamID)
		if IsValid(user) then
			cats.config.notify(user, cats.lang.ticketClosedBy:format(ticket.admin:Name()))
		end
		cats.config.notify(ply, cats.lang.ticketClosed)
	elseif ticket.userID == ply:SteamID() and not IsValid(ticket.admin) then
		-- user cancelled the ticket
	else
		-- we don't have access to this
		cats.config.notify(ply, 'warning', cats.lang.error_noAccess)
		return
	end

	cats:CloseTicket(steamID)
	hook.Run('cats.closed', ply:SteamID(), steamID)

end)

-- close ticket
function cats:CloseTicket(steamID)

	-- notify clients
	netstream.Start(getAdmins(steamID), 'cats.closeTicket', steamID)

	self.currentTickets[steamID] = nil
	self.api:delete('/chat/' .. steamID)

end

-- claim/unclaim ticket
function cats:ClaimTicket(steamID, ply, doClaim)

	local ticket = self.currentTickets[steamID]

	-- ticket doesn't exist
	if not ticket then
		self:Log('Trying to claim inexistant ticket for ' .. steamID)
		return
	end

	-- check access
	if IsValid(ticket.admin) and ticket.adminID ~= ply:SteamID() then
		cats.config.notify(ply, 'warning', cats.lang.error_noAccess)
		return
	end

	if doClaim then
		-- claim ticket
		ticket.admin = ply
		ticket.adminID = ply:SteamID()
		ticket.claimTime = os.time()
	else
		-- unclaim ticket
		ticket.admin = nil
		ticket.adminID = nil
	end

	hook.Run('cats.claim', ply, steamID, doClaim)
	netstream.Start(getAdmins(steamID), 'cats.claimTicket', steamID, ply, doClaim)

end
netstream.Hook('cats.claimTicket', function(ply, steamID, doClaim)

	local ticket = cats.currentTickets[steamID]

	-- check access
	if not cats.config.playerCanSeeTicket(ply, steamID) or ply:SteamID() == steamID then
		cats.config.notify(ply, 'warning', cats.lang.error_noAccess)
		return
	end

	-- ticket doesn't exist
	if not ticket then
		cats.config.notify(ply, 'warning', cats.lang.error_ticketNotFound)
		return
	end

	local user = player.GetBySteamID(steamID)
	if doClaim then
		-- ticket already claimed
		if IsValid(ticket.admin) then
			cats.config.notify(ply, 'warning', cats.lang.error_ticketAlreadyClaimed)
			return
		end

		-- notify about claim
		cats.config.notify(ply, cats.lang.ticketClaimed)
		cats.config.notify(user, cats.lang.ticketClaimedBy:format(ply:Name()))
	else
		-- ticket not claimed yet
		if not IsValid(ticket.admin) then
			cats.config.notify(ply, 'warning', cats.lang.error_ticketNotClaimed)
			return
		end

		-- notify about unclaim
		cats.config.notify(ply, cats.lang.ticketUnclaimed)
		cats.config.notify(user, cats.lang.ticketUnclaimedBy:format(ply:Name()))
	end

	-- do the thing
	cats:ClaimTicket(steamID, ply, doClaim)

end)

---------------------------------------------------
-- GAMEMODE HOOKS
---------------------------------------------------

-- initiate tickets
hook.Add('PlayerSay', 'cats', function(ply, text)

	local shouldTrigger, msg = cats.config.triggerText(ply, text)
	if shouldTrigger then
		cats:DispatchMessage(ply:SteamID(), ply:SteamID(), msg, true)
		return ''
	end

end)

-- deal with disconnected players
hook.Add('PlayerDisconnected', 'cats', function(ply)

	for steamID, ticket in pairs(cats.currentTickets) do
		if steamID == ply:SteamID() then
			-- notify admin
			if IsValid(ticket.admin) then
				cats.config.notify(ticket.admin, 'warning', cats.lang.ticketUserLeft)
			end

			-- delete ticket
			cats:CloseTicket(steamID)
		elseif ticket.adminID == ply:SteamID() then
			-- unclaim ticket
			cats:ClaimTicket(steamID, ply, false)
		end
	end

end)

hook.Add('PlayerFinishedLoading', 'cats', function(ply)

	if cats.config.playerCanSeeTicket(ply, '') then
		netstream.Start(ply, 'cats.syncTickets', cats.currentTickets)
	end

end)

local lastMsgTime = 0
timer.Create('cats.checkUpdates', 5, 0, function()

	cats.api:get('/util/updates/' .. lastMsgTime):Then(function(res)
		lastMsgTime = res.data[1]
		for steamID, msgs in pairs(res.data[2]) do
			for i, msg in ipairs(msgs) do
				if not ignoreMsgsTime[msg.time] then
					cats:DispatchMessage(msg.owner, steamID, msg.text)
				else
					ignoreMsgsTime[msg.time] = nil
				end
			end
		end
	end)

end)
