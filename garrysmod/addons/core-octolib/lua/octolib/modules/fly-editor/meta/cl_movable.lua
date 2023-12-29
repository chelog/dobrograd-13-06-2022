local vector_zero, angle_zero = Vector(), Angle()
local snapTable = {
	move = { 0.1, 0.5, 1, 4, 16, 64, 128, 256, 512 },
	rotate = { 1, 2, 5, 10, 15, 30, 45, 60, 90 },
}

local shiftMul = 0.1
local snapMode = 5
local snapCache

-- local actionMul = 1
-- hook.Add('VGUIMousePressed', 'fly-editor.movable', function(pnl, code)
-- 	local editor = octolib.flyEditor
-- 	if not editor.active or not editor.selected or not editor.axis then return end

-- 	if code == MOUSE_WHEEL_DOWN then
-- 		actionMul = math.max(actionMul * 0.5, 0.125)
-- 		octolib.flyEditor.notify('Скорость взаимодействия: x' .. math.Round(actionMul, 2))
-- 	elseif code == MOUSE_WHEEL_UP then
-- 		actionMul = math.min(actionMul * 2, 32)
-- 		octolib.flyEditor.notify('Скорость взаимодействия: x' .. math.Round(actionMul, 2))
-- 	end
-- end)

local function hideOriginalEntity(ent)
	function ent:RenderOverride()
		local movable = self.movable
		if not movable or not IsValid(movable.csent) then
			self.RenderOverride = nil
		end
	end
end

local function getEntInfo(ent)

	if not isentity(ent) then return {} end

	local bgs = {}
	for i, v in ipairs(ent:GetBodyGroups()) do
		local id = v.id
		bgs[id] = ent:GetBodygroup(id)
	end

	local parent = ent:GetParent()
	if IsValid(parent) and parent.movable then
		parent = parent.movable:GetEntity()
	end

	local pos, ang = ent:GetPos(), ent:GetAngles()
	if istable(parent) and parent.movable and IsValid(parent.movable.csent) then
		local parentEnt = parent.movable.csent
		pos, ang = WorldToLocal(pos, ang, parentEnt:GetPos(), parentEnt:GetAngles())
	elseif IsValid(parent) then
		pos, ang = ent:GetLocalPos(), ent:GetLocalAngles()
	end

	parent = istable(parent) and parent.movable and parent.movable.id or IsValid(parent) and parent or nil

	return {
		pos = pos,
		ang = ang,
		model = ent:GetModel(),
		skin = ent:GetSkin(),
		col = ent:GetColor(),
		-- mat = ent:GetMaterial(),
		scale = ent:GetModelScale(),
		size = ent.GetSize and ent:GetSize() or nil,
		parent = parent,
		bgs = bgs,
	}

end

local Movable = {}
Movable.__index = Movable

local cols = {
	x = Color(255,0,0),
	xTr = Color(255,0,0, 20),
	y = Color(0,255,0),
	yTr = Color(0,255,0, 20),
	z = Color(0,0,255),
	zTr = Color(0,0,255, 20),
}

