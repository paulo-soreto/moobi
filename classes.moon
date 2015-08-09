class User
    new: (n, p, g) =>
        @name = n
        @password = p
        @group = g

class Client
    new: (csck, cid) =>
        @socket = csck
        @id = cid
        @socket\settimeout 0
        @ip, @port = @socket\getpeername!
        @temp = {}

    send: (message) =>
        @socket\send message.."\n"

class Logger
    new: =>
        @stack = {}

    write: (message) =>
        fmsg = os.date!..' - '..message
        table.insert @stack, fmsg
        print fmsg

    clear: => @stack = {}

    save: =>
        file = io.open 'log.txt', 'w'
        for line in *@stack do file\write line
        file\close!
        self\clear!

{ :User, :Client, :Logger }