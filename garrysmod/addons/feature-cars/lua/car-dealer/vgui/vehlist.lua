local PANEL = {}

function PANEL:Init()

	self:Dock(BOTTOM)
	self:SetTall(140)

end

function PANEL:Refresh()

	if self.lastOwned then
		self.changesOwned = octolib.table.diff(self.lastOwned, carDealer.cache.owned)
		self.changesCategories = octolib.table.diff(self.lastCategories, carDealer.cache.categories)
	else
		self.changesOwned = carDealer.cache.owned
		self.changesCategories = carDealer.cache.categories
	end
	self.lastCategories = carDealer.cache.categories
	self.lastOwned = carDealer.cache.owned

	self:RefreshGarage()

	local items = self:GetItems()
	for i = #items, 2, -1 do
		local item = items[i]
		if item and IsValid(item.Tab) and #self.changesCategories > 0 then
			self:CloseTab(item.Tab, true)
		end
	end

	if not carDealer.cache.categories then return end

	if #self.changesCategories > 0 then
		for _, catID in pairs(carDealer.cache.categories) do
			self:AddCategory(catID)
		end
	end

	self:SwitchToName(self.lastTab)

end

function PANEL:AddCategory(catID)

	local data = carDealer.categories[catID]
	if not data then return end

	local ply = LocalPlayer()
	if data.canSee and data.canSee(ply) == false then return end

	local name, icon = data.name, data.icon
	local p = vgui.Create 'DPanel'
	local item = self:AddSheet(name, p, icon)
	item.Tab.catID = catID

	local scr = p:Add 'DPanel'
	scr:SetPaintBackground(false)
	scr:DockPadding(5, 0, 5, 0)
	function scr:PerformLayout()
		self:SetTall(self:GetParent():GetTall())
	end
	scr:SetWide(10)

	local totalVehicles = 0
	for vehID, veh in SortedPairsByMemberValue(carDealer.vehicles, 'price', false) do
		if (not veh.category or veh.category == catID) and (not veh.canSee or veh.canSee(ply) ~= false) then
			local but = scr:Add 'cd_vehButton'
			but:SetVehicle(vehID)
			scr:SetWide(scr:GetWide() + but:GetWide() + 5)
			totalVehicles = totalVehicles + 1
		end
	end

	carDealer.menu.lists[catID] = scr

end

function PANEL:RefreshGarage()

	local tab = self:GetItems()[1]
	if not tab then
		local p = vgui.Create 'DPanel'
		tab = self:AddSheet('Мой гараж', p, 'icon16/house.png')
		carDealer.menu.lists._garage = p

		if not carDealer.cache.owned then return end

		local scr = p:Add 'DPanel'
		scr:SetPaintBackground(false)
		scr:DockPadding(5, 0, 5, 0)
		function scr:PerformLayout()
			self:SetTall(self:GetParent():GetTall())
		end
		scr:SetWide(10)
		p.scr = scr
	end

	local scr = tab.Panel.scr
	for _, pnl in ipairs(scr:GetChildren()) do
		if pnl.data and pnl.data.id and self.changesOwned[pnl.data.id] then
			pnl:Remove()
		end
	end

	for id, veh in pairs(carDealer.cache.owned) do
		if self.changesOwned[id] then
			local but = scr:Add 'cd_vehButton'
			but:SetVehicle(veh.class, veh)
			scr:SetWide(scr:GetWide() + but:GetWide() + 5)

			if not carDealer.menu.viewer.class then
				but:DoClick()
			end
		end
	end

	self.activeScroller = scr
	timer.Simple(0.5, function()
		self:UpdateCamPositions()
	end)

end

function PANEL:OnActiveTabChanged(_, new)

	self.lastTab = new:GetText()
	self.activeScroller = new:GetPanel():GetChild(0)
	timer.Simple(0, function()
		self:UpdateCamPositions()
	end)

end

function PANEL:UpdateCamPositions()

	if not self.activeScroller then return end

	local x = -self.activeScroller:GetPos()
	local w = self.activeScroller:GetParent():GetSize()
	for _, but in ipairs(self.activeScroller:GetChildren()) do
		local bx = but:GetPos()
		local bx2 = bx + but:GetWide()
		if bx2 > x and bx < x + w then
			local off = w / 2 - ((bx + bx2) / 2 - x)
			local pos = Angle(-10, 90 + off * 0.09, 0):Forward() * 450
			but.mdl:SetCamPos(pos - Vector(0, 0, 15))
			but.mdl:SetLookAng((-pos):Angle())
		end
	end

end

local scrollAreaSize = 40
function PANEL:Think()

	local scr = self.activeScroller
	if not IsValid(scr) then return end

	local cx, cy = self:LocalCursorPos()
	if octolib.math.inRange(cy, 0, self:GetTall()) then
		local w, updated = self:GetWide(), false
		if octolib.math.inRange(cx, 0, scrollAreaSize) then
			local x, y = scr:GetPos()
			local newX = math.Clamp(x + math.ceil(FrameTime() * 250), w - scr:GetWide() - 10, 0)
			if newX > x then
				scr:SetPos(newX, y)
				updated = true
			end
		elseif octolib.math.inRange(cx, w - scrollAreaSize, w) then
			local x, y = scr:GetPos()
			local newX = math.Clamp(x - math.ceil(FrameTime() * 250), w - scr:GetWide() - 10, 0)
			if newX < x then
				scr:SetPos(newX, y)
				updated = true
			end
		end

		if updated then
			self:UpdateCamPositions()
		end
	end

end

function PANEL:CloseTab(tab, removePnl)

	for k, v in pairs(self.Items) do
		if v.Tab == tab then
			table.remove(self.Items, k)
		end
	end

	for k, v in pairs(self.tabScroller.Panels) do
		if v == tab then
			table.remove(self.tabScroller.Panels, k)
		end
	end

	self.tabScroller:InvalidateLayout(true)

	if tab == self:GetActiveTab() then
		local nextItem = self.Items[#self.Items]
		self.m_pActiveTab = nextItem and nextItem.Tab or nil
	end

	local pnl = tab:GetPanel()
	if removePnl then
		pnl:Remove()
	end

	tab:Remove()
	self:InvalidateLayout(true)

	return pnl

end

vgui.Register('cd_vehList', PANEL, 'DPropertySheet')
