PLUGIN_NAME = "vah_sdbs OpenSource version"
PLUGIN_AUTHOR = "SDBS" -- sensor-dream
PLUGIN_VERSION = "1.0.4" -- black lua mod

__sdbs = {
    name = "vah_sdbs",
    path = {
        base = "./",
        lua = "./lua/",
        extra = "./lua/extra/",
        sdbs = "./lua/scripts/vah_sdbs/"
    },
    config = {
        gema_mode_autodetecting = true,
        gema_mode_is_turned_on = tru,
        configrandommaprot = false --I like randomness
    },
    webnet = nil
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
        reset = function(cn, action, flag)
            if action == FA_DROP or action == FA_LOST then
                flagaction(cn, FA_RESET, flag)
            end
        end
    },
    info = {
        data = {},
        get = function (self, cn) 
            if isadmin(cn) then
                say(string.format("\fI%s \f0connected from \fI%s \fIip: \f0%s",self.data[cn].name,self.data[cn].country,self.data[cn].ip,cn))
            else
                say(string.format("\fI%s \f0connected from \fI%s",self.data[cn].name,self.data[cn].country,cn))
            end
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
        end
    }
}

__sdbs.new = function ()
    local self = setmetatable({},{__index=__sdbs})
    --local self = setmetatable({},{__index=_M})   
    return self
end

sdbs = __sdbs.new();

-- lookup global function

function onInit()
    sdbs.webnet = webnet.new(sdbs.path.sdbs.. "IpToCountry.csv")
end

function onDestroy()
end

function onMapStart()
end

function onMapEnd()
end

function onPlayerConnect(cn)
    say("\f3Hello \fI" .. getname(cn) .. "!") 
    sdbs.player.info.data[cn] = sdbs.webnet:country(cn)
    --sdbs.player.info:get(cn)
    for i = 0, maxclient() - 1 do
        if isconnected(i) and i ~= cn then
            if isconnected(i) then
                sdbs.player.info:get(cn)
            end
        end
    end
    --say("\fI[SERVER INFO]" .. getname(cn) .. "\fIconnected!!! with ip \f0" .. getip(cn) .. "")
end

function onPlayerDisconnect(cn, reason)
    sdbs.player.info.data[cn] = nil
end

function onPlayerSpawn(cn)
end

function onFlagAction(cn, action, flag)
    sdbs.player.flag.reset(cn, action, flag)
end
