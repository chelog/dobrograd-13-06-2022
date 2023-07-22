TOOL.Category = 'Dobrograd'
TOOL.Name = L.octoinv_desc
TOOL.Command = nil

TOOL.Information = {
	{ name = 'left' },
	{ name = 'right' },
	{ name = 'reload' },
}

if CLIENT then
	octolib.vars.init('tools.desc.time', 3)
	octolib.vars.init('tools.desc.name', L.item)
	octolib.vars.init('tools.desc.desc', L.desc_item)
end

local function doEffect(ent)

	local e = EffectData()
	e:SetEntity(ent)
	e:SetScale(1)
	util.Effect('sparkling_ent', e)

end

function TOOL:LeftClick(tr)

	local ent = tr.Entity
	if not IsValid(ent) then return false end

	if SERVER then
		if ent:IsPlayer() and not self:GetOwner():IsSuperAdmin() then
			return false
		end

		local ply = self:GetOwner()
		ply:GetClientVar({
			'tools.desc.name',
			'tools.desc.desc',
			'tools.desc.time',
		}, function(vars)
			local data = {
				name = utf8.sub(vars['tools.desc.name'], 1, 255),
				desc = utf8.sub(vars['tools.desc.desc'], 1, 512),
				time = tonumber(vars['tools.desc.time']) or 1,
			}

			doEffect(ent)
			ent:SetNetVar('dbgLook', data)
			duplicator.StoreEntityModifier(ent, 'octo_desc', data)
		end)
	end

	return true

end

function TOOL:RightClick(tr)

	if SERVER then return false end

	local ent = tr.Entity
	local look = IsValid(ent) and ent:GetNetVar('dbgLook')
	if not look then return false end

	octolib.vars.set('tools.desc.name', look.name)
	octolib.vars.set('tools.desc.desc', look.desc)
	octolib.vars.set('tools.desc.time', look.time)

	return true

end

function TOOL:Reload(tr)

	if not IsFirstTimePredicted() then return false end

	local ent = tr.Entity
	local look = IsValid(ent) and ent:GetNetVar('dbgLook')
	if not look then return false end

	if SERVER then
		ent:SetNetVar('dbgLook', nil)
		duplicator.ClearEntityModifier(ent, 'octo_desc')
	end

	doEffect(ent)

	return true

end

function TOOL:BuildCPanel()

	self:AddControl('Header', {
		Text = L.octoinv_desc,
		Description = L.octo_desc_hint
	})

	octolib.vars.presetManager(self, 'tools.desc', {'tools.desc.time', 'tools.desc.name', 'tools.desc.desc'})

	octolib.vars.slider(self, 'tools.desc.time', L.time_see, 0.1, 60, 1)
	octolib.vars.textEntry(self, 'tools.desc.name', L.title)

	self:ControlHelp(L.octo_desc_empty)
	local eDesc = octolib.vars.textEntry(self, 'tools.desc.desc', L.octoinv_desc)
	eDesc:SetMultiline(true)
	eDesc:SetTall(150)
	eDesc:SetContentAlignment(7)

	self:ControlHelp(L.octo_desc_help)

	-- fuck DForm
	for _, pnl in ipairs(self:GetChildren()) do
		pnl:DockPadding(10, 0, 10, 0)
	end

end

if CLIENT then
	language.Add('Tool.octo_desc.name', L.octoinv_desc)
	language.Add('Tool.octo_desc.desc', L.octo_desc)
	language.Add('Tool.octo_desc.left', L.assign)
	language.Add('Tool.octo_desc.right', L.tool_copy)
	language.Add('Tool.octo_desc.reload', L.remove)
else
	duplicator.RegisterEntityModifier('octo_desc', function(ply, ent, data)
		local override = hook.Run('CanTool', ply, { Entity = ent }, 'octo_desc')
		if override == false then return end
		ent:SetNetVar('dbgLook', data)
	end)
end
