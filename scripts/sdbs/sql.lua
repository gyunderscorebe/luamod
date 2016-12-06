return {

    library = nil,
    driver = nil,
    db = nil,
    cur = nil,

    init = function(self,obj)
        self.parent = obj
        if self.parent.cnf.sql.flag then
            -- self.driver = include(self.parent.cnf.sql.driver)
            self.parent.log:w('Load ... library MYSQL '..self.parent.cnf.sql.library)
            local callResult, result = pcall(require, self.parent.cnf.sql.library)
            if callResult then
                self.parent.sql.library = result
                self.parent.log:w('Load library MYSQL '..self.parent.cnf.sql.library..' complete')
                if self:init_driver() then
                    if self:c_db() then
                        self:d_db()
                    end
                end
            else
                self.parent.log:w(result)
            end
            self.parent.log:w("Activate driver "..self.parent.cnf.sql.driver)

        else
            self.parent.log:i('Not active driver '..self.parent.cnf.sql.driver..'. Disabled. ')
        end
    end,

    c_db = function(self)
        if type(self.db) ~= 'userdata' and self.driver then
            self.db = assert(self.driver:connect(self.parent.cnf.sql.db_name, self.parent.cnf.sql.user, self.parent.cnf.sql.pwd, self.parent.cnf.host, self.parent.cnf.sql.port))
            if self.db then self.parent.log:w('Connect db OK. DB: '..self.parent.cnf.sql.db_name) return true end
        else
            self.parent.log:i('Connection already established '..self.parent.cnf.sql.db_name) return true
        end
        self.parent.log:w('Connect db NO. DB: '..self.parent.cnf.sql.db_name) return false
    end,

    d_db = function(self)
        if type(self.db) == 'userdata' then
            self.db:close()
            self.db = nil
            self.parent.log:w('Close connect db OK. DB: '..self.parent.cnf.sql.db_name)
            return true
        end
        self.parent.log:w('Close connect db ERROR. Not connect. DB: '..self.parent.cnf.sql.db_name)
    end,

    init_driver = function(self)
        if self.driver == nil then
            self.driver = assert(self.library[self.parent.cnf.sql.driver]())
            if self.driver then self.parent.log:w('Init driver '..self.parent.cnf.sql.driver..' complete') return true end
        end
        self.parent.log:w('Init driver '..self.parent.cnf.sql.driver..' error') return false
    end,

    close_driver = function(self)
        if type(self.driver) == 'userdata' then
            self.driver:close()
            self.driver = nil
            self.parent.log:w('Close driver '..self.parent.cnf.sql.driver..' complete') return true
        end
        self.parent.log:w('Close driver '..self.parent.cnf.sql.driver..' error') return false
    end,

    destroy = function(self)
        self:d_db()
        self:close_driver()
        --self.library = nil
        self.parent.log:w("Deactivate driver MYSQL ")
    end,

    query = function(self,data)
        if type(self.driver) ~= 'userdata' then self.parent.log:w("No activate driver MYSQL ") return nil end
        if not self:c_db() then return false end
        return pcall(assert,self.db:execute(data))
    end,

    login = function(self,name,passwd)
        self.parent.log:i(string.format("Find player name: %s in DB for login.", name))
        local f, c =  self:query(string.format('SELECT `name`,`pwd`,`access` FROM `user` WHERE `user`.`name` = \'%s\'', name ))
        if f then
            local r = c:fetch ({})
            c:close()
            if r ~= nil then
                self.parent.log:i(string.format("Player found. Name: %s", r[1]))
                if passwd == tostring(r[2]) then
                    self.parent.log:i(string.format("Access is allowed Name: %s", r[1]))
                    return tonumber(r[3])
                else
                    self.parent.log:i(string.format("Access is not permitted Name: %s", r[1]))
                    return string.format(self.parent.cnf.sql.text.access_not_permitted, r[1])
                end
            else
                self.parent.log:w(string.format("Player NOT found. Name: %s", name))
                return  string.format(self.parent.cnf.sql.text.user_not_found,name)
            end
        else
            self.parent.log:e(string.format("Player NOT find. Name: %s MESS: %s", name,c))
            return '\f3'..tostring(c)
        end
    end,

    useradd = function(self,name,access,pwd)
        self.parent.log:w(string.format("Create player name: %s in DB", name))
        local f, r =  self:query(string.format('INSERT INTO `user`(  `name`, `access`, `pwd` ) VALUES ( \'%s\', %s, \'%s\' );', name, access, pwd ))
        if f then
            self.parent.log:i(string.format("Player create. Name: %s", name))
            return  string.format(self.parent.cnf.sql.text.user_add,name,self.parent.cn:get_role(access))
        else
            self.parent.log:e(string.format("Player NOT create. Name: %s MESS: %s", name,r))
            return '\f3'..tostring(r)
        end
    end,

    userdel = function(self,name)
        self.parent.log:i(string.format("Find player name: %s in DB for delete.", name))
        local f, c =  self:query(string.format('SELECT `name` FROM `user` WHERE `user`.`name` = \'%s\'', name ))
        --'DELETE FROM `user` WHERE `user`.`id` = (
        if f then
            local r = c:fetch ({})
            c:close()
            if r ~= nil then
                self.parent.log:i(string.format("Player found. Name: %s", r[1]))
                local ff, cc =  self:query(string.format('DELETE FROM `user` WHERE `user`.`name` = \'%s\'', r[1]))
                if ff then
                    self.parent.log:i(string.format("Player deleted. Name: %s", r[1]))
                    return  string.format(self.parent.cnf.sql.text.user_del,r[1])
                else
                    self.parent.log:e(string.format("Player NOT deleted. Name: %s MESS: %s", r[1],cc))
                    return '\f3'..tostring(cc)
                end
            else
                self.parent.log:w(string.format("Player NOT found. Name: %s", name))
                return  string.format(self.parent.cnf.sql.text.user_not_found,name)
            end
        else
            self.parent.log:e(string.format("Player NOT deleted. Name: %s MESS: %s", name,c))
            return '\f3'..tostring(c)
        end
    end
}