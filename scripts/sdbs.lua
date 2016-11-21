PLUGIN_NAME = "aCmOdFoRvAh"
PLUGIN_AUTHOR = "SDBS"
PLUGIN_VERSION = "1.0"

LOG_INFO = 2
LOG_WARN = 3
LOG_ERR = 4

sdbs = {
    path = "./lua/scripts/sdbs/" 
}

package.path = sdbs.path.."?.lua;"
-- Пишет в stdout, для отладки токо
sdbs.CLog = true
sdbs.fs = {
    parent = sdbs,
    inc = function(self,name,path)
        local path = path or name
        self.parent[name] = require(path)
        self.parent[name]['parent'] = sdbs
        if self.parent.log ~= nil then self.parent.log:ib("require module: "..name) end
    end,
    backup = function(self, file)
        os.execute("cp --backup=t "..file.." "..file..".back")
    end
}

sdbs.fs:inc('log')
sdbs.fs:inc('fn','function')
sdbs.fs:inc('say')
sdbs.fs:inc('serializator')

local callResult, result = pcall(dofile, sdbs.path..'cnf.lua')
if callResult then sdbs.cnf = result sdbs.log:ib('require cnf') else
    sdbs.log:ib(result)
    sdbs.log:wb("Please flag CreateDefCnf make true")
    sdbs.log:ib("Load default configuration")
    sdbs.fs:inc('cnf',"def/cnf_def")
    if sdbs.cnf.CreateDefCnf then
        sdbs.log:ib("Save configuration, Please flag CreateDefCnf make false")
        sdbs.serializator:saveData("cnf",sdbs.cnf,sdbs.path.."cnf.lua")
    end
end

if sdbs.cnf.Geo.Activate then
    if sdbs.cnf.Geo.Country or cnf.Geo.CCode then geoip.load_geoip_database(sdbs.path..sdbs.cnf.Geo.FCountry) sdbs.log:ib("Activate GeoIP Country + CC") end
    if sdbs.cnf.Geo.City then geoip.load_geocity_database(sdbs.path..sdbs.cnf.Geo.FCity) sdbs.log:wb("Activate GeoIP City") end
end

sdbs.fs:inc('map')
sdbs.fs:inc('flag')
sdbs.fs:inc('vote')
sdbs.fs:inc('cn')
require ('handlers')


function onInit()
    sdbs.log:fb()
    return PLUGIN_BLOCK
end

--[[
function config:new()
    self.__index = self
    return setmetatable({}, self )
end
]]