function octolib.createMoveable(prop, id)

	local data
	if isentity(prop) then
		if not IsValid(prop) then return end

		local parent = prop:GetParent()
		local hasParent = IsValid(parent)
		data = {
			model = prop:GetModel(),
			parent = prop:GetParent(),
			pos = hasParent and prop:GetLocalPos() or prop:GetPos(),
			ang = hasParent and prop:GetLocalAngles() or prop:GetAngles(),
			scale = prop:GetModelScale(),
			mat = prop:GetMaterial(),
			skin = prop:GetSkin(),
			col = prop:GetColor(),
			rg = prop:GetRenderGroup(),
			size = prop.GetSize and prop:GetSize() or nil,
		}

		local bgs = {}
		for _, v in ipairs(prop:GetBodyGroups()) do
			local id = v.id
			bgs[id] = prop:GetBodygroup(id)
		end
		data.bgs = bgs
	else
		data = prop
	end

	local csent = ClientsideModel(data.model, data.rg)
	octolib.applyEntData(csent, data)

	timer.Simple(0, function()
		local parent = csent:GetParent()
		if IsValid(parent) then
			if parent.movable and IsValid(parent.movable.csent) then
				csent:SetParent(parent.movable.csent)
			else
				csent:SetParent(parent)
			end
		end
	end)

	local editor = octolib.flyEditor
	if not id then
		id = 1
		while editor.movables[id] do
			id = id + 1
		end
	end
	local movable = setmetatable({
		ent = prop,
		csent = csent,
		id = id,
		limits = data.limits,
		static = data.static,
		name = data.name,
		icon = data.icon,
		customDraw = data.customDraw,
	}, Movable)

	if data.customDraw then
		function csent:RenderOverride()
			data.customDraw(self, movable, editor)
		end
	end

	if isentity(prop) then
		hideOriginalEntity(prop)
	end
	prop.movable = movable
	csent.movable = movable

	editor.movables[id] = movable
	editor.pnlScene:AddMovable(movable)

	editor.recalcMovablePositions()

	return movable

end

function Movable:Remove()

	local ent = self.ent
	if IsValid(ent) and ent.movable == self then
		ent.movable = nil
	end

	if IsValid(self.csent) then
		for _, child in pairs(self.csent:GetChildren()) do
			if child.movable then
				child.movable:Remove()
			else
				child:Remove()
			end
		end
		self.csent:Remove()
	end

	local editor = octolib.flyEditor
	if editor.selected == self then
		editor.selected = nil
	end

	editor.pnlScene:RemoveMovable(self)
	editor.movables[self.id] = nil

end

function Movable:GetEntity()

	local ent = self.ent
	if not istable(ent) and not IsValid(ent) then
		self:Remove()
		return
	end

	return ent

end

function Movable:GetCSEntity()

	local csent = self.csent
	if not IsValid(csent) then
		self:Remove()
		return
	end

	return csent

end

function Movable:Move(off)

	local csent = self:GetCSEntity()
	if not csent then return end

	local pos = csent:GetPos()
	pos:Add(off)
	csent:SetPos(pos)

end

octolib.gizmos = octolib.gizmos or {}
local gz = octolib.gizmos
gz.radius = 20
gz.dx1 = Vector(1, 0, 0)
gz.dy1 = Vector(0, 1, 0)
gz.dz1 = Vector(0, 0, 1)
gz.dx = Vector(gz.radius, 0, 0)
gz.dy = Vector(0, gz.radius, 0)
gz.dz = Vector(0, 0, gz.radius)
gz.ax = Angle(0, 0, 0)
gz.ay = Angle(0, 90, 0)
gz.az = Angle(90, 0, 0)
gz.mins = Vector(-10, -2, -2)
gz.maxs = Vector(10, 2, 2)

function Movable:Rotate(off)

	local csent = self:GetCSEntity()
	if not csent then return end

	local editor = octolib.flyEditor
	local around = angle_zero
	if editor.space == editor.SPACE_LOCAL then
		around = csent:GetAngles()
		off.y = -off.y
	elseif editor.space == editor.SPACE_PARENT then
		local parent = csent:GetParent()
		if IsValid(parent) then
			around = parent:GetAngles()
		end
	end

	local ang = csent:GetAngles()
	ang:RotateAroundAxis(around:Forward(), off.p)
	ang:RotateAroundAxis(around:Right(), -off.y)
	ang:RotateAroundAxis(around:Up(), off.r)

	if editor.origin == editor.ORIGIN_CENTER then
		local obbCenter = csent:OBBCenter()
		local center1 = csent:LocalToWorld(obbCenter)
		local center2 = LocalToWorld(obbCenter, angle_zero, csent:GetPos(), ang)
		self:Move(center1 - center2)
	end

	csent:SetAngles(ang)

end

