-- функции общего назначения

return {

    split = function(self,p,d)
        local t, ll
        t={}
        ll=0
        if(#p == 1) then return {p} end
        while true do
            l=string.find(p,d,ll,true)
            if l~=nil then
                table.insert(t, string.sub(p,ll,l-1))
                ll=l+1
            else
                table.insert(t, string.sub(p,ll))
                break
            end
        end
        return t
    end,

    slice = function(self,array, S, E)
        local result = {}
        local length = #array
        S = S or 1
        E = E or length
        if E < 0 then
            E = length + E + 1
        elseif E > length then
            E = length
        end
        if S < 1 or S > length then
            return {}
        end
        local i = 1
        for j = S, E do
            result[i] = array[j]
            i = i + 1
        end
        return result
    end,

    -- ({ ['pattern'] = 'replacement' [, n] })
    str_replace = function(self,str,arg)
        for k,v in pairs(arg) do
            str = str:gsub(k,v)
        end
        return str
    end,

    ltrim = function(self, s) -- remove leading whitespaces
        return (s:gsub("^%s*", ""))
    end,

    trim = function(self, s) --remove leading and trailing whitespace
        return (s:gsub("^%s*(.-)%s*$", "%1"))
    end,

    rtrim = function(self, s) --remove trailing whitespace
        local n = #s
        while n > 0 and s:find("^%s", n) do n = n - 1 end
        return s:sub(1, n)
    end,

    compare = function(self, str1, str2)
      return (str1 == str2)
    end,

    icompare = function(self, str1, str2)
      return (string.toupper(str1) == string.toupper(str2))
    end,

    reverse_number = function(self, num)
      local str = tostring(num) -- преобразуем число в строку
      str = string.reverse(str) -- переворачиваем строку
      return tonumber(str) -- преобразуем обратно в число и возвращаем
    end,

    shuffle =function (self, t)
        local n,nf = #t, #t --___ME__ fixed this function so it doesn't always start with the same map every time you reload the server, I just like my random to be random
        while n > 0 do
            local k = math.random(nf)
            t[n], t[k] = t[k], t[n]
            n = n - 1
        end
        return t
    end,
    -- проверка, что переменная это число, строка или булевский тип)
    is_valid_type = function (self,value_type)
        return "number" == value_type or
                "boolean" == value_type or
                "string" == value_type
    end,

    -- конвертация переменной в строку
    value_to_str = function (self,value)
        local value_type = type(value)
        if "number" == value_type or "boolean" == value_type then
            result = tostring(value)
        else  -- assume it is a string
            result = string.format("%q", value)
        end
        return result
    end,

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

    backup_file = function(self, file)
        os.execute("cp --backup=t "..file.." "..file..".back")
    end,

    copy_file = function(self, from,to)
        os.execute("cp "..from.." "..to)
    end,

    random_color = function ()
        return C_CODES[math.random(1, #C_CODES)]
    end,

    -- 0 < 17
    random_color_fix = function ()
        return C_CN_CODES[math.random(1, #C_CN_CODES)]
    end,

    colorize_text = function(self,text)
        return string.gsub(text,"\\f","\f")
    end,
--[[
    colorize_text = function (self,text)
      for i = 1, #C_CODES do
        text = text:gsub(CC_LOOKUP[i], C_CODES[i])
      end
      return text
    end,
]]
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
