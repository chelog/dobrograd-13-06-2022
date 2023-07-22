local editor = octolib.flyEditor
editor.active = false
editor.baseMoveSpeed = 1
editor.ply = LocalPlayer()
editor.vPos = Vector()
editor.vAng = Angle()
editor.fov = 80
editor.anchor = Vector()
editor.radius = 300
editor.movablePosCache = {}
editor.cmd = {
	fly = true,
	move = Vector(),
	rotate = Angle(),
}

editor.dir = Vector()
editor.movables = {}
editor.moveSpeed = 100
editor.dist = 0

local sensitivity = GetConVar('sensitivity'):GetFloat()
local vector_zero, angle_zero = Vector(), Angle()
local colHighlight = Color(247, 132, 5)

surface.CreateFont('fly-editor.notify', {
	font = 'Calibri',
	extended = true,
	size = 24,
	weight = 350,
})

hook.Add('PreDrawHalos', 'fly-editor.scene', function()
	if not editor.highlight then return end
	halo.Add({ editor.highlight.csent }, colHighlight, 2, 2, 2)
end)

function editor.getAnchorPos()

	if IsValid(editor.anchorEnt) then
		return editor.anchorEnt:LocalToWorld(editor.anchor)
	else
		return editor.anchor
	end

end

function editor.setMaxDist(dist)

	editor.radius = dist
	editor.sphereSegments = math.Clamp(math.floor(dist * 0.07), 8, 100)

end

function editor.notify(text, time)

	time = time or 1.5
	editor.message = { text, CurTime() + time }

end

function editor.exit()

	editor.active = false

	if IsValid(editor.pnlScene) then editor.pnlScene:Remove() end
	if IsValid(editor.pnlToolbar) then editor.pnlToolbar:Remove() end
	if IsValid(editor.pnlActions) then editor.pnlActions:Remove() end
	if IsValid(editor.pnlInspector) then editor.pnlInspector:Remove() end
	for _, movable in pairs(editor.movables) do
		movable:Remove()
	end
	table.Empty(editor.movables)

	if editor.options and editor.options.canCreate then
		concommand.Add('gm_spawn', function(_, _, args) netstream.Start('gm_spawn', args) end)
	end

end

function editor.addMovable(data, id)

	if data.parent and not isentity(data.parent) then
		local propParent = editor.movables[data.parent]
		data.parent = isentity(propParent) and propParent or
			istable(propParent) and propParent.csent or data.parent
	end

	if not id then id = #editor.movables + 1 end
	return octolib.createMoveable(data, id)

end

