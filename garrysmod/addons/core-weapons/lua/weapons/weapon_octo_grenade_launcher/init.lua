AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'
include 'shared.lua'

netstream.Hook('dbg-glauncher.applyCharge', function(ply, charge, delayed)

	if not isstring(charge) then return end
	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) or wep:GetClass() ~= 'weapon_octo_grenade_launcher' then return end
	local ct = CurTime()
	if (wep.nextRecharge or 0) > ct then return end
	wep.nextRecharge = ct + 4

	local charges = wep:GetNetVar('charges', {})
	local amount = charges[charge] or 0
	if amount < 1 then
		return ply:Notify('warning', 'У тебя нет снарядов этого вида!')
	end

	charges[charge] = amount - 1
	local oldCharge = wep:GetNetVar('charge')
	if oldCharge then
		charges[oldCharge] = (charges[oldCharge] or 0) + 1
	end

	wep:SetNetVar('charges', charges)
	wep:SetNetVar('charge', charge)
	wep:SetNetVar('chargeDelayed', tobool(delayed))
	wep:EmitSound('grenade_launcher/grenade_launcher_reload.wav')
	ply:DoEmote('{name} заряжает 40-мм ' .. utf8.lower(wep.ChargeTypes[charge].name) .. ' в гранатомет')
	ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
	timer.Simple(1.5, function()
		if IsValid(ply) then ply:DoAnimation(ACT_HL2MP_GESTURE_RELOAD_SMG1) end
	end)

end)

local function getMax(cfg)
	return cfg.max
end
function SWEP:Recharge()
	self:SetNetVar('charges', octolib.table.map(self.ChargeTypes, getMax))
end

function SWEP:Shoot(proj, forceMul)
	local ply = self:GetOwner()

	local force = 2000 * forceMul
	local pos, ang, vel = ply:GetBonePosition(ply:LookupBone('ValveBiped.Bip01_Head1') or 6)
	pos = pos - Vector(0, 0, 5)
	local tr = util.TraceLine { start = ply:GetShootPos(), endpos = pos, filter = ply }
	if tr.Hit then
		pos = tr.HitPos + tr.HitNormal * 5
		vel = tr.HitNormal * force * 0.4
	else
		vel = ply:GetForward()
		vel = vel * force
	end

	proj:SetPos(pos)
	proj:SetAngles(ang)

	proj.LifeTime = proj.charge.delay * (self:GetNetVar('chargeDelayed') and 1 or 0.1) * math.Rand(0.8, 1.2)
	proj.BreakSensitivity = 100
	proj.ExplodeAfterCollision = true
	proj:Spawn()
	proj:Activate()
	proj.owner = ply
	ply:LinkEntity(proj)
	proj:SetGravity(0.5)

	local phys = proj:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(vel)
	end

end
