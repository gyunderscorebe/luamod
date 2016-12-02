return {
    driver = nil,
    handle = nil,
    db = nil,
    init = function(self,obj)
        self.parent = obj
        if self.parent.cnf.sql.flag then
            self.driver = require(self.parent.cnf.sql.driver)
            if self.driver then
                self.handle = assert(self.driver.mysql())
                if self.handle then
                    self.db = assert(self.handle:connect(self.parent.cnf.sql.db_name, self.parent.cnf.sql.user, self.parent.cnf.sql.pwd, self.parent.cnf.  sql.host))
                    if self.db then
                        self.init = true
                        self.parent.log:w("Activate MYSQL "..tostring(self.init))
                    end
                end
            end
        else
            self.parent.log:i('Activate MYSQL OK')
        end
    end
}