-- local cols = {
-- 	bg = Color(0,0,0, 100),
-- 	bgOwned = Color(50,100,35, 150),
-- 	bgSelected = Color(0,0,0, 120),
-- 	bgHover = Color(255,255,255, 10),
-- }

surface.CreateFont('car-dealer.button.title', {
	font = 'Roboto',
	size = 20,
	weight = 500,
	antialias = true,
	extended = true,
})

local PANEL = {}

function PANEL:Init()

	self:SetText('')
	self:Dock(LEFT)
	self:DockMargin(0, 0, 5, 0)
	self:SetWide(135)

	local m = self:Add 'cd_vehModel'
	m:SetMouseInputEnabled(false)
	self.mdl = m

	local l = m:Add 'DLabel'
	l:Dock(BOTTOM)
	l:SetTall(40)
	l:SetContentAlignment(5)
	l:SetFont('car-dealer.button.title')
	l:SetText('Автомобиль')
	self.title = l

	local tp = self:Add 'DPanel'
	tp:SetPaintBackground(false)
	tp:SetPos(20, 5)
	tp:SetSize(95, 16)
	tp:SetTall(16)
	self.tags = tp

end

function PANEL:AddTag(tag)
	local icon = self.tags:Add 'DImageButton'
	icon:Dock(RIGHT)
	icon:DockMargin(5, 0, 0, 0)
	icon:SetWide(16)
	icon:SetImage(tag[1])
	icon:AddOctoHint(tag[2])
	self.tags:SetVisible(true)
end

function PANEL:SetVehicle(vehID, data)

	data = data or {}

	local cdData = carDealer.vehicles[vehID]
	if not cdData then return end

	self.vehID = vehID
	self.mdl:SetVehicle(vehID, data)
	self.title:SetText(data.plate or cdData.name)

	self.tags:Clear()
	self.tags:SetVisible(false)
	local tags = table.Copy(cdData.tags or {})
	hook.Run('car-dealer.populateTags', vehID, cdData, tags)
	for _, tag in ipairs(tags) do
		if not data.id or tag[3] then self:AddTag(tag) end
	end

	self.data = data

end

function PANEL:Paint()

	-- nothing... yet

end

function PANEL:DoClick()

	carDealer.menu.viewer:SetVehicle(self.vehID, self.data)

	-- local vehName = self.vehName
	-- if not vehName then return end

	-- local me
	-- for k,p in ipairs(self:GetParent():GetChildren()) do
	-- 	p.selected = nil
	-- 	if p == self then me = k end
	-- end
	-- self.selected = true
	-- carDealer.perCategorieSels[self.dealer] = self.vehID or me

	-- local pnl = carDealer.curPage
	-- if not IsValid(pnl) or not IsValid(carDealer.viewer) then return end

	-- carDealer.viewer:SetVeh(self.vehData or self.vehName, self.vehID)

end

vgui.Register('cd_vehButton', PANEL, 'DButton')