function Movable:Clone()

	local info = getEntInfo(self.csent)
	info.name = self.name
	info.icon = self.icon
	local newMovable = octolib.flyEditor.addMovable(info)

	for _, child in pairs(self.csent:GetChildren()) do
		if not child.movable then continue end
		local childInfo = getEntInfo(child.movable.csent)
		childInfo.parent = newMovable.csent
		childInfo.name = child.name
		childInfo.icon = child.icon
		octolib.flyEditor.addMovable(childInfo)
	end

	return newMovable

end

function Movable:GetChanges()

	local ent, csent = self:GetEntity(), self:GetCSEntity()
	if not ent then return {} end
	if not csent then return { deleted = true } end

	return octolib.table.diff(getEntInfo(ent), getEntInfo(csent))

end

local draws = {}

function draws.move(editor, pos, ang, axis, grab)
	local scale = pos:Distance(editor.vPos) / 120
	local px = LocalToWorld(gz.dx * scale, angle_zero, pos, ang)
	local py = LocalToWorld(gz.dy * scale, angle_zero, pos, ang)
	local pz = LocalToWorld(gz.dz * scale, angle_zero, pos, ang)
	render.DrawLine(pos, px, cols.x)
	render.DrawLine(pos, py, cols.y)
	render.DrawLine(pos, pz, cols.z)
end

function draws.moveGrabbed(editor, pos, ang, axis, grab)
	local scale = pos:Distance(editor.vPos) / 120
	local movable = editor.selected
	if movable.static then return end

	local dir = editor.dir * 4096
	local dx = LocalToWorld(gz.dx * scale, angle_zero, vector_zero, ang)
	local dy = LocalToWorld(gz.dy * scale, angle_zero, vector_zero, ang)
	local dz = LocalToWorld(gz.dz * scale, angle_zero, vector_zero, ang)

	local off
	if axis == editor.AXIS_X then
		local st, en = pos - dx * 100, pos + dx * 100
		render.DrawLine(st, en, cols.x, true)
		render.DrawLine(st, en, cols.xTr)

		if math.abs(dir.y) > math.abs(dir.z) then
			local curHit = util.IntersectRayWithPlane(grab[1], dir, pos, dy)
			if not curHit then return end

			local proj = WorldToLocal(curHit, angle_zero, grab[2], ang)
			if proj.x == 0 then return end
			off = LocalToWorld(Vector(proj.x, 0, 0), angle_zero, vector_zero, ang)
		else
			local curHit = util.IntersectRayWithPlane(grab[1], dir, pos, dz)
			if not curHit then return end

			local proj = WorldToLocal(curHit, angle_zero, grab[2], ang)
			if proj.x == 0 then return end
			off = LocalToWorld(Vector(proj.x, 0, 0), angle_zero, vector_zero, ang)
		end
	elseif axis == editor.AXIS_Y then
		local st, en = pos - dy * 100, pos + dy * 100
		render.DrawLine(st, en, cols.y, true)
		render.DrawLine(st, en, cols.yTr)

		if math.abs(dir.x) > math.abs(dir.z) then
			local curHit = util.IntersectRayWithPlane(grab[1], dir, pos, dx)
			if not curHit then return end

			local proj = WorldToLocal(curHit, angle_zero, grab[2], ang)
			if proj.y == 0 then return end
			off = LocalToWorld(Vector(0, proj.y, 0), angle_zero, vector_zero, ang)
		else
			local curHit = util.IntersectRayWithPlane(grab[1], dir, pos, dz)
			if not curHit then return end

			local proj = WorldToLocal(curHit, angle_zero, grab[2], ang)
			if proj.y == 0 then return end
			off = LocalToWorld(Vector(0, proj.y, 0), angle_zero, vector_zero, ang)
		end
	elseif axis == editor.AXIS_Z then
		local st, en = pos - dz * 100, pos + dz * 100
		render.DrawLine(st, en, cols.z, true)
		render.DrawLine(st, en, cols.zTr)

		if math.abs(dir.x) > math.abs(dir.y) then
			local curHit = util.IntersectRayWithPlane(grab[1], dir, pos, dx)
			if not curHit then return end

			local proj = WorldToLocal(curHit, angle_zero, grab[2], ang)
			if proj.z == 0 then return end
			off = LocalToWorld(Vector(0, 0, proj.z), angle_zero, vector_zero, ang)
		else
			local curHit = util.IntersectRayWithPlane(grab[1], dir, pos, dy)
			if not curHit then return end

			local proj = WorldToLocal(curHit, angle_zero, grab[2], ang)
			if proj.z == 0 then return end
			off = LocalToWorld(Vector(0, 0, proj.z), angle_zero, vector_zero, ang)
		end
	end

	if off then
		local moveOff = Vector(off)
		if input.IsShiftDown() then moveOff:Mul(shiftMul) end

		if movable.limits then
			local parentPos = IsValid(movable.csent:GetParent()) and movable.csent:GetParent():GetPos() or Vector()
			local pos = movable.csent:GetPos() - parentPos
			if movable.limits.dist then
				local dist = (pos + off):LengthSqr()
				if dist > movable.limits.dist * movable.limits.dist then
					moveOff = (pos + off):GetNormalized() * movable.limits.dist - pos
				end
			end
		end

		if input.IsControlDown() then
			snapCache = snapCache or Vector()
			snapCache:Add(moveOff)

			local snapDist = snapTable.move[snapMode]
			local dist = snapCache:Length()
			local snapped = math.floor(dist / snapDist) * snapDist
			if snapped ~= 0 then
				local dir = snapCache:GetNormalized()
				movable:Move(dir * snapped)
				snapCache = dir * (dist - snapped)
			end
		else
			movable:Move(moveOff)
		end

		grab[2]:Add(off)
	end
