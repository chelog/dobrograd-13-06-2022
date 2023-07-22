local pmeta = FindMetaTable 'Player'
pmeta.SteamName = pmeta.SteamName or pmeta.Name
function pmeta:Name()
	return self:GetNetVar('rpname') or self:SteamName()
end
pmeta.GetName = pmeta.Name
pmeta.Nick = pmeta.Name
