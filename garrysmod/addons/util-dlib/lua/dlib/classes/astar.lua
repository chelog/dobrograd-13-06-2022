local NAV_LOOPS_PER_FRAME = CreateConVar('sv_dlib_nav_loops_per_frame', '50', {
  FCVAR_ARCHIVE,
  FCVAR_NOTIFY
}, 'A* Searcher iterations per frame')
local NAV_OPEN_LIMIT = CreateConVar('sv_dlib_nav_open_limit', '700', {
  FCVAR_REPLICATED,
  FCVAR_ARCHIVE,
  FCVAR_NOTIFY
}, 'A* Searcher "open" nodes limit (at same time)')
local NAV_LIMIT = CreateConVar('sv_dlib_nav_limit', '4000', {
  FCVAR_REPLICATED,
  FCVAR_ARCHIVE,
  FCVAR_NOTIFY
}, 'A* Searcher total iterations limit')
local FRAME_THERSOLD = CreateConVar('sv_dlib_nav_frame_limit', '5', {
  FCVAR_ARCHIVE,
  FCVAR_NOTIFY
}, 'A* Searcher time limit (in milliseconds) per calculation per frame')
local TIME_LIMIT = CreateConVar('sv_dlib_nav_time_limit', '2500', {
  FCVAR_REPLICATED,
  FCVAR_ARCHIVE,
  FCVAR_NOTIFY
}, 'A* Searcher total time limit (in milliseconds) per one search')
local AStarNode
do
  local _class_0
  local _base_0 = {
    SetG = function(self, val)
      if val == nil then
        val = 0
      end
      self.g = val
      self.f = self.g + self.h
    end,
    SetH = function(self, val)
      if val == nil then
        val = 0
      end
      self.h = val
      self.f = self.g + self.h
    end,
    SetFrom = function(self, val)
      self.from = val
    end,
    __tostring = function(self)
      return "[DLib:AStarNode:" .. tostring(self.nav) .. "]"
    end,
    GetG = function(self)
      return self.g
    end,
    GetH = function(self)
      return self.h
    end,
    GetF = function(self)
      return self.f
    end,
    GetPos = function(self)
      return self.pos
    end,
    GetFrom = function(self)
      return self.from
    end,
    HasParent = function(self)
      return self.from ~= nil
    end,
    GetParent = function(self)
      return self.from
    end,
    GetAdjacentAreas = function(self)
      return self.nav:GetAdjacentAreas()
    end,
    Underwater = function(self)
      return self.nav:IsUnderwater()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, nav, g, target)
      if g == nil then
        g = 0
      end
      if target == nil then
        target = Vector(0, 0, 0)
      end
      self.nav = nav
      self.pos = self.nav:GetCenter()
      self.positions = {
        self.pos
      }
      self.target = target
      self.g = g
      self.h = target:DistToSqr(self.pos)
      self.f = self.g + self.h
    end,
    __base = _base_0,
    __name = "AStarNode"
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
  self.NORTH_WEST = 0
  self.NORTH_EAST = 1
  self.SOUTH_EAST = 2
  self.SOUTH_WEST = 3
  self.SIDES = {
    self.NORTH_EAST,
    self.NORTH_WEST,
    self.SOUTH_EAST,
    self.SOUTH_WEST
  }
  AStarNode = _class_0
