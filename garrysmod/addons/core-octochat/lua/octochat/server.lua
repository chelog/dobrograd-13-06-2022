netstream.Hook('isTyping', function(ply, is)

	ply:SetNetVar('IsTyping', tobool(is) or nil)

end)

function octochat.explodeArg(arg)
	local args = {}

	local from, to, diff = 1, 0, 0
	local inQuotes, wasQuotes = false, false

	for c in arg:gmatch('.') do
		to = to + 1

		if c == '"' then
			inQuotes = not inQuotes
			wasQuotes = true

			continue
		end

		if c == ' ' and not inQuotes then
			diff = wasQuotes and 1 or 0
			wasQuotes = false
			args[#args + 1] = arg:sub(from + diff, to - 1 - diff)
			from = to + 1
		end
	end
	diff = wasQuotes and 1 or 0

	if from ~= to + 1 then args[#args + 1] = arg:sub(from + diff, to + 1 - bit.lshift(diff, 1)) end

	return args
end

function octochat.findPlayer(info)
	if not info or info == '' then return end
	info = tostring(info)
	local lower = utf8.lower(info)
	local numInfo = tonumber(info)

	for _,v in ipairs(player.GetAll()) do

		if v:UserID() == numInfo then
			return v
		end

		if info == v:SteamID() then
			return v
		end

		if string.find(utf8.lower(v:SteamName()), lower, 1, true) ~= nil then
			return v
		end

		if string.find(utf8.lower(v:Name()), lower, 1, true) ~= nil then
			return v
		end
	end

end

-- "say" binds handling
hook.Add('PlayerSay', 'octochat.catchDefault', function(ply, txt, t)
	if ply.handledSay then return end
	ply:Say(txt, t)
	return ''
end)

local ply = FindMetaTable 'Player'
function ply:ChatPrint(txt)

	netstream.Start(self, 'chat', txt)

end

function ply:Say(txt, t)

	if not self:TriggerCooldown('octochat.say', 1) then return end

	txt = utf8.sub(string.Trim(tostring(txt)), 1, 1024)
	self.handledSay = true
	txt = hook.Run('PlayerSay', self, txt, tobool(t)) or txt
	self.handledSay = false
	if txt == '' then return end

	if not isfunction(octochat.genericSayFunc) then return end
	octochat.genericSayFunc(self, txt)
	hook.Run('PostPlayerSay', self, txt)

end
netstream.Hook('chat', ply.Say)

concommand.Add('octochat_say', function(ply, cmd, args, argStr)
	if IsValid(ply) then return ply:Say(argStr) end
	txt = hook.Run('ConsoleSay', argStr) or argStr
	if txt == '' then return end

	if not isfunction(octochat.genericSayFunc) then return end
	octochat.genericSayFunc(nil, txt)
	hook.Run('PostConsoleSay', nil, txt)
end)

concommand.Add('octochat_help', function(ply)
	if IsValid(ply) then return ply:PrintMessage(HUD_PRINTTALK, 'Эта команда доступна только консоли') end
	octolib.msg('Список команд, доступных с консоли:')
	for k, v in pairs(octochat.commands) do
		if v.consoleFriendly then octolib.msg(k) end
	end
end)

ply.OldPrintMessage = ply.OldPrintMessage or ply.PrintMessage
function ply:PrintMessage(type, str)
	if type == HUD_PRINTTALK then
		netstream.Start(self, 'chat', str)
	else
		self:OldPrintMessage(type, str)
	end
end

local OldPrintMessage = PrintMessage
function PrintMessage(type, str)
	if type == HUD_PRINTTALK then
		netstream.Start(nil, 'chat', str)
	else
		OldPrintMessage(type, str)
	end
end

function octochat.safeNotify(ply, channel, msg)
	if IsValid(ply) then ply:Notify(channel, msg)
	else octolib.msg(msg or channel) end
end

function octochat.safePlayerName(ply)
	return IsValid(ply) and ply:Name() or L.console
end

local function genericFilterFunc(pos, range)
	return function(ent)
		if not IsValid(ent) or not ent:IsPlayer() then return false end

		if ent.FSpectating then
			if ent.FSpectatePos then
				return ent.FSpectatePos:DistToSqr(pos) <= range
			elseif IsValid(ent.FSpectatingEnt) then
				return ent.FSpectatingEnt:GetPos():DistToSqr(pos) <= range
			end
		end

		return ent:GetPos():DistToSqr(pos) <= range
	end
end

local function ghostFilterFunc(pos, range)
	return function(ent)
		if not IsValid(ent) or not ent:IsPlayer() then return false end

		if ent.FSpectating then
			if ent.FSpectatePos then
				return ent.FSpectatePos:DistToSqr(pos) <= range
			elseif IsValid(ent.FSpectatingEnt) then
				return ent.FSpectatingEnt:GetPos():DistToSqr(pos) <= range
			end
		end

		return ent:GetPos():DistToSqr(pos) <= range and (ent:IsGhost() or ent:IsAdmin())
	end
end

function octochat.talkTo(recipients, ...)
	if not istable(recipients) then
		if isentity(recipients) then
			recipients = {recipients}
		elseif recipients then return ErrorNoHalt('Invalid recipients list') end
	end
	netstream.Start(recipients, 'octochat.addEntry', unpack{...})
	return recipients
end

function octochat.talkToAdmins(...)
	octochat.talkTo(octolib.players.getAdmins(), ...)
end

function octochat.talkToRange(pos, range, ...)
	if not isvector(pos) then
		if not isentity(pos) then return ErrorNoHalt('Expected position or entity') end
		pos = pos:GetPos()
	end

	return octochat.talkTo(octolib.array.filter(player.GetAll(), genericFilterFunc(pos, range * range)), ...)
end

function ply:TalkToRange(range, ...)
	local heard
	if not self:IsAlive() or self:IsGhost() then
		heard = octochat.talkTo(octolib.array.filter(player.GetAll(), ghostFilterFunc(self:GetPos(), range * range)), ...)
	else
		heard = octochat.talkToRange(self, range, ...)
	end
	return heard
end

function ply:DoEmote(emote)
	return self:TalkToRange(250, octochat.textColors.rp, emote % {name = self:Name()})
end
