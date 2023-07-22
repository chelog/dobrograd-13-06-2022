--[[

	well, if you're reading this, you probably tried to steal the code
	luckily, I can properly split realms and you get not working clientside code

	- chelog

]]

include 'shared.lua'

function SWEP:DrawWorldModel()

	return false

end

function SWEP:DrawWorldModelTranslucent()

	return false

end

function SWEP:PrimaryAttack()

	-- keep calm and do nothing

end

function SWEP:SecondaryAttack()

	-- keep calm and do nothing

end

function SWEP:Reload()

	-- keep calm and do nothing

end

function SWEP:Think()

	-- nothing

end

function SWEP:Holster()

	local ply = self:GetOwner()
	if not IsValid(ply) then return true end

	local b1 = ply:LookupBone 'ValveBiped.Bip01_R_Upperarm'
	local b2 = ply:LookupBone 'ValveBiped.Bip01_R_Forearm'
	if b1 and b2 then
		ply:ManipulateBoneAngles(b1, Angle())
		ply:ManipulateBoneAngles(b2, Angle())
	end

	return true

end

function SWEP:OnRemove()

	local ply = self:GetOwner()
	if not IsValid(ply) then return true end

	local b1 = ply:LookupBone 'ValveBiped.Bip01_R_Upperarm'
	local b2 = ply:LookupBone 'ValveBiped.Bip01_R_Forearm'
	if b1 and b2 then
		ply:ManipulateBoneAngles(b1, Angle())
		ply:ManipulateBoneAngles(b2, Angle())
	end

end

local offPosDown1, offPosDown2, offAngDown = Vector(3.7,-1.5,0.75), Vector(3.9,-1.9,0.35), Angle(0,25,0)
local offPosUp1, offPosUp2, offAngUp = Vector(2.6, -1, -3), Vector(2, -0.8, -3), Angle(0, 78, 0)
local offPosSmoke = Vector(0, -1.5, 0)

local smokers = {}
local function updateCigarette(ply)
	local wep = ply:GetWeapon('dbg_cigarette')

	local dummy = ply.dbgCigarette
	if IsValid(wep) then
		smokers[#smokers + 1] = ply
	elseif IsValid(dummy) then
		local em = dummy.emitter
		timer.Simple(2, function()
			em:Finish()
		end)
		dummy:Remove()
		ply.dbgCigarette = nil
	end

end
timer.Create('dbg-cigarette', 0.5, 0, function()
	table.Empty(smokers)
	for _, ply in ipairs(player.GetAll()) do updateCigarette(ply) end
end)

local function createCigaretteDummy(ply)
	if ply.dbgCigaretteCreating then return end
	ply.dbgCigaretteCreating = true
	timer.Simple(0, function()
		ply.dbgCigarette = octolib.createDummy('models/phycigold.mdl', RENDERGROUP_BOTH)
		ply.dbgCigarette.emitter = ParticleEmitter(Vector())
		ply.dbgCigarette.female = not octolib.models.isMale(ply:GetModel())
		ply.dbgCigaretteCreating = false
	end)
end

local function drawSmoker(ply, ct, ft)

	if not IsValid(ply) then return end

	local c = ply.dbgCigarette
	if not IsValid(c) then
		createCigaretteDummy(ply)
		return
	end

	local aWep = ply:GetActiveWeapon()
	c.mult = math.Approach(c.mult or 0, ply:GetNetVar('IsSmoking') and 1 or 0, ft * 2)
	local b1 = ply:LookupBone 'ValveBiped.Bip01_R_Upperarm'
	local b2 = ply:LookupBone 'ValveBiped.Bip01_R_Forearm'
	if b1 and b2 then
		ply:ManipulateBoneAngles(b1, Angle(20*c.mult, -62*c.mult, 10*c.mult))
		ply:ManipulateBoneAngles(b2, Angle(-5*c.mult, -10*c.mult, 0))
		c.isUp = c.mult > 0.9

		local onHead = c.isUp or not (IsValid(aWep) and aWep:GetClass() == 'dbg_cigarette')
		if onHead ~= c.onHead then
			c:SetParent()
			if onHead then
				c:SetParent(ply, ply:LookupAttachment('eyes') or 1)
				c:SetLocalPos(c.female and offPosUp2 or offPosUp1)
				c:SetLocalAngles(offAngUp)
			else
				c:SetParent(ply, ply:LookupAttachment('anim_attachment_RH') or 5)
				c:SetLocalPos(c.female and offPosDown2 or offPosDown1)
				c:SetLocalAngles(offAngDown)
			end
		end
		c.onHead = onHead
	end

	if ct > (c.nextP or 0) and not c.isUp then
		local pos = ply.dbgCigarette:LocalToWorld(offPosSmoke)
		local p = c.emitter:Add(string.format('particle/smokesprites_00%02d',math.random(7,16)), pos)
		p:SetColor(255,255,255)
		p:SetGravity(Vector(0,0,10))
		p:SetDieTime(2)
		p:SetLifeTime(0)
		p:SetStartSize(0.5)
		p:SetEndSize(2)
		p:SetStartAlpha(100)
		p:SetEndAlpha(0)
		p:SetCollide(false)
		p:SetRoll(math.random(360))
		p:SetRollDelta((math.random() - 0.5) * 2)
		p:SetAirResistance(50)
		c.nextP = ct + 0.15
	end

end

hook.Add('PostDrawTranslucentRenderables', 'dbg-cigarette', function()
	local ct, ft = CurTime(), FrameTime()
	for _, ply in ipairs(smokers) do
		drawSmoker(ply, ct, ft)
	end
end)

net.Receive('dbg.cigarette.exhale', function(len)

	local ply = net.ReadEntity()
	local amount = net.ReadUInt(8)

	local em = ParticleEmitter(Vector())
	for i = 0, amount-1 do
		timer.Simple(0.5 + i * 0.1, function()
			if IsValid(ply) then
				local att = ply:GetAttachment(ply:LookupAttachment('mouth') or 0)
				local p = em:Add(string.format('particle/smokesprites_00%02d', math.random(7,16)), att.Pos)
				p:SetColor(255,255,255)
				p:SetVelocity(att.Ang:Forward() * (15 - i * 0.5))
				p:SetGravity(Vector(0,0,1))
				p:SetDieTime(8)
				p:SetLifeTime(0)
				p:SetStartSize(1)
				p:SetEndSize(8)
				p:SetStartAlpha(50)
				p:SetEndAlpha(0)
				p:SetCollide(false)
				p:SetRoll(math.random(360))
				p:SetRollDelta((math.random() - 0.5))
				p:SetAirResistance(50)
			end
		end)
	end

end)
