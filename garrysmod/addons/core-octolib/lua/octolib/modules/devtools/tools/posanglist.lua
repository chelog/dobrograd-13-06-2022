local icon = octolib.icons.silk16('location_pin', 'smooth mips')

concommand.Add('octolib_tool_posanglist', function(ply, cmd, args, argStr)
	if not CFG.dev and not LocalPlayer():IsSuperAdmin() then return end

	local model = argStr:Trim() ~= '' and argStr or 'models/hunter/blocks/cube05x05x05.mdl'

	local showIcons = false
	hook.Add('HUDPaint', 'octolib.posanglist', function()
		if not octolib.flyEditor.active then
			return hook.Remove('HUDPaint', 'octolib.posanglist')
		end

		if not showIcons then return end

		for _, movable in pairs(octolib.flyEditor.movables) do
			local pos = movable.csent:GetPos():ToScreen()
			surface.SetMaterial(icon)
			surface.SetDrawColor(255,255,255, 255)
			surface.DrawTexturedRect(pos.x - 8, pos.y - 8, 16, 16)
		end
	end)

	local function clearMovables()
		for _, movable in pairs(octolib.flyEditor.movables) do
			movable:Remove()
		end
	end

	octolib.flyEditor.start({
		noclip = true,
		maxDist = 0,
		buttons = {
			{'Отображать сквозь карту', octolib.icons.silk32('eye_close'), function(self)
				showIcons = not showIcons
				self:SetImage(showIcons and octolib.icons.silk32('eye') or octolib.icons.silk32('eye_close'))
			end},
			{'Импорт', octolib.icons.silk32('map_add'), function()
				Derma_StringRequest('Импорт данных', 'Введи код, полученный при экспорте', '', function(input)
					for row in input:gmatch('{(.-)}') do
						local posX, posY, posZ = row:match('Vector%((.-),(.-),(.-)%)')
						local angP, angY, angR = row:match('Angle%((.-),(.-),(.-)%)')
						octolib.createMoveable({
							name = 'Позиция',
							model = model,
							pos = Vector(tonumber(posX), tonumber(posY), tonumber(posZ)),
							ang = Angle(tonumber(angP), tonumber(angY), tonumber(angR)),
						})
					end
				end)
			end},
			{'Экспорт', octolib.icons.silk32('map_go'), function()
				local out = {}
				for _, movable in pairs(octolib.flyEditor.movables) do
					local posX, posY, posZ = movable.csent:GetPos():Unpack()
					local angP, angY, angR = movable.csent:GetAngles():Unpack()
					out[#out + 1] = ('{ Vector(%g, %g, %g), Angle(%g, %g, %g) },'):format(posX, posY, posZ, angP, angY, angR)
				end
				SetClipboardText(table.concat(out, '\n'))
			end},
			{'Очистить', octolib.icons.silk32('map_delete'), function()
				clearMovables()
			end},
		},
		canCreate = {
			{'Новая позиция', {
				model = model,
				name = 'Позиция',
			}}
		},
	}, function(movables)

	end)
end)
