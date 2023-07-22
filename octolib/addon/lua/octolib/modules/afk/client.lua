if CFG.disabledModules.afk then return end

local lastPress, isAFK = 0, false

local function startTicking()

	netstream.Start('octolib.afk', false)
	isAFK = false

end

local function stopTicking()

	netstream.Start('octolib.afk', true)
	isAFK = true

end

hook.Add('PlayerButtonDown', 'octolib', function(ply, button)

	if not system.HasFocus() then return end

	lastPress = CurTime()
	if isAFK then startTicking() end

end)

timer.Create('octolib.afktick', 1, 0, function()

	if isAFK then return end
	if CurTime() >= lastPress + CFG.afkTime then stopTicking() end

end)

local blur, blurState = Material( 'pp/blurscreen' ), 0
local colors = CFG.skinColors
hook.Add( 'RenderScreenspaceEffects', 'octolib.afk', function()

	local a = 1 - math.pow( 1 - blurState, 2 )
	if a > 0 and CFG.drawOverlay then
		local colMod = {
			['$pp_colour_addr'] = 0,
			['$pp_colour_addg'] = 0,
			['$pp_colour_addb'] = 0,
			['$pp_colour_mulr'] = 0,
			['$pp_colour_mulg'] = 0,
			['$pp_colour_mulb'] = 0,
			['$pp_colour_brightness'] = -a * 0.2,
			['$pp_colour_contrast'] = 1 + 0.5 * a,
			['$pp_colour_colour'] = 1 - a,
		}

		if GetConVar('octolib_blur'):GetBool() then
			DrawColorModify(colMod)

			surface.SetDrawColor( 255, 255, 255, a * 255 )
			surface.SetMaterial( blur )

			for i = 1, 3 do
				blur:SetFloat( '$blur', a * i * 2 )
				blur:Recompute()

				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRect( -1, -1, ScrW() + 2, ScrH() + 2 )
			end
		else
			colMod['$pp_colour_brightness'] = -0.4 * a
			colMod['$pp_colour_contrast'] = 1 + 0.2 * a
			DrawColorModify(colMod)
		end

		local col = colors.bg
		draw.NoTexture()
		surface.SetDrawColor(col.r, col.g, col.b, a * 100)
		surface.DrawRect(-1, -1, ScrW() + 1, ScrH() + 1)
	end

end)

local clock = Material('octoteam/icons/clock.png')
hook.Add('HUDPaint', 'octolib.afk', function()

	if CFG.drawOverlay and blurState > 0 then
		surface.SetDrawColor(255,255,255, blurState * 255)
		surface.SetMaterial(clock)
		surface.DrawTexturedRect(ScrW() / 2 - 32, ScrH() / 2 - 32, 64, 64)
	end

end)

hook.Add('Think', 'octolib.afk', function()

	if not system.HasFocus() and not isAFK then stopTicking() end
	blurState = math.Approach(blurState, isAFK and 1 or 0, FrameTime() / 2)

end)

startTicking()
