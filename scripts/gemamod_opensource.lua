PLUGIN_CHANGED = "SDBS"
PLUGIN_CHANGED_DATE = "09/11/2016"

PLUGIN_NAME = "SilverCloudGemaMod OpenSource version"
PLUGIN_AUTHOR = "Jg99" -- Jg99
PLUGIN_VERSION = "4.2.2" -- SilverCloud Gema mod

dofile("lua/scripts/functions/functions.lua")


-- common

include("ac_server")
require "webnet77"


config = {
    gema_mode_autodetecting = true;
    gema_mode_is_turned_on = true;
    randommaprot = false --I like randomness
}

SpamInterval = 60
namelog = {}
disconnectlog = {}
cached_gtop = nil
new_record_added = true
fines = {}
start_times = {}
autogemakick = false
dup = false
colortext = true
ismuted = {} --use to block all text and voicecoms from a player
lastpm = {} --keep track of who pm'd you last for !r
disconnectcount = 29
autogemakick = true
allgeoips = {}
forbidden ={}
postdata = {}

adminstatuscn = -1

webnet = nil

mcmsg 	= true	--Message if server is full.
mmmsg 	= true	--Message if a player cannot connect because of Mastermode.
banmsg 	= true  --Message if a banned players trying to connect.

votes = {
    [-1] = false;               --Demo
    [0] = false;		--TDM
    [1] = false;		--Coop
    [2] = false;		--DM
    [3] = false;		--surv
    [4] = false;		--tsurv
    [5] = true;                 --ctf
    [6] = false;		--PF
    [9] = false;		--LSS
    [10] = false;		--osok
    [11] = false;		--tosok
    [13] = false;		--htf
    [14] = false;		--tktf
    [15] = false;		--ktf
    [16] = false;               --num
}

ccodes = { "\f0", "\f1", "\f2", "\f0", "\f2", "\f5", "\f6", "\f7", "\f8", "\f9", "\fA", "\fB", "\fC", "\fD", "\fE",
  "\fF", "\fG", "\fH", "\fI", "\fJ", "\fK", "\fL", "\fM", "\fN", "\fO", "\fP", "\fQ", "\fR", "\fS", "\fT",
  "\fU", "\fV", "\fW", "\fX", "\fY", "\fZ", "\fb"}
cclookup = { "\\f0", "\\f1", "\\f2", "\\f0", "\\f2", "\\f5", "\\f6", "\\f7", "\\f8", "\\f9", "\\fA", "\\fB", "\\fC", "\\fD", "\\fE",
  "\\fF", "\\fG", "\\fH", "\\fI", "\\fJ", "\\fK", "\\fL", "\\fM", "\\fN", "\\fO", "\\fP", "\\fQ", "\\fR", "\\fS", "\\fT",
  "\\fU", "\\fV", "\\fW", "\\fX", "\\fY", "\\fZ", "\\fb"}

eighttext = {"\fNIt is certain", "\fNIt is decidedly so", "\fNWithout a doubt", "\fNYes definitely", "\fNYou may rely on it", "\fNAs I see it yes", "\fNMost likely", "\fNOutlook good", "\fNYes", "\fNSigns point to yes", "\fNReply hazy try again", "\fN Ask again later", "\fNBetter not tell you now", "\fNCannot predict now", "\fNConcentrate and ask again", "\fNDon't count on it", "\fN My reply is no", "\fNMy sources say no", "\fNOutlook not so good", "\fNVery doubtful", "\fNOh hell no!"}

--server spam messages, add or remove text as needed
spammessages = {"\f2[\fISERVER INFO\f2] \fY:\fIGEMA \f2server powered by \fILua","\f2[\fISERVER INFO\f2] \fY:\fIPLEASE \f2DO NOT \fIKILL \f2IN \fIGEMA!!!","\f2[\fISERVER INFO\f2] \fY:\fIGEMA-killers \f2will be \fI\fbBanned \f2or \fI\fbBlacklisted!!!","\f2[\fISERVER INFO\f2] \fY:\f2Part of the \f2|\fIAoX\f2| C\fIlan \f2N\fIetwork \f2of Servers","\f2[\fISERVER INFO\f2] \fY:\f2Visit us @ \fIvah-clan.ga","\f2[\fISERVER INFO\f2] \fY:\f2On \fIirc.freenode.net \f2@ \fI#vah","\f2[\fISERVER INFO\f2] \fY:\f2If you have any questions, contact \f1|VAH|-Vahe \f2for assistance.","\f2[\fISERVER INFO\f2] \fY:\fYType \fI!cmds \f2to see a list of available commands","\f2[\fISERVER INFO\f2] \fY:\fIRespect \f2all fellow \fIplayers \f2and server \fIadmins","\f2[\fISERVER INFO\f2] \fY:\fIGEMA \f2server powered by \fILua","\f2[\fISERVER INFO\f2] \fY:\fIPLEASE \f2DO NOT \fIKILL \f2IN \fIGEMA!!!","\f2[\fISERVER INFO\f2] \fY:\fIGEMA-killers \f2will be \fI\fbBanned \f2or \fI\fbBlacklisted!!!","\f2[\fISERVER INFO\f2] \fY:\fIEnjoy \f2the \fIServer!","\f2[\fISERVER INFO\f2] \fY:\f2Type \fI!cmds \f2To see available commands","\f2[\fISERVER INFO\f2] \fY:\fIRESPECT \f2THE \fIADMINS\f2, \fIPLAYERS \f2and \fISERVER","\f2[\fISERVER INFO\f2] \fY:\f2Please refrain from using \fIOFFENSIVE LANGUAGE","\f2[\fISERVER INFO\f2] \fY:\f2Open \fI24\f2/\fI7","\f2[\fISERVER INFO\f2] \fY:\fIHave Fun!","\f2[\fISERVER INFO\f2] \fY:\f2Part of the \f2|\fIAoX\f2| C\fIlan \f2N\fIetwork \f2of Servers","\f2[\fISERVER INFO\f2] \fY:\f2Visit us @ \fIaox-clan.net","\f2[\fISERVER INFO\f2] \fY:\f2On \fIirc.freenode.net \f2@ \fI#vah","\f2[\fISERVER INFO\f2] \fY:\fIGEMA \f2server powered by \fILua","\f2[\fISERVER INFO\f2] \fY:\fIPLEASE \f2DO NOT \fIKILL \f2IN \fIGEMA!!!","\f2[\fISERVER INFO\f2] \fY:\fIGEMA-killers \f2will be \fI\fbBanned \f2or \fI\fbBlacklisted!!!","\f2[\fISERVER INFO\f2] \fY:\f2If you have any questions, contact \f1|VAH|-Vahe \f2for assistance."}

