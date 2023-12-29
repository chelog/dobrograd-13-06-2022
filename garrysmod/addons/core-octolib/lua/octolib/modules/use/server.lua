if CFG.disabledModules.use then return end

local useDist = CFG.useDist
local useDistSqr = useDist * useDist

local defaultActions = {
	function(ply, ent)
		return L.use, 'octoteam/icons/hand_point.png', function(ply, ent, args)
			ent:Use(ply, ply, USE_TOGGLE, 1)
		end
	end,
}

function octolib.use.getEntityUses(ent)
	if not IsValid(ent) then return end
	local class = ent:GetClass()

	local itemClass = octoinv and octoinv.itemClasses[class]
	if itemClass and isfunction(octoinv.items[itemClass].pickup) then
		local actions = table.Copy(CFG.use[class] or defaultActions)

		actions[#actions + 1] = function(ply, ent)
			if octoinv.items[itemClass].pickup(ply, ent) == false then return end
			return L.pickup, 'octoteam/icons/arrow_up2.png', function(ply, ent)
				ply:PickupItem(ent)
			end
		end
		return actions
	end

	return CFG.use[class]
end

local useClasses = {}
for class, _ in pairs(CFG.use) do table.insert(useClasses, class) end
hook.Add('PlayerFinishedLoading', 'octolib.use', function(ply)
	netstream.Start(ply, 'octolib.use.classes', useClasses)
end)

hook.Add('PlayerUse', 'octolib.use', function(ply, ent)
	if octolib.use.getEntityUses(ent) and not ply.octolib_usenow then return false end
end)

hook.Add('KeyPress', 'octolib.use', function(ply, key)
	if key == IN_USE then
		if hook.Run('octolib.canUse', ply) == false then return end
		ply.octolib_uselast = CurTime()
	end
end)

hook.Add('KeyRelease', 'octolib.use', function(ply, key)
	if key == IN_USE then
		if hook.Run('octolib.canUse', ply) ~= false then
			local tr = octolib.use.getTrace(ply)
			local ent = tr.Entity
			local uses = octolib.use.getEntityUses(ent)
			if uses and ply.octolib_uselast and CurTime() - ply.octolib_uselast < 0.3 then
				for _, use in pairs(uses) do
					local name, _, action = use(ply, ent)
					if name and action then
						action(ply, ent)
						break
					end
				end
			end
		end
		ply.octolib_uselast = nil
	end
end)

local function tick(ply)
	if not ply.octolib_uselast or CurTime() - ply.octolib_uselast <= 0.2 then return end
	ply.octolib_uselast = nil
	if hook.Run('octolib.canUse', ply) == false then return end
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep:GetClass() == 'weapon_physgun' and ply:KeyDown(IN_ATTACK) then return end -- if player is rotating with physgun

	local tr = octolib.use.getTrace(ply)
	local ent = tr.Entity
	local uses = octolib.use.getEntityUses(ent)
	if uses then
		local actions = {}
		for i, use in pairs(uses) do
			local name, icon, _, args = use(ply, ent)
			if name then
				icon = icon or 'octoteam/icons/error.png'
				actions[i] = { name, icon }
				if args then actions[i][3] = args(ply, ent) end
			end
		end
		netstream.Start(ply, 'octolib.use', ent, actions)
	end

end
hook.Add('PlayerTick', 'octolib.use', tick)
hook.Add('VehicleMove', 'octolib.use', tick)

netstream.Hook('octolib.use', function(ply, ent, useID, args)
	local uses = octolib.use.getEntityUses(ent)
	if not uses or not uses[useID] then return end

	local plyPos = ply:GetShootPos()
	if plyPos:DistToSqr(ent:NearestPoint(plyPos)) > useDistSqr then return end

	local _, _, action = uses[useID](ply, ent)
	if action then action(ply, ent, args) end
end)

octolib.include.prefixed('/config/octolib-use', {
	'hooks',
	'*',
})
