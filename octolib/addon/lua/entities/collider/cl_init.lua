include 'shared.lua'

local show = CreateClientConVar('octolib_showcolliders', '0', false)

function ENT:Draw()

	if not show:GetBool() then return end

	local col = self:GetNetVar('collider')
	if not col then return end

	if col[1] == 'model' then
		self:DrawModel()
	elseif col[1] == 'box' then
		local mins, maxs = unpack(col[2])
		render.DrawWireframeBox(self:GetPos(), self:GetAngles(), mins, maxs, color_white, true)
	end

end
