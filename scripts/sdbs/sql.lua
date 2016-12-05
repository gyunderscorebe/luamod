return {

    library = nil,
    driver = nil,
    db = nil,

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
        if self.db == nil and self.driver then
            self.db = assert(self.driver:connect(self.parent.cnf.sql.db_name, self.parent.cnf.sql.user, self.parent.cnf.sql.pwd, self.parent.cnf.host, self.parent.cnf.sql.port))
            if self.db then self.parent.log:w('Connect db OK. DB = '..self.parent.cnf.sql.db_name) return true end
        end
        self.parent.log:w('Connect db NO. DB = '..self.parent.cnf.sql.db_name) return false
    end,

    d_db = function(self)
        if self.db then
            self.db:close()
            self.db = nil
            self.parent.log:w('Close connect db OK. DB = '..self.parent.cnf.sql.db_name)
            return true
        end
        self.parent.log:w('Close connect db ERROR. Not connect. DB = '..self.parent.cnf.sql.db_name)
    end,

    init_driver = function(self)
        if self.driver == nil then
            self.driver = assert(self.library[self.parent.cnf.sql.driver]())
            if self.driver then self.parent.log:w('Init driver '..self.parent.cnf.sql.driver..' complete') return true end
        end
        self.parent.log:w('Init driver '..self.parent.cnf.sql.driver..' error') return false
    end,

    close_driver = function(self)
        if self.driver then
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
        self.parent.log:w("Deactivate driver MYSQL "..tostring(sdbs.sql.cdb))
    end
}