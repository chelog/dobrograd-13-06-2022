octolib.vars = octolib.vars or {}

netstream.Hook('octolib.getVars', function(vars)
	local res = {}

	if not istable(vars) then vars = { vars } end
	for i, var in ipairs(vars) do
		res[var] = octolib.vars.get(var)
	end

	netstream.Start('octolib.getVars', res)
end)

netstream.Hook('octolib.setVar', octolib.setVar)

--
-- some panel helpers
--

local hookFuncs = {
	DComboBox = function(pnl, _var, hName)
		hook.Add('octolib.setVar', hName, function(var, val)
			if not IsValid(pnl) then
				hook.Remove('octolib.setVar', hName)
				return
			end

			if var ~= _var then return end
			for i, v in ipairs(pnl.Data) do
				if v == val then
					return pnl:ChooseOptionID(i)
				end
			end
		end)
	end,

	DColorMixer = function(pnl, _var, hName)
		hook.Add('octolib.setVar', hName, function(var, val)
			if not IsValid(pnl) then
				hook.Remove('octolib.setVar', hName)
				return
			end

			if var == _var and val ~= pnl:GetColor() then pnl:SetColor(val) end
		end)
	end,

	DTextEntry = function(pnl, _var, hName)
		hook.Add('octolib.setVar', hName, function(var, val)
			if not IsValid(pnl) then
				hook.Remove('octolib.setVar', hName)
				return
			end

			if var == _var and val ~= pnl:GetText() then pnl:SetText(val) end
		end)
	end,

	other = function(pnl, _var, hName)
		hook.Add('octolib.setVar', hName, function(var, val)
			if not IsValid(pnl) then
				hook.Remove('octolib.setVar', hName)
				return
			end

			if var == _var and pnl:GetValue() ~= val then pnl:SetValue(val) end
		end)
	end,
}

local nextPanelID = 1
local function setupHooks(pnl, _var)
	pnl.octoVarID = nextPanelID
	nextPanelID = nextPanelID + 1

	local hName = 'octolib.panel' .. pnl.octoVarID
	local addHook = hookFuncs[pnl:GetTable().ThisClass] or hookFuncs.other

	addHook(pnl, _var, hName)
	pnl.OnRemove = function() hook.Remove('octolib.setVar', hName) end
end

function octolib.vars.slider(pnl, var, txt, min, max, prc)
	local e = octolib.slider(pnl, txt, min, max, prc)
	e:SetValue(tonumber(octolib.vars.get(var)) or min)
	e.OnValueChanged = function(self, val)
		octolib.vars.set(var, math.Round(val, prc))
	end
	setupHooks(e, var)

	return e
end

function octolib.vars.checkBox(pnl, var, txt)
	local e = octolib.checkBox(pnl, txt)
	e:SetValue(octolib.vars.get(var) or false)
	e.OnChange = function(self, val)
		octolib.vars.set(var, val)
	end
	setupHooks(e, var)

	return e
end

function octolib.vars.textEntry(pnl, var, txt)
	local e, t = octolib.textEntry(pnl, txt)
	e:SetUpdateOnType(true)
	e:SetValue(tostring(octolib.vars.get(var)) or '')
	e.OnValueChange = function(self, val)
		octolib.vars.set(var, val)
	end
	setupHooks(e, var)

	return e, t
end

function octolib.vars.comboBox(pnl, var, txt, choices)
	choices = choices or {}
	local curVar = octolib.vars.get(var)
	for i, v in ipairs(choices) do
		v[3] = curVar == v[2]
	end

	local e, t = octolib.comboBox(pnl, txt, choices)
	e.OnSelect = function(self, i, name, val)
		octolib.vars.set(var, val)
	end
	setupHooks(e, var)

	return e, t
end

function octolib.vars.binder(pnl, var, txt, value)
	local e, t = octolib.binder(pnl, txt, value)
	e:SetValue(tonumber(octolib.vars.get(var)) or 0)
	e.OnChange = function(self, val)
		octolib.vars.set(var, tonumber(val))
	end
	setupHooks(e, var)

	return e, t

