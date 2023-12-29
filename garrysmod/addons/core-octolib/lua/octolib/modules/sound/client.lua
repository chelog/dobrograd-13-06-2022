local DSP = 1
local meta = FindMetaTable('Player')

function meta:GetDSP()
	return DSP
end

meta.SetDSP = octolib.func.detour(
	meta.SetDSP,
	'Player:SetDSP',
	function(original, player, value)
		DSP = value

		return original(player, value)
	end
)

netstream.Hook('octolib.setDSP', function(value)
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	ply:SetDSP(value)
end)
