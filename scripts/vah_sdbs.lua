PLUGIN_NAME = "vah_sdbs open source version"
PLUGIN_AUTHOR = "SDBS" -- sensor-dream
PLUGIN_VERSION = "1.0.5" -- black lua mod

--module("SDBS", package.seeall)

-- Для работы со строками

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
        defaultDomain = "vah-clan.ga",
        defaultUser = "root",
        defaultServer = "frends",
        -- Авто ресет флаг при потере сбросе флага или гибели игрока
        resetflag = true,
        -- Разрешить одинаковые имена
        allowSameName = false,
        -- Обворачивает имя игрока в >>>-{ NAME }-> можно изменить
        wrapperName = true,
        -- Если игрок сменил имя на другое и хочет стать админом или наоборот админ меняет свое имя, то выкинуть с сервера
        disconnectLoLadmin = true,
        -- Говорить всем кто стал админом :D
        onSayAdminRoleChanged = true,
        -- автоопределение режима игры или карты gema
        autoDetectingMode = false,
        --Выключить мод если не gema
        tyrnOfModIsNotGema = false,
        configrandommaprot = false --I like randomness
    },  
    webnet = nil,
    say = nil,
    game = nil,
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

__sdbs.say = {
    setCursorInfoState = function (self,user,server)
        self.wrappers[0] = "["..(user or self.root.config.defaultUser).."@"..(server or self.root.config.defaultServer).."."..self.root.config.defaultDomain.."]$       "
        return self.wrappers[0]
    end,
    wrappers = {
        [0] = nil,
        [1] = ">>>-(",
        [2] = ")-{",
        [3] = "}->"
    },
    wrapper = function(self,str,cn)
        if self.root.config.wrapperName then
            if cn == nil then cn = "NaN" end
            return string.format("%s%s%s%s%s",self.wrappers[1],cn,self.wrappers[2],str,self.wrappers[3])
            --setname(cn,name)                        
        end
        return str
    end,
    onErrorSetUser = function (self, cn, name)
        say(string.format("\f3%s\f0There was an attempt entrance player with the same name \f2%s",self.wrappers[0],self:wrapper(name,cn)))
        say("\f0Which is prohibited by the rules.")
    end,
    onMapChange = function(self,mapname,mapmode)
        sayall(string.format("\f0%s\f1Selected playground %s for \f2 %s \f3 mode :D ",self.wrappers[0],(mapname or "GO..GO.."),( mapmode or "OgOgO")))
    end,
    onPlayerConnect = function(self,flag,info)
        if flag == 0  then sayex(string.format("\f0%s\f1Player \f2%s \f1came from \f5%s\f1, \f2%s\f1, IP : \f2%s",self.wrappers[0],self:wrapper(info.name,info.cn),info.country, info.iso ,info.ip),info.cn) end
        if flag == 1  then  sayex(string.format("\f0%s\f1Player \f2%s \f1came from \f5%s\f1, \f2%s",self.wrappers[0],self:wrapper(info.name,info.cn),info.country, info.iso),info.cn) end
        if flag == 2  then say(string.format("\f0%s\f3Hello \f2 %s \f3:D ",self.wrappers[0],self:wrapper(info.name,info.cn)),info.cn) end
    end,
    onPlayerDisconnect = function(self,cn,reason)
        sayex(string.format("\f0%s\f0Player \f2%s \f3 leaving us, went to see \f1https://vah-clan.ga \f0:D",self.wrappers[0],self:wrapper(getname(cn),cn)))
    end,
    onPlayerRoleChange = function(self,flag,cn,name)
        if flag == 0 then sayall(string.format("\f0%s\f2is Administrator",self.wrappers[0],self:wrapper(name,cn))) end
    end
}

