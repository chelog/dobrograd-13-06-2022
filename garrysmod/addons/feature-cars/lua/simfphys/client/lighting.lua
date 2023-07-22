local checkinterval = 2
local maxLampDist = 3000 * 3000
local maxLightSpriteDist = 3000 * 3000
local NextCheck = CurTime() + checkinterval

local hdr = GetConVar('mat_hdr_level')
local mat = Material('sprites/light_ignorez')
local mat2 = Material('sprites/light_glow02_add_noz')

if file.Exists('materials/sprites/glow_headlight_ignorez.vmt', 'GAME') then
	mat2 = Material('sprites/glow_headlight_ignorez')
end

local SpritesDisabled = false
local AllowVisualDamage = true
local FrontProjectedLights = true
local RearProjectedLights = true
local Shadows = false

cvars.AddChangeCallback('cl_simfphys_hidesprites', function(convar, oldValue, newValue) SpritesDisabled = (tonumber(newValue) ~= 0) end)
cvars.AddChangeCallback('cl_simfphys_spritedamage', function(convar, oldValue, newValue) AllowVisualDamage = (tonumber(newValue) ~= 0) end)
cvars.AddChangeCallback('cl_simfphys_frontlamps', function(convar, oldValue, newValue) FrontProjectedLights = (tonumber(newValue) ~= 0) end)
cvars.AddChangeCallback('cl_simfphys_rearlamps', function(convar, oldValue, newValue) RearProjectedLights = (tonumber(newValue) ~= 0) end)
cvars.AddChangeCallback('cl_simfphys_shadows', function(convar, oldValue, newValue) Shadows = (tonumber(newValue) ~= 0) end)

SpritesDisabled = GetConVar('cl_simfphys_hidesprites'):GetBool()
AllowVisualDamage = GetConVar('cl_simfphys_spritedamage'):GetBool()
FrontProjectedLights = GetConVar('cl_simfphys_frontlamps'):GetBool()
RearProjectedLights = GetConVar('cl_simfphys_rearlamps'):GetBool()
Shadows = GetConVar('cl_simfphys_shadows'):GetBool()

if not istable(vtable) then
	vtable = {}
end

local function BodyGroupIsValid(bodygroups, entity)
	for index, groups in pairs(bodygroups) do
		local mygroup = entity:GetBodygroup(index)
		for g_index = 1, table.Count(groups) do
			if (mygroup == groups[g_index]) then return true end
		end
	end
	return false
end

