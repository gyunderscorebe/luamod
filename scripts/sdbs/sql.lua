return {
    driver = nil,
    handle = nil,
    db = nil,
    cdb = false,
    init = function(self,obj)
        self.parent = obj
        if self.parent.cnf.sql.flag then
            -- self.driver = include(self.parent.cnf.sql.driver)
            self.parent.log:w('Load ... driver MYSQL '..self.parent.cnf.sql.driver)
            local callResult, result = pcall(require, self.parent.cnf.sql.driver)
            if callResult then
                self.parent.sql.driver = result
                self.parent.log:w('Load driver MYSQL '..self.parent.cnf.sql.driver..' complete')
                self.handle = assert(self.driver.mysql())
                if self.handle then
                    self.parent.log:w('Connect ... DB = '..self.parent.cnf.sql.db_name)
                    self.db = assert(self.handle:connect(self.parent.cnf.sql.db_name, self.parent.cnf.sql.user, self.parent.cnf.sql.pwd, self.parent.cnf.host, self.parent.cnf.sql.port))
                    if self.db then self.cdb = true sdbs.log:w('Connect db OK. DB = '..self.parent.cnf.sql.db_name) end
                end
            else
                self.parent.log:w(result)
            end
            self.parent.log:w("Activate driver MYSQL "..tostring(self.cdb))

        else
            self.parent.log:i('Not active driver MYSQL. Disabled. ')
        end
    end
}