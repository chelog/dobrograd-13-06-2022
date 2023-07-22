SWEP.Pos = Vector(-3, -3, 3)
SWEP.Ang = Angle(70, 180, 0)
SWEP.Base				= 'weapon_base'
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.Category			= L.dobrograd
SWEP.PrintName			= L.broom
SWEP.ViewModel			= ''
SWEP.Author			 = ''
SWEP.Instructions		= ''
SWEP.WorldModel			= 'models/props_junk/cardboard_box004a.mdl'
SWEP.HoldType			= 'passive'

-- game.AddDecal('transparent', 'decals/transparent')

function SWEP:Initialize()

	self:SetWeaponHoldType(self.HoldType)

end

function SWEP:PrimaryAttack()

	if SERVER then
		local tr = self.Owner:GetEyeTrace()
		if self.Owner:EyePos():DistToSqr(tr.HitPos) > 10000 then return end

		self:SetHoldType('slam')
		timer.Simple(0.1, function() self.Owner:SetAnimation(PLAYER_ATTACK1) end)
		timer.Simple(0.9, function() self:SetHoldType(self.HoldType) end)
		timer.Simple(0.3, function()
			netstream.Start(nil, 'dbg-broom.clean', tr.HitPos, tr.HitNormal)
			sound.Play('weapons/broom/sweep'..tostring(math.random(1,5))..'.mp3', tr.HitPos, 70, 100, 1)
		end)
	end

	self:SetNextPrimaryFire(CurTime() + 1)

end

netstream.Hook('dbg-broom.clean', function(pos, n)

	-- for i = 0, 2 do
	-- 	util.Decal('transparent', pos + n, pos - n)
	-- end

	local info = EffectData()
	info:SetNormal(n)
	info:SetOrigin(pos)
	for i = 0, 10 do
		info:SetScale(math.random(0.1,1))
		util.Effect('WheelDust', info)
	end

end)

function SWEP:Think()

	-- nothing

end

function SWEP:SecondaryAttack()

	-- nothing

end

function SWEP:CreateModel()
	if self.creatingModel or IsValid(self.WModel) then return end
	self.creatingModel = true
	timer.Simple(0, function()
		if not IsValid(self) then return end
		self.WModel = octolib.createDummy('models/props_c17/pushbroom.mdl', RENDERGROUP_OPAQUE)
		self.WModel:SetNoDraw(true)
		self.WModel:SetBodygroup(1, 1)
		self.creatingModel = false
	end)
end

function SWEP:DrawWorldModel()

	if not IsValid(self.WModel) then
		return self:CreateModel()
	end

	local wm = self.WModel
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone('ValveBiped.Bip01_L_Hand')
		local pos, ang = self.Owner:GetBonePosition(bone)

		if bone then
			ang:RotateAroundAxis(ang:Right(), self.Ang.p)
			ang:RotateAroundAxis(ang:Forward(), self.Ang.y)
			ang:RotateAroundAxis(ang:Up(), self.Ang.r)
			wm:SetRenderOrigin(pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z)
			wm:SetRenderAngles(ang)
			wm:DrawModel()
			wm:SetModelScale(0.8, 0)
		end
	else
		wm:DrawModel()
	end

end
