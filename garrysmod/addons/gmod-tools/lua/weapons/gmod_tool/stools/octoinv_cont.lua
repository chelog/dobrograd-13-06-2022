TOOL.Category = 'Dobrograd'
TOOL.Name = L.inventory
TOOL.Command = nil

TOOL.Information = {
	{ name = 'left' },
	{ name = 'right' },
	{ name = 'reload' },
}

octolib.vars.init('tools.octoinv.data', {})
octolib.vars.init('tools.octoinv.password', '')
octolib.vars.init('tools.octoinv.soundURL', '')
octolib.vars.init('tools.octoinv.soundFile', octolib.vars.get('tools.octoinv.sound') or '')

local function doEffect(ent)

	local e = EffectData()
	e:SetEntity(ent)
	e:SetScale(1)
	util.Effect('sparkling_ent', e)

end

local function doConts(ent, data)

	ent:ImportInventory(data)
	ent.lootable = true
	if not ent:GetNetVar('dbgLook') then
		ent:SetNetVar('dbgLook', {
			name = '',
			desc = L.can_be_searched,
			time = 1,
		})
	end

end

function TOOL:LeftClick(tr)

	local ent = tr.Entity
	if not IsValid(ent) or ent:IsPlayer() or string.StartWith(ent:GetClass(), 'octoinv_') then return false end

	if SERVER then
		local ply = self:GetOwner()
		if not ply:query(L.permissions_create_prop_inventory) then
			ply:Notify('warning', L.no_access_create_inventory)
			return false
		end

		ply:GetClientVar({ 'tools.octoinv.data', 'tools.octoinv.time', 'tools.octoinv.soundURL', 'tools.octoinv.soundFile', 'tools.octoinv.period', 'tools.octoinv.password' }, function(vars)
			local data = vars['tools.octoinv.data']
			if #data < 1 then return end

			local inv, time = {}, vars['tools.octoinv.time']
			for i, cont in ipairs(data) do
				if not cont.id then return end
				inv[cont.id] = {
					name = cont.name or L.container,
					icon = cont.icon or 'octoteam/icons/box.png',
					volume = cont.volume or 10,
					craft = cont.craft,
				}
			end

			local soundURL, soundFile, period = string.Trim(vars['tools.octoinv.soundURL']), string.Trim(vars['tools.octoinv.soundFile'])
			if soundURL == '' then soundURL = nil end
			if soundFile == '' then soundFile = nil end
			if soundURL or soundFile then
				period = math.Clamp(isnumber(vars['tools.octoinv.period']) and vars['tools.octoinv.period'] or 1, 1, 100)
			end

			if not ply:query('DBG: Изменять звук обыска') then
				soundURL, soundFile, period = nil
			end

			local password = string.Trim(vars['tools.octoinv.password'] or '')
			if password == '' then password = nil end

			if ent.inv then ent.inv:Remove() end
			doConts(ent, inv)
			doEffect(ent)
			ent.lootData = {
				time = time,
				soundURL = soundURL,
				soundFile = soundFile,
				period = period,
			}
			ent.password = password
			duplicator.StoreEntityModifier(ent, 'octoinv', {
				lootTime = time,
				lootSoundURL = soundURL,
				lootSoundFile = soundFile,
				lootPeriod = period,
				inv = inv,
				password = password,
			})
		end)
	end

	return true

end

-- function TOOL:RightClick(tr)

-- 	if SERVER then return false end

-- 	local ent = tr.Entity
-- 	local look = IsValid(ent) and ent:GetNetVar('dbgLook')
-- 	if not look then return false end

-- 	octolib.vars.set('tools.desc.name', look.name)

-- 	return true

-- end

function TOOL:Reload(tr)

	if CLIENT then return true end

	local ply = self:GetOwner()
	if not ply:query(L.permissions_create_prop_inventory) then
		ply:Notify('warning', L.no_access_create_inventory)
		return false
	end

	local ent = tr.Entity
	if not IsValid(ent) or ent:IsPlayer() or string.StartWith(ent:GetClass(), 'octoinv_') or not ent.inv then return false end

	ent.inv:Remove()
	doEffect(ent)
	ent.lootable = nil
	ent.lootData = nil
	ent.password = nil
	duplicator.ClearEntityModifier(ent, 'octoinv')

	local look = ent:GetNetVar('dbgLook')
	if look and look.desc == L.can_be_searched then
		ent:SetNetVar('dbgLook', nil)
	end

	return true

end

