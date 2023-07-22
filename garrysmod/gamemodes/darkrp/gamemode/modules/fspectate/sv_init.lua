util.AddNetworkString("FSpectate")

local function findPlayer(info)
	if not info or info == "" then return nil end
	local pls = player.GetAll()

	for k = 1, #pls do
		local v = pls[k]
		if tonumber(info) == v:UserID() then
			return v
		end

		if info == v:SteamID() then
			return v
		end

		if string.find(string.lower(v:Name()), string.lower(tostring(info)), 1, true) ~= nil then
			return v
		end
	end

	return nil
end

local function Spectate(ply, cmd, args)
	CAMI.PlayerHasAccess(ply, "FSpectate", function(b, _)
		if not b then ply:ChatPrint("No Access!") return end

		local target = findPlayer(args[1])
		if target == ply then ply:ChatPrint("Invalid target!") return end

		ply.FSpectatingEnt = target
		ply.FSpectating = true
		hook.Run('fspectate.start', ply, target)

		ply:ExitVehicle()

		net.Start("FSpectate")
			net.WriteBool(target == nil)
			if IsValid(ply.FSpectatingEnt) then
				net.WriteEntity(ply.FSpectatingEnt)
			end
		net.Send(ply)

		local targetText = IsValid(target) and (target:Nick() .. " (" .. target:SteamID() .. ")") or ""
		ply:ChatPrint("You are now spectating " .. targetText)
	end)
end
concommand.Add("FSpectate", Spectate)

local function TPToPos(ply, cmd, args)
	CAMI.PlayerHasAccess(ply, "FSpectateTeleport", function(b, _)
		if not b then ply:ChatPrint("No Access!") return end

		local x, y, z = string.match(args[1] or "", "([-0-9\\.]+),%s?([-0-9\\.]+),%s?([-0-9\\.]+)")
		local vx, vy, vz = string.match(args[2] or "", "([-0-9\\.]+),%s?([-0-9\\.]+),%s?([-0-9\\.]+)")
		local pos = Vector(tonumber(x), tonumber(y), tonumber(z))
		local vel = Vector(tonumber(vx or 0), tonumber(vy or 0), tonumber(vz or 0))

		if not args[1] or not x or not y or not z then return end

		ply:SetPos(pos)

		if vx and vy and vz then ply:SetVelocity(vel) end
	end)
end
concommand.Add("FTPToPos", TPToPos)

local function SpectateVisibility(ply, viewEnt)
	if not ply.FSpectating then return end

	if IsValid(ply.FSpectatingEnt) then
		AddOriginToPVS(ply.FSpectatingEnt:GetShootPos())
	end

	if ply.FSpectatePos then
		AddOriginToPVS(ply.FSpectatePos)
	end
end
hook.Add("SetupPlayerVisibility", "FSpectate", SpectateVisibility)

local function setSpectatePos(ply, cmd, args)
	CAMI.PlayerHasAccess(ply, "FSpectate", function(b, _)
		if not b then ply:ChatPrint("No Access!") return end

		if not ply.FSpectating or not args[3] then return end
		local x, y, z = tonumber(args[1] or 0), tonumber(args[2] or 0), tonumber(args[3] or 0)

		ply.FSpectatePos = Vector(x, y, z)
	end)
end
concommand.Add("_FSpectatePosUpdate", setSpectatePos)

local function endSpectate(ply, cmd, args)
	ply.FSpectatingEnt = nil
	ply.FSpectating = nil
	ply.FSpectatePos = nil
	hook.Run('fspectate.end', ply)
end
concommand.Add("FSpectate_StopSpectating", endSpectate)

local function playerVoice(listener, talker)
	if not IsValid(listener.FSpectatingEnt) then return end

	-- You can hear someone if your spectate target can hear them
	local canHear, surround = GAMEMODE:PlayerCanHearPlayersVoice(listener.FSpectatingEnt, talker)
	local canHearLocal = GAMEMODE:PlayerCanHearPlayersVoice(listener, talker)

	-- you can always hear the person you're spectating
	return canHear or canHearLocal or listener.FSpectatingEnt == talker, surround
end
hook.Add("PlayerCanHearPlayersVoice", "FSpectate", playerVoice)

-- ULX' !spectate command conflicts with mine
-- The concommand "ulx spectate" should still work.
local function fixULXIncompat()
	if ULib then
		ULib.removeSayCommand("!spectate")
	end
end
hook.Add("InitPostEntity", "FSpectate", fixULXIncompat)
