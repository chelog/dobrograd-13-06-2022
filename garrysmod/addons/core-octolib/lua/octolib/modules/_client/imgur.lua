local original, proxy = 'https://i.imgur.com/', 'https://wani4ka.ru/api/imgur/'

local server

function octolib.imgurLoaded()
	return server ~= nil
end

function octolib.forceImgurProxy(useProxy)
	server = useProxy and proxy or original
end

function octolib.imgurUsesProxy()
	return server == proxy
end

http.Fetch('https://i.imgur.com/7pODAQu.jpg', function(body, size, headers, code)
	server = code == 200 and original or proxy
	hook.Run('octolib.imgur.loaded')
end, function()
	server = proxy
end)

function octolib.imgurImage(name)
	if not octolib.imgurLoaded() then
		ErrorNoHalt('Tried to load imgur image before server determined')
	end
	return (server or original) .. name
end

octolib.loadingMat = Material('octoteam/icons/clock.png')
local imgCache = {}

local function fileNameFromURL(url)
	return 'imgscreen/' ..
		string.StripExtension(url):gsub('https?://', ''):gsub('[\\/:*?"<>|%.]', '_') ..
		'.' .. string.GetExtensionFromFilename(url)
end

local function matNameFromURL(url)
	return '../data/' .. fileNameFromURL(url)
end

function octolib.getURLMaterial(url, callback, forceReload)
	local mat = imgCache[url]
	if not mat then
		imgCache[url] = octolib.loadingMat
		mat = octolib.loadingMat

		http.Fetch(url, function(content)
			file.Write(fileNameFromURL(url), content)

			local matName = matNameFromURL(url)
			RunConsoleCommand('mat_reloadmaterial', string.StripExtension(matName))
			imgCache[url] = Material(matName)

			if isfunction(callback) then callback(imgCache[url]) end
		end)
	else
		if forceReload then
			RunConsoleCommand('mat_reloadmaterial', string.StripExtension(matNameFromURL(url)))
		end
		if isfunction(callback) then callback(mat) end
	end
	return mat
end

function octolib.getImgurMaterial(url, callback, forceReload)
	return octolib.getURLMaterial(octolib.imgurImage(url), callback, forceReload)
end

local function clearCache()

	file.CreateDir('imgscreen')
	local fls = file.Find('imgscreen/*', 'DATA')
	for _, fl in ipairs(fls) do
		file.Delete('imgscreen/' .. fl)
	end

end
hook.Add('Shutdown', 'imgscreen.clearCache', clearCache)
hook.Add('PlayerFinishedLoading', 'imgscreen.clearCache', clearCache)

hook.Add('Think', 'octolib-imgur.init', function()
	hook.Remove('Think', 'octolib-imgur.init')
	vgui.GetControlTable('DImage').SetURL = function(self, url)
		octolib.getURLMaterial(url, function(mat)
			if not IsValid(self) then return end
			self:SetMaterial(mat)
		end)
	end
end)
