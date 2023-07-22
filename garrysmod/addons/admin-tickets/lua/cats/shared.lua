-- proudly coded by chelog

if SERVER then function ScrW() return 1920 end function ScrH() return 1080 end end cats = cats or {} cats.config = {}
-- ^
-- | please do not touch these

------------------------------------------------------
-- BASIC CONFIG
------------------------------------------------------

-- positions
cats.config.spawnSize = { 450, 220 }
cats.config.spawnPosAdmin = { ScrW() - 500, 50 }
cats.config.spawnPosUser = { ScrW() - 500, ScrH() - 250 }

-- appearance
cats.config.punchCardMode = 'dots' -- 'line', 'dots' or 'columns'
cats.config.punchCardStart = 5

-- rating
cats.config.defaultRating = 3
cats.config.ratingTimeout = 60

-- admin notify
cats.config.oldTicketTrigger = 30 * 60
cats.config.notificationDelay = 15 * 60

-- sound
cats.config.newTicketSound = 'buttons/bell1.wav'

-- language
cats.lang = {
	openTickets = L.openTickets,
	myTicket = L.myTicket,
	userDisconnected = L.userDisconnected,
	claimedBy = L.claimedBy,
	sendMessage = L.sendMessage,
	typeYourMessage = L.typeYourMessage,
	actions = L.actions,
	action_claim = L.action_claim,
	action_unclaim = L.action_unclaim,
	action_spectate = L.action_spectate,
	action_goto = L.action_goto,
	action_bring = L.action_bring,
	action_return = L.action_return,
	action_returnself = L.action_returnself,
	action_copySteamID = L.action_copySteamID,
	action_callon = L.action_callon,
	action_calloff = L.action_calloff,
	action_close = L.action_close,
	error_wait = L.error_wait,
	error_noAccess = L.error_noAccess,
	error_playerNotFound = L.error_playerNotFound,
	error_ticketNotEnded = L.error_ticketNotEnded,
	error_ticketNotFound = L.error_ticketNotFound,
	error_ticketEnded = L.error_ticketEnded,
	error_ticketNotClaimed = L.error_ticketNotClaimed,
	error_ticketAlreadyClaimed = L.error_ticketAlreadyClaimed,
	error_needToRate = L.error_needToRate,
	error_cantCancelHasAdmin = L.error_cantCancelHasAdmin,
	ticketClaimed = L.ticketClaimed,
	ticketUnclaimed = L.ticketUnclaimed,
	ticketClaimedBy = L.ticketClaimedBy,
	ticketUnclaimedBy = L.ticketUnclaimedBy,
	ticketClosed = L.ticketClosed,
	ticketClosedBy = L.ticketClosedBy,
	ticketRatedForAdmin = L.ticketRatedForAdmin,
	ticketRatedForUser = L.ticketRatedForUser,
	ticketUserLeft = L.ticketUserLeft,
	rateAdmin = L.rateAdmin,
	ok = L.finish,
	cancel = L.cancel,
	ticket_noAdmins = L.ticket_noAdmins,
	dow = L.dow,
}

cats.config.actualAdminRanks = octolib.array.toKeys {
	'trainee',
	'admin',
	'tadmin',
	'sadmin',
}

------------------------------------------------------
-- ADVANCED SETTINGS (do not edit unless you're a dev)
------------------------------------------------------

cats.config.getPlayerName = function(ply)
	if not IsValid(ply) then return L.player_left end
	return ply:Name() .. " (" .. ply:SteamName() .. ")"
end
cats.config.playerCanSeeTicket = function(ply, ticketSteamID)
	return ply:query("DBG: Видеть админ-запросы") or ply:SteamID() == ticketSteamID
end
cats.config.triggerText = function(ply, text)
	if cats.config.playerCanSeeTicket(ply, "") then return false end

	text = text:Trim()
	if text:sub(1,1) == '@' then
		return true, text:sub(2):Trim()
	elseif text:sub(1,3) == '///' then
		return true, text:sub(4):Trim()
	end

	return false
end
cats.config.notify = function(ply, type, ...)
	if IsValid(ply) then
		ply:Notify(type, ...)
	else
		octolib.notify.sendAll(type, ...)
	end
end
cats.config.iDiffers = function(t1, t2)
	local delta = {}
	for _, v in ipairs(t1) do
		delta[v] = true
	end
	for _, v in ipairs(t2) do
		if not delta[v] then return true end
		delta[v] = nil
	end
	return not table.IsEmpty(delta)
end

-- NOTE: these are clientside
cats.config.commands = {
	{ -- spectate
		text = cats.lang.action_spectate,
		icon = 'eye',
		click = function(ply)
			RunConsoleCommand('FSpectate', ply:SteamID())
		end
	},
	{ -- copy steamID
		text = L.spawn,
		icon = 'asterisk_yellow',
		click = function(ply)
			RunConsoleCommand("say", "/spawn " .. ply:Name())
		end
	},
	{ -- bring
		text = cats.lang.action_bring,
		icon = 'arrow_left',
		click = function(ply)
			RunConsoleCommand('sgs', 'bring', ply:SteamID())
		end
	},
	{ -- return
		text = cats.lang.action_return,
		icon = 'arrow_redo',
		click = function(ply)
			RunConsoleCommand('sgs', 'return', ply:SteamID())
		end
	},
	{ -- goto
		text = cats.lang.action_goto,
		icon = 'arrow_right',
		click = function(ply)
			RunConsoleCommand('sgs', 'goto', ply:SteamID())
		end
	},
	{ -- return self
		text = cats.lang.action_returnself,
		icon = 'arrow_undo',
		click = function(ply)
			RunConsoleCommand('sgs', 'return', LocalPlayer():SteamID())
		end
	},
	{ -- copy steamID
		text = cats.lang.action_copySteamID,
		icon = 'page_copy',
		click = function(ply)
			SetClipboardText( ply:SteamID() )
		end
	},
}

-- | also please do not touch these
-- V
if SERVER then ScrW = nil ScrH = nil end