function ltrim(s) -- remove leading whitespaces
    return (s:gsub("^%s*", ""))
end

function trim(s) --remove leading and trailing whitespace
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function rtrim(s) --remove trailing whitespace
    local n = #s
    while n > 0 and s:find("^%s", n) do n = n - 1 end
    return s:sub(1, n)
end

function random_color()
    return ccodes[math.random(1, #ccodes)]
end

function ServerSpam()
    clientprint(-1, spammessages[math.random(#spammessages)])
end

function find_place(records, name)
    local result = nil
    for i,record in ipairs(records) do
        if record[1] == name then
            result = i
            break
        end
    end
    return result
end

function gload()
    if new_record_added == false then return cached_gtop end
    local grecords = {}
    local grecords_m = {}
    local count = 0
    for line in io.lines("lua/config/SvearkMod_maps.cfg") do
        local cnt = string.find(line, "=")
            if cnt ~= nil then
                local map_name = string.sub(line,1,cnt - 1)
                local gdata = sorted_records(load_records(map_name))
                local n = grecords_m[gdata[1][1]]
                if n == nil then
                    count = count + 1
                    table.insert(grecords, { gdata[1][1], 1})
                    grecords_m[gdata[1][1]] = count
                else
                    grecords[grecords_m[gdata[1][1]]][2] = grecords[grecords_m[gdata[1][1]]][2] + 1
                end
            else
                print("Error on gload: lua/config/SvearkMod_maps.cfg non-existant")
            end
    end
    table.sort(grecords, function (L, R) return L[2] > R[2] end)
    cached_gtop = grecords
    new_record_added = false
    return grecords
end

function say(text, cn)
    if cn == nil then cn = -1 end -- to all
    clientprint(cn, text)
end

function sayexept(text, cn)
    for t = 0, maxclient() - 1 do
        if isconnected(t) and cn ~= t then clientprint(t, text)	end
    end
end

function slice(array, S, E)
    local result = {}
    local length = #array
    S = S or 1
    E = E or length
    if E < 0 then
        E = length + E + 1
    elseif E > length then
        E = length
    end
    if S < 1 or S > length then
        return {}
    end
    local i = 1
    for j = S, E do
        result[i] = array[j]
        i = i + 1
    end
    return result
end

function is_gema(mapname)
    local implicit = { "jigsaw", "deadmeat-10" }
    local code = {
        "g",
        "3e",
        "m",
        "a@4"
    }
    mapname = mapname:lower()
    for k,v in ipairs(implicit) do
        if mapname:find(v) then
            return true
        end
    end
    for i = 1, #mapname - #code + 1 do
        local match = 0
        for j = 1, #code do
            for k = 1, #code[j] do
                if mapname:sub(i+j-1, i+j-1) == code[j]:sub(k, k) then
                    match = match + 1
                end
            end
        end
        if match == #code then
        return true
        end
    end
    return false
end

-- interface to the records

function sorted_records(records)
    local sorted_records = {}
    for player, delta in pairs(records) do
        table.insert(sorted_records, { player, delta })
    end
    table.sort(sorted_records, function (L, R) return L[2] < R[2] end)
    return sorted_records
end


function reverse_sorted_records(records)
    if records == nil then return nil end
    local sorted_records = {}
    for player, delta in pairs(records) do
        table.insert(sorted_records, { player, delta })
    end
    table.sort(sorted_records, function (L, R) return L[2] > R[2] end)
    return sorted_records
end

function add_record(map, player, delta)
    local records = load_records(map)
    if records[player] == nil or delta < records[player] then
        records[player] = delta
        save_records(map, records)
        new_record_added = true
    end
end

function save_records(map, records)
    local sorted_records = sorted_records(records)
    local lines = {}
    for i,record in ipairs(sorted_records) do
        table.insert(lines, record[1] .. " " .. tostring(record[2]))
    end
    cfg.setvalue("SvearkMod_maps", map:lower():gsub("=", ""), table.concat(lines, "\t"))
end

function load_records(map)
    local records = {}
    local data = cfg.getvalue("SvearkMod_maps", map:lower():gsub("=", ""))
    if data ~= nil then
        local lines = split(data, "\t")
        for i,line in ipairs(lines) do
            record = split(line, " ")
            records[record[1]] = tonumber(record[2])
        end
    end
    return records
end

function get_best_record(map)
    -- version f0r3v3
    --[[
    local sorted_records = sorted_records(load_records(map))
    if sorted_records ~= nil then
        local i, best_record = next(sorted_records)
        return best_record[1], best_record[2]
    end
    ]]
    -- version Jg99
    local sorted_records = sorted_records(load_records(map))
    local i, best_record = next(sorted_records)
    if  best_record == nil then
        return PLUGIN_BLOCK
    end  
    if best_record[1] or best_record[2] ~= nil then
        return best_record[1], best_record[2]
    elseif best_record[1] or best_record[2] == nil then
        print("Error returning best_record")
    end
end

function fine_player(cn, fine)
    if fine > 0 then
        if fines[cn] == nil then
            fines[cn] = fine
        else
            fines[cn] = fines[cn] + fine
        end
    end
end

function shuffle(t)
  local n,nf = #t, #t --___ME__ fixed this function so it doesn't always start with the same map every time you reload the server, I just like my random to be random
  while n > 0 do
    local k = math.random(nf)
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
  return t
end

function sendMOTD(cn)
    if not config.gema_mode_is_turned_on then return end
    if cn == nil then cn = -1 end
    if config.gema_mode_is_turned_on then
        say("\f0\fbWelcome \f2VAH \fbGEMA !", cn)
	say("\f2**************************************************************",cn)
    end
    say("\f0TYPE \fI!cmds \f0TO SEE AVAILABLE SERVER COMMANDS", cn)
    say("\fIno account(!login) \f3Beta version!", cn)
        commands["@mapbest"][2](cn, {})
    
end

function onMapChange(mapname, gamemode)
    if config.gema_mode_autodetecting then
        config.gema_mode_is_turned_on = (gamemode == GM_CTF and is_gema(mapname))
        if config.gema_mode_is_turned_on then
            setautoteam(false)
        else
            setautoteam(true)
        end
    end
    sendMOTD()
    if config.randommaprot then
        local maps = getservermaps()
        local maprot = {}
        for i, map in ipairs(maps) do
            if is_gema(map) then
                local entry = {}
                entry["map"] = map
                entry["mode"] = GM_CTF
                entry["time"] = 25
                entry["allowVote"] = 1
                entry["minplayer"] = 0
                entry["maxplayer"] = 0
                entry["skiplines"] = 0
                table.insert(maprot, entry)
            end
        end
        maprot = shuffle(maprot)
        setwholemaprot(maprot)
        --local maprot = getwholemaprot()
        --setwholemaprot(maprot)
        print("(INFO) gRandomizer: maprot got shuffled")
    end
end

function onMaprotRead()
    if not config.randommaprot then return end
    local maps = getservermaps()
    local maprot = {}
    for i, map in ipairs(maps) do
        if is_gema(map) then
            local entry = {}
            entry["map"] = map
            entry["mode"] = GM_CTF
            entry["time"] = 25
            entry["allowVote"] = 1
            entry["minplayer"] = 0
            entry["maxplayer"] = 0
            entry["skiplines"] = 0
            table.insert(maprot, entry)
        end
    end
    maprot = shuffle(maprot)
    setwholemaprot(maprot)
    print(string.format("(INFO) gRandomizer: %d GEMA maps loaded to maprot", #maprot))
end

function colorizetext(text)
    for i = 1, #ccodes do
        text = text:gsub(cclookup[i], ccodes[i])
    end
    return text
end

function hasbadwords(text) --expects forbidden words to be lower case, returns true if there is a match, false if its safe to say
    text = text:lower()
    local oldtext = text
    for i = 1, #forbidden do
        text = text:gsub(forbidden[i], "----")
    end
    if oldtext ~= text then return true else return false end
end

function saycolors(text, sender, cn, team, me)
    if hasbadwords(text) then
        say("\f0Watch your language!", sender)
        logline(2, "[" .. getip(sender) .. "] " .. getname(sender) .. " says: '"  .. text .. "', Forbidden speech")
        return
    end
    if text == nil or sender == nil then return end  --must check for nils cause all arguments are optional when humans write code
    if me == nil then me = false end
    if team == nil then team = false end
    if cn == nil then cn = -1 end
    local senderteam, tempstring, usescolor, melog, teamlog, teamname = getteam(sender), "", false, "", " says:", "CLA"
    if me then melog = "(me) " end --add that to log line if /me is used
    if team then
        if team == 1 then teamname = "RVSF" end
        if team == 4 then teamname = "SPECTATOR" end
        teamlog = " says to team " .. teamname .. ":"
    end
    logline(2, "[" .. getip(sender) .. "] " .. melog .. getname(sender) .. teamlog .. " '"  .. text .. "'")
    if team then
        tempstring = "\f1" .. getname(sender) --use blue player name and text when in team cause the rest of text can be any color
      elseif me then
        tempstring = "\f0" .. getname(sender) .."\f0" --use green player name and green text when public cause the rest of text can be any color
    else
        tempstring = "\f5" .. getname(sender) .."\f0" --use white player name and green text when public cause the rest of text can be any color
    end
    if not me then tempstring = tempstring .. ":" end -- add : for normal text
    local ctext = colorizetext(text)
    if ctext ~= text then usescolor = true end --nedd to see if this needs to be echoed to sender
    tempstring = tempstring .. " " .. colorizetext(text) --add colored text to the string
    for t = 0, maxclient() - 1 do
        if isconnected(t) and (getteam(t) == senderteam or not team) and (cn == t or cn == -1) and (sender ~= t or usescolor) then --yeah, just send it to who should read it
            clientprint(t, tempstring)
        end
    end
end

function show_country(cn, private, acn)
    if webnet == nil then return end
    local iso, name =  webnet:lookup(getip(cn))
    -- capitalize all the words and copy result into 'country' {
    local str = split(name, " ")
    local country = ""
    local i = 1
    while str[i] ~= nil do
        country = country .. " " .. string.sub(str[i],1,1):upper() .. string.sub(str[i],2,string.len(str[i]))
        i = i + 1
    end
  -- }
    if private then
        say(string.format("\fL%s \fTconnected from\fL%s",getname(cn),country),acn)
    else
        say(string.format("\fH%s \fIconnected from\fH%s",getname(cn),country))
    end
end

function CreateMapList()
    local f = assert(io.open("config/maplist.txt", "w+"))
    f:write("Maplist:\n" ..table.concat(getservermaps(), "\n").. "\nTotal map count: " ..#getservermaps().. ".")
    f:close()
end

-- commands
--- params: { admin required, show message in chat, gema mode required }

commands = {

    --- START CHANGED CODE

    --
    --- !cmds
    --- is works
    --

    ["@cmds"] = {
        { false, false, false };
        function (cn, args)
            say("\f0V\f2AH GEMA SERVERS \f0C\f2OMMANDS ))) \fN", cn)
            say("\fN---------------------------------------------------------------------------------------------------------------", cn )
            say("\f0AVAILABLE COMMANDS: \fN| \fI@cmds \fN| \fI@ad <PASSWORD> \fN| \fI@wi \f0optional <CN> \fN| \fI@pm \f0<CN> <TEXT>\fN| \fI@inf \fN| \fI@addtime \f0 <MINUTES> \fN|  \fI@rules \fN| \fI@gemarules \fN| ", cn )
            say("\fN---------------------------------------------------------------------------------------------------------------", cn )
            say("\f0PAM COMMANDS: \fN| \fI@time \fN| \fN| \fI@8ball \fN| \fI@lol \fN|", cn )
            say("\fN---------------------------------------------------------------------------------------------------------------", cn )
            if isadmin(cn) then
                say("\f0ADMIN COMMANDS: \fN| \fI@noad \fN| \fI@toad \f0<CN> \fN| \fI@serverdesc \f0<NAME> \fN| \fI@maplist \fN| \fI@randmrot \f0<FLAG> (1 enable 0 disable) \fN| \fI@colortext \fN| \fI@ext \f0<MINUTES> \fN| \fI@shuffleteams \fN| \fI@auto \fN| \fI@ipbl \fN| \fI@unipbl \fN| \fI@gema \fN| \fI@say \f0<TEXT> \fN| \fI@duplicate \f0 <enabled or disabled> \fN|  \fI@b or @k \f0<CN> \fN|\fI@autokick \fN|", cn)
                say("\fN---------------------------------------------------------------------------------------------------------------", cn )
            end
            say("\fI[SERVER INFO] \f0 " .. getname(cn) .. " \fIis watching server commands.")
        end

    };

    --- AVAILABLE COMMANDS

    --
    --- @ad <PASSWD>
    --- is works
    --

    ["@ad"] ={
        {false, false, false};
        function (cn, args)
            if #args >= 1 then
                local arg = trim(args[1])
                local passwords = getadminpwds()
                for line, password in pairs(passwords) do
                    if arg == password then   
                        if not isadmin(cn) then 
                            if adminstatuscn ~= -1 then
                                setrole(adminstatuscn, 0 )
                                say("\f1Player " ..getname(adminstatuscn).. " it no ADMIN")
                            end
                            adminstatuscn = cn
                            setrole(cn, CR_ADMIN )
                            say("\f1Player " ..getname(cn).. " is ADMIN")
                        end
                        break
                    end
                end              
            else
                say("\f1Empty PASSWORD !!!", cn)
            end
        end
    };

    --
    --- @wi
    --- is works
    --

    ["@wi"] = {
        { false, false, false };
        function (cn, args)
            local sender = cn
            if #args >= 1 then
                cn = tonumber(args[1])
                if cn == nil then
                    say("\f1Wrong cn!", sender)
                    return
                else
                    if not isconnected(cn) then
                        say("\f1Player disconnected", sender)
                        return
                    end
                end
            end
            show_country(cn, true, sender)
            if isadmin(sender) then
                say(string.format("\fZ~\fM~\fZ~\fM~\fZ~ \bl\fXIP\fJ: \f9%s \fZ~\fM~\fZ~\fM~\fZ~",getip(cn)), sender)
            end
        end
    };

    --
    --- @pm <CN> <TEXT>
    --- is works
    --

    ["@pm"] = {
        { false, false, false };
        function (cn, args)
            if #args < 2 then return end
            local to, text = tonumber(args[1]), table.concat(args, " ", 2)
            say(string.format("\fI[SERVER INFO] \f0PM FROM \fI%s (%d)\f0: \fM%s", getname(cn), cn, text), to)
            say(string.format("\fI[SERVER INFO] \f0PM FOR \fI%s \f0HAS BEEN SENT", getname(to)), cn)
        end
    };

    --
    --- @inf
    --- is works
    --

    ["@inf"] = {
        { false, false, false };
        function(cn)
            say("\fESilverCloud\f0 Gema Mod \fIv. 4.2.1 OpenSource , Copyleft 2011-2016 SilverCloudTech (Jg99), No Rights Reserved.", cn)
            say("\fILua AC Executables made by Sveark.", cn)
        end
    };

    --
    --- @addtime <MINUTES>
    --- is works
    --

    ["@addtime"] = {
        { false, false, false };
        function (cn, args)
            if tonumber(args[1]) < 16 and tonumber(args[1]) > 2 then
                settimeleft(tonumber(args[1]))
                say(string.format("\fI[SERVER INFO] \f0 Time remaining changed to %d", args[1]), cn)
            else
                say(string.format("\fI ERROR: Time has to be between 3 and 15 minutes, %s!", getname(cn)), cn)
            end
        end
    };

    --
    --- @rules
    --- is works
    --

    ["@rules"] = {
        {false, false, false};
        function (cn, args)
            local sender = cn
            say("\fI[SERVER INFO] \f0" .. getname(cn) .. ", \fIHere are the server's \fI\fbRULES:", cn)
            say("\fI[SERVER INFO] \f0 SERVER RULES: 1: NO KILLING IN GEMA = \fIBan or Blacklist", cn)
            say("\fI[SERVER INFO] \f0 2: NO cheating/abusive behavior = \fIBan/blaclklist", cn)
            say("\fN ----------------------------------------------------------------------------------------------------", cn)
        end
    };

    --
    --- @gemarules
    --- is works
    --

    ["@gemarules"] = {
        {false, false, false};
        function (cn, args)
            local sender = cn
            say("\fI[SERVER INFO] \f0" .. getname(cn) .. ", \fIHere are the gema \fI\fbRULES:", cn)
            say("\fI[SERVER INFO] \f0 1. No killing in gema, Gema is an obstacle course that ", cn)
            say("\fI[SERVER INFO] \f0 2: you use the AssaultRifle to perform higher jumps, or with a grenade to", cn)
            say("\fI[SERVER INFO] \f0 perform very high jumps. Enjoy!", cn)
        end
    };

    --
    --- @mapbest
    --- is works
    --

    ["@mapbest"] = {
        { false, false, true };
        function (cn)
            local player, delta = get_best_record(getmapname())
            if player ~= nil then
                if delta ~= nil then
                    say(string.format("\f0THE BEST TIME FOR THIS MAP IS \fI%02d:%02d \f0(RECORDED BY \fI%s\f0)", delta / 60, delta % 60, player), cn)
                else
                    print("ERROR")
                end      
            else
                say("\f0NO BEST TIME FOUND FOR THIS MAP", cn)
            end
        end
    };

    --
    --- @mybest
    --- is works
    --

    ["@mybest"] = {
        { false, false, true };
        function (cn)
            local records = load_records(getmapname())
            local delta = records[getname(cn)]
            if delta == nil then
                say("\f0NO PRIVATE RECORD FOUND FOR THIS MAP", cn)
            else
                say(string.format("\f0YOUR BEST TIME FOR THIS MAP IS \fI%02d:%02d", delta / 60, delta % 60), cn)
            end
        end
    };

    --- PAM COMMANDS

    --
    --- @time
    --- is works
    --

    ["@time"] = {
        { false, false, false };
        function (cn, args)
            logline(2, getname(cn).." used !time")
            say("\f0D\f2ate is \f0"  .. os.date("%c"),cn)
        end
    };

    --
    --- @8ball
    --- is works
    --

    ["@8ball"] = {
        { false, false, false };
        function (cn, args)
            logline(2, getname(cn).." used !8ball")
            local question = table.concat(args, " ")
            if question ~= "" then
                say(random_color()..getname(cn).." shakes".. random_color().." the Magic 8 ball...")
                say("\f0"..getname(cn)..": Magic 8 ball, "..question.."?")
                say(random_color().. "Magic 8 ball says: " ..eighttext[math.random(1, #eighttext)])
            else
                say(random_color()..getname(cn) .. "'s" .. random_color().. " magic 8 ball says: " ..eighttext[math.random(1, #eighttext)])
            end
        end
    };

    --
    --- @lol
    --- is works
    --

    ["@lol"] = {
        { false, false, false };
        function (cn, cmd)
            say(random_color().. " [SERVER INFO] " ..random_color()..getname(cn) ..random_color().. ": " ..random_color().. "LoL`:D " ..random_color().. " !!!")
        end
    };


    --- ADMIN COMMANDS

    --
    --- @serverdesc
    --

    ["@serverdesc"] = {
        { true, false, false };
        function (cn, args)
            a = tostring(args[1])
            b = tostring(args[2])
            c = tostring(args[3])
            d = tostring(args[4])
            e = tostring(args[5])
            f = tostring(args[6])
            g = tostring(args[7])
            h = tostring(args[8])
            i = tostring(args[9])
            j = tostring(args[10])
            if b == nil then
                b = "\fE"
            elseif c == nil then
                c = "\fE "
            elseif d == nil then
                d = "\fE "
            elseif e == nil then
                e = "\fE "
            elseif f == nil then
                f = "\fE "
            elseif g == nil then
                g = "\fE "
            elseif h == nil then
                h = "\fE "
            elseif i == nil then
                i = "\fE "
            elseif j == nil then
            j = "\fE "
 
            end
            setservname(string.format("%s %s %s %s %s %s %s %s %s %s", a, b, c, d, e, f, g, h, i, j))
            say("\fE The server name was changed to " ..string.format("%s %s %s %s %s %s %s %s %s %s.", a, b, c, d, e, f, g, h, i, j))  
        end
    };

    --
    --- @maplist
    --- is works
    --

    ["@maplist"] = {
        { true, false, false  };
        function (cn, args)
            say("\f1With too many maps, you and eventually everyone will lag out.\n\fDFile maplist.txt saved to main AC folder in /config\n\f1May not contain all maps due to folder problems of lua.", cn)
            if getservermaps() == nil then
		say("No maps found.", cn)
            else
		CreateMapList()
            end
        end
    };

    --
    --- @noad
    --- is works
    --

    ["@noad"] ={
        {true, false, false};
        function (cn)
            if isadmin(cn) then
                setrole( cn , 0)
                adminstatuscn = -1
                say("\f0Your status ADMIN is disabled :D", cn)
            else
                say("\f0You not ADMIN :D", cn)
            end
        end
    };

    --
    --- @toad <CN>
    --- is works
    --

    ["@toad"] ={
        {true, false, false};
        function (cn,args)
            if isadmin(cn) then
                if #args == 1 then 
                    local to = tonumber(trim(args[1]))
                    if isconnected(to) then
                        setrole(to, CR_ADMIN)
                        adminstatuscn = to
                        say("\f1Player " ..getname(to).. " is ADMIN")
                        setrole( cn , 0)
                        say("\f0Your status ADMIN is disabled :D", cn)
                    else 
                        say("\f1Player <CN=" ..to.. "> not connected", cn)
                    end
                end
            else
                say("\f0You not ADMIN :D", cn)
            end
        end
    };

    --
    --- @randmrot <FLAG> 1 enable 0 disable
    --- is works
    --

    ["@randmrot"] = {
        { true, false, false };
        function (cn, args)
            logline(2, "admincommand !randmrot attempt, "..getname(cn) .. ": "..table.concat(args, " "))
            if args[1]  == "1" then
                config.randommaprot = true
                --onMaprotRead()
                onMapChange()
                say("\f0Random \f2maprot turned \f0ON", cn)
                logline(2, getname(cn).." turned on random maprot")
            elseif args[1] == "0" then
                config.randommaprot = false
                setmaprot("config/maprot.cfg")
                print("(INFO) gRandomizer: default maprot loaded")
                say("\f0Random \f2maprot turned \f0OFF", cn)
                logline(2, getname(cn).." turned off random maprot")
            else
                say("\f0Random \f2maprot is "..(config.randommaprot and "\f0ON"  or "\f0OFF"), cn)
            end
        end
    };

    --
    --- @colortext ---
    --

    ["@colortext"] = {
        { true, false, false };
        function (cn,args)
            colortext  = not colortext
            say("\f0You have " ..(colortext and "enabled" or "disabled").. " colorful text", cn) 
        end
    };

    --
    --- @ext ---
    --

    ["@ext"] = {
        { true, false, true };
        function (cn, args)
            if #args == 1 then
                settimeleft(tonumber(args[1]))
                say("\fI[SERVER INFO] \f0 Time remaining changed!")
            end
        end
    };

    --
    --- @shuffleteams ---
    --

    ["@shuffleteams"] = { 
	{true, false, false};
        function (cn)
            shuffleteams()
        end
    };

    --
    --- @auto ---
    --

    ["@auto"] = {
        { true, true, false };
        function (cn, args)
            config.gema_mode_autodetecting = not config.gema_mode_autodetecting
            say("\fI[SERVER INFO] \f0AUTODETECTING OF GEMA MODE IS TURNED " .. (config.gema_mode_autodetecting and "ON" or "OFF"), cn)
        end
    };

    --
    --- @ipbl ---
    --

    ["@ipbl"] = {
        {true, false, false};
        function (cn, args)
            local name = getname(cn)
	    if not isadmin(cn) then return end
            local ip = ""
            local mask = ""	     
            if #args > 1 then
                local y = split(table.concat(args, " ", 1), " ")
                mask = y[2]
                if mask == "/16" or mask == "/32" or mask == "/24" then
                    if string.len(y[1]) < 3 then 
                        local cnx = tonumber(y[1])
                        if cnx == nil then say("\f0Wrong cn",cn) return end
                        if isadmin(cnx) then return end		   
                        local tempip = getip(cnx)
                        if mask == "/24" then ip = tempip
                        else
                           ip = temp_ip_split(tempip) .. ".0.0"
                        end
                        say(string.format("\fI%s \f0is banned",getname(cnx)))
                        ban(cnx)
                    else
                        ip = y[1]
                    end
                else
                    say("\f0IP blacklist failed. Wrong mask",cn) 
                    return
                end
            else
                if string.len(args[1]) < 7 then
                    local cnx = tonumber(args[1])
                    if isadmin(cnx) then return end    
                    ip = getip(cnx)
                    say(string.format("\fI%s \f0is banned",getname(cnx)))
                    ban(cnx)
                else
                    ip = args[1]
                end
            end
                if ip:match("%d+.%d+.%d+.%d+") == nil then say("\f0Not ip",cn) return end
                os.execute("del config/serverblacklist.cfg.bkp")
                os.execute("cp config/serverblacklist.cfg config/serverblacklist.cfg.bkp")	
                local f = assert(io.open("config/serverblacklist.cfg", "a+"))  
                f:write("\n",ip .. mask .. "\n")
                f:close()
                say(string.format("\fI%s \f0blacklisted by \fI%s",ip .. mask,name))
        end
    };

    --
    --- @unipbl ---
    --

    ["@unipbl"] = {
        {true, false, false};
        function (cn, args)
            if not isadmin(cn) then return end
	    os.execute("rm config/serverblacklist.cfg")
	    os.execute("cp config/serverblacklist.cfg.bkp config/serverblacklist.cfg")
	    say("\fESilverCloud Blacklist has been undone successfully.")
	end
   };

    --
    --- @gema ---
    --

    ["@gema"] = {
        { true, true, false };
        function (cn, args)
            config.gema_mode_is_turned_on = not config.gema_mode_is_turned_on
            say("\fI[SERVER INFO] \f0GEMA MODE IS TURNED " .. (config.gema_mode_is_turned_on and "ON" or "OFF"), cn)
        end
    };

    --
    --- @say ---
    --

    ["@say"] = {
        { true, false, false };
        function (cn,args)
            local text = table.concat(args, " ", 1)
            text = string.gsub(text,"\\f","\f")
            local parts = split(text, " ")
	    say(text)
        end
    };

    --
    --- @duplicate ---
    --

    ["@duplicate"] = {
        { true, false, false };
        function (cn,args)
            dup  = not dup
            say("\f0You have  "..(dup and "enabled" or "disabled").." duplicating text", cn) 
        end
    };

    --
    --- @b --- ban <CN>
    --

    ["@b"] = {
        { true, false, false };
        function (cn, args)
            local name = getname(cn)
	    local cnx = tonumber(args[1])
	    if cn == nil then say("\f0Wrong cn",cn) return end
            say(string.format("\fI[SERVER INFO] \fI" .. getname(cnx) .. "\f0 was banned by \fI" .. getname(cn) .. "\f0. IP: \f0" .. getip(cnx) ))
	    ban(cnx)
        end
    };

    --
    --- @k --- kick <CN>
    --

    ["@k"] = {
        { true, false, false };
        function (cn, args)
            local name = getname(cn)
	    local cnx = tonumber(args[1])
	    if cn == nil then say("\f0Wrong cn",cn) return end
	    say(string.format("\fI[SERVER INFO] \fI" .. getname(cnx) .. "\f0 is kicked by \fI" .. getname(cn) .. "\f0!"))
	    disconnect(cnx, DISC_MKICK)
            say("\fI[SERVER INFO]\f0  " ..getname(acn).. "\f0 was kicked. IP:" ..getip(acn).. ".")
        end
    };

    --
    --- @autokick
    --

    ["@autokick"] = {
        { true, false, false };
        function (cn, args)
            autogemakick = not autogemakick
            say("\f0You have " ..(autogemakick and "enabled" or "disabled").. " auto gema and teamkill kick.", cn) 
        end
    };

    --- END CHANGED CODE

}

-- handlers

function onPlayerDeathAfter(tcn, acn, gib, gun)
    if acn ~= tcn and config.gema_mode_is_turned_on and autogemakick and isTeammode(getgamemode()) then
        local totalkills = getfrags(acn) + getteamkills(acn) * 2
        if totalkills >= 3 then
            say("\f0Player \f0" .. getname(acn) .. "has been autobanned for \fI gema killing. \f0 IP-address:" .. getip(acn))
            ban(acn)
        elseif totalkills then
            -- disconnect(acn, DISC_MKICK)
            say("\f0Player \fI" .. getname(acn) .. "\f0 has been autokicked for \fI gema killing.")
            disconnect(acn, DISC_MKICK)
        end
    end
end

-- version Jg99
function onPlayerSayText(cn, text)
    text2 = string.format("SCLog: Player %s says: %s. Their IP is: %s",getname(cn):gsub("%%", "%%%%"), text:gsub("%%", "%%%%") ,getip(cn))
    logline(4, text2)
    if colortext then
        text = string.gsub(text,"\\f","\f")
        local parts = split(text, " ")
        local command, args = parts[1], slice(parts, 2)
        if commands[command] ~= nil then
            local params, callback = commands[command][1], commands[command][2]
            if (isadmin(cn) or not params[1]) and (config.gema_mode_is_turned_on or not params[3]) then
                callback(cn, args)	  
                    if not params[2] then
                        return PLUGIN_BLOCK
                    end
            else
                return PLUGIN_BLOCK
            end
        end
	if isadmin(cn) then
            SayToAllA(text,cn)
            return PLUGIN_BLOCK
	else
            SayToAll(text,cn)
            return PLUGIN_BLOCK
	end
        --logtext = string.gsub("player" .. getname(cn) .. "says:" .. text .. ". IP-address "..getip(cn).. " has been logged") --Output text to Log
        --logline(3, logtext)
    else
        local parts = split(text, " ")
        local command, args = parts[1], slice(parts, 2)
        if commands[command] ~= nil then 
            local params, callback = commands[command][1], commands[command][2]
            if (isadmin(cn) or not params[1]) and (config.gema_mode_is_turned_on or not params[3]) then
                callback(cn, args)
                if not params[2] then
                    return PLUGIN_BLOCK
                end
            else
                return PLUGIN_BLOCK
            end
        end
        if isadmin(cn) then
            SayToAllA(text,cn)
            return PLUGIN_BLOCK
        else
            SayToAll(text,cn)
            return PLUGIN_BLOCK
        end
    end
end

--[[
 -- version f0r3v3
function onPlayerSayText(cn, text, team, me) --added mute june 14, 2013
    local parts = split(text, " ")
    local command, args = parts[1], slice(parts, 2)
    local sender = cn
    local originaltext = text
    if not ismuted[sender] then
        if commands[command] ~= nil then
            local params, callback = commands[command][1], commands[command][2]
            if (isadmin(cn) or not params[1]) and (config.gema_mode_is_turned_on or not params[3]) then
                callback(cn, args)
                if not params[2] then
                    return PLUGIN_BLOCK
                end
            else --needed admin to process command so ignore it
                logline(2, getname(cn).." failed admincommand: "..text)
                return PLUGIN_BLOCK
            end
        elseif string.byte(command,1) == string.byte("!",1) then
            logline(2, getname(cn)..", unknown command: "..text)
            say("\f0! Command not understood, check spelling or try !cmds", cn)
            return PLUGIN_BLOCK
        else
            saycolors(text, cn, -1, team, me) --to add colors to text
            return PLUGIN_BLOCK
        end
    else
        logline(2, "**Muted player " .. getname(sender) .. "(" .. sender .. "): " .. text)
        --say("You have been muted, msg not sent!", cn)--can enable if you want them to know but they may just reconnect
        return PLUGIN_BLOCK
    end
end
]]
function SayToAll(text, except)
    for n=0,20,1 do
        -- if isconnected(n) and n ~= except then
	if dup then
            say("\f0|\fX" .. except .. "\f0|\fI#\f0" .. getname(except) .. ":\fE " .. text,n)
        elseif isconnected(n) and n ~= except then
            say("\f0|\fX" .. except .. "\f0|\fI#\f0" .. getname(except) .. ":\fE " .. text,n)
	end
	-- end
     end
end
   
function SayToAllA(text, except)
    for n=0,20,1 do
        -- if isconnected(n) and n ~= except then
        if dup then
            say("\f0|\fX" .. except .. "\f0|\fI#\f0" .. getname(except) .. ":\fE " .. text,n)
	elseif isconnected(n) and n ~= except then
            say("\f0|\fX" .. except .. "\f0|\fI#\f0" .. getname(except) .. ":\fE " .. text,n)
	end
	-- end
    end
end
   
function SayToAll2(text, except)
    if isconnected(n) and n ~= except then
        say("\fI[SERVER INFO] \f0",text,n)
    end
end

function onPlayerNameChange (cn, new_name)
    say("\fI[SERVER INFO] \f0" .. getname(cn) .. " \fIchanged name to \f0" .. new_name .. "!")
end

function onPlayerSendMap(map_name, cn, upload_error)
    if is_gema(map_name) then
        say("\fISERVER INFO] \f0Gema Check: \fE Map is a gema!, You may vote it now!", cn)
        upload_error = UE_NOERROR
    else
        say("\fI[SERVER INFO]\f0 Gema Check: \fI Map is NOT a gema. You may not upload non-gema maps.", cn)
        upload_error = UE_IGNORE
        return upload_error
    end
end


if config.gema_mode_autodetecting then
   -- config.gema_mode_is_turned_on = (gamemode == GM_CTF and is_gema(mapname))
end

sendMOTD()
settimeleft(tonumber(25))
setautoteam(false)
local records = load_records(getmapname())
local delta = records[getname(cn)]
if delta == nil then
    say("\f0NO PRIVATE RECORD FOUND FOR THIS MAP", cn)
else
    say(string.format("\f0YOUR BEST TIME FOR THIS MAP IS \fI%02d:%02d", delta / 60, delta % 60), cn)
end
    

function onPlayerConnect(cn)
    sendMOTD(cn)
    say("\f3Hello \fI" .. getname(cn) .. "!") 
    show_country(cn, false)
    --say("\fI[SERVER INFO]" .. getname(cn) .. "\fIconnected!!! with ip \f0" .. getip(cn) .. "")
    setautoteam(false)
end

function onPlayerDisconnect(acn, reason)
	if reason == DISC_MASTERMODE and mmmsg then
		say("\fI" ..getname(acn).. "\f1 could not connect. [\fIMastermode\f1]")
	elseif reason == DISC_MAXCLIENTS and mcmsg then
		say("\fI" ..getname(acn).. "\f1 could not connect. [\fIServer full\f1]")
	elseif reason == DISC_BANREFUSE and banmsg then
		say("\fI" ..getname(acn).. "\f1 could not connect. [\fIBanned\f1]")
	end
end

function onPlayerCallVote(cn, type, text, number)
    if (type == SA_AUTOTEAM) and (not getautoteam()) then
        voteend(VOTE_NO)
    elseif (type == SA_FORCETEAM) or (type == SA_SHUFFLETEAMS) then
        voteend(VOTE_NO)
    end
    if (type == SA_MAP) and not (number == GM_CTF) then voteend(VOTE_NO) end
    if (type == SA_GIVEADMIN) or (type == SA_CLEARDEMOS) then voteend(VOTE_NO) end
    -- if (type == SA_BAN) or (type == SA_KICK) or (type == SA_REMBANS) or (type == --SA_GIVEADMIN) then
    --      voteend(1)
    -- end
    --if number ~= 5 then
        --voteend
        --if (type == SA_BAN) or (type == SA_KICK) then
            --voteend(1)
        --end
    setautoteam(false)
end

function onFlagAction(cn, action, flag)
    if action == FA_DROP or action == FA_LOST then
        flagaction(cn, FA_RESET, flag)
    end
    if config.gema_mode_is_turned_on and action == FA_SCORE then
        if start_times[cn] == nil then return end
        local delta = math.floor((getsvtick() - start_times[cn]) / 1000)
        start_times[cn] = nil
        if delta == 0 then return end
        if fines[cn] ~= nil then
            delta = delta + fines[cn]
            fines[cn] = nil
        end
        say(string.format("\f0%s \f9||||\fH++++++++++SCORED AFTER \fA%02d:%02d \f0min.\fH++++++++++\f9||||", getname(cn), delta / 60, delta % 60, delta *1000))
        add_record(getmapname(), getname(cn), delta)
        local best_player, best_delta = get_best_record(getmapname())
        if best_delta == delta then
            say("\fI~~~~~~*** \f0\fbNEW BEST TIME RECORDED! \fI***~~~~~~")
        end
    end
end

function onPlayerVote(actor_cn, vote)
    say("\fI[SERVER INFO] \f0Player " .. getname(actor_cn) .. "\fI(\fE".. actor_cn .. "\fI)\fE voted \f0F" .. vote .. "\fN!")
end

function onMapEnd()
    say("\f0 GG!  \fEThanks for playing a game with us!")
end
 
function temp_ip_split(ip)
    local x,y
    local xt = false
    local yt = true
    for i=1,string.len(ip),1 do
        if string.sub(ip,i,i) == "." then
            if yt == false then
                y = i
                break
            end
            if xt == false then
                xt = true
                yt = false
                x = i
            end
        end
    end
    return string.sub(ip,1,y-1)
end

function RandomMessages()
    local messages = {"\fI[SERVER INFO] \f0 No killing in gema! \fI Or ban/blacklist!", "\fI[SERVER INFO] \f0Visit =AoW= clan site at http://acaowforum.tk", "\fI\fI[SERVER INFO] \fICheating is not allowed. Cheaters will be blacklisted and/or reported.", "\fI[SERVER INFO] \fE Laggers don't matter in a gema!", "\fI[SERVER INFO] \fI Abusive behavior/trolling is not allowed, and may result in a \fB ban/blacklist.", "\fI[SERVER INFO] \f0 Have fun playing gemas on SilverCloud Gema server!", "\fI[SERVER INFO] \f0 Look for other \fESilverCloud\fN\fE=\f0A\fIo\fIW\fE= \f0Servers!", "\fI[SERVER INFO] \f0 Contact Jg99 on IRC or on forum.cubers.net!", "\fI[SERVER INFO] \f0 This gema server has a !whois (CN) cmd so you can view where players connected from (country)!"}
    clientprint(-1, messages[math.random(#messages)])
end

function ChangeServerName()
    local names = {"\fE Come Play @ SilverCloud Gemas", "\fEsctechusa.com is the main site!", "\fENo gameplay-modifying commands are used!", "\fE Hosted by \fNJg99!", "\fE SilverCloud Gemas has a wide selection of gemas!", "\fE  SilverCloud Gema server has useful stuff, like a gema timer!", "\fE SAVE GEMAS NOW -  SilverCloud Gemas"}
    setservname(names[math.random(#names)])
end

function DisableAutoTeam5Secs()
    setautoteam(false)
end

function onInit()
    print("(!) Initializing IP database...")
    webnet = webnet77.new("lua/extra/IpToCountry.csv")
    if webnet ~= nil then print("(!) OK")
    else print("(!) FAIL") end
    --tmr.create(9,9 * 60 * 1000, "RandomMessages") -- every 5 minutes
    --tmr.create(1,7 * 60 * 1000, "ChangeServerName") -- every 5 seconds
    tmr.create(2,7 * 1 * 1, "DisableAutoTeam5Secs") -- every 5 ms i think
    setautoteam(false)
    setnickblist("config/nicknameblacklist.cfg")
    setblacklist("config/serverblacklist.cfg")
    --onMaprotRead()
    onMapChange() --shuffle maprot
end

function onDestroy()
    --tmr.remove(1)
    tmr.remove(2)
    --tmr.remove(9)
end

function onPlayerSpawn(cn)
    start_times[cn] = getsvtick()
    fines[cn] = nil
    setautoteam(0)
end
