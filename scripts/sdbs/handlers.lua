-- wait functions

--(int actor_cn)
function onPlayerPreconnect (cn)
    sdbs.cn:preconnect(cn)
    --return PLUGIN_BLOCK
end
--(int actor_cn)
function onPlayerConnect(cn) 
    sdbs.cn:connect(cn)
    --return PLUGIN_BLOCK
end
--(int actor_cn, int reason)
function onPlayerDisconnect(cn,reasson)
    sdbs.cn:disconnect(cn,reasson)
    --return PLUGIN_BLOCK
end
--(int actor_cn, string new_name)
-- Смена имени игроком
function onPlayerNameChange(cn, newname)
   sdbs.cn:rename(cn,newname)
   return PLUGIN_BLOCK
end
function onPlayerRoleChange(cn, new_role, hash, pwd, isconnect)

    if sdbs.cn:role_change(cn, new_role, hash, pwd, isconnect) then
        return PLUGIN_BLOCK
    end
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
    --sdbs.say:me(cn,text)
    --sdbs.say:pm(cn,'PM player cn = '..(tostring(math.abs(cn -1))),math.abs(cn -1))
    --sdbs.say:all(cn,'SayALL')
    --sdbs.say:allex(cn,'SayAllEx cn = '..(tostring(math.abs(cn -1))),math.abs(cn -1))
    return sdbs.cn:chk_commands(cn,text)
    --sdbs.say:file('sdbs.txt')
end
--(int actor_cn, int action, int flag)
-- Действия с флагом
function onFlagAction(cn, action, flag)
end
-- (string map_name, int game_mode)
-- Активация карты
function onMapChange(name, mode)
    sdbs.gm.map:set_info(name, mode)
end

sdbs.log:i('Require module handlers is OK')