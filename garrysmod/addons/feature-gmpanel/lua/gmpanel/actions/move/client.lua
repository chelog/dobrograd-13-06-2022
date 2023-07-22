gmpanel.actions.registerAction('move', {
	name = 'Переместить',
	icon = 'octoteam/icons/resize.png',
	openSettings = function(panel, data)
		local posang = octolib.textEntry(panel, 'Позиция и угол')
		posang:SetPlaceholderText('[0 0 0]{0 0 0}')
		if data.pos and data.ang then
			posang:SetValue(('[%d %d %d]{%d %d %d}'):format(data.pos.x, data.pos.y, data.pos.z, data.ang.p, data.ang.y, data.ang.r))
		end
		octolib.button(panel, 'Вставить текущее местоположение', function()
			local pos, ang = LocalPlayer():GetPos(), LocalPlayer():EyeAngles()
			posang:SetValue(('[%d %d %d]{%d %d %d}'):format(pos.x, pos.y, pos.z, ang.p, ang.y, ang.r))
		end):DockMargin(0, 0, 0, 10)
		panel.posang = posang

	end,
	getData = function(panel)

		local text = panel.posang:GetValue()
		local posStr = text:gmatch('%[(.-)%]')()
		local angStr = text:gmatch('%{(.-)%}')()
		if not posStr or not angStr then return end

		local pos = Vector(posStr)
		local ang = Angle(angStr)
		if not isvector(pos) or not isangle(ang) then return end

		return {
			pos = pos,
			ang = ang,
		}

	end,
})
