timer.Create('octolib.playerTick', CFG.playerTickTime, 0, function()
	octolib.func.throttle(player.GetAll(), 10, 0.1, function(ply)
		if not IsValid(ply) then return end
		ply.eyeDist = EyePos():DistToSqr(ply:GetPos())

		if ply.prevDormant ~= ply:IsDormant() then
			hook.Run('octolib.newDormantState', ply, ply:IsDormant())
			ply.prevDormant = ply:IsDormant()
		end
	end)

end)

local tellServerCache = {}
hook.Add('octolib.newDormantState', 'octolib.playerTick', function(ply, st)
	if not st and ply:IsPlayer() then
		tellServerCache[ply] = true
	end
end)

timer.Create('octolib.newDormantState', 3, 0, function()
	if table.Count(tellServerCache) < 1 then return end

	netstream.Start('PlayersEnteredPVS', table.GetKeys(tellServerCache))
	tellServerCache = {}
end)

local Player = FindMetaTable('Player')
local Entity = FindMetaTable('Entity')

-- see serverside for explanation
function Player:GetModel()
	return self.GetNetVar and self:GetNetVar('model') or Entity.GetModel(self)
end
