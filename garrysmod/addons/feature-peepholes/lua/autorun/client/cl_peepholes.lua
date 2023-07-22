local fisheye = CreateClientConVar('cl_dbg_fisheyeonpeepholes', '1', true)
local hint = false

local x, y, w, h, r, seg, poly = ScrW() / 2, ScrH() / 2, 128, 128, ScrH() / 2.5, 46, {}
poly[#poly+1] = {x = x, y = y, u = 0.5, v = 0.5}
for i = 0, seg do
	local a = math.rad((i/seg) * -360)
	poly[#poly+1] = {x = x + math.sin(a) * r, y = y + math.cos(a) * r, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5}
end

local rt = GetRenderTarget("peepholes", ScrW(), ScrH())
local busy, view = false

local function updateRender()

	busy = true
	render.PushRenderTarget(rt)
	local ang = LocalPlayer():EyeAngles()
	render.RenderView(view)
	render.PopRenderTarget()
	busy = false

end

netstream.Hook('dbg-doors.peephole', function(nview)
	view = nview
	if view then view.w, view.h = ScrW(), ScrH() end
end)

hook.Add('PreDrawEffects', 'dbg-doors.peephole', function()

	if busy or not view then return end
		
	updateRender()

	-- prepare
	render.ClearStencil()
	render.SetStencilEnable(true)
	render.SetStencilTestMask(255)
	render.SetStencilWriteMask(255)
	render.SetStencilReferenceValue(42)
		
	-- make mask
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilPassOperation(STENCIL_REPLACE)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	cam.Start2D()
	surface.SetDrawColor(255, 255, 255)
	draw.NoTexture()
	surface.DrawPoly(poly)
	cam.End2D()

	-- draw view
	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.SetStencilFailOperation(STENCIL_ZERO)
	render.SetStencilZFailOperation(STENCIL_ZERO)
	render.DrawTextureToScreen(rt)

	-- darken screen
	render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
	cam.Start2D()
	draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), color_black)
	cam.End2D()
	render.SetStencilEnable(false)

end)

hook.Add('RenderScreenspaceEffects', 'dbg-doors.peepholes.overlay', function()
	if not fisheye:GetBool() or not view then return end
	DrawMaterialOverlay('models/props_c17/fisheyelens', -0.05)
end)

hook.Add('HUDPaint', 'dbg-doors.peepholes.tutorial', function()

	if view then
		hint = true
		draw.DrawText('Нажми E, чтобы перестать смотреть в глазок', 'CloseCaption_Normal', ScrW() / 2, ScrH() - 48, color_white, TEXT_ALIGN_CENTER)
	elseif hint then hook.Remove('HUDPaint', 'dbg-doors.peepholes.tutorial') end

end)