local contList
local function rebuildList()

	if not IsValid(contList) then return end
	contList:Clear()

	local contData = octolib.vars.get('tools.octoinv.data')
	contData = contData and table.Copy(contData) or {}

	local bSave = vgui.Create 'DButton'
	bSave:SetParent(contList)
	bSave:Dock(TOP)
	bSave:SetTall(0)
	bSave:DockMargin(0, 0, 0, 5)
	bSave:SetText(L.save_changes)
	function bSave:DoClick()
		octolib.vars.set('tools.octoinv.data', contData)
	end

	local active = false
	local function changed()
		if active then return end
		active = true
		bSave:SizeTo(bSave:GetWide(), 30, 0.5, 0, -1)
	end

	for i, cont in ipairs(contData) do
		local cp = contList:Add(cont.name)

		local del = cp.Header:Add 'DButton'
		del:SetPaintBackground(false)
		del:SetText('')
		del:SetSize(24, 20)
		del:SetIcon('icon16/cross.png')
		del:SetToolTip(L.delete_container)
		function del:DoClick()
			table.remove(contData, i)
			octolib.vars.set('tools.octoinv.data', contData)
		end

		function cp.Header:PerformLayout()
			del:AlignRight()
		end

		local p = vgui.Create 'DPanel'
		p:DockPadding(5, 5, 5, 5)

		local e1 = octolib.textEntry(p, L.title)
		e1:SetValue(cont.name)
		e1:SetUpdateOnType(true)
		function e1:OnValueChange(val) cont.name = val changed() end

		local e2 = octolib.textEntry(p, L.icon)
		e2:SetValue(cont.icon)
		e2:SetUpdateOnType(true)
		function e2:OnValueChange(val) cont.icon = val changed() end

		local ib = e2:Add 'DButton'
		ib:Dock(RIGHT)
		ib:SetWide(25)
		ib:SetText('')
		ib:SetIcon('icon16/color_swatch.png')
		ib:SetPaintBackground(false)
		function ib:DoClick()
			if IsValid(self.picker) then return end
			self.picker = octolib.icons.picker(function(val) e2:SetValue(val) end, e2:GetValue())
		end

		local e3 = octolib.slider(p, L.inventory_volume, 0.1, 1000, 1)
		e3:SetValue(cont.volume)
		function e3:OnValueChanged(val) cont.volume = math.Round(val, 1) changed() end

		local e4 = octolib.checkBox(p, L.can_craft)
		e4:SetValue(cont.craft)
		function e4:OnChange(val) cont.craft = val and true or nil changed() end

		cp:SetContents(p)
	end

	local bAdd = vgui.Create 'DButton'
	bAdd:SetParent(contList)
	bAdd:Dock(TOP)
	bAdd:SetTall(30)
	bAdd:DockMargin(0, 5, 0, 0)
	bAdd:SetText(L.add_container)
	function bAdd:DoClick()
		local i = #contData + 1
		contData[i] = {
			name = L.container .. i,
			icon = 'octoteam/icons/box1.png',
			volume = 10,
		}

		for i, cont in ipairs(contData) do
			cont.id = 'cont' .. i
		end

		octolib.vars.set('tools.octoinv.data', contData)
	end

end

hook.Add('octolib.setVar', 'tools.octoinv', function(var, val)
	if var == 'tools.octoinv.data' then rebuildList() end
end)

function TOOL:BuildCPanel()

	self:AddControl('Header', {
		Text = L.inventory,
		Description = L.description_inventory
	})

	octolib.vars.slider(self, 'tools.octoinv.time', L.search_time, 0, 20, 1)

	local ply = LocalPlayer()
	if ply:query('DBG: Изменять звук обыска') then

		local tabs = vgui.Create('DPropertySheet')
		self:AddItem(tabs)
		tabs:Dock(TOP)
		tabs:SetTall(90)

		local filePan = tabs:Add('DPanel')
		filePan:SetPaintBackground(false)
		octolib.vars.textEntry(filePan, 'tools.octoinv.soundFile')
		octolib.button(filePan, L.browser_sound, function() RunConsoleCommand('wire_sound_browser_open') end)
		filePan = tabs:AddSheet('Внутриигровой', filePan, 'icon16/cross.png').Tab

		local urlPan = tabs:Add('DPanel')
		urlPan:SetPaintBackground(false)
		octolib.vars.textEntry(urlPan, 'tools.octoinv.soundURL')
		urlPan = tabs:AddSheet('По URL', urlPan, 'icon16/cross.png').Tab

		function tabs:OnActiveTabChanged(old, new)
			if new == filePan then
				octolib.vars.set('tools.octoinv.soundURL', '')
			else
				octolib.vars.set('tools.octoinv.soundFile', '')
			end
		end

		if octolib.vars.get('tools.octoinv.soundURL') ~= '' then tabs:SetActiveTab(urlPan) end

		octolib.vars.slider(self, 'tools.octoinv.period', 'Период', 1, 100, 0)
		self:Help('Период воспроизведения звука измеряется в количестве воспроизведений анимации обыска, например:\n 1 - воспроизводить каждый раз вместе с анимацией обыска;\n 2 - воспроизводить через раз.\nЕсли звук указан, он обязательно воспроизведётся при первой анимации обыска вне зависимости от значения периода')

	end

	octolib.vars.textEntry(self, 'tools.octoinv.password', 'Пароль')

	local p = vgui.Create 'DCategoryList'
	self:AddItem(p)
	p:SetTall(ScrH() - 120)

	contList = p
	rebuildList()

end

if SERVER then

	local lootDistSqr = CFG.useDist * CFG.useDist

	duplicator.RegisterEntityModifier('octoinv', function(ply, ent, data)
		if IsValid(ply) and not ply:query('DBG: Создавать инвентарь у предмета') then return end
		doConts(ent, data.inv)
		if not IsValid(ply) or ply:query('DBG: Изменять звук обыска') then
			ent.lootData = {
				time = data.lootTime,
				soundURL = data.lootSoundURL,
				soundFile = data.lootSoundFile,
				period = data.lootPeriod,
			}
		else
			ent.lootData = { time = data.lootTime }
		end
		ent.password = data.password
	end)

	hook.Add('EntityRemoved', 'tools.octoinv', function(entity)

		if not entity.lootable then
			return
		end

		local entityInventory = entity:GetInventory()
		if not entityInventory then
			return
		end

		entityInventory:Remove(true)

	end, -1)

else

	language.Add('Tool.octoinv_cont.name', L.inventory)
	language.Add('Tool.octoinv_cont.desc', L.add_container_to_prop)
	language.Add('Tool.octoinv_cont.left', L.assign)
	language.Add('Tool.octoinv_cont.right', L.tool_copy)
	language.Add('Tool.octoinv_cont.reload', L.remove)

end