local function UpdateSubMats(ent, Lowbeam, Highbeam, IsBraking, IsReversing)
	if not istable(ent.SubMaterials) then return end

	if ent.SubMaterials.turnsignals then
		local IsTurningLeft = ent.signal_left
		local IsTurningRight = ent.signal_right
		local IsFlashing = ent:GetFlasher() == 1

		if ent.WasTurningLeft ~= IsTurningLeft or ent.WasTurningRight ~= IsTurningRight or ent.WasFlashing ~= IsFlashing then
			if ent.SubMaterials.turnsignals.left then
				for k,v in pairs(ent.SubMaterials.turnsignals.left) do
					local mat = (IsFlashing and IsTurningLeft) and v or ''
					ent:SetSubMaterial(k, mat)
				end
			end
			if ent.SubMaterials.turnsignals.right then
				for k,v in pairs(ent.SubMaterials.turnsignals.right) do
					local mat = (IsFlashing and IsTurningRight) and v or ''
					ent:SetSubMaterial(k, mat)
				end
			end

			ent.WasTurningLeft = IsTurningLeft
			ent.WasTurningRight = IsTurningRight
			ent.WasFlashing = IsFlashing
		end
	end

	if ent.WasReversing == IsReversing and ent.WasBraking == IsBraking and ent.WasLowbeam == Lowbeam and ent.WasHighbeam == Highbeam then return end

	if Lowbeam then
		if Highbeam then
			if ent.SubMaterials.on_highbeam then
				if not IsReversing and not IsBraking then
					if ent.SubMaterials.on_highbeam.Base then
						for k,v in pairs(ent.SubMaterials.on_highbeam.Base) do
							ent:SetSubMaterial(k, v)
						end
					end
				elseif IsBraking then
					if IsReversing then
						if ent.SubMaterials.on_highbeam.Brake_Reverse then
							for k,v in pairs(ent.SubMaterials.on_highbeam.Brake_Reverse) do
								ent:SetSubMaterial(k, v)
							end
						end
					else
						if ent.SubMaterials.on_highbeam.Brake then
							for k,v in pairs(ent.SubMaterials.on_highbeam.Brake) do
								ent:SetSubMaterial(k, v)
							end
						end
					end
				else
					if ent.SubMaterials.on_highbeam.Reverse then
						for k,v in pairs(ent.SubMaterials.on_highbeam.Reverse) do
							ent:SetSubMaterial(k, v)
						end
					end
				end
			end
		else
			if ent.SubMaterials.on_lowbeam then
				if not IsReversing and not IsBraking then
					if ent.SubMaterials.on_lowbeam.Base then
						for k,v in pairs(ent.SubMaterials.on_lowbeam.Base) do
							ent:SetSubMaterial(k, v)
						end
					end
				elseif IsBraking then
					if IsReversing then
						if ent.SubMaterials.on_lowbeam.Brake_Reverse then
							for k,v in pairs(ent.SubMaterials.on_lowbeam.Brake_Reverse) do
								ent:SetSubMaterial(k, v)
							end
						end
					else
						if ent.SubMaterials.on_lowbeam.Brake then
							for k,v in pairs(ent.SubMaterials.on_lowbeam.Brake) do
								ent:SetSubMaterial(k, v)
							end
						end
					end
				else
					if ent.SubMaterials.on_lowbeam.Reverse then
						for k,v in pairs(ent.SubMaterials.on_lowbeam.Reverse) do
							ent:SetSubMaterial(k, v)
						end
					end
				end
			end
		end
	else
		if ent.SubMaterials.off then
			if not IsReversing and not IsBraking then
				if ent.SubMaterials.off.Base then
					for k,v in pairs(ent.SubMaterials.off.Base) do
						ent:SetSubMaterial(k, v)
					end
				end
			elseif IsBraking then
				if IsReversing then
					if ent.SubMaterials.off.Brake_Reverse then
						for k,v in pairs(ent.SubMaterials.off.Brake_Reverse) do
							ent:SetSubMaterial(k, v)
						end
					end
				else
					if ent.SubMaterials.off.Brake then
						for k,v in pairs(ent.SubMaterials.off.Brake) do
							ent:SetSubMaterial(k, v)
						end
					end
				end
			else
				if ent.SubMaterials.off.Reverse then
					for k,v in pairs(ent.SubMaterials.off.Reverse) do
						ent:SetSubMaterial(k, v)
					end
				end
			end
		end
	end

	ent.WasReversing = IsReversing
	ent.WasBraking = IsBraking
	ent.WasLowbeam = Lowbeam
	ent.WasHighbeam = Highbeam
end

local function ManageProjTextures()
	if not vtable then return end

	local eyePos = LocalPlayer():GetShootPos()
	for i, ent in pairs(vtable) do
		if IsValid(ent) then
			if ent:GetPos():DistToSqr(eyePos) > maxLampDist then
				if ent.checkProjectors then
					for _, proj in pairs(ent.Projtexts) do
						if IsValid(proj.projector) then
							proj.projector:Remove()
							proj.projector = nil
							proj.LampsActive = nil
						end
					end
					ent.checkProjectors = nil
				end
				continue
			end
			ent.checkProjectors = true

			local vel = ent:GetVelocity() * RealFrameTime()
			ent.triggers = {
				[1] = ent:GetLightsEnabled(),
				[2] = ent:GetLampsEnabled(),
				[4] = ent:GetIsBraking(),
				[5] = ent:GetGear() == 1,
				[6] = ent.signal_left,
				[7] = ent.signal_right,
				[8] = ent:GetIsBraking(),
				[9] = ent:GetIsBraking(),
			}

			UpdateSubMats(ent, ent.triggers[1], ent.triggers[2], ent.triggers[4], ent.triggers[5])

			local mul = StormFox2.Time.IsNight() and 1 or 0.2
			for _, proj in pairs(ent.Projtexts) do
				local trigger = ent.triggers[proj.trigger]
				local enable = ent.triggers[1] or trigger

				if proj.Damaged or (proj.trigger == 2 and not FrontProjectedLights) or (proj.trigger == 4 and not RearProjectedLights) then
					trigger = false
					enable = false
				end

				if ent.HasSpecialTurnSignals and proj.trigger == 4 and (ent.triggers[6] or ent.triggers[7]) then
					trigger = false
				end

				if proj.LampsActive ~= trigger then
					proj.LampsActive = trigger

					if enable then
						proj.istriggered = trigger
						local brightness = trigger and proj.ontrigger.brightness or proj.brightness
						local mat = trigger and proj.ontrigger.mat or proj.mat
						local col = trigger and proj.ontrigger.col or proj.col
						local FarZ = trigger and proj.ontrigger.FarZ or proj.FarZ

						if trigger and brightness > 0 then
							local thelamp = ProjectedTexture()
							thelamp:SetBrightness(brightness * mul)
							thelamp:SetTexture(mat)
							thelamp:SetColor(col)
							thelamp:SetEnableShadows(Shadows)
							thelamp:SetFarZ(FarZ)
							thelamp:SetNearZ(proj.NearZ)
							thelamp:SetFOV(proj.Fov)
							if FarZ > 500 then
								thelamp:SetConstantAttenuation(0.5)
							end

							proj.projector = thelamp
						elseif IsValid(proj.projector) then
							proj.projector:Remove()
							proj.projector = nil
						end
					elseif IsValid(proj.projector) then
						proj.projector:Remove()
						proj.projector = nil
					end
				end

				if IsValid(proj.projector) then
					local pos = ent:LocalToWorld(proj.pos)
					local ang = ent:LocalToWorldAngles(proj.ang)

					if proj.istriggered ~= trigger then
						proj.istriggered = trigger

						if proj.ontrigger.brightness then
							local brightness = trigger and proj.ontrigger.brightness or proj.brightness
							proj.projector:SetBrightness(brightness * mul)
						end

						if proj.ontrigger.mat then
							local mat = trigger and proj.ontrigger.mat or proj.mat
							proj.projector:SetTexture(mat)
						end

						if proj.ontrigger.FarZ then
							local FarZ = trigger and proj.ontrigger.FarZ or proj.FarZ
							proj.projector:SetFarZ(FarZ)
						end
					end

					proj.projector:SetPos(pos + vel)
					proj.projector:SetAngles(ang)
					proj.projector:Update()
				end
			end
		else
			vtable[i] = nil
		end
	end
