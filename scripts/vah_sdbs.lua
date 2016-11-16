PLUGIN_NAME = "vah_sdbs open source version"
PLUGIN_AUTHOR = "SDBS" -- sensor-dream
PLUGIN_VERSION = "1.0.5" -- black lua mod

--module("SDBS", package.seeall)

-- Для работы со строками

__sdbs = __sdbs

__sdbs = {
    name = "vah_sdbs.lua",
    path = {
        base = "./",
        lua = "./lua/",
        extra = "./lua/extra/",
        config = "./lua/config/",
        sdbs = "./lua/scripts/vah_sdbs/",
        webnetdata = "./lua/scripts/vah_sdbs/IpToCountry.csv"
    },
    config = nil,
    webnet = nil,
    log = nil,
    say = nil,
    game = nil,
    player = nil
}


-- Задаем пути поиска

package.path = __sdbs.path.sdbs.. "?.lua; " ..__sdbs.path.extra.. "?.lua; " ..__sdbs.path.lua..  "?.lua; " ..__sdbs.path.base..  "?.lua;"

-- Подключаем библиотеки

--dofile("lua/scripts/vah_sdbs/function.lua")
require("config")
require("function")
require("fs")
require("server")
require("webnet")
require("say")
require("game")
require("player")
require("commands")

__sdbs.new = function ()
    local self =  setmetatable({},{__index=__sdbs})
    return self
end

sdbs = sdbs
sdbs = __sdbs:new();

-- lookup global function

function onInit()
    --sdbs.cursor = getservername()
    sdbs.webnet = webnet:new(sdbs.path.webnetdata)

    sdbs.log.root = setmetatable({},{__index = sdbs})
    sdbs.say.root = setmetatable({},{__index = sdbs})

    sdbs.game.root = setmetatable({},{__index = sdbs})
    sdbs.game.vote.root = setmetatable({},{__index = sdbs})
    sdbs.game.mode.root = setmetatable({},{__index = sdbs})

    sdbs.player.root = setmetatable({},{__index = sdbs})
    sdbs.player.flag.root = setmetatable({},{__index = sdbs})
    sdbs.player.info.root = setmetatable({},{__index = sdbs})
    sdbs.player.commands.root = setmetatable({},{__index = sdbs})

    -- sdbs.say:setCursorInfoState()
end

function onDestroy()
end

        -- GM_DEMO - -1,GM_TDM - 0,GM_COOP - 1,GM_DM - 2,
        -- GM_SURV - 3,GM_TSURV - 4,GM_CTF - 5,GM_PF - 6,
        -- GM_LSS - 9,GM_OSOK - 10,GM_TOSOK - 11,GM_HTF - 13,
        -- GM_TKTF - 14,GM_KTF - 15,GM_NUM - 22
--(string map_name, int game_mode)
function onMapChange(mapname,modemap)
    if sdbs.config.autoDetectingMode then sdbs.game.mode:getmode(modemap,mapname) end
    sdbs.game.mapname = mapname
    -- sdbs.say:setCursorInfoState(sdbs.game.mode.mode,sdbs.game.mapname)
    sdbs.game.mapgema = sdbs.game:chkGema(sdbs.game.mapname)
    
    if sdbs.config.map.say.loadMap and not sdbs.game.mapgema then sdbs.say:onMapChange(0, sdbs.game.mapname, sdbs.game.mode.mode) end    
    if sdbs.config.map.say.loadMapGema and sdbs.game.mapgema then sdbs.say:onMapChange(1, sdbs.game.mapname, sdbs.game.mode.mode) end
    
    if sdbs.config.map.team.auto.map == true and ( modemap == GM_TDM or modemap == GM_TSURV or modemap == GM_CTF or modemap == GM_TOSOK  or modemap == GM_TKTF ) then
        if sdbs.game.mapgema and not sdbs.config.team.auto.gema then setautoteam(false) else setautoteam(true) end
    end
end


--(int actor_cn)
function onPlayerConnect(cn)
    local info = sdbs.player.info:setuser(cn)
    local cn = sdbs.player.info:whoadmin()
    if info ~= nil then
        if cn ~= nil then
            sdbs.say:onPlayerConnect(0,info,cn)
        else
            sdbs.say:onPlayerConnect(1,info)
        end
        sdbs.say:onPlayerConnect(2,info)
        --sdbs.log:inf("Player connect",cn)
    end
    --setautoteam(false)
end

--(int actor_cn, int reason)
function onPlayerDisconnectAfter(cn,reason)
end

--(int actor_cn, int reason)
function onPlayerDisconnect(cn, reason)
  if reason == DISC_MASTERMODE then
	sdbs.say:err("\f0" ..getname(cn).. "\f2 could \f0not \f2connect. [\f0Mastermode\f2]")
  elseif reason == DISC_MAXCLIENTS then
	sdbs.say:err("\f0" ..getname(cn).. "\f2 could \f0not \f2connect. [\f0Server full\f2]")
  elseif reason == DISC_BANREFUSE then
	sdbs.say:err("\f0" ..getname(cn).. "\f2 could \f0not \f2connect. [\f0Banned\f2]")
  end
    sdbs.say:onPlayerDisconnect(cn,reason)
    sdbs.player.info:unsetuser(cn)
end

