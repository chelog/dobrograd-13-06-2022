function octolib.screen.capture(config)

	return util.Promise(function(resolve, reject)
		hook.Add('PostRender', 'octolib.screen', function()
			hook.Remove('PostRender', 'octolib.screen')
			resolve(render.Capture(config or { format = 'png', quality = 100, alpha = false, h = ScrH(), w = ScrW(), x = 0, y = 0 }))
		end)
	end)

end

local function getUrl()
	return octolib.imgurUsesProxy() and 'https://wani4ka.ru/api/imgur/upload' or 'https://api.imgur.com/3'
end

local api
hook.Add('PlayerFinishedLoading', 'octolib.imgur', function()
	api = octolib.api({
		url = getUrl(),
		headers = {},
	})
end)

function octolib.screen.sendToImgur(data)

	return util.Promise(function(resolve, reject)
		if not api then return reject('Неизвестная техническая ошибка') end
		api.url = getUrl()
		api:post('/image', {
			image = util.Base64Encode(data.img),
			name = data.name or 'grab.png',
			type = data.type or 'png',
			title = data.title or 'octolib.screen',
		}):Then(function(res)
			resolve(res.data)
		end):Catch(function(r)
			reject(tostring(r))
		end)
	end)

end

netstream.Listen('octolib.imgur', function(reply, key)
	api.headers.Authorization = 'Client-ID ' .. tostring(key)
	octolib.screen.capture():Then(function(img)
		return octolib.screen.sendToImgur({
			img = img,
			title = ('%s (%s)'):format(LocalPlayer():Name(), LocalPlayer():SteamID()),
		})
	end):Then(reply):Catch(reply)
end)
