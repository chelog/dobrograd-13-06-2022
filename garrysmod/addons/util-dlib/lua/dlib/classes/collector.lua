do
  local _class_0
  local _base_0 = {
    Add = function(self, ...)
      return self:add(...)
    end,
    Rebuild = function(self, ...)
      return self:rebuild(...)
    end,
    Update = function(self, ...)
      return self:update(...)
    end,
    Calculate = function(self, ...)
      return self:calculate(...)
    end,
    SetSteps = function(self, ...)
      return self:setSteps(...)
    end,
    SetTimeout = function(self, ...)
      return self:setTimeout(...)
    end,
    SetDefault = function(self, ...)
      return self:setDefault(...)
    end,
    add = function(self, val, update)
      if val == nil then
        val = self.def
      end
      if update == nil then
        update = true
      end
      local time = CurTimeL()
      self.values[self.nextvalue] = {
        val,
        time
      }
      self.nextvalue = self.nextvalue + 1
      if self.nextvalue > self.steps then
        self.nextvalue = 1
      end
      if update then
        return self:update()
      end
    end,
    rebuild = function(self)
      local time = CurTimeL()
      do
        local _accum_0 = { }
        local _len_0 = 1
        for i = 1, self.steps do
          _accum_0[_len_0] = {
            self.def,
            time
          }
          _len_0 = _len_0 + 1
        end
        self.values = _accum_0
      end
    end,
    update = function(self)
      local time = CurTimeL()
      do
        local _accum_0 = { }
        local _len_0 = 1
        local _list_0 = self.values
        for _index_0 = 1, #_list_0 do
          local valData = _list_0[_index_0]
          if valData[2] + self.timeout < time then
            _accum_0[_len_0] = {
              self.def,
              time
            }
          else
            _accum_0[_len_0] = valData
          end
          _len_0 = _len_0 + 1
        end
        self.values = _accum_0
      end
    end,
    calculate = function(self)
      local output = 0
      local _list_0 = self.values
      for _index_0 = 1, #_list_0 do
        local val = _list_0[_index_0]
        output = output + val[1]
      end
      return output
    end,
    think = function(self)
      return self:update()
    end,
    Think = function(self)
      return self:update()
    end,
    Update = function(self)
      return self:update()
    end,
    setSteps = function(self, steps)
      if steps == nil then
        steps = self.steps
      end
      self.steps = steps
      self.nextvalue = 1
      return self:rebuild()
    end,
    setTimeout = function(self, timeout)
      if timeout == nil then
        timeout = self.timeout
      end
      self.timeout = timeout
      return self:rebuild()
    end,
    setDefault = function(self, def)
      if def == nil then
        def = self.def
      end
      self.def = def
      return self:rebuild()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, steps, timeout, def)
      if steps == nil then
        steps = 100
      end
      if timeout == nil then
        timeout = 1
      end
      if def == nil then
        def = 0
      end
      self.steps = steps
      self.nextvalue = 1
      self.timeout = timeout
      self.def = def
      return self:rebuild()
    end,
    __base = _base_0,
    __name = "Collector"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DLib.Collector = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.Collector
  local _base_0 = {
    calculate = function(self)
      local average = 0
      local values = self.steps
      local _list_0 = self.values
      for _index_0 = 1, #_list_0 do
        local val = _list_0[_index_0]
        average = average + val[1]
      end
      return average / values
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Average",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DLib.Average = _class_0
  return _class_0
end
