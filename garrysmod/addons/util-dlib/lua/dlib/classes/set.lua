local string_format = string.format
local type, pairs
do
  local _obj_0 = _G
  type, pairs = _obj_0.type, _obj_0.pairs
end
do
  local _class_0
  local _base_0 = {
    add = function(self, object)
      if object == nil then
        return false
      end
      for i, val in ipairs(self.values) do
        if val == object then
          return false
        end
      end
      table.insert(self.values, object)
      return true
    end,
    Add = function(self, ...)
      return self:add(...)
    end,
    AddArray = function(self, ...)
      return self:addArray(...)
    end,
    Has = function(self, ...)
      return self:has(...)
    end,
    Includes = function(self, ...)
      return self:has(...)
    end,
    Contains = function(self, ...)
      return self:has(...)
    end,
    Remove = function(self, ...)
      return self:remove(...)
    end,
    Delete = function(self, ...)
      return self:remove(...)
    end,
    UnSet = function(self, ...)
      return self:remove(...)
    end,
    GetValues = function(self, ...)
      return self:getValues()
    end,
    CopyValues = function(self, ...)
      local _accum_0 = { }
      local _len_0 = 1
      for val in ipairs(self.values) do
        _accum_0[_len_0] = val
        _len_0 = _len_0 + 1
      end
      return _accum_0
    end,
    addArray = function(self, objects)
      local _list_0 = objects
      for _index_0 = 1, #_list_0 do
        local object = _list_0[_index_0]
        self:add(object)
      end
    end,
    has = function(self, object)
      if object == nil then
        return false
      end
      for i, val in ipairs(self.values) do
        if val == object then
          return true
        end
      end
      return false
    end,
    includes = function(self, ...)
      return self:has(...)
    end,
    contains = function(self, ...)
      return self:has(...)
    end,
    remove = function(self, object)
      if object == nil then
        return false
      end
      for i, val in ipairs(self.values) do
        if val == object then
          table.remove(self.values, i)
          return true
        end
      end
      return false
    end,
    delete = function(self, ...)
      return self:remove(...)
    end,
    rm = function(self, ...)
      return self:remove(...)
    end,
    unset = function(self, ...)
      return self:remove(...)
    end,
    getValues = function(self)
      return self.values
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.values = { }
    end,
    __base = _base_0,
    __name = "Set"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DLib.Set = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.Set
  local _base_0 = {
    _hash = function(self, object)
      local tp = type(object)
      if tp == 'string' or tp == 'number' then
        return object
      else
        return string_format('%p', object)
      end
    end,
    add = function(self, object)
      if object == nil then
        return false
      end
      local p = self:_hash(object)
      if self.values[p] ~= nil then
        return false
      end
      self.values[p] = object
      return true, p
    end,
    has = function(self, object)
      if object == nil then
        return false
      end
      local p = self:_hash(object)
      return self.values[p] ~= nil
    end,
    remove = function(self, object)
      if object == nil then
        return false
      end
      local p = self:_hash(object)
      if self.values[p] == nil then
        return false
      end
      self.values[p] = nil
      return true, p
    end,
    getValues = function(self)
      local _accum_0 = { }
      local _len_0 = 1
      for i, val in pairs(self.values) do
        _accum_0[_len_0] = val
        _len_0 = _len_0 + 1
      end
      return _accum_0
    end,
    CopyValues = function(self)
      return self:getValues()
    end,
    copyHash = function(self)
      local _tbl_0 = { }
      for i, val in pairs(self.values) do
        _tbl_0[val] = val
      end
      return _tbl_0
    end,
    CopyHashTable = function(self)
      local _tbl_0 = { }
      for i, val in pairs(self.values) do
        _tbl_0[val] = val
      end
      return _tbl_0
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "HashSet",
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
  DLib.HashSet = _class_0
end
do
  local _class_0
  local _base_0 = {
    encode = function(self, val, indexFail)
      if indexFail == nil then
        indexFail = 1
      end
      if self.enumsInversed[val] == nil then
        return indexFail
      end
      return self.enumsInversed[val]
    end,
    Encode = function(self, ...)
      return self:encode(...)
    end,
    Decode = function(self, ...)
      return self:decode(...)
    end,
    Write = function(self, ...)
      return self:write(...)
    end,
    Read = function(self, ...)
      return self:read(...)
    end,
    decode = function(self, val, indexFail)
      if indexFail == nil then
        indexFail = 1
      end
      if type(val) ~= 'number' then
        val = tonumber(val)
      end
      if self.enums[val] == nil then
        return self.enums[indexFail]
      end
      return self.enums[val]
    end,
    write = function(self, val, ifNone)
      return net.WriteUInt(self:encode(val, ifNone), net.ChooseOptimalBits(#self.enums))
    end,
    read = function(self, ifNone)
      return self:decode(net.ReadUInt(net.ChooseOptimalBits(#self.enums)), ifNone)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, ...)
      self.enums = {
        ...
      }
      do
        local _tbl_0 = { }
        for i, v in ipairs(self.enums) do
          _tbl_0[v] = i
        end
        self.enumsInversed = _tbl_0
      end
    end,
    __base = _base_0,
    __name = "Enum"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DLib.Enum = _class_0
  return _class_0
end
