octolib.drawDebug = false

surface.CreateFont('3d.medium', {
	font = 'Calibri',
	extended = true,
	size = 42,
	weight = 350,
})

timer.Create('octolib.drawDebug', 2, 0, function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	local wep = ply:GetActiveWeapon()
	octolib.drawDebug = ply:Team() == TEAM_ADMIN and IsValid(wep) and wep:GetClass() == 'weapon_physgun'
end)

local colors = CFG.skinColors
function render.DrawBubble(ent, pos, ang, text, maxDist, fadeDist)
	if IsValid(ent) then
		pos, ang = LocalToWorld(pos, ang, ent:GetPos(), ent:GetAngles())
	end

	local al = math.Clamp(1 - (pos:DistToSqr(EyePos()) - fadeDist * fadeDist) / (maxDist * maxDist), 0, 1) * 255
	if al <= 0 then return end

	cam.Start3D2D(pos, ang, 0.1)
		surface.SetFont('3d.medium')
		local w, h = surface.GetTextSize(text)
		draw.RoundedBox(8, -w/2 - 10, -h/2 - 3, w + 20, h + 6, ColorAlpha(colors.bg50, al))

		draw.SimpleText(text, '3d.medium', 0, 0, Color(238,238,238, al), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()

end
