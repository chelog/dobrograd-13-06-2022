include 'shared.lua'

surface.CreateFont('octoinv-3d.normal', {
	font = 'Calibri',
	extended = true,
	size = 32,
	weight = 350,
})

local colors = CFG.skinColors
function ENT:Draw()

	self:DrawModel()

	local al = math.Clamp(1 - (self:GetPos():DistToSqr(EyePos()) - 40000) / 40000, 0, 1)
	if al > 0 then
		local pos, ang = LocalToWorld(Vector(8.15, -23, 43), Angle(0, 90, 90), self:GetPos(), self:GetAngles())
		cam.Start3D2D(pos, ang, 0.1)
			surface.SetAlphaMultiplier(al)
			draw.RoundedBox(8, 0, 0, 350, 580, colors.bg50)
			local data = self:GetNetVar('contents')
			if data then
				for i, item in ipairs(data) do
					local x, y = 5, 5 + (i-1) * 83
					draw.RoundedBoxEx(8, x + 70, y, 270, 70, Color(170,119,102), false, true, false, true)
					draw.RoundedBoxEx(8, x, y, 70, 70, color_white, true, false, true, false)
					if item.icon then
						surface.SetDrawColor(255,255,255)
						surface.SetMaterial(Material(item.icon))
						surface.DrawTexturedRect(x+3, y+3, 64, 64)

						draw.SimpleText(DarkRP.formatMoney(item.price), '3d.medium', x+330, y+45, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
						local name = item.name
						surface.SetFont('octoinv-3d.normal')
						local tw, th = surface.GetTextSize(name)
						-- if item.amount then name = string.format('(%s) %s', item.amount, name) end
						if tw > 250 then
							render.ClearStencil()
							render.SetStencilEnable(true)

							render.SetStencilWriteMask(1)
							render.SetStencilTestMask(1)
							render.SetStencilReferenceValue(1)

							render.SetStencilCompareFunction(STENCIL_NEVER)
							render.SetStencilFailOperation(STENCIL_REPLACE)
							render.SetStencilPassOperation(STENCIL_KEEP)
							render.SetStencilZFailOperation(STENCIL_KEEP)

							surface.SetDrawColor(0,0,0, 255)
							surface.DrawRect(x + 71, y + 1, 268, 78)

							render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
							render.SetStencilReferenceValue(1)
							render.SetStencilFailOperation(STENCILOPERATION_ZERO)
							render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
							render.SetStencilPassOperation(STENCILOPERATION_KEEP)

							draw.SimpleText(name, 'octoinv-3d.normal', x+330 + (math.sin(CurTime() / 2) + 1) / 2 * (tw - 250), y+19, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

							render.SetStencilEnable(false)
						else
							draw.SimpleText(name, 'octoinv-3d.normal', x+330, y+19, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
						end
					else
						surface.SetDrawColor(255,255,255)
						surface.SetMaterial(Material('octoteam/icons/refresh.png'))
						surface.DrawTexturedRect(x+3, y+3, 64, 64)

						draw.SimpleText(L.empty_hint, '3d.medium', x+330, y+32	, Color(255,255,255, 50), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					end
				end
			else
				draw.SimpleText(L.vend_hint, '3d.medium', 175, 250, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(L.vend_empty, '3d.medium', 175, 280, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(L.vend_of_managment, 'octoinv-3d.normal', 175, 520, Color(255,255,255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(L.vend_press_use, 'octoinv-3d.normal', 175, 545, Color(255,255,255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			surface.SetAlphaMultiplier(1)
		cam.End3D2D()
	end

end
