surface.CreateFont('DeathScreen', {
	size = 64,
	weight = 800,
	antialias = true,
	shadow = false,
	font = 'Default'})

hook.Add('HUDShouldDraw', 'FPDeath', function(name)
	if name ~= 'CHudCrosshair' then return end

	local ply = LocalPlayer()
	local body = ply:GetNetVar('DeathRagdoll')
	if not body or not IsValid(body) then body = ply:GetParent() end
	if not body or not IsValid(body) or body:IsVehicle() then return end
	if (not ply:Alive() and CurTime() < ply:GetNetVar('_GhostTime', 0)) or ply:GetNetVar('Tased') or ply:GetNetVar('Ragdolled') then
		return false
	end
end)

local function getRagdoll(ply)
	local body = ply:GetNetVar('DeathRagdoll')
	if not body or not IsValid(body) then body = ply:GetParent() end
	if not body or not IsValid(body) or body:IsVehicle() then return end
	return body
end

-- add first person death
hook.Add('CalcView', 'FPDeath', function(ply)
	local body = getRagdoll(ply)
	if not body then return end

	local head = body:LookupBone('ValveBiped.Bip01_Head1')
	if (not ply:Alive() and CurTime() < ply:GetNetVar('_GhostTime', 0)) or ply:GetNetVar('Tased') or ply:GetNetVar('Ragdolled') then
		-- make head disappear
		body:ManipulateBoneScale(head, Vector(0, 0, 0))

		local eyes = body:GetAttachment(body:LookupAttachment('eyes'))
		local view = {
			origin = eyes.Pos - eyes.Ang:Forward() * 6,
			angles = eyes.Ang,
			fov = 90
		}

		return view
	else
		-- restore head after spawn
		local head = body:LookupBone('ValveBiped.Bip01_Head1')
		body:ManipulateBoneScale(head, Vector(1, 1, 1))
	end
end, -10)

