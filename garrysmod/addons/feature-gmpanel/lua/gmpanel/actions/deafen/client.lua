local curState, tgtState = 0, 0

netstream.Hook('gmpanel.darkenScreen', function(val)
	tgtState = val
end)

hook.Add('PostDrawHUD', 'gmpanel.darkenScreen', function()
	if curState == tgtState and curState == 0 then return end

	local ft = FrameTime()
	-- interpolate the value
	local delta = (tgtState - curState) * (ft < 1 and ft or 1)
	if math.abs(delta) < .01 then
		delta = delta > 0 and .01 or -.01
	end
	if math.abs(tgtState - curState) < .01 then
		delta = tgtState - curState
	end
	curState = curState + delta

	-- apply effects
	if curState ~= 0 then
		local deathColors = {
			[ '$pp_colour_addr' ] = 0,
			[ '$pp_colour_addg' ] = 0,
			[ '$pp_colour_addb' ] = 0,
			[ '$pp_colour_brightness' ] = 0,
			[ '$pp_colour_contrast' ] = 1 - curState * 0.7,
			[ '$pp_colour_colour' ] = 1 - curState,
			[ '$pp_colour_mulr' ] = 0,
			[ '$pp_colour_mulg' ] = 0,
			[ '$pp_colour_mulb' ] = 0
		} DrawColorModify(deathColors)

		if curState > 0.5 then
			local _prc = (curState-.5) / .5
			DrawBloom(0.1, (_prc^3) * 1, 6, 6, 1, 0.25, 1, 1, 1)
		end
	end

end)

gmpanel.actions.registerAction('deafen', {
	name = 'Оглушение',
	icon = 'octoteam/icons/man_mdel.png',
	openSettings = function(panel, data)

		octolib.label(panel, 'Визуальные эффекты затемнения экрана и приглушения звука')

		local screen = octolib.slider(panel, 'Затемнение экрана:', 0, 2, 0)
		screen:SetValue(data.screen or 0)
		panel.screen = screen

		local sound = octolib.slider(panel, 'Приглушение звука:', 0, 2, 0)
		sound:SetValue(data.sound or 0)
		panel.sound = sound

	end,
	getData = function(panel)
		return {
			screen = IsValid(panel.screen) and panel.screen:GetValue() or 0,
			sound = IsValid(panel.sound) and panel.sound:GetValue() or 0,
		}
	end,
})
