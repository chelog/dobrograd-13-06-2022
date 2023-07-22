surface.CreateFont('octobans.normal', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
})

local colors = CFG.skinColors
netstream.Hook('octobans', function(msg)

	if msg then
		surface.PlaySound('ambient/creatures/pigeon_idle2.wav')
		local txt = markup.Parse('<font=octobans.normal>' .. msg .. '</font>', 600)
		local blur = Material('pp/blurscreen')
		hook.Add('RenderScreenspaceEffects', 'octobans', function()

			local colMod = {
				['$pp_colour_addr'] = 0,
				['$pp_colour_addg'] = 0,
				['$pp_colour_addb'] = 0,
				['$pp_colour_mulr'] = 0,
				['$pp_colour_mulg'] = 0,
				['$pp_colour_mulb'] = 0,
				['$pp_colour_brightness'] = -0.2,
				['$pp_colour_contrast'] = 1 + 0.5,
				['$pp_colour_colour'] = 0,
			}

			if GetConVar('octogui_blur'):GetBool() then
				DrawColorModify(colMod)

				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(blur)

				for i = 1, 3 do
					blur:SetFloat('$blur', i * 2)
					blur:Recompute()

					render.UpdateScreenEffectTexture()
					surface.DrawTexturedRect(-1, -1, ScrW() + 2, ScrH() + 2)
				end
			else
				colMod['$pp_colour_brightness'] = -0.4
				colMod['$pp_colour_contrast'] = 1 + 0.2
				DrawColorModify(colMod)
			end

			draw.NoTexture()
			local col = colors.bg
			surface.SetDrawColor(col.r,col.g,col.b, 100)
			surface.DrawRect(-1, -1, ScrW() + 1, ScrH() + 1)

		end)


		local lock = Material('octoteam/icons/lock.png')
		hook.Add('HUDPaint', 'octobans', function()

			surface.SetDrawColor(255,255,255, 255)
			surface.SetMaterial(lock)
			surface.DrawTexturedRect(ScrW() / 2 - 32, ScrH() / 2 - 180, 64, 64)

			txt:Draw((ScrW() - 600) / 2, ScrH() / 2 - 100, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 255)

		end)
	else
		hook.Remove('RenderScreenspaceEffects', 'octobans')
		hook.Remove('HUDPaint', 'octobans')
	end

end)
