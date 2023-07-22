local assert, error, DLib, table
do
  local _obj_0 = _G
  assert, error, DLib, table = _obj_0.assert, _obj_0.error, _obj_0.DLib, _obj_0.table
end
local type = luatype
jit.on()
if DLib.NBT then
  for k, v in pairs(DLib.NBT) do
    DLib.NBT[k] = nil
  end
end
DLib.NBT = DLib.NBT or { }
local Typed = { }
local TypedByID = { }
local TypeID = {
  TAG_End = 0,
  TAG_Byte = 1,
  TAG_Short = 2,
  TAG_Int = 3,
  TAG_Long = 4,
  TAG_Float = 5,
  TAG_Double = 6,
  TAG_Byte_Array = 7,
  TAG_String = 8,
  TAG_List = 9,
  TAG_Compound = 10,
  TAG_Int_Array = 11,
  TAG_Long_Array = 12
}
do
  local _class_0
  local _base_0 = {
    GetDefault = function(self)
      return 0
    end,
    GetLength = function(self)
      return self.length
    end,
    CheckValue = function(self, value)
      return assert(type(value) ~= 'nil', 'value can not be nil')
    end,
    GetValue = function(self)
      return self.value
    end,
    SetValue = function(self, value)
      if value == nil then
        value = self.value
      end
      self:CheckValue(value)
      self.value = value
    end,
    Serialize = function(self, bytesbuffer)
      return error('Method not implemented')
    end,
    Deserialize = function(self, bytesbuffer)
      return error('Method not implemented')
    end,
    GetTagID = function(self)
      return self.__class.TAG_ID
    end,
    GetPayload = function(self)
      return self:GetLength()
    end,
    PayloadLength = function(self)
      return self:GetPayload()
    end,
    Varies = function(self)
      return false
    end,
    FixedPayloadLength = function(self)
      return self.__class.FIXED_LENGTH
    end,
    Name = function(self)
      return self.__class.NAME
    end,
    GetName = function(self)
      return self:Name()
    end,
    Nick = function(self)
      return self:Name()
    end,
    GetNick = function(self)
      return self:Name()
    end,
    GetType = function(self)
      return 'undefined'
    end,
    MetaName = 'NBTBase',
    IsBase = function(self)
      return self:Name() == 'TAG_Base'
    end,
    IsEnd = function(self)
      return self:Name() == 'TAG_End'
    end,
    IsByte = function(self)
      return self:Name() == 'TAG_Byte'
    end,
    IsShort = function(self)
      return self:Name() == 'TAG_Short'
    end,
    IsInt = function(self)
      return self:Name() == 'TAG_Int'
    end,
    IsLong = function(self)
      return self:Name() == 'TAG_Long'
    end,
    IsFloat = function(self)
      return self:Name() == 'TAG_Float'
    end,
    IsDouble = function(self)
      return self:Name() == 'TAG_Double'
    end,
    IsByteArray = function(self)
      return self:Name() == 'TAG_Byte_Array'
    end,
    IsString = function(self)
      return self:Name() == 'TAG_String'
    end,
    IsList = function(self)
      return self:Name() == 'TAG_List'
    end,
    IsTagCompound = function(self)
      return self:Name() == 'TAG_Compound'
    end,
    IsCompound = function(self)
      return self:Name() == 'TAG_Compound'
    end,
    IsIntArray = function(self)
      return self:Name() == 'TAG_Int_Array'
    end,
    IsLongArray = function(self)
      return self:Name() == 'TAG_Long_Array'
    end,
    __tostring = function(self)
      return self:Name() .. '[' .. self.__class.NAME .. '][' .. tostring(self.value) .. ']'
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, value)
      if value == nil then
        value = self:GetDefault()
      end
      if not self.length then
        self.length = 0
      end
      self.value = value
      if value ~= nil then
        return self:CheckValue(value)
      end
    end,
    __base = _base_0,
    __name = "Base"
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
  self.FIXED_LENGTH = -1
  self.NAME = 'TAG_Base'
  DLib.NBT.Base = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.NBT.Base
  local _base_0 = {
    Serialize = function(self, bytesbuffer)
      return self
    end,
    Deserialize = function(self, bytesbuffer)
      return self
    end,
    GetPayload = function(self)
      return 0
    end,
    FixedPayloadLength = function(self)
      return 0
    end,
    MetaName = 'NBTTagEnd',
    GetType = function(self)
      return 'end'
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TagEnd",
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
  local self = _class_0
  self.NAME = 'TAG_End'
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DLib.NBT.TagEnd = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.NBT.Base
  local _base_0 = {
    CheckValue = function(self, value)
      _class_0.__parent.__base.CheckValue(self, value)
      if type(value) ~= 'number' then
        error('Value must be a number! ' .. type(value) .. ' given.')
      end
      return assert(value >= -0x80 and value < 0x80, 'value overflow')
    end,
    Serialize = function(self, bytesbuffer)
      return bytesbuffer:WriteByte(self.value)
    end,
    Deserialize = function(self, bytesbuffer)
      self.value = bytesbuffer:ReadByte()
      return self
    end,
    GetPayload = function(self)
      return 1
    end,
    GetType = function(self)
      return 'byte'
    end,
    MetaName = 'NBTByte'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TagByte",
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
  local self = _class_0
  self.FIXED_LENGTH = 1
  self.NAME = 'TAG_Byte'
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DLib.NBT.TagByte = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.NBT.Base
  local _base_0 = {
    CheckValue = function(self, value)
      _class_0.__parent.__base.CheckValue(self, value)
      if type(value) ~= 'number' then
        error('Value must be a number! ' .. type(value) .. ' given.')
      end
      return assert(value >= -0x8000 and value < 0x8000, 'value overflow')
    end,
    Serialize = function(self, bytesbuffer)
      return bytesbuffer:WriteInt16(self.value)
    end,
    Deserialize = function(self, bytesbuffer)
      self.value = bytesbuffer:ReadInt16()
      return self
    end,
    GetPayload = function(self)
      return 2
    end,
    GetType = function(self)
      return 'short'
    end,
    MetaName = 'NBTShort'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TagShort",
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
  local self = _class_0
  self.FIXED_LENGTH = 2
  self.NAME = 'TAG_Short'
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DLib.NBT.TagShort = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.NBT.Base
  local _base_0 = {
    CheckValue = function(self, value)
      _class_0.__parent.__base.CheckValue(self, value)
      if type(value) ~= 'number' then
        error('Value must be a number! ' .. type(value) .. ' given.')
      end
      return assert(value >= -0x7FFFFFFF and value < 0x7FFFFFFF, 'value overflow')
    end,
    Serialize = function(self, bytesbuffer)
      return bytesbuffer:WriteInt32(self.value)
    end,
    Deserialize = function(self, bytesbuffer)
      self.value = bytesbuffer:ReadInt32()
      return self
    end,
    GetPayload = function(self)
      return 4
    end,
    GetType = function(self)
      return 'int'
    end,
    MetaName = 'NBTInt'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TagInt",
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
  local self = _class_0
  self.FIXED_LENGTH = 4
  self.NAME = 'TAG_Int'
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DLib.NBT.TagInt = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.NBT.Base
  local _base_0 = {
    CheckValue = function(self, value)
      _class_0.__parent.__base.CheckValue(self, value)
      if type(value) ~= 'number' then
        error('Value must be a number! ' .. type(value) .. ' given.')
      end
      return assert(value >= -9223372036854775808 and value < 9223372036854775808, 'value overflow')
    end,
    Serialize = function(self, bytesbuffer)
      return bytesbuffer:WriteInt64(self.value)
    end,
    Deserialize = function(self, bytesbuffer)
      self.value = bytesbuffer:ReadInt64()
      return self
    end,
    GetPayload = function(self)
      return 8
    end,
    GetType = function(self)
      return 'long'
    end,
    MetaName = 'NBTLong'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TagLong",
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
  local self = _class_0
  self.FIXED_LENGTH = 8
  self.NAME = 'TAG_Long'
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DLib.NBT.TagLong = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.NBT.Base
  local _base_0 = {
    CheckValue = function(self, value)
      _class_0.__parent.__base.CheckValue(self, value)
      if type(value) ~= 'number' then
        return error('Value must be a number! ' .. type(value) .. ' given.')
      end
    end,
    Serialize = function(self, bytesbuffer)
      return bytesbuffer:WriteFloat(self.value)
    end,
    Deserialize = function(self, bytesbuffer)
      self.value = bytesbuffer:ReadFloat()
      return self
    end,
    GetPayload = function(self)
      return 4
    end,
    GetType = function(self)
      return 'float'
    end,
    MetaName = 'NBTFloat'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TagFloat",
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
  local self = _class_0
  self.FIXED_LENGTH = 4
  self.NAME = 'TAG_Float'
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DLib.NBT.TagFloat = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.NBT.Base
  local _base_0 = {
    CheckValue = function(self, value)
      _class_0.__parent.__base.CheckValue(self, value)
      if type(value) ~= 'number' then
        return error('Value must be a number! ' .. type(value) .. ' given.')
      end
    end,
    Serialize = function(self, bytesbuffer)
      return bytesbuffer:WriteDouble(self.value)
    end,
    Deserialize = function(self, bytesbuffer)
      self.value = bytesbuffer:ReadDouble()
      return self
    end,
    GetPayload = function(self)
      return 8
    end,
    GetType = function(self)
      return 'double'
    end,
    MetaName = 'NBTDouble'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TagDouble",
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
  local self = _class_0
  self.FIXED_LENGTH = 8
  self.NAME = 'TAG_Double'
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DLib.NBT.TagDouble = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.NBT.Base
  local _base_0 = {
    CheckValue = function(self, value)
      return _class_0.__parent.__base.CheckValue(self, value) and assert(#value < 65536, 'String is too long!')
    end,
    Serialize = function(self, bytesbuffer)
      bytesbuffer:WriteUInt16(#self.value)
      return bytesbuffer:WriteBinary(self.value)
    end,
    Deserialize = function(self, bytesbuffer)
      self.length = bytesbuffer:ReadUInt16()
      self.value = bytesbuffer:ReadBinary(self.length)
      return self
    end,
    GetDefault = function(self)
      return ''
    end,
    GetLength = function(self)
      return #self.value
    end,
    GetPayload = function(self)
      return 2 + self:GetLength()
    end,
    GetType = function(self)
      return 'string'
    end,
    MetaName = 'NBTString'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TagString",
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
  local self = _class_0
  self.NAME = 'TAG_String'
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DLib.NBT.TagString = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.NBT.Base
  local _base_0 = {
    GetArray = function(self)
      return self.array
    end,
    ExtractValue = function(self, index)
      if index == nil then
        index = 1
      end
      return self.array[index]
    end,
    AtIndex = function(self, index)
      if index == nil then
        index = 1
      end
      return self.array[index]
    end,
    GetIndex = function(self, index)
      if index == nil then
        index = 1
      end
      return self.array[index]
    end,
    GetValue = function(self)
      local _accum_0 = { }
      local _len_0 = 1
      local _list_0 = self.array
      for _index_0 = 1, #_list_0 do
        local tag = _list_0[_index_0]
        _accum_0[_len_0] = tag:GetValue()
        _len_0 = _len_0 + 1
      end
      return _accum_0
    end,
    CopyArray = function(self)
      local _accum_0 = { }
      local _len_0 = 1
      local _list_0 = self.array
      for _index_0 = 1, #_list_0 do
        local tag = _list_0[_index_0]
        _accum_0[_len_0] = tag
        _len_0 = _len_0 + 1
      end
      return _accum_0
    end,
    iterate = function(self)
      return ipairs(self.array)
    end,
    iterator = function(self)
      return ipairs(self.array)
    end,
    pairs = function(self)
      return ipairs(self.array)
    end,
    ipairs = function(self)
      return ipairs(self.array)
    end,
    AddValue = function(self, value)
      return error('Method not implemented')
    end,
    SerializeLength = function(self, bytesbuffer, length)
      if length == nil then
        length = self.length
      end
      return bytesbuffer:WriteUInt32(length)
    end,
    DeserializeLength = function(self, bytesbuffer)
      return bytesbuffer:ReadUInt32()
    end,
    Serialize = function(self, bytesbuffer)
      self:SerializeLength(bytesbuffer, self.length)
      local _list_0 = self.array
      for _index_0 = 1, #_list_0 do
        local tag = _list_0[_index_0]
        tag:Serialize(bytesbuffer)
      end
      return self
    end,
    ReadTag = function(self, bytesbuffer)
      return error('No tag is specified as array type')
    end,
    Deserialize = function(self, bytesbuffer)
      self.length = self:DeserializeLength(bytesbuffer)
      do
        local _accum_0 = { }
        local _len_0 = 1
        for i = 1, self.length do
          _accum_0[_len_0] = self:ReadTag(bytesbuffer)
          _len_0 = _len_0 + 1
        end
        self.array = _accum_0
      end
      return self
    end,
    GetPayload = function(self)
      return self.length * self.__class.FIELD_LENGTH + self.RANGE
    end,
    GetType = function(self)
      return 'array_undefined'
    end,
    MetaName = 'NBTArray',
    __tostring = function(self)
      return self:Name() .. '[' .. self.__class.NAME .. '][' .. self.length .. ']{' .. tostring(self.array) .. '}'
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, values)
      _class_0.__parent.__init(self, 'array', -1)
      self.array = { }
      if values then
        local _list_0 = values
        for _index_0 = 1, #_list_0 do
          local value = _list_0[_index_0]
          self:AddValue(value)
        end
      end
    end,
    __base = _base_0,
    __name = "TagArrayBased",
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
  local self = _class_0
  self.FIELD_LENGTH = 1
  self.RANGE = 4
  self.NAME = 'TAG_Array'
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DLib.NBT.TagArrayBased = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.NBT.TagArrayBased
  local _base_0 = {
    AddValue = function(self, value)
      self.length = self.length + 1
      table.insert(self:GetArray(), DLib.NBT.TagByte(value))
      return self
    end,
    ReadTag = function(self, bytesbuffer)
      return DLib.NBT.TagByte():Deserialize(bytesbuffer)
    end,
    GetType = function(self)
      return 'array_bytes'
    end,
    MetaName = 'NBTArrayBytes'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TagByteArray",
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
  local self = _class_0
  self.FIELD_LENGTH = 1
  self.RANGE = 4
  self.NAME = 'TAG_Byte_Array'
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DLib.NBT.TagByteArray = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.NBT.TagArrayBased
  local _base_0 = {
    AddValue = function(self, value)
      self.length = self.length + 1
      table.insert(self:GetArray(), DLib.NBT.TagInt(value))
      return self
    end,
    ReadTag = function(self, bytesbuffer)
      return DLib.NBT.TagInt():Deserialize(bytesbuffer)
    end,
    GetType = function(self)
      return 'array_ints'
    end,
    MetaName = 'NBTArrayInt'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TagIntArray",
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
  local self = _class_0
  self.FIELD_LENGTH = 4
  self.RANGE = 4
  self.NAME = 'TAG_Int_Array'
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DLib.NBT.TagIntArray = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.NBT.TagArrayBased
  local _base_0 = {
    AddValue = function(self, value)
      self.length = self.length + 1
      table.insert(self:GetArray(), DLib.NBT.TagLong(value))
      return self
    end,
    ReadTag = function(self, bytesbuffer)
      return DLib.NBT.TagLong():Deserialize(bytesbuffer)
    end,
    GetType = function(self)
      return 'array_longs'
    end,
    MetaName = 'NBTArrayLong'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TagLongArray",
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
  local self = _class_0
  self.FIELD_LENGTH = 8
  self.RANGE = 4
  self.NAME = 'TAG_Long_Array'
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DLib.NBT.TagLongArray = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.NBT.TagArrayBased
  local _base_0 = {
    Serialize = function(self, bytesbuffer)
      bytesbuffer:WriteUByte(self.tagID)
      bytesbuffer:WriteUInt32(self.length)
      local _list_0 = self:GetArray()
      for _index_0 = 1, #_list_0 do
        local tag = _list_0[_index_0]
        tag:Serialize(bytesbuffer)
      end
      return self
    end,
    Deserialize = function(self, bytesbuffer)
      self.tagID = bytesbuffer:ReadUByte()
      self.tagClass = DLib.NBT.GetTyped(self.tagID)
      if not self.tagClass then
        error('Invalid tag ID specified as array type - ' .. self.tagID)
      end
      self.length = bytesbuffer:ReadUInt32()
      do
        local _accum_0 = { }
        local _len_0 = 1
        for i = 1, self.length do
          _accum_0[_len_0] = self:ReadTag(bytesbuffer)
          _len_0 = _len_0 + 1
        end
        self.array = _accum_0
      end
      return self
    end,
    AddValue = function(self, ...)
      self.length = self.length + 1
      local classIn = self.tagClass
      if not classIn then
        error('Invalid tag ID specified as array type - ' .. self.tagID)
      end
      if DLib.NBT.VALID_META[type(select(1, ...))] or type(select(1, ...)) == 'table' and select(1, ...).Serialize then
        table.insert(self:GetArray(), select(1, ...))
      else
        table.insert(self:GetArray(), classIn(...))
      end
      return self
    end,
    ReadTag = function(self, bytesbuffer)
      local classIn = self.tagClass
      return classIn():Deserialize(bytesbuffer)
    end,
    GetPayload = function(self)
      local output = 5
      local _list_0 = self:GetArray()
      for _index_0 = 1, #_list_0 do
        local tag = _list_0[_index_0]
        output = output + tag:GetPayload()
      end
      return output
    end,
    GetType = function(self)
      return 'array'
    end,
    MetaName = 'NBTList',
    __tostring = function(self)
      return self:Name() .. '[' .. self.__class.NAME .. '][' .. (DLib.NBT.TYPEID_F[self.tagClass.TAG_ID] or 'ERROR') .. '][' .. self.length .. ']{' .. tostring(self.array) .. '}'
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, tagID, values)
      if tagID == nil then
        tagID = 1
      end
      self.tagID = tagID
      self.tagClass = DLib.NBT.GetTyped(tagID)
      if not self.tagClass then
        error('Invalid tag ID specified as array type - ' .. tagID)
      end
      _class_0.__parent.__init(self, name)
      if values then
        for i, val in ipairs(values) do
          self:AddValue(val)
        end
      end
    end,
    __base = _base_0,
    __name = "TagList",
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
  local self = _class_0
  self.FIELD_LENGTH = -1
  self.RANGE = 4
  self.NAME = 'TAG_List'
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DLib.NBT.TagList = _class_0
end
do
  local _class_0
  local _parent_0 = DLib.NBT.Base
  local _base_0 = {
    GetTagName = function(self)
      return self.name
    end,
    TagName = function(self)
      return self:GetTagName()
    end,
    SetTagName = function(self, name)
      if name == nil then
        name = self.name
      end
      self.name = name
    end,
    ReadFile = function(self, bytesbuffer)
      local status = ProtectedCall(function()
        return self:ReadFileProtected(bytesbuffer)
      end)
      if not status then
        Error('Error reading a NBT file from Bytes Buffer! Is file/buffer a valid NBT file and is not corrupted?\n')
      end
      return status
    end,
    ReadFileProtected = function(self, bytesbuffer)
      assert(bytesbuffer:ReadUByte() == 10, 'Invalid header. Is file corrupted or not a valid NBT file?')
      local readNameLen = bytesbuffer:ReadUInt16()
      self:SetTagName(bytesbuffer:ReadBinary(readNameLen))
      return self:Deserialize(bytesbuffer)
    end,
    WriteFile = function(self, bytesbuffer)
      bytesbuffer:WriteUByte(self:GetTagID())
      bytesbuffer:WriteUInt16(#self:GetTagName())
      bytesbuffer:WriteBinary(self:GetTagName())
      return self:Serialize(bytesbuffer)
    end,
    Serialize = function(self, bytesbuffer)
      for key, tag in pairs(self.table) do
        bytesbuffer:WriteUByte(tag:GetTagID())
        bytesbuffer:WriteUInt16(#key)
        bytesbuffer:WriteBinary(key)
        tag:Serialize(bytesbuffer)
      end
      bytesbuffer:WriteUByte(0)
      return self
    end,
    Deserialize = function(self, bytesbuffer)
      while true do
        local readTagID = bytesbuffer:ReadUByte()
        if readTagID == 0 then
          break
        end
        local classIn = DLib.NBT.GetTyped(readTagID)
        local readIDLen = bytesbuffer:ReadUInt16()
        local readID = bytesbuffer:ReadBinary(readIDLen)
        local readTag
        if readTagID == TypeID.TAG_Compound then
          readTag = classIn(readID)
        else
          readTag = classIn()
        end
        readTag:Deserialize(bytesbuffer)
        self:AddTag(readID, readTag)
      end
      return self
    end,
    AddTag = function(self, key, value)
      if key == nil then
        key = ''
      end
      self.table[tostring(key)] = value
      if value.SetTagName then
        value:SetTagName(key)
      end
      return self
    end,
    SetTag = function(self, ...)
      return self:AddTag(...)
    end,
    SetTag2 = function(self, ...)
      return self:AddTag2(...)
    end,
    AddTag2 = function(self, key, value)
      if key == nil then
        key = ''
      end
      self:AddTag(key, value)
      return value
    end,
    RemoveTag = function(self, key)
      if key == nil then
        key = ''
      end
      self.table[tostring(key)] = nil
      return self
    end,
    __tostring = function(self)
      return self:Name() .. '[' .. self:GetTagName() .. '][?]{' .. tostring(self.table) .. '}'
    end,
    GetValue = function(self)
      local _tbl_0 = { }
      for key, tag in pairs(self.table) do
        _tbl_0[key] = tag:GetValue()
      end
      return _tbl_0
    end,
    iterate = function(self)
      return pairs(self.table)
    end,
    iterator = function(self)
      return pairs(self.table)
    end,
    pairs = function(self)
      return pairs(self.table)
    end,
    HasTag = function(self, key)
      if key == nil then
        key = ''
      end
      return self.table[tostring(key)] ~= nil
    end,
    GetTag = function(self, key)
      if key == nil then
        key = ''
      end
      return self.table[tostring(key)]
    end,
    GetTagValue = function(self, key)
      if key == nil then
        key = ''
      end
      return self.table[tostring(key)]:GetValue()
    end,
    AddByte = function(self, key, value)
      if key == nil then
        key = ''
      end
      return self:AddTag(key, DLib.NBT.TagByte(value))
    end,
    AddBool = function(self, key, value)
      if key == nil then
        key = ''
      end
      if value == nil then
        value = false
      end
      return self:AddTag(key, DLib.NBT.TagByte(value and 1 or 0))
    end,
    AddShort = function(self, key, value)
      if key == nil then
        key = ''
      end
      return self:AddTag(key, DLib.NBT.TagShort(value))
    end,
    AddInt = function(self, key, value)
      if key == nil then
        key = ''
      end
      return self:AddTag(key, DLib.NBT.TagInt(value))
    end,
    AddFloat = function(self, key, value)
      if key == nil then
        key = ''
      end
      return self:AddTag(key, DLib.NBT.TagFloat(value))
    end,
    AddDouble = function(self, key, value)
      if key == nil then
        key = ''
      end
      return self:AddTag(key, DLib.NBT.TagDouble(value))
    end,
    AddLong = function(self, key, value)
      if key == nil then
        key = ''
      end
      return self:AddTag(key, DLib.NBT.TagLong(value))
    end,
    AddString = function(self, key, value)
      if key == nil then
        key = ''
      end
      return self:AddTag(key, DLib.NBT.TagString(value))
    end,
    AddByteArray = function(self, key, values)
      if key == nil then
        key = ''
      end
      return self:AddTag2(key, DLib.NBT.TagByteArray(values))
    end,
    AddIntArray = function(self, key, values)
      if key == nil then
        key = ''
      end
      return self:AddTag2(key, DLib.NBT.TagIntArray(values))
    end,
    AddLongArray = function(self, key, values)
      if key == nil then
        key = ''
      end
      return self:AddTag2(key, DLib.NBT.TagLongArray(values))
    end,
    AddTagList = function(self, key, tagID, values)
      if key == nil then
        key = ''
      end
      return self:AddTag2(key, DLib.NBT.TagList(tagID, values))
    end,
    AddTagCompound = function(self, key, values)
      if key == nil then
        key = ''
      end
      return self:AddTag2(key, DLib.NBT.TagCompound(key, values))
    end,
    AddTypedValue = function(self, key, value)
      if key == nil then
        key = ''
      end
      local _exp_0 = type(value)
      if 'number' == _exp_0 then
        return self:AddDouble(key, value)
      elseif 'string' == _exp_0 then
        return self:AddString(key, value)
      elseif 'table' == _exp_0 then
        return self:AddTagCompound(key, vaue)
      else
        return error('Unable to tetermine tag type for value - ' .. type(value))
      end
    end,
    SetByte = function(self, ...)
      return self:AddByte(...)
    end,
    SetBool = function(self, ...)
      return self:AddBool(...)
    end,
    SetShort = function(self, ...)
      return self:AddShort(...)
    end,
    SetInt = function(self, ...)
      return self:AddInt(...)
    end,
    SetFloat = function(self, ...)
      return self:AddFloat(...)
    end,
    SetDouble = function(self, ...)
      return self:AddDouble(...)
    end,
    SetLong = function(self, ...)
      return self:AddLong(...)
    end,
    SetString = function(self, ...)
      return self:AddString(...)
    end,
    SetByteArray = function(self, ...)
      return self:AddByteArray(...)
    end,
    SetIntArray = function(self, ...)
      return self:AddIntArray(...)
    end,
    SetLongArray = function(self, ...)
      return self:AddLongArray(...)
    end,
    SetTagList = function(self, ...)
      return self:AddTagList(...)
    end,
    SetTagCompound = function(self, ...)
      return self:AddTagCompound(...)
    end,
    SetTypedValue = function(self, ...)
      return self:AddTypedValue(...)
    end,
    SetVector = function(self, key, vec)
      self:AddTagList(key, TypeID.TAG_Float, {
        vec.x,
        vec.y,
        vec.z
      })
      return self
    end,
    SetAngle = function(self, key, ang)
      self:AddTagList(key, TypeID.TAG_Float, {
        ang.p,
        ang.y,
        ang.r
      })
      return self
    end,
    SetColor = function(self, key, color)
      self:AddByteArray(key, {
        color.r - 128,
        color.g - 128,
        color.b - 128,
        color.a - 128
      })
      return self
    end,
    GetVector = function(self, key)
      local a, b, c
      do
        local _obj_0 = self:GetTagValue(key)
        a, b, c = _obj_0[1], _obj_0[2], _obj_0[3]
      end
      return Vector(a, b, c)
    end,
    GetAngle = function(self, key)
      local a, b, c
      do
        local _obj_0 = self:GetTagValue(key)
        a, b, c = _obj_0[1], _obj_0[2], _obj_0[3]
      end
      return Angle(a, b, c)
    end,
    GetColor = function(self, key)
      local a, b, c, d
      do
        local _obj_0 = self:GetTagValue(key)
        a, b, c, d = _obj_0[1], _obj_0[2], _obj_0[3], _obj_0[4]
      end
      return Color(a + 128, b + 128, c + 128, d + 128)
    end,
    GetLength = function(self)
      return table.Count(self.table)
    end,
    GetType = function(self)
      return 'table'
    end,
    MetaName = 'NBTCompound'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, name, values)
      if name == nil then
        name = 'data'
      end
      self.name = name
      self.table = { }
      _class_0.__parent.__init(self)
      if values then
        for key, value in pairs(values) do
          self:AddTypedValue(key, value)
        end
      end
    end,
    __base = _base_0,
    __name = "TagCompound",
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
  local self = _class_0
  self.NAME = 'TAG_Compound'
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DLib.NBT.TagCompound = _class_0
end
for k, classname in pairs(DLib.NBT) do
  if TypeID[classname.NAME] then
    Typed[TypeID[classname.NAME]] = classname
  end
end
for k, classname in pairs(DLib.NBT) do
  TypedByID[classname.NAME] = classname
end
do
  local _tbl_0 = { }
  for k, classname in pairs(DLib.NBT) do
    _tbl_0[classname.MetaName] = true
  end
  DLib.NBT.VALID_META = _tbl_0
end
for typeid, classname in pairs(Typed) do
  classname.TAG_ID = typeid
end
DLib.NBT.TYPEID = TypeID
do
  local _tbl_0 = { }
  for v, k in pairs(TypeID) do
    _tbl_0[k] = v
  end
  DLib.NBT.TYPEID_F = _tbl_0
end
DLib.NBT.TYPED = Typed
DLib.NBT.TYPED_BY_ID = TypedByID
DLib.NBT.GetTyped = function(index)
  if index == nil then
    index = 0
  end
  if not Typed[index] then
    error('invalid tag id specified - ' .. index)
  end
  return Typed[index]
end
DLib.NBT.GetTypedID = function(id)
  if id == nil then
    id = 'TAG_Byte'
  end
  if not TypedByID[id] then
    error('invalid tag string id specified - ' .. index)
  end
  return TypedByID[id]
end
