if not system.IsLinux() then return end

require 'slog'
require 'sourcenet'

local tag = 'stringcmd_exploit'

local maxL, maxN = 10000, 100
local tL, tN = {}, {}

local function punish(ply)

	if not IsValid(ply) or ply.kicked then return end
	
	ply.kicked = true
	serverguard:BanPlayer(nil, ply, '0', 'exploits', true)
	if CNetChan and CNetChan(ply:EntIndex()) then
		CNetChan(ply:EntIndex()):Shutdown('exploits')
	end

end

hook.Add('ExecuteStringCommand', tag, function(s, c)

	local cL, cN = tL[s], tN[s]
	if not cL then cL = 0 end
	if not cN then cN = 0 end

	if cL > maxL or cN > maxN then
		punish(player.GetBySteamID(s))
		return true
	end

	tN[s] = cN + 1
	tL[s] = cL + #c

end)

-- local lastTick
hook.Add('Tick', tag, function()

	for k, cL in next, tL do
		tL[k] = nil
	end

	for k, cN in next, tN do
		tN[k] = nil
	end

	-- if lastTick and SysTime() - lastTick > 0.5 then
	-- 	for i, ply in ipairs(player.GetAll()) do
	-- 		local ch = CNetChan(ply:EntIndex())
	-- 		local n = ch:GetNumBitsWritten(false)
	-- 		if n > 1000000 then punish(ply) end
	-- 	end
	-- end

	-- lastTick = SysTime()

end)
