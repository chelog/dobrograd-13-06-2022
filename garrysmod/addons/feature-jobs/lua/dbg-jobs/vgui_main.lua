local instance

local PANEL = {}

function PANEL:Init()
	-- ALL JOBS
	self.available = vgui.Create 'DPanel'
	self.available:SetPaintBackground(false)
	self:AddSheet('Доступные', self.available, octolib.icons.silk16('world'))

	-- MY JOBS
	self.active = vgui.Create 'DPanel'
	self.active:SetPaintBackground(false)
	self:AddSheet('Принятые', self.active, octolib.icons.silk16('tick'))

	instance = self
end

function PANEL:AddAvailable(publishData)
	if hook.Run('dbg-jobs.canTake', LocalPlayer(), publishData) == false then return end

	local button = self.available:Add 'dbg_jobs_button'
	button:SetJob(self, publishData)
end

function PANEL:RemoveAvailable(jobID)
	for _, button in ipairs(self.available:GetChildren()) do
		if button.publishData.id == jobID then
			button:Remove()
		end
	end
end

function PANEL:SetAvailable(publishDatas)
	self.available:Clear()

	for _, job in pairs(publishDatas) do
		self:AddAvailable(job)
	end
end

function PANEL:AddActive(job)
	local button = self.active:Add 'dbg_jobs_button'
	button:SetJob(self, job.publishData, job)
end

function PANEL:SetActive(data)
	self.active:Clear()

	for _, job in pairs(data or {}) do
		self:AddActive(job)
	end
end

netstream.Hook('dbg-jobs.syncAvailable', function(publishDatas)
	if not IsValid(instance) then return end
	instance:SetAvailable(publishDatas)
end)

netstream.Hook('dbg-jobs.syncActive', function(jobs)
	if not IsValid(instance) then return end
	instance:SetActive(jobs)
end)

netstream.Hook('dbg-jobs.addAvailable', function(publishData)
	if not IsValid(instance) then return end
	instance:AddAvailable(publishData)
end)

netstream.Hook('dbg-jobs.removeAvailable', function(jobID)
	if not IsValid(instance) then return end
	instance:RemoveAvailable(jobID)
end)

vgui.Register('dbg_jobs_main', PANEL, 'DPropertySheet')
