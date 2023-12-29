if CFG.disabledModules.ptime then return end

local vars = {
	here = 'pt.here',
	total = 'pt.total',
	sessionStart = 'pt.sessionStart',
}

local meta = FindMetaTable('Player')

function meta:GetTimeSession()
	local ct = CurTime()
	return ct - self:GetNetVar(vars.sessionStart, ct)
end

function meta:GetTimeTotal()
	return self:GetNetVar(vars.total, 0) + self:GetTimeSession()
end

function meta:GetTimeHere()
	return self:GetNetVar(vars.here, 0) + self:GetTimeSession()
end
