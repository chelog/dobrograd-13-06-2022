if CFG.disabledModules.use then return end

octolib.use = octolib.use or {}

function octolib.use.getTrace(ply)
	return ply:GetEyeTraceLimited(CFG.useDist)
end

function octolib.use.check(ply, ent)
	if not IsValid(ply) or not IsValid(ent) then return false end

	local tr = octolib.use.getTrace(ply)

	return tr.Entity == ent
end
