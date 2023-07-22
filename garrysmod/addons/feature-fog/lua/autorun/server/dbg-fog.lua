-- local col, dist, dist2 = Vector(0.75,0.75,0.75), 3000, 3000 * 0.65
-- local f

-- hook.Add('InitPostEntity', 'dbg-fog', function()

-- 	for k,v in pairs(ents.FindByClass('env_fog_controller')) do
-- 		if IsValid(v) then f = v end
-- 	end
-- 	f = f or ents.Create('env_fog_controller')

-- 	f:SetKeyValue('fogcolor', '200 200 200')
-- 	f:SetKeyValue('fogcolor2', '200 200 200')
-- 	f:SetKeyValue('fogdir', '1 0 0')
-- 	f:SetKeyValue('fogstart', dist2)
-- 	f:SetKeyValue('fogend', dist)
-- 	f:SetKeyValue('farz', dist + 150)
-- 	f:SetKeyValue('fogenable', 1)
-- 	f:SetKeyValue('fogblend', 1)
-- 	f:Spawn()
-- 	f:Activate()

-- 	timer.Simple(0, function()
-- 		f:Fire('TurnOn')
-- 		f:Input('SetStartDist', f, f, dist2)
-- 		f:Input('SetEndDist', f, f, dist)
-- 		f:Input('SetFarZ', f, f, dist + 150)
-- 		f:Input('StartFogTransition', f, f)
-- 	end)

-- end)

-- function UpdateFog(_col, _dist, _dist2)

-- 	for k,v in pairs(ents.FindByClass('env_fog_controller')) do
-- 		if IsValid(v) then f = v end
-- 	end
-- 	if not IsValid(f) then return end

-- 	col, dist, dist2 = _col, _dist, _dist2 or (dist * 0.65)

-- 	f:SetKeyValue('fogstart', dist2)
-- 	f:SetKeyValue('fogend', dist)
-- 	f:SetKeyValue('farz', dist + 150)

-- 	timer.Simple(0, function()
-- 		f:Input('SetStartDist', f, f, dist2)
-- 		f:Input('SetEndDist', f, f, dist)
-- 		f:Input('SetFarZ', f, f, dist + 150)
-- 	end)

-- 	netstream.Start(nil, 'dbg-fog', col, dist, dist2)

-- end
