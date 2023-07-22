if SERVER and os.date('%d%m') ~= '0104' then return end
-- copied from face poser "smile" preset
local flexes = {
	[20] = 1,
	[21] = 1,
	[22] = 1,
	[23] = 1,
	[24] = 0,
	[25] = 0,
	[26] = 0,
	[27] = 0.6,
	[28] = 0.4,
	[29] = 0,
	[30] = 0,
	[31] = 0,
	[32] = 0,
	[33] = 1,
	[34] = 1,
	[35] = 0,
	[36] = 0,
	[37] = 0,
	[38] = 0,
	[39] = 0,
	[40] = 1,
	[41] = 1,
	[42] = 0,
	[43] = 0,
	[44] = 0,
}

local function smile(ply, mul)
	mul = mul or 1
	for k,v in pairs(flexes) do
		ply:SetFlexWeight(k, v * mul)
	end
end

if SERVER then
	hook.Add('dbg-test.complete', 'dbg-event.april1', function(ply)
		smile(ply)
	end)
end

if CLIENT then

	local enabled = false
	concommand.Add('dbg_smile', function()
		enabled = not enabled
		print(enabled and ':)' or ':|')
		for _,v in ipairs(player.GetAll()) do
			smile(v, enabled and 1 or 0)
		end
	end)

	hook.Add('octolib.newDormantState', 'dbg-event.april1', function(ply, st)
		if not st then smile(ply, enabled and 1 or 0) end
	end)

end