end

local segs, circle = 30, {}
for i = 0, segs-1 do
	local rad = math.pi * 2 / segs * i
	circle[i] = { math.cos(rad), math.sin(rad) }
end

function draws.rotate(editor, pos, ang, axis, grab)
	local radius = pos:Distance(editor.vPos) / 10
	local dx = LocalToWorld(gz.dx1 * radius * 1.2, angle_zero, vector_zero, ang)
	local dy = LocalToWorld(gz.dy1 * radius * 1.2, angle_zero, vector_zero, ang)
	local dz = LocalToWorld(gz.dz1 * radius * 1.2, angle_zero, vector_zero, ang)

	local vPos, vAng = editor.vPos, editor.vAng
	local vDist = pos:DistToSqr(vPos - vAng:Forward() * 2 * radius / 20)

	for i1 = 0, segs-1 do
		local i2 = i1 < segs-1 and i1 + 1 or 0
		local c1, c2, s1, s2 = circle[i1][1], circle[i2][1], circle[i1][2], circle[i2][2]
		local p1, p2

		p1, p2 = pos + c1 * dy + s1 * dz, pos + c2 * dy + s2 * dz
		render.DrawLine(p1, p2, p1:DistToSqr(vPos) < vDist and p2:DistToSqr(vPos) < vDist and cols.x or cols.xTr)

		p1, p2 = pos + c1 * dz + s1 * dx, pos + c2 * dz + s2 * dx
		render.DrawLine(p1, p2, p1:DistToSqr(vPos) < vDist and p2:DistToSqr(vPos) < vDist and cols.y or cols.yTr)

		p1, p2 = pos + c1 * dx + s1 * dy, pos + c2 * dx + s2 * dy
		render.DrawLine(p1, p2, p1:DistToSqr(vPos) < vDist and p2:DistToSqr(vPos) < vDist and cols.z or cols.zTr)
	end
end