local buts = {}
function editor.start(options, funcOk, funcCancel)

	if editor.active or not funcOk then return end

	options = options or {}

	editor.active = true
	editor.doneClickerFix = false
	editor.ply = LocalPlayer()
	editor.vAng = options.vAng or editor.ply:EyeAngles()
	editor.vPos = options.vPos or (editor.ply:EyePos() - editor.vAng:Forward() * 15)
	editor.anchorEnt = options.anchorEnt
	editor.anchor = Vector(options.anchor or IsValid(editor.anchorEnt) and Vector() or editor.vPos)
	editor.setMaxDist(options.maxDist or 300)
	editor.tool = options.tool or editor.TOOL_MOVE
	editor.space = options.space or editor.SPACE_GLOBAL
	editor.origin = options.origin or editor.ORIGIN_ZERO
	editor.options = options

	editor.pnlScene = vgui.Create 'fe_scene'
	editor.pnlInspector = vgui.Create 'fe_inspector'

	local toolbar = vgui.Create 'fe_toolbar'
	toolbar:SetAlignment(7)
	editor.pnlToolbar = toolbar

	buts.tMove = toolbar:AddButton('Двигать', 'octoteam/icons-32/transform_move.png', function(but)
		editor.selectTool(editor.TOOL_MOVE)
		editor.notify('Инструмент: Двигать')
	end)
	buts.tMove:SetAlpha(editor.tool == editor.TOOL_MOVE and 255 or 50)
	buts.tRotate = toolbar:AddButton('Вращать', 'octoteam/icons-32/transform_rotate.png', function(but)
		editor.selectTool(editor.TOOL_ROTATE)
		editor.notify('Инструмент: Вращать')
	end)
	buts.tRotate:SetAlpha(editor.tool == editor.TOOL_ROTATE and 255 or 50)
	buts.tScale = toolbar:AddButton('Изменить размер', 'octoteam/icons-32/transform_scale.png', function(but)
		editor.selectTool(editor.TOOL_SCALE)
		editor.notify('Инструмент: Размер')
	end)
	buts.tScale:SetAlpha(editor.tool == editor.TOOL_SCALE and 255 or 50)

	toolbar:AddSpacer()

	buts.sGlobal = toolbar:AddButton('Глобальное пространство', 'octoteam/icons-32/globe_network.png', function(but)
		editor.space = editor.SPACE_GLOBAL
		buts.sGlobal:SetAlpha(255)
		buts.sLocal:SetAlpha(50)
		buts.sParent:SetAlpha(50)
		editor.notify('Пространство: Глобальное')
	end)
	buts.sGlobal:SetAlpha(editor.space == editor.SPACE_GLOBAL and 255 or 50)
	buts.sLocal = toolbar:AddButton('Локальное пространство', 'octoteam/icons-32/drive_network.png', function(but)
		editor.space = editor.SPACE_LOCAL
		buts.sGlobal:SetAlpha(50)
		buts.sLocal:SetAlpha(255)
		buts.sParent:SetAlpha(50)
		editor.notify('Пространство: Локальное')
	end)
	buts.sLocal:SetAlpha(editor.space == editor.SPACE_LOCAL and 255 or 50)
	buts.sParent = toolbar:AddButton('Пространство родителя', 'octoteam/icons-32/network_folder.png', function(but)
		editor.space = editor.SPACE_PARENT
		buts.sGlobal:SetAlpha(50)
		buts.sLocal:SetAlpha(50)
		buts.sParent:SetAlpha(255)
		editor.notify('Пространство: Родитель')
	end)
	buts.sParent:SetAlpha(editor.space == editor.SPACE_PARENT and 255 or 50)

	toolbar:AddSpacer()

	buts.oZero = toolbar:AddButton('Нулевая ось', 'octoteam/icons-32/shape_align_bottom.png', function(but)
		editor.origin = editor.ORIGIN_ZERO
		buts.oZero:SetAlpha(255)
		buts.oCenter:SetAlpha(50)
		editor.notify('Ось: Нулевая')
	end)
	buts.oZero:SetAlpha(editor.origin == editor.ORIGIN_ZERO and 255 or 50)
	buts.oCenter = toolbar:AddButton('Центральная ось', 'octoteam/icons-32/shape_align_middle.png', function(but)
		editor.origin = editor.ORIGIN_CENTER
		buts.oZero:SetAlpha(50)
		buts.oCenter:SetAlpha(255)
		editor.notify('Ось: Центр')
	end)
	buts.oCenter:SetAlpha(editor.origin == editor.ORIGIN_CENTER and 255 or 50)

	toolbar:AddSpacer()
	buts.aResetProp = toolbar:AddButton('Сбросить положение', 'octoteam/icons-32/arrow_rotate_anticlockwise.png', function(but)
		if not editor.selected then return end
		local ent = editor.selected.csent
		ent:SetAngles(Angle())
		ent:SetModelScale(1)
		ent:SetSize(Vector(1,1,1))
		editor.notify('Положение сброшено')
	end)

	local function getChanges()
		local changes = {}
		for i, movable in pairs(editor.movables) do
			local changesHere = movable:GetChanges()
			if not table.IsEmpty(changesHere) then
				changes[movable.id or movable:GetEntity()] = changesHere
			end
		end
		return changes
	end

	local actions = vgui.Create 'fe_toolbar'
	actions:SetAlignment(8)
	editor.pnlActions = actions

	if options.buttons then
		for _, button in ipairs(options.buttons) do
			actions:AddButton(unpack(button))
		end
		actions:AddSpacer()
	end

	if options.canCreate then
		if istable(options.canCreate) then
			actions:AddButton('Добавить', 'octoteam/icons-32/add.png', function(but)
				octolib.menu(octolib.table.mapSequential(options.canCreate, function(data)
					return { data[1], nil, function()
						local prop = table.Copy(data[2])
						local tr = util.QuickTrace(editor.vPos, editor.vAng:Forward() * 2048)
						prop.pos = tr.Hit and tr.HitPos or editor.vPos
						editor.addMovable(prop)
					end}
				end)):Open()
			end)
			actions:AddSpacer()
		else
			concommand.Add('gm_spawn', function(_, _, args)
				local mdl = args[1]
				if not mdl then return end

				local tr = util.QuickTrace(editor.vPos, editor.vAng:Forward() * 1000)
				editor.addMovable({
					model = mdl,
					pos = tr.Hit and tr.HitPos or editor.vPos,
				})
			end)
		end
	end

	actions:AddButton('Применить', 'octoteam/icons-32/tick.png', function(but)
		local changes = getChanges()
		local doNotClose = funcOk(changes)
		if doNotClose ~= true then
			editor.exit()
		end
	end)
	actions:AddButton('Отмена', 'octoteam/icons-32/cross.png', function(but)
		if funcCancel then
			local changes = getChanges()
			funcCancel(changes)
		end
		editor.exit()
	end)

	for id, prop in pairs(options.props or {}) do
		if options.parent and not prop.parent then
			prop.parent = options.parent
			if not prop.pos then
				prop.pos = Vector()
				prop.ang = Angle()
			end
		end

		editor.addMovable(prop, id)
	end

	editor.recalcMovablePositions()

