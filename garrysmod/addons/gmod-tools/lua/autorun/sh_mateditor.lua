materials = materials or {};
materials.stored = materials.stored or {};
materials.ents = {}
for _, ent in ipairs(ents.GetAll()) do
	if ent.MaterialData ~= nil then
		table.insert(materials.ents, ent)
	end
end

function materials:GetStored()
	return self.stored;
end;

function materials:Set(ent, texture, data, filter)
	if (SERVER) then
		data.texture = texture
		netstream.Start(filter, 'Materialize', { ent }, { data })
		table.RemoveByValue(materials.ents, ent)

		if (texture == nil or texture == '') then
			if (IsValid(ent)) then
				ent:SetMaterial('');
				ent.MaterialData = nil
				duplicator.ClearEntityModifier(ent, 'MaterialData')
			end;

			return;
		end;

		ent:SetMaterial('');
		table.insert(materials.ents, ent)

		ent.MaterialData = {
			texture = texture,
			ScaleX = data.ScaleX or 1,
			ScaleY = data.ScaleY or 1,
			OffsetX = data.OffsetX or 0,
			OffsetY = data.OffsetY or 0,
			UseNoise = data.UseNoise or false,
			NoiseTexture = data.NoiseTexture or 'detail/noise_detail_01',
			NoiseScaleX = data.NoiseScaleX or 1,
			NoiseScaleY = data.NoiseScaleY or 1,
			NoiseOffsetX = data.NoiseOffsetX or 0,
			NoiseOffsetY = data.NoiseOffsetY or 0,
		};

		texture = texture:lower();
		texture = string.Trim(texture);
		local uid = texture .. '+' .. (data.ScaleX or 1) .. '+' .. (data.ScaleY or 1) .. '+' .. (data.OffsetX or 0) .. '+' .. (data.OffsetY or 0);

		if (data.UseNoise) then
			uid = uid .. (data.NoiseTexture or 'detail/noise_detail_01') .. '+' .. (data.NoiseScaleX or 1) .. '+' .. (data.NoiseScaleY or 1) .. '+' .. (data.NoiseOffsetX or 0) .. '+' .. (data.NoiseOffsetY or 0);
		end;

		uid = uid:gsub('%.', '-');

		ent:SetMaterial('!' .. uid);

		duplicator.StoreEntityModifier(ent, 'MaterialData', ent.MaterialData);
	else
		if (texture == nil or texture == '') then
			if (IsValid(ent)) then
				ent:SetMaterial('');
			end;

			return;
		end;

		ent:SetMaterial('');

		data = data or {};
		data.texture = texture;
		data.UseNoise = data.UseNoise or false;
		data.ScaleX = data.ScaleX or 1;
		data.ScaleY = data.ScaleY or 1;
		data.OffsetX = data.OffsetX or 0;
		data.OffsetY = data.OffsetY or 0;
		data.NoiseTexture = data.NoiseTexture or 'detail/noise_detail_01';
		data.NoiseScaleX = data.NoiseScaleX or 1;
		data.NoiseScaleY = data.NoiseScaleY or 1;
		data.NoiseOffsetX = data.NoiseOffsetX or 0;
		data.NoiseOffsetY = data.NoiseOffsetY or 0;

		texture = texture:lower();
		texture = string.Trim(texture);

		local tempMat = Material(texture);

		if (string.find(texture, '../', 1, true) or string.find(texture, 'pp/', 1, true)) then
			return;
		end;

		local uid = texture .. '+' .. data.ScaleX .. '+' .. data.ScaleY .. '+' .. data.OffsetX .. '+' .. data.OffsetY;

		if (data.UseNoise) then
			uid = uid .. (data.NoiseTexture or 'detail/noise_detail_01') .. '+' .. (data.NoiseScaleX or 1) .. '+' .. (data.NoiseScaleY or 1) .. '+' .. (data.NoiseOffsetX or 0) .. '+' .. (data.NoiseOffsetY or 0);
		end;

		uid = uid:gsub('%.', '-');

		if (!self.stored[uid]) then

			local matTable = {
				['$basetexture'] = tempMat:GetName(),
				['$basetexturetransform'] = 'center .5 .5 scale ' .. (1 / data.ScaleX) .. ' ' .. (1 / data.ScaleY) .. ' rotate 0 translate ' .. data.OffsetX .. ' ' .. data.OffsetY,
				['$vertexalpha'] = 0,
				['$vertexcolor'] = 1
			};

			for k, v in pairs(data) do
				if (k:sub(1, 1) == '$') then
					matTable[k] = v;
				end;
			end;

			if (data.UseNoise) then
				matTable['$detail'] = data.NoiseTexture;
			end;

			if (file.Exists('materials/' .. texture .. '_normal.vtf', 'GAME')) then
				matTable['$bumpmap'] = texture .. '_normal';
				matTable['$bumptransform'] = 'center .5 .5 scale ' .. (1 / data.ScaleX) .. ' ' .. (1 / data.ScaleY) .. ' rotate 0 translate ' .. data.OffsetX .. ' ' .. data.OffsetY;
			end;

			local matrix = Matrix();
			matrix:Scale(Vector(1 / data.ScaleX, 1 / data.ScaleY, 1));
			matrix:Translate(Vector(data.OffsetX, data.OffsetY, 0));

			local noiseMatrix = Matrix();
			noiseMatrix:Scale(Vector(1 / data.NoiseScaleX, 1 / data.NoiseScaleY, 1));
			noiseMatrix:Translate(Vector(data.NoiseOffsetX, data.NoiseOffsetY, 0));

			self.stored[uid] = CreateMaterial(uid, 'VertexLitGeneric', matTable);
			if tempMat:GetTexture('$basetexture') then self.stored[uid]:SetTexture('$basetexture', tempMat:GetTexture('$basetexture')); end
			self.stored[uid]:SetMatrix('$basetexturetransform', matrix);
			self.stored[uid]:SetMatrix('$detailtexturetransform', noiseMatrix);
		end;

		ent.MaterialData = {
			texture = texture,
			ScaleX = data.ScaleX or 1,
			ScaleY = data.ScaleY or 1,
			OffsetX = data.OffsetX or 0,
			OffsetY = data.OffsetY or 0,
			UseNoise = data.UseNoise or false,
			NoiseTexture = data.NoiseTexture or 'detail/noise_detail_01',
			NoiseScaleX = data.NoiseScaleX or 1,
			NoiseScaleY = data.NoiseScaleY or 1,
			NoiseOffsetX = data.NoiseOffsetX or 0,
			NoiseOffsetY = data.NoiseOffsetY or 0,
		};

		ent:SetMaterial('!' .. uid);
	end;
