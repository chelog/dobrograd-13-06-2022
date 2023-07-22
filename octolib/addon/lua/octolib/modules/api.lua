--[[
	Class: octolib.API
		Object to simplify work with HTTP endpoints
]]

local API = {}
API.__index = API

--
-- Group: Constructors
--

--[[
	Function: octolib.api
		Create API object

	Arguments:
		<ConfigAPI> config - API object config

	Example:
		--- Lua
		local myApi = octolib.api({
			url = 'http://example.com/api',
			headers = { ['Authorization'] = 't0ps3cr3t' },
		})

		myApi:get('/users/1'):Then(function(result)
			if result.code == 200 then
				print('User name is ' .. result.data.username)
			else
				print('Failed to get user info')
			end
		end)
		---
]]
function octolib.api(config)

	local api = {
		url = config.url,
		headers = config.headers,
	}

	setmetatable(api, API)
	return api

end

--
-- Group: Methods
--

--[[
	Function: _request
		Perform generic request, used internally, use HTTP verbs methods instead

	Arguments:
		<string> path - Path relative to endpoint
		<string> verb - <HTTP verb: https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods>
		<table> data - optional table of data

	Returns:
		<Promise> (<RequestResult>) - Promise with results of request
]]
function API:_request(path, verb, data)

	local url = self.url .. path
	local opts = {
		headers = self.headers,
		url = url,
		method = verb:lower(),
		type = 'application/json',
	}

	if data then
		if opts.method == 'get' then
			local params = {}
			for k, v in pairs(data) do params[#params + 1] = ('%s=%s'):format(octolib.string.urlEncode(k), octolib.string.urlEncode(v)) end
			opts.url = opts.url .. '?' .. table.concat(params, '&')
		else
			opts.body = util.TableToJSON(data)
		end
	end

	return util.Promise(function(res, rej)
		opts.success = function(code, body, headers)
			local data = body and util.JSONToTable(body)
			if data then
				res({
					code = code,
					data = data,
				})
			else
				rej('Invalid response:' .. body)
			end
		end

		opts.failed = function(reason)
			print(('API request on %s failed: %s'):format(url, reason))
			rej(reason)
		end

		HTTP(opts)
	end)

end

--[[
	Function: get
		GET request to api endpoint. Data will be encoded into URL

	--- Prototype
	function API:get(path, data)
	---

	Arguments:
		<string> path - Path relative to endpoint
		<table> data - optional table of data

	Returns:
		<Promise> (<RequestResult>) - Result of API request
]]

--[[
	Function: post
		POST request to api endpoint. Data will be encoded into request body as JSON
		Also available with same parameters: API:put(), API:delete(), API:patch()

	--- Prototype
	function API:get(path, data)
	---

	Arguments:
		<string> path - Path relative to endpoint
		<table> data - optional table of data

	Returns:
		<Promise> (<RequestResult>) - Result of API request
]]

-- define HTTP verbs funcs
local verbs = {'get', 'post', 'put', 'delete', 'patch'}
for i, verb in ipairs(verbs) do
	API[verb] = function(self, path, data)
		return self:_request(path, verb, data)
	end
end

--
-- Group: Structures
--

--[[
	Type: ConfigAPI
		API config structure

	Properties:
		<string> url - Endpoint URL
		<table> headers - Keyed table of headers sent with each request
]]
--[[
	Type: RequestResult
		HTTP response structure

	Properties:
		<int> code - <HTTP response status code: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status>
		<table> data - Parsed response body
]]

local function octoservicesTryInit()
	if not CFG.octoservicesURL then return end

	hook.Remove('Think', 'octolib.api.octoservices')

	octoservices = octolib.api({
		url = CFG.octoservicesURL,
		headers = { ['x-api-key'] = CFG.keys and CFG.keys.services or nil },
	})

	hook.Run('octoservices.init', octoservices)
end
octoservicesTryInit()
hook.Add('Think', 'octolib.api.octoservices', octoservicesTryInit)