end
netstream.Hook('octolib.fly-editor', function(id, options)

	editor.start(options, function(changes)
		netstream.Start('octolib.fly-editor', id, true, changes)
	end, function(changes)
		netstream.Start('octolib.fly-editor', id, false, changes)
	end)

end)

function editor.selectTool(tool)
	editor.tool = tool
	buts.tMove:SetAlpha(tool == editor.TOOL_MOVE and 255 or 50)
	buts.tRotate:SetAlpha(tool == editor.TOOL_ROTATE and 255 or 50)
	buts.tScale:SetAlpha(tool == editor.TOOL_SCALE and 255 or 50)
	editor.grab = nil
	editor.axis = nil
end

function editor.recalcMovablePositions()

	table.Empty(editor.movablePosCache)
	for id, movable in pairs(editor.movables) do
		if IsValid(movable.csent) then
			editor.movablePosCache[id] = movable.csent:LocalToWorld(movable.csent:OBBCenter()):ToScreen()
		end
	end

end

local wasPressing = {}
function editor.thinkInput()

	local cmd = editor.cmd
	cmd.lmb = input.IsMouseDown(MOUSE_LEFT) and (vgui.IsHoveringWorld() or wasPressing.lmb)
	cmd.rmb = input.IsMouseDown(MOUSE_RIGHT) and (vgui.IsHoveringWorld() or wasPressing.rmb)
	cmd.alt = input.IsKeyDown(KEY_LALT)
	cmd.shift = input.IsKeyDown(KEY_LSHIFT)

	if cmd.lmb ~= wasPressing.lmb then
		if editor.highlight and cmd.lmb then
			editor.pnlScene:SelectByMovable(editor.highlight)
		elseif editor.selected then
			if cmd.lmb then
				editor.axis, editor.grab = editor.selected:TryClick()
			else
				editor.axis, editor.grab = nil
				editor.recalcMovablePositions()
			end
		end
	end

	if cmd.rmb ~= wasPressing.rmb then
		local enable = cmd.rmb
		cmd.isMoving = enable
		if enable then wasPressing.mousePos = { gui.MousePos() } end
		gui.EnableScreenClicker(not enable)
		if not enable then
			gui.SetMousePos(unpack(wasPressing.mousePos or {0,0}))
			editor.recalcMovablePositions()
		end
	end

	editor.moveSpeed = (cmd.shift and 300 or cmd.alt and 25 or 100) * editor.baseMoveSpeed
	wasPressing.lmb = cmd.lmb
	wasPressing.rmb = cmd.rmb

	if input.IsKeyDown(KEY_DELETE) and editor.selected and not editor.selected.static then
		editor.selected:Remove()
	end