end;

if (CLIENT) then
	netstream.Hook('Materialize', function(ents, mats)
		for i, ent in ipairs(ents) do
			if not IsValid(ent) then continue end

			local mat = mats[i]
			materials:Set(ent, mat and mat.texture or '', mat or {})
		end
	end);
else
	local function syncMaterials(ply)
		local mats = octolib.table.mapSequential(materials.ents, function(ent)
			return ent.MaterialData
		end)
		netstream.Heavy(ply, 'Materialize', materials.ents, mats)
	end
	hook.Add('PlayerFinishedLoading', 'MaterialData', function(ply)
		timer.Simple(15, function()
			if not IsValid(ply) then return end
			syncMaterials(ply)
		end)
	end)

	local page = 1
	timer.Create('advMat.sync', 10, 0, function()
		if player.GetCount() < 1 then return end

		local plys = octolib.array.page(player.GetAll(), 10, page)
		if table.Count(plys) < 1 then
			page = 1
			plys = octolib.array.page(player.GetAll(), 10, page)
		end
		page = page + 1

		syncMaterials(plys)
	end)

	timer.Create('advMat.validate', 30, 0, function()
		for i = #materials.ents, 1, -1 do
			if not IsValid(materials.ents[i]) then
				table.remove(materials.ents, i)
			end
		end
	end)

	hook.Add('EntityRemoved', 'MaterialData', function(ent)
		if ent.MaterialData then
			table.RemoveByValue(materials.ents, ent)
		end
	end)

	concommand.Add('advmat_reload', function(ply)
		-- if ply.advmat_cooldown then return ply:Notify('Подожди немного, обновлять данные можно не чаще раза в 30 секунд') end

		syncMaterials(ply)
		-- ply.advmat_cooldown = true

		-- timer.Simple(30, function()
		-- 	if not IsValid(ply) then return end
		-- 	ply.advmat_cooldown = nil
		-- end)
	end)
end;

duplicator.RegisterEntityModifier('MaterialData', function(player, entity, data)
	materials:Set(entity, data.texture, data);
end);