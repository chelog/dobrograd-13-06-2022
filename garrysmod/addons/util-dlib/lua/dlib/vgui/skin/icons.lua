local DLib = DLib
local Color = Color
local table = table
DLib.skin.icons = { }
do
  local _accum_0 = { }
  local _len_0 = 1
  local _list_0 = {
    'blue',
    'green',
    'orange',
    'pink',
    'purple',
    'red',
    'yellow'
  }
  for _index_0 = 1, #_list_0 do
    local color = _list_0[_index_0]
    _accum_0[_len_0] = "icon16/flag_" .. tostring(color) .. ".png"
    _len_0 = _len_0 + 1
  end
  DLib.skin.icons.flags = _accum_0
end
do
  local _accum_0 = { }
  local _len_0 = 1
  local _list_0 = {
    'blue',
    'green',
    'orange',
    'pink',
    'purple',
    'red',
    'yellow'
  }
  for _index_0 = 1, #_list_0 do
    local color = _list_0[_index_0]
    _accum_0[_len_0] = "icon16/tag_" .. tostring(color) .. ".png"
    _len_0 = _len_0 + 1
  end
  DLib.skin.icons.tags = _accum_0
end
DLib.skin.icons.tag = DLib.skin.icons.tags
DLib.skin.icons.copy = DLib.skin.icons.tags
do
  local _accum_0 = { }
  local _len_0 = 1
  local _list_0 = {
    'bug',
    'bug_go',
    'bug_delete',
    'bug_error'
  }
  for _index_0 = 1, #_list_0 do
    local n = _list_0[_index_0]
    _accum_0[_len_0] = "icon16/" .. tostring(n) .. ".png"
    _len_0 = _len_0 + 1
  end
  DLib.skin.icons.bugs = _accum_0
end
DLib.skin.icons.url = {
  'icon16/link.png'
}
DLib.skin.icons.bug = DLib.skin.icons.bugs
DLib.skin.icons.user = 'icon16/user.png'
do
  local _tbl_0 = { }
  for key, value in pairs(DLib.skin.icons) do
    _tbl_0[key] = (function()
      return table.frandom(value)
    end)
  end
  DLib.skin.icon = _tbl_0
end
