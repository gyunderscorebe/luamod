return {
    textLog = function(self,flag,text,cn)
        local flag, text, name, ip = (flag or LOG_INFO),(text or "SYSTEM"), "SYSTEM", "SYSTEM"
        if cn ~= nil then
            if  cn >= 0 then 
                name = getname(cn) or "SYSTEM"
                ip = getip(cn) or "SYSTEM"
            else cn = "SYSTEM" end
        else cn = "SYSTEM" end 
        if cn ~= "SYSTEM" then
            logline(flag,string.format("SDBS Log: Player %s CN %s says: %s. Their IP is: %s",name:gsub("%%", "%%%%"),cn, text:gsub("%%", "  %%%%") ,ip))
        else 
            logline(flag,string.format("SDBS Log: Player %s says: %s.",name:gsub("%%", "%%%%"), text:gsub("%%", "  %%%%") ))
        end
    end,
    buff = {},
    --save in buffer
    setBuff = function(self, flag, text,cn )        
        table.insert(self.buff, { flag = flag, text = text, cn = cn } )
    end,
    -- info
    ib = function (self,text, cn) if self.parent.CLog then self:setBuff(LOG_INFO, text, cn) end end,
    --warning
    wb = function (self,text, cn) if self.parent.CLog then self:setBuff(LOG_WARN, text, cn) end end,
    --error
    eb = function (self,text, cn) if self.parent.CLog then self:setBuff(LOG_ERR, text, cn) end end,
    --flush buff
    fb = function(self)
        if self.parent.CLog then
            if #self.buff > 0 then
                for _,v in ipairs(self.buff) do
                    self:textLog(v.flag,v.text, v.cn)
                end
                self.buff = nil
                self.buff = {}
            end
        end
    end,
    -- info
    i = function (self,text, cn) if self.parent.CLog then self:textLog(LOG_INFO,text,cn) end end,
    --warning
    w = function (self,text, cn) if self.parent.CLog then self:textLog(LOG_WARN, text, cn) end end,
    --error
    e = function (self,text, cn) if self.parent.CLog then self:textLog(LOG_ERR, text, cn) end end
}