end

local hull = { Vector(-5, -5, -5), Vector(5, 5, 5) }
function editor.thinkMoving()

	local cmd = editor.cmd

	editor.vAng:Add(cmd.rotate * sensitivity / 200)

	local magSqr = cmd.move:LengthSqr()
	if magSqr > 0 then
		local move = cmd.move:GetNormalized() * editor.moveSpeed * FrameTime()

		local delta = editor.vAng:Forward() * move.y + editor.vAng:Right() * move.x
		if move.x ~= 0 or move.y ~= 0 then
			delta = delta + editor.vAng:Up() * move.z
		else
			delta = Vector(0, 0, move.z)
		end
		local tgtPos = editor.vPos + delta

		if not editor.options.noclip then
			local tr = util.TraceHull {
				start = editor.vPos,
				endpos = tgtPos,
				mins = hull[1],
				maxs = hull[2],
				mask = MASK_SOLID_BRUSHONLY,
			}

			if tr.Hit then
				local ang = tr.HitNormal:Angle()
				local rest = WorldToLocal(tgtPos, angle_zero, tr.HitPos, ang)
				rest.x = 0
				delta = LocalToWorld(rest, angle_zero, vector_zero, ang)
				tgtPos = editor.vPos + delta

				local tr = util.TraceHull {
					start = editor.vPos,
					endpos = tgtPos,
					mins = hull[1],
					maxs = hull[2],
					mask = MASK_SOLID_BRUSHONLY,
				}

				if tr.Hit then
					delta = tr.HitPos - editor.vPos
				end
			end
		end
		editor.vPos:Add(delta)

		local anchor = editor.getAnchorPos()
		editor.dist = editor.vPos:Distance(anchor)
		if editor.radius > 0 and editor.dist > editor.radius then
			editor.vPos = anchor + (editor.vPos - anchor):GetNormalized() * editor.radius
		end
	end

end

local function getHoveredMovable()

	local mx, my = gui.MousePos()
	local editor = octolib.flyEditor
	for id, scrPos in pairs(editor.movablePosCache) do
		if math.abs(scrPos.x - mx) < 15 and math.abs(scrPos.y - my) < 15 and editor.movables[id] ~= editor.selected then
			return editor.movables[id]
		end
	end

end

function editor.thinkIdle()

	local pnl = vgui.GetHoveredPanel()
	local hoveredByPanel = IsValid(pnl) and IsValid(pnl:GetParent()) and pnl:GetParent().movable
	local hoveredInWorld = getHoveredMovable()
	editor.highlight = hoveredByPanel or hoveredInWorld or nil

	local editor = octolib.flyEditor
	local inspector = editor.pnlInspector
	local inspectorVisible = inspector:IsVisible()
	if editor.selected and not inspectorVisible then
		inspector:SetVisible(true)
	elseif not editor.selected and inspectorVisible then
		inspector:SetVisible(false)
	end

end

