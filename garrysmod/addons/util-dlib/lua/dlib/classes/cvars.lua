local messaging = { }
DLib.MessageMaker(messaging, 'DLib/Message')
do
  local _class_0
  local _base_0 = {
    create = function(self, name, defvalue, flags, desc)
      if defvalue == nil then
        defvalue = '0'
      end
      if flags == nil then
        flags = 0
      end
      if desc == nil then
        desc = ''
      end
      if name == 'set' then
        error('_set is reserved')
      end
      flags = DLib.util.composeEnums(flags, FCVAR_ARCHIVE, FCVAR_REPLICATED)
      self.convars[name] = CreateConVar('sv_' .. self.namespace .. '_' .. name, defvalue, flags, desc)
      self.help[name] = desc
      self.defaults[name] = defvalue
      return self.convars[name]
    end,
    set = function(self, name, ...)
      if not self.convars[name] then
        return false
      end
      if CLIENT then
        RunConsoleCommand(self.setname, name, ...)
      else
        RunConsoleCommand('sv_' .. self.namespace .. '_' .. name, ...)
      end
      return true
    end,
    get = function(self, name)
      return self.convars[name]
    end,
    clickfunc = function(self, name)
      return function(pnl, newVal)
        if type(newVal) == 'boolean' then
          return self:set(name, newVal and '1' or '0')
        else
          return self:set(name, newVal)
        end
      end
    end,
    checkbox = function(self, pnlTarget, name)
      do
        local _with_0 = pnlTarget:CheckBox(self.help[name], 'sv_' .. self.namespace .. '_' .. name)
        local cvar = self.convars[name]
        _with_0.Button.Think = function()
          return _with_0:SetChecked(self:getBool(name))
        end
        _with_0.Button.DoClick = function()
          return self:set(name, not cvar:GetBool() and '1' or '0')
        end
        return _with_0
      end
    end,
    checkboxes = function(self, pnlTarget)
      local output
      do
        local _accum_0 = { }
        local _len_0 = 1
        for name, cvar in pairs(self.convars) do
          _accum_0[_len_0] = self:checkbox(pnlTarget, name)
          _len_0 = _len_0 + 1
        end
        output = _accum_0
      end
      return output
    end,
    getBool = function(self, name, ifFail)
      if ifFail == nil then
        ifFail = false
      end
      if not self.convars[name] then
        return ifFail
      end
      return self.convars[name].GetBool(self.convars[name], ifFail)
    end,
    getInt = function(self, name, ifFail)
      if ifFail == nil then
        ifFail = 0
      end
      if not self.convars[name] then
        return ifFail
      end
      return self.convars[name].GetInt(self.convars[name], ifFail)
    end,
    getFloat = function(self, name, ifFail)
      if ifFail == nil then
        ifFail = 0
      end
      if not self.convars[name] then
        return ifFail
      end
      return self.convars[name].GetFloat(self.convars[name], ifFail)
    end,
    getString = function(self, name)
      if not self.convars[name] then
        return ''
      end
      return self.convars[name].GetString(self.convars[name])
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, namespace)
      if not namespace then
        error('No namespace!')
      end
      self.namespace = namespace
      self.convars = { }
      self.help = { }
      self.defaults = { }
      self.setname = self.namespace .. '_set'
      self.cami = false
      if SERVER then
        return concommand.Add(self.setname, function(ply, cmd, args)
          local name = args[1] or ''
          name = name:Trim()
          if IsValid(ply) and not ply:IsSuperAdmin() then
            return messaging.MessagePlayer(ply, 'No access!')
          end
          if not self.convars[name] then
            return messaging.MessagePlayer(ply, 'Invalid Console Variable - sv_' .. self.namespace .. '_' .. name)
          end
          if not args[2] then
            return messaging.MessagePlayer(ply, 'Value is missing')
          end
          table.remove(args, 1)
          local newval = table.concat(args, ' ')
          self:set(name, newval)
          return messaging.Message(ply, ' has changed sv_' .. self.namespace .. '_' .. name .. ' to ', newval)
        end)
      end
    end,
    __base = _base_0,
    __name = "Convars"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DLib.Convars = _class_0
  return _class_0
end
