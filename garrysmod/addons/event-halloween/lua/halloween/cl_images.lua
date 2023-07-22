local dist, distFade = 2000 * 2000, 300 * 300


local function drawImage(data)

	local al = math.Clamp(1 - (data.pos:DistToSqr(EyePos()) - distFade) / dist, 0, 1)
	if al <= 0 then return end
	local matBg = octolib.getImgurMaterial(data.url.bg)
	if matBg == octolib.loadingMat then return end
	local matWindow = octolib.getImgurMaterial(data.url.window)
	if matWindow == octolib.loadingMat then return end
	local matShape = octolib.getImgurMaterial(data.url.shape)
	if matShape == octolib.loadingMat then return end

	al = al * 255
	cam.Start3D2D(data.pos, data.ang, 0.1)
		surface.SetDrawColor(159,159,159, al)
		surface.SetMaterial(matBg)
		surface.DrawTexturedRect(0, 0, data.w, data.h)
		surface.SetDrawColor(0,0,0, math.min(al * 4, 255))
		surface.SetMaterial(matShape)
		surface.DrawTexturedRect(0, 0, data.w, data.h)
		surface.SetDrawColor(159,159,159, al)
		surface.SetMaterial(matWindow)
		surface.DrawTexturedRect(0, 0, data.w, data.h)
	cam.End3D2D()

end

netstream.Hook('dbg-halloween.images', function(data)
	renderData = halloween.parseData(data)
	if renderData and renderData[1] then
		hook.Add('PostDrawOpaqueRenderables', 'dbg-halloween.images', function()
			for _, v in ipairs(renderData) do
				drawImage(v)
			end
		end)
	else hook.Remove('PostDrawOpaqueRenderables', 'dbg-halloween.images') end
end)
