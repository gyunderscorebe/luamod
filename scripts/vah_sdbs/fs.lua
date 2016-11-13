
--  

fs = {}

fs.name = "fs.lua"

fs.IDBASE = 10000

fs.fsflags = {}
fs.errmsg = ""

fs.regflag = function (flag)
    if flag == nil then
	self.errmsg = "fs_regflag: expected flag name, got nil"
	return false
    end
    for i = 1, #self.fsflags do
	if flag == self.fsflags[i] then
            self.errmsg = "fs.regflag: flag "..flag.." already exists!"
            return false
	end
    end
    table.insert(self.fsflags,flag)
    self.errmsg = ""
    return true
end

fs.savecflags = function (pid,flags)
    local sfile = io.open("lua/config/flagsystem.cfg","r")
    if sfile == nil then
	cfg.createfile("flagsystem")
    end
    io.close(sfile)
    if self.flags[1] == nil then
	self.errmsg = "fs.savecflags: table == nil"
	return false
    end
    cfg.setvalue("flagsystem",getip(pid),table.concat(self.fsflags,","))
    return true
end

fs.loadcflags = function (pid)
    local flg = cfg.getvalue("flagsystem",getip(pid))
    if flg == "(fail)" then
       self.errmsg = "fs_loadcflags: couldn't load flags for ip "..getip(pid)
       return false
    else
        local tmp = split(flg,"[,]")
        if tmp[1] == nil then
            self.errmsg = "fs_loadcflags: no flags for ip "..getip(pid)
            return false
        end
	return tmp
    end
end

fs.delflag = function (flag)
    if flag == nil then
        self.errmsg = "fs_regflag: expected flag name, got nil"
        return false
    end
    local notfound = 0
    for i = 1, #self.fsflags do
        if flag == self.fsflags[i] then
            table.remove(self.fsflags,i)
            return true
	else
            notfound = 1
	end
    end
    if notfound == 1 then
	self.errmsg = "fs_delflag: flag "..flag.." not exists"
	return false
    end
end

fs.geterror = function ()
    return self.errmsg
end

fs.getflagtable = function ()
    if self.fsflags[1] == nil then
	self.errmsg = "fs_getflagtable: flag table is nil (fix: add some flags)"
	return 0
    end
    return self.fsflags
end

print ("dofile " ..fs.name)
