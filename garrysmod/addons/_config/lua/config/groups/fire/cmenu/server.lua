local SwitchSound = Sound('HL2Player.FlashLightOn')

local function killLight(ply)
	if IsValid(ply.projectedlight) then
		SafeRemoveEntity(ply.projectedlight)
	end
end

local function createFlashlight(ply)
	if IsValid(ply.projectedlight) then return end
	local light = ents.Create('env_projectedtexture')
	light:SetParent(ply)
	light:SetPos(ply:GetShootPos())
	light:SetAngles(ply:GetAngles())
	light:SetKeyValue('enableshadows', 1)
	light:SetKeyValue('nearz', 7)
	light:SetKeyValue('farz', 750.0)
	light:SetKeyValue('lightcolor','255 255 255 255')
	light:SetKeyValue('lightfov', 70)
	light:Spawn()
	light:Input('SpotlightTexture', NULL, NULL, 'effects/flashlight001')
	light:Fire('setparentattachment','chest', 0.01)
	ply.projectedlight = light
end

local function checkUniform(ply)
	if not ply:GetModel():find('models/gta5/fire') then return end
	local bgs = {}
	for i, v in ipairs(ply:GetBodyGroups()) do
		local id = v.id
		bgs[id] = ply:GetBodygroup(id)
	end
	return bgs[2] == 1
end

netstream.Hook('fire.scba', function(ply)
	if not (ply:Team() == TEAM_FIREFIGHTER and checkUniform(ply)) then return end
	if ply:GetNetVar('fire.scba') then 
		ply:SetNetVar('fire.scba')
		if IsValid(ply.scba) then 
			ply.scba:Stop()
			ply.scba = nil
		end
		return 
	end
	ply:SetNetVar('fire.scba', true)
	ply.scba = CreateSound(ply, 'scba.wav')
	ply.scba:Play()
end)

local function removeSCBA(ply)
	if IsValid(ply) and ply:GetNetVar('fire.scba') and IsValid(ply.scba) then
		ply.scba:Stop()
		ply.scba = nil
		ply:SetNetVar('fire.scba')
	end
end

hook.Add('PlayerDeath', 'fire.scba', removeSCBA)
hook.Add('PlayerSpawn', 'fire.scba', removeSCBA)

netstream.Hook('fire.flashlight', function(ply)
	if not (ply:Team() == TEAM_FIREFIGHTER and checkUniform(ply)) then return end
	ply:EmitSound(SwitchSound)
	if ply:GetNetVar('fire.flashlight') then
		killLight(ply)
		ply:SetNetVar('fire.flashlight') 
	else
		createFlashlight(ply)
		ply:SetNetVar('fire.flashlight', true)
	end
end)

hook.Add('PlayerDeath', 'fire.flashlight', killLight)
hook.Add('PlayerDisconnected', 'fire.flashlight', killLight)
hook.Add('PlayerSpawn', 'fire.flashlight', killLight)
hook.Add('simple-orgs.handOver', 'fire.flashlight', killLight)