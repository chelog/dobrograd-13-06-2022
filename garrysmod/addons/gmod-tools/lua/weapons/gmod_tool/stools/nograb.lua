TOOL.Category = 'Dobrograd'
TOOL.Name = 'Запретить хватать'
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

	if SERVER and not ent.nograb then
		ent.nograb = true
		duplicator.StoreEntityModifier(ent, 'nograb', {})
		self:GetOwner():ChatPrint('Теперь это нельзя схватить рукой')

		doEffect(ent)
	end

	return true

end

function TOOL:RightClick(tr)

	local ent = tr.Entity
	if not IsValid(ent) then return false end

	if SERVER and ent.nograb then
		ent.nograb = nil
		duplicator.ClearEntityModifier(ent, 'nograb')
		self:GetOwner():ChatPrint('Теперь это можно схватить рукой')

		doEffect(ent)
	end

	return true

end

function TOOL:BuildCPanel()

	self:AddControl('Header', {
		Text = 'Запретить хвататься',
		Description = 'Этот инструмент отключает возможность хватать предмет рукой'
	})

end

if CLIENT then
	language.Add('Tool.nograb.name', 'Запретить хвататься')
	language.Add('Tool.nograb.desc', 'Отключает возможность хватать предмет рукой')
	language.Add('Tool.nograb.left', 'Запретить')
	language.Add('Tool.nograb.right', 'Восстановить')
else
	duplicator.RegisterEntityModifier('nograb', function(ply, ent, data)
		local override = hook.Run('CanTool', ply, { Entity = ent }, 'nograb')
		if override == false then return end
		ent.nograb = data ~= nil
	end)

	hook.Add('dbg-hands.canDrag', 'tool.nograb', function(ply, ent, tr)
		if ent.nograb then
			return false
		end
	end)
end
