local User
do
  local _base_0 = { }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, n, p, g)
      self.name = n
      self.password = p
      self.group = g
    end,
    __base = _base_0,
    __name = "User"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  User = _class_0
end
local Client
do
  local _base_0 = {
    send = function(self, message)
      return self.socket:send(message .. "\n")
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, csck, cid)
      self.socket = csck
      self.id = cid
      self.socket:settimeout(0)
      self.ip, self.port = self.socket:getpeername()
      self.temp = { }
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
  Client = _class_0
end
local Logger
do
  local _base_0 = {
    write = function(self, message)
      local fmsg = os.date() .. ' - ' .. message
      table.insert(self.stack, fmsg)
      return print(fmsg)
    end,
    clear = function(self)
      self.stack = { }
    end,
    save = function(self)
      local file = io.open('log.txt', 'w')
      local _list_0 = self.stack
      for _index_0 = 1, #_list_0 do
        local line = _list_0[_index_0]
        file:write(line)
      end
      file:close()
      return self:clear()
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.stack = { }
    end,
    __base = _base_0,
    __name = "Logger"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Logger = _class_0
end
local Database
do
  local _base_0 = {
    load_users = function(self)
      self.users = { }
      local db_file = io.open('./Data/users', 'r')
      local data = ''
      if db_file ~= nil then
        data = db_file:read('*a')
        db_file:close()
      end
      for user, pass, group in data:gmatch('(%w+):(%w+):(%w+);') do
        table.insert(self.users, User(user, pass, group))
      end
    end,
    save_users = function(self)
      local file = io.open('./Data/users', 'w')
      local _list_0 = self.users
      for _index_0 = 1, #_list_0 do
        local user = _list_0[_index_0]
        file:write(user.name .. ':' .. user.password .. ':' .. user.group .. ';')
      end
      return file:close()
    end,
    add_user = function(self, name, pass, group)
      table.insert(self.users, User(name, pass, group))
      self:save_users()
      return self:load_users()
    end,
    remove_user = function(self, name)
      for index, value in pairs(self.users) do
        if value.name == name then
          table.remove(self.users, index)
        end
      end
      self:save_users()
      return self:load_users()
    end,
    valid_user = function(self, name, pass)
      local user
      do
        local _accum_0 = { }
        local _len_0 = 1
        for i, u in pairs(self.users) do
          if u.name == name and u.password == pass then
            _accum_0[_len_0] = u
            _len_0 = _len_0 + 1
          end
        end
        user = _accum_0
      end
      return #user > 0
    end,
    user_exists = function(self, name)
      local user
      do
        local _accum_0 = { }
        local _len_0 = 1
        local _list_0 = self.users
        for _index_0 = 1, #_list_0 do
          local u = _list_0[_index_0]
          if u.name == name then
            _accum_0[_len_0] = u
            _len_0 = _len_0 + 1
          end
        end
        user = _accum_0
      end
      return #user > 0
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.users = { }
    end,
    __base = _base_0,
    __name = "Database"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Database = _class_0
end
return {
  User = User,
  Client = Client,
  Logger = Logger,
  Database = Database
}