--(int actor_cn, int old_role, string hash, int adminpwd_line, bool player_is_connecting)
function onPlayerRoleChangeAfter(cn, old_role, hash, admpwd, isconnecting)
end

--(int actor_cn, int new_role, string hash, int adminpwd_line, bool player_is_connecting)
function onPlayerRoleChange(cn, new_role, hash, pwd, isconnect)
    local name = getname(cn)
    if (sdbs.player.info:getoldname(cn)) == name then
        if new_role == CR_ADMIN then
            sdbs.player.info.data[cn].role = CR_ADMIN
            if sdbs.config.onSayAdminRoleChanged then sdbs.say:onPlayerRoleChange(0,cn,name) end
        else
            sdbs.player.info.data[cn].role = CR_DEFAULT
            if sdbs.config.onSayAdminRoleChanged then sdbs.say:onPlayerRoleChange(1,cn,name) end
        end
    else
        if sdbs.config.disconnectLoLadmin then 
            sdbs.say:onPlayerRoleChange(2,cn,name)
            sdbs.player.info:unsetuser(cn)
            disconnect(cn, DISC_BADNICK)
        else
            setrole(cn, CR_DEFAULT)
        end
    end
end

--(int actor_cn, string new_name)
function onPlayerNameChange(cn, newname)
    if sdbs.player.info:is(cn) then 
        if  not sdbs.config.allowSameName then
            for i = 0, #sdbs.player.info.data do
                if sdbs.player.info:is(i) and ( sdbs.player.info.data[i].name == newname or sdbs.player.info.data[i].oldname == newname )  then
                    sdbs.say:onPlayerNameChange(0,cn,newname)
                    sdbs.player.info:unsetuser(cn)
                    disconnect(cn, DISC_BADNICK)
                    return nil
                end
            end
        end
        sdbs.say:onPlayerNameChange(1,cn,newname)
        sdbs.player.info.data[cn].oldname = sdbs.player.info.data[cn].name
        sdbs.player.info.data[cn].name = newname
    end
end

function onFlagAction(cn, action, flag)
    if action == FA_DROP or action == FA_LOST then sdbs.player.flag:reset(cn,flag) end
end

-- int (vote error); (int actor_cn, int type, string text, int number, int vote_error)
function onPlayerCallVote (cn, type, text, number, vote_error)
    
    local info = sdbs.player.info:get(cn)
    if info.cn ~=nil then
        if type == SA_AUTOTEAM and not getautoteam() then
            voteend(VOTE_NO)
            say("\f3You don't have the permission to set autoteam on", cn)
        end
        
    end
    
    
--[[    
1
    if type == SA_AUTOTEAM and not getautoteam() then
        voteend(VOTE_NO)
        say("\f3You don't have the permission to set autoteam on", cn)
    elseif (type == SA_FORCETEAM) or (type == SA_SHUFFLETEAMS) then
        say("\f3You don't have the permission to vote that", cn)
        voteend(VOTE_NO)
    elseif type == SA_MAP then
        if number ~= GM_CTF then
            if number == 21 then
                if nextmap ~= nil then setnextmap(nextmap) end
                say("\f3You don't have the permission to use this command", cn)
            else
                say("\f3Only CTF mode is allowed", cn)
            end
            voteend(VOTE_NO)
        elseif not isGema(text) then
            say("\f3This map doesn't seem to be a gema", cn)
            voteend(VOTE_NO)
        elseif ismodo(cn) then
            voteend(VOTE_YES)
        end
    elseif type == SA_MASTERMODE and not isadmin(cn) then
        if number ~= 0 then
            say("\f3You don't have the permission to vote that", cn)
            voteend(VOTE_NO)
        end
    elseif type == SA_KICK and ismodo(cn) then
        voteend(VOTE_YES)
    elseif type == SA_BAN and ismodo(cn) then
        voteend(VOTE_YES)
    end

2

  if type == SA_MAP and not isadmin(cn) then
    if not votes[number] then
      voteend(VOTE_NO)
    end
  end
  if ismuted[cn] then
    voteend(VOTE_NO)
  end
  if (type == SA_GIVEADMIN) and getname(cn) ~= protectedname then
    voteend(VOTE_NO)
    say("\f0Vote Type Disallowed", cn)
  end
  
    if (type == SA_AUTOTEAM) and (not getautoteam()) then
        voteend(VOTE_NO)
    elseif (type == SA_FORCETEAM) or (type == SA_SHUFFLETEAMS) then
        voteend(VOTE_NO)
end

3

	if (type == SA_MAP) and not (number == GM_CTF) then voteend(VOTE_NO) end
        if (type == SA_GIVEADMIN) or (type == SA_CLEARDEMOS) then voteend(VOTE_NO) end
 -- if (type == SA_BAN) or (type == SA_KICK) or (type == SA_REMBANS) or (type == --SA_GIVEADMIN) then
  --      voteend(1)
 --   end
--if number ~= 5 then
--voteend

--if (type == SA_BAN) or (type == SA_KICK) then
--voteend(1)
--end


setautoteam(false)
]]
end

--(int result, int owner_cn, int type, string text, int number
function onVoteEnd()
    
end

--(int actor_cn, int vote)
function onPlayerVote(cn, vote)
    
end

-- (int actor_cn, int sound
function onPlayerSayVoice(cn,sound)

end

--(int sender_cn, string message)
function onPlayerSayText(cn, text)

end

function LuaLoop()

end