TOOL.Category = 'Dobrograd'
TOOL.Name = 'Запретить посадку'
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

	if SERVER and not ent.nosit then
		ent.nosit = true
		duplicator.StoreEntityModifier(ent, 'nosit', {})
		self:GetOwner():ChatPrint('Теперь на этом нельзя сидеть')

		doEffect(ent)
	end

	return true
	
end

function TOOL:RightClick(tr)

	local ent = tr.Entity
	if not IsValid(ent) then return false end

	if SERVER and ent.nosit then
		ent.nosit = nil
		duplicator.ClearEntityModifier(ent, 'nosit')
		self:GetOwner():ChatPrint('Запрет на посадку снят')

		doEffect(ent)
	end

	return true

end

function TOOL:BuildCPanel()

	self:AddControl('Header', {
		Text = 'Запретить посадку',
		Description = 'Этот инструмент отключает возможность сидеть на предметах'
	})

end

if CLIENT then
	language.Add('Tool.nosit.name', 'Запретить посадку')
	language.Add('Tool.nosit.desc', 'Отключает возможность сидеть на предметах')
	language.Add('Tool.nosit.left', 'Запретить')
	language.Add('Tool.nosit.right', 'Восстановить')
else
	duplicator.RegisterEntityModifier('nosit', function(ply, ent, data)
		local override = hook.Run('CanTool', ply, { Entity = ent }, 'nosit')
		if override == false then return end
		ent.nosit = data ~= nil
	end)

	hook.Add('dbg-sit.allow', 'tool.nosit', function(ply, ent, pos, ang)
		if IsValid(ent) and ent.nosit then
			return false
		end
	end)
end
