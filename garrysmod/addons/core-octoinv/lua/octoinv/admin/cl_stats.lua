local update = octolib.func.debounceStart(function()
	netstream.Request('octoinv.stats'):Then(function(data)
		if IsValid(octoinv.statsWindow) then
			octoinv.statsWindow:Update(data)
		end
	end)
end, 5)

concommand.Add('octoinv_stats', function()
	local me = LocalPlayer()
	if not me:IsSuperAdmin() then return end
	
	if IsValid(octoinv.statsWindow) then
		octoinv.statsWindow:Remove()
	end

	local fr = vgui.Create 'DFrame'
	fr:SetSize(250, 250)
	fr:SetTitle('Выброшенные вещи')
	fr:AlignLeft(30)
	fr:AlignBottom(30)
	octoinv.statsWindow = fr

	local lst = fr:Add 'DListView'
	lst:Dock(FILL)
	lst:AddColumn('Класс')
	lst:AddColumn('Количество')
	lst:SetMultiSelect(false)

	local rowsByUid = {}
	octoinv.statsWindow.items = rowsByUid
	function fr:Update(data)
		local byUid = {}
		for _, item in ipairs(data) do
			byUid[item.uid] = item
			if not rowsByUid[item.uid] then
				local amount = istable(item.data[2]) and item.data[2].amount or isnumber(item.data[2]) and item.data[2] or 1
				rowsByUid[item.uid] = lst:AddLine(item.data[1], amount)
			end
			rowsByUid[item.uid].pos = item.pos
			rowsByUid[item.uid].uid = item.uid
		end
		for k, v in pairs(rowsByUid) do
			if not byUid[k] then
				lst:RemoveLine(v:GetID())
				rowsByUid[k] = nil
			end
		end
		lst:PerformLayout()
	end

	function lst:OnRowSelected(_, line)
		octoinv.statsWindow.selected = line.uid
	end

	function lst:OnRowRightClick(_, line)
		local menu = DermaMenu()
			menu:AddOption('Телепорт', function()
				netstream.Start('octologs.goto', line.pos + Vector(0,0,64), Angle(0,0,0))
			end)
			menu:AddSpacer()
			menu:AddOption('Удалить', function()
				netstream.Start('octoinv.stats.removeItem', line.uid)
				self:RemoveLine(line:GetID())
				rowsByUid[line.uid] = nil
				self:PerformLayout()
			end)
		menu:Open()
	end

	timer.Create('octoinv.stats.update', 1, 0, update)
	function fr:OnRemove()
		timer.Remove('octoinv.stats.update')
	end

end)

hook.Add('HUDPaint', 'octoinv.stats', function()
	if not IsValid(octoinv.statsWindow) then return end

	local sizeOuter = 8 + 2 * math.sin(CurTime() * 3)
	local sizeInner = sizeOuter / 2
	local offset = sizeInner / 2
	local selected = octoinv.statsWindow.selected
	
	for uid, line in pairs(octoinv.statsWindow.items) do
		if uid == selected then continue end
		local pos = line.pos:ToScreen()
		if pos.visible then
			draw.RoundedBox(sizeInner, pos.x-sizeInner, pos.y-sizeInner, sizeOuter, sizeOuter, color_black)
			draw.RoundedBox(offset, pos.x-offset, pos.y-offset, sizeInner, sizeInner, color_white)
		end
	end

	-- draw selected last so that it's always visible
	sizeOuter, sizeInner, offset = sizeOuter*2, sizeInner*2, offset*2
	if selected then
		local line = octoinv.statsWindow.items[selected]
		if not line then return end
		local pos = line.pos:ToScreen()
		if pos.visible then
			draw.RoundedBox(sizeInner, pos.x-sizeInner, pos.y-sizeInner, sizeOuter, sizeOuter, color_black)
			draw.RoundedBox(offset, pos.x-offset, pos.y-offset, sizeInner, sizeInner, color_red)
		end
	end

end)