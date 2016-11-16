-- функции логирования и консольных сообщений

__sdbs.log = {
    log = function(self,flag,text,cn)
        -- text = string.format("SCLog: Player %s says: %s. Their IP is: %s",getname(cn):gsub("%%", "%%%%"), text:gsub("%%", "%%%%") ,getip(cn))
        local name, ip = "SYSTEM", "SYSTEM"
        -- Flags, ERROR - 4, INFO - 2
        if flag == nil then flag = 2 end
        if cn ~= nil and self.root.player.info:is(cn) then 
            name = self.root.player.info.data[cn].name
            ip = self.root.player.info.data[cn].ip
        end
        text = string.format("SDBS Log: Player %s says: %s. Their IP is: %s",name:gsub("%%", "%%%%"), text:gsub("%%", "%%%%") ,ip)
        logline(flag, text)
    end,
    inf = function(self,text,cn)
        if self.root.config.logLine then self:log(2,text,cn) end
    end,
    warn = function(self,text,cn)
        if self.root.config.logLine then self:log(4,text,cn) end
    end,
    err = function(self,text,cn)
        if self.root.config.logLine then self:log(4,text,cn) end
    end
}

__sdbs.say = {
    wrappers = {
        -- [0] = "[sensor-dream@sensor-dream.ru]$",
        [1] = ">>>-(",
        [2] = ")-{",
        [3] = "}->"
    },
--[[
    setCursorInfoState = function (self,user,server)
        self.wrappers[0] = "\f2["..(user or self.root.config.defaultUser).."@"..(server or self.root.config.defaultServer).."."..self.root.config.defaultDomain.."]$       "
        return self.wrappers[0]
    end,
]]
    setInfo = function (self,color,text,cn,tcn)
        local cn, tcn = cn, tcn
        local user = self.root.config.defaultUser
        local server = self.root.game.mode.mode or self.root.config.defaultServer
        if self.root.game:isgema() then server = server.."-GEMA" end
        local domain = self.root.config.defaultDomain
        -- ex
        if cn == -1 and tcn ~= nil then
            for i = 0, #self.root.player.info.data do
                if i ~= tcn then clientprint(i, string.format("%s%s%s","\f0["..( self.root.player.info:getname(i) or user ).."@"..server.."."..domain.."]$       ",color,text),tcn) end
            end
            return
        end
        -- to
        if cn ~= nil and tcn == nil then
            clientprint(cn, string.format("%s%s%s","\f0["..( self.root.player.info:getname(cn) or user ).."@"..server.."."..domain.."]$       ",color,text))
            return
        end
        -- all
        for i = 0, #self.root.player.info.data do
            clientprint(i, string.format("%s%s%s","\f0["..( self.root.player.info:getname(i) or user ).."@"..server.."."..domain.."]$       ",color,text))
        end
        return
    end,
    wrapper = function(self,str,cn)
        if self.root.config.wrapperName then
            if cn == nil then cn = "NaN" end
            return string.format("%s%s%s%s%s",self.wrappers[1],cn,self.wrappers[2],str,self.wrappers[3])
            --setname(cn,name)                        
        end
        return str
    end,
    sys = function(self,text,cn,tcn)
        self:setInfo("\f5",text,cn,tcn)
    end,
    inf = function(self,tex,tcn,tcn)
        self:setInfo("\f0",text)
    end,
    warn = function(self,text,cn,tcn)
        self:setInfo("\f1",text,cn,tcn)
    end,
    err = function(self,text,cn,tcn)
        self:setInfo("\f3",text,cn,tcn)
    end,
    say = function(self,text, cn, tcn)
        if cn == nil then cn = -1 end
        --if tcn == nil then tcn = -1 end
        clientprint(cn, text,tcn)
    end,
    to = function(self,text,cn)
        --if cn == nil then return end
        self:setInfo("\f0",text,cn)
        --clientprint(cn, string.format("%s\f3%s",self:setInfo(cn),text))
    end,
    all = function(self,text,cn,tcn)
        self:setInfo("\f0",text,cn,tcn)
        --clientprint(-1, string.format("%s\f3%s",self:setInfo(),text))
    end,
    ex = function(self,text, tcn )
        --if tcn == nil then return end
        self:setInfo("\f0",text, -1,tcn)
        --clientprint(-1, string.format("%s\f3%s",self:setInfo(tcn),text),tcn)
    end,
    sayfile = function(self,path)
        for line in io.lines(path) do
            self:all(line)
        end
    end,
    getModeList = function(self,cn)
        self.to(string.format("\f0GM_DEMO - %s, GM_TDM - %s, GM_COOP - %s, GM_DM - %s, GM_SURV - %s, GM_TSURV - %s, GM_CTF - %s, GM_PF - %s, GM_LSS - %s, GM_OSOK - %s, GM_TOSOK - %s, GM_HTF - %s, GM_TKTF - %s, GM_KTF - %s, GM_NUM - %s",GM_DEMO,GM_TDM,GM_COOP,GM_DM,GM_SURV,GM_TSURV,GM_CTF,GM_PF,GM_LSS,GM_OSOK,GM_TOSOK,GM_HTF,GM_TKTF,GM_KTF,GM_NUM))
        --self.root.log:info(string.format("\f0GM_DEMO - %s, GM_TDM - %s, GM_COOP - %s, GM_DM - %s, GM_SURV - %s, GM_TSURV - %s, GM_CTF - %s, GM_PF - %s, GM_LSS - %s, GM_OSOK - %s, GM_TOSOK - %s, GM_HTF - %s, GM_TKTF - %s, GM_KTF - %s, GM_NUM - %s",GM_DEMO,GM_TDM,GM_COOP,GM_DM,GM_SURV,GM_TSURV,GM_CTF,GM_PF,GM_LSS,GM_OSOK,GM_TOSOK,GM_HTF,GM_TKTF,GM_KTF,GM_NUM),cn)
    end,
    getVoteList = function(self,cn)
        self:to(string.format("\f0--voteactions: VOTE_NEUTRAL - %s, VOTE_YES - %s, VOTE_NO - %s --votetypes: SA_KICK - %s, SA_BAN - %s, SA_REMBANS - %s, SA_MASTERMODE - %s, SA_AUTOTEAM - %s, SA_FORCETEAM - %s, SA_GIVEADMIN - %s, SA_MAP - %s, SA_RECORDDEMO - %s, SA_STOPDEMO - %s, SA_CLEARDEMOS - %s, SA_SERVERDESC - %s, SA_SHUFFLETEAMS - %s",VOTE_NEUTRAL, VOTE_YES, VOTE_NO, SA_KICK, SA_BAN, SA_REMBANS, SA_MASTERMODE, SA_AUTOTEAM, SA_FORCETEAM, SA_GIVEADMIN, SA_MAP, SA_RECORDDEMO, SA_STOPDEMO, SA_CLEARDEMOS, SA_SERVERDESC, SA_SHUFFLETEAMS),cn)
        --self.root.log:inf(string.format("\f0--voteactions: VOTE_NEUTRAL - %s, VOTE_YES - %s, VOTE_NO - %s --votetypes: SA_KICK - %s, SA_BAN - %s, SA_REMBANS - %s, SA_MASTERMODE - %s, SA_AUTOTEAM - %s, SA_FORCETEAM - %s, SA_GIVEADMIN - %s",VOTE_NEUTRAL, VOTE_YES, VOTE_NO, SA_KICK, SA_BAN, SA_REMBANS, SA_MASTERMODE, SA_AUTOTEAM, SA_FORCETEAM, SA_GIVEADMIN))
        --self.root.log:inf(string.format("\f0SA_MAP - %s, SA_RECORDDEMO - %s, SA_STOPDEMO - %s, SA_CLEARDEMOS - %s, SA_SERVERDESC - %s, SA_SHUFFLETEAMS - %s",SA_MAP, SA_RECORDDEMO, SA_STOPDEMO, SA_CLEARDEMOS, SA_SERVERDESC, SA_SHUFFLETEAMS))
    end,
    onErrorSetUser = function (self, cn, name)
        self:err(string.format("There was an attempt entrance player with the same name \f2%s",self:wrapper(name,cn)))
        self:say("\f3Which is prohibited by the rules.")
    end,
    onMapChange = function(self,flag,mapname,mapmode)
        if flag == 0 then self:inf(string.format("Selected playground \f0%s \f2for \f4%s \f2mode \f3!!! ",(mapname or "GO..GO.."),( mapmode or "OgOgO"))) end
        if flag == 1 then self:inf(string.format("Selected GEMA - playground \f1%s \f3!!! \f2for \f4%s \f2mode \f3!!! ",(mapname or "GO..GO.."),( mapmode or "OgOgO"))) end
    end,
    onPlayerConnect = function(self,flag,info,admin)
        if flag == 0  then 
            self:to(string.format("Player \f2%s \f1came from \f5%s\f1, \f2%s\f1, IP : \f2%s",self:wrapper(info.name,info.cn),info.country, info.iso ,info.ip),admin )
        end
        if flag == 1  then  self:ex(string.format("\f1Player \f2%s \f1came from \f5%s\f1 | \f2%s",self:wrapper(info.name,info.cn),info.country, info.iso),info.cn) end
        if flag == 2  then self:to(string.format("\f2We welcome you \f3%s \f2player :) ",self:wrapper(info.name,info.cn)),info.cn) end
    end,
    onPlayerDisconnect = function(self,cn,reason)
        self:sys(string.format("Player \f2%s \f5 leaving us, went to see \f1https://%s \f0:D",self:wrapper(getname(cn),cn),self.root.config.defaultDomain))
    end,
    onPlayerRoleChange = function(self,flag,cn,name)
        if flag == 0 then self:ex(string.format("\f1%s is Administrator",self:wrapper(name,cn)),cn) end
        if flag == 1 then self:ex(string.format("\f1%s is not Administrator",self:wrapper(name,cn)),cn) end
        if flag == 2 then 
            self:err(string.format("An attempt was made to change the name to become a manager, probably in order to troll. Last change"))
            self:say(string.format("\f2%s \f3to \f5%s",self:wrapper(self.root.player.info:getoldname(cn),cn),self:wrapper(name,cn)))
            self:say("\f3This is prohibited by the regulations in force.")
        end
    end,
    onPlayerNameChange = function(self,flag,cn,newname)
        if flag == 0 then
            self:warn(string.format("There was an attempt entrance player with the same name"))
            self:say(string.format("\f2%s \f1to \f2%s",self:wrapper(self.root.player.info:getname(cn),cn),self:wrapper(newname,cn)))
            self:say("\f2Which is prohibited by the rules.")
        end
        if flag == 1 then
            self:ex(string.format("\f2Player name changed. \f1%s \f2to \f1%s",self:wrapper(self.root.player.info:getname(cn),cn),self:wrapper(newname,cn)),cn)
        end
    end,
    onFlagAction = function(self,flag,cn)
        if flag == 0 then self:ex(string.format("\f2Player \f0%s \f2lost flag",self.wrappers[0],self:wrapper(self.root.player.info:getname(cn),cn))) end
    end
}

print ("dofile say.lua")