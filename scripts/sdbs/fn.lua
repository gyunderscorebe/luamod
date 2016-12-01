-- функции общего назначения

return {

    -- ( string name, string path )
    load = function(self,name,path)
        path = path or name
        self.parent[name] = require(path)
        if self.parent[name].init ~= nil then
            self.parent[name]:init(self.parent)
        else
            if self.parent.C_LOG then logline(2,string.format('SDBS: Player SYSTEM says: Module %s init OK',name)) end
        end
    end,

    random_color_cn = function ()
        return C_CN_CODES[math.random(1, #C_CN_CODES)]
    end,

    init = function(self,obj)
       self.parent = obj
        --self.parent = setmetatable( {}, { __index = obj } )
        --self.parent = setmetatable( {}, { __index = obj, __newindex = obj } )
       if self.parent.flag.C_LOG then logline(2,'SDBS: Player SYSTEM says: Module function init OK') end
    end

}