end

function octolib.vars.colorPicker(pnl, var, txt, alpha, palette)
	local e, t = octolib.colorPicker(pnl, txt, alpha, palette)
	e:SetColor(octolib.vars.get(var) or Color(255,255,255))
	e.ValueChanged = function(self, val)
		if octolib.vars.get(var) ~= val then
			octolib.vars.set(var, val)
		end
	end
	setupHooks(e, var)

	return e, t
end

function octolib.vars.presetManager(pnl, path, vars)
	local wrap = pnl.AddItem and pnl:AddItem('DPanel') or pnl:Add('DPanel')
	wrap:DockMargin(10, 10, 10, 0)
	wrap:Dock(TOP)
	wrap:SetTall(20)
	wrap:SetText('')

	local sel = wrap:Add('DComboBox')
	sel:Dock(FILL)

	path = 'presets.' .. (path or '')
	local function rebuild()
		sel:Clear()
		local data = octolib.vars.get(path) or {}
		for _, v in ipairs(data) do
			sel:AddChoice(v[1], v[2])
		end
	end
	rebuild()

	local iconDelete = wrap:Add('DImageButton')
	iconDelete:Dock(RIGHT)
	iconDelete:SetWide(20)
	iconDelete:SetStretchToFit(false)
	iconDelete:SetImage('octoteam/icons-16/cross.png')
	iconDelete:AddHint('Удалить шаблон')
	function iconDelete:DoClick()
		Derma_Query('Ты точно хочешь удалить этот шаблон?', 'Удаление шаблона', 'Да', function()
			local id = sel:GetSelectedID()
			if not id or id < 1 then return end
			local data = octolib.vars.get(path) or {}
			table.remove(data, id)
			octolib.vars.set(path, table.Copy(data))
			rebuild()
		end, 'Нет')
	end
	iconDelete:SetVisible(false)

	local iconSave = wrap:Add('DImageButton')
	iconSave:Dock(RIGHT)
	iconSave:SetWide(20)
	iconSave:SetStretchToFit(false)
	iconSave:SetImage('octoteam/icons-16/file_save_as.png')
	iconSave:AddHint('Обновить шаблон')
	function iconSave:DoClick()
		local id = sel:GetSelectedID()
		if not id then return end
		local data = octolib.vars.get(path) or {}
		data = data[id] or {}
		Derma_StringRequest('Обновление шаблона', 'Укажи новое название шаблона', data[1] or '', function(name)
			name = string.Trim(name)
			if name == '' then return end

			local data = {}
			for _, v in ipairs(vars) do
				data[v] = octolib.vars.get(v)
			end

			local vars = octolib.vars.get(path) or {}
			vars[id] = {name, data}
			octolib.vars.set(path, table.Copy(vars))
			rebuild()
			sel:ChooseOptionID(id)

		end, nil, 'Обновить', 'Отмена')
	end
	iconSave:SetVisible(false)

	local iconCreate = wrap:Add('DImageButton')
	iconCreate:Dock(RIGHT)
	iconCreate:SetWide(20)
	iconCreate:SetStretchToFit(false)
	iconCreate:SetImage('octoteam/icons-16/plus.png')
	iconCreate:AddHint('Создать шаблон')
	function iconCreate:DoClick()
		Derma_StringRequest('Создание шаблона', 'Укажи название нового шаблона', '', function(name)
			name = string.Trim(name)
			if name == '' then return end

			local data = {}
			for _, v in ipairs(vars) do
				data[v] = octolib.vars.get(v)
			end

			local vars = octolib.vars.get(path) or {}
			vars[#vars + 1] = {name, data}
			octolib.vars.set(path, table.Copy(vars))
			rebuild()
			sel:ChooseOptionID(#vars)

		end, nil, 'Создать', 'Отмена')
	end

	function sel:OnSelect(_, _, data)
		for k, v in pairs(data or {}) do
			octolib.vars.set(k, v)
		end

		iconDelete:SetVisible(true)
		iconSave:SetVisible(true)
	end
end
