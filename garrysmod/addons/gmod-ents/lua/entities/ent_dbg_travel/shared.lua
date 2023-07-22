ENT.Type 		= "anim"
ENT.Base 		= "base_gmodentity"
ENT.PrintName	= L.travel
ENT.Category	= L.dobrograd
ENT.Author		= "chelog"
ENT.Contact		= "chelog@octothorp.team"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.transferFee = 50
ENT.transferInterval = {60, 120}
ENT.transferIntervalLow = {30, 60}
ENT.transferLength = 5
ENT.noFeeTime = 5 * 60 * 60
ENT.menuLength = 15

function ENT:FreeTransfer(ply)
	return ply:GetTimeHere() <= (self.noFeeTime or 5 * 60 * 60)
end

function ENT:GetFee(ply, dst)
	return (dst or 1) * (self.transferFee or 50) * (CurTime() <= 1800 and 0.5 or 1) * (self:FreeTransfer(ply) and 0 or 1)
end

hook.Add('dbg-travel.canTransfer', 'dbg-travel.default', function(ply, fee, travel)
	if not (ply:canAfford(fee) or travel:FreeTransfer(ply)) then
		return false, L.bus_not_enough_money
	end
end)

function ENT:CanTransfer(ply, fee, notify)
	local can, why = hook.Run('dbg-travel.canTransfer', ply, fee, self)
	if can == false and notify then
		why = why or 'Ты не можешь сейчас воспользоваться автобусом'
		if SERVER then
			ply:Notify('warning', why)
		elseif CLIENT and ply == LocalPlayer() then
			octolib.notify.show('warning', why)
		end
	end
	return can ~= false, why
end
