-- Нендл вызова сервера

--(int actor_cn)
function onPlayerPreconnect (cn)
    sdbs.cn:preconnect(cn)
end
--(int actor_cn)
function onPlayerConnect(cn)   
    sdbs.cn:connect(cn)
end
--(int actor_cn, int reason)
function onPlayerDisconnect(cn,reasson)
    sdbs.cn:disconnect(cn,reasson)
end
--(int actor_cn, string new_name)
-- Смена имени игроком
function onPlayerNameChange(cn, nename)
    sdbs.cn:rename(cn,nename)
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
--(int actor_cn, int action, int flag)
-- Действия с флагом
function onFlagAction(cn, action, flag)
    if action == FA_DROP or action == FA_LOST then
        if sdbs.cnf.Flag.autoReset then
            if getgamemode() == GM_CTF then flagaction(cn,FA_RESET,flag) end
        end
    end
end
-- (string map_name, int game_mode)
-- Активация карты
function onMapChange(name, mode)
    sdbs.log:w('On Map Change')
    if sdbs.cnf.Game.autoTeam  and ( modemap == GM_TDM or modemap == GM_TSURV or modemap == GM_CTF or modemap == GM_TOSOK  or modemap == GM_TKTF ) then setautoteam(true) end
end