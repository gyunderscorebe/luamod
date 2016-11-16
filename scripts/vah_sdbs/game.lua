-- 

__sdbs.game = {
    vote = {

        -- voteactions
        -- VOTE_NEUTRAL - 0, VOTE_YES - 1, VOTE_NO - 2

        actions = {
            [VOTE_NEUTRAL] = "NEUTRAL",         --0
            [VOTE_YES] = "YES",                 --1
            [VOTE_NO] = "NO"                    --2
        },  

        -- votetypes
        -- SA_KICK - 0, SA_BAN - 1, SA_REMBANS - 2, SA_MASTERMODE - 3
        -- SA_AUTOTEAM - 4, SA_FORCETEAM - 5, SA_GIVEADMIN - 6
        -- SA_MAP - 7, SA_RECORDDEMO - 8, SA_STOPDEMO - 9, SA_CLEARDEMOS - 10
        -- SA_SERVERDESC - 11, SA_SHUFFLETEAMS - 12

        types = {
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
            [SA_SHUFFLETEAMS] = "SHUFFLETEAMS"  --12
        },
        getvote = function(self,vote)
            local v = vote or nil
            if self.types[v] ~= nil then
                self.vote = self.vote[v]
                self.incvote = v
            else
                self.vote = nil
                self.incvote = nil
            end
            return self.vote
        end,
        vote = nil,
        incvote = nil
    },
    mode = {
        -- GM_DEMO - -1,GM_TDM - 0,GM_COOP - 1,GM_DM - 2,
        -- GM_SURV - 3,GM_TSURV - 4,GM_CTF - 5,GM_PF - 6,
        -- GM_LSS - 9,GM_OSOK - 10,GM_TOSOK - 11,GM_HTF - 13,
        -- GM_TKTF - 14,GM_KTF - 15,GM_NUM - 22
        types = {
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
            [GM_NUM] = "NUM"        --22
        },
        getmode = function(self,mode)
            local m = mode or getgamemode()
            if self.types[m] ~= nil then
                self.mode = self.types[m]
                self.incmode = mode
            else
                self.mode = "|VAH|"
                self.incmode = nil
            end
            return  {
                        mode = self.mode,
                        incmode = self.incmode
                    }
        end,
        mode = nil,
        incmode = nil
    },
    mapname = nil,
    mapgema = false,
    chkGema = function (self, mapname)
        mapname = mapname:lower()        
        for k,v in ipairs(self.root.config.map.list.implicit) do
            if mapname:find(v) then
                return true
            end
        end
        for i = 1, #mapname - #self.root.config.map.list.code + 1 do
            local match = 0
            for j = 1, #self.root.config.map.list.code do
                for k = 1, #self.root.config.map.list.code[j] do
                    if mapname:sub(i+j-1, i+j-1) == self.root.config.map.list.code[j]:sub(k, k) then
                        match = match + 1
                    end
                end
            end
            if match == #self.root.config.map.list.code then
                return true
            end
        end
        return false
    end,
    isgema = function(self)
        return self.mapgema or false
    end
    
}

print ("dofile game.lua")