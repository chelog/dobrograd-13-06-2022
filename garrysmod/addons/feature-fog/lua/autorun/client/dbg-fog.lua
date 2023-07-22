-- local col, dist, dist2 = Vector(0.75,0.75,0.75), 3000, 3000 * 0.65
-- netstream.Hook('dbg-fog', function(_col, _dist, _dist2)
-- 	col = _col
-- 	dist = _dist
-- 	dist2 = _dist2 or (_dist * 0.65)
-- end)

-- hook.Add('SetupWorldFog', 'FoxController', function()
-- 	render.FogMode(1)
-- 	render.FogStart(dist2)
-- 	render.FogEnd(dist)
-- 	render.FogMaxDensity(1)
-- 	render.FogColor(col.x * 255, col.y * 255, col.z * 255)

-- 	return true
-- end)

-- hook.Add('SetupSkyboxFog', 'FoxControllerSky', function(scale)
-- 	render.FogMode(MATERIAL_FOG_LINEAR)
-- 	render.FogStart(dist2 * scale)
-- 	render.FogEnd(dist * scale)
-- 	render.FogMaxDensity(1)
-- 	render.FogColor(col.x * 255, col.y * 255, col.z * 255)

-- 	return true
-- end)
