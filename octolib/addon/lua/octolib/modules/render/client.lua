octolib.renderModel = octolib.renderModel or {}

local vector_right = Vector(1, 0, 0)
local vector_forward = Vector(0, 1, 0)
local vector_up = Vector(0, 0, 1)
local angle_zero = Angle()
local emptyPng = render.Capture({ x = 0, y = 0, w = 1, h = 1, format = 'png' })

local waitingDests = {}
local waitingImages = {}
local renderedImages = {}

file.CreateDir('octolib/render')
hook.Add('ShutDown', 'octolib.renderModel.clenup', function()
	local files = file.Find('octolib/render/*', 'DATA')
	for _, name in ipairs(files) do
		file.Delete('octolib/render/' .. name)
	end
end)

local queue = {}
hook.Add('Think', 'octolib.renderModel.queue', function()
	if not queue[1] then return end

	local destination, settings, fileName, filePath, matPath = unpack(table.remove(queue, 1))

	local imgW, imgH = destination.width * 3, destination.height * 3
	local texture = GetRenderTarget(('octolib_render_%d_%d'):format(imgW, imgH), imgW, imgH)
	local camFov = settings.camFov
	local camAng = settings.camAng
	local mdlAng = Angle()
	mdlAng:RotateAroundAxis(vector_forward, camAng.p)
	mdlAng:RotateAroundAxis(vector_up, camAng.y)
	mdlAng:RotateAroundAxis(vector_right, camAng.r)

	render.PushRenderTarget(texture)
	render.Clear(0,0,0,0, true, true)

	local csent = ClientsideModel(destination.model, RENDERGROUP_BOTH)
	local mins, maxs = csent:GetModelBounds()
	csent:SetPos((mins + maxs) / -2)
	csent:SetAngles(mdlAng)
	csent:SetSkin(destination.skin or 0)
	for id, val in pairs(destination.bg or {}) do
		csent:SetBodygroup(id, val)
	end

	local camDist = mins:Distance(maxs) / 2 / math.tan(math.rad(camFov / (2 * settings.camFovMod)))
	local camPos = Vector(-camDist, 0, 0)

	local light1Pos = Vector(camPos)
	light1Pos:Rotate(Angle(0, 120, 0))
	local light2Pos = Vector(camPos)
	light2Pos:Rotate(Angle(0, -120, 0))

	local light1 = {
		type = MATERIAL_LIGHT_POINT,
		pos = light1Pos,
		color = Vector(0.5, 0.5, 0.5),
		fiftyPercentDistance = camDist * 2.5,
		zeroPercentDistance = camDist * 3,
	}

	local light2 = {
		type = MATERIAL_LIGHT_POINT,
		pos = light2Pos,
		color = Vector(0.5, 0.5, 0.5),
		fiftyPercentDistance = camDist * 2.5,
		zeroPercentDistance = camDist * 3,
	}

	cam.Start3D(camPos + settings.camPos, angle_zero, camFov, 0, 0, imgW, imgH)
		render.OverrideAlphaWriteEnable(true, true)
		render.SuppressEngineLighting(true)
		render.PushFilterMin(TEXFILTER.ANISOTROPIC)
		render.SetLocalModelLights({ light1, light2 })
			render.SetWriteDepthToDestAlpha(false)
			render.SetColorModulation(1, 1, 1)
			render.ResetModelLighting(0.75, 0.75, 0.75)
			csent:DrawModel()
			local imageData = render.Capture({
				format = 'png',
				x = 0, y = 0,
				w = imgW, h = imgH,
				farz = camDist * 2,
			})
		render.SetLocalModelLights()
		render.PopFilterMin()
		render.SuppressEngineLighting(false)
		render.OverrideAlphaWriteEnable(false)
	cam.End3D()

	csent:Remove()
	render.PopRenderTarget()

	file.Write(filePath, imageData)
	RunConsoleCommand('mat_reloadmaterial', matPath:StripExtension())

	local image = Material(matPath, 'smooth noclamp mips')
	for _, destination in ipairs(waitingDests[fileName]) do
		destination.image = image
	end

	waitingDests[fileName] = nil
	renderedImages[fileName] = image
end)

function octolib.renderModel.getFileName(destination)
	local model = destination.model
	local skin = destination.skin or 0
	local bg = table.concat(octolib.array.map(destination.bg or {}, function(v) return v end), ',')
	local size = destination.width .. destination.height

	return util.CRC(size .. model .. skin .. bg)
end

function octolib.renderModel.queueRender(destination, settings)
	local image = destination.image
	if image then
		destination.image = image
		return
	end

	local fileName = octolib.renderModel.getFileName(destination)
	local filePath = 'octolib/render/' .. fileName .. '.png'
	local matPath = '../data/' .. filePath

	local renderedImages = renderedImages[fileName]
	if renderedImages then
		destination.image = renderedImages
		return
	end

	if not waitingImages[fileName] then
		file.Write(filePath, emptyPng)
		RunConsoleCommand('mat_reloadmaterial', matPath:StripExtension())
		destination.image = Material(matPath, 'smooth noclamp')
		waitingImages[fileName] = destination.image
	end

	local waiting = waitingDests[fileName]
	if not waiting then
		waitingDests[fileName] = { destination }
		waiting = waitingDests[fileName]
		queue[#queue + 1] = { destination, settings, fileName, filePath, matPath }
	else
		waiting[#waitingDests + 1] = destination
	end
end

function octolib.renderModel.clear(destination)
	local fileName = octolib.renderModel.getFileName(destination)
	renderedImages[fileName] = nil
	destination.image = nil
end
