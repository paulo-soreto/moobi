local handle
handle = function(index, client, message)
  logger:write('Mensagem de [' .. client.ip .. ']: ' .. message)
  if message:find('<0>') then
    return client:send('<0 ' .. client.id .. ">'e' n=" .. server.version .. '</0>')
  elseif message:find('<login') then
    local user, pass = message:match('<login (.*)>(.*)</login>')
    if database:user_exists(user) then
      if database:valid_user(user, pass) then
        client.name = user
        return client:send('<login>allow</login>')
      else
        return client:send('<login>wp</login>')
      end
    else
      return client:send('<login>wu</login>')
    end
  elseif message:find('<reges') then
    local user, pass = message:match('<reges (.*)>(.*)</reges>')
    if database:user_exists(user) then
      return client:send('<reges>ue</reges>')
    else
      database:add_user(user, pass, 'std')
      return client:send('<reges>success</reges>')
    end
  elseif message:find('<1>') then
    return client:send('<1>' .. client.id .. '</1>')
  elseif message:find('<2>') then
    return client:send('<2>' .. client.name .. '</1>')
  elseif message:find('<3a>') then
    client.temp['pchat_id'] = message:match('<3a>(.*)</3a>')
  elseif message:find('<3>') then
    return server.send_to_player(tonumber(client.temp['pchat_id'], message:gsub('<3>', '<3 ' .. client.id .. '>')))
  elseif message:find('<4a>') then
    client.temp['stateid'] = message:match('<4a>(.*)</4a>')
  elseif message:find('<4>') then
    return server.send_to_player(tonumber(client.temp['stateid'], data))
  elseif message:find('<5>') then
    return server.send_to_all(message:gsub('<5>', '<5 ' .. client.id .. '>'))
  elseif message:find('<6>') then
    return server.send_to_all(message:gsub('<6>', '<6 ' .. client.id .. '>'))
  elseif message:find('<7>') then
    return server.send_to_all(message)
  elseif message:find('<8>') then
    return client.socket:close()
  elseif message:find('<10>') then
    return server.send_to_all(message)
  elseif message:find('<10a>') then
    client.temp['attackid'] = message:match('<10a>(.*)</10a>')
  elseif message:find('<10b>') then
    return server.send_to_player(tonumber(client.temp['attackid'], message))
  elseif message:find('<11a>') then
    client.temp['resultid'] = message:match('<11a>(.*)</11a>')
  elseif message:find('<11>') then
    return server.send_to_player(tonumber(client.temp['resultid'], message))
  elseif message:find('<12a>') then
    client.temp['mchatid'] = message:match('<12a>(.*)</12a>')
  elseif message:find('<12>') then
    return server.send_to_player(tonumber(client.temp['mchatid'], message))
  elseif message:find('<13a>') then
    client.temp['absid'] = message:match('<13a>(.*)</13a>')
  elseif message:find('<abs>') then
    return server.send_to_player(tonumber(client.temp['absid'], message:gsub('<abs>', '')))
  elseif message:find('<14a>') then
    client.temp['partyid'] = message:match('<14a>(.*)</14a>')
  elseif message:find('<party>') then
    return server.send_to_player(tonumber(client.temp['partyid'], message:gsub('<party>', '')))
  elseif message:find('<15a>') then
    client.temp['guildid'] = message:match('<15a>(.*)</15a>')
  elseif message:find('<guild>') then
    return server.send_to_player(tonumber(client.temp['guildid'], message:gsub('<guild>', '')))
  elseif message:find('<16a>') then
    client.temp['adminid'] = message:match('<16a>(.*)</16a>')
  elseif message:find('<admin>') then
    return server.send_to_player(tonumber(client.temp['adminid'], message:gsub('<admin>', '')))
  elseif message:find('<17a>') then
    client.temp['tradeid'] = message:match('<17a>(.*)</17a>')
  elseif message:find('<trade>') then
    return server.send_to_player(tonumber(client.temp['tradeid'], message:gsub('<trade>', '')))
  elseif message:find('<17g>') then
    client.temp['tradeid'] = message:match('<17g>(.*)</17g>')
    return server.send_to_player(tonumber(client.temp['tradeid'], message))
  end
end
return {
  handle = handle
}
