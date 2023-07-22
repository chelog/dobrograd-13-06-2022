TOOL.Category = 'Dobrograd'
TOOL.Name = 'Помещение'
TOOL.Command = nil

TOOL.Information = {
	{ name = 'left' },
	{ name = 'right' },
	{ name = 'reload' },
}

local ways = {'doors', 'markers'}

if CLIENT then

	language.Add('Tool.estates.name', 'Помещения')
	language.Add('Tool.estates.desc', 'Самый лучший тул')

	language.Add('Tool.estates.left.doors', 'Добавить дверь в выбранное помещение')
	language.Add('Tool.estates.right.doors', 'Создать помещение с этой дверью')
	language.Add('Tool.estates.reload.doors', 'Удалить дверь из помещения')
	language.Add('Tool.estates.left.markers', 'Установить маркер для выбранного помещения')
	language.Add('Tool.estates.right.markers', 'Телепортироваться к маркеру выбранного помещения')
	language.Add('Tool.estates.reload.markers', 'Удалить маркер помещения')

	local opt = octolib.vars.get('dbg-estates.option') or 1
	language.Add('Tool.estates.left', language.GetPhrase('Tool.estates.left.' .. tostring(ways[opt])))
	language.Add('Tool.estates.right', language.GetPhrase('Tool.estates.right.' .. tostring(ways[opt])))
	language.Add('Tool.estates.reload', language.GetPhrase('Tool.estates.reload.' .. tostring(ways[opt])))

