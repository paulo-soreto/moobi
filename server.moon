socket = require 'socket'

import User, Client from require 'classes'
import insert, remove from table
import handle from require 'functions'

class Server
    new: (p, v) =>
        @port = p
        @version = v
        @clients = {}
        @high_index = 0
        @lock = false

    start: =>
        logger\write 'Iniciando servidor...'
        @socket = socket\tcp!
        @socket\bind '*', @port
        @socket\listen 10
        @ip, @port = @socket\getsockname!
        @socket\settimeout 0
        @socket\setoption 'tcp-nodelay', true
        logger\write 'Servidor iniciando em ['..@ip..':'..@port..']'
        self\load_database!
        self\loop!

    load_database: =>
        logger\write 'Carregando banco de dados...'
        db_file = io.open './Data/users', 'r'
        data = db_file\read'*a'
        db_file\close!
        @database = {}
        for user, pass, group in data\gmatch '(%w+):(%w+):(%w+);' do insert @database, User user, pass, group
        logger\write #@database..' usuarios carregados!'

    loop: =>
        while true
            if self\can_read @socket then self\accept!
            self\receive!
            if @lock then socket.sleep 0.1

    accept: =>
        @high_index += 1
        client = Client @socket\accept!, @high_index
        insert @clients, client
        logger\write 'Usuario ['..client.ip..':'..client.port..'] conectado!'

    receive: =>
        for index, client in pairs @clients
            continue unless self\can_read @clients[index].socket
            message, status = @clients[index].socket\receive '*l'
            if status == 'closed'
                logger\write 'Usuario ['..@clients[index].ip..':'..@clients[index].port..'] desconectado!'
                remove @clients, index
            elseif message\len! > 0
                handle index, @clients[index], message

    kick_player: (id) =>
        for client in *@clients do if client.id == v then client.socket\close!

    send_to_player: (id, message) =>
        for client in *@clients do if client.id == id then client.socket\send message.."\n"

    send_to_all: (message) =>
        for client in *@clients do client.socket\send message.."\n"

    can_read: (sck) =>
        r, w, e = socket.select { sck }, nil, 0
        return #r > 0

{ :Server }