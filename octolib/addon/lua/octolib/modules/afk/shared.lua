local ply = FindMetaTable 'Player'

if CFG.disabledModules.afk then return end

function ply:GetAFKTime()
	local wentAFK = self:GetNetVar('afk')
	if not wentAFK then return 0 end

	return CurTime() - wentAFK
end

function ply:IsAFK()
	return tobool(self:GetNetVar('afk'))
end
