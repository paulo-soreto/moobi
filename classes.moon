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

class Database
    new: => @users = {}

    load_users: =>
        @users = {}
        db_file = io.open './Data/users', 'r'
        data = ''
        if db_file ~= nil
            data = db_file\read '*a'
            db_file\close!
        for user, pass, group in data\gmatch '(%w+):(%w+):(%w+);' do table.insert @users, User user, pass, group
    
    save_users: =>
        file = io.open './Data/users', 'w'
        for user in *@users do file\write user.name..':'..user.password..':'..user.group..';'
        file\close!

    add_user: (name, pass, group) =>
        table.insert @users, User name, pass, group
        self\save_users!
        self\load_users!

    remove_user: (name) =>
        for index, value in pairs @users do if value.name == name then table.remove @users, index
        self\save_users!
        self\load_users!

    valid_user: (name, pass) =>
        user = [u for i, u in pairs @users when u.name == name and u.password == pass]
        return #user > 0

    user_exists: (name) =>
        user = [u for u in *@users when u.name == name]
        return #user > 0

{ :User, :Client, :Logger, :Database }