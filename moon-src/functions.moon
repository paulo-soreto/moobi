handle = (index, client, message) ->
    logger\write 'Mensagem de ['..client.ip..']: '..message

    -- Autenticação
    if message\find '<0>'
        client\send '<0 '..client.id..">'e' n="..server.version..'</0>'

    -- Login
    elseif message\find '<login'
        user, pass = message\match '<login (.*)>(.*)</login>'
        if database\user_exists user
            if database\valid_user user, pass
                client.name = user
                client\send '<login>allow</login>'
            else client\send '<login>wp</login>'
        else
            client\send '<login>wu</login>'

    -- Registro
    elseif message\find '<reges'
        user, pass = message\match '<reges (.*)>(.*)</reges>'
        if database\user_exists user then client\send '<reges>ue</reges>'
        else
            database\add_user user, pass, 'std'
            client\send '<reges>success</reges>'

    -- ID
    elseif message\find '<1>'
        client\send '<1>'..client.id..'</1>'

    -- Nome
    elseif message\find '<2>'
        client\send '<2>'..client.name..'</1>'

    -- Private chat
    elseif message\find '<3a>'
        client.temp['pchat_id'] = message\match '<3a>(.*)</3a>'
    elseif message\find '<3>'
        server.send_to_player tonumber client.temp['pchat_id'], message\gsub '<3>', '<3 '..client.id..'>'

    -- State
    elseif message\find '<4a>'
        client.temp['stateid'] = message\match '<4a>(.*)</4a>'
    elseif message\find '<4>'
        server.send_to_player tonumber client.temp['stateid'], data
    
    -- Netplayer
    elseif message\find '<5>'
        server.send_to_all message\gsub '<5>', '<5 '..client.id..'>'
    elseif message\find '<6>'
        server.send_to_all message\gsub '<6>', '<6 '..client.id..'>'

    -- Remove
    elseif message\find '<7>'
        server.send_to_all message

    -- Test end
    elseif message\find '<8>'
        client.socket\close!

    -- System
    elseif message\find '<10>'
        server.send_to_all message

    -- PVP Attack
    elseif message\find '<10a>'
        client.temp['attackid'] = message\match '<10a>(.*)</10a>'
    elseif message\find '<10b>'
        server.send_to_player tonumber client.temp['attackid'], message

    -- PVP Result
    elseif message\find '<11a>'
        client.temp['resultid'] = message\match '<11a>(.*)</11a>'
    elseif message\find '<11>'
        server.send_to_player tonumber client.temp['resultid'], message

    -- Map chat
    elseif message\find '<12a>'
        client.temp['mchatid'] = message\match '<12a>(.*)</12a>'
    elseif message\find '<12>'
        server.send_to_player tonumber client.temp['mchatid'], message

    -- ABS
    elseif message\find '<13a>'
        client.temp['absid'] = message\match '<13a>(.*)</13a>'
    elseif message\find '<abs>'
        server.send_to_player tonumber client.temp['absid'], message\gsub '<abs>', ''

    -- Party
    elseif message\find '<14a>'
        client.temp['partyid'] = message\match '<14a>(.*)</14a>'
    elseif message\find '<party>'
        server.send_to_player tonumber client.temp['partyid'], message\gsub '<party>', ''

    -- Guild
    elseif message\find '<15a>'
        client.temp['guildid'] = message\match '<15a>(.*)</15a>'
    elseif message\find '<guild>'
        server.send_to_player tonumber client.temp['guildid'], message\gsub '<guild>', ''

    -- Admin
    elseif message\find '<16a>'
        client.temp['adminid'] = message\match '<16a>(.*)</16a>'
    elseif message\find '<admin>'
        server.send_to_player tonumber client.temp['adminid'], message\gsub '<admin>', ''

    -- Trade
    elseif message\find '<17a>'
        client.temp['tradeid'] = message\match '<17a>(.*)</17a>'
    elseif message\find '<trade>'
        server.send_to_player tonumber client.temp['tradeid'], message\gsub '<trade>', ''
    elseif message\find '<17g>'
        client.temp['tradeid'] = message\match '<17g>(.*)</17g>'
        server.send_to_player tonumber client.temp['tradeid'], message
    
{ :handle }