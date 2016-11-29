-- функции общего назначения

return {

    -- ( string name, string path )
    load = function(self,name,path)
        path = path or name
        self.parent[name] = require(path)
        if self.parent[name].init ~= nil then
            self.parent[name]:init(self.parent)
        else
            if self.parent.C_LOG then logline(2,string.format('SDBS: Player SYSTEM says: Module %s init is OK',name)) end
        end
    end,

    init = function(self,obj)
       self.parent = obj
        --self.parent = setmetatable( {}, { __index = obj } )
        --self.parent = setmetatable( {}, { __index = obj, __newindex = obj } )
       if self.parent.C_LOG then logline(2,'SDBS: Module function init is OK') end
    end

}