function draws.rotateGrabbed(editor, pos, ang, axis, grab)
	local radius = pos:Distance(editor.vPos) / 10
	local dx = LocalToWorld(gz.dx1 * radius * 1.2, angle_zero, vector_zero, ang)
	local dy = LocalToWorld(gz.dy1 * radius * 1.2, angle_zero, vector_zero, ang)
	local dz = LocalToWorld(gz.dz1 * radius * 1.2, angle_zero, vector_zero, ang)

	local mul = input.IsShiftDown() and shiftMul or 1

	local vPos, dir = editor.vPos, editor.dir
	local movable = editor.selected
	if movable.static then return end

	if axis == editor.AXIS_X then
		for i1 = 0, segs-1 do
			local i2 = i1 < segs-1 and i1+1 or 0
			local c1, c2, s1, s2 = circle[i1][1], circle[i2][1], circle[i1][2], circle[i2][2]

			local p1, p2 = pos + c1 * dy + s1 * dz, pos + c2 * dy + s2 * dz
			render.DrawLine(p1, p2, cols.x)
		end

		local curHit = util.IntersectRayWithPlane(vPos, dir, pos, dx)
		if not curHit then return end
		render.DrawLine(pos, pos + (curHit - pos):GetNormalized() * radius, color_white)

		local proj = WorldToLocal(curHit, angle_zero, pos, ang)
		local oldAng = math.atan2(grab.y, grab.z)
		local curAng = math.atan2(proj.y, proj.z)
		if oldAng ~= curAng then
			local delta = math.deg(oldAng - curAng) * mul
			if input.IsControlDown() then
				snapCache = (snapCache or 0) + delta

				local snapDist = snapTable.rotate[snapMode]
				local snapped = math.Round(snapCache / snapDist) * snapDist
				if snapped ~= 0 then
					movable:Rotate(Angle(snapped, 0, 0))
					snapCache = snapCache - snapped
				end
			else
				movable:Rotate(Angle(delta, 0, 0))
			end
			if editor.space ~= editor.SPACE_LOCAL then editor.grab = proj end
		end
	elseif axis == editor.AXIS_Y then
		for i1 = 0, segs-1 do
			local i2 = i1 < segs-1 and i1 + 1 or 0
			local c1, c2, s1, s2 = circle[i1][1], circle[i2][1], circle[i1][2], circle[i2][2]

			local p1, p2 = pos + c1 * dz + s1 * dx, pos + c2 * dz + s2 * dx
			render.DrawLine(p1, p2, cols.y)
		end

		local curHit = util.IntersectRayWithPlane(vPos, dir, pos, dy)
		if not curHit then return end
		render.DrawLine(pos, pos + (curHit - pos):GetNormalized() * radius, color_white)

		local proj = WorldToLocal(curHit, angle_zero, pos, ang)
		local oldAng = math.atan2(grab.x, grab.z)
		local curAng = math.atan2(proj.x, proj.z)
		if oldAng ~= curAng then
			local global = editor.space ~= editor.SPACE_LOCAL
			local delta = math.deg(oldAng - curAng) * mul
			if global then
				editor.grab = proj
				delta = -delta
			end

			if input.IsControlDown() then
				snapCache = (snapCache or 0) + delta

				local snapDist = snapTable.rotate[snapMode]
				local snapped = math.Round(snapCache / snapDist) * snapDist
				if snapped ~= 0 then
					movable:Rotate(Angle(0, snapped, 0))
					snapCache = snapCache - snapped
				end
			else
				movable:Rotate(Angle(0, delta, 0))
			end
		end
	elseif axis == editor.AXIS_Z then
		for i1 = 0, segs-1 do
			local i2 = i1 < segs-1 and i1 + 1 or 0
			local c1, c2, s1, s2 = circle[i1][1], circle[i2][1], circle[i1][2], circle[i2][2]

			local p1, p2 = pos + c1 * dx + s1 * dy, pos + c2 * dx + s2 * dy
			render.DrawLine(p1, p2, cols.z)
		end

		local curHit = util.IntersectRayWithPlane(vPos, dir, pos, dz)
		if not curHit then return end
		render.DrawLine(pos, pos + (curHit - pos):GetNormalized() * radius, color_white)

		local proj = WorldToLocal(curHit, angle_zero, pos, ang)
		local oldAng = math.atan2(grab.x, grab.y)
		local curAng = math.atan2(proj.x, proj.y)
		if oldAng ~= curAng then
			local delta = math.deg(oldAng - curAng) * mul
			if input.IsControlDown() then
				snapCache = (snapCache or 0) + delta

				local snapDist = snapTable.rotate[snapMode]
				local snapped = math.Round(snapCache / snapDist) * snapDist
				if snapped ~= 0 then
					movable:Rotate(Angle(0, 0, snapped))
					snapCache = snapCache - snapped
				end
			else
				movable:Rotate(Angle(0, 0, delta))
			end

			if editor.space ~= editor.SPACE_LOCAL then editor.grab = proj end
		end
	end
