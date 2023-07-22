TOOL.Category = 'Dobrograd'
TOOL.Name = L.octo_perma
TOOL.Command = nil

TOOL.Information = {
	{ name = 'left' },
	{ name = 'right' },
}

local function doEffect(ent)

	local e = EffectData()
	e:SetEntity(ent)
	e:SetScale(1)
	util.Effect('sparkling_ent', e)

end

function TOOL:LeftClick(tr)

	local base = tr.Entity
	if not IsValid(base) or base:IsPlayer() or not self:GetOwner():query(L.permissions_permaprops) then return false end

	if SERVER then
		local data = duplicator.Copy(base)
		permaprops.clearData(data)

		for id, entData in pairs(data.Entities) do
			local ent = Entity(id)
			if IsValid(ent) then
				ent:Remove()
			end
		end

		permaprops.spawn(data)
	end

	return true

end

function TOOL:RightClick(tr)

	local ent = tr.Entity
	if not IsValid(ent) then return false end

	if SERVER then
		self:GetOwner():ChatPrint(ent.perma and L.prop_set_perma or L.prop_not_perma)
	end

	return true

end

function TOOL:BuildCPanel()

	self:AddControl('Header', {
		Text = L.octoinv_desc,
		Description = L.octo_perma_hint,
	})

	self:Button(L.save, 'octo_perma_save')
	self:ControlHelp(L.perma_save_hint)

	self:Button(L.octo_perma_restart, 'octo_perma_load')
	self:ControlHelp(L.perma_restart_hint)

	self:Button(L.remove_from_map, 'octo_perma_clear')
	self:ControlHelp(L.remove_from_map_hint)

end

if CLIENT then
	language.Add('Tool.octo_perma.name', L.octo_perma)
	language.Add('Tool.octo_perma.desc', L.octo_perma_desc)
	language.Add('Tool.octo_perma.left', L.octo_perma)
	language.Add('Tool.octo_perma.right', L.check_perma)
end
