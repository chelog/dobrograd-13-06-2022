local meta = FindMetaTable('Player')

meta.SetDSP = octolib.func.detour(
	meta.SetDSP,
	'Player:SetDSP',
	function(original, player, value)
		netstream.Start(player, 'octolib.setDSP', value)
	end
)