end

local function SetupProjectedTextures(ent , vehiclelist)
	ent.Projtexts = {}

	local proj_col = vehiclelist.ModernLights and Color(215,240,255) or Color(220,205,160)

	if isvector(vehiclelist.L_HeadLampPos) and isangle(vehiclelist.L_HeadLampAng) then
		ent.Projtexts['FL'] = {
			trigger = 2,
			ontrigger = {
				mat = 'effects/flashlight/headlight_highbeam',
				FarZ = 2000,
				brightness = hdr:GetBool() and 8 or 0.5,
			},
			pos = vehiclelist.L_HeadLampPos,
			ang = vehiclelist.L_HeadLampAng,
			mat = 'effects/flashlight/headlight_lowbeam',
			col = proj_col,
			brightness = 0.5,
			FarZ = 1000,
			NearZ = 75,
			Fov = 80,
		}
	end

	if isvector(vehiclelist.R_HeadLampPos) and isangle(vehiclelist.R_HeadLampAng) then
		ent.Projtexts['FR'] = {
			trigger = 2,
			ontrigger = {
				mat = 'effects/flashlight/headlight_highbeam',
				FarZ = 2000,
				brightness = hdr:GetBool() and 8 or 0.5,
			},
			pos = vehiclelist.R_HeadLampPos,
			ang = vehiclelist.R_HeadLampAng,
			mat = 'effects/flashlight/headlight_lowbeam',
			col = proj_col,
			brightness = 0.5,
			FarZ = 1000,
			NearZ = 75,
			Fov = 80,
		}
	end

	if isvector(vehiclelist.L_RearLampPos) and isangle(vehiclelist.L_RearLampAng) then
		ent.Projtexts['RL'] = {
			trigger = 4,
			ontrigger = {
				brightness = hdr:GetBool() and 5 or 0.3,
			},
			pos = vehiclelist.L_RearLampPos,
			ang = vehiclelist.L_RearLampAng,
			mat = 'effects/flashlight/soft',
			col = Color(30,0,0),
			brightness = 0,
			FarZ = 200,
			NearZ = 45,
			Fov = 140,
		}

		ent.Projtexts['RL2'] = {
			trigger = 5,
			ontrigger = {
				brightness = hdr:GetBool() and 5 or 0.3,
			},
			pos = vehiclelist.L_RearLampPos,
			ang = vehiclelist.L_RearLampAng,
			mat = 'effects/flashlight/soft',
			col = Color(50,50,50),
			brightness = 0,
			FarZ = 200,
			NearZ = 45,
			Fov = 140,
		}
	end

	if isvector(vehiclelist.R_RearLampPos) and isangle(vehiclelist.R_RearLampAng) then
		ent.Projtexts['RR'] = {
			trigger = 4,
			ontrigger = {
				brightness = hdr:GetBool() and 5 or 0.3,
			},
			pos = vehiclelist.R_RearLampPos,
			ang = vehiclelist.R_RearLampAng,
			mat = 'effects/flashlight/soft',
			col = Color(30,0,0),
			brightness = 0,
			FarZ = 200,
			NearZ = 45,
			Fov = 140,
		}

		ent.Projtexts['RR2'] = {
			trigger = 5,
			ontrigger = {
				brightness = hdr:GetBool() and 5 or 0.3,
			},
			pos = vehiclelist.R_RearLampPos,
			ang = vehiclelist.R_RearLampAng,
			mat = 'effects/flashlight/soft',
			col = Color(50,50,50),
			brightness = 0,
			FarZ = 200,
			NearZ = 45,
			Fov = 140,
		}
	end

	ent:CallOnRemove('remove_projected_textures', function(vehicle)
		for _, proj in pairs(ent.Projtexts) do
			local thelamp = proj.projector
			if IsValid(thelamp) then
				thelamp:Remove()
			end
		end
	end)
