gmpanel.registerAction('models', function(obj)
	local model = obj.model
	local skin = obj.skin
	if not model or not skin then return false end
	local bg = obj.bodygroups or {}
	local players = gmpanel.buildTargets(obj.players or {})
	for _,pl in ipairs(players) do
		pl:SetModel(model)
		pl:SetSkin(skin)
		for k,v in pairs(bg) do
			pl:SetBodygroup(k, v)
		end
	end
end)
