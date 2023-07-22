octolib.server('sv_drag')

hook.Add('playerCanChangeTeam', 'dbg-cuffs', function(ply, _, force)
	if force then return end
	if ply.dragging then
		return false, 'Сначала отпусти игрока'
	elseif ply:IsHandcuffed() then
		return false, L.dontdoincuffs
	end
end)

hook.Add('CanPlayerEnterVehicle', 'dbg-cuffs', function(ply)
	if ply.isForce then return end
	if ply:IsHandcuffed() and not ply:GetNetVar('dragger') then return false end
	if ply.dragging then return false end
end)

hook.Add('CanExitVehicle', 'dbg-cuffs', function(veh, ply)
	if ply:IsHandcuffed() and not ply.isForce then return false end
end)

hook.Add('PlayerDisconnected', 'dbg-cuffs', function(ply)
	if IsValid(ply.draggedBy) then
		ply.draggedBy.dragging = nil
	end
end)

hook.Add('PlayerCanSeePlayersChat', 'dbg-cuffs', function(text, teamOnly, listener, ply)
	if not IsValid(ply) then return end
	local cuffed, wep = ply:IsHandcuffed()
	if cuffed and wep:GetNetVar('gag') then return false end
end)

hook.Add('PlayerCanHearPlayersVoice', 'dbg-cuffs', function(listener, ply)
	if not IsValid(ply) then return end
	local cuffed, wep = ply:IsHandcuffed()
	if cuffed and wep:GetNetVar('gag') then return false end
end)

local function cant(ply)
	if ply:IsHandcuffed() then return false, L.dontdoincuffs end
end

hook.Add('canDropWeapon', 'dbg-cuffs', function(ply, wep)
	if wep:GetClass() == 'weapon_cuffed' then return false, L.dontdoincuffs end
end)
hook.Add('canRequestWarrant', 'dbg-cuffs', function(crim, cop, reason)
	if cop:IsHandcuffed() then return false, L.dontdoincuffs end
end)
hook.Add('canWanted', 'dbg-cuffs', function(crim, cop, reason)
	if cop:IsHandcuffed() then return false, L.dontdoincuffs end
end)
hook.Add('canArrest', 'dbg-cuffs', function(cop, crim)
	if IsValid(crim) and not crim:IsHandcuffed() then return false, L.needscuffs end
end)
hook.Add('CanChangeRPName', 'dbg-cuffs', cant)

hook.Add('OnHandcuffed', 'dbg-cuffs', function(ply, target, cuffs)
	target.policeCuffs = ply:GetActiveWeapon():GetClass() == 'weapon_cuff_police' or nil
end)

hook.Add('PlayerUse', 'dbg-cuffs', cant)
hook.Add('octoinv.canLock', 'dbg-cuffs', cant)
hook.Add('octoinv.canUnlock', 'dbg-cuffs', cant)
hook.Add('octoinv.canPickup', 'dbg-cuffs', cant)
hook.Add('octoinv.canCraft', 'dbg-cuffs', cant)
hook.Add('octoinv.canDrop', 'dbg-cuffs', cant)
hook.Add('octoinv.canMove', 'dbg-cuffs', cant)
hook.Add('octoinv.canUse', 'dbg-cuffs', function(cont, item, ply)
	if ply:IsHandcuffed() then return false, L.dontdoincuffs end
end)

hook.Add('octolib.canUseAnimation', 'dbg-cuffs', cant)
