file.mkdir('dlib/keybinds')
DLib.bind = DLib.bind or { }
local bind = DLib.bind
bind.KeyMap = {
  [KEY_FIRST] = 'FIRST',
  [KEY_NONE] = 'NONE',
  [KEY_0] = '0',
  [KEY_1] = '1',
  [KEY_2] = '2',
  [KEY_3] = '3',
  [KEY_4] = '4',
  [KEY_5] = '5',
  [KEY_6] = '6',
  [KEY_7] = '7',
  [KEY_8] = '8',
  [KEY_9] = '9',
  [KEY_A] = 'A',
  [KEY_B] = 'B',
  [KEY_C] = 'C',
  [KEY_D] = 'D',
  [KEY_E] = 'E',
  [KEY_F] = 'F',
  [KEY_G] = 'G',
  [KEY_H] = 'H',
  [KEY_I] = 'I',
  [KEY_J] = 'J',
  [KEY_K] = 'K',
  [KEY_L] = 'L',
  [KEY_M] = 'M',
  [KEY_N] = 'N',
  [KEY_O] = 'O',
  [KEY_P] = 'P',
  [KEY_Q] = 'Q',
  [KEY_R] = 'R',
  [KEY_S] = 'S',
  [KEY_T] = 'T',
  [KEY_U] = 'U',
  [KEY_V] = 'V',
  [KEY_W] = 'W',
  [KEY_X] = 'X',
  [KEY_Y] = 'Y',
  [KEY_Z] = 'Z',
  [KEY_PAD_0] = 'PAD_0',
  [KEY_PAD_1] = 'PAD_1',
  [KEY_PAD_2] = 'PAD_2',
  [KEY_PAD_3] = 'PAD_3',
  [KEY_PAD_4] = 'PAD_4',
  [KEY_PAD_5] = 'PAD_5',
  [KEY_PAD_6] = 'PAD_6',
  [KEY_PAD_7] = 'PAD_7',
  [KEY_PAD_8] = 'PAD_8',
  [KEY_PAD_9] = 'PAD_9',
  [KEY_PAD_DIVIDE] = 'PAD_DIVIDE',
  [KEY_PAD_MULTIPLY] = 'PAD_MULTIPLY',
  [KEY_PAD_MINUS] = 'PAD_MINUS',
  [KEY_PAD_PLUS] = 'PAD_PLUS',
  [KEY_PAD_ENTER] = 'PAD_ENTER',
  [KEY_PAD_DECIMAL] = 'PAD_DECIMAL',
  [KEY_LBRACKET] = 'LBRACKET',
  [KEY_RBRACKET] = 'RBRACKET',
  [KEY_SEMICOLON] = 'SEMICOLON',
  [KEY_APOSTROPHE] = 'APOSTROPHE',
  [KEY_BACKQUOTE] = 'BACKQUOTE',
  [KEY_COMMA] = 'COMMA',
  [KEY_PERIOD] = 'PERIOD',
  [KEY_SLASH] = 'SLASH',
  [KEY_BACKSLASH] = 'BACKSLASH',
  [KEY_MINUS] = 'MINUS',
  [KEY_EQUAL] = 'EQUAL',
  [KEY_ENTER] = 'ENTER',
  [KEY_SPACE] = 'SPACE',
  [KEY_BACKSPACE] = 'BACKSPACE',
  [KEY_TAB] = 'TAB',
  [KEY_CAPSLOCK] = 'CAPSLOCK',
  [KEY_NUMLOCK] = 'NUMLOCK',
  [KEY_ESCAPE] = 'ESCAPE',
  [KEY_SCROLLLOCK] = 'SCROLLLOCK',
  [KEY_INSERT] = 'INSERT',
  [KEY_DELETE] = 'DELETE',
  [KEY_HOME] = 'HOME',
  [KEY_END] = 'END',
  [KEY_PAGEUP] = 'PAGEUP',
  [KEY_PAGEDOWN] = 'PAGEDOWN',
  [KEY_BREAK] = 'BREAK',
  [KEY_LSHIFT] = 'LSHIFT',
  [KEY_RSHIFT] = 'RSHIFT',
  [KEY_LALT] = 'LALT',
  [KEY_RALT] = 'RALT',
  [KEY_LCONTROL] = 'LCONTROL',
  [KEY_RCONTROL] = 'RCONTROL',
  [KEY_LWIN] = 'LWIN',
  [KEY_RWIN] = 'RWIN',
  [KEY_APP] = 'APP',
  [KEY_UP] = 'UP',
  [KEY_LEFT] = 'LEFT',
  [KEY_DOWN] = 'DOWN',
  [KEY_RIGHT] = 'RIGHT',
  [KEY_F1] = 'F1',
  [KEY_F2] = 'F2',
  [KEY_F3] = 'F3',
  [KEY_F4] = 'F4',
  [KEY_F5] = 'F5',
  [KEY_F6] = 'F6',
  [KEY_F7] = 'F7',
  [KEY_F8] = 'F8',
  [KEY_F9] = 'F9',
  [KEY_F10] = 'F10',
  [KEY_F11] = 'F11',
  [KEY_F12] = 'F12',
  [KEY_CAPSLOCKTOGGLE] = 'CAPSLOCKTOGGLE',
  [KEY_NUMLOCKTOGGLE] = 'NUMLOCKTOGGLE',
  [KEY_LAST] = 'LAST',
  [KEY_SCROLLLOCKTOGGLE] = 'SCROLLLOCKTOGGLE',
  [KEY_COUNT] = 'COUNT',
  [KEY_XBUTTON_A] = 'XBUTTON_A',
  [KEY_XBUTTON_B] = 'XBUTTON_B',
  [KEY_XBUTTON_X] = 'XBUTTON_X',
  [KEY_XBUTTON_Y] = 'XBUTTON_Y',
  [KEY_XBUTTON_LEFT_SHOULDER] = 'XBUTTON_LEFT_SHOULDER',
  [KEY_XBUTTON_RIGHT_SHOULDER] = 'XBUTTON_RIGHT_SHOULDER',
  [KEY_XBUTTON_BACK] = 'XBUTTON_BACK',
  [KEY_XBUTTON_START] = 'XBUTTON_START',
  [KEY_XBUTTON_STICK1] = 'XBUTTON_STICK1',
  [KEY_XBUTTON_STICK2] = 'XBUTTON_STICK2',
  [KEY_XBUTTON_UP] = 'XBUTTON_UP',
  [KEY_XBUTTON_RIGHT] = 'XBUTTON_RIGHT',
  [KEY_XBUTTON_DOWN] = 'XBUTTON_DOWN',
  [KEY_XBUTTON_LEFT] = 'XBUTTON_LEFT',
  [KEY_XSTICK1_RIGHT] = 'XSTICK1_RIGHT',
  [KEY_XSTICK1_LEFT] = 'XSTICK1_LEFT',
  [KEY_XSTICK1_DOWN] = 'XSTICK1_DOWN',
  [KEY_XSTICK1_UP] = 'XSTICK1_UP',
  [KEY_XBUTTON_LTRIGGER] = 'XBUTTON_LTRIGGER',
  [KEY_XBUTTON_RTRIGGER] = 'XBUTTON_RTRIGGER',
  [KEY_XSTICK2_RIGHT] = 'XSTICK2_RIGHT',
  [KEY_XSTICK2_LEFT] = 'XSTICK2_LEFT',
  [KEY_XSTICK2_DOWN] = 'XSTICK2_DOWN',
  [KEY_XSTICK2_UP] = 'XSTICK2_UP'
}
bind.LocalizedButtons = {
  UP = 'UP Arrow',
  DOWN = 'DOWN Arrow',
  LEFT = 'LEFT Arrow',
  RIGHT = 'RIGHT Arrow'
}
local KEY_LIST
do
  local _accum_0 = { }
  local _len_0 = 1
  for key, str in pairs(bind.KeyMap) do
    _accum_0[_len_0] = key
    _len_0 = _len_0 + 1
  end
  KEY_LIST = _accum_0
