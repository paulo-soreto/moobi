import insert, remove from table
import User from require 'classes'

class Database
	new: => @users = {}

	load_users: =>
		@users = {}
		db_file = io.open './Data/users', 'r'
		data = ''
		if db_file ~= nil
			data = db_file\read '*a'
			db_file\close!
		for user, pass, group in data\gmatch '(%w+):(%w+):(%w+);' do insert @users, User user, pass, group
	
	save_users: =>
		file = io.open './Data/users', 'w'
		for user in *@users do file\write user.name..':'..user.password..':'..user.group..';'
		file\close!

	add_user: (name, pass, mail) =>
		insert @users, User name, pass, mail
		self\save_users!
		self\load_users!

	remove_user: (name) =>
		for index, value in pairs @users do if value.name == name then remove @users, index
		self\save_users!
		self\load_users!

	valid_user: (name, pass) =>
		user = [u for i, u in pairs @users when u.name == name and u.password == pass]
		return #user > 0

db = Database!
db\load_users!
db\remove_user 'novin', 'novin'
print db\valid_user 'novin', 'novin'