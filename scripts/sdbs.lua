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

sdbs.fn = require('fn')
sdbs.fn:init(sdbs)
sdbs.fn:load('log')

function onInit()
end

function onDestroy()

end
