do
  local _class_0
  local _base_0 = {
    GetMins = function(self)
      return self.mins
    end,
    GetMaxs = function(self)
      return self.maxs
    end,
    SetMins = function(self, val)
      self.mins = val
    end,
    SetMaxs = function(self, val)
      self.maxs = val
    end,
    GetPos = function(self)
      return self.pos
    end,
    SetPos = function(self, val)
      self.pos = val
    end,
    GetAddition = function(self)
      return self.addition
    end,
    SetAddition = function(self, val)
      self.addition = val
    end,
    GetStrict = function(self)
      return self.strict
    end,
    GetStrictHeight = function(self)
      return self.sheight
    end,
    SetStrict = function(self, val)
      self.strict = val
    end,
    SetStrictHeight = function(self, val)
      self.sheight = val
    end,
    GetAABB = function(self)
      return self.mins, self.maxs
    end,
    GetSAABB = function(self)
      return self.smins, self.smaxs
    end,
    SetAABB = function(self, val1, val2)
      self.mins, self.maxs = val1, val2
    end,
    SetSAABB = function(self, val1, val2)
      self.smins, self.smaxs = val1, val2
    end,
    GetMask = function(self)
      return self.mask
    end,
    SetMask = function(self, val)
      self.mask = val
    end,
    GetMaskReachable = function(self)
      return self.maskReachable
    end,
    SetMaskReachable = function(self, val)
      self.maskReachable = val
    end,
    GetStep = function(self)
      return self.step
    end,
    GetRadius = function(self)
      return self.radius
    end,
    SetStep = function(self, val)
      self.step = val
    end,
    SetRadius = function(self, val)
      self.radius = val
    end,
    check = function(self, target)
      if self.usehull then
        local tr = util.TraceHull({
          start = self.pos,
          endpos = target + self.addition,
          mins = self.mins,
          maxs = self.maxs,
          mask = self.maskReachable,
          filter = self.filter:getValues()
        })
        if self.strict and not tr.Hit then
          local tr2 = util.TraceHull({
            start = target + self.addition,
            endpos = target + self.addition + Vector(0, 0, self.sheight),
            mins = self.smins,
            maxs = self.smaxs,
            mask = self.mask,
            filter = self.filter:getValues()
          })
          return not tr2.Hit, tr, tr2
        end
        return not tr.Hit, tr
      else
        local tr = util.TraceLine({
          start = self.pos,
          endpos = target + self.addition,
          mask = self.maskReachable,
          filter = self.filter:getValues()
        })
        if self.strict and not tr.Hit then
          local tr2 = util.TraceHull({
            start = target + self.addition,
            endpos = target + self.addition + Vector(0, 0, self.sheight),
            mins = self.smins,
            maxs = self.smaxs,
            mask = self.mask,
            filter = self.filter:getValues()
          })
          return not tr2.Hit, tr, tr2
        end
        return not tr.Hit, tr
      end
    end,
    Search = function(self)
      if self:check(self.pos) then
        return self.pos
      end
      for radius = 1, self.radius do
        for x = -radius, radius do
          local pos = self.pos + Vector(x * self.step, radius * self.step, 0)
          if self:check(pos) then
            return pos
          end
          pos = self.pos + Vector(x * self.step, -radius * self.step, 0)
          if self:check(pos) then
            return pos
          end
        end
        for y = -radius, radius do
          local pos = self.pos + Vector(radius * self.step, y * self.step, 0)
          if self:check(pos) then
            return pos
          end
          pos = self.pos + Vector(-radius * self.step, y * self.step, 0)
          if self:check(pos) then
            return pos
          end
        end
      end
      return false
    end,
    SearchOptimal = function(self)
      local validPositions = self:SearchAll()
      if #validPositions == 0 then
        return false
      end
      table.sort(validPositions, function(a, b)
        return a:DistToSqr(self.pos) < b:DistToSqr(self.pos)
      end)
      return validPositions[1]
    end,
    SearchAll = function(self)
      local output = { }
      if self:check(self.pos) then
        table.insert(output, self.pos)
      end
      for radius = 1, self.radius do
        for x = -radius, radius do
          local pos = self.pos + Vector(x * self.step, radius * self.step, 0)
          if self:check(pos) then
            table.insert(output, pos)
          end
          pos = self.pos + Vector(x * self.step, -radius * self.step, 0)
          if self:check(pos) then
            table.insert(output, pos)
          end
        end
        for y = -radius, radius do
          local pos = self.pos + Vector(radius * self.step, y * self.step, 0)
          if self:check(pos) then
            table.insert(output, pos)
          end
          pos = self.pos + Vector(-radius * self.step, y * self.step, 0)
          if self:check(pos) then
            table.insert(output, pos)
          end
        end
      end
      return output
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, posStart, step, radius)
      if posStart == nil then
        posStart = Vector(0, 0, 0)
      end
      if step == nil then
        step = 25
      end
      if radius == nil then
        radius = 10
      end
      self.pos = posStart
      self.mins = Vector(-4, -4, -4)
      self.maxs = Vector(4, 4, 4)
      self.step = step
      self.radius = radius
      self.addition = Vector(0, 0, 0)
      self.usehull = true
      self.filter = DLib.Set()
      self.mask = MASK_SOLID
      self.maskReachable = MASK_SOLID
      self.strict = false
      self.smins = Vector(-16, -16, 0)
      self.smaxs = Vector(16, 16, 0)
      self.sheight = 70
    end,
    __base = _base_0,
    __name = "Freespace"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DLib.Freespace = _class_0
  return _class_0
end