function editor.thinkAnchor()

	local anchor = editor.anchorEnt
	if not IsValid(anchor) then return end

	local newPos, newAng = anchor:GetPos(), anchor:GetAngles()
	if not editor.lastAnchorPos then
		editor.lastAnchorPos = newPos
		editor.lastAnchorAng = newAng
	end

	if newPos ~= editor.lastAnchorPos then
		editor.vPos:Add(newPos - editor.lastAnchorPos)
		editor.lastAnchorPos = newPos
	end

	if newAng ~= editor.lastAnchorAng then
		local angDelta = newAng - editor.lastAnchorAng
		editor.vAng:Add(angDelta)

		local relPos = anchor:WorldToLocal(editor.vPos)
		local newRelPos = Vector(relPos)
		newRelPos:Rotate(angDelta)
		local posDelta = LocalToWorld(newRelPos - relPos, angle_zero, vector_zero, newAng)
		editor.vPos:Add(posDelta)

		editor.lastAnchorAng = newAng
	end

end

local binds = {
	invnext = function()
		if not editor.cmd.isMoving then return end
		editor.baseMoveSpeed = math.max(editor.baseMoveSpeed * 0.5, 0.25)
		editor.notify('Скорость передвижения: x' .. math.Round(editor.baseMoveSpeed, 2))
		return true
	end,
	invprev = function()
		if not editor.cmd.isMoving then return end
		editor.baseMoveSpeed = math.min(editor.baseMoveSpeed * 2, 32)
		editor.notify('Скорость передвижения: x' .. math.Round(editor.baseMoveSpeed, 2))
		return true
	end,
	slot1 = function() if IsValid(buts.tMove) then buts.tMove:DoClick() return true end end,
	slot2 = function() if IsValid(buts.tRotate) then buts.tRotate:DoClick() return true end end,
	slot3 = function() if IsValid(buts.tScale) then buts.tScale:DoClick() return true end end,
	slot4 = function() if IsValid(buts.sGlobal) then buts.sGlobal:DoClick() return true end end,
	slot5 = function() if IsValid(buts.sLocal) then buts.sLocal:DoClick() return true end end,
	slot6 = function() if IsValid(buts.sParent) then buts.sParent:DoClick() return true end end,
	slot7 = function() if IsValid(buts.oZero) then buts.oZero:DoClick() return true end end,
	slot8 = function() if IsValid(buts.oCenter) then buts.oCenter:DoClick() return true end end,
	['+use'] = function()
		if editor.tool == editor.TOOL_MOVE and IsValid(buts.tRotate) then return buts.tRotate:DoClick() end
		if editor.tool == editor.TOOL_ROTATE and IsValid(buts.tScale) then return buts.tScale:DoClick() end
		if editor.tool == editor.TOOL_SCALE and IsValid(buts.tMove) then return buts.tMove:DoClick() end
	end,
	['+reload'] = function()
		if editor.space == editor.SPACE_GLOBAL and IsValid(buts.sLocal) then return buts.sLocal:DoClick() end
		if editor.space == editor.SPACE_LOCAL and IsValid(buts.sParent) then return buts.sParent:DoClick() end
		if editor.space == editor.SPACE_PARENT and IsValid(buts.sGlobal) then return buts.sGlobal:DoClick() end
	end,
	['impulse 100'] = function()
		if editor.origin == editor.ORIGIN_ZERO and IsValid(buts.oCenter) then return buts.oCenter:DoClick() end
		if editor.origin == editor.ORIGIN_CENTER and IsValid(buts.oZero) then return buts.oZero:DoClick() end
	end,
}

hook.Add('PlayerBindPress', 'fly-editor', function(ply, bind, press)

	if editor.active and binds[bind] and press then
		return binds[bind]()
	end

end)

hook.Add('dbg-view.override', 'fly-editor', function()
	if editor.active then return false end
end)

hook.Add('ShouldDrawLocalPlayer', 'fly-editor', function()
	if editor.active then return true end
end)

