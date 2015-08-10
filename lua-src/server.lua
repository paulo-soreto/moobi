local socket = require('socket')
local User, Client
do
  local _obj_0 = require('classes')
  User, Client = _obj_0.User, _obj_0.Client
end
local insert, remove
do
  local _obj_0 = table
  insert, remove = _obj_0.insert, _obj_0.remove
end
local handle
handle = require('functions').handle
local Server
do
  local _base_0 = {
    start = function(self)
      logger:write('Iniciando servidor...')
      self.socket = socket:tcp()
      self.socket:bind('*', self.port)
      self.socket:listen(10)
      self.ip, self.port = self.socket:getsockname()
      self.socket:settimeout(0)
      self.socket:setoption('tcp-nodelay', true)
      logger:write('Servidor iniciando em [' .. self.ip .. ':' .. self.port .. ']')
      database:load_users()
      return self:loop()
    end,
    loop = function(self)
      while true do
        if self:can_read(self.socket) then
          self:accept()
        end
        self:receive()
        if self.lock then
          socket.sleep(0.1)
        end
      end
    end,
    accept = function(self)
      self.high_index = self.high_index + 1
      local client = Client(self.socket:accept(), self.high_index)
      insert(self.clients, client)
      return logger:write('Usuario [' .. client.ip .. ':' .. client.port .. '] conectado!')
    end,
    receive = function(self)
      for index, client in pairs(self.clients) do
        local _continue_0 = false
        repeat
          if not (self:can_read(self.clients[index].socket)) then
            _continue_0 = true
            break
          end
          local message, status = self.clients[index].socket:receive('*l')
          if status == 'closed' then
            logger:write('Usuario [' .. self.clients[index].ip .. ':' .. self.clients[index].port .. '] desconectado!')
            remove(self.clients, index)
          elseif message:len() > 0 then
            handle(index, self.clients[index], message)
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
    end,
    kick_player = function(self, id)
      local _list_0 = self.clients
      for _index_0 = 1, #_list_0 do
        local client = _list_0[_index_0]
        if client.id == v then
          client.socket:close()
        end
      end
    end,
    send_to_player = function(self, id, message)
      local _list_0 = self.clients
      for _index_0 = 1, #_list_0 do
        local client = _list_0[_index_0]
        if client.id == id then
          client.socket:send(message .. "\n")
        end
      end
    end,
    send_to_all = function(self, message)
      local _list_0 = self.clients
      for _index_0 = 1, #_list_0 do
        local client = _list_0[_index_0]
        client.socket:send(message .. "\n")
      end
    end,
    can_read = function(self, sck)
      local r, w, e = socket.select({
        sck
      }, nil, 0)
      return #r > 0
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, p, v)
      self.port = p
      self.version = v
      self.clients = { }
      self.high_index = 0
      self.lock = false
    end,
    __base = _base_0,
    __name = "Server"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Server = _class_0
end
return {
  Server = Server
}