__sdbs.game = {
    listmode = {
        [GM_DEMO] = "DEMO",
        [GM_TDM] = "TDM",
        [GM_COOP] = "COOP",
        [GM_DM] = "DM",
        [GM_SURV] = "SURV",
        [GM_TSURV] = "TSURV",
        [GM_CTF] = "CTF",
        [GM_PF] = "PF",
        [GM_LSS] = "LSS",
        [GM_OSOK] = "OSOK",
        [GM_TOSOK] = "TOSOK",
        [GM_HTF] = "HTF",
        [GM_TKTF] = "TKTF",
        [GM_KTF] = "KTF",
        [GM_NUM] = "NUM"
    },
    getmode = function(self,mode)
        local m = mode or getgamemode()
        if self.listmode[m] ~= nil then self.mode = self.listmode[m] else self.mode = "|VAH|" end
        return self.mode
    end,
    mode = nil,
    mapname = nil,
}

__sdbs.player = {
    flag = {
        time = 5,
        reset = function (self, cn,flag)
            if self.root.config.resetflag then flagaction(cn, FA_RESET, flag) end
        end
    },
    info = {
        data = {},
        backdata = {},
        gametime = function (self,cn)
            if self.data[cn] ~= null then
                return getsvtick() - self.data[cn].starttime
            end
            return 0
        end,
        is = function (self, cn)
            if self.data[cn] ~=nil then return true else return false end
        end,
        unsetuser = function (self,cn)
            if self:is(cn) then self.data[cn] = nil end
        end,
        setuser = function (self, cn, enet )
            if isconnected(cn) and cn >= 0 and cn < maxclient() then                
                if not self:is(cn) then
                    local name = getname(cn)
                    if not self.root.config.allowSameName  then
                        -- Работает в 2 раза быстрее 
                        for i = 0, #self.data do
                            if self:is(i) and ( self.data[i].name == name or self.data[i].oldname == name ) then
                                self.root.say:onErrorSetUser(cn,name)
                                self:unsetuser(cn)
                                disconnect(cn, DISC_BADNICK)
                                return nil
                            end
                        end
                        -- Работает в 2 раза медленнее
--[[
                        for i, val in ipairs(self.data) do
                            if self:is(i) and val == name then
                                sayall(string.format("\f2There was an attempt entrance player with the same name \f3%s. \f0Which is prohibited by the rules",name))
                                self:unsetuser(cn)
                                disconnect(cn, DISC_BADNICK)
                                return nil
                            end
                        end
]]
                    end
                    

                    local data = { iso = nil, country = nil, ip = nil }

                    if self.root.webnet ~= nil then 
                        data = self.root.webnet:geo(cn)
                    end

                    self.data[cn] = {
                        cn = cn,
                        name = name,
                        oldname = name,
                        iso = data.iso,
                        country = data.country,
                        ip = data.ip,
                        role = isadmin(cn), 
                        frags = nil,
                        flagscore = nil,
                        deaths = nil,
                        teamkills = nil,
                        shotdamage = nil,
                        damage = nil,
                        points = nil,
                        forced = nil,
                        events = nil,
                        lastdisc = nil,
                        reconnections = nil,
                        team = nil,
                        starttime = getsvtick(),
                        endtime = self:gametime(cn)
                    }
                    return self.data[cn]
                end
            end
            return nil;
        end,
        get = function (self, cn) 
            if isconnected(cn) and cn >= 0 and cn < maxclient() then
                if self:is(cn) then
                    return self.data[cn]
                end
            end
            return {
                        cn = nil,
                        name = nil,
                        oldname = nil,
                        iso = nil,
                        country = nil,
                        ip = nil,
                        role = nil, 
                        frags = nil,
                        flagscore = nil,
                        deaths = nil,
                        teamkills = nil,
                        shotdamage = nil,
                        damage = nil,
                        points = nil,
                        forced = nil,
                        events = nil,
                        lastdisc = nil,
                        reconnections = nil,
                        team = nil,
                        starttime = nil,
                        endtime = nil
                    }
        end,
        getcn = function (self, name)
            for i = 0, maxclient() - 1 do
                if self:is(i) and self.data[i].name == name then return self.data[i].cn end
            end
            return nil
        end,
        getname = function(self, cn)
            local data = self:get(cn)
            return data.name
        end,
        getoldname = function(self, cn)
            local data = self:get(cn)
            return data.oldname
        end,
        getcountry = function(self, cn)
            local data = self:get(cn)
            return data.country
        end,
        getiso = function(self, cn)
            local data = self:get(cn)
            return data.iso
        end,
        getip = function(self, cn)
            local data = self:get(cn)
            return data.ip
        end,
        whocn = function (self,cn)
            if self:is(cn) then 
                return {
                    name = self.data[cn].name,
                    iso = self.data[cn].iso,
                    country = self.data[cn].country,
                    cn = self.data[cn].cn
                }
            end
            return nil
        end,
        whoadmin = function ()
            for i = 0, maxclient() - 1 do
                if self:is(cn) and self.data[i].role == CR_ADMIN then
                    return {
                        name = self.data[i].name,
                        iso = self.data[i].iso,
                        country = self.data[i].country,
                        cn = self.data[i].cn
                    }
                end
            end
            return nil
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
    --sdbs.cursor = getservername()
    sdbs.say.root = setmetatable({},{__index = sdbs})
    sdbs.game.root = setmetatable({},{__index = sdbs})
    sdbs.player.root = setmetatable({},{__index = sdbs})
    sdbs.player.flag.root = setmetatable({},{__index = sdbs})
    sdbs.player.info.root = setmetatable({},{__index = sdbs})
    
    sdbs.say:setCursorInfoState()

    sdbs.webnet = webnet:new(sdbs.path.sdbs.."IpToCountry.csv")
end

function onDestroy()
end

--(string map_name, int game_mode)
function onMapChange(name,mode)
    if sdbs.config.autoDetectingMode then sdbs.game:getmode(mode,name) end
    sdbs.game.mapname = name
    sdbs.say:setCursorInfoState(sdbs.game.mode)
    sdbs.say:onMapChange(name,sdbs.game.mode)
end


--(int actor_cn)
function onPlayerConnect(cn)
    local info = sdbs.player.info:setuser(cn)
    if info ~= nil then
        if isadmin(cn) then 
            sdbs.say:onPlayerConnect(0,info)
        else
            sdbs.say:onPlayerConnect(1,info)
        end
        sdbs.say:onPlayerConnect(2,info)
    end
end

--(int actor_cn, int reason)
function onPlayerDisconnectAfter(cn,reason)
end

--(int actor_cn, int reason)
function onPlayerDisconnect(cn, reason)
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
        end
    else
        if sdbs.config.disconnectLoLadmin then 
            sayall(string.format("\f3%s\f2An attempt was made to change the name to become a manager, probably in order to troll. Last change",sdbs.say.wrappers[0]))
            sayall(string.format("\f3%s -> %s",sdbs.say:wrapper(sdbs.player.info:getoldname(cn),cn),sdbs.say:wrapper(name,cn)))
            sayall("\f2This is prohibited by the regulations in force.")
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
                    sayall(string.format("\f3%s\f2There was an attempt entrance player with the same name",sdbs.say.wrappers[0]))
                    sayall(string.format("\f3%s to %s",sdbs.say:wrapper(sdbs.player.info:getname(cn),cn),sdbs.say:wrapper(newname,cn)))
                    sayall("\f2Which is prohibited by the rules.")
                    sdbs.player.info:unsetuser(cn)
                    disconnect(cn, DISC_BADNICK)
                    return nil
                end
            end
        end
        sayex(string.format("\f0%s\f2Player name changed. \f1%s \f2to \f1%s",sdbs.say.wrappers[0],sdbs.say:wrapper(sdbs.player.info:getname(cn),cn),sdbs.say:wrapper(newname,cn)),cn)
        sdbs.player.info.data[cn].oldname = sdbs.player.info.data[cn].name
        sdbs.player.info.data[cn].name = newname
    end
end

function onFlagAction(cn, action, flag)
    if action == FA_DROP or action == FA_LOST then sdbs.player.flag:reset(cn,flag) end
end
