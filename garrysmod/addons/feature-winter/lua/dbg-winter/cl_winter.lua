hook.Add('PostDrawHUD', 'dbg-winter', function()
	local st = LocalPlayer():GetNetVar('frost', 0) / 100
	if isHoldingCamera or st <= 0 then return end

	DrawColorModify({
		['$pp_colour_addr'] = 0,
		['$pp_colour_addg'] = st * 0.2,
		['$pp_colour_addb'] = st * 0.5,
		['$pp_colour_brightness'] = 0,
		['$pp_colour_contrast'] = 1,
		['$pp_colour_colour'] = 1 - st * 0.5,
		['$pp_colour_mulr'] = 0,
		['$pp_colour_mulg'] = 0,
		['$pp_colour_mulb'] = 0,
	})
end)
