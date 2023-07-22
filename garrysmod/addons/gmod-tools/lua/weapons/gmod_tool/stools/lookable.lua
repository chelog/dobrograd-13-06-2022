TOOL.Category = 'Dobrograd'
TOOL.Name = 'Осмотреть'
TOOL.Command = nil

TOOL.Information = {
	{ name = 'left' },
	{ name = 'right' },
	{ name = 'reload' },
}

local vars = {
	pages = {},
	sound = 'ambient/machines/keyboard3_clicks.wav',
	soundVol = 1,
	soundDist = 200,
}

if CLIENT then
	for k, v in pairs(vars) do
		octolib.vars.init('tools.lookable.' .. k, v)
	end
end

local function doEffect(ent)

	local e = EffectData()
	e:SetEntity(ent)
	e:SetScale(1)
	util.Effect('sparkling_ent', e)

end

local varList = octolib.table.map(table.GetKeys(vars), function(v) return 'tools.lookable.' .. v end)

function TOOL:LeftClick(tr)

	local ent = tr.Entity
	if not IsValid(ent) then return false end

	if SERVER then
		if ent:IsPlayer() and not self:GetOwner():IsSuperAdmin() then
			return false
		end

		local ply = self:GetOwner()
		ply:GetClientVar(varList, function(vars)
			local path = vars['tools.lookable.sound'] or ''
			local dist = tonumber(vars['tools.lookable.soundDist']) or 200
			local isURL = path:sub(1, 4) == 'http'

			local data = {
				pages = vars['tools.lookable.pages'] or {},
				sound = string.Trim(path) ~= '' and {
					volume = tonumber(vars['tools.lookable.soundVol']) or 1,

					url = isURL and path or nil,
					dist = isURL and dist or nil,
					distInner = isURL and (dist * 0.1) or nil,

					file = not isURL and path or nil,
					level = not isURL and (dist / 4) or nil,
				},
			}

			doEffect(ent)
			ent.lookableData = data
			duplicator.StoreEntityModifier(ent, 'lookable', data)
		end)
	end

	return true

end

function TOOL:RightClick(tr)

	if SERVER then return false end

	local ent = tr.Entity
	local data = IsValid(ent) and ent.lookableData
	if not data then return false end

	for k,v in pairs(data) do
		octolib.vars.set('tools.lookable.' .. k, v)
	end

	return true

end

function TOOL:Reload(tr)

	if not IsFirstTimePredicted() then return false end

	local ent = tr.Entity
	local data = IsValid(ent) and ent.lookableData
	if not data then return false end

	if SERVER then
		ent.lookableData = nil
		duplicator.ClearEntityModifier(ent, 'lookable')
	end

	doEffect(ent)

	return true

end

function TOOL:BuildCPanel()

	octolib.vars.textEntry(self, 'tools.lookable.sound', 'Звук из игры или по URL')
	self:Button(L.browser_sound, 'wire_sound_browser_open')
	octolib.vars.slider(self, 'tools.lookable.soundVol', 'Громкость звука', 0, 1, 2)
	octolib.vars.slider(self, 'tools.lookable.soundDist', 'Дальность звука', 50, 5000, 0)

	octolib.button(self, 'Редактировать страницы', function()
		octolib.dataEditor.open('tool.lookable.pages')
	end)

	-- fuck DForm
	for _, pnl in ipairs(self:GetChildren()) do
		pnl:DockPadding(10, 0, 10, 0)
	end

end

if CLIENT then
	local function openEditor(save, row)
		local f = vgui.Create 'DFrame'
		f:SetSize(400, 600)
		f:MakePopup()
		f:Center()

		if row then
			octolib.button(f, 'Удалить', function()
				save()
				f:Remove()
			end):DockMargin(0, 0, 0, 5)
		end

		local img = f:Add 'DImage'
		img:Dock(TOP)
		img:SetTall(350)
		img:SetKeepAspect(true)

		local eURL = octolib.textEntry(f, 'Ссылка на изображение')
		eURL:SetUpdateOnType(true)

		local eW = octolib.textEntry(f, 'Ширина в пикселях')
		eW:SetNumeric(true)
		if row and row.w then eW:SetValue(row.w) end

		local eH = octolib.textEntry(f, 'Высота в пикселях')
		eH:SetNumeric(true)
		if row and row.h then eH:SetValue(row.h) end

		local initial = row and string.Trim(row.url) ~= ''
		local function update(self, url)
			if not IsValid(self) then return end
			octolib.getURLMaterial(url, function(mat)
				if not IsValid(self) then return end
				img:SetMaterial(mat)
				if not initial then
					eW:SetValue(tostring(mat:Width()))
					eH:SetValue(tostring(mat:Height()))
				end
				initial = false
			end)
		end
		eURL.OnValueChange = update -- let it load immediately if possible
		if row and row.url then eURL:SetValue(row.url) end
		eURL.OnValueChange = octolib.func.debounce(update, 0.5)

		octolib.button(f, 'Сохранить', function()
			save({
				url = eURL:GetValue(),
				w = tonumber(eW:GetValue()) or 0,
				h = tonumber(eH:GetValue()) or 0,
			})
			f:Remove()
		end)
	end

	octolib.dataEditor.register('tool.lookable.pages', {
		name = 'Осмотреть - Страницы',
		columns = {
			{ field = 'url', name = 'Изображение' },
		},
		load = function(load)
			load(octolib.vars.get('tools.lookable.pages') or {})
		end,
		save = function(rows)
			octolib.vars.set('tools.lookable.pages', rows)
		end,
		new = function(save)
			openEditor(save)
		end,
		edit = function(row, save)
			openEditor(save, row)
		end,
	})

	netstream.Hook('tools.lookable', function(data)
		local cont, overlay
		local sw, sh = ScrW(), ScrH()

		local function openPage(i)
			local page = data.pages[i]
			if not page then return end

			if IsValid(overlay) then overlay:Remove() end
			cont, overlay = octolib.overlay(nil, 'DPanel')
			cont:SetPaintBackground(false)
			overlay:MakePopup()

			local scale = 1
			if page.h > sh then scale = sh / page.h end
			if page.w * scale > sw - 150 then scale = (sw - 150) / page.w end

			local w, h = page.w * scale, page.h * scale
			cont:SetSize(w + 150, h)
			img = cont:Add 'DImage'
			img:SetURL(page.url)
			img:SetSize(w, h)
			img:Center()

			if i ~= #data.pages then
				local bNext = cont:Add 'DImageButton'
				bNext:SetSize(64, 64)
				bNext:SetImage('octoteam/icons/arrow_right.png')
				bNext:SetPos(w + 150 - 5 - 64, (h - 64) / 2)
				function bNext:DoClick()
					openPage(i + 1)
				end
			end

			if i > 1 then
				local bPrev = cont:Add 'DImageButton'
				bPrev:SetSize(64, 64)
				bPrev:SetImage('octoteam/icons/arrow_left.png')
				bPrev:SetPos(5, (h - 64) / 2)
				function bPrev:DoClick()
					openPage(i - 1)
				end
			end
		end
		openPage(1)
	end)

	language.Add('Tool.lookable.name', 'Осмотреть')
	language.Add('Tool.lookable.desc', 'Добавь возможность осмотреть предмет')
	language.Add('Tool.lookable.left', L.assign)
	language.Add('Tool.lookable.right', L.tool_copy)
	language.Add('Tool.lookable.reload', L.remove)
end
