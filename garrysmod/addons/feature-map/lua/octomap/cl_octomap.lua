octomap.material = Material('octoteam/icons/clock.png')

for k, v in pairs({
	url = 'goEUmT0.jpg',
	addX = 80, addY = -22,
	relX = 0.072, relY = -0.072,
	mapW = 2560, mapH = 2560,
	scale = 0.5,
	tgtScale = 0.5,
	scaleMin = 0.2097152, scaleMax = 1,
	offX = 0, offY = 0,
	tgtOffX = 0, tgtOffY = 0,
	cx = 0, cy = 0,
	bgCol = Color(198, 234, 146),
	tgtSpeed = 20,
	allowPan = true,
	paddingL = 0,
	paddingR = 0,
	paddingT = 0,
	paddingB = 0,
}) do
	octomap.config[k] = octomap.config[k] or v
end

local config = octomap.config

function octomap.reloadMainMaterial()

	local pathFile = 'imgscreen/' .. config.url
	local pathImg = '../data/' .. pathFile

	if file.Exists(pathFile, 'DATA') then
		octomap.material = Material(pathImg)
		return
	end

	http.Fetch(octolib.imgurImage(config.url), function(content)
		file.Write(pathFile, content)
		local matName = pathImg:gsub('%.png', '')
		RunConsoleCommand('mat_reloadmaterial', matName)
		octomap.material = Material(pathImg)
	end)

end

function octomap.worldToMap(x, y, z)

	if isvector(x) then x, y, z = x.x, x.y, x.z end
	return x * config.relX + config.addX, y * config.relY + config.addY, z

end

function octomap.mapToWorld(x, y, z)

	if isvector(x) then x, y, z = x.x, x.y, x.z end
	return (x - config.addX) / config.relX, (y - config.addY) / config.relY, z

end

hook.Add('octolib.imgur.loaded', 'octomap', octomap.reloadMainMaterial)
if octolib and octolib.imgurLoaded and octolib.imgurLoaded() then
	octomap.reloadMainMaterial()
end

if config.updateMap then
	timer.Create('octomap.update', 1, 0, config.updateMap)
end
