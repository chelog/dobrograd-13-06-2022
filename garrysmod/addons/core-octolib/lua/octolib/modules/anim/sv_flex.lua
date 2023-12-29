local function applyFlex(ply, flexes)

	for i = 0, ply:GetFlexNum() - 1 do
		ply:SetFlexWeight(i, flexes[i] or 0)
	end

end

netstream.Hook('player-flex', function(ply, data)

	if not istable(data) then return end

	local flexes = {}
	for i = 0, ply:GetFlexNum() - 1 do
		local val = math.Round(math.Clamp(data[i] or 0, 0, 1), 2)
		flexes[i] = val ~= 0 and val or nil
	end

	ply.octolib_flexes = flexes
	applyFlex(ply, ply.octolib_flexes or {})

	netstream.StartPVS(ply:GetPos(), 'player-flex', ply, flexes)

end)
