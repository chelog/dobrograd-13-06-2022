local math
math = _G.math
local prefixes = {
  {
    'deci',
    10 ^ -1
  },
  {
    'centi',
    10 ^ -2
  },
  {
    'milli',
    10 ^ -3
  },
  {
    'micro',
    10 ^ -6
  },
  {
    'nano',
    10 ^ -9
  },
  {
    'deca',
    10
  },
  {
    'hecto',
    10 ^ 2
  },
  {
    'kilo',
    10 ^ 3
  },
  {
    'mega',
    10 ^ 6
  },
  {
    'giga',
    10 ^ 9
  },
  {
    'tera',
    10 ^ 12
  }
}
do
  local _class_0
  local _base_0 = {
    set = function(self, hammerUnits)
      self.hammer = hammerUnits
      self.metres = (hammerUnits * 19.05) / 1000
      for _index_0 = 1, #prefixes do
        local _des_0 = prefixes[_index_0]
        local prefix, size
        prefix, size = _des_0[1], _des_0[2]
        self[prefix .. 'metres'] = self.metres / size
      end
    end,
    GetMetres = function(self)
      return self.metres
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, hammerUnits)
      self.hammer = hammerUnits
      self.metres = (hammerUnits * 19.05) / 1000
      for _index_0 = 1, #prefixes do
        local _des_0 = prefixes[_index_0]
        local prefix, size
        prefix, size = _des_0[1], _des_0[2]
        self[prefix .. 'metres'] = self.metres / size
      end
    end,
    __base = _base_0,
    __name = "Measurment"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  for _index_0 = 1, #prefixes do
    local _des_0 = prefixes[_index_0]
    local prefix, size
    prefix, size = _des_0[1], _des_0[2]
    local valueOut = prefix .. 'metres'
    self.__base['Get' .. prefix:sub(1, 1):upper() .. prefix:sub(2) .. 'metres'] = function(self)
      return self[valueOut]
    end
    self.__base['Get' .. prefix:sub(1, 1):upper() .. prefix:sub(2) .. 'meters'] = function(self)
      return self[valueOut]
    end
  end
  DLib.Measurment = _class_0
end
do
  local _class_0
  local _base_0 = {
    set = function(self, hammerUnits)
      self.hammer = hammerUnits
      self.metres = (hammerUnits * 19.05) / 1000
    end,
    GetMetres = function(self)
      return self.metres
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, hammerUnits)
      self.hammer = hammerUnits
      self.metres = (hammerUnits * 19.05) / 1000
    end,
    __base = _base_0,
    __name = "MeasurmentNoCache"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  for _index_0 = 1, #prefixes do
    local _des_0 = prefixes[_index_0]
    local prefix, size
    prefix, size = _des_0[1], _des_0[2]
    local valueOut = prefix .. 'metres'
    self.__base['Get' .. prefix:sub(1, 1):upper() .. prefix:sub(2) .. 'metres'] = function(self)
      return self.metres / size
    end
    self.__base['Get' .. prefix:sub(1, 1):upper() .. prefix:sub(2) .. 'meters'] = function(self)
      return self.metres / size
    end
  end
  DLib.MeasurmentNoCache = _class_0
  return _class_0
end
