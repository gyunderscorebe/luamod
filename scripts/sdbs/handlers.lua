-- wait functions

--(int actor_cn)
function onPlayerPreconnect (cn)
    --if cn == 1 then setip(cn,'185.5.250.123') end
    --if cn == 1 then setip(cn,'212.20.45.40 ') end
    local ret = sdbs.cn:on_preconnect(cn)
    if ret == PLUGIN_BLOCK then return PLUGIN_BLOCK end
    return
end
--(int actor_cn)
function onPlayerConnect(cn) 
    local ret = sdbs.cn:on_connect(cn)
    if ret == PLUGIN_BLOCK then return PLUGIN_BLOCK end
    return
end
--(int actor_cn, int reason)
function onPlayerDisconnect(cn,reasson)
    sdbs.cn:on_disconnect(cn,reasson)
    --return PLUGIN_BLOCK
    return
end
--(int actor_cn, string new_name)
-- Смена имени игроком
function onPlayerNameChange(cn, newname)
    local ret = sdbs.cn:on_rename(cn,newname)
    if ret == PLUGIN_BLOCK then return PLUGIN_BLOCK end
    return
end

function onPlayerRoleChange(cn, new_role, hash, pwd, isconnect)
    local ret = sdbs.cn:on_role_change(cn, new_role, hash, pwd, isconnect)
    if ret == PLUGIN_BLOCK then return PLUGIN_BLOCK end
    return
end
--(int target_cn, int actor_cn, bool gib, int gun) 
-- Смерть игрока
function onPlayerDeath(tcn,cn,gib,gun)

end
--(int actor_cn, int target_cn, int damage, int actor_gun, bool gib)
-- Повреждение игрока
function onPlayerDamage(cn ,tcn, damage, gun, gib)
end
-- = int (vote error); (int actor_cn, int type, string text, int number, int vote_error)
-- голосование игроком
function onPlayerCallVote(cn, type,text, number, vote_error)
end
--(int actor_cn, int sound)
--Игрок что то сказал в консоль
function onPlayerSayVoice(cn, sound)
end
-- (int sender_cn, string text, bool team, bool me)
function onPlayerSayText(cn,text,team,me)
    local ret = sdbs.cn:on_say_text(cn,text,team,me)
    if ret == PLUGIN_BLOCK then return PLUGIN_BLOCK end
    return
end
--(int actor_cn, int action, int flag)
-- Действия с флагом
function onFlagAction(cn, action, flag)
    sdbs.gm.flag:on_flag_action(cn, action, flag)
    return
end
-- (string map_name, int game_mode)
-- Активация карты
function onMapChange(name, mode)
    sdbs.gm.map:on_map_change(name,mode)
    return
end

function onMapEnd()
    sdbs.gm.map:on_map_end()
    return
end

sdbs.log:i('Module handlers init OK')