end

function draws.scale(editor, pos, ang, axis, grab)
	local scale = pos:Distance(editor.vPos) / 120
	local px, ax = LocalToWorld(gz.dx * scale, angle_zero, pos, ang)
	local py, ay = LocalToWorld(gz.dy * scale, angle_zero, pos, ang)
	local pz, az = LocalToWorld(gz.dz * scale, angle_zero, pos, ang)
	render.DrawLine(pos, px, cols.x)
	render.DrawLine(pos, py, cols.y)
	render.DrawLine(pos, pz, cols.z)
	local mins, maxs = Vector(-1,-1,-1) * scale, Vector(1,1,1) * scale
	render.DrawWireframeBox(px, ax, mins, maxs, cols.x)
	render.DrawWireframeBox(py, ay, mins, maxs, cols.y)
	render.DrawWireframeBox(pz, az, mins, maxs, cols.z)
end

local function scaleRecursive(ent, delta, updateLocation)
	local size, pos = ent:GetSize(), ent:GetLocalPos()
	for _, axis in ipairs({'x', 'y', 'z'}) do
		local aDelta = delta[axis]
		if aDelta ~= 0 then
			local oldSize = size[axis]
			size[axis] = oldSize + aDelta
			if updateLocation then
				pos[axis] = pos[axis] * (oldSize + aDelta) / oldSize
			end
		end
	end

	if updateLocation then
		ent:SetLocalPos(pos)
	else
		ent:SetSize(size)
	end

	for _, ent in ipairs(ent:GetChildren()) do
		scaleRecursive(ent, delta, true)
	end
end

function draws.scaleGrabbed(editor, pos, ang, axis, grab)
	local scale = pos:Distance(editor.vPos) / 120
	local movable = editor.selected
	if movable.static then return end

	local dir = editor.dir * 4096
	local dx = LocalToWorld(gz.dx * scale, angle_zero, vector_zero, ang)
	local dy = LocalToWorld(gz.dy * scale, angle_zero, vector_zero, ang)
	local dz = LocalToWorld(gz.dz * scale, angle_zero, vector_zero, ang)
	local mul = (input.IsShiftDown() and shiftMul or 1) * 0.1

	local off
	if axis == editor.AXIS_X then
		local st, en = pos - dx * 100, pos + dx * 100
		render.DrawLine(st, en, cols.x, true)
		render.DrawLine(st, en, cols.xTr)

		if math.abs(dir.y) > math.abs(dir.z) then
			local curHit = util.IntersectRayWithPlane(grab[1], dir, pos, dy)
			if not curHit then return end

			local proj = WorldToLocal(curHit, angle_zero, grab[2], ang)
			if proj.x == 0 then return end
			off = Vector(proj.x, 0, 0)
		else
			local curHit = util.IntersectRayWithPlane(grab[1], dir, pos, dz)
			if not curHit then return end

			local proj = WorldToLocal(curHit, angle_zero, grab[2], ang)
			if proj.x == 0 then return end
			off = Vector(proj.x, 0, 0)
		end
	elseif axis == editor.AXIS_Y then
		local st, en = pos - dy * 100, pos + dy * 100
		render.DrawLine(st, en, cols.y, true)
		render.DrawLine(st, en, cols.yTr)

		if math.abs(dir.x) > math.abs(dir.z) then
			local curHit = util.IntersectRayWithPlane(grab[1], dir, pos, dx)
			if not curHit then return end

			local proj = WorldToLocal(curHit, angle_zero, grab[2], ang)
			if proj.y == 0 then return end
			off = Vector(0, proj.y, 0)
		else
			local curHit = util.IntersectRayWithPlane(grab[1], dir, pos, dz)
			if not curHit then return end

			local proj = WorldToLocal(curHit, angle_zero, grab[2], ang)
			if proj.y == 0 then return end
			off = Vector(0, proj.y, 0)
		end
	elseif axis == editor.AXIS_Z then
		local st, en = pos - dz * 100, pos + dz * 100
		render.DrawLine(st, en, cols.z, true)
		render.DrawLine(st, en, cols.zTr)

		if math.abs(dir.x) > math.abs(dir.y) then
			local curHit = util.IntersectRayWithPlane(grab[1], dir, pos, dx)
			if not curHit then return end

			local proj = WorldToLocal(curHit, angle_zero, grab[2], ang)
			if proj.z == 0 then return end
			off = Vector(0, 0, proj.z)
		else
			local curHit = util.IntersectRayWithPlane(grab[1], dir, pos, dy)
			if not curHit then return end

			local proj = WorldToLocal(curHit, angle_zero, grab[2], ang)
			if proj.z == 0 then return end
			off = Vector(0, 0, proj.z)
		end
	end

	if off and off:LengthSqr() > 0 then
		off:Mul(mul)

		if movable.limits and movable.limits.scale then
			local size = movable.csent:GetSize()
			local min, max = unpack(movable.limits.scale)
			for _, axis in ipairs({'x', 'y', 'z'}) do
				off[axis] = math.Clamp(off[axis] + size[axis], min, max) - size[axis]
			end
		end

		scaleRecursive(movable.csent, off)
		grab[2]:Add(LocalToWorld(off / mul, angle_zero, vector_zero, ang))
	end
