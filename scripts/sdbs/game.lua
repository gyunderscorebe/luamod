return {
    -- FLAG
    flag = {
        action = {
                --number
            [FA_PICKUP] = 'PICKUP',
            [FA_STEAL] = 'STEAL',
            [FA_DROP] = 'DROP',
            [FA_LOST] = 'LOST',
            [FA_RETURN] = 'RETURN',
            [FA_SCORE] = 'SCORE',
            [FA_RESET] = 'RESET',
                --string
            PICKUP = FA_PICKUP,
            STEAL = FA_STEAL,
            DROP = FA_DROP,
            LOST = FA_LOST,
            RETURN = FA_RETURN,
            SCORE = FA_SCORE,
            RESET = FA_RESET,
        },
        get = function(self,action)
            if self.action[mode] ~= nil then
                return self.action[mode]
            end
            return nil
        end,
        flag_action =  function(self,cn,action,flag)
            self.fa = {
                [FA_DROP] = function(self,cn,action,flag)
                    if self.parent.parent.cnf.flag.reset.drop then flagaction(cn,FA_RESET,flag) end
                    if self.parent.parent.cnf.flag.reset.say_drop then self.parent.parent.say:sallexme(cn,string.format("\fPPlayer \f3%s \fPflag dropped, probably wanted to hide \fX:)",self.parent.parent.cn.data[self.parent.parent.cn.data_cn[cn]].name)) end
                end,
                [FA_LOST] = function(self,cn,action,flag)
                    if self.parent.parent.cnf.flag.reset.lost then flagaction(cn,FA_RESET,flag) end
                    if self.parent.parent.cnf.flag.reset.say_lost then self.parent.parent.say:sallexme(cn,string.format("\fPPlayer loses \f3%s \fPflag, probably due to death \f4:(",self.parent.parent.cn.data[self.parent.parent.cn.data_cn[cn]].name)) end
                end
            }
            if self.fa[action]~= nil then  self.fa[action](self,cn,action,flag) end
        end
    },
    -- MODE
    mode = {
        -- GM_DEMO - -1,GM_TDM - 0,GM_COOP - 1,GM_DM - 2,
        -- GM_SURV - 3,GM_TSURV - 4,GM_CTF - 5,GM_PF - 6,
        -- GM_LSS - 9,GM_OSOK - 10,GM_TOSOK - 11,GM_HTF - 13,
        -- GM_TKTF - 14,GM_KTF - 15,GM_NUM - 22
        types = {
                --number
            [GM_DEMO] = "DEMO",     -- -1
            [GM_TDM] = "TDM",       --0
            [GM_COOP] = "COOP",     --1
            [GM_DM] = "DM",         --2
            [GM_SURV] = "SURV",     --3
            [GM_TSURV] = "TSURV",   --4
            [GM_CTF] = "CTF",       --5
            [GM_PF] = "PF",         --6
            [GM_LSS] = "LSS",       --9
            [GM_OSOK] = "OSOK",     --10
            [GM_TOSOK] = "TOSOK",   --11
            [GM_HTF] = "HTF",       --13
            [GM_TKTF] = "TKTF",     --14
            [GM_KTF] = "KTF",       --15
            [GM_NUM] = "NUM",        --22
                --string
            DEMO = GM_DEMO,     -- -1
            TDM = GM_TDM,       --0
            COOP = GM_COOP,     --1
            DM= GM_DM,          --2
            SURV = GM_SURV,     --3
            TSURV = GM_TSURV,   --4
            CTF = GM_CTF,       --5
            PF = PFGM_PF,       --6
            LSS = GM_LSS,       --9
            OSOK = GM_OSOK,     --10
            TOSOK = GM_TOSOK,   --11
            HTF = GM_HTF,       --13
            TKTF = GM_TKTF,     --14
            KTF = GM_KTF,       --15
            NUM = GM_NUM        --22
        },
        get = function(self,mode)
            if self.types[mode] ~= nil then
                return self.types[mode]
            end
            return nil
        end
    },
    -- MAP
    map = {
        name = nil,
        mode = nil,
        mode_gema = false,
        mode_str = nil,
        chk_gema_map = function (self, mapname)
            mapname = mapname:lower()        
            for _,v in ipairs(self.parent.parent.cnf.map.list.implicit) do
                if mapname:find(v) then
                    return true
                end
            end
            for i = 1, #mapname - #self.parent.parent.cnf.map.list.code + 1 do
                local match = 0
                for j = 1, #self.parent.parent.cnf.map.list.code do
                    for k = 1, #self.parent.parent.cnf.map.list.code[j] do
                        if mapname:sub(i+j-1, i+j-1) == self.parent.parent.cnf.map.list.code[j]:sub(k, k) then
                            match = match + 1
                        end
                    end
                end
                if match == #self.parent.parent.cnf.map.list.code then
                    return true
                end
            end
            return false
        end,
        is_gema_map = function(self)
            return self.mode_gema or false
        end,
        set_info = function(self,name,mode)
            self.name = name or getmapname()
            self.mode = mode or getgamemode()
            self.mode_str = self.parent.mode:get(self.mode)
            self.mode_gema = self:chk_gema_map(name)
        end
    },
    -- VOTE
    vote = {

        vote = nil,
        inc_vote = nil,

        -- voteactions
        -- VOTE_NEUTRAL - 0, VOTE_YES - 1, VOTE_NO - 2

        action = {
                --number
            [VOTE_NEUTRAL] = "NEUTRAL",         --0
            [VOTE_YES] = "YES",                 --1
            [VOTE_NO] = "NO",                   --2
                --string
            NEUTRAL = VOTE_NEUTRAL,         --0
            YES = VOTE_YES,                 --1
            NO = VOTE_NO                    --2
        },

        get_action = function(self,action)
            if self.action[mode] ~= nil then
                return self.action[mode]
            end
            return nil
        end,

        -- votetypes
        -- SA_KICK - 0, SA_BAN - 1, SA_REMBANS - 2, SA_MASTERMODE - 3
        -- SA_AUTOTEAM - 4, SA_FORCETEAM - 5, SA_GIVEADMIN - 6
        -- SA_MAP - 7, SA_RECORDDEMO - 8, SA_STOPDEMO - 9, SA_CLEARDEMOS - 10
        -- SA_SERVERDESC - 11, SA_SHUFFLETEAMS - 12

        types = {
                --number
            [SA_KICK] = "KICK",                 --0
            [SA_BAN] = "BAN",                   --1
            [SA_REMBANS] = "REMBANS",           --2
            [SA_MASTERMODE] = "MASTERMODE",     --3
            [SA_AUTOTEAM] = "AUTOTEAM",         --4
            [SA_FORCETEAM] = "FORCETEAM",       --5
            [SA_GIVEADMIN] = "GIVEADMIN",       --6
            [SA_MAP] = "MAP",                   --7
            [SA_RECORDDEMO] = "RECORDDEMO",     --8
            [SA_STOPDEMO] = "STOPDEMO",         --9
            [SA_CLEARDEMOS] = "CLEARDEMOS",     --10
            [SA_SERVERDESC] = "SERVERDESC",     --11
            [SA_SHUFFLETEAMS] = "SHUFFLETEAMS",  --12
                --string
            KICK = SA_KICK,                 --0
            BAN = SA_BAN,                   --1
            REMBANS = SA_REMBANS,           --2
            MASTERMODE = SA_MASTERMODE,     --3
            AUTOTEAM = SA_AUTOTEAM,         --4
            FORCETEAM = SA_FORCETEAM,       --5
            GIVEADMIN = SA_GIVEADMIN,       --6
            MAP = SA_MAP,                   --7
            RECORDDEMO = SA_RECORDDEMO,     --8
            STOPDEMO = SA_STOPDEMO ,         --9
            CLEARDEMOS = SA_CLEARDEMOS,     --10
            SERVERDESC = SA_SERVERDESC,     --11
            SHUFFLETEAMS = SA_SHUFFLETEAMS  --12  
        },
        get_vote = function(self,vote)
            local v = vote or nil
            if self.types[v] ~= nil then
                self.vote = self.vote[v]
                self.inc_vote = v
                return self.vote
            end
            self.vote = nil
            self.inc_vote = nil
            return nil
        end
    },

    init = function(self,obj)
    --[[
        self.parent = setmetatable( {}, { __index = obj } )
        self.flag.parent = setmetatable( {}, { __index = self } )
        self.mode.parent = setmetatable( {}, { __index = self } )
        self.map.parent = setmetatable( {}, { __index = self } )
        self.vote.parent = setmetatable( {}, { __index = self } )
    ]]
        self.parent = obj
        self.flag.parent = self
        self.mode.parent = self
        self.map.parent = self
        self.vote.parent = self
        self.parent.log:ib('GAME init OK')
    end
}