local PANEL = {}

function PANEL:Init()

	carDealer.menu = self
	self:Dock(FILL)

	self.lists = {}
	self.viewer = self:Add 'cd_vehViewer'
	self.list = self:Add 'cd_vehList'

end

hook.Add('car-dealer.sync', 'car-dealer.menu', function()
	local m = carDealer.menu
	if not IsValid(m) then return end

	m.pendingRefresh = true
end)

hook.Add('pon.entityCreated', 'octolib.netVar', function(ent, tbl, key)
	local vehTbl = LocalPlayer():GetNetVar('cd.vehicle')
	if tbl == vehTbl then
		local m = carDealer.menu
		if IsValid(m) then m.pendingRefresh = true end
	end
end)

function PANEL:Paint()
	-- no paint
end

function PANEL:Refresh()

	self.list:Refresh()
	self.viewer:Refresh()

end

function PANEL:SetMinimized(val)

	self.minimized = val

	if not val and self.pendingRefresh then
		self:Refresh()
		-- netstream.Start('car-dealer.sync')
	end

end

function PANEL:Think()

	if self.pendingRefresh then
		self.pendingRefresh = nil
		self:Refresh()
	end

end

-- function PANEL:Select(n)
-- 	local pan = self.vehs[n]
-- 	local pos = n-1
-- 	if not pan then
-- 		pan = self.vehs[1]
-- 		pos = 0
-- 	end
-- 	if pan then
-- 		pan:DoClick()
-- 		self.list:GetVBar():AnimateTo(pos * 64 - 32, 0, 0, 1)
-- 	end
-- end

-- function PANEL:SetDealer(dealerID)

-- 	local vl = self.list
-- 	vl:Clear()
-- 	self.vehs = {}

-- 	if not carDealer.categories[dealerID] then return end

-- 	for vehName, veh in SortedPairsByMemberValue(carDealer.vehicles, 'price') do
-- 		if veh.categories and not table.HasValue(veh.categories, dealerID) then continue end

-- 		local b = vgui.Create 'cd_vehButton'
-- 		b:SetVehicle(vehName, nil, dealerID)
-- 		vl:AddItem(b)
-- 		self.vehs[#self.vehs+1] = b
-- 	end
-- 	self.dealerID = dealerID

-- 	hook.Add('car-dealer.sync', 'menu', function()
-- 		if IsValid(self) then self:SetDealer(dealerID) end
-- 	end)

-- end

-- function PANEL:GetDealer()
-- 	return self.dealerID
-- end

vgui.Register('cd_menu', PANEL, 'DPanel')
