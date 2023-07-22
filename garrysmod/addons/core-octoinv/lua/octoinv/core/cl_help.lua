surface.CreateFont('octoinv-help.heading', {
	font = 'Calibri',
	extended = true,
	size = 42,
	weight = 350,
})

surface.CreateFont('octoinv-help.subheading', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
})

local defaultData = {
	amount = 1,
	volume = 0,
	mass = 0,
	name = L.unknown,
	desc = L.not_desc,
	icon = 'octoteam/icons/error.png',
	model = 'models/props_junk/garbage_bag001a.mdl',
}

local function classData(class, field)
	local data = octoinv.items[class]
	return data and data[field] or defaultData[field]
end

local function itemData(item, field)

	local data = octoinv.items[item.class or item[1]]
	return istable(item[2]) and item[2][field] or item[field] or (data and data[field]) or defaultData[field]

end

local function iconPath(icon, class)

	if not icon then
		return class and classData(class, 'icon') or defaultData.icon
	elseif isstring(icon) then
		return icon
	else
		return icon:GetName() .. '.png'
	end

end

local function craftIcon(craft)

	if istable(craft) and istable(craft.finish) and istable(craft.finish[1]) then
		return iconPath(itemData(craft.finish[1], 'icon'))
	elseif isstring(craft.icon) then
		return iconPath(craft.icon)
	else
		return defaultData.icon
	end

end


--
-- CRAFT AND STUFF MANUAL
--

surface.CreateFont('octoinv-help.heading', {
	font = 'Calibri',
	extended = true,
	size = 42,
	weight = 350,
})

surface.CreateFont('octoinv-help.subheading', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
})

local contNames = {
	printer = L.printer,
	printer_cart = L.printer_cart,
	refinery = L.refinery,
	refinery_fuel = L.refinery_fuel,
	smelter = L.smelter,
	smelter_fuel = L.smelter_fuel,
	machine = L.machine,
	machine_tray = L.machine_tray,
	workbench = L.workbench,
	fridge = L.fridge,
	stove = L.stove,
	oven = L.oven,
	_hand = L.inventory_hands,
}

