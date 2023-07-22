CFG.use.ent_dbg_camera = {
	function(ply, ent)
		if ent.pendingWorker ~= ply then return end
		return 'Починить', 'octoteam/icons/wrench.png', function(ply, ent)
			ent:Use(ply, ply, USE_TOGGLE, 1)
		end
	end,
	function(ply, ent)
		if not ply:IsSuperAdmin() then return end
		return 'Настроить', 'octoteam/icons/keypad.png', function(ply, ent)
			local dt, notifyData = ent:GetNetVar('rotationData', {}), octolib.array.toKeys(ent.notifyData) or {}
			local notifyOpts = octolib.table.mapSequential(table.GetKeys(simpleOrgs.orgs), function(v) return {simpleOrgs.orgs[v].name, v, notifyData[v]} end)
			notifyOpts[#notifyOpts + 1] = {'Полиция', 'cp', notifyData['cp']}
			octolib.request.send(ply, {
				pitch = {
					name = 'Наклон',
					type = 'numSlider',
					dec = 0,
					min = -45,
					max = 30,
					default = dt.p or 0,
				},
				center = {
					name = 'Центр',
					type = 'numSlider',
					dec = 0,
					min = -120,
					max = 120,
					default = dt.center or 0,
				},
				radius = {
					name = 'Радиус вращения',
					desc = 'Левая граница: центр - alpha, правая: центр + alpha',
					type = 'numSlider',
					dec = 0,
					min = 0,
					max = 90,
					default = dt.r or 0,
				},
				speed = {
					name = 'Скорость вращения',
					desc = 'Градусы/сек',
					type = 'numSlider',
					dec = 1,
					min = 0,
					max = 30,
					default = math.deg(dt.v or 0),
				},
				viewDist = {
					name = 'Дальность обзора',
					type = 'numSlider',
					dec = 0,
					min = 500,
					max = 2000,
					default = dt.viewDist or 1500,
				},
				notifyData = {
					name = 'Оповещения',
					desc = 'Выбери, какую организацию будет оповещать камера о всех нарушениях',
					type = 'checkGroup',
					opts = notifyOpts,
					required = true,
				},
			}, function(data)
				if IsValid(ent) then
					data.pitch = math.Clamp(data.pitch or dt.p or 0, -45, 30)
					data.center = math.Clamp(data.center or dt.center or 0, -120, 120)
					data.radius = math.Clamp(data.radius or dt.r or 0, 0, 90)
					data.speed = math.Clamp(data.speed or dt.v or 0, 0, 30)
					data.viewDist = math.Clamp(data.viewDist or dt.viewDist, 500, 2000)
					ent.notifyData = data.notifyData

					local ac = math.abs(data.center)
					if ac + data.radius > 120 then
						data.radius = 120 - ac
					end

					ent:SetRotationData(data.pitch, data.center, data.radius, math.rad(data.speed), data.viewDist)
				end
			end)
		end
	end,
}
