return {

    wcursor = function (self,cn,name,server,domain,sys)
        if not sys and self.cursor.active then
            return (self.parent.fn:str_replace(self.cursor.format,{ ['<NAME>'] = name ,['<SERVER>'] = server , ['<DOMAIN>'] = domain }))..' '
        end
        return ''
    end,
    wname = function(self,cn,name,sys)
        if not sys then
            if self.wrapp.active then
                return (self.parent.fn:str_replace(self.wrapp.format,{ ['<CN>'] = cn ,['<NAME>'] = name }))..' :'
            end
            return name..' :'
        end
        return ''
    end,
    out = function(self,text,cn,tcn,excn,cflag,nflag,tflag,sys,pm)
        if self.parent.cn.data_cn[cn] == nil then return end
        local name, tcn, cflag, nflag, tflag,sys = self.parent.cn.data[self.parent.cn.data_cn[cn]].name or self.cursor.def_name, tcn, (cflag or self.cursor.color), (nflag or self.wrapp.color),(tflag or self.text.color), sys or false, pm or false
        local server, domain = self.parent.gm.map.mode_str or self.cursor.def_server, self.cursor.def_domain
        if self.cursor.randomcolor then cflag = self.parent.fn:random_color() end
        if self.wrapp.randomcolor then nflag = self.parent.fn:random_color() end
        if tcn ~= nil and tcn >=0 then
            if self.parent.cn.data_cn[tcn] == nil then return end
            if pm then
                if isconnected(tcn) then
                    pm = SAY_PRIVATE
                    --name = getname(tcn) 
                    clientprint(tcn,string.format('%s%s%s%s %s%s%s',cflag,self:wcursor(tcn,self.parent.cn.data[self.parent.cn.data_cn[tcn]].name,server,domain),nflag,self:wname(cn,name,sys),pm,tflag,text))
                    return
                else return end
            else
                pm = ''
            end
            clientprint(tcn,string.format('%s%s%s%s %s%s%s',cflag,self:wcursor(tcn,self.parent.cn.data[self.parent.cn.data_cn[tcn]].name,server,domain),nflag,self:wname(cn,name,sys),pm,tflag,text))
        elseif tcn == -1 then
            for _,v in ipairs(self.parent.cn.data) do
                if excn ~= v.cn then 
                    clientprint(v.cn,string.format('%s%s%s%s %s%s',cflag,self:wcursor(cn,v.name,server,domain),nflag,self:wname(cn,name,sys),tflag,text)) 
                end
            end
        end
    end,
    colorize = function(self,text)
        if self.parent.cnf.say.colorize_text_cmd then text = string.gsub(text,"\\f","\f") end
        return text
    end,
    all = function(self,cn,text,cflag,nflag,tflag)
        self:out(text,cn,-1,nil,cflag,nflag,tflag,false,false)
    end,    
    allex = function(self,cn,tcn,text,cflag,nflag,tflag)
        self:out(text,cn,-1,tcn,cflag,nflag,tflag,false,false)
    end,
    allexme = function(self,cn,text,cflag,nflag,tflag)
        self:out(text,cn,-1,cn,cflag,nflag,tflag,false,false)
    end,
    pm = function(self,cn,tcn,text,cflag,nflag,tflag)
        self:out(text,cn,tcn,nil,cflag,nflag,tflag,sys,true)
    end,
    to = function(self,cn,tcn,text,cflag,nflag,tflag)
        self:out(text,cn,tcn,nil,cflag,nflag,tflag,false,false)
    end,
    me = function(self,cn,text,cflag,nflag,tflag)
        self:out(text,cn,cn,nil,cflag,nflag,tflag,false,false)
    end,
    sall = function(self,cn,text,cflag,nflag,tflag)
        for _,v in ipairs(self.parent.cn.data) do
            if excn ~= v.cn then 
                self:out(text,v.cn,v.cn,nil,cflag,nflag,tflag,true,false)
            end
        end
        --self:out(text,cn,-1,nil,cflag,nflag,tflag,true,false)
    end,    
    sallex = function(self,cn,tcn,text,cflag,nflag,tflag)
        self:out(text,cn,-1,tcn,cflag,nflag,tflag,true,false)
    end,
    sallexme = function(self,cn,text,cflag,nflag,tflag)
        self:out(text,cn,-1,cn,cflag,nflag,tflag,true,false)
    end,
    spm = function(self,cn,tcn,text,cflag,nflag,tflag)
        self:out(text,cn,tcn,nil,cflag,nflag,tflag,true,true)
    end,
    sto = function(self,cn,tcn,text,cflag,nflag,tflag)
        self:out(text,cn,tcn,nil,cflag,nflag,tflag,true,false)
    end,
    sme = function(self,cn,text,cflag,nflag,tflag)
        self:out(text,cn,cn,nil,cflag,nflag,tflag,true,false)
    end,

    file = function(self,cn,path,sys,pm)
        for line in io.lines(path) do
            local txt = sdbs.parent.str_replace(line,{[','] = ''})
            self:all(cn,txt,_,_,_,sys,pm)
        end
    end,

    init = function(self,obj)
        self.parent = obj
        self.cursor = self.parent.cnf.say.cursor
        self.wrapp = self.parent.cnf.say.wrapp
        self.text = self.parent.cnf.say.text
       --self.parent = setmetatable( {}, { __index = obj } )
        --self.parent = setmetatable( {}, { __index = obj, __newindex = obj } )
        self.parent.log:i('Module say init is OK')
    end
}