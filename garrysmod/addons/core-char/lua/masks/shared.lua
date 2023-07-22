local plyMeta = FindMetaTable('Player')

function plyMeta:GetMaskId()
	local data = self:GetNetVar('hMask')
	if not data then return end
	return istable(data) and data[1] or data
end

function plyMeta:GetMaskExpire()
	local data = self:GetNetVar('hMask')
	if not data then return end
	return istable(data) and data[2] or nil
end

function plyMeta:CanUnmask()
	local data = self:GetNetVar('hMask')
	if not data then return end
	return istable(data) and not data.unequip or false
end