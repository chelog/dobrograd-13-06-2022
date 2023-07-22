concommand.Add('octolib_rendermodel', function()
	local dest = {
		width = 16,
		height = 16,
		model = 'models/props_junk/garbage_bag001a.mdl',
		skin = 0,
	}
	local renderSettings = {
		camFov = 20,
		camFovMod = 1,
		camPos = Vector(0, 0, 0),
		camAng = Angle(0, 0, 0),
	}

	local frame = vgui.Create 'DFrame'
	frame:SetSize(550, 1000)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle('Настройка рендера модели')

	local preview = frame:Add 'DPanel'
	preview:Dock(TOP)
	preview:SetTall(512)
	function preview:Paint(w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0,0,0))

		local iw, ih = dest.width, dest.height
		local x, y = (w - iw) / 2, (h - ih) / 2
		draw.RoundedBox(4, x, y, iw, ih, Color(85,68,85))

		if not dest.image then return end

		surface.SetMaterial(dest.image)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(x, y, iw, ih)
	end

	-- controls
	local rebuild = octolib.func.debounce(function()
		octolib.renderModel.clear(dest)
		octolib.renderModel.queueRender(dest, renderSettings)
	end, 0.1)

	local eModel = octolib.textEntry(frame, 'Модель')
	eModel:DockMargin(5, 5, 5, 5)
	eModel:SetTall(15)
	eModel:SetPlaceholderText('Модель')
	eModel:SetUpdateOnType(true)
	eModel.PaintOffset = 5
	function eModel:OnValueChange(text)
		dest.model = text
		rebuild()
	end
	eModel:SetValue(dest.model)

	local sWidth = octolib.slider(frame, 'Ширина', 16, 512, 0)
	function sWidth:OnValueChanged(val)
		dest.width = math.Round(val)
		rebuild()
	end
	sWidth:SetValue(dest.width)

	local sHeight = octolib.slider(frame, 'Высота', 16, 512, 0)
	function sHeight:OnValueChanged(val)
		dest.height = math.Round(val)
		rebuild()
	end
	sHeight:SetValue(dest.height)

	local sFov = octolib.slider(frame, 'FOV', 10, 90, 1)
	function sFov:OnValueChanged(val)
		renderSettings.camFov = math.Round(val, 1)
		rebuild()
	end
	sFov:SetValue(renderSettings.camFov)

	local sFovMod = octolib.slider(frame, 'Множитель FOV', 0.2, 2, 2)
	function sFovMod:OnValueChanged(val)
		renderSettings.camFovMod = math.Round(val, 2)
		rebuild()
	end
	sFovMod:SetValue(renderSettings.camFovMod)

	local sPitch = octolib.slider(frame, 'Угол: Pitch', -180, 180, 0)
	function sPitch:OnValueChanged(val)
		local newAngle = Angle(renderSettings.camAng)
		newAngle.p = val
		renderSettings.camAng = newAngle
		rebuild()
	end
	sPitch:SetValue(renderSettings.camAng.p)

	local sYaw = octolib.slider(frame, 'Угол: Yaw', -180, 180, 0)
	function sYaw:OnValueChanged(val)
		local newAngle = Angle(renderSettings.camAng)
		newAngle.y = val
		renderSettings.camAng = newAngle
		rebuild()
	end
	sYaw:SetValue(renderSettings.camAng.y)

	local sRoll = octolib.slider(frame, 'Угол: Roll', -180, 180, 0)
	function sRoll:OnValueChanged(val)
		local newAngle = Angle(renderSettings.camAng)
		newAngle.r = val
		renderSettings.camAng = newAngle
		rebuild()
	end
	sRoll:SetValue(renderSettings.camAng.r)

	local sX = octolib.slider(frame, 'Позиция: X', -50, 50, 1)
	function sX:OnValueChanged(val)
		local newVector = Vector(renderSettings.camPos)
		newVector.x = val
		renderSettings.camPos = newVector
		rebuild()
	end
	sX:SetValue(renderSettings.camPos.x)

	local sY = octolib.slider(frame, 'Позиция: Y', -50, 50, 1)
	function sY:OnValueChanged(val)
		local newVector = Vector(renderSettings.camPos)
		newVector.y = val
		renderSettings.camPos = newVector
		rebuild()
	end
	sY:SetValue(renderSettings.camPos.y)

	local sZ = octolib.slider(frame, 'Позиция: Z', -50, 50, 1)
	function sZ:OnValueChanged(val)
		local newVector = Vector(renderSettings.camPos)
		newVector.z = val
		renderSettings.camPos = newVector
		rebuild()
	end
	sZ:SetValue(renderSettings.camPos.z)

	local bCopy = octolib.button(frame, 'Скопировать код', function()
		local out = ''
		-- out = out .. ('model = \'%s\',\n'):format(eModel:GetValue())
		-- out = out .. ('width = %d,\n'):format(sWidth:GetValue())
		-- out = out .. ('height = %d,\n'):format(sHeight:GetValue())
		out = out .. ('camFov = %d,\n'):format(sFov:GetValue())
		out = out .. ('camFovMod = %.2f,\n'):format(sFovMod:GetValue())

		local camAng = Angle(sPitch:GetValue(), sYaw:GetValue(), sRoll:GetValue())
		out = out .. ('camAng = Angle(%d, %d, %d),\n'):format(camAng.p, camAng.y, camAng.r)

		local camPos = Vector(sX:GetValue(), sY:GetValue(), sZ:GetValue())
		out = out .. ('camPos = Vector(%.1f, %.1f, %.1f),\n'):format(camPos.x, camPos.y, camPos.z)

		SetClipboardText(out)
	end)
	bCopy:Dock(BOTTOM)
end)
