local meta = FindMetaTable 'Player'

function meta:GetKarma()

	if hook.Run('dbg-karma.override', self) == false then return 0 end
	return self:GetNetVar('dbg.karma', 0)

end
