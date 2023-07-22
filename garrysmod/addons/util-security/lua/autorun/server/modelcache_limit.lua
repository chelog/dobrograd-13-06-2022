require 'octobin'

local maxModels = 4096 - 200

local function preventSpawnOverLimit(ply, model)
	if octobin.GetNumPrecachedModels() >= maxModels and not octobin.IsModelPrecached(model) then
		if IsValid(ply) and ply:TriggerCooldown('modelcache', 10) then
			ply:Notify('warning', 'Эту модель не получится заспавнить до следующего рестарта. Подробнее: https://octo.gg/model-cache')
		end
		return false
	end
end

util.IsValidModelRaw = util.IsValidModelRaw or util.IsValidModel
function util.IsValidModel(model)
	if octobin.GetNumPrecachedModels() >= maxModels and not octobin.IsModelPrecached(model) then
		return false
	end

	return util.IsValidModelRaw(model)
end

hook.Add('PlayerSpawnObject', 'model-cache', preventSpawnOverLimit)
hook.Add('PlayerSpawnProp', 'model-cache', preventSpawnOverLimit)
hook.Add('PlayerSpawnEffect', 'model-cache', preventSpawnOverLimit)
hook.Add('PlayerSpawnRagdoll', 'model-cache', preventSpawnOverLimit)
hook.Add('PlayerSpawnVehicle', 'model-cache', preventSpawnOverLimit)

timer.Create('modelCacheLimit.vote', octolib.time.toSeconds(15, 'minutes'), 0, function()
	if octobin.GetNumPrecachedModels() < maxModels then return end

	octolib.questions.start({
		text = 'На сервере превышен лимит уникальных моделей, которые может кэшировать движок игры, из-за чего спавнить новые невозможно. Единственное возможное решение - сделать рестарт. Если хотя бы 40% игроков проголосует "за", то мы поставим таймер на 20 минут.\n\nДелаем рестарт?',
		time = 180,
		onFinish = function(diff, yAmount, nAmount)
			local total = yAmount + nAmount
			if yAmount / total >= 0.4 then
				RunConsoleCommand('octolib_restart', octolib.time.toSeconds(20, 'minutes'))
				timer.Remove('modelCacheLimit.vote')
			end
		end,
	})
end)
