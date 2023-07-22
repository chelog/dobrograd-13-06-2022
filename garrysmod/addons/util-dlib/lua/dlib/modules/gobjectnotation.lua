local DLib, type, luatype, istable, table, string, error
do
  local _obj_0 = _G
  DLib, type, luatype, istable, table, string, error = _obj_0.DLib, _obj_0.type, _obj_0.luatype, _obj_0.istable, _obj_0.table, _obj_0.string, _obj_0.error
end
DLib.GON = DLib.GON or { }
local GON = DLib.GON
GON.HashRegistry = GON.HashRegistry or { }
GON.Registry = GON.Registry or { }
GON.IdentityRegistry = GON.IdentityRegistry or { }
GON.FindProvider = function(identity)
  local provider = GON.IdentityRegistry[identity]
  return provider or false
end
GON.RemoveProvider = function(provider)
  local identity = provider:GetIdentity()
  local identify = provider:LuaTypeIdentify()
  GON.IdentityRegistry[identity] = nil
  if istable(identify) then
    for _index_0 = 1, #identify do
      local i = identify[_index_0]
      GON.HashRegistry[i] = nil
    end
  elseif isstring(identify) then
    GON.HashRegistry[identify] = nil
  end
  for i, provider2 in ipairs(GON.Registry) do
    if provider2:GetIdentity() == identity then
      GON.Registry[i] = nil
      return 
    end
  end
end
GON.RegisterProvider = function(provider)
  local identity = provider:GetIdentity()
  local identify = provider:LuaTypeIdentify()
  local should_put = provider:ShouldPutIntoMainRegistry()
  GON.IdentityRegistry[identity] = provider
  if istable(identify) then
    for _index_0 = 1, #identify do
      local i = identify[_index_0]
      GON.HashRegistry[i] = provider
    end
  elseif isstring(identify) then
    GON.HashRegistry[identify] = provider
  end
  if should_put then
    for i, provider2 in ipairs(GON.Registry) do
      if provider2:GetIdentity() == identity then
        GON.Registry[i] = provider
        return 
      end
    end
    table.insert(GON.Registry, provider)
  end
end
do
  local _class_0
  local _base_0 = {
    SetValue = function(self, value)
      self.value = value
      return self
    end,
    Serialize = function(self)
      return error('Not implemented')
    end,
    GetValue = function(self)
      return self.value
    end,
    GetStructure = function(self)
      return self.structure
    end,
    GetHeapID = function(self)
      return self.heapid
    end,
    GetIdentity = function(self)
      return self.__class:GetIdentity()
    end,
    IsKnownValue = function(self)
      return true
    end,
    GetRegistryID = function(self)
      return self._identity_id
    end,
    IsInstantValue = function(self)
      return true
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, structure, id)
      self.structure = structure
      self.heapid = id
    end,
    __base = _base_0,
    __name = "IDataProvider"
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
  self.LuaTypeIdentify = function(self)
    return self._IDENTIFY
  end
  self.ShouldPutIntoMainRegistry = function(self)
    return self:LuaTypeIdentify() == nil
  end
  self.GetIdentity = function(self)
    return error('Not implemented')
  end
  self.Ask = function(self, value, ltype)
    if ltype == nil then
      ltype = luatype(value)
    end
    local identify = self:LuaTypeIdentify()
    if istable(identify) == 'table' then
      return table.qhasValue(identify, ltype)
    else
      return ltype == identify
    end
  end
  self.Deserialize = function(self, bytesbuffer, structure, heapid, length)
    return error('Not implemented')
  end
  GON.IDataProvider = _class_0
end
do
  local _class_0
  local _base_0 = {
    GetHeapID = function(self)
      return self.heapid
    end,
    Length = function(self)
      return #self.data
    end,
    IsKnownValue = function(self)
      return false
    end,
    BinaryData = function(self)
      return self.data
    end,
    GetRegistryID = function(self)
      return self.registryid
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, structure, data, id, registryid)
      self.structure = structure
      self.data = data
      self.heapid = id
      self.registryid = registryid
    end,
    __base = _base_0,
    __name = "UnknownValue"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  GON.UnknownValue = _class_0
