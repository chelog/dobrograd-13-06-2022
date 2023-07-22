local meta = FindMetaTable 'Player'
function meta:GetLetterCount()

	local playerHas = 0
	for _,v in ipairs(ents.FindByClass('letter')) do
		if v:GetNetVar('Owner') == self then
			playerHas = playerHas + 1
		end
	end
	return playerHas

end
