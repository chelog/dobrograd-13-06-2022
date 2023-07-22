include('shared.lua')

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:Initialize()
	self:SetHoldType('slam')
end

function SWEP:Holster()
	if IsValid(self.cmdl_LeftCuff) then self.cmdl_LeftCuff:Remove() end
	if IsValid(self.cmdl_RightCuff) then self.cmdl_RightCuff:Remove() end
	return true
end
SWEP.OnRemove = SWEP.Holster

local CuffMdl = 'models/hunter/tubes/tube2x2x1.mdl'

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

function SWEP:RenderCuffs(vm, data)
	if not IsValid(vm) then return end

	if not IsValid(self.leftCuff) or not IsValid(self.rightCuff) then
		return self:CreateCuffs()
	end

	local rpos, rang = self:GetBonePos('ValveBiped.Bip01_R_Hand', vm)
	if not rpos or not rang then return end

	-- Right
	local u, r, f = rang:Up(), rang:Right(), rang:Forward()
	local fixed_rpos = rpos + (f * data.right.pos.x) + (r * data.right.pos.y) + (u * data.right.pos.z)
	self.rightCuff:SetPos(fixed_rpos)
	rang:RotateAroundAxis(u, data.right.ang.y)
	rang:RotateAroundAxis(r, data.right.ang.p)
	rang:RotateAroundAxis(f, data.right.ang.r)
	self.rightCuff:SetAngles(rang)

	local matrix = Matrix()
	matrix:Scale(data.right.scale)
	self.rightCuff:EnableMatrix('RenderMultiply', matrix)

	self.rightCuff:SetMaterial(self.CuffMaterial)
	self.rightCuff:DrawModel()

	-- Left
	local dist = data.left.pos:DistToSqr(fixed_rpos)
	if dist > 10000 then
		data.left.pos = fixed_rpos
		data.left.vel = Vector(0, 0, 0)
	elseif dist > 100 then
		local target = (fixed_rpos - data.left.pos) * 0.3
		data.left.vel.x = math.Approach(data.left.vel.x, target.x, 1)
		data.left.vel.y = math.Approach(data.left.vel.y, target.y, 1)
		data.left.vel.z = math.Approach(data.left.vel.z, target.z, 3)
	end

	data.left.vel.x = math.Approach(data.left.vel.x, 0, 0.5)
	data.left.vel.y = math.Approach(data.left.vel.y, 0, 0.5)
	data.left.vel.z = math.Approach(data.left.vel.z, 0, 0.5)

	data.left.vel.z = math.Approach(data.left.vel.z, (fixed_rpos.z - data.left.pos.z - 10)*data.left.gravity, 3)
	data.left.pos:Add(data.left.vel)

	self.leftCuff:SetPos(data.left.pos)
	self.leftCuff:SetAngles(data.left.ang)
	self.leftCuff:EnableMatrix('RenderMultiply', matrix)

	self.leftCuff:SetMaterial(self.CuffMaterial)
	self.leftCuff:DrawModel()

	-- Rope
	if not self.RopeMat then self.RopeMat = Material(self.CuffRope) end
	render.SetMaterial(self.RopeMat)
	render.DrawBeam(data.left.pos + data.rope.l, fixed_rpos, 0.7, 0, 5, color_white)
end

SWEP.wrender = {
	left = {pos=Vector(0,0,0), vel=Vector(0,0,0), gravity=1, ang=Angle(0,30,90)},
	right = {pos=Vector(2.95,2.5,-0.2), ang=Angle(30,0,90), scale = Vector(0.044,0.044,0.044)},
	rope = {l = Vector(0,0,2), r = Vector(3,-1.65,1)},
}
function SWEP:DrawWorldModel()
	self:RenderCuffs(self.Owner, self.wrender)
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
