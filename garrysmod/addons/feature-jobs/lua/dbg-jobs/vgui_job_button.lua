local colHover = Color(0,0,0, 30)

local function iconAndLabel(parent, iconPath, text, iconWidth, iconMargin)
	local icon = parent:Add 'DImage'
	icon:Dock(LEFT)
	icon:SetWide(iconWidth or 16)
	icon:DockMargin(0, 0, iconMargin or 4, 0)
	icon:SetImage(iconPath)

	local label = parent:Add 'DLabel'
	label:Dock(FILL)
	label:SetContentAlignment(4)
	label:SetText(text)

	return icon, label
end

local PANEL = {}

function PANEL:Init()
	self:Dock(TOP)
	self:SetTall(48)

	self.icon = self:Add 'DImage'
	self.icon:Dock(LEFT)
	self.icon:DockMargin(8, 8, 8, 8)
	self.icon:SetWide(32)

	self.title = self:Add 'DLabel'
	self.title:Dock(FILL)
	self.title:SetFont('dbg-jobs.title')
	self.title:SetText('...')

	local right = self:Add 'DPanel'
	right:Dock(RIGHT)
	right:SetWide(70)
	right:SetPaintBackground(false)
	right:SetMouseInputEnabled(false)

	self.time = right:Add 'DPanel'
	self.time:Dock(TOP)
	self.time:SetTall(16)
	self.time:DockMargin(0, 6, 0, 4)
	self.time:SetPaintBackground(false)
	self.time.icon, self.time.label = iconAndLabel(self.time, 'icon16/time.png', '...')

	self.reward = right:Add 'DPanel'
	self.reward:Dock(TOP)
	self.reward:SetTall(16)
	self.reward:SetPaintBackground(false)
	self.reward.icon, self.reward.label = iconAndLabel(self.reward, 'icon16/money.png', '...')

	self:SetText('')
end

function PANEL:SetJob(mainPanel, publishData, startData)
	local time = publishData.timeout and (math.floor(publishData.timeout / 60) .. ' мин') or '???'

	self.mainPanel = mainPanel
	self.publishData = publishData
	self.startData = startData
	self.icon:SetImage(publishData.icon)
	self.title:SetText(publishData.name)
	self.time.label:SetText(time)
	self.reward.label:SetText(publishData.reward)
end

function PANEL:DoClick()
	local overlay = octolib.overlay(self:GetParent():GetParent():GetParent(), 'dbg_jobs_overlay')
	overlay:SetJob(self.mainPanel, self.publishData, self.startData)
	self.mainPanel.overlay = overlay
end

function PANEL:Paint(w, h)
	if self.Hovered then
		draw.RoundedBox(4, 0, 0, w, h, colHover)
	end
end

vgui.Register('dbg_jobs_button', PANEL, 'DButton')
