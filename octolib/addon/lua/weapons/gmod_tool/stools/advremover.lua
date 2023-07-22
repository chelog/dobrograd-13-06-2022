TOOL.Category = 'octolib'
TOOL.Name = 'Advanced Remover'

TOOL.Information = {
	{ name = 'left' },
	{ name = 'right' },
}

octolib.vars.init('tools.advremover.radius', 100)
octolib.vars.init('tools.advremover.own', true)
octolib.vars.init('tools.advremover.ignoreWeapons', true)

local function DoRemoveEntity(ent)

	if (!IsValid(ent) || ent:IsPlayer()) then return false end

	-- Nothing for the client to do here
	if (CLIENT) then return true end

	-- Remove all constraints (this stops ropes from hanging around)
	constraint.RemoveAll(ent)

	-- Remove it properly in 1 second
	timer.Simple(1, function() if (IsValid(ent)) then ent:Remove() end end)

	-- Make it non solid
	ent:SetNotSolid(true)
	ent:SetMoveType(MOVETYPE_NONE)
	ent:SetNoDraw(true)

	-- Send Effect
	local ed = EffectData()
		ed:SetOrigin(ent:GetPos())
		ed:SetEntity(ent)
	util.Effect('entity_remove', ed, true, true)

	return true

end

local ignoreClasses = octolib.array.toKeys{ 'player', 'predicted_viewmodel' }

function TOOL:LeftClick(trace)

	if SERVER then
		local ply = self:GetOwner()
		ply:GetClientVar({
			'tools.advremover.radius',
			'tools.advremover.own',
			'tools.advremover.ignoreWeapons',
		}, function(vars)
			for _, ent in ipairs(ents.FindInSphere(trace.HitPos, math.Clamp(vars['tools.advremover.radius'], 1, 1000))) do
				if hook.Run('CanTool', ply, octolib.entity.dummyTrace(ent), 'advremover') == false then continue end
				if ignoreClasses[ent:GetClass()] then continue end
				if vars['tools.advremover.own'] and ent:CPPIGetOwner() ~= ply then continue end
				if vars['tools.advremover.ignoreWeapons'] and ent:IsWeapon() and IsValid(ent:GetOwner()) then continue end

				DoRemoveEntity(ent)
			end
		end)
	end

	return true

end

local enabled = false
function TOOL:RightClick()

	if SERVER or not IsFirstTimePredicted() then return end

	enabled = not enabled

	if enabled then
		hook.Add('PostDrawTranslucentRenderables', 'octolib.advremover', function()
			local pos = LocalPlayer():GetEyeTrace().HitPos
			if not pos then return end

			local r = octolib.vars.get('tools.advremover.radius')
			local steps = math.Clamp(math.floor(math.pow(r, 0.5)), 6, 50)

			render.DrawWireframeSphere(pos, r, steps, steps, ColorAlpha(color_white, 10))
			render.DrawWireframeSphere(pos, r, steps, steps, color_white, true)
		end)
	else
		hook.Remove('PostDrawTranslucentRenderables', 'octolib.advremover')
	end

end

function TOOL:Holster()

	if SERVER then return end

	hook.Remove('PostDrawTranslucentRenderables', 'octolib.advremover')

end

function TOOL:BuildCPanel()

	octolib.vars.slider(self, 'tools.advremover.radius', 'Радиус', 1, 1000, 0)
	octolib.vars.checkBox(self, 'tools.advremover.own', 'Только мои энтити')
	octolib.vars.checkBox(self, 'tools.advremover.ignoreWeapons', 'Игнорировать оружие в руках')

end

if CLIENT then
	language.Add('Tool.advremover.name', 'Advanced Remover')
	language.Add('Tool.advremover.desc', 'Удалитель с плюшками')
	language.Add('Tool.advremover.left', 'Удалить в радиусе')
	language.Add('Tool.advremover.left', 'Включить предпросмотр зоны')
end
