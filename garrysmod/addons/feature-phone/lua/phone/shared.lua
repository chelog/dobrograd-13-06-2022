local meta = FindMetaTable 'Player'

function meta:IsUsingPhone()
	return self:GetNetVar('UsingPhone', false)
end