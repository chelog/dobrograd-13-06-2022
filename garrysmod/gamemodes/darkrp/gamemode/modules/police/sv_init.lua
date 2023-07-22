local plyMeta = FindMetaTable('Player')

/*---------------------------------------------------------------------------
Interface functions
---------------------------------------------------------------------------*/
function plyMeta:warrant(warranter, reason)
	if self.warranted then return end
	local suppressMsg = hook.Call('playerWarranted', GAMEMODE, self, warranter, reason)

	self.warranted = true
	timer.Simple(GAMEMODE.Config.searchtime, function()
		if not IsValid(self) then return end
		self:unWarrant(warranter)
	end)

	if suppressMsg then return end

	local warranterNick = IsValid(warranter) and warranter:Nick() or L.disconnected_player
	local printMessage = L.warrant_ordered:format(warranterNick, self:Nick(), reason)

	for _,v in ipairs(player.GetAll()) do
		if v:isCP() then v:Notify(printMessage) end
	end

	warranter:Notify(L.warrant_approved2)
end

function plyMeta:unWarrant(unwarranter)
	if not self.warranted then return end

	local suppressMsg = hook.Call('playerUnWarranted', GAMEMODE, self, unwarranter)

	self.warranted = false

	if suppressMsg then return end

	unwarranter:Notify(L.warrant_expired:format(self:Nick()))
end

function plyMeta:wanted(actor, reason, time)
	if not IsValid(actor) or reason == '' then return end

	local suppressMsg = hook.Call('playerWanted', DarkRP.hooks, self, actor, reason)

	time = time or GAMEMODE.Config.wantedtime
	self:SetNetVar('wanted', reason)
	self:SetDBVar('wanted', {
		till = os.time() + time,
		reason = reason,
	})

	timer.Create(self:UniqueID() .. ' wantedtimer', time or GAMEMODE.Config.wantedtime, 1, function()
		if not IsValid(self) then return end
		self:unWanted()
	end)

	if suppressMsg then return end

	local printMessage = L.wanted_by_police_print:format(actor:Nick(), self:Nick(), reason)

	octolib.notify.sendAll(printMessage)
end

function plyMeta:unWanted(actor, reason)
	local suppressMsg = hook.Call('playerUnWanted', GAMEMODE, self, actor, reason or 'no reason')
	self:SetNetVar('wanted', nil)
	self:SetDBVar('wanted', nil)

	timer.Remove(self:UniqueID() .. ' wantedtimer')

	if suppressMsg then return end

	local expiredMessage = IsValid(actor) and L.wanted_revoked:format(self:Nick(), actor:Nick() or '', reason or 'Без причины') or
		L.wanted_expired:format(self:Nick())

	octolib.notify.sendAll(expiredMessage)
end

local baseTime = 30 * 60 -- 30 mins
local minTime = 10 * 60 -- 10 mins
local maxTime = 2.5 * 60 * 60 -- 2.5 hours
local function getJailTime(ply)
	local karma = ply:GetKarma()
	if karma > 0 then return baseTime end
	return baseTime - ply:GetKarma() * 5
end

function plyMeta:arrest(time, arrester, reason, noModify, noKarma)
	if self:Team() == TEAM_ADMIN then return end
	if not noModify then
		time = math.Clamp(math.Round((time or 1) * getJailTime(self)), minTime, maxTime)
	end

	if not noKarma then self:AddKarma(-1, L.karma_arrest) end

	hook.Call('playerArrested', DarkRP.hooks, self, time, arrester, reason)
	if self:InVehicle() then self:ExitVehicle() end
	self:SetNetVar('Arrested', true)
	self:SetNetVar('ArrestReason', reason)
	self.unarrestAt = os.time() + time

	-- Always get sent to jail when Arrest() is called, even when already under arrest
	local map = game.GetMap()
	if not map:find('riverden') and dbgPolice.haveJailPos() then
		self:Spawn()
	end
	self:SetPrisonClothes(true)
end

function plyMeta:unArrest(unarrester)
	if not self:isArrested() then return end

	self:SetNetVar('Arrested', nil)
	self:SetNetVar('ArrestReason', nil)
	self:SetHealth(100)
	self:SetHunger(100)
	self.unarrestAt = nil
	self:SetDBVar('arrest', nil)
	if self:InVehicle() then self:ExitVehicle() end
	self:SetPrisonClothes(false)
	hook.Call('playerUnArrested', DarkRP.hooks, self, unarrester)
end

/*---------------------------------------------------------------------------
Chat commands
---------------------------------------------------------------------------*/
DarkRP.nextEMSRequest = 1

function DarkRP.sendEMSPos(ply, cop)

	local marker = {
		id = 'police' .. DarkRP.nextEMSRequest,
		txt = L.police_call .. DarkRP.nextEMSRequest,
		pos = ply:GetPos() + Vector(0,0,40),
		col = Color(235,120,120),
		des = {'timedist', {600, 300}},
		icon = 'octoteam/icons-16/exclamation.png',
	}

	if cop:isEMS() then
		cop:EmitSound('ambient/chatter/cb_radio_chatter_' .. math.random(1,3) .. '.wav', 45, 100, 0.5)
		cop:AddMarker(marker)
	end

