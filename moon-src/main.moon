import Server from require 'server'
import Logger, Database from require 'classes'

export logger = Logger!
export database = Database!

export server = Server 5000, '4.9'
server.lock = true
server\start!