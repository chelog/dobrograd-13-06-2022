peepholes = peepholes or {}

local function getDoorWidth(door)
	local mins, maxs = door:GetModelBounds()
	local dx, dy = maxs.x - mins.x, maxs.y - mins.y
	return math.abs(dx) > math.abs(dy) and dx or dy
end

-- 1 = in front of door, 2 = behind the door
local function getRelativePosition(ply, door)
	return ply:GetAimVector():Dot(door:GetForward()) <= 0 and 1 or 2
end

-- 1 = forward, -1 = backward
local function calculatePos(door, fw)
	return Vector(0.3 * fw, getDoorWidth(door) / 2 - 2, 16)
end

-- true = in front of door, false = behind door
local function calculateAngle(door, fw)
	return Angle(0, fw and 0 or 180, 0)
end

local function stopViewing(ply)

	ply.peephole = nil
	netstream.Start(ply, 'dbg-doors.peephole', nil)
	timer.Simple(0.5, function() ply:Freeze(false) end)

end

function peepholes.setup(ply, door)

	local dir = getRelativePosition(ply, door)
	if not door.peephole then door.peephole = {} end
	if door.peephole[dir] then return false, 'На этой стороне двери уже установлен глазок' end

	local pos = calculatePos(door, dir == 1 and 1 or -1)
	if not pos then return false, 'Не получится поставить глазок на движущуюся дверь' end

	local ph = ents.Create('prop_dynamic')
	ph:SetModel('models/maxofs2d/camera.mdl')
	ph:SetParent(door)
	ph:SetModelScale(0.4)
	ph:SetLocalPos(pos)
	ph:SetLocalAngles(calculateAngle(door, dir == 1))
	ph:Spawn()
	door:DeleteOnRemove(ph)
	door.peephole[dir] = ph

	return true, 'Глазок установлен'

end

function peepholes.hasPeephole(door)
	return door.peephole ~= nil
end

function peepholes.canAccess(ply, door)
	local dir = getRelativePosition(ply, door)
	return door.peephole and door.peephole[dir] and IsValid(door.peephole[dir])
end

function peepholes.view(ply, door)

	if not peepholes.canAccess(ply, door) then return end
	if ply.peephole then return end

	local dir = getRelativePosition(ply, door)
	local ent = door.peephole[dir]
	local pos, ang = Vector(ent:GetPos()), Angle(ent:GetAngles())
	pos = pos - ent:GetForward() * 10
	ang:RotateAroundAxis(Vector(0,0,1), 180)
	netstream.Start(ply, 'dbg-doors.peephole', {
		origin = pos,
		angles = ang,
		x = 0, y = 0,
		fov = 150,
	})

	ply.peephole = ent
	ply:Freeze(true)

end

function peepholes.remove(door, dir)

	if not door.peephole or not door.peephole[dir] then return end
	local ent = door.peephole[dir]
	for _,pl in ipairs(player.GetAll()) do
		if pl.peephole == ent then stopViewing(pl) end
	end
	ent:Remove()
	door.peephole[dir] = nil
	if not door.peephole[1] and not door.peephole[2] then door.peephole = nil end

end


hook.Add('Move', 'dbg-doors.peephole.quit1', function(ply, data)
	if ply.peephole and data:GetVelocity() ~= Vector() then
		stopViewing(ply)
	end
end)

hook.Add('dbg-doors.unowned', 'dbg-doors.peephole.remove', function(ent)
	if ent.peephole then
		peepholes.remove(ent, 1)
		peepholes.remove(ent, 2)
	end
end)

local exitBtns = {KEY_E, KEY_LCONTROL, KEY_SPACE}

hook.Add('PlayerButtonDown', 'dbg-doors.peepholes', function(ply, btn)
	if ply.peephole and table.HasValue(exitBtns, btn) then stopViewing(ply) end
end)

local classes = {'prop_door_rotating'}
octoinv.registerItem('peephole', {
	name = 'Глазок',
	icon = 'octoteam/icons/bubble.png',
	mass = 0.08,
	volume = 0.1,
	desc = 'Загляни за дверь, не выходя из дома!',
	use = {
		function(ply, item)
			return L.set, 'octoteam/icons/wrench.png', function(ply, item)
				local ent = octolib.use.getTrace(ply).Entity
				if not IsValid(ent) or not table.HasValue(classes, ent:GetClass()) then ply:Notify('warning', 'Нужно смотреть на дверь') return end
				if ent:GetPlayerOwner() ~= ply:SteamID() then ply:Notify('warning', 'Глазок можно установить только на свою дверь') return end
				if ply:HasItem('tool_screwer') < 1 then ply:Notify('warning', 'Для установки нужна отвертка') return end

				ply:DelayedAction('peephole_mount', 'Установка', {
					time = 5,
					check = function() return octolib.use.check(ply, ent) and ply:HasItem('tool_screwer') >= 1 and ply:HasItem('peephole') >= 1 end,
					succ = function()
						if ent:GetPlayerOwner() ~= ply:SteamID() then ply:Notify('warning', 'Глазок можно установить только на свою дверь') return end
						if ply:HasItem('tool_screwer') < 1 then ply:Notify('warning', 'Для установки нужна отвертка') return end

						local result, msg = peepholes.setup(ply, ent)
						if result then ply:TakeItem('peephole', 1) end

						ply:Notify(result and 'rp' or 'warning', msg)
					end,
				}, {
					time = 1.5,
					inst = true,
					action = function()
						ply:EmitSound('ambient/machines/pneumatic_drill_' .. math.random(1, 4) .. '.wav')
						ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
					end,
				})
			end
		end,
	},
})

octoinv.addShopItem('peephole', {
	cat = 'security', price = 150
})