end

local function SetUpLights(vname , ent)
	ent.Sprites = {}

	local vehiclelist = list.Get('simfphys_lights')[vname]
	if not vehiclelist then ent.SubMaterials = false return end

	ent.LightsEMS = vehiclelist.ems_sprites or false
	local hl_col = vehiclelist.ModernLights and {215,240,255} or {220,205,160}

	SetupProjectedTextures(ent , vehiclelist)

	if not vehiclelist or not vehiclelist.SubMaterials then
		ent.SubMaterials = false
	else
		ent.SubMaterials = vehiclelist.SubMaterials
	end

	if istable(vehiclelist.ems_sprites) then
		ent.PixVisEMS = {}
		for i = 1, table.Count(vehiclelist.ems_sprites) do
			ent.PixVisEMS[i] = util.GetPixelVisibleHandle()

			ent.LightsEMS[i].material = ent.LightsEMS[i].material and Material(ent.LightsEMS[i].material) or mat2
		end
	end

	if istable(vehiclelist.Headlight_sprites) then
		for _, data in pairs(vehiclelist.Headlight_sprites) do
			local s = {}
			s.PixVis = util.GetPixelVisibleHandle()
			s.trigger = 1

			if not isvector(data) then
				s.color = data.color and data.color or Color(hl_col[1], hl_col[2], hl_col[3],  255)
				s.material = data.material and Material(data.material) or mat2
				s.size = data.size and data.size or 16
				s.pos = data.pos
				if (data.OnBodyGroups) then s.bodygroups = data.OnBodyGroups end
				table.insert(ent.Sprites, s)
			else
				s.pos = data
				s.color = Color(hl_col[1], hl_col[2], hl_col[3],  255)
				s.material = mat
				s.size = 16
				table.insert(ent.Sprites, s)

				local s2 = {}
				s2.PixVis = util.GetPixelVisibleHandle()
				s2.trigger = s.trigger
				s2.pos = data
				s2.color = Color(hl_col[1], hl_col[2], hl_col[3],  150)
				s2.material = mat2
				s2.size = 64
				table.insert(ent.Sprites, s2)
			end
		end
	end

	if istable(vehiclelist.Rearlight_sprites) then
		for _, data in pairs(vehiclelist.Rearlight_sprites) do
			local s = {}
			s.PixVis = util.GetPixelVisibleHandle()
			s.trigger = 1

			if not isvector(data) then
				s.color = data.color and data.color or Color(255, 0, 0,  125)
				s.material = data.material and Material(data.material) or mat2
				s.size = data.size and data.size or 16
				s.pos = data.pos
				if (data.OnBodyGroups) then s.bodygroups = data.OnBodyGroups end
				table.insert(ent.Sprites, s)
			else
				local s2 = {}
				s2.PixVis = util.GetPixelVisibleHandle()
				s2.trigger = s.trigger
				s2.pos = data
				s2.color = Color(255, 120, 0,  125)
				s2.material = mat2
				s2.size = 12
				table.insert(ent.Sprites, s2)

				s.pos = data
				s.color = Color(255, 0, 0,  90)
				s.material = mat
				s.size = 32
				table.insert(ent.Sprites, s)
			end
		end
	end

	if istable(vehiclelist.Brakelight_sprites) then
		for _, data in pairs(vehiclelist.Brakelight_sprites) do
			local s = {}
			s.PixVis = util.GetPixelVisibleHandle()
			s.trigger = 4

			if not isvector(data) then
				s.color = data.color and data.color or Color(255, 0, 0,  125)
				s.material = data.material and Material(data.material) or mat2
				s.size = data.size and data.size or 16
				s.pos = data.pos
				if (data.OnBodyGroups) then s.bodygroups = data.OnBodyGroups end
				table.insert(ent.Sprites, s)
			else
				s.pos = data
				s.color = Color(255, 0, 0,  90)
				s.material = mat
				s.size = 32
				table.insert(ent.Sprites, s)

				local s2 = {}
				s2.PixVis = util.GetPixelVisibleHandle()
				s2.trigger = s.trigger
				s2.pos = data
				s2.color = Color(255, 120, 0,  125)
				s2.material = mat2
				s2.size = 12
				table.insert(ent.Sprites, s2)
			end
		end
	end

	if istable(vehiclelist.Reverselight_sprites) then
		for _, data in pairs(vehiclelist.Reverselight_sprites) do
			local s = {}
			s.PixVis = util.GetPixelVisibleHandle()
			s.trigger = 5

			if not isvector(data) then
				s.color = data.color and data.color or Color(255, 255, 255,  255)
				s.material = data.material and Material(data.material) or mat2
				s.size = data.size and data.size or 16
				s.pos = data.pos
				if (data.OnBodyGroups) then s.bodygroups = data.OnBodyGroups end
				table.insert(ent.Sprites, s)
			else
				s.pos = data
				s.color = Color(255, 255, 255,  150)
				s.material = mat
				s.size = 12
				table.insert(ent.Sprites, s)

				local s2 = {}
				s2.PixVis = util.GetPixelVisibleHandle()
				s2.trigger = s.trigger
				s2.pos = data
				s2.color =  Color(255, 255, 255,  80)
				s2.material = mat2
				s2.size = 25
				table.insert(ent.Sprites, s2)
			end
		end
	end

	if istable(vehiclelist.FrontMarker_sprites) then
		for _, data in pairs(vehiclelist.FrontMarker_sprites) do
			local s = {}
			s.PixVis = util.GetPixelVisibleHandle()
			s.trigger = 1

			if isvector(data) then
				s.pos = data
				s.color = Color(200, 100, 0,  150)
				s.material = mat
				s.size = 12
				table.insert(ent.Sprites, s)
			end
		end
	end

	if istable(vehiclelist.RearMarker_sprites) then
		for _, data in pairs(vehiclelist.RearMarker_sprites) do
			local s = {}
			s.PixVis = util.GetPixelVisibleHandle()
			s.trigger = 1

			if isvector(data) then
				s.pos = data
				s.color = Color(205, 0, 0,  150)
				s.material = mat
				s.size = 12
				table.insert(ent.Sprites, s)
			end
		end
	end

	if istable(vehiclelist.Headlamp_sprites) then
		for _, data in pairs(vehiclelist.Headlamp_sprites) do
			local s = {}
			s.PixVis = util.GetPixelVisibleHandle()
			s.trigger = 2

			if not isvector(data) then
				s.color = data.color and data.color or Color(hl_col[1], hl_col[2], hl_col[3],  255)
				s.material = data.material and Material(data.material) or mat2
				s.size = data.size and data.size or 16
				s.pos = data.pos
				if (data.OnBodyGroups) then s.bodygroups = data.OnBodyGroups end
				table.insert(ent.Sprites, s)
			else
				s.pos = data
				s.color = Color(hl_col[1], hl_col[2], hl_col[3],  255)
				s.material = mat
				s.size = 16
				table.insert(ent.Sprites, s)

				local s2 = {}
				s2.PixVis = util.GetPixelVisibleHandle()
				s2.trigger = s.trigger
				s2.pos = data
				s2.color = Color(hl_col[1], hl_col[2], hl_col[3],  150)
				s2.material = mat2
				s2.size = 64
				table.insert(ent.Sprites, s2)
			end
		end
	end

	if istable(vehiclelist.FogLight_sprites) then
		for _, data in pairs(vehiclelist.FogLight_sprites) do
			local s = {}
			s.PixVis = util.GetPixelVisibleHandle()
			s.trigger = 3

			if not isvector(data) then
				s.color = data.color and data.color or Color(hl_col[1], hl_col[2], hl_col[3],  255)
				s.material = data.material and Material(data.material) or mat2
				s.size = data.size and data.size or 32
				s.pos = data.pos
				if (data.OnBodyGroups) then s.bodygroups = data.OnBodyGroups end
				table.insert(ent.Sprites, s)
			else
				s.pos = data
				s.color = Color(hl_col[1], hl_col[2], hl_col[3],  200)
				s.material = mat2
				s.size = 32
				table.insert(ent.Sprites, s)
			end
		end
	end

	if istable(vehiclelist.Turnsignal_sprites) then
		ent.HasTurnSignals = true

		if istable(vehiclelist.Turnsignal_sprites.Left) then
			for _, data in pairs(vehiclelist.Turnsignal_sprites.Left) do
				local s = {}
				s.PixVis = util.GetPixelVisibleHandle()
				s.trigger = 6

				if not isvector(data) then
					s.color = data.color and data.color or Color(200, 100, 0,  255)
					s.material = data.material and Material(data.material) or mat2
					s.size = data.size and data.size or 24
					s.pos = data.pos
					if (data.OnBodyGroups) then s.bodygroups = data.OnBodyGroups end
					table.insert(ent.Sprites, s)
				else
					s.pos = data
					s.color = Color(255, 150, 0,  150)
					s.material = mat
					s.size = 20
					table.insert(ent.Sprites, s)

					local s2 = {}
					s2.PixVis = util.GetPixelVisibleHandle()
					s2.trigger = s.trigger
					s2.pos = data
					s2.color = Color(200, 100, 0,  80)
					s2.material = mat2
					s2.size = 70
					table.insert(ent.Sprites, s2)
				end
			end
		end

		if istable(vehiclelist.Turnsignal_sprites.Right) then
			for _, data in pairs(vehiclelist.Turnsignal_sprites.Right) do
				local s = {}
				s.PixVis = util.GetPixelVisibleHandle()
				s.trigger = 7

				if not isvector(data) then
					s.color = data.color and data.color or Color(200, 100, 0,  255)
					s.material = data.material and Material(data.material) or mat2
					s.size = data.size and data.size or 24
					s.pos = data.pos
					if (data.OnBodyGroups) then s.bodygroups = data.OnBodyGroups end
					table.insert(ent.Sprites, s)
				else
					s.pos = data
					s.color = Color(255, 150, 0,  150)
					s.material = mat
					s.size = 20
					table.insert(ent.Sprites, s)

					local s2 = {}
					s2.PixVis = util.GetPixelVisibleHandle()
					s2.trigger = s.trigger
					s2.pos = data
					s2.color = Color(200, 100, 0,  80)
					s2.material = mat2
					s2.size = 70
					table.insert(ent.Sprites, s2)
				end
			end
		end

		if istable(vehiclelist.Turnsignal_sprites.TurnBrakeLeft) then
			ent.HasSpecialTurnSignals = true
			for _, data in pairs(vehiclelist.Turnsignal_sprites.TurnBrakeLeft) do
				local s = {}
				s.PixVis = util.GetPixelVisibleHandle()
				s.trigger = 8

				if not isvector(data) then
					s.color = data.color and data.color or Color(255, 0, 0,  125)
					s.material = data.material and Material(data.material) or mat2
					s.size = data.size and data.size or 16
					s.pos = data.pos
					if (data.OnBodyGroups) then s.bodygroups = data.OnBodyGroups end
					table.insert(ent.Sprites, s)
				else
					s.pos = data
					s.color = Color(255, 60, 0,  90)
					s.material = mat
					s.size = 40
					table.insert(ent.Sprites, s)

					local s2 = {}
					s2.PixVis = util.GetPixelVisibleHandle()
					s2.trigger = s.trigger
					s2.pos = data
					s2.color = Color(255, 120, 0,  125)
					s2.material = mat2
					s2.size = 16
					table.insert(ent.Sprites, s2)
				end
			end
		end

		if istable(vehiclelist.Turnsignal_sprites.TurnBrakeRight) then
			ent.HasSpecialTurnSignals = true
			for _, data in pairs(vehiclelist.Turnsignal_sprites.TurnBrakeRight) do
				local s = {}
				s.PixVis = util.GetPixelVisibleHandle()
				s.trigger = 9

				if not isvector(data) then
					s.color = data.color and data.color or Color(255, 0, 0,  125)
					s.material = data.material and Material(data.material) or mat2
					s.size = data.size and data.size or 16
					s.pos = data.pos
					if (data.OnBodyGroups) then s.bodygroups = data.OnBodyGroups end
					table.insert(ent.Sprites, s)
				else
					s.pos = data
					s.color = Color(255, 60, 0,  90)
					s.material = mat
					s.size = 40
					table.insert(ent.Sprites, s)

					local s2 = {}
					s2.PixVis = util.GetPixelVisibleHandle()
					s2.trigger = s.trigger
					s2.pos = data
					s2.color = Color(255, 120, 0,  125)
					s2.material = mat2
					s2.size = 16
					table.insert(ent.Sprites, s2)
				end
			end
		end
	end

	ent.EnableLights = true
	table.insert(vtable, ent)
