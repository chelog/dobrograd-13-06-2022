include('shared.lua')

function ENT:Initialize()
	self.stream = octolib.audio.stream()
	self.stream:SetParent(self)
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:SetVolume(vol)
	self.stream:SetVolume(vol)
end

function ENT:SetDistance(dist)
	self.stream:SetDistance(dist)
end

function ENT:StopStream()
	self.stream:Stop()
end

function ENT:StartStream(url)
	self.stream:SetURL(url)
end

function ENT:Set2D(enable)
	if enable then
		self.stream:SetParent()
		self.stream:SetPos()
	else
		self.stream:SetParent(self)
	end
end

function ENT:OnRemove()
	self.stream:Remove()
end
