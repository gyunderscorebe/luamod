PLUGIN_NAME = "aCmOdFoRvAh"
PLUGIN_AUTHOR = "SDBS"
PLUGIN_VERSION = "1.0.5"

-- reload lua as admin:  /serverextention lua::reload --

sdbs = {
    path = "lua/scripts/sdbs/"
}

package.path = sdbs.path.."?.lua;"

-- Пишет в stdout, для отладки токо
sdbs.C_LOG = true

require('constants')

sdbs.fn = require('function')
sdbs.fn:init(sdbs)
sdbs.fn:load('log')

local callResult, result = pcall(dofile, sdbs.path..'cnf.lua')
if callResult then sdbs.cnf = result sdbs.log:i('Module cnf init is OK') else
    sdbs.log:w(result)
    sdbs.log:w("Restore default configuration")
    sdbs.fn:copy_file(sdbs.path.."def/cnf.lua",sdbs.path.."cnf.lua")
    sdbs.log:w("Load default configuration")
    sdbs.fn:load('cnf')
end

sdbs.fn:load('say')
sdbs.fn:load('gm','game')
sdbs.fn:load('cn')
sdbs.fn:load('cmd','commands')

if sdbs.cnf.geo.activate then
    if sdbs.cnf.geo.country then geoip.load_geoip_database(sdbs.path..sdbs.cnf.geo.f_country) sdbs.log:i("Activate GeoIP Country + CC") end
    if sdbs.cnf.geo.city then geoip.load_geocity_database(sdbs.path..sdbs.cnf.geo.f_city) sdbs.log:w("Activate GeoIP City") end
end

require('handlers')
function onInit()
    setautoteam(false)
    sdbs.C_LOG = sdbs.cnf.c_log
    sdbs.log:w("Map autoteam is  "..tostring(getautoteam()))
    sdbs.log:w("Init mod "..PLUGIN_NAME..' is  OK')
end

function onDestroy()
    sdbs.log:w("Destroy mod "..PLUGIN_NAME..' is  OK')
end
