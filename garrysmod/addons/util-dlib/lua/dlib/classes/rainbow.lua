local HUDCommons = HUDCommons
local rnd = util.SharedRandom
local Color = Color
local math = math
local sin = math.sin
local cos = math.cos
do
  local _class_0
  local _base_0 = {
    Randomize = function(self)
      self.pointer = 1
      do
        local _accum_0 = { }
        local _len_0 = 1
        for i = 1, self.iterations do
          _accum_0[_len_0] = Color(128 + rnd(self.seed, -128, 127, i * self.strength), 128 + rnd(self.seed, -128, 127, i * self.strength + self.move), 128 + rnd(self.seed, -128, 127, i * self.strength + self.move * 2))
          _len_0 = _len_0 + 1
        end
        self.values = _accum_0
      end
      return self
    end,
    Next = function(self)
      self.pointer = self.pointer + 1
      if #self.values < self.pointer then
        self.pointer = 1
      end
      return self.values[self.pointer]
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, seed, iterations, strength, move)
      if seed == nil then
        seed = 'DLib.RandomRainbow'
      end
      if iterations == nil then
        iterations = 8
      end
      if strength == nil then
        strength = 1
      end
      if move == nil then
        move = iterations * 2
      end
      self.seed = seed
      self.iterations = iterations
      self.strength = strength
      self.move = move
      self.values = { }
      self.pointer = 1
      return self:Randomize()
    end,
    __base = _base_0,
    __name = "RandomRainbow"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DLib.RandomRainbow = _class_0
end
do
  local _class_0
  local _base_0 = {
    Create = function(self)
      self.pointer = 1
      if self.forward then
        do
          local _accum_0 = { }
          local _len_0 = 1
          for i = 1, self.length do
            _accum_0[_len_0] = Color(128 * self.mult + cos(i * self.strength) * 127 * self.mult, 128 + cos(i * self.strength + self.move) * 127 * self.mult, 128 * self.mult + cos(i * self.strength + self.move * 2) * 127 * self.mult)
            _len_0 = _len_0 + 1
          end
          self.values = _accum_0
        end
      else
        do
          local _accum_0 = { }
          local _len_0 = 1
          for i = 1, self.length do
            _accum_0[_len_0] = Color(128 * self.mult + sin(i * self.strength) * 127 * self.mult, 128 + sin(i * self.strength + self.move) * 127 * self.mult, 128 * self.mult + sin(i * self.strength + self.move * 2) * 127 * self.mult)
            _len_0 = _len_0 + 1
          end
          self.values = _accum_0
        end
      end
      return self
    end,
    Next = function(self)
      self.pointer = self.pointer + 1
      if #self.values < self.pointer then
        self.pointer = 1
      end
      return self.values[self.pointer]
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, length, strength, move, forward, mult)
      if length == nil then
        length = 64
      end
      if strength == nil then
        strength = 0.2
      end
      if move == nil then
        move = 2
      end
      if forward == nil then
        forward = true
      end
      if mult == nil then
        mult = 1
      end
      self.mult = mult
      self.length = length
      self.strength = strength
      self.move = move
      self.forward = forward
      self.values = { }
      self.pointer = 1
      return self:Create()
    end,
    __base = _base_0,
    __name = "Rainbow"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DLib.Rainbow = _class_0
  return _class_0
end
