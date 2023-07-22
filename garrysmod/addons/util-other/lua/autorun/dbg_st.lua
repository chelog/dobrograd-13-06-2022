local meta = FindMetaTable 'Player'

local function isvip( self )

	return self:query( L.permissions_dobrodey )

end
meta.IsVIP = isvip
meta.IsVip = isvip
