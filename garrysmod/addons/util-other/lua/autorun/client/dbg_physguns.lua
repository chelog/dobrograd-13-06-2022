hook.Add('Think', 'dbg-physguns', function()
hook.Remove('Think', 'dbg-physguns')

octolib.vars.init('physgunColor', Color(0,161,255))
local updatePhysgunColor = octolib.func.debounce(function(col)
	netstream.Start('dbg-physguns.changeColor', col)
end, 0.5)
hook.Add('octolib.setVar', 'physgunColor', function(var, val)
	if var == 'physgunColor' and val ~= LocalPlayer():GetNetVar('physgunColor', Color(0,161,255)) then
		updatePhysgunColor(val)
	end
end)

local physgunTargets = {}
local vector_zero = Vector(0,0,0)

local function getPhysgunColor(ply)
	local col = ply:GetNetVar('physgunColor', {r = 0, g = 161, b = 255})
	return Color(col.r, col.g, col.b)
end

hook.Add('DrawPhysgunBeam', 'dbg.suppressPhysgun', function(ply, physgun, enabled, target)

	ply:SetWeaponColor(enabled and not ply:GetNetVar('Invisible') and getPhysgunColor(ply):ToVector() or vector_zero)

	if IsValid(target) then
		physgunTargets[ply] = target
	end

	local wep = LocalPlayer():GetActiveWeapon()
	if wep == physgun and octolib.vars.get('hideMyBeam') then return false end
	if not IsValid(wep) or (wep:GetClass() ~= 'weapon_physgun' and wep:GetClass() ~= 'gmod_tool') then
		return false
	end
end)

hook.Add('PreDrawHalos', 'AddPhysgunHalos', function()
	if octolib.vars.get('hidePhysgunHalos') or table.Count(physgunTargets) < 1 then return end

	for k, v in pairs(physgunTargets) do
		if IsValid(k) and IsValid(v) then
			local size = math.random(1, 2)
			local colr = k:GetWeaponColor():ToColor() + Color(math.random(0,88), math.random(0,88), math.random(0,88))
			halo.Add({v}, colr, size, size)
		end
	end

	physgunTargets = {}
end)

end)
