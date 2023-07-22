include 'shared.lua'
ENT.RenderGroup = RENDERGROUP_BOTH

local dist, distFade = 2000 * 2000, 300 * 300
local posOff, angOff = Vector(0, 0, 0.5), Angle(0, 90, 0)

function ENT:Draw()

	local data = self:GetNetVar('img')
	if not data then return end

	local al = math.Clamp(1 - (self:GetPos():DistToSqr(EyePos()) - (data[5] or distFade)) / dist, 0, 1)
	if al <= 0 then return end


	local url, w, h, col = unpack(data)
	url = url or ''
	w = w or 16
	h = h or 16
	col = col or color_white

	local mat = octolib.getURLMaterial(url)
	if mat == octolib.loadingMat then
		w, h, col = 64, 64, color_white
	end

	if not self.rbMins or not self.rbMaxs then
		self.rbMins, self.rbMaxs = self:GetRenderBounds()
	end
	local expectedMaxs = Vector(h * 0.1, w * 0.1, 0.001)
	local expectedMins = -expectedMaxs
	if self.rbMins ~= expectedMins or self.rbMaxs ~= expectedMaxs then
		self:SetRenderBounds(expectedMins, expectedMaxs)
		self.rbMins, self.rbMaxs = expectedMins, expectedMaxs
	end

	local pos, ang = LocalToWorld(posOff, angOff, self:GetPos(), self:GetAngles())
	cam.Start3D2D(pos, ang, 0.2)
		surface.SetDrawColor(col.r, col.g, col.b, col.a * al)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(-w / 2, -h / 2, w, h)
	cam.End3D2D()

end

local function clearCache()

	file.CreateDir('imgscreen')
	local fls, fds = file.Find('imgscreen/*', 'DATA')
	for _, fl in ipairs(fls) do
		file.Delete('imgscreen/' .. fl)
	end

end
hook.Add('Shutdown', 'imgscreen.clearCache', clearCache)
hook.Add('PlayerFinishedLoading', 'imgscreen.clearCache', clearCache)
