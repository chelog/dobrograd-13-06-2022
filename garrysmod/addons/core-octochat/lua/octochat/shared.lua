octochat.notifyColors = {
	rp = Color(255, 220, 100),
	warning = Color(214, 74, 65),
	ooc = Color(43, 123, 167),
	hint = Color(16, 140, 73),
}

octochat.textColors = {
	rp = Color(255,220,83),
	ooc = Color(42,123,167),
}


local meta = FindMetaTable 'Player'

function meta:IsTyping()

	return self:GetNetVar('IsTyping', false)

end
