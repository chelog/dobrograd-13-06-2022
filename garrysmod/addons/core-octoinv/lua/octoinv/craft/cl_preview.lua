local lastDir, lastAng, lastPos, woke

local activatePreviewPhysics = octolib.func.debounce(function()
	if not IsValid(octoinv.preview) then return end
	local physObj = octoinv.preview:GetPhysicsObject()
	if IsValid(physObj) then physObj:Wake() end
end, 0.3)

netstream.Hook('octoinv.craftPreview', function(mdl, rotate)
	if IsValid(octoinv.preview) then octoinv.preview:Remove() end
	if mdl then
		octoinv.preview = ents.CreateClientProp(mdl)
		octoinv.preview:PhysicsInit(SOLID_VPHYSICS)
		octoinv.preview:SetMoveType(MOVETYPE_VPHYSICS)
		octoinv.preview:SetNotSolid(true)
		octoinv.preview:SetRenderMode(RENDERMODE_TRANSCOLOR)
		octoinv.preview:SetColor(Color(255, 255, 255, 150))
		octoinv.preview.rotate = rotate
		lastDir, lastAng, lastPos, woke = nil
	end
end)

hook.Add('Think', 'octoinv.craftPreview', function()

	if not IsValid(octoinv.preview) then return end
	local ply = LocalPlayer()
	local physObj = octoinv.preview:GetPhysicsObject()

	local dir = ply:GetAimVector()
	dir.z = 0
	dir:Normalize()

	local ang = ply:EyeAngles()
	ang.p = 0
	ang.r = 0
	ang.y = ang.y + 180 - (octoinv.preview.rotate or 0)

	local pos = ply:GetShootPos() + dir * 25
	if lastDir == dir and lastAng == ang and lastPos == pos then
		if not woke then
			activatePreviewPhysics()
			woke = true
		end
		return
	end
	lastDir, lastAng, lastPos, woke = dir, ang, Vector(pos.x, pos.y, pos.z), false
	if IsValid(physObj) then physObj:Sleep() end
	octoinv.preview:SetPos(pos)
	octoinv.preview:SetAngles(ang)
	pos = octoinv.preview:NearestPoint(pos + dir * 512)
	octoinv.preview:SetPos(pos)

end)