else
	local nameExamples = {
		'Франклин %d', 'Заправка, город', 'Полиция',
		'Линкольн %d, кв. %d', 'БЦ на Бравери, пав. %d',
		'Дуглас %d', 'Церковь', 'Заправка, пригород'
	}

	local function collectData()
		local data = netvars.GetNetVar('dbg-estates') or {}
		local ans = {}
		for i,v in pairs(data) do
			ans[i] = table.Copy(v)
			local doors = {}
			for _,door in ipairs(v.doors or {}) do
				doors[#doors + 1] = {
					name = ('[%s][%s]'):format(door:EntIndex(), door:GetClass()),
					title = door:GetTitle() or '',
					id = door:EntIndex(),
				}
			end
			ans[i].doors = doors
		end
		return ans
	end

	TOOL.CollectData = collectData

	TOOL.Ways = {
		{ -- doors
			leftClick = function(self, ply, ent, sel)
				if not IsValid(ent) or not ent:IsDoor() then return end
				if not sel or sel == 0 or not dbgEstates.exists(sel) then
					return ply:Notify('Нужно выбрать помещение')
				end
				if ent:GetNetVar('estate') == sel then return end

				dbgEstates.linkDoor(ent, sel)
				netstream.Start(ply, 'dbg-estates.getToolData', collectData())
			end,
			rightClick = function(self, ply, ent)
				if not IsValid(ent) or not ent:IsDoor() then return end
				octolib.request.send(ply, {{
					type = 'strShort',
					name = 'Название помещения',
					desc = 'Обычно название общественного места или адрес',
					ph = nameExamples[math.random(#nameExamples)]:format(math.random(10), math.random(10)),
					required = true,
				}}, function(data)
					local name = istable(data) and utf8.sub(string.Trim(data[1] or 'Помещение'), 1, 32) or 'Помещение'
					local est = ent:GetEstateID()
					if est > 0 then
						dbgEstates.unlinkDoor(ent)
					end
					est = dbgEstates.createEstate(ent, name)
					netstream.Start(ply, 'dbg-estates.getToolData', collectData(), est)
				end)
			end,
			reload = function(self, ply, ent)
				if not IsValid(ent) or not ent:IsDoor() or ent:IsBlocked() then return end
				ent:SetBlocked(true)
				netstream.Start(ply, 'dbg-estates.getToolData', self:CollectData())
			end,
		}, { -- markers
			leftClick = function(self, ply, ent, sel, tr)
				if not sel or sel == 0 or not dbgEstates.exists(sel) then
					return ply:Notify('Нужно выбрать помещение')
				end

				local data = dbgEstates.getData(sel)
				local marker = data.marker or {}
				octolib.request.send(ply, {
					name = {
						type = 'strShort',
						name = 'Название',
						default = marker.name or data.name,
					},
					sort = {
						type = 'numSlider',
						name = 'Порядок в сайдбаре',
						desc = 'Чем больше значение, тем ниже маркер будет находиться в списке. Поставь 0, чтобы оставить по умолчанию',
						min = 0,
						max = 2000,
						dec = 0,
						default = marker.sort or 0,
					},
					icon = {
						type = 'iconPicker',
						name = 'Иконка',
						default = marker.icon,
						path = 'materials/octoteam/icons-16/'
					},
					perma = {
						type = 'check',
						name = 'Видимость',
						txt = 'Маркер всегда виден в карте на F4',
						default = marker.perma,
					},
					group = {
						type = 'strShort',
						name = 'Группа в сайдбаре',
						desc = 'Например, если нужно сделать несколько заправок одним пунктом',
						default = marker.group,
					},
				}, function(res)
					res.group = string.Trim(res.group or '', ' ')
					if res.group == '' then res.group = nil end
					if res.sort == 0 then res.sort = nil end
					local nMarker = {
						name = tostring(res.name or 'Помещение'),
						icon = tostring(res.icon or 'octoteam/icons-16/house.png'),
						pos = tr.HitPos,
						perma = res.perma,
						group = res.group,
						sort = res.sort,
					}
					dbgEstates.updateMarker(sel, nMarker)
					ply:Notify('Маркер обновлен')
					netstream.Start(ply, 'dbg-estates.getToolData', collectData())
				end)
			end,
			rightClick = function(self, ply, ent, sel)
				if not sel or sel == 0 or not dbgEstates.exists(sel) then
					return ply:Notify('Нужно выбрать помещение')
				end

				local data = dbgEstates.getData(sel)
				local marker = data.marker
				if not marker or not marker.pos then
					return ply:Notify('У этого помещения не установлен маркер')
				end
				ply:SetPos(marker.pos)
			end,
			reload = function(self, ply, ent, sel)
				if not sel or sel == 0 or not dbgEstates.exists(sel) then
					return ply:Notify('Нужно выбрать помещение')
				end
				dbgEstates.updateMarker(sel)
				ply:Notify('Маркер удален')
			end,
		}
	}

	netstream.Hook('dbg-estates.getToolData', function(ply)
		if not ply:IsSuperAdmin() then return end
		netstream.Start(ply, 'dbg-estates.getToolData', collectData())
	end)

	netstream.Hook('dbg-estates.goToDoor', function(ply, id)
		if not ply:IsSuperAdmin() then return end
		local ent = ents.GetByIndex(id)
		if not IsValid(ent) or not ent:IsDoor() then return end
		ply:SetPos(ent:LocalToWorld(ent:OBBCenter()))
	end)

	netstream.Hook('dbg-estates.renameDoor', function(ply, id, title)
		if not ply:IsSuperAdmin() then return end
		local ent = ents.GetByIndex(id)
		if not IsValid(ent) or not ent:IsDoor() then return end
		title = utf8.sub(string.Trim(title), 1, 128)
		if title == '' then title = nil end
		ent:SetTitle(title, true)
		netstream.Start(ply, 'dbg-estates.getToolData', collectData())
	end)

	netstream.Hook('dbg-estates.changePrice', function(ply, id, price)
		if not ply:IsSuperAdmin() or not isnumber(id) or id < 1 or not isnumber(price) then return end
		price = math.max(0, math.floor(price))
		dbgEstates.setEstatePrice(id, price)
		ply:Notify('Помещению "' .. tostring(dbgEstates.getData(id).name) .. '" установлена цена ' .. DarkRP.formatMoney(price))
		netstream.Start(ply, 'dbg-estates.getToolData', collectData())
	end)

	netstream.Hook('dbg-estates.changeOwners', function(ply, id, owners)
		if not ply:IsSuperAdmin() or not isnumber(id) or id < 1 or not istable(owners) then return end
		dbgEstates.updateOwners(id, owners)
		netstream.Start(ply, 'dbg-estates.getToolData', collectData())
	end)

	netstream.Hook('dbg-estates.changePurpose', function(ply, id, purpose)
		if not (ply:IsSuperAdmin() and isnumber(id) and isnumber(purpose) and octolib.math.inRange(purpose, 0, 2)) then return end
		dbgEstates.setPurpose(id, purpose)
		ply:Notify('Теперь помещение "' .. tostring(dbgEstates.getData(id).name) .. '" можно использовать только для ' .. (purpose == 1 and 'бизнеса' or 'проживания'))
		netstream.Start(ply, 'dbg-estates.getToolData', collectData())
	end)

end


function TOOL:LeftClick(tr)

	local ply = self:GetOwner()
	if not IsValid(ply) or not ply:IsSuperAdmin() then return false end
	if CLIENT then return true end

	local ent = tr.Entity
	ply:GetClientVar({'dbg-estates.option', 'dbg-estates.sel'}, function(data)
		if not IsValid(ply) or not istable(data) then return end
		local opt, sel = data['dbg-estates.option'], data['dbg-estates.sel']
		if not self.Ways[opt] then return end
		self.Ways[opt].leftClick(self, ply, ent, sel, tr)
	end)
	return true

end

function TOOL:RightClick(tr)

	local ply = self:GetOwner()
	if not IsValid(ply) or not ply:IsSuperAdmin() then return false end
	if CLIENT then return true end

	local ent = tr.Entity
	ply:GetClientVar({'dbg-estates.option', 'dbg-estates.sel'}, function(data)
		if not IsValid(ply) or not istable(data) then return end
		local opt, sel = data['dbg-estates.option'], data['dbg-estates.sel']
		if not self.Ways[opt] then return end
		self.Ways[opt].rightClick(self, ply, ent, sel, tr)
	end)
	return true

end

function TOOL:Reload(tr)

	local ply = self:GetOwner()
	if not IsValid(ply) or not ply:IsSuperAdmin() then return false end
	if CLIENT then return true end

	local ent = tr.Entity
	ply:GetClientVar({'dbg-estates.option', 'dbg-estates.sel'}, function(data)
		if not IsValid(ply) or not istable(data) then return end
		local opt, sel = data['dbg-estates.option'], data['dbg-estates.sel']
		if not self.Ways[opt] then return end
		self.Ways[opt].reload(self, ply, ent, sel, tr)
	end)
	return true

end

local function paint(ent, name)
	local pos = ent:LocalToWorld(ent:OBBCenter()):ToScreen()
	if name then
		draw.DrawText(name, 'f4.normal-sh', pos.x, pos.y, color_black, TEXT_ALIGN_CENTER)
		draw.DrawText(name, 'f4.normal', pos.x, pos.y, color_white, TEXT_ALIGN_CENTER)
	end
	draw.DrawText(tostring(ent:EntIndex()), 'f4.normal-sh', pos.x, pos.y + 25, color_black, TEXT_ALIGN_CENTER)
	draw.DrawText(tostring(ent:EntIndex()), 'f4.normal', pos.x, pos.y + 25, color_white, TEXT_ALIGN_CENTER)
end

local function render3d()
	cam.Start3D()
		local sel = octolib.vars.get('dbg-estates.sel') or 0
		if sel == 0 then return cam.End3D() end
		local data = dbgEstates.getData(sel).doors
		if not data then return cam.End3D() end
		for _,v in ipairs(data) do
			if IsValid(v) then
				local mins, maxs = v:GetCollisionBounds()
				render.DrawWireframeBox(v:GetPos(), v:GetAngles(), mins, maxs, color_red)
			end
		end
	cam.End3D()
end

function TOOL:DrawHUD()
	local ply = self:GetOwner()
	if not IsValid(ply) or not ply:IsSuperAdmin() then return end
	local ent = ply:GetEyeTrace().Entity
	if not IsValid(ent) or not ent:IsDoor() then return render3d() end
	paint(ent, dbgEstates.getData(ent:GetEstateID()).name)
	render3d()
end

local mats = {}
local colors
if CLIENT then
	local matNames = {'door_open', 'map_pin'}
	for _,v in ipairs(matNames) do
		local mat = 'octoteam/icons/' .. v .. '.png'
		Material(mat)
		mats[#mats + 1] = CreateMaterial(mat .. '-ignorez', 'UnlitGeneric', {
			['$basetexture'] = mat,
			['$ignorez'] = 1,
			['$translucent'] = 1,
			['$smooth'] = 1,
		})
	end
	colors = CFG.skinColors
end
function TOOL:DrawToolScreen(w, h)
	draw.RoundedBox(0, 0, 0, w, h, colors.bg)
	local opt = math.max(1, octolib.vars.get('dbg-estates.option') or 1)
	surface.SetMaterial(mats[math.min(#mats, opt)])
	surface.SetDrawColor(255, 255, 255)
	local ww, hh = w * 0.5, h * 0.5
	surface.DrawTexturedRect(ww * 0.5, h * 0.1, ww, hh)
	draw.DrawText('Помещения', 'f4.medium', ww, h * 0.6, color_white, TEXT_ALIGN_CENTER)
	draw.DrawText('powered by Octothorp', 'Trebuchet24', w * 0.95, h * 0.87, color_white, TEXT_ALIGN_RIGHT)
end

local tags = {
	'yellow', 'red', 'purple', 'pink', 'orange', 'green', 'blue',
}
local estList

local function addLine(lst, name, data)
	local cont = lst:Add('DPanel')
	cont:Dock(TOP)
	cont:SetTall(20)
	cont:SetPaintBackground(false)

	local checkBox = cont:Add('DCheckBox')
	checkBox:Dock(LEFT)
	checkBox:SetWide(24)
	lst.owns[data] = checkBox

	local label = cont:Add('DLabel')
	label:SetText(name)
	label:Dock(FILL)
	label:DockMargin(5, 0, 0, 0)
end

local function headerClick(self)
	self.clck(self)
	local id = self:GetParent().id
	for _,v in ipairs(estList:GetCanvas():GetChildren()) do
		if v.id ~= id then
			v:DoExpansion(false)
		end
	end
	octolib.vars.set('dbg-estates.sel', self:GetParent():GetExpanded() and id or nil)
end

local function rebuildList(data, estId)
	if estId then
		octolib.vars.set('dbg-estates.sel', estId)
	end
	if not IsValid(estList) then return end
	estList:Clear()

	for k,est in SortedPairsByMemberValue(data, 'name') do
		local category = estList:Add(est.name or k ~= 0 and 'Помещение' or 'Заблокированные')
		local pnl = vgui.Create('DPanel')

		octolib.label(pnl, 'Помещения:'):DockMargin(5, 5, 5, 5)
		local lst = pnl:Add('DListView')
		lst:Dock(TOP)
		lst:AddColumn('Дверь')
		lst:AddColumn('Табличка')
		local sz = 20
		for _,v in SortedPairsByMemberValue(est.doors or {}, 'name') do
			lst:AddLine(v.name, v.title or '').id = v.id
			sz = sz + 17
		end
		lst:SetTall(sz)
		function lst:OnRowRightClick(_, line)
			local menu = DermaMenu()
			menu:AddOption('Телепортироваться', function()
				netstream.Start('dbg-estates.goToDoor', line.id)
			end):SetIcon('octoteam/icons-16/user_go.png')
			menu:AddOption('Изменить табличку', function()
				Derma_StringRequest('Изменить табличку', 'Укажи новый текст таблички:', line:GetColumnText(2), function(label)
					netstream.Start('dbg-estates.renameDoor', line.id, label)
				end)
			end):SetIcon('octoteam/icons-16/tag_' .. tags[math.random(#tags)] .. '.png')
			menu:Open()
		end

		if k > 0 then

			local price = octolib.textEntry(pnl, 'Стоимость:')
			price:SetNumeric(true)
			price:SetValue(est.price or 0)
			local saveBtn = octolib.button(price, 'Сохранить', function()
				local num = tonumber(price:GetValue()) or 0
				num = math.max(0, math.floor(num))
				netstream.Start('dbg-estates.changePrice', k, num)
			end)
			saveBtn:Dock(RIGHT)
			price.OnValueChange = saveBtn.DoClick

			local owns = pnl:Add('DScrollPanel')
			owns.owns = {}
			owns:Dock(TOP)
			owns:SetTall(100)
			owns:DockMargin(5, 0, 0, 5)
			for i,v in pairs(dbgDoorGroups.groups) do
				addLine(owns, v, 'g:' .. i)
			end
			for _,job in ipairs(RPExtraTeams) do
				addLine(owns, job.name, 'j:' .. job.command)
			end

			for _,v in ipairs(est.owners or {}) do
				if owns.owns[v] then
					owns.owns[v]:SetChecked(true)
				end
			end

			octolib.button(pnl, 'Сохранить владельцев', function()
				local owners = {}
				for id,v in pairs(owns.owns) do
					if v:GetChecked() then
						owners[#owners + 1] = id
					end
				end
				netstream.Start('dbg-estates.changeOwners', k, owners)
			end)

			local purpose = octolib.comboBox(pnl, 'Цель использования:', {{'Без ограничений', 0}, {'Только для бизнеса', 1}, {'Только для проживания', 2}})
			purpose:ChooseOptionID((est.purpose or 0) + 1)
			function purpose:OnSelect(idx)
				netstream.Start('dbg-estates.changePurpose', k, idx-1)
			end

		end

		category.id = k
		category:SetContents(pnl)
		category:SetExpanded(octolib.vars.get('dbg-estates.sel') == k)
		category.Header.clck, category.Header.DoClick = category.Header.DoClick, headerClick
	end
end

function TOOL:BuildCPanel()

	self:AddControl('Header', {
		Text = '#Tool.estates.name',
		Description	= '#Tool.estates.desc'
	})

	octolib.label(self, 'Режим редактирования:')
	local way = vgui.Create('DComboBox')
	self:AddItem(way)
	way:Dock(TOP)
	way:SetTall(30)
	way:AddChoice('Двери', 'doors', false, 'octoteam/icons-16/door.png')
	way:AddChoice('Маркеры', 'markers', false, 'octoteam/icons-16/map.png')
	function way:OnSelect(idx, val, data)
		octolib.vars.set('dbg-estates.option', idx)
		language.Add('Tool.estates.left', language.GetPhrase('Tool.estates.left.' .. data))
		language.Add('Tool.estates.right', language.GetPhrase('Tool.estates.right.' .. data))
		language.Add('Tool.estates.reload', language.GetPhrase('Tool.estates.reload.' .. data))
	end
	way:ChooseOptionID(octolib.vars.get('dbg-estates.option') or 1)

	local p = vgui.Create 'DCategoryList'
	self:AddItem(p)
	p:SetTall(ScrH() - 310)

	octolib.button(self, 'Обновить', function()
		netstream.Start('dbg-estates.getToolData')
	end):Dock(BOTTOM)

	estList = p
	netstream.Hook('dbg-estates.getToolData', rebuildList)
	netstream.Start('dbg-estates.getToolData')

end

