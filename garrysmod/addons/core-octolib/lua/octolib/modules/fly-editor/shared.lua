octolib.flyEditor = octolib.flyEditor or {}

octolib.include.prefixed('meta')
octolib.include.client('vgui')

octolib.flyEditor.AXIS_X = 0
octolib.flyEditor.AXIS_Y = 1
octolib.flyEditor.AXIS_Z = 2
octolib.flyEditor.TOOL_MOVE = 0
octolib.flyEditor.TOOL_ROTATE = 1
octolib.flyEditor.TOOL_SCALE = 2
octolib.flyEditor.SPACE_GLOBAL = 0
octolib.flyEditor.SPACE_LOCAL = 1
octolib.flyEditor.SPACE_PARENT = 2
octolib.flyEditor.ORIGIN_ZERO = 0
octolib.flyEditor.ORIGIN_CENTER = 1

octolib.entDefaults = {
	parent = NULL,
	pos = Vector(),
	ang = Angle(),
	skin = 0,
	col = Color(255,255,255, 255),
	mat = '',
	scale = 1,
	bgs = {[0] = 0},
}

function octolib.applyEntData(ent, changes)

	if not IsValid(ent) then return end

	local parent = ent:GetParent()
	if changes.parent then
		if changes.parent == '--deleted--' then changes.parent = nil end
		parent = changes.parent
		ent:SetParent(parent)
	end
	if changes.pos then
		if IsValid(parent) then
			ent:SetLocalPos(changes.pos)
		else
			ent:SetPos(changes.pos)
		end
	end
	if changes.ang then
		if IsValid(parent) then
			ent:SetLocalAngles(changes.ang)
		else
			ent:SetAngles(changes.ang)
		end
	end
	if changes.model then ent:SetModel(changes.model) end
	if changes.skin then ent:SetSkin(changes.skin) end
	if changes.col then ent:SetColor(changes.col) end
	if changes.mat then ent:SetMaterial(changes.mat) end
	if changes.size then
		ent:SetModelScale(1)
		ent:SetSize(changes.size)
	elseif changes.scale then
		ent:SetModelScale(changes.scale)
	end
	if changes.bgs then
		for k, v in pairs(changes.bgs) do
			ent:SetBodygroup(k, v)
		end
	end

end
