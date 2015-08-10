local Server
Server = require('server').Server
local Logger, Database
do
  local _obj_0 = require('classes')
  Logger, Database = _obj_0.Logger, _obj_0.Database
end
logger = Logger()
database = Database()
server = Server(5000, '4.9')
server.lock = true
return server:start()