end
do
  local _class_0
  local _base_0 = {
    GetHeapValue = function(self, id)
      return self.heap[id]
    end,
    NextHeapIdentifier = function(self)
      local ret = self.nextid
      self.nextid = self.nextid + 1
      return ret
    end,
    FindInHeap = function(self, value)
      if self._heap then
        return self._heap[value] or false
      end
      local _list_0 = self.heap
      for _index_0 = 1, #_list_0 do
        local provider = _list_0[_index_0]
        if provider and provider:IsKnownValue() and provider:GetValue() == value then
          return provider
        end
      end
      return false
    end,
    GetIdentityID = function(self, identity)
      local _get = self._identity_registry[identity]
      if _get then
        return _get
      end
      _get = self.next_reg_id
      if _get >= 0x100 then
        error('Too many types in a single file! 255 is the maximum!')
      end
      self.identity_registry[_get] = identity
      self._identity_registry[identity] = _get
      self.next_reg_id = self.next_reg_id + 1
      return _get
    end,
    AddToHeap = function(self, value)
      do
        local provider = self:FindInHeap(value)
        if provider then
          return provider
        end
      end
      local ltype = luatype(value)
      local provider = GON.HashRegistry[ltype]
      if not provider then
        local _list_0 = GON.Registry
        for _index_0 = 1, #_list_0 do
          local prov = _list_0[_index_0]
          if prov:Ask(value, ltype) then
            provider = prov
            break
          end
        end
      end
      if not provider then
        return false, self.__class.ERROR_MISSING_PROVIDER
      end
      local identity = provider:GetIdentity()
      if not identity then
        return false, self.__class.ERROR_NO_IDENTIFIER
      end
      local iid = self:GetIdentityID(identity)
      local id = self:NextHeapIdentifier()
      local serialized = provider(self, id)
      serialized._identity_id = iid
      self.heap[id] = serialized
      if self._heap then
        self._heap[value] = serialized
      end
      if not self.root then
        self.root = serialized
      end
      serialized:SetValue(value)
      return serialized
    end,
    SetRoot = function(self, provider)
      if not istable(provider) or not provider.GetHeapID then
        error('Provider must be GON.IDataProvider! typeof ' .. luatype(provider))
      end
      if self.heap[provider:GetHeapID()] ~= provider then
        error('Given provider is not part of this structure heap')
      end
      self.root = provider
    end,
    IsHeapBig = function(self)
      return self.long_heap or #self.heap >= 0xFFFF
    end,
    WriteHeader = function(self, bytesbuffer)
      bytesbuffer:WriteBinary('\xF7\x7FDLib.GON\x00\x02')
      bytesbuffer:WriteUByte(self.next_reg_id - 1)
      for i = 0, self.next_reg_id - 1 do
        bytesbuffer:WriteString(self.identity_registry[i])
      end
    end,
    WriteHeap = function(self, bytesbuffer)
      bytesbuffer:WriteUInt32(#self.heap)
      local _list_0 = self.heap
      for _index_0 = 1, #_list_0 do
        local provider = _list_0[_index_0]
        bytesbuffer:WriteUByte(provider:GetRegistryID())
        if provider:IsKnownValue() then
          bytesbuffer:WriteUInt16(0)
          local pos = bytesbuffer:Tell()
          provider:Serialize(bytesbuffer)
          local pos2 = bytesbuffer:Tell()
          local len = pos2 - pos
          bytesbuffer:Move(-len - 2)
          bytesbuffer:WriteUInt16(len)
          bytesbuffer:Move(len)
        else
          bytesbuffer:WriteUInt16(provider:Length())
          bytesbuffer:WriteBinary(provider:BinaryData())
        end
      end
    end,
    WriteRoot = function(self, bytesbuffer)
      bytesbuffer:WriteUByte(self.root and 1 or 0)
      if self.root and self:IsHeapBig() then
        bytesbuffer:WriteUInt32(self.root:GetHeapID())
      end
      if self.root and not self:IsHeapBig() then
        return bytesbuffer:WriteUInt16(self.root:GetHeapID())
      end
    end,
    ReadHeader = function(self, bytesbuffer)
      local read = bytesbuffer:ReadBinary(12)
      self.long_heap = false
      if read == '\xF7\x7FDLib.GON\x00\x01' then
        self.identity_registry = { }
        self._identity_registry = { }
        self.next_reg_id = bytesbuffer:ReadUByte() + 1
        for i = 0, self.next_reg_id - 1 do
          read = bytesbuffer:ReadString()
          self.identity_registry[i] = read
          self._identity_registry[read] = i
        end
        self.long_heap = true
        return true
      elseif read == '\xF7\x7FDLib.GON\x00\x02' then
        self.identity_registry = { }
        self._identity_registry = { }
        self.next_reg_id = bytesbuffer:ReadUByte() + 1
        for i = 0, self.next_reg_id - 1 do
          read = bytesbuffer:ReadString()
          self.identity_registry[i] = read
          self._identity_registry[read] = i
        end
        return true
      end
      return false
    end,
    ReadHeap = function(self, bytesbuffer)
      self.heap = { }
      self.nextid = 1
      local amount = bytesbuffer:ReadUInt32()
      for i = 1, amount do
        local heapid = self.nextid
        self.nextid = self.nextid + 1
        local iid = bytesbuffer:ReadUByte()
        local regid = self.identity_registry[iid]
        local provider
        if regid then
          provider = GON.FindProvider(regid)
        end
        local len = bytesbuffer:ReadUInt16()
        if not provider then
          self.heap[heapid] = GON.UnknownValue(self, bytesbuffer:ReadBinary(len), heapid, iid)
        else
          local pos1 = bytesbuffer:Tell()
          local p = provider:Deserialize(bytesbuffer, self, heapid, len)
          self.heap[heapid] = p
          p._identity_id = iid
          if self._heap and p:IsInstantValue() then
            self._heap[p:GetValue()] = p
          end
          local pos2 = bytesbuffer:Tell()
          if (pos2 - pos1) ~= len then
            error('provider read more or less than required (' .. (pos2 - pos1) .. ' vs ' .. len .. ')')
          end
        end
      end
    end,
    ReadRoot = function(self, bytesbuffer)
      local has_root = bytesbuffer:ReadUByte() == 1
      if has_root then
        if self:IsHeapBig() then
          self.root = self.heap[bytesbuffer:ReadUInt32()]
        end
        if not self:IsHeapBig() then
          self.root = self.heap[bytesbuffer:ReadUInt16()]
        end
      else
        self.root = nil
      end
    end,
    WriteFile = function(self, bytesbuffer)
      self:WriteHeader(bytesbuffer)
      self:WriteHeap(bytesbuffer)
      self:WriteRoot(bytesbuffer)
      return bytesbuffer
    end,
    ReadFile = function(self, bytesbuffer)
      self:ReadHeader(bytesbuffer)
      self:ReadHeap(bytesbuffer)
      self:ReadRoot(bytesbuffer)
      return self
    end,
    CreateBuffer = function(self)
      local bytesbuffer = DLib.BytesBuffer()
      return self:WriteFile(bytesbuffer)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, lowmem)
      if lowmem == nil then
        lowmem = false
      end
      self.lowmem = lowmem
      self.nextid = 1
      self.heap = { }
      if not lowmem then
        self._heap = { }
      end
      self.next_reg_id = 0
      self.identity_registry = { }
      self._identity_registry = { }
      self.long_heap = false
    end,
    __base = _base_0,
    __name = "Structure"
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
  self.ERROR_MISSING_PROVIDER = 0
  self.ERROR_NO_IDENTIFIER = 1
  GON.Structure = _class_0
end
do
  local _class_0
  local _parent_0 = GON.IDataProvider
  local _base_0 = {
    Serialize = function(self, bytesbuffer)
      return bytesbuffer:WriteBinary(self.value)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "StringProvider",
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
  self._IDENTIFY = 'string'
  self.GetIdentity = function(self)
    return 'builtin:string'
  end
  self.Deserialize = function(self, bytesbuffer, structure, heapid, length)
    return GON.StringProvider(structure, heapid):SetValue(bytesbuffer:ReadBinary(length))
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  GON.StringProvider = _class_0
end
do
  local _class_0
  local _parent_0 = GON.IDataProvider
  local _base_0 = {
    Serialize = function(self, bytesbuffer)
      return bytesbuffer:WriteDouble(self.value)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "NumberProvider",
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
  self._IDENTIFY = 'number'
  self.GetIdentity = function(self)
    return 'builtin:number'
  end
  self.Deserialize = function(self, bytesbuffer, structure, heapid, length)
    return GON.NumberProvider(structure, heapid):SetValue(bytesbuffer:ReadDouble())
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  GON.NumberProvider = _class_0
end
do
  local _class_0
  local _parent_0 = GON.IDataProvider
  local _base_0 = {
    Serialize = function(self, bytesbuffer)
      return bytesbuffer:WriteUByte(self.value and 1 or 0)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "BooleanProvider",
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
  self._IDENTIFY = 'boolean'
  self.GetIdentity = function(self)
    return 'builtin:boolean'
  end
  self.Deserialize = function(self, bytesbuffer, structure, heapid, length)
    return GON.BooleanProvider(structure, heapid):SetValue(bytesbuffer:ReadUByte() == 1)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  GON.BooleanProvider = _class_0
end
do
  local _class_0
  local _parent_0 = GON.IDataProvider
  local _base_0 = {
    SetSerializedValue = function(self, value)
      self._serialized = value
      self.was_serialized = true
      self.value = nil
    end,
    IsInstantValue = function(self)
      return false
    end,
    Rehash = function(self, value, preserveUnknown)
      if value == nil then
        value = self.value
      end
      if preserveUnknown == nil then
        preserveUnknown = true
      end
      if self.value and self.structure._heap then
        self.structure._heap[self.value] = nil
      end
      self.value = value
      if self.structure._heap then
        self.structure._heap[value] = self
      end
      local copy = self._serialized
      self._serialized = { }
      if preserveUnknown then
        for key, value in pairs(copy) do
          local _key = self.structure:GetHeapValue(key)
          local _value = self.structure:GetHeapValue(value)
          if _key and _value and (not _key:IsKnownValue() or not _value:IsKnownValue()) then
            self._serialized[key] = value
          end
        end
      end
      for key, value in pairs(value) do
        local keyHeap = self.structure:AddToHeap(key)
        if keyHeap then
          local keyValue = self.structure:AddToHeap(value)
          if keyValue then
            self._serialized[keyHeap:GetHeapID()] = keyValue:GetHeapID()
          end
        end
      end
      return self
    end,
    SetValue = function(self, value)
      self:Rehash(value, false)
      self.was_serialized = false
    end,
    GetValue = function(self)
      if not self.was_serialized then
        return self.value
      end
      if self.value and self.structure._heap then
        self.structure._heap[self.value] = nil
      end
      self.value = { }
      if self.structure._heap then
        self.structure._heap[self.value] = self
      end
      self.was_serialized = false
      for key, value in pairs(self._serialized) do
        local _key = self.structure:GetHeapValue(key)
        local _value = self.structure:GetHeapValue(value)
        if _key and _value and _key:IsKnownValue() and _value:IsKnownValue() then
          self.value[_key:GetValue()] = _value:GetValue()
        end
      end
      return self.value
    end,
    Serialize = function(self, bytesbuffer)
      local long_heap = self.structure:IsHeapBig()
      for key, value in pairs(self._serialized) do
        if long_heap then
          bytesbuffer:WriteUInt32(key)
          bytesbuffer:WriteUInt32(value)
        else
          bytesbuffer:WriteUInt16(key)
          bytesbuffer:WriteUInt16(value)
        end
      end
      if long_heap then
        bytesbuffer:WriteUInt32(0)
      end
      if not long_heap then
        return bytesbuffer:WriteUInt16(0)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TableProvider",
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
  self._IDENTIFY = 'table'
  self.GetIdentity = function(self)
    return 'builtin:table'
  end
  self.Deserialize = function(self, bytesbuffer, structure, heapid, length)
    local long_heap = structure:IsHeapBig()
    local obj = GON.TableProvider(structure, heapid)
    local _serialized = { }
    if long_heap then
      while true do
        local readKey = bytesbuffer:ReadUInt32()
        if readKey == 0 then
          break
        end
        local readValue = bytesbuffer:ReadUInt32()
        if readValue == 0 then
          break
        end
        _serialized[readKey] = readValue
      end
    else
      while true do
        local readKey = bytesbuffer:ReadUInt16()
        if readKey == 0 then
          break
        end
        local readValue = bytesbuffer:ReadUInt16()
        if readValue == 0 then
          break
        end
        _serialized[readKey] = readValue
      end
    end
    obj:SetSerializedValue(_serialized)
    return obj
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  GON.TableProvider = _class_0
end
GON.RegisterProvider(GON.StringProvider)
GON.RegisterProvider(GON.NumberProvider)
GON.RegisterProvider(GON.BooleanProvider)
GON.RegisterProvider(GON.TableProvider)
do
  local _class_0
  local _parent_0 = GON.IDataProvider
  local _base_0 = {
    Serialize = function(self, bytesbuffer)
      bytesbuffer:WriteDouble(self.value.x)
      bytesbuffer:WriteDouble(self.value.y)
      return bytesbuffer:WriteDouble(self.value.z)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "VectorProvider",
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
  self._IDENTIFY = 'Vector'
  self.GetIdentity = function(self)
    return 'gmod:Vector'
  end
  self.Deserialize = function(self, bytesbuffer, structure, heapid, length)
    return GON.VectorProvider(structure, heapid):SetValue(Vector(bytesbuffer:ReadDouble(), bytesbuffer:ReadDouble(), bytesbuffer:ReadDouble()))
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  GON.VectorProvider = _class_0
end
do
  local _class_0
  local _parent_0 = GON.IDataProvider
  local _base_0 = {
    Serialize = function(self, bytesbuffer)
      bytesbuffer:WriteFloat(self.value.x)
      bytesbuffer:WriteFloat(self.value.y)
      return bytesbuffer:WriteFloat(self.value.z)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "AngleProvider",
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
  self._IDENTIFY = 'Angle'
  self.GetIdentity = function(self)
    return 'gmod:Angle'
  end
  self.Deserialize = function(self, bytesbuffer, structure, heapid, length)
    return GON.AngleProvider(structure, heapid):SetValue(Angle(bytesbuffer:ReadFloat(), bytesbuffer:ReadFloat(), bytesbuffer:ReadFloat()))
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  GON.AngleProvider = _class_0
end
do
  local _class_0
  local _parent_0 = GON.IDataProvider
  local _base_0 = {
    Serialize = function(self, bytesbuffer)
      bytesbuffer:WriteUByte(self.value.r)
      bytesbuffer:WriteUByte(self.value.g)
      bytesbuffer:WriteUByte(self.value.b)
      return bytesbuffer:WriteUByte(self.value.a)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "ColorProvider",
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
  self._IDENTIFY = 'Color'
  self.GetIdentity = function(self)
    return 'dlib:Color'
  end
  self.Deserialize = function(self, bytesbuffer, structure, heapid, length)
    return GON.ColorProvider(structure, heapid):SetValue(Color(bytesbuffer:ReadUByte(), bytesbuffer:ReadUByte(), bytesbuffer:ReadUByte(), bytesbuffer:ReadUByte()))
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  GON.ColorProvider = _class_0
end
GON.RegisterProvider(GON.VectorProvider)
GON.RegisterProvider(GON.AngleProvider)
GON.RegisterProvider(GON.ColorProvider)
local writeVector
writeVector = function(vec, bytesbuffer)
  bytesbuffer:WriteFloat(vec.x)
  bytesbuffer:WriteFloat(vec.y)
  return bytesbuffer:WriteFloat(vec.z)
end
local readVector
readVector = function(bytesbuffer)
  return Vector(bytesbuffer:ReadFloat(), bytesbuffer:ReadFloat(), bytesbuffer:ReadFloat())
end
do
  local _class_0
  local _parent_0 = GON.IDataProvider
  local _base_0 = {
    Serialize = function(self, bytesbuffer)
      return bytesbuffer:WriteString(self.value:GetName())
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "ConVarProvider",
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
  self._IDENTIFY = 'ConVar'
  self.GetIdentity = function(self)
    return 'gmod:ConVar'
  end
  self.Deserialize = function(self, bytesbuffer, structure, heapid, length)
    return GON.ConVarProvider(structure, heapid):SetValue(ConVar(bytesbuffer:ReadString()))
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  GON.ConVarProvider = _class_0
end
do
  local _class_0
  local _parent_0 = GON.IDataProvider
  local _base_0 = {
    Serialize = function(self, bytesbuffer)
      local tab = self.value:ToTable()
      for _index_0 = 1, #tab do
        local row = tab[_index_0]
        bytesbuffer:WriteDouble(row[1])
        bytesbuffer:WriteDouble(row[2])
        bytesbuffer:WriteDouble(row[3])
        bytesbuffer:WriteDouble(row[4])
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "VMatrixProvider",
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
  self._IDENTIFY = 'VMatrix'
  self.GetIdentity = function(self)
    return 'gmod:VMatrix'
  end
  self.Deserialize = function(self, bytesbuffer, structure, heapid, length)
    local tab = { }
    for i = 1, 4 do
      table.insert(tab, {
        bytesbuffer:ReadDouble(),
        bytesbuffer:ReadDouble(),
        bytesbuffer:ReadDouble(),
        bytesbuffer:ReadDouble()
      })
    end
    return GON.VMatrixProvider(structure, heapid):SetValue(Matrix(tab))
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  GON.VMatrixProvider = _class_0
end
do
  local _class_0
  local _parent_0 = GON.IDataProvider
  local _base_0 = {
    Serialize = function(self, bytesbuffer)
      return bytesbuffer:WriteString(self.value:GetName())
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "MaterialProvider",
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
  self._IDENTIFY = 'IMaterial'
  self.GetIdentity = function(self)
    return 'gmod:IMaterial'
  end
  self.Deserialize = function(self, bytesbuffer, structure, heapid, length)
    return GON.MaterialProvider(structure, heapid):SetValue(Material(bytesbuffer:ReadString()), nil)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  GON.MaterialProvider = _class_0
end
do
  local _class_0
  local _parent_0 = GON.IDataProvider
  local _base_0 = {
    Serialize = function(self, bytesbuffer)
      return self.__class:Write(self.value, bytesbuffer)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "CTakeDamageInfoProvider",
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
  self._IDENTIFY = {
    'CTakeDamageInfo',
    'LTakeDamageInfo'
  }
  self.GetIdentity = function(self)
    return 'dlib:LTakeDamageInfo'
  end
  self.Write = function(self, obj, bytesbuffer)
    do
      local _with_0 = bytesbuffer
      _with_0:WriteDouble(obj:GetDamage())
      _with_0:WriteDouble(obj:GetBaseDamage())
      _with_0:WriteDouble(obj:GetMaxDamage())
      _with_0:WriteDouble(obj:GetDamageBonus())
      _with_0:WriteUInt32(obj:GetDamageCustom())
      _with_0:WriteUInt32(obj:GetAmmoType())
      writeVector(obj:GetDamagePosition(), bytesbuffer)
      writeVector(obj:GetDamageForce(), bytesbuffer)
      writeVector(obj:GetReportedPosition(), bytesbuffer)
      _with_0:WriteUInt32(obj:GetDamageType())
      return _with_0
    end
  end
  self.Read = function(self, obj, bytesbuffer)
    do
      local _with_0 = bytesbuffer
      obj:SetDamage(_with_0:ReadDouble())
      obj:SetBaseDamage(_with_0:ReadDouble())
      obj:SetMaxDamage(_with_0:ReadDouble())
      obj:SetDamageBonus(_with_0:ReadDouble())
      obj:SetDamageCustom(_with_0:ReadUInt32())
      obj:SetAmmoType(_with_0:ReadUInt32())
      obj:SetDamagePosition(readVector(bytesbuffer))
      obj:SetDamageForce(readVector(bytesbuffer))
      obj:SetReportedPosition(readVector(bytesbuffer))
      obj:SetDamageType(_with_0:ReadUInt32())
      return _with_0
    end
  end
  self.Deserialize = function(self, bytesbuffer, structure, heapid, length)
    local obj = DLib.LTakeDamageInfo()
    self:Read(obj, bytesbuffer)
    return GON.CTakeDamageInfoProvider(structure, heapid):SetValue(obj)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  GON.CTakeDamageInfoProvider = _class_0
end
GON.RegisterProvider(GON.ConVarProvider)
GON.RegisterProvider(GON.VMatrixProvider)
GON.RegisterProvider(GON.MaterialProvider)
GON.RegisterProvider(GON.CTakeDamageInfoProvider)
GON.Serialize = function(value, toBuffer)
  if toBuffer == nil then
    toBuffer = true
  end
  local struct = GON.Structure()
  struct:AddToHeap(value)
  if not toBuffer then
    return struct
  end
  return struct:CreateBuffer()
end
GON.Deserialize = function(bufferIn, retreiveValue)
  if retreiveValue == nil then
    retreiveValue = true
  end
  local struct = GON.Structure()
  struct:ReadFile(bufferIn)
  if not retreiveValue then
    return struct
  end
  if not struct.root then
    return 
  end
  return struct.root:GetValue()
end
