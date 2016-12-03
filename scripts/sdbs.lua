PLUGIN_NAME = "aCmOdFoRvAh"
PLUGIN_AUTHOR = "SDBS"
PLUGIN_VERSION = "1.0.5"

-- reload lua as admin:  /serverextention lua::reload --

sdbs = {
    path = "lua/scripts/sdbs/",
    cpath = "lua/extra/"
}

package.path = sdbs.path.."?.lua;"
package.cpath = sdbs.cpath.."?.so;"

-- Пишет в stdout, для отладки токо
sdbs.flag = {
    C_LOG = true,
    geo_country = false,
    geo_city = false,
}

sdbs.fn = require('constants')
sdbs.fn = require('fn')
sdbs.fn:init(sdbs)
sdbs.fn:load('log')

local callResult, result = pcall(require, 'cnf')
if callResult then sdbs.cnf = result sdbs.log:i('Module cnf init OK') else
    sdbs.log:w(result)
    sdbs.log:w("Restore default configuration")
    sdbs.fn:copy_file(sdbs.path.."def/cnf.lua",sdbs.path.."cnf.lua")
    sdbs.log:w("Load default configuration")
    sdbs.fn:load('cnf')
end

sdbs.fn:load('say')
sdbs.fn:load('gm','game')
sdbs.fn:load('cn')
sdbs.fn:load('cmd')

if sdbs.cnf.geo.active then
    if sdbs.cnf.geo.country then
        sdbs.flag.geo_country = geoip.load_geoip_database(sdbs.path..sdbs.cnf.geo.f_country)
        if sdbs.flag.geo_country then sdbs.log:i("Activate GeoIP Country + CC") else sdbs.log:w("Not activate GeoIP Country + CC") end
    end
    if sdbs.cnf.geo.city then
        sdbs.flag.geo_city = geoip.load_geocity_database(sdbs.path..sdbs.cnf.geo.f_city)
        if sdbs.flag.geo_city then sdbs.log:i("Activate GeoIP City") else sdbs.log:w("Not activate GeoIP City") end
    end
end

require('handlers')

sdbs.fn:load('sql')

function onInit()
    setautoteam(false)
    sdbs.flag.C_LOG = sdbs.cnf.c_log
    sdbs.log:w("Map autoteam is  "..tostring(getautoteam()))
    sdbs.cnf.map.say.load_map = false
    callhandler('onMapChange', getmapname(), getgamemode())
    sdbs.cnf.map.say.load_map = true
    if #sdbs.cn.data == 0 then
        for cn = 0,  maxclient() -1 do
            if isconnected(cn) then
                callhandler('onPlayerPreconnect', cn)
                callhandler('onPlayerConnect', cn)
                sdbs.log:i('Reinit Player '..sdbs.cn.data[sdbs.cn.data_cn[cn]].name..' CN '..cn..' OK',cn)
            end
        end
    end
    sdbs.log:w("Init mod "..PLUGIN_NAME..' OK')
end

function onDestroy()
    sdbs.flag.C_LOG = true
    if sdbs.sql.cdb then
        sdbs.sql.db:close()
        sdbs.sql.handle:close()
        sdbs.sql.driver = nil
        sdbs.log:w("Deactivate driver MYSQL "..tostring(sdbs.sql.cdb))
    end
    sdbs.log:i("Destroy mod "..PLUGIN_NAME..' OK')
end