end
do
  local _tbl_0 = { }
  for k, v in pairs(bind.KeyMap) do
    _tbl_0[v] = k
  end
  bind.KeyMapReverse = _tbl_0
end
bind.SerealizeKeys = function(keys)
  if keys == nil then
    keys = { }
  end
  local output
  do
    local _accum_0 = { }
    local _len_0 = 1
    for _index_0 = 1, #keys do
      local k = keys[_index_0]
      if bind.KeyMap[k] then
        _accum_0[_len_0] = bind.KeyMap[k]
        _len_0 = _len_0 + 1
      end
    end
    output = _accum_0
  end
  return output
end
bind.UnSerealizeKeys = function(keys)
  if keys == nil then
    keys = { }
  end
  local output
  do
    local _accum_0 = { }
    local _len_0 = 1
    for _index_0 = 1, #keys do
      local k = keys[_index_0]
      if bind.KeyMapReverse[k] then
        _accum_0[_len_0] = bind.KeyMapReverse[k]
        _len_0 = _len_0 + 1
      end
    end
    output = _accum_0
  end
  return output
end
do
  local _class_0
  local _base_0 = {
    Setup = function(self, binds)
      self.KeybindingsMap = binds
      for name, data in pairs(self.KeybindingsMap) do
        data.secondary = data.secondary or { }
        data.id = name
        data.name = data.name or '#BINDNAME?'
        data.desc = data.desc or '#BINDDESC?'
        data.order = data.order or 100
      end
      do
        local _accum_0 = { }
        local _len_0 = 1
        for name, data in pairs(self.KeybindingsMap) do
          _accum_0[_len_0] = data
          _len_0 = _len_0 + 1
        end
        self.KeybindingsOrdered = _accum_0
      end
      return table.sort(self.KeybindingsOrdered, function(a, b)
        return a.order < b.order
      end)
    end,
    RegisterBind = function(self, id, name, desc, primary, secondary, order)
      if name == nil then
        name = '#BINDNAME?'
      end
      if desc == nil then
        desc = '#BINDDESC?'
      end
      if primary == nil then
        primary = { }
      end
      if secondary == nil then
        secondary = { }
      end
      if order == nil then
        order = 100
      end
      if not id then
        error('No ID specified!')
      end
      self.KeybindingsMap[id] = {
        name = name,
        desc = desc,
        primary = primary,
        secondary = secondary,
        order = order,
        id = id
      }
      do
        local _accum_0 = { }
        local _len_0 = 1
        for name, data in pairs(self.KeybindingsMap) do
          _accum_0[_len_0] = data
          _len_0 = _len_0 + 1
        end
        self.KeybindingsOrdered = _accum_0
      end
      return table.sort(self.KeybindingsOrdered, function(a, b)
        return a.order < b.order
      end)
    end,
    GetDefaultBindings = function(self)
      local output
      do
        local _accum_0 = { }
        local _len_0 = 1
        for id, data in pairs(self.KeybindingsMap) do
          local primary = bind.SerealizeKeys(data.primary)
          local secondary = bind.SerealizeKeys(data.secondary)
          local _value_0 = {
            name = id,
            primary = primary,
            secondary = secondary
          }
          _accum_0[_len_0] = _value_0
          _len_0 = _len_0 + 1
        end
        output = _accum_0
      end
      return output
    end,
    UpdateKeysMap = function(self)
      local watchButtons
      do
        local _tbl_0 = { }
        local _list_0 = self.Keybindings
        for _index_0 = 1, #_list_0 do
          local data = _list_0[_index_0]
          local _list_1 = data.primary
          for _index_1 = 1, #_list_1 do
            local key = _list_1[_index_1]
            _tbl_0[key] = true
          end
        end
        watchButtons = _tbl_0
      end
      local _list_0 = self.Keybindings
      for _index_0 = 1, #_list_0 do
        local data = _list_0[_index_0]
        local _list_1 = data.secondary
        for _index_1 = 1, #_list_1 do
          local key = _list_1[_index_1]
          watchButtons[key] = true
        end
      end
      do
        local _tbl_0 = { }
        local _list_1 = self.Keybindings
        for _index_0 = 1, #_list_1 do
          local data = _list_1[_index_0]
          _tbl_0[data.name] = data
        end
        self.KeybindingsUserMap = _tbl_0
      end
      do
        local _tbl_0 = { }
        local _list_1 = self.Keybindings
        for _index_0 = 1, #_list_1 do
          local data = _list_1[_index_0]
          _tbl_0[data.name] = {
            name = data.name,
            primary = bind.UnSerealizeKeys(data.primary),
            secondary = bind.UnSerealizeKeys(data.secondary)
          }
        end
        self.KeybindingsUserMapCheck = _tbl_0
      end
      do
        local _accum_0 = { }
        local _len_0 = 1
        for key, bool in pairs(watchButtons) do
          _accum_0[_len_0] = bind.KeyMapReverse[key]
          _len_0 = _len_0 + 1
        end
        self.WatchingButtons = _accum_0
      end
      do
        local _tbl_0 = { }
        local _list_1 = self.WatchingButtons
        for _index_0 = 1, #_list_1 do
          local key = _list_1[_index_0]
          _tbl_0[key] = false
        end
        self.PressedButtons = _tbl_0
      end
      do
        local _tbl_0 = { }
        local _list_1 = self.WatchingButtons
        for _index_0 = 1, #_list_1 do
          local key = _list_1[_index_0]
          _tbl_0[key] = { }
        end
        self.WatchingButtonsPerBinding = _tbl_0
      end
      do
        local _tbl_0 = { }
        local _list_1 = self.Keybindings
        for _index_0 = 1, #_list_1 do
          local data = _list_1[_index_0]
          _tbl_0[data.name] = false
        end
        self.BindPressStatus = _tbl_0
      end
      local _list_1 = self.Keybindings
      for _index_0 = 1, #_list_1 do
        local _des_0 = _list_1[_index_0]
        local name, primary, secondary
        name, primary, secondary = _des_0.name, _des_0.primary, _des_0.secondary
        for _index_1 = 1, #primary do
          local key = primary[_index_1]
          table.insert(self.WatchingButtonsPerBinding[bind.KeyMapReverse[key]], name)
        end
        for _index_1 = 1, #secondary do
          local key = secondary[_index_1]
          table.insert(self.WatchingButtonsPerBinding[bind.KeyMapReverse[key]], name)
        end
      end
    end,
    SetKeyCombination = function(self, bindid, isPrimary, keys, update, doSave)
      if bindid == nil then
        bindid = ''
      end
      if isPrimary == nil then
        isPrimary = true
      end
      if keys == nil then
        keys = { }
      end
      if update == nil then
        update = true
      end
      if doSave == nil then
        doSave = true
      end
      if not self.KeybindingsMap[bindid] then
        return false
      end
      if not self.KeybindingsUserMap[bindid] then
        return false
      end
      if isPrimary then
        local _list_0 = self.Keybindings
        for _index_0 = 1, #_list_0 do
          local data = _list_0[_index_0]
          if data.name == bindid then
            data.primary = keys
            break
          end
        end
      else
        local _list_0 = self.Keybindings
        for _index_0 = 1, #_list_0 do
          local data = _list_0[_index_0]
          if data.name == bindid then
            data.secondary = keys
            break
          end
        end
      end
      if update then
        self:UpdateKeysMap()
      end
      if doSave then
        self:SaveKeybindings()
      end
      return true
    end,
    IsKeyDown = function(self, keyid)
      if keyid == nil then
        keyid = KEY_NONE
      end
      return self.PressedButtons[keyid] or false
    end,
    IsBindPressed = function(self, bindid)
      if bindid == nil then
        bindid = ''
      end
      if not self.KeybindingsMap[bindid] then
        return false
      end
      if not self.KeybindingsUserMap[bindid] then
        return false
      end
      return self.BindPressStatus[bindid] or false
    end,
    IsBindDown = IsBindPressed,
    InternalIsBindPressed = function(self, bindid)
      if bindid == nil then
        bindid = ''
      end
      if not self.KeybindingsMap[bindid] then
        return false
      end
      if not self.KeybindingsUserMapCheck[bindid] then
        return false
      end
      local data = self.KeybindingsUserMapCheck[bindid]
      local total = #data.primary
      local hits = 0
      local total2 = #data.secondary
      local hits2 = 0
      local _list_0 = data.primary
      for _index_0 = 1, #_list_0 do
        local key = _list_0[_index_0]
        if self:IsKeyDown(key) then
          hits = hits + 1
        end
      end
      local _list_1 = data.secondary
      for _index_0 = 1, #_list_1 do
        local key = _list_1[_index_0]
        if self:IsKeyDown(key) then
          hits2 = hits2 + 1
        end
      end
      return total ~= 0 and total == hits or total2 ~= 0 and total2 == hits2
    end,
    GetBindString = function(self, bindid)
      if bindid == nil then
        bindid = ''
      end
      if not self.KeybindingsMap[bindid] then
        return false
      end
      if not self.KeybindingsUserMap[bindid] then
        return false
      end
      local output
      local data = self.KeybindingsUserMap[bindid]
      if #data.primary ~= 0 then
        output = table.concat((function()
          local _accum_0 = { }
          local _len_0 = 1
          local _list_0 = data.primary
          for _index_0 = 1, #_list_0 do
            local key = _list_0[_index_0]
            _accum_0[_len_0] = bind.LocalizedButtons[key] or key
            _len_0 = _len_0 + 1
          end
          return _accum_0
        end)(), ' + ')
      end
      if #data.secondary ~= 0 then
        local tab
        do
          local _accum_0 = { }
          local _len_0 = 1
          local _list_0 = data.secondary
          for _index_0 = 1, #_list_0 do
            local key = _list_0[_index_0]
            _accum_0[_len_0] = bind.LocalizedButtons[key] or key
            _len_0 = _len_0 + 1
          end
          tab = _accum_0
        end
        if output then
          output = output .. (' or ' .. table.concat(tab, ' + '))
        end
        if not output then
          output = table.concat(tab, ' + ')
        end
      end
      return output or '<no key found>'
    end,
    SaveKeybindings = function(self)
      return file.Write(self.fpath, util.TableToJSON(self.Keybindings, true))
    end,
    LoadKeybindings = function(self)
      self.Keybindings = nil
      local settingsExists = file.Exists(self.fpath, 'DATA')
      if settingsExists then
        local read = file.Read(self.fpath, 'DATA')
        self.Keybindings = util.JSONToTable(read)
        if self.Keybindings then
          local defaultBinds = self:GetDefaultBindings()
          local valid = true
          local hits = { }
          local _list_0 = self.Keybindings
          for _index_0 = 1, #_list_0 do
            local data = _list_0[_index_0]
            if not data.primary then
              valid = false
              break
            end
            if not data.secondary then
              valid = false
              break
            end
            if not data.name then
              valid = false
              break
            end
            if type(data.primary) ~= 'table' then
              valid = false
              break
            end
            if type(data.secondary) ~= 'table' then
              valid = false
              break
            end
            if type(data.name) ~= 'string' then
              valid = false
              break
            end
            hits[data.name] = true
          end
          local shouldSave = false
          if valid then
            for _index_0 = 1, #defaultBinds do
              local data = defaultBinds[_index_0]
              if not hits[data.name] then
                table.insert(self.Keybindings, data)
                shouldSave = true
              end
            end
            self:UpdateKeysMap()
            if shouldSave then
              self:SaveKeybindings()
            end
          else
            self.Keybindings = nil
          end
        end
      end
      if not self.Keybindings then
        self.Keybindings = self:GetDefaultBindings()
        self:UpdateKeysMap()
        self:SaveKeybindings()
      end
      return self.Keybindings
    end,
    UpdateKeysStatus = function(self)
      if not self.WatchingButtons then
        return 
      end
      local _list_0 = self.WatchingButtons
      for _index_0 = 1, #_list_0 do
        local key = _list_0[_index_0]
        local oldStatus = self.PressedButtons[key]
        local newStatus = input.IsKeyDown(key)
        if oldStatus ~= newStatus then
          self.PressedButtons[key] = newStatus
          local watching = self.WatchingButtonsPerBinding[key]
          if watching then
            for _index_1 = 1, #watching do
              local name = watching[_index_1]
              local oldPressStatus = self.BindPressStatus[name]
              local newPressStatus = self:InternalIsBindPressed(name)
              if oldPressStatus ~= newPressStatus then
                self.BindPressStatus[name] = newPressStatus
                if not newPressStatus then
                  hook.Run(self.vname .. '.BindReleased', name)
                else
                  hook.Run(self.vname .. '.BindPressed', name)
                end
              end
            end
          end
        end
      end
    end,
    OpenKeybindsMenu = function(self)
      do
        local frame = vgui.Create('DFrame')
        frame:SetSkin('DLib_Black')
        frame:SetSize(470, ScrHL() - 200)
        frame:SetTitle(self.vname .. ' Keybinds')
        frame:Center()
        frame:MakePopup()
        frame:SetKeyboardInputEnabled(true)
        frame.scroll = vgui.Create('DScrollPanel', frame)
        frame.scroll:Dock(FILL)
        do
          local _accum_0 = { }
          local _len_0 = 1
          local _list_0 = self.KeybindingsOrdered
          for _index_0 = 1, #_list_0 do
            local _des_0 = _list_0[_index_0]
            local id
            id = _des_0.id
            do
              local _with_0 = vgui.Create('DLibBindRow', frame.scroll)
              _with_0:SetTarget(self)
              _with_0:SetBindID(id)
              _with_0:Dock(TOP)
              _accum_0[_len_0] = _with_0
            end
            _len_0 = _len_0 + 1
          end
          frame.rows = _accum_0
        end
        return frame
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, vname, binds, doLoad)
      if doLoad == nil then
        doLoad = true
      end
      if not vname then
        error('Name is required')
      end
      if not binds then
        error('Binds are required')
      end
      self.vname = vname
      self.fname = vname:lower()
      self.fpath = 'dlib/keybinds/' .. self.fname .. '.txt'
      self:Setup(binds)
      if doLoad then
        self:LoadKeybindings()
      end
      return hook.Add('Think', self.vname .. '.Keybinds', function()
        return self:UpdateKeysStatus()
      end)
    end,
    __base = _base_0,
    __name = "KeyBindsAdapter"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  bind.KeyBindsAdapter = _class_0
