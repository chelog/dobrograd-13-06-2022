local renderPos = {
	blind = {Vector(4.5,4,2.6), Vector(4.8,5.8,0), Vector(4.5,4,-2.8), Vector(3.4,-1,-3.8), Vector(2.5,-3.5,0), Vector(3.4,-1,3.8)},
	gag = {Vector(2.0,5.2,2), Vector(2.0,6.5,-0.1), Vector(2.0,5.5,-2), Vector(1,1,-3.4), Vector(0.2,-2,0), Vector(1,1,3.4)},
}
local rope = Material('cable/rope')

local function renderCircle(pos, ang, k)
	local p = renderPos[k][1]
	local first = pos + (ang:Forward() * p.x) + (ang:Right() * p.y) + (ang:Up() * p.z)
	local last = first
	for i = 2, #renderPos[k] do
		p = renderPos[k][i]
		local new = pos + (ang:Forward() * p.x) + (ang:Right() * p.y) + (ang:Up() * p.z)
		render.DrawBeam(new, last, 1.5, 0, 1, color_white)
		last = new
	end
	render.DrawBeam(last, first, 1.5, 0, 1, color_white)
end

hook.Add('PostPlayerDraw', 'dbg-cuffs', function(ply)
	if not IsValid(ply) then return end

	local cuffed, cuff = ply:IsHandcuffed()
	if not cuffed or not IsValid(cuff) then return end

	render.SetMaterial(rope)

	local pos, ang
	local bone = cuff.Owner:LookupBone('ValveBiped.Bip01_Head1')
	if bone then
		pos, ang = cuff.Owner:GetBonePosition(bone)
	end
	if not pos and not ang then return end

	if cuff:GetNetVar('blind') then
		renderCircle(pos, ang, 'blind')
	end

	if cuff:GetNetVar('gag') then
		renderCircle(pos, ang, 'gag')
	end
end)
