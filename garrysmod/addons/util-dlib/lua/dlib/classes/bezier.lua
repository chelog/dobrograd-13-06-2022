local Lerp, DLib, table, assert, type
do
  local _obj_0 = _G
  Lerp, DLib, table, assert, type = _obj_0.Lerp, _obj_0.DLib, _obj_0.table, _obj_0.assert, _obj_0.type
end
DLib.Bezier = { }
do
  local _class_0
  local _base_0 = {
    AddPoint = function(self, value)
      table.insert(self.values, value)
      return self
    end,
    PushPoint = function(self, value)
      return self:AddPoint(value)
    end,
    AddValue = function(self, value)
      return self:AddPoint(value)
    end,
    PushValue = function(self, value)
      return self:AddPoint(value)
    end,
    Add = function(self, value)
      return self:AddPoint(value)
    end,
    Push = function(self, value)
      return self:AddPoint(value)
    end,
    RemovePoint = function(self, i)
      return table.remove(self.values, i)
    end,
    PopPoint = function(self)
      return table.remove(self.values)
    end,
    BezierValues = function(self, t)
      return t:tbezier(self.values)
    end,
    CheckValues = function(self)
      return #self.values > 1
    end,
    Populate = function(self)
      assert(self:CheckValues(), 'at least two values must present')
      self.status = true
      do
        local _accum_0 = { }
        local _len_0 = 1
        for t = self.startpos, self.endpos, self.step do
          _accum_0[_len_0] = self:BezierValues(t)
          _len_0 = _len_0 + 1
        end
        self.populated = _accum_0
      end
      return self
    end,
    CopyValues = function(self)
      local _accum_0 = { }
      local _len_0 = 1
      local _list_0 = self.values
      for _index_0 = 1, #_list_0 do
        local val = _list_0[_index_0]
        _accum_0[_len_0] = val
        _len_0 = _len_0 + 1
      end
      return _accum_0
    end,
    GetValues = function(self)
      return self.values
    end,
    GetPopulatedValues = function(self)
      return self.populated
    end,
    CopyPopulatedValues = function(self)
      local _accum_0 = { }
      local _len_0 = 1
      local _list_0 = self.populated
      for _index_0 = 1, #_list_0 do
        local val = _list_0[_index_0]
        _accum_0[_len_0] = val
        _len_0 = _len_0 + 1
      end
      return _accum_0
    end,
    Lerp = function(self, t, a, b)
      return Lerp(t, a, b)
    end,
    GetValue = function(self, t)
      if t == nil then
        t = 0
      end
      assert(self.status, 'Not populated!')
      assert(type(t) == 'number', 'invalid T')
      t = t:clamp(0, 1) / self.step + self.startpos
      if self.populated[t] then
        return self.populated[t]
      end
      local t2 = t:ceil()
      local prevValue = self.populated[t2 - 1] or self.populated[1]
      local nextValue = self.populated[t2] or self.populated[2]
      return self:Lerp(t % 1, prevValue, nextValue)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, step, startpos, endpos)
      if step == nil then
        step = 0.05
      end
      if startpos == nil then
        startpos = 0
      end
      if endpos == nil then
        endpos = 1
      end
      self.values = { }
      self.step = step
      self.startpos = startpos
      self.endpos = endpos
      self.populated = { }
      self.status = false
    end,
    __base = _base_0,
    __name = "Number"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DLib.Bezier.Number = _class_0
end
local Vector, LerpVector
do
  local _obj_0 = _G
  Vector, LerpVector = _obj_0.Vector, _obj_0.LerpVector
end
do
  local _class_0
  local _parent_0 = DLib.Bezier.Number
  local _base_0 = {
    CheckValues = function(self)
      return #self.valuesX > 1
    end,
    GetValues = function(self)
      return self.valuesX, self.valuesY, self.valuesZ
    end,
    CopyValues = function(self)
      return (function()
        local _accum_0 = { }
        local _len_0 = 1
        local _list_0 = self.valuesX
        for _index_0 = 1, #_list_0 do
          local val = _list_0[_index_0]
          _accum_0[_len_0] = val
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)(), (function()
        local _accum_0 = { }
        local _len_0 = 1
        local _list_0 = self.valuesY
        for _index_0 = 1, #_list_0 do
          local val = _list_0[_index_0]
          _accum_0[_len_0] = val
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)(), (function()
        local _accum_0 = { }
        local _len_0 = 1
        local _list_0 = self.valuesZ
        for _index_0 = 1, #_list_0 do
          local val = _list_0[_index_0]
          _accum_0[_len_0] = val
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)()
    end,
    AddPoint = function(self, value)
      table.insert(self.valuesX, value.x)
      table.insert(self.valuesY, value.y)
      table.insert(self.valuesZ, value.z)
      return self
    end,
    BezierValues = function(self, t)
      return Vector(t:tbezier(self.valuesX), t:tbezier(self.valuesY), t:tbezier(self.valuesZ))
    end,
    Lerp = function(self, t, a, b)
      return LerpVector(t, a, b)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.valuesX = { }
      self.valuesY = { }
      self.valuesZ = { }
    end,
    __base = _base_0,
    __name = "Vector",
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
  DLib.Bezier.Vector = _class_0
end
local Angle, LerpAngle
do
  local _obj_0 = _G
  Angle, LerpAngle = _obj_0.Angle, _obj_0.LerpAngle
end
do
  local _class_0
  local _parent_0 = DLib.Bezier.Number
  local _base_0 = {
    CheckValues = function(self)
      return #self.valuesP > 1
    end,
    GetValues = function(self)
      return self.valuesP, self.valuesY, self.valuesR
    end,
    CopyValues = function(self)
      return (function()
        local _accum_0 = { }
        local _len_0 = 1
        local _list_0 = self.valuesP
        for _index_0 = 1, #_list_0 do
          local val = _list_0[_index_0]
          _accum_0[_len_0] = val
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)(), (function()
        local _accum_0 = { }
        local _len_0 = 1
        local _list_0 = self.valuesY
        for _index_0 = 1, #_list_0 do
          local val = _list_0[_index_0]
          _accum_0[_len_0] = val
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)(), (function()
        local _accum_0 = { }
        local _len_0 = 1
        local _list_0 = self.valuesR
        for _index_0 = 1, #_list_0 do
          local val = _list_0[_index_0]
          _accum_0[_len_0] = val
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)()
    end,
    AddPoint = function(self, value)
      table.insert(self.valuesP, value.p)
      table.insert(self.valuesY, value.y)
      table.insert(self.valuesR, value.r)
      return self
    end,
    BezierValues = function(self, t)
      return Angle(t:tbezier(self.valuesX), t:tbezier(self.valuesY), t:tbezier(self.valuesZ))
    end,
    Lerp = function(self, t, a, b)
      return LerpAngle(t, a, b)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.valuesP = { }
      self.valuesY = { }
      self.valuesR = { }
    end,
    __base = _base_0,
    __name = "Angle",
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
  DLib.Bezier.Angle = _class_0
  return _class_0
end
