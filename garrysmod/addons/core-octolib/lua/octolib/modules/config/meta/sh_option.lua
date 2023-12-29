local Option = octolib.meta.getOrCreate('configOption')

function Option:On(name, id, callback)
	self.listeners = self.listeners or {}
	self.listeners[name] = self.listeners[name] or {}
	self.listeners[name][id] = callback
end

function Option:Off(name, id, callback)
	if not self.listeners or not self.listeners[name] then
		return
	end

	self.listeners[name][id] = nil
end

function Option:Emit(name, ...)
	if not self.listeners or not self.listeners[name] then
		return
	end

	for _, callback in pairs(self.listeners[name]) do
		callback(...)
	end
end

function Option:Get()
	return self.value
end

function Option:Set(value)
	if not self:Validate(value) then
		return
	end

	self.value = value

	self:Emit('changed', value)
end

function Option:Validate(value)
	if type(self.validate) ~= 'function' then return true end
	return self.validate(value)
end
