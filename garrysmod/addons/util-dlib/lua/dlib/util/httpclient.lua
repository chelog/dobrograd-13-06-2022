do
  local _class_0
  local _base_0 = {
    Expired = function(self, stamp)
      if stamp == nil then
        stamp = os.time()
      end
      if self.m_Session then
        return false
      end
      return self.m_Expires < stamp
    end,
    Is = function(self, path)
      if self.Secure and not path:startsWith('https://') then
        return false
      end
      local protocol, domain = path:match('(https?)://([a-zA-Z0-9.-]+)')
      if not protocol or not domain then
        return false
      end
      if self.explicitDomain and self.m_Domain ~= domain then
        return false
      end
      if not self.explicitDomain and not domain:endsWith(self.m_Domain) then
        return false
      end
      local uripath = path:sub(#protocol + 4 + #domain):trim()
      if uripath == '' then
        uripath = '/'
      end
      return uripath:startsWith(self.m_Path)
    end,
    Hash = function(self)
      return tostring(self.name) .. "_" .. tostring(self.m_Domain) .. "[" .. tostring(self.explicitDomain) .. "]_" .. tostring(util.CRC(self.m_Path)) .. "_" .. tostring(self.m_Secure)
    end,
    Value = function(self)
      return tostring(self.name) .. "=" .. tostring(self.value)
    end,
    Serialize = function(self)
      local build = {
        self.name .. '=' .. self.value,
        'Created=' .. os.date('%a, %d %b %Y %H:%M:%S GMT', self.m_CreationTime),
        'Domain=' .. self.m_Domain,
        'Path=' .. self.m_Path
      }
      if self.m_HttpOnly then
        table.insert(build, 'HttpOnly')
      end
      if not self.m_Session then
        table.insert(build, 'Expires=' .. os.date('%a, %d %b %Y %H:%M:%S GMT', self.m_Expires))
      end
      if self.explicitDomain then
        table.insert(build, 'UnsafeDomain')
      end
      return table.concat(build, '; ')
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, name, value, domain, path, explicitDomain)
      if path == nil then
        path = '/'
      end
      if explicitDomain == nil then
        explicitDomain = true
      end
      assert(isstring(name), 'Name must be a string')
      assert(isstring(value), 'Value must be a string')
      assert(not name:find(' ', 1, true) and not name:find('=', 1, true) and not name:find(';', 1, true) and not name:find('\n', 1, true), 'Cookie name can not contain special symbols')
      assert(not value:find(' ', 1, true) and not value:find('=', 1, true) and not value:find(';', 1, true) and not value:find('\n', 1, true), 'Cookie value can not contain special symbols')
      assert(isstring(domain), 'Domain must be a string')
      assert(isstring(path), 'Path must be a string')
      assert(isstring(domain), 'Domain must be a string')
      self.name = name
      self.value = value
      self.m_HttpOnly = false
      self.m_Domain = domain
      self.m_Path = path
      self.m_Secure = false
      self.m_CreationTime = os.time()
      self.m_Expires = math.huge
      self.m_Session = true
      self.explicitDomain = explicitDomain
    end,
    __base = _base_0,
    __name = "Cookie"
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
  self.Parse = function(self, strInput, domain, unsafe)
    if unsafe == nil then
      unsafe = false
    end
    assert(isstring(strInput), 'Input must be a string')
    local split = strInput:split(';')
    local _name = table.remove(split, 1)
    local startPos, endPos = _name:find('=', 1, true)
    if not startPos then
      error('Malformed input. First key=value pair in cookie must always be cookie\'s name and value!')
    end
    local cname = _name:sub(1, startPos - 1)
    local cvalue = _name:sub(startPos + 1)
    local data = {
      unsafedomain = true
    }
    for _index_0 = 1, #split do
      local param = split[_index_0]
      local trim = param:trim()
      local _exp_0 = trim:lower()
      if 'secure' == _exp_0 then
        data.secure = true
      elseif 'httponly' == _exp_0 then
        data.httponly = true
      elseif 'unsafedomain' == _exp_0 then
        if unsafe then
          data.unsafedomain = true
        end
      else
        startPos, endPos = trim:find('=', 1, true)
        if startPos then
          local name = trim:sub(1, startPos - 1)
          local value = trim:sub(startPos + 1)
          if name:lower() == 'max-age' then
            do
              local num = tonumber(value)
              if num then
                data.override_expires = true
                if num == 0 then
                  data.expires = nil
                  data.session = true
                else
                  data.expires = os.time() + num
                  data.session = false
                end
              end
            end
          elseif name:lower() == 'expires' and not data.override_expires then
            data.expires = http.ParseDate(value)
            data.session = false
            if data.expires < 10 then
              data.expires = nil
              data.session = true
            end
          elseif unsafe and name:lower() == 'created' then
            data.created = http.ParseDate(value)
          elseif name:lower() == 'domain' then
            data.domain = value
            data.unsafedomain = false
          elseif name:lower() == 'path' then
            data.path = value
          end
        end
      end
    end
    local cookie = self(cname, cvalue, data.domain or domain, data.path)
    if data.secure then
      cookie:SetIsSecure(true)
    end
    if data.httponly then
      cookie:SetHttpOnly(true)
    end
    if data.created then
      cookie:SetCreationStamp(data.created)
    end
    if data.domain then
      cookie:SetDomain(data.domain)
    end
    cookie:SetExplicitDomain(data.unsafedomain)
    if data.expires then
      cookie:SetExpiresStamp(data.expires)
      cookie:SetIsSession(data.session)
    end
    return cookie
  end
  AccessorFunc(self.__base, 'm_HttpOnly', 'HttpOnly', FORCE_BOOL)
  AccessorFunc(self.__base, 'explicitDomain', 'ExplicitDomain', FORCE_BOOL)
  AccessorFunc(self.__base, 'm_Session', 'IsSession', FORCE_BOOL)
  AccessorFunc(self.__base, 'm_CreationTime', 'CreationStamp', FORCE_NUMBER)
  AccessorFunc(self.__base, 'm_Expires', 'ExpiresStamp', FORCE_NUMBER)
  AccessorFunc(self.__base, 'm_Secure', 'IsSecure', FORCE_BOOL)
  AccessorFunc(self.__base, 'm_Path', 'Path', FORCE_STRING)
  AccessorFunc(self.__base, 'm_Domain', 'Domain', FORCE_STRING)
  AccessorFunc(self.__base, 'value', 'Value', FORCE_STRING)
  http.Cookie = _class_0
end
do
  local _class_0
  local _base_0 = {
    Add = function(self, input, domain)
      local cookie = isstring(input) and http.Cookie:Parse(input, domain) or input
      local hash = cookie:Hash()
      if self.jar[hash] then
        cookie:SetCreationStamp(self.jar[hash]:GetCreationStamp())
      end
      self.jar[hash] = cookie
      return self
    end,
    Remove = function(self, input, domain)
      local cookie = isstring(input) and http.Cookie:Parse(input, domain) or input
      local hash = cookie:Hash()
      if self.jar[hash] then
        self.jar[hash] = nil
        return true
      end
      return false
    end,
    GetFor = function(self, url)
      for hash, cookie in pairs(self.jar) do
        if cookie:Expired() then
          self.jar[hash] = nil
        end
      end
      local _accum_0 = { }
      local _len_0 = 1
      for hash, cookie in pairs(self.jar) do
        if cookie:Is(url) then
          _accum_0[_len_0] = cookie
          _len_0 = _len_0 + 1
        end
      end
      return _accum_0
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.jar = { }
    end,
    __base = _base_0,
    __name = "CookieJar"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  http.CookieJar = _class_0
end
local Promise
Promise = DLib.Promise
do
  local _class_0
  local _base_0 = {
    CookieList = function(self, url)
      local cookies = self.cookiejar:GetFor(url)
      if not cookies or #cookies == 0 then
        return false
      end
      return table.concat((function()
        local _accum_0 = { }
        local _len_0 = 1
        for _index_0 = 1, #cookies do
          local cookie = cookies[_index_0]
          _accum_0[_len_0] = cookie:Value()
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)(), '; ')
    end,
    Patch = function(self, url, headers)
      local cookieList = self:CookieList(url)
      local hit = not cookieList
      local hit2 = not self.last_referer
      if hit and hit2 then
        return headers
      end
      for headerName in pairs(headers) do
        if not hit and headerName:lower() == 'cookie' then
          hit = true
        end
        if not hit2 and headerName:lower() == 'referer' then
          hit2 = true
        end
      end
      if not hit then
        headers.Cookie = cookieList
      end
      if not hit2 then
        headers.Referer = self.last_referer
      end
      return headers
    end,
    _Domain = function(self, url)
      return url:match('https?://([a-zA-Z0-9.-]+)'):lower()
    end,
    _Receive = function(self, domain, headers)
      for key, value in pairs(headers) do
        if key:lower() == 'set-cookie' then
          self.cookiejar:Add(value, domain)
        end
      end
    end,
    Get = function(self, url, headers)
      if headers == nil then
        headers = { }
      end
      return Promise(function(resolve, reject)
        return http.PromiseGet(url, self:Patch(url, headers)):Catch(reject):Then(function(body, size, headers, code, ...)
          if body == nil then
            body = ''
          end
          if size == nil then
            size = 0
          end
          if headers == nil then
            headers = { }
          end
          if code == nil then
            code = 500
          end
          self:_Receive(self:_Domain(url), headers)
          if code >= 200 and code < 300 then
            self.last_referer = url
          end
          return resolve(body, size, headers, code, ...)
        end)
      end)
    end,
    Post = function(self, url, params, headers)
      if headers == nil then
        headers = { }
      end
      return Promise(function(resolve, reject)
        return http.PromisePost(url, params, self:Patch(url, headers)):Catch(reject):Then(function(body, size, headers, code, ...)
          if body == nil then
            body = ''
          end
          if size == nil then
            size = 0
          end
          if headers == nil then
            headers = { }
          end
          if code == nil then
            code = 500
          end
          self:_Receive(self:_Domain(url), headers)
          if code >= 200 and code < 300 then
            self.last_referer = url
          end
          return resolve(body, size, headers, code, ...)
        end)
      end)
    end,
    PostBody = function(self, url, body, headers)
      if headers == nil then
        headers = { }
      end
      return Promise(function(resolve, reject)
        return http.PromisePostBody(url, body, self:Patch(url, headers)):Catch(reject):Then(function(body, size, headers, code, ...)
          if body == nil then
            body = ''
          end
          if size == nil then
            size = 0
          end
          if headers == nil then
            headers = { }
          end
          if code == nil then
            code = 500
          end
          self:_Receive(self:_Domain(url), headers)
          if code >= 200 and code < 300 then
            self.last_referer = url
          end
          return resolve(body, size, headers, code, ...)
        end)
      end)
    end,
    Put = function(self, url, body, headers)
      if headers == nil then
        headers = { }
      end
      return Promise(function(resolve, reject)
        return http.PromisePut(url, body, self:Patch(url, headers)):Catch(reject):Then(function(body, size, headers, code, ...)
          if body == nil then
            body = ''
          end
          if size == nil then
            size = 0
          end
          if headers == nil then
            headers = { }
          end
          if code == nil then
            code = 500
          end
          self:_Receive(self:_Domain(url), headers)
          if code >= 200 and code < 300 then
            self.last_referer = url
          end
          return resolve(body, size, headers, code, ...)
        end)
      end)
    end,
    Head = function(self, url, headers)
      if headers == nil then
        headers = { }
      end
      return Promise(function(resolve, reject)
        return http.PromiseHead(url, self:Patch(url, headers)):Catch(reject):Then(function(headers, code, ...)
          if headers == nil then
            headers = { }
          end
          if code == nil then
            code = 500
          end
          self:_Receive(self:_Domain(url), headers)
          if code >= 200 and code < 300 then
            self.last_referer = url
          end
          return resolve(headers, code, ...)
        end)
      end)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, cookiejar)
      if isstring(cookiejar) then
        error('serializing of cookiejar is not supported yet')
      elseif type(cookiejar) == 'table' then
        self.cookiejar = cookiejar
      else
        self.cookiejar = http.CookieJar()
      end
      self.set_referer = true
      self.last_referer = false
    end,
    __base = _base_0,
    __name = "Client"
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
  AccessorFunc(self.__base, 'set_referer', 'SetReferer', FORCE_BOOL)
  AccessorFunc(self.__base, 'last_referer', 'LastReferer')
  http.Client = _class_0
  return _class_0
end