end

function DarkRP.callEMS(ply, nick, text)
	if (ply.nextEMSRequest or 0) > CurTime() then return end
	local can, why = hook.Run('dbg.canCallEMS', ply, nick, text)
	if can == false then return ply:Notify('warning', why or 'Ты не можешь вызвать экстренные службы сейчас') end

	local msg = L.prefix_request:format(DarkRP.nextEMSRequest, nick)

	octolib.request.send(ply, {{
		type = 'check',
		name = 'Вызов экстренных служб',
		desc = msg .. text,
		txt = 'Отправить координаты вызова',
	}}, function(data)
		local sendPos = tobool(data and data[1])

		ply:DoEmote(L.call_police_hint)
		hook.Run('dbg-police.call', ply, nick, text, sendPos)

		octochat.talkTo(ply, octochat.textColors.rp, msg, color_red, text)
		for _,v in ipairs(player.GetAll()) do
			if v:isEMS() then
				octochat.talkTo(v, octochat.textColors.rp, msg, color_red, text)
				if sendPos then DarkRP.sendEMSPos(ply, v) end
			end
		end

		ply.nextEMSRequest = CurTime() + 10
		DarkRP.nextEMSRequest = DarkRP.nextEMSRequest + 1
	end)

end

/*---------------------------------------------------------------------------
Hooks
---------------------------------------------------------------------------*/
hook.Add('dbg-char.spawn', 'dbg-police.prison', function(ply)
	timer.Simple(1, function()
		if ply:isArrested() then
			ply:SetPrisonClothes(true)
		end
	end)
end)

function DarkRP.hooks:playerArrested(ply, time, arrester, reason)
	if ply:isWanted() then ply:unWanted(arrester, 'Арестован') end
	ply:SetNetVar('HasGunlicense', nil)

	ply:StripWeapons()

	if ply:isArrested() then return end -- hasn't been arrested before

	octolib.notify.sendAll(L.police_arrest:format(ply:Name(), time, reason or '???'))

	local steamID = ply:SteamID()
	timer.Create(ply:UniqueID() .. 'jailtimer', time, 1, function()
		if IsValid(ply) then ply:unArrest() end
	end)
	net.Start('GotArrested')
		net.WriteFloat(time)
	net.Send(ply)
end

local posss = {
	rp_eastcoast_v4c = {
		Vector(1653.889771, 571.335571, -31.968750),
		Vector(1654.759277, 500.929108, -31.968750),
		Vector(1654.535278, 395.715942, -31.968750),
		Vector(1724.396240, 621.734558, -31.968750),
		Vector(1722.024292, 546.571472, -31.968750),
		Vector(1722.533203, 399.360565, -31.968750),
		Vector(1722.942505, 280.949951, -31.968750),
		Vector(1723.226929, 198.728729, -31.968750),
		Vector(1655.216919, 198.493408, -31.968750),
	},
	rp_truenorth_v1a = {
		Vector(1346, 3659, 8),
		Vector(1448, 3655, 8),
		Vector(1573, 3656, 8),
		Vector(1696, 3654, 8),
	},
	rp_evocity_dbg_220222 = {
		Vector(-7766, -9577, 72),
		Vector(-7768, -9387, 72),
		Vector(-7767, -9744, 72),
	},
	rp_riverden_dbg_220313 = {
		Vector(-8927.750977, 9896.843750, 66.194023),
		Vector(-8930.870117, 10103.999023, 66.029442),
		Vector(-8929.173828, 10319.784180, 66.202721),
	},
}

local lastSpawn = 1
local poss = posss[game.GetMap()]

function DarkRP.hooks:playerUnArrested(ply, actor)
	if ply.Sleeping and GAMEMODE.KnockoutToggle then
		DarkRP.toggleSleep(ply, 'force')
	end

	gamemode.Call('PlayerLoadout', ply)
	if GAMEMODE.Config.telefromjail then
		-- yeah,
		if lastSpawn > #poss then lastSpawn = 1 end
		-- yeah,
		local pos = poss[ lastSpawn ]
		-- fuck,
		lastSpawn = lastSpawn + 1
		-- off

		timer.Simple(0, function() if IsValid( ply ) then ply:SetPos(pos) ply:SelectWeapon('dbg_hands') end end) -- workaround for SetPos in weapon event bug
	end

	timer.Remove(ply:UniqueID() .. 'jailtimer')
	octolib.notify.sendAll(L.hes_unarrested:format(ply:Name()))
end

hook.Add('dbg-char.firstSpawn', 'Arrested', function(ply)

	timer.Simple(1, function()
		if not IsValid(ply) then return end
		local reason = ply:GetDBVar('arrest')
		if reason then
			print(ply, 'left while arrested')
			ply:arrest(reason[2], nil, (L.leave_arrest):format(reason[1]), true, true)
		end
	end)

end)

hook.Add('PlayerDisconnected', 'Arrested', function(ply)

	if ply:isArrested() then
		ply:SetDBVar('arrest', {ply:GetNetVar('ArrestReason') or L.reason_not_find, ply.unarrestAt - os.time()})
		print(ply, 'left while arrested')
	end

end)