end
local AStarTracer
do
  local _class_0
  local _base_0 = {
    GetOpenNodes = function(self)
      return self.opened
    end,
    GetOpenNodesCount = function(self)
      return #self.opened
    end,
    CopyOpenNodes = function(self)
      local _accum_0 = { }
      local _len_0 = 1
      local _list_0 = self.opened
      for _index_0 = 1, #_list_0 do
        local node = _list_0[_index_0]
        _accum_0[_len_0] = node
        _len_0 = _len_0 + 1
      end
      return _accum_0
    end,
    GetClosedNodes = function(self)
      return self.closed
    end,
    GetClosedNodesCount = function(self)
      return #self.closed
    end,
    CopyClosedNodes = function(self)
      local _accum_0 = { }
      local _len_0 = 1
      local _list_0 = self.closed
      for _index_0 = 1, #_list_0 do
        local node = _list_0[_index_0]
        _accum_0[_len_0] = node
        _len_0 = _len_0 + 1
      end
      return _accum_0
    end,
    GetTotalNodes = function(self)
      return self.database
    end,
    GetTotalNodesCount = function(self)
      return #self.database
    end,
    CopyTotalNodes = function(self)
      local _accum_0 = { }
      local _len_0 = 1
      local _list_0 = self.database
      for _index_0 = 1, #_list_0 do
        local node = _list_0[_index_0]
        _accum_0[_len_0] = node
        _len_0 = _len_0 + 1
      end
      return _accum_0
    end,
    GetIterations = function(self)
      return self.iterations
    end,
    GetTotalIterations = function(self)
      return self.iterations
    end,
    GetCalculationTime = function(self)
      return self.totalTime
    end,
    GetCurrentG = function(self)
      return self.currentG
    end,
    GetLeftDistance = function(self)
      return math.max(self.distToEnd - math.sqrt(self.currentG), 0)
    end,
    GetDistance = function(self)
      return self.distToEnd
    end,
    Distance = function(self)
      return self.distToEnd
    end,
    IsStopped = function(self)
      return self.stop
    end,
    IsWorking = function(self)
      return self.working
    end,
    IsSuccess = function(self)
      return self.success
    end,
    IsFailure = function(self)
      return self.failure
    end,
    IsFinished = function(self)
      return self.hasfinished
    end,
    HasFinished = function(self)
      return self.hasfinished
    end,
    SetSuccessCallback = function(self, val)
      if val == nil then
        val = (function(self) end)
      end
      self.callbackSuccess = val
    end,
    SetFailCallback = function(self, val)
      if val == nil then
        val = (function(self) end)
      end
      self.callbackFail = val
    end,
    SetFailureCallback = function(self, val)
      if val == nil then
        val = (function(self) end)
      end
      self.callbackFail = val
    end,
    SetStopCallback = function(self, val)
      if val == nil then
        val = (function(self) end)
      end
      self.callbackStop = val
    end,
    __tostring = function(self)
      return "[DLib:AStarTracer:" .. tostring(self.ID) .. "]"
    end,
    GetNode = function(self, nav)
      local _list_0 = self.database
      for _index_0 = 1, #_list_0 do
        local data = _list_0[_index_0]
        if data.nav == nav then
          return data
        end
      end
    end,
    AddNode = function(self, node)
      return table.insert(self.database, node)
    end,
    GetPath = function(self)
      return self.points
    end,
    GetPoints = function(self)
      return self.points
    end,
    RecalcPath = function(self)
      if not self.hasfinished then
        return self.points
      end
      if self.failure then
        return self.points
      end
      self.points = {
        self.endPos
      }
      local current = self.lastNode
      while current do
        table.insert(self.points, current:GetPos())
        current = current:GetFrom()
      end
      table.insert(self.points, self.startPos)
      return self.points
    end,
    Stop = function(self)
      if not self.working then
        return 
      end
      self.status = self.__class.NAV_STATUS_INTERRUPT
      self.working = false
      self.stop = true
      self.hasfinished = true
      hook.Remove('Think', tostring(self))
      return self:callbackStop()
    end,
    OnSuccess = function(self, node)
      self.status = self.__class.NAV_STATUS_SUCCESS
      self.lastNode = node
      self.working = false
      self.success = true
      self.hasfinished = true
      hook.Remove('Think', tostring(self))
      self:RecalcPath()
      return self:callbackSuccess()
    end,
    OnFailure = function(self, status)
      if status == nil then
        status = self.__class.NAV_STATUS_GENERIC_FAILURE
      end
      self.working = false
      self.failure = true
      self.hasfinished = true
      self.status = status
      hook.Remove('Think', tostring(self))
      return self:callbackFail(status)
    end,
    GetStatus = function(self)
      return self.status
    end,
    Start = function(self)
      self.lastNodeNav = navmesh.Find(self.endPos, 1, 20, 20)[1]
      self.firstNodeNav = navmesh.Find(self.startPos, 1, 20, 20)[1]
      self.status = self.__class.NAV_STATUS_WORKING
      if not self.lastNodeNav or not self.firstNodeNav then
        self:OnFailure(self.__class.NAV_STATUS_FAILURE_NO_OPEN_NODES)
        return 
      end
      self.working = true
      self.iterations = 0
      self.totalTime = 0
      local newNode = AStarNode(self.firstNodeNav, self.startPos:DistToSqr(self.firstNodeNav:GetCenter()), self.endPos)
      self.opened = {
        newNode
      }
      self.database = {
        newNode
      }
      return hook.Add('Think', tostring(self), function()
        return self:ThinkHook()
      end)
    end,
    GetNearestNode = function(self)
      local current
      local min
      local index
      for i = 1, #self.opened do
        local data = self.opened[i]
        if not min or data.f < min then
          min = data.f
          current = data
          index = i
        end
      end
      if index then
        table.remove(self.opened, index)
      end
      if current then
        table.insert(self.closed, current)
      end
      return current
    end,
    ThinkHook = function(self)
      local status = xpcall(self.Think, self.__class.OnError, self)
      if not status then
        return self:OnFailure()
      end
    end,
    Think = function(self)
      if not self.working then
        hook.Remove('Think', tostring(self))
        return 
      end
      if #self.opened == 0 then
        self:OnFailure(self.__class.NAV_STATUS_FAILURE_NO_OPEN_NODES)
        return 
      end
      if #self.opened >= self.nodesLimit then
        self:OnFailure(self.__class.NAV_STATUS_FAILURE_OPEN_NODES_LIMIT)
        return 
      end
      local calculationTime = 0
      for i = 1, self.loopsPerIteration do
        local sTime = SysTime()
        self.iterations = self.iterations + 1
        if self.hasLimit and self.iterations > self.limit then
          self:OnFailure(self.__class.NAV_STATUS_FAILURE_LOOPS_LIMIT)
          return 
        end
        local nearest = self:GetNearestNode()
        if not nearest then
          break
        end
        if nearest.nav == self.lastNodeNav then
          self:OnSuccess(nearest)
          return 
        end
        self.currentG = nearest:GetG()
        local _list_0 = nearest:GetAdjacentAreas()
        for _index_0 = 1, #_list_0 do
          local _continue_0 = false
          repeat
            local node = _list_0[_index_0]
            local hitClosed = false
            local _list_1 = self.closed
            for _index_1 = 1, #_list_1 do
              local cl = _list_1[_index_1]
              if cl.nav == node then
                hitClosed = true
                break
              end
            end
            if hitClosed then
              _continue_0 = true
              break
            end
            local nodeObject = self:GetNode(node)
            if nodeObject then
              local dist = nodeObject:GetPos():DistToSqr(nearest:GetPos())
              local lengthMultiplier = 1
              if nodeObject:Underwater() then
                lengthMultiplier = lengthMultiplier + 20
              end
              local deltaZ = nodeObject:GetPos().z - nearest:GetPos().z
              if deltaZ > 0 then
                lengthMultiplier = lengthMultiplier + math.max(0, deltaZ)
              end
              if deltaZ < 0 then
                lengthMultiplier = lengthMultiplier + math.max(0, -deltaZ)
              end
              local distG = nearest:GetG() + dist * lengthMultiplier
              if nodeObject:GetG() > distG then
                nodeObject:SetG(distG)
                nodeObject:SetFrom(nearest)
              end
            else
              nodeObject = AStarNode(node, nearest:GetG() + node:GetCenter():DistToSqr(nearest:GetPos()), self.endPos)
              nodeObject:SetFrom(nearest)
              self:AddNode(nodeObject)
              if node:IsValid() then
                table.insert(self.opened, nodeObject)
              else
                table.insert(self.closed, nodeObject)
              end
            end
            _continue_0 = true
          until true
          if not _continue_0 then
            break
          end
        end
        local cTime = (SysTime() - sTime) * 1000
        calculationTime = calculationTime + cTime
        self.totalTime = self.totalTime + cTime
        if self.totalTime >= self.timeThersold then
          self:OnFailure(self.__class.NAV_STATUS_FAILURE_TIME_LIMIT)
          return 
        end
        if calculationTime >= self.frameThersold then
          break
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, startPos, endPos, loopsPerIteration, nodesLimit, limit, frameThersold, timeThersold)
      if startPos == nil then
        startPos = Vector(0, 0, 0)
      end
      if endPos == nil then
        endPos = Vector(0, 0, 0)
      end
      if loopsPerIteration == nil then
        loopsPerIteration = NAV_LOOPS_PER_FRAME:GetInt()
      end
      if nodesLimit == nil then
        nodesLimit = NAV_OPEN_LIMIT:GetInt()
      end
      if limit == nil then
        limit = NAV_LIMIT:GetInt()
      end
      if frameThersold == nil then
        frameThersold = FRAME_THERSOLD:GetFloat()
      end
      if timeThersold == nil then
        timeThersold = TIME_LIMIT:GetFloat()
      end
      self.ID = self.__class.nextID
      self.__class.nextID = self.__class.nextID + 1
      self.working = false
      self.hasfinished = false
      self.failure = false
      self.success = false
      self.stop = false
      self.opened = { }
      self.closed = { }
      self.database = { }
      self.points = {
        startPos,
        endPos
      }
      self.startPos = startPos
      self.endPos = endPos
      self.distToEnd = endPos:Distance(startPos)
      self.loopsPerIteration = loopsPerIteration
      self.limit = limit
      self.hasLimit = limit ~= 0
      self.frameThersold = frameThersold
      self.timeThersold = timeThersold
      self.totalTime = 0
      self.iterations = 0
      self.nodesLimit = nodesLimit
      self.callbackFail = function(self) end
      self.callbackSuccess = function(self) end
      self.callbackStop = function(self) end
      self.status = self.__class.NAV_STATUS_IDLE
      self.currentG = 0
    end,
    __base = _base_0,
    __name = "AStarTracer"
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
  self.nextID = 1
  self.NAV_STATUS_IDLE = -1
  self.NAV_STATUS_SUCCESS = 0
  self.NAV_STATUS_GENERIC_FAILURE = 1
  self.NAV_STATUS_WORKING = 2
  self.NAV_STATUS_FAILURE_TIME_LIMIT = 3
  self.NAV_STATUS_FAILURE_OPEN_NODES_LIMIT = 4
  self.NAV_STATUS_FAILURE_LOOPS_LIMIT = 5
  self.NAV_STATUS_FAILURE_NO_OPEN_NODES = 6
  self.NAV_STATUS_INTERRUPT = 7
  self.OnError = function(err)
    print('[DLib AStarTracer ERROR]: ', err)
    return print(debug.traceback())
  end
  AStarTracer = _class_0
end
DLib.AStarTracer = AStarTracer
DLib.AStarNode = AStarNode
