PLUGIN_NAME = "vah_sdbs open source version"
PLUGIN_AUTHOR = "SDBS" -- sensor-dream
PLUGIN_VERSION = "1.0.4" -- black lua mod

SDBS_NAN = "NaN"

__sdbs = {
    name = "vah_sdbs",
    path = {
        base = "./",
        lua = "./lua/",
        extra = "./lua/extra/",
        config = "./lua/config/",
        sdbs = "./lua/scripts/vah_sdbs/"
    },
    config = {
        -- Обворачивает имя игрока в spirit-{ <NAME> }->
        isspirrit = true,
        -- Авто ресет флаг при потере сбросе флаг или гибели игрока
        resetflag = true,
        -- автоопределение режима игры или карты gema
        autodetectingmode = true,
        configrandommaprot = false --I like randomness
    },
    webnet = nil,
    player = nil
}

-- Задаем пути поиска

package.path = __sdbs.path.sdbs.. "?.lua; " ..__sdbs.path.extra.. "?.lua; " ..__sdbs.path.lua..  "?.lua; " ..__sdbs.path.base..  "?.lua;"

-- Подключаем библиотеки

--dofile("lua/scripts/vah_sdbs/function.lua")
require("function")
require("fs")
require("server")
require("webnet")

__sdbs.player = {
    flag = {
        time = 5,
        action = {
            --[[
            [FA_PICKUP] = function (cn,flag) end,
            [FA_STEAL] = function (cn, flag) flagaction(cn, FA_RESET, flag) end,
            [FA_RETURN] = function (cn,flag) end,
            [FA_SCORE] = function (cn, flag) end,
            [FA_RESET] = function (cn, flag) end
            ]]
            [FA_DROP] = function (cn, flag) flagaction(cn, FA_RESET, flag) end,
            [FA_LOST] = function (cn, flag) flagaction(cn, FA_RESET, flag) end
        }
    },
    info = {
        data = {},
        config = {
        },
        gametime = function (self,cn)
            if self.data[cn] ~= null then
                return getsvtick() - self.data[cn].starttime
            end
            return 0
        end,
        inituser = function (self, cn, enet )
            if isconnected(cn) and cn >= 0 and cn < maxclient() then
                local data = { iso = SDBS_NAN, country = SDBS_NAN, ip = SDBS_NAN }
                if enet ~= nil then 
                    data = enet.geo(enet,cn)
                end    
                if self.data[cn] == nil then
                    self.data[cn] = {
                        name = getname(cn),
                        iso = data.iso,
                        country = data.country,
                        ip = data.ip,
                        role = isadmin(cn),
                        frags = SDBS_NAN,
                        flagscore = SDBS_NAN,
                        deaths = SDBS_NAN,
                        teamkills = SDBS_NAN,
                        shotdamage = SDBS_NAN,
                        damage = SDBS_NAN,
                        points = SDBS_NAN,
                        forced = SDBS_NAN,
                        events = SDBS_NAN,
                        lastdisc = SDBS_NAN,
                        reconnections = SDBS_NAN,
                        team = SDBS_NAN,
                        starttime = getsvtick(),
                        endtime = self:gametime(cn)
                    }
                    return self.data[cn]
                end
            end
            return nil;
        end,
        unsetuser = function (self,cn)
           if self.data[cn] ~=nil then self.data[cn] = nil end
        end,
        get = function (self, cn) 
            if cn ~= nil and isconnected(cn) then
                if self.data[cn] ~=nil then
                    return self.data[cn]
                end
            end
            return {
                    name = SDBS_NAN,
                    iso = SDBS_NAN,
                    country = SDBS_NAN,
                    ip = SDBS_NAN,
                    role = SDBS_NAN,
                    frags = SDBS_NAN,
                    flagscore = SDBS_NAN,
                    deaths = SDBS_NAN,
                    teamkills = SDBS_NAN,
                    shotdamage = SDBS_NAN,
                    damage = SDBS_NAN,
                    points = SDBS_NAN,
                    forced = SDBS_NAN,
                    events = SDBS_NAN,
                    lastdisc = SDBS_NAN,
                    reconnections = SDBS_NAN,
                    team = SDBS_NAN,
                    starttime = SDBS_NAN,
                    endtime = SDBS_NAN
            }
        end,
        isspect = function (team)
            return team > 1 and team <= 4
        end,
        isactive = function (team)
            return team == 0 or team == 1
        end,
        cnadmin = function ()
            for i = 0, maxclient() - 1 do
                if isadmin(i) then
                    return i
                end
            end
            return nil
        end,
        nameadmin = function (self, cn)
            return slef.cnadmin(cn) or nil
        end
    }
}