function octoinv.initHelp()

	if IsValid(octoinv.helpPnl) then octoinv.helpPnl:Remove() end

	local ps = vgui.Create 'DPropertySheet'
	ps:SetSize(800, 600)
	octoinv.helpPnl = ps

	concommand.Add('octoinv_help', function()
		if not IsValid(octoinv.helpPnl) then octoinv.initHelp() end
		octoinv.helpPnl:SetVisible(not octoinv.helpPnl:IsVisible())
	end)

	local matArrow = Material('octoteam/icons/arrow_left2.png')
	local matAction = Material('octoteam/icons/error.png')
	local function paintIcon(self, w, h)
		surface.SetDrawColor(255,255,255, 255)
		surface.SetMaterial(self.icon)
		surface.DrawTexturedRect(w/2 - 32, h/2 - 32, 64, 64)
		if self.text then
			draw.Text({
				text = self.text,
				pos = { w/2 + 3, h/2 - 1 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				color = color_white,
			})
		end
	end

	do -- crafts
		local p = ps:Add 'DPanel'
		p:SetPaintBackground(false)

		local d = p:Add 'DScrollPanel'
		d:Dock(FILL)
		d.pnlCanvas:DockPadding(10,10,10,10)

		local lv = p:Add 'DListView'
		lv:Dock(LEFT)
		lv:SetWide(250)
		lv:SetHideHeaders(true)
		lv:DockMargin(0,0,5,0)
		lv:AddColumn(''):SetFixedWidth(32)
		lv:AddColumn(L.title)
		lv:SetDataHeight(32)
		lv:SetMultiSelect(false)
		function lv:OnRowSelected(i, line)
			d:Clear()
			local craft = line.craft

			local p1 = d:Add 'DPanel'
			p1:Dock(TOP)
			p1:DockMargin(0,0,0,10)
			p1:DockPadding(10,5,10,5)
			p1:SetPaintBackground(false)

			local from = p1:Add 'DIconLayout'
			from:Dock(RIGHT)
			from:SetWide(268)
			from:SetSpaceX(4)
			from:SetSpaceY(4)

			if craft.ings and #craft.ings > 0 then
				local l = from:Add 'DLabel'
				l:SetFont('octoinv-help.subheading')
				l:SetSize(268, 30)
				l:SetText(L.ingredients)
				l.OwnLine = true
				for i, item in ipairs(craft.ings) do
					local temp = {class = item[1], amount = item[2]}
					octoinv.createItemPanel(from, temp)
				end
			end
			if craft.tools and #craft.tools > 0 then
				local l = from:Add 'DLabel'
				l:SetFont('octoinv-help.subheading')
				l:SetSize(268, 30)
				l:SetText(L.tools_hint)
				l.OwnLine = true
				for i, item in ipairs(craft.tools) do
					local temp = {class = item[1], amount = item[2]}
					octoinv.createItemPanel(from, temp)
				end
			end
			from:PerformLayout()

			local to = p1:Add 'DIconLayout'
			to:Dock(LEFT)
			to:SetWide(64)
			to:SetSpaceX(4)
			to:SetSpaceY(4)
			if istable(craft.finish) and #craft.finish > 0 then
				local l = to:Add 'DLabel'
				l:SetFont('octoinv-help.subheading')
				l:SetSize(64, 30)
				l:SetText(L.total)
				l.OwnLine = true
				for i, item in ipairs(craft.finish) do
					if istable(item) then
						if istable(item[2]) then
							local temp = {class = item[1]}
							for k, v in pairs(item[2]) do temp[k] = v end
							octoinv.createItemPanel(to, temp)
						else
							octoinv.createItemPanel(to, {class = item[1], amount = item[2] or 1})
						end
					end
				end
			else
				octoinv.createItemPanel(to, {
					class = 'souvenir',
					name = craft.name or L.some_kind_of_action,
					desc = craft.desc or L.not_desc,
					icon = Material(iconPath(craft.icon)),
					mass = 0,
					volume = 0,
				})
			end
			to:PerformLayout()

			local conts = {}
			if craft.conts then
				for i, contID in ipairs(table.GetKeys(craft.conts)) do table.insert(conts, contNames[contID] or contID) end
			end
			if #conts == 0 then table.insert(conts, L.anywhere) end

			local arrow = p1:Add 'DPanel'
			arrow:Dock(FILL)
			arrow:DockMargin(0,32,0,0)
			arrow.Paint = paintIcon
			arrow.text = table.concat(conts, ', ')
			arrow.icon = matArrow

			if craft.jobs and table.Count(craft.jobs) > 0 then
				local txt = {}
				for jobID, _ in pairs(craft.jobs) do
					local job = DarkRP.getJobByCommand(jobID)
					if job and job.name then table.insert(txt, job.name) end
				end

				local l1 = d:Add 'DLabel'
				l1:Dock(TOP)
				l1:SetTall(30)
				l1:SetWrap(true)
				l1:SetFont('octoinv-help.subheading')
				l1:SetText(L.can_do .. table.concat(txt, ', '))
			end

			p1:SizeToChildren(false, true)
			local ph = p1:GetTall()
			p1:SetTall(p1:GetTall() + 10)
			local fh, th = from:GetTall(), to:GetTall()
			if fh ~= th then
				local m = (ph - (fh > th and th or fh)) / 2
				(fh > th and to or from):DockMargin(0, m, 0, m)
			end
		end
		ps:AddSheet(L.recipes, p, octolib.icons.silk16('document_info'))

		for class, craft in SortedPairsByMemberValue(octoinv.crafts, 'name') do
			if craft.name then
				local icon = vgui.Create 'DImage'
				icon:SetImage(craftIcon(craft))
				local line = lv:AddLine(icon, craft.name)
				line.craft = craft
			end
		end
		lv:SelectFirstItem()
	end

	do -- processes
		local p = ps:Add 'DPanel'
		p:SetPaintBackground(false)

		local d = p:Add 'DScrollPanel'
		d:Dock(FILL)
		d.pnlCanvas:DockPadding(10,10,10,10)

		local lv = p:Add 'DListView'
		lv:Dock(LEFT)
		lv:SetWide(250)
		lv:SetHideHeaders(true)
		lv:DockMargin(0,0,5,0)
		lv:AddColumn(''):SetFixedWidth(32)
		lv:AddColumn(L.title)
		lv:SetDataHeight(32)
		lv:SetMultiSelect(false)
		function lv:OnRowSelected(i, line)
			d:Clear()
			local prod = line.prod

			local l1 = d:Add 'DLabel'
			l1:Dock(TOP)
			l1:SetTall(60)
			l1:SetFont('octoinv-help.heading')
			l1:SetText(L.nutrition)
			l1:SetContentAlignment(5)

			if prod.fuel then
				local fuel = d:Add 'DIconLayout'
				fuel:Dock(TOP)
				fuel:SetWide(200)
				fuel:SetSpaceX(4)
				fuel:SetSpaceY(4)
				for contID, items in pairs(prod.fuel) do
					local l = fuel:Add 'DLabel'
					l:SetFont('octoinv-help.subheading')
					l:SetSize(200, 30)
					l:SetText(contNames[contID] or contID)
					l.OwnLine = true
					for class, time in pairs(items) do
						octoinv.createItemPanel(fuel, {
							class = class,
							amount = 1,
							desc = (L.nutrition_hint):format(math.floor(time / 60), time % 60),
						})
					end
				end
				fuel:PerformLayout()
			else
				local l = d:Add 'DLabel'
				l:Dock(TOP)
				l:SetTall(30)
				l:SetFont('octoinv-help.subheading')
				l:SetText(L.not_required)
			end

			local l1 = d:Add 'DLabel'
			l1:Dock(TOP)
			l1:SetTall(60)
			l1:SetFont('octoinv-help.heading')
			l1:SetText(L.process)
			l1:SetContentAlignment(5)

			for i, proc in pairs(prod.prod) do
				local p1 = d:Add 'DPanel'
				p1:Dock(TOP)
				p1:DockMargin(0,0,0,15)
				p1:DockPadding(10,5,10,5)
				-- p1:SetPaintBackground(false)

				local from = p1:Add 'DIconLayout'
				from:Dock(RIGHT)
				from:SetWide(200)
				from:SetSpaceX(4)
				from:SetSpaceY(4)

				local to = p1:Add 'DIconLayout'
				to:Dock(LEFT)
				to:SetWide(132)
				to:SetSpaceX(4)
				to:SetSpaceY(4)

				local arrow = p1:Add 'DPanel'
				arrow:Dock(FILL)
				arrow:DockMargin(0,32,0,0)
				arrow.Paint = paintIcon
				arrow.icon = matArrow
				arrow.text = ('%d:%02d'):format(math.floor(proc.time / 60), proc.time % 60)

				if proc.desc then
					from:SetWide(166)
					local l1 = from:Add 'DLabel'
					l1.OwnLine = true
					l1:SetSize(166, 94)
					l1:SetContentAlignment(4)
					l1:SetWrap(true)
					l1:SetText(proc.desc[1])

					to:SetWide(166)
					local l2 = to:Add 'DLabel'
					l2.OwnLine = true
					l2:SetSize(166, 94)
					l2:SetContentAlignment(4)
					l2:SetWrap(true)
					l2:SetText(proc.desc[2])

					arrow:DockMargin(0,0,0,0)
				else
					for contID, items in pairs(proc.ins) do
						local l = from:Add 'DLabel'
						l:SetFont('octoinv-help.subheading')
						l:SetSize(200, 30)
						l:SetText(contNames[contID] or contID)
						l.OwnLine = true
						for i, item in ipairs(items) do
							local temp = { class = item[1], amount = item[2] }
							octoinv.createItemPanel(from, temp)
						end
					end
					from:PerformLayout()

					for contID, items in pairs(proc.out) do
						local l = to:Add 'DLabel'
						l:SetFont('octoinv-help.subheading')
						l:SetSize(132, 30)
						l:SetText(contNames[contID] or contID)
						l.OwnLine = true
						for i, item in ipairs(items) do
							local chance, class, amountOrData = unpack(item)
							if isstring(chance) then
								chance = nil
								class, amountOrData = unpack(item)
							end
							if istable(item[2]) then
								local temp = {
									class = class,
									status = chance and (chance * 100 .. '%') or nil,
								}
								for k, v in pairs(amountOrData) do temp[k] = v end
								octoinv.createItemPanel(to, temp)
							else
								octoinv.createItemPanel(to, {
									class = class,
									amount = amountOrData or 1,
									status = chance and (chance * 100 .. '%') or nil,
								})
							end
						end
					end
					to:PerformLayout()
				end

				p1:SizeToChildren(false, true)
				local ph = p1:GetTall()
				p1:SetTall(math.max(p1:GetTall() + 10, 104))
				local fh, th = from:GetTall(), to:GetTall()
				if fh ~= th then
					local m = (ph - (fh > th and th or fh)) / 2
					(fh > th and to or from):DockMargin(0, m, 0, m)
				end
			end
		end
		ps:AddSheet(L.process, p, octolib.icons.silk16('clock'))

		for class, prod in SortedPairsByMemberValue(octoinv.prods, 'name') do
			if prod.name then
				local icon = vgui.Create 'DImage'
				icon:SetImage(iconPath(prod.icon))
				local line = lv:AddLine(icon, prod.name)
				line.prod = prod
			end
		end
		lv:SelectFirstItem()
	end

	do -- item ids
		local function lrc(self, id, line)
			local m = DermaMenu()
			m:AddOption(L.copy_id, function() SetClipboardText(line:GetColumnText(2)) end):SetIcon('icon16/page_copy.png')
			m:Open()
		end

		local function irc(self)
			local m = DermaMenu()
			m:AddOption(L.copy_id, function() SetClipboardText(self.itemID) end):SetIcon('icon16/page_copy.png')
			m:Open()
		end

		local sp = ps:Add 'DScrollPanel'
		local li = sp:Add 'DIconLayout'
		li:SetSpaceX(4)
		li:SetSpaceY(4)
		li:Dock(FILL)
		ps:AddSheet(L.items, sp, octolib.icons.silk16('box_search'))
		for class, item in SortedPairsByMemberValue(octoinv.items, 'name') do
			if item.name then
				local temp = {class = class, amount = 1}
				local i = octoinv.createItemPanel(li, temp)
				i.itemID = class
				i.DoRightClick = irc
			end
		end

		local lw = ps:Add 'DListView'
		lw:AddColumn(L.title)
		lw:AddColumn('ID')
		lw:SetMultiSelect(false)
		lw.OnRowRightClick = lrc
		ps:AddSheet(L.weapons, lw, octolib.icons.silk16('gun'))
		for id, wep in SortedPairsByMemberValue(weapons.GetList(), 'PrintName') do
			if wep.PrintName and not wep.HideFromHelp then
				lw:AddLine(wep.PrintName, wep.ClassName)
			end
		end
	end

	octoinv.helpPnl:SetVisible(false)

end
