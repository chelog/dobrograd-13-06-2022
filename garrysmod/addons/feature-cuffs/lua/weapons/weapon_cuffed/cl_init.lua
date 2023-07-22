include('shared.lua')

function SWEP:OnRemove() -- Fixes invisible other weapons
	if IsValid(self.Owner) then
		local viewModel = self.Owner:GetViewModel()
		if IsValid(viewModel) then viewModel:SetMaterial('') end
	end
	if IsValid(self.leftCuff ) then self.leftCuff:Remove() end
	if IsValid(self.rightCuff ) then self.rightCuff:Remove() end
	return true
end

function SWEP:DrawHUDBackground()
	if self:GetNetVar('blind') then
		surface.SetDrawColor(Color(0, 0, 0, 253))
		surface.DrawRect(0, 0, ScrW(), ScrH())

		surface.SetDrawColor(color_black)
		for i = 1, ScrH(), 5 do
			surface.DrawRect(0, i, ScrW(), 4)
		end
		for i = 1, ScrW(), 5 do
			surface.DrawRect(i, 0, 4, ScrH())
		end
	end
end

local CuffMdl = 'models/hunter/tubes/tube2x2x1.mdl'
local DefaultRope = 'cable/cable2'

local wrender = {
	left = {pos=Vector(0,0,0), ang=Angle(90,0,0), scale = Vector(0.035,0.035,0.035)},
	right = {pos=Vector(0.2,0,0), ang=Angle(90,0,0), scale = Vector(0.035,0.035,0.035)},
	rope = {l = Vector(-0.2,1.3,-0.25), r = Vector(0.4,1.4,-0.2)},
}

function SWEP:CreateCuffs()
	if self.creatingCuffs then return end
	timer.Simple(0, function()
		if not IsValid(self) then return end
		if not IsValid(self.leftCuff) then
			self.leftCuff = octolib.createDummy(CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE)
			self.leftCuff:SetNoDraw(true)
		end
		if not IsValid(self.rightCuff) then
			self.rightCuff = octolib.createDummy(CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE)
			self.rightCuff:SetNoDraw(true)
		end
		self.creatingCuffs = false
	end)
end

function SWEP:DrawWorldModel()
	local vm, data, lbone, rbone = self.Owner, wrender, 'ValveBiped.Bip01_L_Hand', 'ValveBiped.Bip01_R_Hand'
	if not IsValid(vm) then return end

	if not IsValid(self.leftCuff) or not IsValid(self.rightCuff) then
		return self:CreateCuffs()
	end

	local lpos, lang = self:GetBonePos(lbone, vm)
	local rpos, rang = self:GetBonePos(rbone, vm)

	-- Left
	local u,r,f = lang:Up(), lang:Right(), lang:Forward() -- Prevents moving axes
	self.leftCuff:SetPos(lpos + (f*data.left.pos.x) + (r*data.left.pos.y) + (u*data.left.pos.z))
	lang:RotateAroundAxis(u, data.left.ang.y)
	lang:RotateAroundAxis(r, data.left.ang.p)
	lang:RotateAroundAxis(f, data.left.ang.r)
	self.leftCuff:SetAngles(lang)

	local matrix = Matrix()
	matrix:Scale(data.left.scale)
	self.leftCuff:EnableMatrix('RenderMultiply', matrix)

	self.leftCuff:SetMaterial(self:GetNetVar('CuffMaterial', ''))
	self.leftCuff:DrawModel()

	-- Right
	u,r,f = rang:Up(), rang:Right(), rang:Forward() -- Prevents moving axes
	self.rightCuff:SetPos( rpos + (f*data.right.pos.x) + (r*data.right.pos.y) + (u*data.right.pos.z) )
	rang:RotateAroundAxis(u, data.right.ang.y)
	rang:RotateAroundAxis(r, data.right.ang.p)
	rang:RotateAroundAxis(f, data.right.ang.r)
	self.rightCuff:SetAngles(rang)

	local matrix = Matrix()
	matrix:Scale(data.right.scale)
	self.rightCuff:EnableMatrix('RenderMultiply', matrix)

	self.rightCuff:SetMaterial(self:GetNetVar('CuffMaterial', ''))
	self.rightCuff:DrawModel()

	-- Rope accross half the map...
	if (lpos.x == 0 and lpos.y == 0 and lpos.z == 0) or (rpos.x == 0 and rpos.y == 0 and rpos.z == 0) then return end

	if self:GetNetVar('CuffRope') ~= self.LastMatStr then
		self.RopeMat = Material(self:GetNetVar('CuffRope'))
		self.LastMatStr = self:GetNetVar('CuffRope')
	end
	if not self.RopeMat then self.RopeMat = Material(DefaultRope) end
	render.SetMaterial(self.RopeMat)
	render.DrawBeam(lpos + (lang:Forward()*data.rope.l.x) + (lang:Right()*data.rope.l.y) + (lang:Up()*data.rope.l.z),
						rpos + (f*data.rope.r.x) + (r*data.rope.r.y) + (u*data.rope.r.z), 0.7, 0, 5, color_white)

	if IsValid(self.Owner) and IsValid(self.Owner:GetNetVar('dragger')) then
		local dragger = self.Owner:GetNetVar('dragger')
		local bone = dragger:LookupBone('ValveBiped.Bip01_R_Hand')
		if bone then
			render.DrawBeam(rpos + (f*data.rope.r.x) + (r*data.rope.r.y) + (u*data.rope.r.z), dragger:GetBonePosition(bone), 0.7, 0, 5, color_white)
		end
	end
end

function SWEP:GetBonePos(bonename, vm)
	local bone = vm:LookupBone(bonename)
	if not bone then return end

	local pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
	local matrix = vm:GetBoneMatrix(bone)
	if matrix then
		pos, ang = matrix:GetTranslation(), matrix:GetAngles()
	end
	if self.ViewModelFlip then ang.r = -ang.r end
	return pos, ang
end

