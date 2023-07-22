local CAMI = CAMI
local DLib = DLib
local CLIENT = CLIENT
local SERVER = SERVER
local LocalPlayer = LocalPlayer
local pairs = pairs
local ipairs = ipairs
local IsValid = IsValid
local player = player
local timer = timer
local table = table
do
  local _class_0
  local _base_0 = {
    Track = function(self, ...)
      self.tracked:addArray({
        ...
      })
      self:TriggerUpdate()
      return self
    end,
    HasPermission = function(self, ply, perm)
      if CLIENT and type(ply) == 'string' then
        perm = ply
        return self.trackedReplies[perm]
      else
        return self.trackedRepliesPly[ply] and self.trackedRepliesPly[ply][perm]
      end
    end,
    HandlePanel = function(self, perm, pnl)
      if SERVER then
        return 
      end
      self.trackedPanels[perm] = self.trackedPanels[perm] or { }
      table.insert(self.trackedPanels[perm], pnl)
      return self
    end,
    TriggerUpdate = function(self)
      if CLIENT then
        self:TriggerUpdateClient()
      end
      return self:TriggerUpdateRegular()
    end,
    TriggerUpdateClient = function(self)
      local ply = LocalPlayer()
      if not ply:IsValid() or not ply.UniqueID then
        return 
      end
      local _list_0 = self.tracked.values
      for _index_0 = 1, #_list_0 do
        local perm = _list_0[_index_0]
        local status = ProtectedCall(function()
          return CAMI.PlayerHasAccess(ply, perm, function(has, reason)
            if has == nil then
              has = false
            end
            if reason == nil then
              reason = ''
            end
            local old = self.trackedReplies[perm]
            self.trackedReplies[perm] = has
            if old ~= has and self.trackedPanels[perm] then
              local cleanup = { }
              for k, v in ipairs(self.trackedPanels[perm]) do
                if IsValid(v) then
                  v:SetEnabled(has)
                else
                  table.insert(cleanup, k)
                end
              end
              return table.removeValues(self.trackedPanels[perm], cleanup)
            end
          end)
        end)
        if not status then
          DLib.MessageError('Error while getting permissions for ' .. self.idetifier .. '! Tell Admin mod (if problem is on its side)/Author of addon which use CAMIWatchdog')
          DLib.MessageError('Permission in question: ' .. perm)
        end
      end
    end,
    TriggerUpdateRegular = function(self)
      do
        local _tbl_0 = { }
        for ply, data in pairs(self.trackedRepliesPly) do
          if ply:IsValid() then
            _tbl_0[ply] = data
          end
        end
        self.trackedRepliesPly = _tbl_0
      end
      local _list_0 = player.GetAll()
      for _index_0 = 1, #_list_0 do
        local ply = _list_0[_index_0]
        self.trackedRepliesPly[ply] = self.trackedRepliesPly[ply] or { }
        local _list_1 = self.tracked.values
        for _index_1 = 1, #_list_1 do
          local perm = _list_1[_index_1]
          local status = ProtectedCall(function()
            return CAMI.PlayerHasAccess(ply, perm, function(has, reason)
              if has == nil then
                has = false
              end
              if reason == nil then
                reason = ''
              end
              if IsValid(ply) then
                self.trackedRepliesPly[ply][perm] = has
              end
            end)
          end)
          if not status then
            DLib.Message('Error while getting permissions for ' .. self.idetifier .. '! Tell Admin mod (if problem is on its side)/Author of addon which use CAMIWatchdog')
            DLib.Message('Permission in question: ' .. perm)
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, idetifier, repeatSpeed, ...)
      if repeatSpeed == nil then
        repeatSpeed = 10
      end
      if not idetifier then
        error('No idetifier!')
      end
      self.repeatSpeed = repeatSpeed
      self.idetifier = idetifier
      self.tracked = DLib.Set()
      if CLIENT then
        self.trackedReplies = { }
      end
      if CLIENT then
        self.trackedPanels = { }
      end
      self.trackedRepliesPly = { }
      self:Track(...)
      timer.Create('DLib.CAMIWatchdog.' .. self.idetifier, repeatSpeed, 0, function()
        return self:TriggerUpdate()
      end)
      return self:TriggerUpdate()
    end,
    __base = _base_0,
    __name = "CAMIWatchdog"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DLib.CAMIWatchdog = _class_0
  return _class_0
end
