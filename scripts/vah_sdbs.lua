PLUGIN_NAME = "vah_sdbs open source version"
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
        reset = function(self,cn, action, flag)
            if action == FA_DROP or action == FA_LOST then
                flagaction(cn, FA_RESET, flag)
            end
        end
    },
    info = {
        data = {},
        config = {
        },
        inituser = function (self, cn, enet )
            if enet ~= nil and cn >= 0 and cn < maxclient() then
                local data = enet.geo(enet,cn)
                print (data.iso)
                if self.data[cn] == nil then
                    self.data[cn] = {
                        name = getname(cn),
                        iso = data.iso,
                        country = data.country,
                        ip = data.ip,
                        role = isadmin(cn),
                        time = {
                            start = getsvtick(),
                            gametime = function ()
                                return getsvtick() - self.start
                            end
                        }
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
            return nil
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
    --local self = setmetatable({},{__index=_M})   
    return self
end

sdbs = __sdbs.new();

-- lookup global function

function onInit()
    sdbs.webnet = webnet:new(sdbs.path.sdbs.."IpToCountry.csv")
    --sdbs.webnet = webnet:new()
    --sdbs.webnet:load(sdbs.path.sdbs .. "IpToCountry.csv")
    --if sdbs.webnet ~= nil then print ("Init webnet") else print ("Not init webnet") end
end

function onDestroy()
end

function onMapStart()
end

function onMapEnd()
end

function onPlayerConnect(cn, reason)
    local info = sdbs.player.info:inituser(cn,sdbs.webnet)
    --local info = sdbs.player.info:get(cn)
    if info ~= nil then
        -- local config = sdbs.player.info.config
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
        say("\f3Hello \f2 " ..info.name.. " (\f1" ..cn.. "\f2) \f3:D ",cn) 
    end
end

function onPlayerDisconnect(cn, reason)
    sdbs.player.info:unsetuser(cn)
    say("\f3:( Goodbye my baby \f2 " ..getname(cn).. " \f3:(") 
end

function onPlayerSpawn(cn)
end

function onFlagAction(cn, action, flag)
    sdbs.player.flag.reset(cn, action, flag)
end