end

local function DrawEMSLights(ent)
	local Time = CurTime()

	if ent.LightsEMS then

		for i = 1, table.Count(ent.LightsEMS) do
			if not ent.LightsEMS[i].Damaged then

				local size = ent.LightsEMS[i].size
				local LightPos = ent:LocalToWorld(ent.LightsEMS[i].pos)
				local Visible = util.PixelVisible(LightPos, 4, ent.PixVisEMS[i])
				local mat = ent.LightsEMS[i].material
				local numcolors = table.Count(ent.LightsEMS[i].Colors)

				ent.LightsEMS[i].Timer = ent.LightsEMS[i].Timer or 0
				ent.LightsEMS[i].Index = ent.LightsEMS[i].Index or 0

				if numcolors > 1 and ent.LightsEMS[i].Timer < Time then
					ent.LightsEMS[i].Timer = Time + ent.LightsEMS[i].Speed
					ent.LightsEMS[i].Index = ent.LightsEMS[i].Index + 1

					if ent.LightsEMS[i].Index > numcolors then
						ent.LightsEMS[i].Index = 1
					end
				end

				local col = ent.LightsEMS[i].Colors[ent.LightsEMS[i].Index]

				if ent.LightsEMS[i].OnBodyGroups then
					Visible = ent:BodyGroupIsValid(ent.LightsEMS[i].OnBodyGroups) and Visible or 0
				end

				if Visible and Visible >= 0.6 and col ~= Color(0,0,0,0) then
					Visible = (Visible - 0.6) / 0.4

					render.SetMaterial(mat)
					-- they are way too dim by default
					-- TODO: render specific 3d sprites from photon along with halos
					for _ = 1, 5 do
						render.DrawSprite(LightPos, size, size,  Color(col['r'], col['g'], col['b'],  col['a'] * Visible))
					end
				end
			end
		end
	end