end

local function getPosAng(csent, editor)

	local pos = csent:GetPos()
	local ang

	if editor.space == editor.SPACE_LOCAL or editor.tool == editor.TOOL_SCALE then
		ang = csent:GetAngles()
	elseif editor.space == editor.SPACE_GLOBAL then
		ang = angle_zero
	elseif editor.space == editor.SPACE_PARENT then
		local parent = csent:GetParent()
		if IsValid(parent) then
			ang = parent:GetAngles()
		else
			ang = angle_zero
		end
	end

	if editor.origin == editor.ORIGIN_CENTER then
		pos = csent:LocalToWorld(csent:OBBCenter())
	end

	return pos, ang

end

function Movable:Render()

	local csent = self:GetCSEntity()
	if not csent then return end

	if not self.selected then return end

	local editor = octolib.flyEditor
	local tool = editor.tool
	local axis, grab = editor.axis, editor.grab
	local pos, ang = getPosAng(csent, editor)

	if not axis then snapCache = nil end
	if tool == editor.TOOL_MOVE then
		if not axis then
			draws.move(editor, pos, ang, axis, grab)
		else
			draws.moveGrabbed(editor, pos, ang, axis, grab)
		end
	elseif tool == editor.TOOL_ROTATE then
		if not axis then
			draws.rotate(editor, pos, ang, axis, grab)
		else
			draws.rotateGrabbed(editor, pos, ang, axis, grab)
		end
	elseif tool == editor.TOOL_SCALE then
		if not axis then
			draws.scale(editor, pos, ang, axis, grab)
		else
			draws.scaleGrabbed(editor, pos, ang, axis, grab)
		end
	end

end

