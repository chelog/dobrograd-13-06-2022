include 'shared.lua'

local wmPos = Vector(35.7, -3.8, 26.2)
local wmAng = Angle(-30.2, 0, 0)

local angle_zero = Angle()
local lineMat = Material('cable/xbeam')
local linePos = Vector(66, 0, 39)
local segs = 15

local function offZ(x)
	return 0.25 - (x - 0.5)^2
end

function SWEP:CreateWorldModel()

	if IsValid(self.wm) then
		self:RemoveWorldModel()
	end

	local wm = octolib.createDummy(self.WorldModel)

	local owner = self:GetOwner()
	if not IsValid(owner) then
		wm:SetParent(self)
		wm:SetPos(Vector())
		wm:SetAngles(Angle())
	end

	self.wm = wm

end

function SWEP:RemoveWorldModel()

	if IsValid(self.wm) then
		self.wm:Remove()
	end

end

function SWEP:Equip() self:CreateWorldModel() end
function SWEP:Deploy() self:CreateWorldModel() end
function SWEP:OwnerChanged() self:CreateWorldModel() end
function SWEP:Holster() self:RemoveWorldModel() end
function SWEP:OnRemove() self:RemoveWorldModel() end

function SWEP:DrawWorldModel()

	local owner = self:GetOwner()
	if IsValid(owner) and owner:GetActiveWeapon() == self and IsValid(self.wm) then
		local attID = owner:LookupAttachment('anim_attachment_RH')
		if attID <= 0 then return end
		local att = owner:GetAttachment(attID)
		local newPos, newAng = LocalToWorld(wmPos, wmAng, att.Pos, att.Ang)
		self.wm:SetPos(newPos)
		self.wm:SetAngles(newAng)
		-- self.wm:DrawModel()

		local hkID = self:GetNetVar('hook')
		local hk = hkID and Entity(hkID)
		if not IsValid(hk) then return end

		local pos1 = LocalToWorld(linePos, angle_zero, att.Pos, att.Ang)
		local pos2 = hk:GetPos()
		local dir = (pos2 - pos1):GetNormalized()
		local dist = pos1:Distance(pos2)

		render.SetMaterial(lineMat)
		render.StartBeam(segs)
			render.AddBeam(pos1, 0.5, 0, color_white)
			for i = 1, segs - 2 do
				local frac = 1 / segs * i
				local pos = pos1 + dir * frac * dist
				pos.z = pos.z - offZ(frac) * dist / 5
				render.AddBeam(pos, 0.5, i + 1, color_white)
			end
			render.AddBeam(pos2, 0.5, segs, color_white)
		render.EndBeam()
	else
		self:DrawModel()
	end

end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 1)
end