end

hook.Add('Think', 'simfphys_lights_managment', function()
	local curtime = CurTime()

	ManageProjTextures()

	if NextCheck < curtime then
		NextCheck = curtime + checkinterval

		for _, ent in pairs(ents.FindByClass('gmod_sent_vehicle_fphysics_base')) do
			if ent.EnableLights ~= true then
				local listname = ent:GetLights_List()

				if listname then
					if listname ~= 'no_lights' then
						SetUpLights(listname, ent)
					else
						ent.EnableLights = true
					end
				end
			end
		end
	end
end)

hook.Add('PostDrawTranslucentRenderables', 'simfphys_draw_sprites', function()
	if SpritesDisabled then return end
	if vtable then
		for _, ent in pairs(vtable) do
			if IsValid(ent) and istable(ent.triggers) and ent:GetPos():DistToSqr(EyePos()) < maxLightSpriteDist then
				if ent:GetEMSEnabled() then
					DrawEMSLights(ent)
				end

				for _, sprite in pairs(ent.Sprites) do
					if not sprite.Damaged then
						local regTrigger = ent.triggers[ sprite.trigger ]
						local typeSpecial = (sprite.trigger == 8 and ent.triggers[ 6 ]) or (sprite.trigger == 9 and ent.triggers[7])
						if typeSpecial then regTrigger = false end

						if regTrigger or typeSpecial then
							local LightPos = ent:LocalToWorld(sprite.pos)
							local Visible = util.PixelVisible(LightPos, 4, sprite.PixVis)
							local s_col = sprite.color
							local s_mat = sprite.material
							local s_size = sprite.size

							if sprite.bodygroups then
								Visible = BodyGroupIsValid(sprite.bodygroups, ent) and Visible or 0
							end

							if Visible and Visible >= 0.6 then
								Visible = (Visible - 0.6) / 0.4
								render.SetMaterial(s_mat)

								local c_Alpha = s_col['a'] * Visible
								if (sprite.trigger == 6 or sprite.trigger == 7 or typeSpecial) and not ent.forceFlasher then
									c_Alpha = c_Alpha * (ent:GetFlasher() ^ 7)
								end

								render.DrawSprite(LightPos, s_size, s_size,  Color(s_col['r'], s_col['g'], s_col['b'],  c_Alpha))
							end
						end
					end
				end
			end
		end
	end
end)

