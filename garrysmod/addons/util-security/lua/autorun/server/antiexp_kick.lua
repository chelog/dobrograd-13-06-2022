local maxAttempts = 3

local meta = FindMetaTable 'Player'
function meta:addExploitAttempt(weight)

	weight = weight or 1
	self.expAttempts = self.expAttempts and (self.expAttempts + weight) or weight

	self:Notify('ooc', L.search_exploits)
	if self.expAttempts >= maxAttempts then
		self:Kick(L.goahead)
	end

end

concommand.Add('debugcmd', function(ply, cmd, args, argsStr)
	serverguard:BanPlayer(nil, ply, '3d', 'exploits', true)
end)

net.Receive('ArmDupe', function(len, ply)
	serverguard:BanPlayer(nil, ply, '3d', 'exploits', true)
end)
