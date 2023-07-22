TOOL.Category = 'Dobrograd'
TOOL.Name = 'Тени'
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

	local ent = tr.Entity
	if not IsValid(ent) then return false end

	if SERVER then
		ent:DrawShadow(false)
		duplicator.StoreEntityModifier(ent, 'noshadow', {})

		doEffect(ent)
	end

	return true
	
end

function TOOL:RightClick(tr)

	local ent = tr.Entity
	if not IsValid(ent) then return false end

	if SERVER then
		ent:DrawShadow(true)
		duplicator.ClearEntityModifier(ent, 'noshadow')

		doEffect(ent)
	end

	return true

end

function TOOL:BuildCPanel()

	self:AddControl('Header', {
		Text = 'Тени',
		Description = 'Этот инструмент позволяет включать и отключать тени на предметах'
	})

end

if CLIENT then
	language.Add('Tool.noshadow.name', 'Тени')
	language.Add('Tool.noshadow.desc', 'Отключает/включает тени на предметах')
	language.Add('Tool.noshadow.left', 'Отключить')
	language.Add('Tool.noshadow.right', 'Включить')
else
	duplicator.RegisterEntityModifier('noshadow', function(ply, ent, data)
		local override = hook.Run('CanTool', ply, { Entity = ent }, 'noshadow')
		if override == false then return end
		timer.Simple(1, function()
			ent:DrawShadow(data == nil)
		end)
	end)
end
