function octolib.screen.sendToImgur(ply)

	return util.Promise(function(resolve, reject)
		netstream.Request(ply, 'octolib.imgur', CFG.imgurKey):Then(function(res)
			if istable(res) then resolve(res) else reject(res) end
		end):Catch(reject)
	end)

end
