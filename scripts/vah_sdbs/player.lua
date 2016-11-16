-- player

__sdbs.player = {
    flag = {
        time = 5,
        reset = function (self, cn,flag)
            if self.root.config.flag.reset and self.root.game.incmode == GM_CTF then
                flagaction(cn, FA_RESET, flag)
                if self.root.config.flag.say then self.root.say:onFlagAction(0,cn) end
            end
            
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
            self.root.log:inf(" Set user "..cn)
            if isconnected(cn) and cn >= 0 and cn < maxclient() then
                if not self:is(cn) then
                    local name = getname(cn)
                    if not self.root.config.allowSameName  then

                        for k,v in ipairs(self.data) do                            
                            if self:is(k) and ( v.name == name or v.oldname == name ) then
                                self.root.say:onErrorSetUser(cn,name)
                                self:unsetuser(cn)
                                disconnect(cn, DISC_BADNICK)
                                return nil
                            end
                        end

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
                        role = CR_DEFAULT,
                        modt = CR_DEFAULT,
                        mute = false,
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
            if isconnected(cn) and ( cn >= 0 and cn < maxclient() ) then
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
                        modt = nil,
                        mute = nil,
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
            local v = self:get(cn)
            return v.cn
        end,
        whoadmin = function (self)
            for i = 0, #self.data do
                if self:is(i) and self.data[i] == CR_ADMIN then
                    return self.data[i].cn
                end
            end
            return nil
        end
    },
    commands = nil
}

print ("dofile player.lua")
