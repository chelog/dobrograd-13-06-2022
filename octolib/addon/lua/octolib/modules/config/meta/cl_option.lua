local Option = octolib.meta.getOrCreate('configOption')

function Option:Load(callback, fail)
	if not self:CanRead(LocalPlayer()) then
		return callback()
	end

	netstream.Request('octolib.config.get', self.id)
		:Then(function(value)
			self:Set(value)

			if callback then
				callback(value)
			end
		end)
		:Catch(fail)
end

function Option:Save(callback, fail)
	if not self:CanWrite(LocalPlayer()) then
		return callback(false)
	end

	netstream.Request('octolib.config.set', self.id, self.value)
		:Then(callback)
		:Catch(fail)
end