local glassimpact = Sound('Glass.BulletImpact')
local function spritedamage(length)
	if not AllowVisualDamage then return end

	local veh = net.ReadEntity()
	if not IsValid(veh) then return end

	local pos = veh:LocalToWorld(net.ReadVector())
	local Rad = net.ReadBool() and 26 or 8
	local curtime = CurTime()

	veh.NextImpactsnd = veh.NextImpactsnd or 0

	if istable(veh.Sprites) then

		for i, sprite in pairs(veh.Sprites) do

			if not sprite.Damaged then

				local spritepos = veh:LocalToWorld(sprite.pos)
				local Dist = (spritepos - pos):Length()

				if Dist < Rad then
					veh.Sprites[i].Damaged = true

					if sprite.trigger >= 6 then
						veh.turnsignals_damaged = true
					end

					local effectdata = EffectData()
						effectdata:SetOrigin(spritepos)
					util.Effect('GlassImpact', effectdata, true, true)

					if veh.NextImpactsnd < curtime then
						veh.NextImpactsnd = curtime + 0.05
						sound.Play(glassimpact, spritepos, 75)
					end
				end
			end
		end
	end

	if istable(veh.Projtexts) then

		for i, proj in pairs(veh.Projtexts) do

			if not proj.Damaged then

				local lamppos = veh:LocalToWorld(proj.pos)
				local Dist = (lamppos - pos):Length()

				if Dist < Rad * 2 then
					veh.Projtexts[i].Damaged = true
				end
			end
		end
	end

	if istable(veh.LightsEMS) then

		for i = 1, table.Count(veh.LightsEMS) do

			if not veh.LightsEMS[i].Damaged then

				local spritepos = veh:LocalToWorld(veh.LightsEMS[i].pos)
				local Dist = (spritepos - pos):Length()

				if Dist < Rad then
					veh.LightsEMS[i].Damaged = true

					local effectdata = EffectData()
						effectdata:SetOrigin(spritepos)
					util.Effect('GlassImpact', effectdata, true, true)

					if veh.NextImpactsnd < curtime then
						veh.NextImpactsnd = curtime + 0.05
						sound.Play(glassimpact, spritepos, 75)
					end
				end
			end
		end
	end
