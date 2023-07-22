
-- Copyright (C) 2017-2020 DBotThePony

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.

local http = http
local DLib = DLib
local Promise = DLib.Promise

http.Get = http.Fetch

function http.PromiseFetch(url, headers)
	return Promise(function(resolve, reject)
		http.Fetch(url, resolve, reject, headers)
	end)
end

http.PromiseGet = http.PromiseFetch

function http.PromisePost(url, params, headers)
	return Promise(function(resolve, reject)
		http.Post(url, params, resolve, reject, headers)
	end)
end

function http.PromisePostBody(url, body, headers)
	return Promise(function(resolve, reject)
		http.PostBody(url, body, resolve, reject, headers)
	end)
end

function http.PromiseHead(url, headers)
	return Promise(function(resolve, reject)
		http.Head(url, resolve, reject, headers)
	end)
end

function http.PromisePut(url, body, params, headers)
	return Promise(function(resolve, reject)
		http.Put(url, body, resolve, reject, headers)
	end)
end

if CLIENT then
	local steamworks = steamworks

	function steamworks.PromiseDownload(wsid, uncompress)
		return Promise(function(resolve)
			steamworks.Download(wsid, uncompress, function(data)
				if not data then
					reject('Unsuccessful')
					return
				end

				resolve(data)
			end)
		end)
	end

	function steamworks.PromiseFileInfo(wsid)
		return Promise(function(resolve, reject)
			steamworks.FileInfo(wsid, function(data)
				if not data then
					reject('Unsuccessful')
					return
				end

				resolve(data)
			end)
		end)
	end

	function steamworks.PromiseGetList(_type, tags, offset, numRetrieve, days, userID)
		return Promise(function(resolve, reject)
			steamworks.GetList(_type, tags, offset, numRetrieve, days, userID, function(data)
				if not data then
					reject('Unsuccessful')
					return
				end

				resolve(data)
			end)
		end)
	end

	function steamworks.PromiseRequestPlayerInfo(steamid64)
		return Promise(function(resolve, reject)
			steamworks.RequestPlayerInfo(steamid64, function(data)
				if not data then
					reject('Unsuccessful')
					return
				end

				resolve(data)
			end)
		end)
	end

	function steamworks.PromiseVoteInfo(wsid)
		return Promise(function(resolve, reject)
			steamworks.VoteInfo(steamid64, function(data)
				if not data then
					reject('Unsuccessful')
					return
				end

				resolve(data)
			end)
		end)
	end
end