function Movable:TryClick()

	local csent = self:GetCSEntity()
	if not csent then return end

	local editor = octolib.flyEditor
	local tool = editor.tool
	local vPos, vAng, dir = editor.vPos, editor.vAng, editor.dir * 4096
	local pos, ang = getPosAng(csent, editor)

	if tool == editor.TOOL_MOVE then
		local scale = pos:Distance(editor.vPos) / 120
		local px, ax = LocalToWorld(gz.dx / 2 * scale, gz.ax, pos, ang)
		if util.IntersectRayWithOBB(vPos, dir, px, ax, gz.mins * scale, gz.maxs * scale) then
			local hit = util.IntersectRayWithPlane(vPos, dir, pos, ang:Up())
			if not hit then return end
			return editor.AXIS_X, { vPos, hit }
		end

		local py, ay = LocalToWorld(gz.dy / 2 * scale, gz.ay, pos, ang)
		if util.IntersectRayWithOBB(vPos, dir, py, ay, gz.mins * scale, gz.maxs * scale) then
			local hit = util.IntersectRayWithPlane(vPos, dir, pos, ang:Up())
			if not hit then return end
			return editor.AXIS_Y, { vPos, hit }
		end

		local pz, az = LocalToWorld(gz.dz / 2 * scale, gz.az, pos, ang)
		if util.IntersectRayWithOBB(vPos, dir, pz, az, gz.mins * scale, gz.maxs * scale) then
			local hit = util.IntersectRayWithPlane(vPos, dir, pos, ang:Right())
			if not hit then return end
			return editor.AXIS_Z, { vPos, hit }
		end
	elseif tool == editor.TOOL_ROTATE then
		local radius = pos:Distance(editor.vPos) / 10
		local dx = LocalToWorld(gz.dx1 * radius * 1.2, angle_zero, vector_zero, ang)
		local dy = LocalToWorld(gz.dy1 * radius * 1.2, angle_zero, vector_zero, ang)
		local dz = LocalToWorld(gz.dz1 * radius * 1.2, angle_zero, vector_zero, ang)
		local r2 = radius * radius * 1.2 * 1.2
		local vDist = pos:DistToSqr(vPos - vAng:Forward() * 2 * radius / 20)
		local curHit

		curHit = util.IntersectRayWithPlane(vPos, dir, pos, dx)
		if curHit and curHit:DistToSqr(vPos) < vDist then
			local proj = WorldToLocal(curHit, angle_zero, pos, ang)
			if octolib.math.inRange(proj:LengthSqr() / r2, 0.8, 1.2) then
				return editor.AXIS_X, proj
			end
		end

		curHit = util.IntersectRayWithPlane(vPos, dir, pos, dy)
		if curHit and curHit:DistToSqr(vPos) < vDist then
			local proj = WorldToLocal(curHit, angle_zero, pos, ang)
			if octolib.math.inRange(proj:LengthSqr() / r2, 0.8, 1.2) then
				proj:Normalize()
				return editor.AXIS_Y, proj
			end
		end

		curHit = util.IntersectRayWithPlane(vPos, dir, pos, dz)
		if curHit and curHit:DistToSqr(vPos) < vDist then
			local proj = WorldToLocal(curHit, angle_zero, pos, ang)
			if octolib.math.inRange(proj:LengthSqr() / r2, 0.8, 1.2) then
				proj:Normalize()
				return editor.AXIS_Z, proj
			end
		end
	elseif tool == editor.TOOL_SCALE then
		local scale = pos:Distance(editor.vPos) / 120
		local px, ax = LocalToWorld(gz.dx / 2 * scale, gz.ax, pos, ang)
		if util.IntersectRayWithOBB(vPos, dir, px, ax, gz.mins * scale, gz.maxs * scale) then
			local hit = util.IntersectRayWithPlane(vPos, dir, pos, ang:Up())
			if not hit then return end
			return editor.AXIS_X, { vPos, hit }
		end

		local py, ay = LocalToWorld(gz.dy / 2 * scale, gz.ay, pos, ang)
		if util.IntersectRayWithOBB(vPos, dir, py, ay, gz.mins * scale, gz.maxs * scale) then
			local hit = util.IntersectRayWithPlane(vPos, dir, pos, ang:Up())
			if not hit then return end
			return editor.AXIS_Y, { vPos, hit }
		end

		local pz, az = LocalToWorld(gz.dz / 2 * scale, gz.az, pos, ang)
		if util.IntersectRayWithOBB(vPos, dir, pz, az, gz.mins * scale, gz.maxs * scale) then
			local hit = util.IntersectRayWithPlane(vPos, dir, pos, ang:Right())
			if not hit then return end
			return editor.AXIS_Z, { vPos, hit }
		end
	end

end
