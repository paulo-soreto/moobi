import Server from require 'server'
import Logger from require 'classes'

export logger = Logger!

export server = Server 5000, '4.9'
server.lock = true
server\start!