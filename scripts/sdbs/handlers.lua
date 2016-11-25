-- wait functions

--(int actor_cn)
function onPlayerPreconnect (cn)
    if sdbs.cn:preconnect(cn) then
        return PLUGIN_BLOCK
    end
end
--(int actor_cn)
function onPlayerConnect(cn) 
    if sdbs.cn:connect(cn) then
        return PLUGIN_BLOCK
    end
end
--(int actor_cn, int reason)
function onPlayerDisconnect(cn,reasson)
    sdbs.cn:disconnect(cn,reasson)
    --return PLUGIN_BLOCK
end
--(int actor_cn, string new_name)
-- Смена имени игроком
function onPlayerNameChange(cn, newname)
    if sdbs.cn:rename(cn,newname) then
        return PLUGIN_BLOCK
    end
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
    --sdbs.say:to(cn,math.abs(cn -1),'to player cn = '..(tostring(math.abs(cn -1))))
    --sdbs.say:pm(cn,math.abs(cn -1),'PM player cn = '..(tostring(math.abs(cn -1))))
    --sdbs.say:all(cn,'SayALL')
    --sdbs.say:allex(cn,math.abs(cn -1),'SayAllEx cn = '..(tostring(math.abs(cn -1))))
    if sdbs.cn:chk_commands(cn,text,team,me) then
        return PLUGIN_BLOCK
    end
    --sdbs.say:file('sdbs.txt')
end
--(int actor_cn, int action, int flag)
-- Действия с флагом
function onFlagAction(cn, action, flag)
    sdbs.gm.flag:flag_action(cn, action, flag)
    --return PLUGIN_BLOCK
end
-- (string map_name, int game_mode)
-- Активация карты
function onMapChange(name, mode)
    sdbs.gm.map:set_info(name, mode)
    sdbs.gm.map:set_auto_team(name, mode)
    sdbs.gm.map:say(name, mode)
end

sdbs.log:i('Require module handlers is OK')