local curState, lastState = 0, 0
hook.Add('PostDrawHUD', 'PostEffectsHealth', function()
	if isHoldingCamera then return end

	local ply, ct, ft = LocalPlayer(), CurTime(), FrameTime()
	local imDead, spTime, ghTime = ply:GetNetVar('Ghost'), ply:GetNetVar('_SpawnTime', 0), ply:GetNetVar('_GhostTime', 0)

	if not imDead then
		-- calculate target percent
		local tgtState
		if ply:Alive() then
			tgtState = 1 - math.Clamp((ply:Health() or 0) / ply:GetMaxHealth(), 0, 1)
		else
			tgtState = 1
		end

		-- interpolate the value
		local delta = (tgtState - curState) * (ft < 1 and ft or 1)
		if math.abs(delta) < .01 then
			delta =  delta > 0 and .01 or -.01
		end
		if tgtState - curState < .01 then
			delta = tgtState - curState
		end
		curState = curState + delta

		-- apply effects
		if curState ~= 0 then
			local deathColors = {
				[ '$pp_colour_addr' ] = 0,
				[ '$pp_colour_addg' ] = 0,
				[ '$pp_colour_addb' ] = 0,
				[ '$pp_colour_brightness' ] = 0,
				[ '$pp_colour_contrast' ] = 1 - curState * 0.7,
				[ '$pp_colour_colour' ] = 1 - curState,
				[ '$pp_colour_mulr' ] = 0,
				[ '$pp_colour_mulg' ] = 0,
				[ '$pp_colour_mulb' ] = 0
			} DrawColorModify(deathColors)

			if curState > 0.5 then
				local _prc = (curState-.5) / .5
				DrawBloom(0.1, (_prc^3) * 1, 6, 6, 1, 0.25, 1, 1, 1)
				-- DrawMotionBlur((1 - (_prc^(.2))*.8), (_prc^(.2))*(.8), 0.01)
			end
		end

		if curState ~= lastState then
			local dsp = 1
			if curState > .8 then
				dsp = 16
			elseif curState > .65 then
				dsp = 15
			elseif curState > .5 then
				dsp = 14
			end
			ply:SetDSP(dsp)
		end

		if not ply:Alive() then
			local fadein = math.Clamp((ct - spTime + octodeath.config.spawnTime) / octodeath.config.fadeOutDeath, 0, 1)
			local al = 255 * fadein
			draw.RoundedBox(0, -5, -5, ScrW() + 10, ScrH() + 10, Color(0,0,0, al))
		else
			local fadeout = math.Clamp((ct - spTime) / octodeath.config.fadeInSpawn, 0, 1)
			local al = 255 * (1 - fadeout^3)
			if al > 0 then
				draw.RoundedBox(0, -5, -5, ScrW() + 10, ScrH() + 10, Color(255,255,255, al))
			end
		end

		if ct > ghTime and ct < spTime and ghTime ~= 0 then
			draw.RoundedBox(0, -5, -5, ScrW() + 10, ScrH() + 10, Color(0,0,0))
		end
	elseif ply:GetNetVar('launcherActivated') then
		local deathColors = {
			[ '$pp_colour_addr' ] = 0,
			[ '$pp_colour_addg' ] = 0,
			[ '$pp_colour_addb' ] = 0.1,
			[ '$pp_colour_brightness' ] = 0,
			[ '$pp_colour_contrast' ] = .95,
			[ '$pp_colour_colour' ] = 0.25,
			[ '$pp_colour_mulr' ] = 0,
			[ '$pp_colour_mulg' ] = 0,
			[ '$pp_colour_mulb' ] = 0
		} DrawColorModify(deathColors)

		if curState ~= lastState then
			ply:SetDSP(1)
		end


		ghTime = ghTime or ct
		if ghTime and ct < ghTime - 0.5 and getRagdoll(ply) then
			local fadein = math.Clamp((ghTime - ct - 0.75) / octodeath.config.ghostTime, 0, 1)
			local al = 255 * (1 - fadein^3)
			if al > 0 then
				draw.RoundedBox(0, -5, -5, ScrW() + 10, ScrH() + 10, Color(0,0,0, al))
			end
		else
			draw.SimpleText(
				string.ToMinutesSeconds(ply:GetNetVar('_SpawnTime', 0) - ct),
				'DeathScreen',
				ScrW() / 2,
				ScrH() - 10,
				Color(220,220,220),
				TEXT_ALIGN_CENTER,
				TEXT_ALIGN_BOTTOM
			)
			local fadein = math.Clamp((ct - ghTime - 1) / octodeath.config.fadeInGhost, 0, 1)
			local al = 255 * (1 - fadein^3)
			if al > 0 then
				draw.RoundedBox(0, -5, -5, ScrW() + 10, ScrH() + 10, Color(0,0,0, al))
			end
		end

		local fadeout = math.Clamp((spTime - ct) / octodeath.config.fadeOutGhost, 0, 1)
		local al = 255 * (1 - fadeout)
		if al > 0 then
			draw.RoundedBox(0, -5, -5, ScrW() + 10, ScrH() + 10, Color(255,255,255, al))
		end
	end
	lastState = curState
end)

octolib.func.loop(function(done)

	local lp = LocalPlayer()
	local imDead = lp:GetNetVar('Ghost')

	octolib.func.throttle(player.GetAll(), 10, 0.05, function(ply)
		if not IsValid(ply) then return end

		local dead = ply:GetNetVar('Ghost')
		if imDead then
			ply:SetColor(Color(255,255,255, 30))
		else
			if dead and not lp:getJobTable().seesGhosts then
				ply:SetColor(Color(255,255,255, 0))
			else
				ply:SetColor(Color(255,255,255, 30))
			end
		end
	end):Then(done)

end)

function player.GetGhosts()
	local tbl = {}
	for _, v in ipairs(player.GetAll()) do
		if v:GetNetVar('Ghost') then tbl[#tbl + 1] = v end
	end
	return tbl
end
