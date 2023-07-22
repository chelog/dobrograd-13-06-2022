AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

SWEP.nextCuff = 0

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	if self.nextCuff > CurTime() then return end

	local ply = self.Owner
	local tgt = octolib.use.getTrace(ply).Entity
	if not IsValid(tgt) or not tgt:IsPlayer() or tgt:IsGhost() then return end

	if self.ScareRequired and tgt:GetNetVar('ScareState', 0) <= 0.4 then
		return ply:Notify('warning', ('%s сопротивляется! Направь на этого человека %sогнестрельное оружие, чтобы припугнуть, а затем попробуй сковать еще раз'):format(tgt:Name(), ply:HasWeapon('stungun') and 'тазер или ' or ''))
	end

	ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
	ply:DelayedAction('cuffing', 'Сковывание', {
		time = self.CuffTime,
		check = function() return octolib.use.check(ply, tgt) and ply:GetActiveWeapon() == self end,
		succ = function()
			tgt:ExitVehicle()
			ply:EmitSound(self.CuffSound)
			self.nextCuff = CurTime() + self.CuffRecharge
			self:DoHandcuff(tgt)
		end,
	})
end

function SWEP:Holster()
	return true
end
SWEP.OnRemove = SWEP.Holster

function SWEP:DoHandcuff(ply)
	if not IsValid(ply) or ply:IsHandcuffed() or not IsValid(self.Owner) then return end
	local veh = ply:GetVehicle()
	if IsValid(veh) and veh.fphysSeat then return end

	local cuffs = ply:Give('weapon_cuffed')
	cuffs:SetNetVar('CuffMaterial', self.CuffMaterial)
	cuffs:SetNetVar('CuffRope', self.CuffRope)
	cuffs.RemoveTime = self.RemoveTime
	cuffs.CanBlind = self.CanBlind
	cuffs.CanGag = self.CanGag
	cuffs.CuffType = self:GetClass() or ''
	ply:SelectWeapon('weapon_cuffed')

	hook.Call('OnHandcuffed', GAMEMODE, self.Owner, ply, cuffs)

	if not self.CuffReusable then
		if IsValid(self.Owner) then self.Owner:ConCommand('lastinv') end
		self:Remove()
	end
end
