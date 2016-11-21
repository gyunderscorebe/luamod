--module('serializator')

-- проверка, что переменная может быть сохранена как строка 
-- т.е это число, строка или булевский тип)
return {
    isValidType = function (self,valueType)
        return "number" == valueType or 
                "boolean" == valueType or 
                "string" == valueType
    end,

    -- конвертация переменной в строку
    valueToString = function (self,value)
        local valueType = type(value)
        if "number" == valueType or "boolean" == valueType then
            result = tostring(value)
        else  -- assume it is a string
            result = string.format("%q", value)
        end
        return result
    end,

    save = function (self,name, value, saved)
        saved = saved or {}       -- initial value
        io.write(name, " = ")
        local valueType = type(value)
        if self:isValidType(valueType) then
            io.write(self:valueToString(value), "\n")
        elseif "table" == valueType then
            if saved[value] then    -- value already saved?
                io.write(saved[value], "\n")  -- use its previous name
            else
                saved[value] = name   -- save name for next time
                io.write("{}\n")     -- create a new table
                for k,v in pairs(value) do      -- save its fields
                -- добавляем проверку ключа таблицы
                    local keyType = type(k)
                    if self:isValidType(keyType) then
                        local fieldname = string.format("%s[%s]", name, self:valueToString(k))
                        self:save(fieldname, v, saved)
                    else
                        error("cannot save a " .. keyType)
                    end
                end
            end
        else
            error("cannot save a " .. valueType)
        end
    end,

    saveData = function (self,name,data,file)
        -- сохраняем предыдущий поток вывода
        local prev = io.output()
        local f = io.open(file, "w")
        -- устанавливаем вывод стандартного потока в наш файл
        io.output(f)
        io.write('-- Config file created '..PLUGIN_NAME..' to date '..(os.date("[%d %b %Y %H:%M]"))..' \n')
        io.write('local ')
        -- сериализация
        self:save(name, data)
        io.write('\n')
        io.write('return '..name)
        io.write('\n')
        -- закрываем файл
        f:close()
        -- восстанавливаем предыдущий поток вывода
        io.output(prev)
    end
}
