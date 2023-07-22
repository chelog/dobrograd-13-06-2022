local useDist = CFG.useDist * CFG.useDist

local function cancelDrag(cop, crim)
	if IsValid(crim) then
		crim:SetNetVar('dragger')
	end
	if IsValid(cop) then
		cop:SetNetVar('dragging')
		cop.dragging = nil
	end
end

local noDragWeps = octolib.array.toKeys({'weapon_physgun', 'med_kit'})

hook.Add('KeyPress', 'dbg-cuffs.drag', function(ply, key)

	if key ~= IN_ATTACK then return end
	if ply:InVehicle() or ply:IsGhost() or ply:IsHandcuffed() then return end
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and noDragWeps[wep:GetClass()] then return end

	local tgt = octolib.use.getTrace(ply).Entity
	if not (IsValid(tgt) and tgt:IsPlayer() and tgt:IsHandcuffed()) then return end
	if IsValid(tgt:GetNetVar('dragger')) or IsValid(ply:GetNetVar('dragging')) then return end
	tgt:SetNetVar('dragger', ply)
	ply:SetNetVar('dragging', tgt)
end)

hook.Add('KeyRelease', 'dbg-cuffs.drag', function(ply, key)
	if key == IN_ATTACK and IsValid(ply:GetNetVar('dragging')) then
		cancelDrag(ply, ply:GetNetVar('dragging'))
	end
end)

hook.Add('PlayerDisconnect', 'dbg-cuffs.drag', function(ply)
	if IsValid(ply:GetNetVar('dragging')) then
		cancelDrag(ply, ply:GetNetVar('dragging'))
	end
	if IsValid(ply:GetNetVar('dragger')) then
		cancelDrag(ply:GetNetVar('dragger'), ply)
	end
end)

hook.Add('FindUseEntity', 'dbg-cuffs.drag', function(ply, ent)
	if not IsValid(ent) or ply:GetNetVar('dragging') then
		local traceEnt = util.TraceLine({
			start = ply:GetShootPos(),
			endpos = ply:GetShootPos() + ply:GetAimVector() * 72,
			filter = {ply, ply:GetNetVar('dragging')},
		}).Entity
		if IsValid(traceEnt) then return traceEnt end
	end
	return ent
end)
