return {
    -- sayas()  -- string message, int player_cn, bool team, bool me
    buff = {},
    out = function(self,text,cn )
        --for 
    end,
    i = function(self,text,cn )
        if cn == nil then table.insert(self.buff, text) end
    end,
    w = function(self,text,cn )
        if cn == nil then table.insert(self.buff, text) end
    end,
    e = function(self,text,cn )
        if cn == nil then table.insert(self.buff, text) end
    end
}