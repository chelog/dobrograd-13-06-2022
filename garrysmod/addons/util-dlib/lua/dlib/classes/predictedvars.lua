local _OBJECTS = DLib.PredictedVarList and DLib.PredictedVarList._OBJECTS or { }
local plyMeta = FindMetaTable('Player')
local cl_showerror = GetConVar('cl_showerror')
do
  local _class_0
  local _base_0 = {
    GetByName = function(self, id)
      return self._OBJECTS[id]
    end,
    SetSyncTimer = function(self, stimer)
      if stimer == nil then
        stimer = self.sync_cooldown
      end
      if game.SinglePlayer() or self.smartSync then
        return 
      end
      self.sync_cooldown = assert(type(stimer) == 'number' and stimer >= 0, 'Time must be a positive number!')
      return timer.Create('DLib.PredictedVarList.Sync', self.sync_cooldown, 0, function()
        return ProtectedCall(self.sync_closure)
      end)
    end,
    Sync = function(self, ply)
      if CLIENT then
        error('Invalid realm')
      end
      net.Start(self._nw)
      ply.__dlib_predvars = ply.__dlib_predvars or { }
      ply.__dlib_predvars[self.netname] = ply.__dlib_predvars[self.netname] or { }
      net.WriteTable(ply.__dlib_predvars[self.netname])
      return net.Send(ply)
    end,
    GetFrame = function(self)
      return self.frame_id
    end,
    AddVar = function(self, identifier, def)
      self.vars[identifier] = def
      return self
    end,
    RegisterMeta = function(self, invalidateName, syncName)
      local self2 = self
      plyMeta[assert(invalidateName, 'Missing invalidate meta name')] = function(self, smart)
        if smart == nil then
          smart = false
        end
        return self2:Invalidate(self, smart)
      end
      plyMeta[assert(syncName, 'Missing sync meta name')] = function(self)
        return self2:Sync(self)
      end
      for name, def in pairs(self.vars) do
        plyMeta['Get' .. name] = function(self)
          return self2:Get(self, name)
        end
        plyMeta['Set' .. name] = function(self, ...)
          return self2:Set(self, name, ...)
        end
        plyMeta['Reset' .. name] = function(self)
          return self2:Reset(self, name)
        end
      end
      return self
    end,
    Invalidate = function(self, ply, smart)
      if smart == nil then
        smart = false
      end
      if SERVER then
        self.frame_id = self.frame_id + 1
        if not ply.__dlib_predvars then
          ply.__dlib_predvars = { }
        end
        if not ply.__dlib_predvars[self.netname] then
          ply.__dlib_predvars[self.netname] = { }
        end
        return 
      end
      if smart and self.lastInvalidate == FrameNumber() then
        return 
      end
      self.lastInvalidate = FrameNumber()
      if IsFirstTimePredicted() then
        self.firstF = true
        self.frame_id = self.frame_id + 1
        for key, value in pairs(self.first) do
          self.prev[key] = value
          self.cur[key] = nil
          self.first[key] = nil
        end
        return 
      end
      self.firstF = false
      for key in pairs(self.cur) do
        self.cur[key] = nil
      end
    end,
    Get = function(self, ply, identifier, def)
      if def == nil then
        def = self.vars[identifier]
      end
      if SERVER then
        if not ply.__dlib_predvars or not ply.__dlib_predvars[self.netname] then
          return def
        end
        local val = ply.__dlib_predvars[self.netname][identifier]
        if val ~= nil then
          return val
        end
        return def
      end
      assert(def ~= nil, 'Variable does not exist')
      if self.firstF then
        local val = self.first[identifier]
        if val ~= nil then
          return val
        end
        if self.prev[identifier] ~= nil then
          return self.prev[identifier]
        end
        return def
      end
      local val = self.cur[identifier]
      if val ~= nil then
        return val
      end
      if self.prev[identifier] ~= nil then
        return self.prev[identifier]
      end
      return def
    end,
    Set = function(self, ply, identifier, val)
      if SERVER then
        assert(assert(ply.__dlib_predvars, ':Invalidate() was never called with this player')[self.netname], ':Invalidate() was never called with this player')[identifier] = val
        if game.SinglePlayer() then
          self:Sync(ply)
        end
        return 
      end
      assert(self.vars[identifier] ~= nil, 'Variable does not exist')
      if self.firstF then
        self.first[identifier] = val
        return 
      end
      self.cur[identifier] = val
    end,
    Reset = function(self, ply, identifier)
      return self:Set(ply, identifier, self.vars[identifier])
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, netname, smartSync)
      if smartSync == nil then
        smartSync = false
      end
      self.netname = assert(netname, 'Missing network name')
      self.__class._OBJECTS[self.netname] = self
      self.vars = { }
      self.prev = { }
      self.cur = { }
      self.first = { }
      self.frame_id = 0
      self.firstF = true
      self.sync_cooldown = 60
      self.lastInvalidate = 0
      self.smartSync = smartSync
      self._nw = 'dlib_pred_' .. netname
      if SERVER then
        net.pool(self._nw)
        if not game.SinglePlayer() then
          if not smartSync then
            self.sync_closure = function()
              local _list_0 = player.GetAll()
              for _index_0 = 1, #_list_0 do
                local ply = _list_0[_index_0]
                if ply.__dlib_predvars and ply.__dlib_predvars[self.netname] then
                  self:Sync(ply)
                end
              end
            end
            return timer.Create('DLib.PredictedVarList.' .. netname, self.sync_cooldown, 0, function()
              return ProtectedCall(self.sync_closure)
            end)
          else
            self.sync_closure = function()
              local _list_0 = player.GetAll()
              for _index_0 = 1, #_list_0 do
                local ply = _list_0[_index_0]
                local score = ply:PacketLoss():pow(2) / 30 + ply:Ping() / 10
                ply['__dlib_psync_last_' .. netname] = (ply['__dlib_psync_last_' .. netname] or 400) - score
                if ply['__dlib_psync_last_' .. netname] <= 0 then
                  ply['__dlib_psync_last_' .. netname] = 400
                  self:Sync(ply)
                end
              end
            end
            return timer.Create('DLib.PredictedVarList.' .. netname, 1, 0, function()
              return ProtectedCall(self.sync_closure)
            end)
          end
        end
      else
        return net.receive(self._nw, function()
          local newR = net.ReadTable()
          if cl_showerror:GetInt() >= 2 then
            local num = 0
            for k, v in pairs(newR) do
              if v ~= self.prev[k] then
                num = num + 1
                local val = self.prev[k]
                if val == nil then
                  val = 'null'
                end
                DLib.Warning(string.format('%.3d %s:%s', num, netname, k), ' - variable differs (net: ', v, ' pred ', val, ')')
              end
            end
          end
          self.prev = newR
        end)
      end
    end,
    __base = _base_0,
    __name = "PredictedVarList"
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
  self._OBJECTS = _OBJECTS
  DLib.PredictedVarList = _class_0
  return _class_0
end
