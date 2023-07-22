if game.GetMap() == 'rp_truenorth_v1a' then
	local function createSSEnt(ent, class)
		local pos, ang = ent:GetPos(), ent:GetAngles()
		ent:Remove()
		ent = ents.Create(class)
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:Spawn()
		ent:GetPhysicsObject():EnableMotion(false)
	end

	local toRem = {2699, 2700, 3838}

	local function makeDobrograd()
		for _,v in ipairs(ents.GetAll()) do
			if v:GetName() == 'speed50' then
				v:SetSkin(5)
			elseif v:GetName() == 'speed80' then
				v:SetSkin(6)
			elseif v:GetName() == 'speed100' then
				v:SetSkin(7)
			elseif v:GetName() == 'flagpole' then
				v:SetSkin(1)
			elseif v:GetName() == 'hwyca' or v:GetName() == 'pumps' then
				v:Remove()
			elseif v:GetName() == 'hwyus' then
				v:Fire('TurnOn', 1, 0)
				if v:GetModel() == 'models/props_street/mail_dropbox.mdl' then
					createSSEnt(v, 'octoinv_mailbox')
				end
			elseif v:GetModel() == 'models/props_unique/atm01.mdl' then
				createSSEnt(v, 'brax_atm')
			end
		end
		for _,v in ipairs(toRem) do
			ents.GetMapCreatedEntity(v):Remove()
		end
	end

	hook.Add('InitPostEntity', 'dbg-cleanthemap', makeDobrograd)
	hook.Add('PostCleanupMap', 'dbg-cleanthemap', makeDobrograd)
end

local function setupWeather()

	if game.GetMap():find('evocity') then
		local lightspots, sprites, spots, lights, nlights1, nlights3 = {}, {}, {}, {}, {}, {}
		for _, ent in ipairs(ents.GetAll()) do
			local name = ent:GetName()
			if name == 'street_lightspot' then lightspots[#lightspots + 1] = ent
			elseif name == 'street_sprite' then sprites[#sprites + 1] = ent
			elseif name == 'street_spot' then spots[#spots + 1] = ent
			elseif name == 'street_light' then lights[#lights + 1] = ent
			elseif name == 'nightlight1' then nlights1[#nlights1 + 1] = ent
			elseif name == 'nightlight3' then nlights3[#nlights3 + 1] = ent end
		end

		local lastLight = -1
		timer.Create('dbg-weather', 1, 0, function()
			local curLight = StormFox2.Weather.GetLuminance()
			local turnOn = curLight < 125
			if lastLight >= 0 and turnOn == (lastLight < 125) then return end
			lastLight = curLight
			for _, ent in ipairs(lightspots) do ent:Fire(turnOn and 'LightOn' or 'LightOff') end
			for _, ent in ipairs(sprites) do ent:Fire(turnOn and 'ShowSprite' or 'HideSprite') end
			for _, ent in ipairs(spots) do ent:Fire(turnOn and 'TurnOn' or 'TurnOff') end
			for _, ent in ipairs(lights) do ent:Fire(turnOn and 'TurnOn' or 'TurnOff') end
			for _, ent in ipairs(nlights1) do ent:Fire(turnOn and 'TurnOn' or 'TurnOff') end
			for _, ent in ipairs(nlights3) do ent:Fire(turnOn and 'TurnOn' or 'TurnOff') end
		end)
	end

end
hook.Add('InitPostEntity', 'dbg-weather', setupWeather)
hook.Add('PostCleanupMap', 'dbg-weather', setupWeather)
setupWeather()

hook.Add('InitPostEntity', 'dbg-doors', function()
	for _,v in ipairs(ents.GetAll()) do
		if v:IsDoor() then
			v.defaultSkin = v:GetSkin()
			v.defaultBGs = {}
			for _,bg in ipairs(v:GetBodyGroups()) do
				v.defaultBGs[bg.id] = v:GetBodygroup(bg.id)
			end
		end
	end
end)
