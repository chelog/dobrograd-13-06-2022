octomap.markers = octomap.markers or {}
octomap.clickableMarkers = octomap.clickableMarkers or {}
octomap.nextMarkerID = octomap.nextMarkerID or 1

octomap.metaMarker = octomap.metaMarker or {}

local config = octomap.config
local Marker = octomap.metaMarker
Marker.__index = Marker

local defaults = {
	icon = 'icon16/house.png',
	iconOffset = {0, 0},
	iconSize = 16,
}

local icons = {
	layerUp = Material('octoteam/icons-16/bullet_up.png'),
	layerDown = Material('octoteam/icons-16/bullet_down.png'),
}

function octomap.getMarker(id)

	return octomap.markers[id]

end

function octomap.createMarker(id)

	if not id then
		id = octomap.nextMarkerID
		octomap.nextMarkerID = octomap.nextMarkerID + 1
	end

	octomap.markers[id] = octomap.markers[id] or {}

	local marker = octomap.markers[id]
	marker.id = id
	marker.thinkAfter = 0
	setmetatable(marker, Marker)

	marker:SetPos(0,0,0)
	marker:SetIcon(defaults.icon)
	marker:SetIconOffset(unpack(defaults.iconOffset))
	marker:SetIconSize(defaults.iconSize)

	return marker

end

function Marker:Paint(x, y, map)

	local permanent = self.permanent
	if permanent then
		surface.DisableClipping(true)
		x = math.Clamp(x, 0, map:GetWide())
		y = math.Clamp(y, 0, map:GetTall())
	end

	local otherLayer = self.layer and self.layer ~= config.mapLayer
	if otherLayer then surface.SetAlphaMultiplier(0.35) end

	local iconX, iconY = x + self.iconOffX - self.iconHalfSize, y + self.iconOffY - self.iconHalfSize
	surface.SetMaterial(self.icon)
	if self.color then
		surface.SetDrawColor(self.color)
	else
		surface.SetDrawColor(255,255,255, 255)
	end
	surface.DrawTexturedRect(iconX, iconY, self.iconSize, self.iconSize)
	surface.SetAlphaMultiplier(1)

	if otherLayer then
		surface.SetMaterial(self.layer > config.mapLayer and icons.layerUp or icons.layerDown)
		surface.SetDrawColor(255,255,255, 200)
		surface.DrawTexturedRect(iconX + self.iconSize - 14, iconY + self.iconSize - 14, self.iconSize, self.iconSize)
	end

	if permanent then
		surface.DisableClipping(false)
	end

end

function Marker:SetIcon(path)

	self.iconPath = path or defaults.icon
	self.icon = Material(self.iconPath)
	return self

end

function Marker:SetIconSize(size)

	self.iconSize = size or defaults.iconSize
	self.iconHalfSize = self.iconSize / 2
	return self

end

function Marker:SetIconOffset(x, y)

	self.iconOffX = x or defaults.iconOffset[1]
	self.iconOffY = y or defaults.iconOffset[2]

	return self

end

function Marker:Remove()

	if self.clickable then self:SetClickable(false) end
	self.removed = true
	octomap.markers[self.id] = nil

	if self.sidebarData then
		hook.Run('octomap.addedToSidebar', self)
	end

end

function Marker:SetID(id)

	local m = octomap.getMarker(id)
	if m then m:Remove() end

	self.id = id
	octomap.markers[id] = self

	return self

end

function Marker:SetPos(x, y, z)

	x, y = x or 0, y or 0
	self.x, self.y, self.z = octomap.worldToMap(x, y, z)
	self.cachedWorldX, self.cachedWorldY = nil
	if config.getMapLayer then
		self.layer = config.getMapLayer(self.z or 0)
	end

	return self

end

function Marker:GetPos()

	if not self.cachedWorldX then
		self.cachedWorldX, self.cachedWorldY = octomap.mapToWorld(self.x, self.y)
	end

	return self.cachedWorldX, self.cachedWorldY

end

function Marker:SetMapPos(x, y, z)

	x, y = x or 0, y or 0
	self.x, self.y = x, y 
	self.z = z or self.z
	self.cachedWorldX, self.cachedWorldY = nil
	if config.getMapLayer then
		self.layer = config.getMapLayer(self.z or 0)
	end

	return self

end

function Marker:GetMapPos(x, y)

	return self.x, self.y

end

function Marker:SetColor(col)

	self.color = col
	return self

end

function Marker:SetClickable(val)

	if val and not self.clickable then
		if not table.HasValue(octomap.clickableMarkers, self) then
			octomap.clickableMarkers[#octomap.clickableMarkers + 1] = self
			self.clickable = true
		end
	elseif not val and self.clickable then
		table.RemoveByValue(octomap.clickableMarkers, self)
		self.clickable = nil
	end

	return self

end

function Marker:SetPermanent(val)

	self.permanent = val or nil
	return self

end

function Marker:SetVisible(val)

	self.hidden = val == false or nil
	return self

end

function Marker:AddToSidebar(name, id)

	self.sidebarData = {
		name = name,
		id = id,
	}

	hook.Run('octomap.addedToSidebar', self)
	return self

end

-- to be overridden
function Marker:LeftClick(map) end
function Marker:RightClick(map) end