hook.Add('CalcView', 'fly-editor', function(ply, pos, ang, fov)

	if not editor.active then return end

	editor.thinkInput()
	editor.thinkAnchor()

	if editor.cmd.isMoving then
		editor.thinkMoving()
	else
		editor.thinkIdle()
	end

	return {
		origin = editor.vPos,
		angles = editor.vAng,
		fov = editor.fov,
	}

end)

hook.Add('CreateMove', 'fly-editor', function(cmd)

	if not editor.active then return end

	local move = editor.cmd.move
	move.x = cmd:GetSideMove()
	move.y = cmd:GetForwardMove()
	move.z = cmd:KeyDown(IN_JUMP) and 10000 or 0

	cmd:ClearMovement()
	cmd:ClearButtons()

end)

hook.Add('InputMouseApply', 'fly-editor', function(cmd, x, y, ang)

	if not editor.active then return end

	local rotate = editor.cmd.rotate
	rotate.p = y
	rotate.y = -x

	cmd:SetMouseX(0)
	cmd:SetMouseY(0)

	return true

end)

hook.Add('RenderScene', 'fly-editor', function(pos, ang, fov)

	if not editor.active then return end

	local mx, my = gui.MousePos()
	local dir = util.AimVector(ang, fov, mx, my, ScrW(), ScrH())

	local tr = util.TraceLine {
		start = editor.vPos,
		endpos = editor.vPos + dir * 4096,
	}

	editor.dir = dir
	editor.trace = tr

end)

hook.Add('PostDrawTranslucentRenderables', 'fly-editor', function()

	if not editor.active then return end

	if editor.radius > 0 then
		local al = editor.dist / editor.radius
		if al > 0.8 then
			local segs = editor.sphereSegments

			local col = Color(255,255,255, (al - 0.8) * 5 * 30)
			render.SetColorMaterial()
			render.CullMode(MATERIAL_CULLMODE_CW)
			render.DrawSphere(editor.getAnchorPos(), editor.radius + 15, segs, segs, col)
			render.CullMode(MATERIAL_CULLMODE_CCW)
		end
	end

	local movable = editor.selected
	if movable and IsValid(movable.csent) then
		movable:Render()
	end

end)

local cols = CFG.skinColors
hook.Add('HUDPaint', 'fly-editor', function()

	if not editor.active then return end

	if not editor.doneClickerFix then -- hack to fix opening with console
		gui.EnableScreenClicker(true)
		editor.doneClickerFix = true
	end

	local msg = editor.message
	if msg then
		local al = math.min(msg[2] - CurTime(), 1)
		if al > 0 then
			surface.SetAlphaMultiplier(al)

			surface.SetFont('fly-editor.notify')
			local x, y = ScrW() / 2, ScrH() - 50
			local w, h = surface.GetTextSize(msg[1])

			draw.RoundedBox(8, x - w/2 - 10, y - h/2 - 3, w + 20, h + 6, ColorAlpha(cols.bg, 200))
			draw.SimpleText(msg[1], 'fly-editor.notify', x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			surface.SetAlphaMultiplier(1)
		else
			editor.message = nil
		end
	end

end)

editor.exit()

-- local canCreate = {}
-- for k, v in pairs(octoinv.collectables) do
-- 	for i, mdl in ipairs(v.models) do
-- 		local data = {}
-- 		if istable(mdl) then
-- 			data.model = mdl[1]
-- 			data.skin = mdl.skin
-- 			data.scale = mdl.scale
-- 			data.col = mdl.color
-- 		else
-- 			data.model = mdl
-- 		end

-- 		canCreate[#canCreate + 1] = {v.name .. ' ' .. i, data}
-- 	end
-- end

-- octolib.flyEditor(me, {
-- 	canCreate = canCreate,
-- 	maxDist = 0,
-- 	noclip = true,
-- }, function(changed, options)
-- 	PrintTable(changed)
-- end)