__sdbs.new = function ()
    local self = setmetatable({},{__index=__sdbs}) 
    return self
end

sdbs = __sdbs.new();

-- lookup global function

function onInit()
    sdbs.webnet = webnet:new(sdbs.path.sdbs.."IpToCountry.csv")
end

function onDestroy()
end

function onMapStart()
end

function onMapEnd()
    say("\f0 hg!  \fEThanks all!")
end

--(string map_name, int game_mode)
function onMapChange(name, mode)
end

--(int actor_cn)
function onPlayerPreconnect(cn)
    if sdbs.config.isspirrit then setname(cn,"spirit-{ " ..(getname(cn)).. " }->") end
end

--(int actor_cn)
function onPlayerConnect(cn)
    local info = sdbs.player.info:inituser(cn,sdbs.webnet)
    if info ~= nil then
        if isadmin(i) then 
            sayex(string.format("\f1Player \f2%s (\f1%s\f2) \f1came from \f5%s\f1, \f2%s\f1, IP : \f2%s",info.name,cn,info.country, info.iso ,info.ip),cn)
        else
            sayex(string.format("\f1Player \f2%s (\f1%s\f2) \f1came from \f5%s\f1, \f2%s",info.name,cn,info.country, info.iso),cn)
        end
--[[
        for i = 0, maxclient() - 1 do
            --if isconnected(i) then
            if isconnected(i) and i ~= cn then
                if isadmin(i) then
                    say(string.format("\f1Player \f2%s (\f1%s\f2) \f1came from \f5%s\f1, \f2%s\f1, IP : \f2%s",info.name,cn,info.country, info.iso ,info.ip),i)
                else
                    say(string.format("\f1Player \f2%s (\f1%s\f2) \f1came from \f5%s\f1, \f2%s",info.name,cn,info.country, info.iso),i)
                end
            end
        end
]]
        say("\f3Hello \f2 " ..info.name.. " (\f1" ..cn.. "\f2) \f3:D ",cn) 
    end
end

--(int actor_cn, int reason)
function onPlayerDisconnectAfter(cn,reason)
end

--(int actor_cn, int reason)
function onPlayerDisconnect(cn, reason)
    say(string.format("\f3:( Goodbye my baby \f2s% \f3:("),(sdbs.player.info:get(cn)).name) 
    sdbs.player.info:unsetuser(cn)
end

--(int actor_cn, int new_role, string hash, int adminpwd_line, bool player_is_connecting)
function onPlayerRoleChange(cn, new_role, hash, pwd, isconnect)
    if new_role == CR_ADMIN then
        (sdbs.player.info.get(cn)).role = CR_ADMIN
    else
        (sdbs.player.info.get(cn)).role = CR_DEFAULT
    end
end

--(int sender_cn, string message, bool team, bool me)
function onPlayerSayText(cn, message,team,me)
end

-- (int actor_cn, int target_cn, int damage, int actor_gun, bool gib)
function onPlayerDamage(cn, tcn, damage, gun, gib)
end

--(int target_cn, int actor_cn, bool gib, int gun)
function onPlayerDeath(tcn, cn,gib,gun)
end

--(int actor_cn)
function onPlayerSpawn(cn)
end

function onFlagAction(cn, action, flag)
     if sdbs.config.resetflag then sdbs.player.flag.action[action](cn, flag) end
end