end
bind.PANEL_BIND_FIELD = {
  Init = function(self)
    self:SetSkin('DLib_Black')
    self.lastMousePress = 0
    self.lastMousePressRight = 0
    self.primary = true
    self.lock = false
    self.combination = { }
    self.combinationNew = { }
    self:SetMouseInputEnabled(true)
    self:SetTooltip('Double RIGHT mouse press to clear binding\nDouble LEFT mouse press to change binding\nWhen changing binding, press needed buttons WITHOUT releasing.\nRelease one of pressed buttons to save.\nTo cancel, press ESCAPE')
    self.combinationLabel = vgui.Create('DLabel', self)
    self.addColor = 0
    do
      local _with_0 = self.combinationLabel
      _with_0:Dock(FILL)
      _with_0:DockMargin(5, 0, 0, 0)
      _with_0:SetTextColor(color_white)
      _with_0:SetText('#COMBINATION?')
      return _with_0
    end
  end,
  SetCombinationLabel = function(self, keys)
    if keys == nil then
      keys = { }
    end
    local str = table.concat((function()
      local _accum_0 = { }
      local _len_0 = 1
      local _list_0 = bind.SerealizeKeys(keys)
      for _index_0 = 1, #_list_0 do
        local key = _list_0[_index_0]
        _accum_0[_len_0] = bind.LocalizedButtons[key] or key
        _len_0 = _len_0 + 1
      end
      return _accum_0
    end)(), ' + ')
    return self.combinationLabel:SetText(str)
  end,
  StopLock = function(self)
    self.lock = false
    self:SetCursor('none')
    if #self.combinationNew == 0 then
      self.combinationNew = self.combination
      return self:SetCombinationLabel(self.combination)
    else
      self:GetParent():OnCombinationUpdates(self, self.combinationNew)
      self.combination = keys
      return self:SetCombinationLabel(self.combinationNew)
    end
  end,
  OnMousePressed = function(self, code)
    if code == nil then
      code = MOUSE_LEFT
    end
    if code == MOUSE_LEFT then
      if self.lock then
        self:StopLock()
        return 
      end
      local prev = self.lastMousePress
      self.lastMousePress = RealTimeL() + 0.4
      if prev < RealTimeL() then
        return 
      end
      self.lock = true
      self.combinationNew = { }
      self.combinationLabel:SetText('???')
      self.mouseX, self.mouseY = self:LocalToScreen(5, 5)
      self:SetCursor('blank')
      do
        local _tbl_0 = { }
        for _index_0 = 1, #KEY_LIST do
          local key = KEY_LIST[_index_0]
          _tbl_0[key] = false
        end
        self.pressedKeys = _tbl_0
      end
    elseif code == MOUSE_RIGHT and not self.lock then
      local prev = self.lastMousePressRight
      self.lastMousePressRight = RealTimeL() + 0.4
      if prev < RealTimeL() then
        return 
      end
      self.combinationNew = { }
      self:GetParent():OnCombinationUpdates(self, self.combinationNew)
      self.combination = self.combinationNew
      return self:SetCombinationLabel(self.combination)
    end
  end,
  OnKeyCodePressed = function(self, code)
    if code == nil then
      code = KEY_NONE
    end
    if code == KEY_NONE or code == KEY_FIRST then
      return 
    end
    if not self.lock then
      return 
    end
    if code == KEY_ESCAPE then
      self.lock = false
      self.combinationNew = self.combination
      self:SetCombinationLabel(self.combination)
      self:SetCursor('none')
      return 
    elseif code == KEY_ENTER then
      self:StopLock()
      return 
    end
    table.insert(self.combinationNew, code)
    return self:SetCombinationLabel(self.combinationNew)
  end,
  OnKeyCodeReleased = function(self, code)
    if code == nil then
      code = KEY_NONE
    end
    if code == KEY_NONE or code == KEY_FIRST then
      return 
    end
    if self.lock then
      return self:StopLock()
    end
  end,
  Paint = function(self, w, h)
    if w == nil then
      w = 0
    end
    if h == nil then
      h = 0
    end
    surface.SetDrawColor(40 + 90 * self.addColor, 40 + 90 * self.addColor, 40)
    surface.DrawRect(0, 0, w, h)
    if self.lock then
      surface.SetDrawColor(137, 130, 104)
      return surface.DrawRect(4, 4, w - 8, h - 8)
    end
  end,
  Think = function(self)
    if self:IsHovered() then
      self.addColor = math.min(self.addColor + FrameTime() * 10, 1)
    else
      self.addColor = math.max(self.addColor - FrameTime() * 10, 0)
    end
    if self.lock then
      input.SetCursorPos(self.mouseX, self.mouseY)
      for _index_0 = 1, #KEY_LIST do
        local key = KEY_LIST[_index_0]
        local old = self.pressedKeys[key]
        local new = input.IsKeyDown(key)
        if old ~= new then
          self.pressedKeys[key] = new
          if new then
            self:OnKeyCodePressed(key)
          else
            self:OnKeyCodeReleased(key)
          end
        end
      end
    end
  end
}
bind.PANEL_BIND_INFO = {
  Init = function(self)
    self:SetSkin('DLib_Black')
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)
    self.bindid = ''
    self.label = vgui.Create('DLabel', self)
    self:SetSize(200, 30)
    do
      local _with_0 = self.label
      _with_0:SetText(' #HINT?')
      _with_0:Dock(LEFT)
      _with_0:DockMargin(10, 0, 0, 0)
      _with_0:SetSize(200, 0)
      _with_0:SetTooltip(' #DESCRIPTION?')
      _with_0:SetTextColor(color_white)
      _with_0:SetMouseInputEnabled(true)
    end
    self.primary = vgui.Create('DLibBindField', self)
    do
      local _with_0 = self.primary
      _with_0:Dock(LEFT)
      _with_0:DockMargin(10, 0, 0, 0)
      _with_0:SetSize(100, 0)
      _with_0.Primary = true
      _with_0.combination = { }
    end
    self.secondary = vgui.Create('DLibBindField', self)
    do
      local _with_0 = self.secondary
      _with_0:Dock(LEFT)
      _with_0:DockMargin(10, 0, 0, 0)
      _with_0:SetSize(100, 0)
      _with_0.Primary = false
      _with_0.combination = { }
      return _with_0
    end
  end,
  SetTarget = function(self, target)
    self.target = target
  end,
  SetBindID = function(self, id)
    if id == nil then
      id = ''
    end
    self.bindid = id
    local data = bind.KeybindingsUserMap[id]
    local dataLabels = bind.KeybindingsMap[id]
    if not data then
      return 
    end
    if not dataLabels then
      return 
    end
    do
      local _with_0 = self.label
      _with_0:SetText(dataLabels.name)
      _with_0:SetTooltip(dataLabels.desc)
    end
    do
      local _accum_0 = { }
      local _len_0 = 1
      local _list_0 = bind.UnSerealizeKeys(data.primary)
      for _index_0 = 1, #_list_0 do
        local key = _list_0[_index_0]
        _accum_0[_len_0] = key
        _len_0 = _len_0 + 1
      end
      self.primary.combination = _accum_0
    end
    do
      local _accum_0 = { }
      local _len_0 = 1
      local _list_0 = bind.UnSerealizeKeys(data.secondary)
      for _index_0 = 1, #_list_0 do
        local key = _list_0[_index_0]
        _accum_0[_len_0] = key
        _len_0 = _len_0 + 1
      end
      self.secondary.combination = _accum_0
    end
    self.primary:SetCombinationLabel(self.primary.combination)
    return self.secondary:SetCombinationLabel(self.secondary.combination)
  end,
  OnCombinationUpdates = function(self, pnl, newCombination)
    if newCombination == nil then
      newCombination = { }
    end
    if self.bindid == '' then
      return 
    end
    return self.target:SetKeyCombination(self.bindid, pnl.Primary, bind.SerealizeKeys(newCombination))
  end,
  Paint = function(self, w, h)
    if w == nil then
      w = 0
    end
    if h == nil then
      h = 0
    end
    surface.SetDrawColor(106, 122, 120)
    return surface.DrawRect(0, 0, w, h)
  end
}
vgui.Register('DLibBindField', bind.PANEL_BIND_FIELD, 'EditablePanel')
vgui.Register('DLibBindRow', bind.PANEL_BIND_INFO, 'EditablePanel')
bind.exportBinds = function(classIn, target)
  target.RegisterBind = function(...)
    return classIn:RegisterBind(...)
  end
  target.SerealizeKeys = function(...)
    return bind.SerealizeKeys(...)
  end
  target.UnSerealizeKeys = function(...)
    return bind.UnSerealizeKeys(...)
  end
  target.GetDefaultBindings = function(...)
    return classIn:GetDefaultBindings(...)
  end
  target.UpdateKeysMap = function(...)
    return classIn:UpdateKeysMap(...)
  end
  target.SetKeyCombination = function(...)
    return classIn:SetKeyCombination(...)
  end
  target.IsKeyDown = function(...)
    return classIn:IsKeyDown(...)
  end
  target.IsBindPressed = function(...)
    return classIn:IsBindPressed(...)
  end
  target.IsBindDown = function(...)
    return classIn:IsBindPressed(...)
  end
  target.InternalIsBindPressed = function(...)
    return classIn:InternalIsBindPressed(...)
  end
  target.GetBindString = function(...)
    return classIn:GetBindString(...)
  end
  target.SaveKeybindings = function(...)
    return classIn:SaveKeybindings(...)
  end
  target.LoadKeybindings = function(...)
    return classIn:LoadKeybindings(...)
  end
  target.UpdateKeysStatus = function(...)
    return classIn:UpdateKeysStatus(...)
  end
  target.OpenKeybindsMenu = function(...)
    return classIn:OpenKeybindsMenu(...)
  end
  target.LocalizedButtons = bind.LocalizedButtons
end
return bind
