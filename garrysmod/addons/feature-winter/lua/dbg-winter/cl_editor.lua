local frame
local ply = LocalPlayer()
local selMat = 'NATURE/SNOWFLOOR001A'
local selColor = Vector(0.5, 0.5, 0.5)

local backup = {}

local function toggleOverride(matStr)

	local mat = Material(matStr)
	local orig = backup[matStr]
	if orig then
		-- material is snowed, remove it
		if orig.t1 then mat:SetTexture('$basetexture', orig.t1) end
		if orig.t2 then mat:SetTexture('$basetexture2', orig.t2) end
		if orig.col then mat:SetVector('$color', orig.col) end
		backup[matStr] = nil
	else
		-- raw material, make it snow
		local orig = {
			t1 = mat:GetTexture('$basetexture'),
			t2 = mat:GetTexture('$basetexture2'),
			col = mat:GetVector('$color'),
		}

		if not orig.t1 or orig.t1:GetName() == 'error' then orig.t1 = nil end
		if not orig.t2 or orig.t2:GetName() == 'error' then orig.t2 = nil end

		if orig.t1 then mat:SetTexture('$basetexture', selMat) end
		if orig.t2 then mat:SetTexture('$basetexture2', selMat) end
		mat:SetVector('$color', selColor)

		backup[matStr] = orig
	end

end

local function adjustDecal(matPath, alpha)

	local mat = Material(matPath)
	if not mat then return octolib.notify.show('Не удалось найти материал') end

	if alpha then
		alpha = math.Round(alpha or 1, 2)
		backup[matPath] = backup[matPath] or { al = mat:GetFloat('$alpha') or 1 }
		mat:SetFloat('$alpha', alpha)
	elseif backup[matPath] and backup[matPath].al then
		mat:SetFloat('$alpha', backup[matPath].al)
		backup[matPath] = nil
	end

end

local function export()
	return octolib.table.map(backup, function(data, matPath)
		local mat = Material(matPath)
		local out = {}
		if data.t1 then out.t1 = mat:GetTexture('$basetexture'):GetName() end
		if data.t2 then out.t2 = mat:GetTexture('$basetexture2'):GetName() end
		if data.col then out.col = mat:GetVector('$color') end
		if data.al then out.al = mat:GetFloat('$alpha') end
		return out
	end)
end

local function reset()
	for matPath, data in pairs(backup) do
		if data.al then
			adjustDecal(matPath)
		else
			toggleOverride(matPath)
		end
	end

	backup = {}
end

function ImportTextureOverrides(exported)
	reset()

	local oldSnowMat, oldSnowCol = selMat, selColor
	for matPath, data in pairs(exported) do
		if data.al then
			adjustDecal(matPath, data.al)
		else
			selMat = data.t1 or data.t2
			selColor = data.col or Vector(0.5, 0.5, 0.5)
			toggleOverride(matPath)
		end
	end
	selMat, selColor = oldSnowMat, oldSnowCol
end

hook.Add('octolib.configLoaded', 'dbg-winter', function()
	if not CFG.dev then return end

	concommand.Add('texture_editor', function()

		if IsValid(frame) then
			frame:Remove()
			return
		end

		ply = LocalPlayer()

		frame = vgui.Create 'DFrame'
		frame:SetSize(200, 162)
		frame:SetTitle('Редактор текстур')
		frame:AlignLeft(5)
		frame:AlignBottom(5)
		frame:SetKeyboardInputEnabled(false)

		local function addButton(text, func)
			local b = frame:Add 'DButton'
			b:Dock(TOP)
			b:DockMargin(0, 0, 0, 5)
			b:SetTall(25)
			b:SetText(text)
			b.DoClick = func

			frame:SetTall(frame:GetTall() + 30)
			frame:AlignBottom(5)
		end

		octolib.button(frame, selMat, function(self)
			Derma_StringRequest('Смена текстуры', 'Введи путь к текстуре, которая\nбудет использоваться для замены', selMat, function(s)
				selMat = s
				self:SetText(selMat)
			end)
		end)

		local cmSnow = octolib.colorPicker(frame, 'Цвет')
		cmSnow:SetWangs(false)
		cmSnow:SetTall(80)
		cmSnow:SetVector(selColor)
		function cmSnow:ValueChanged()
			selColor = self:GetVector()
		end

		addButton('Редактор текстур: OFF', function(self)
			local active = hook.GetTable().PlayerBindPress.texture_editor == nil
			self:SetText('Редактор текстур: ' .. (active and 'ON' or 'OFF'))

			if active then
				hook.Add('PlayerBindPress', 'texture_editor', function(ply, bind, pressed)
					if ply ~= LocalPlayer() or not pressed then return end

					if bind == '+attack' then
						local tr = util.TraceLine({
							start = ply:GetShootPos(),
							endpos = ply:GetShootPos() + ply:GetAimVector() * 10000,
							filter = ply,
						})

						if not tr.Hit or not tr.HitTexture then return octolib.notify.show('warning', 'Не получилось найти точку попадания') end
						if IsValid(tr.Entity) then
							for _, v in ipairs(tr.Entity:GetMaterials()) do
								toggleOverride(v)
							end
							return
						end

						matStr = tr.HitTexture
						if tr.HitTexture:find('**', 1, true) then return octolib.notify.show('warning', 'Этот тип материала не поддерживается, используй mat_crosshair') end

						toggleOverride(tr.HitTexture)
					end

					if bind == '+attack2' then
						Derma_StringRequest('Заменить текстуру', 'Введи путь к материалу, его можно получить через mat_crosshair', '', toggleOverride)
					end
				end)

				octolib.notify.show('ЛКМ - вкл/выкл перезапись материала, на который смотришь')
				octolib.notify.show('ПКМ - ручной ввод пути материала')
			else
				hook.Remove('PlayerBindPress', 'texture_editor')
			end
		end)

		addButton('Видимые материалы', function()
			RunConsoleCommand('mat_texture_list', '1')
		end)

		addButton('Настроить декаль', function()
			octolib.request.open({{
				name = 'Материал',
				desc = 'Можно получить через mat_crosshair или mat_texture_list',
				type = 'strShort',
			}, {
				name = 'Непрозрачность',
				desc = 'Установи в максимум (1), чтобы вернуть к исходному значению',
				type = 'numSlider',
				val = 1, min = 0, max = 1,
			}}, function(data)
				if not data then return end
				adjustDecal(data[1], data[2])
			end)
		end)

		addButton('Экспорт', function()
			SetClipboardText(pon.encode(export()))
			octolib.notify.show('Данные скопировные в буфер обмена')
		end)

		addButton('Импорт', octolib.fStringRequest('Импорт данных', 'Введи экспортированный код', '', function(s)
			local data = pon.decode(s)
			if not istable(data) then return octolib.notify.show('warning', 'Не получилось раскодировать данные') end

			ImportTextureOverrides(data)
		end))

		addButton('Сбросить все', reset)

	end)

end)