end
net.Receive('simfphys_spritedamage', spritedamage)

local function spriterepair(length)
	local veh = net.ReadEntity()

	if not IsValid(veh) then return end

	veh.turnsignals_damaged = nil

	if istable(veh.Sprites) then
		for i in pairs(veh.Sprites) do
			veh.Sprites[i].Damaged = false
		end
	end

	if istable(veh.Projtexts) then
		for i in pairs(veh.Projtexts) do
			veh.Projtexts[i].Damaged = false
		end
	end

	if istable(veh.LightsEMS) then
		for i = 1, table.Count(veh.LightsEMS) do
			veh.LightsEMS[i].Damaged = false
		end
	end
end
net.Receive('simfphys_lightsfixall', spriterepair)


local function turnSignal(ent, turnmode)
	if not IsValid(ent) then return end

	ent.lastTurnMode = turnmode

	if turnmode == 0 then
		ent.signal_left = false
		ent.signal_right = false

		local vehicle = LocalPlayer():GetVehicle()
		if IsValid(vehicle) and IsValid(vehicle.vehiclebase) and vehicle.vehiclebase == ent then
			vehicle.vehiclebase:EmitSound('simulated_vehicles/sfx/turnsignal_end.ogg')
		end
	end

	if turnmode == 1 then
		ent.signal_left = true
		ent.signal_right = true
	end

	if turnmode == 2 then
		ent.signal_left = true
		ent.signal_right = false
	end

	if turnmode == 3 then
		ent.signal_left = false
		ent.signal_right = true
	end
end
net.Receive('simfphys_turnsignal', function()
	turnSignal(net.ReadEntity(), net.ReadInt(32))
end)

local wasNight = false
timer.Create('simfphys.updateProjectorsAtNight', 5, 0, function()
	local isNight = StormFox2.Time.IsNight()
	if isNight == wasNight then return end
	wasNight = isNight

	for i, ent in pairs(vtable) do
		if IsValid(ent) then
			for _, proj in pairs(ent.Projtexts) do
				if IsValid(proj.projector) then
					proj.projector:Remove()
					proj.projector = nil
					proj.LampsActive = nil
				end
			end
		end
	end
end)

hook.Add('NotifyShouldTransmit', 'simfphys.lighting', function(ent, transmit)
	if not transmit or not ent.SubMaterials then return end

	timer.Simple(0, function()
		UpdateSubMats(ent)
	end)
end)

-- local function setFlasher(veh, on)
-- 	if not IsValid(veh) then return end
-- 	veh.signal_left = on
-- 	veh.signal_right = on
-- 	veh.forceFlasher = on
-- end

-- netstream.Hook('simfphys.flash', function(veh, times)
-- 	for i = 0, times - 1 do
-- 		timer.Simple(i * 0.25, function() setFlasher(veh, true) end)
-- 		timer.Simple(i * 0.25 + 0.15, function() setFlasher(veh, false) end)
-- 	end
-- 	timer.Simple(times * 0.25 + 0.15, function()
-- 		turnSignal(veh, veh.lastTurnMode or 0)
-- 	end)
-- end)
