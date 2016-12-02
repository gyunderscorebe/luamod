-- Дефолтный конфигурационный файл

return {

    c_log = true,
    disable_log_chk_mtr_autoteam = false,

    show_mod = true,

    sql = {
        flag =true,
        driver = 'luasql.mysql',
        db_name = 'sdbs_luamod',
        user = 'sdbs_luamod',
        pwd = 'sdbs_luamod',
        host = 'localhost'
    },

    geo = {
        -- активировать загрузку баз
        active = true,
        -- файл весит ~ 1 Mb
        country = true,
        -- файл весит ~ 17Mb
        city = true,
        -- пути к файлам баз GeoIp
        f_country = 'geo/GeoIP.dat',
        f_city = 'geo/GeoLiteCity.dat',
        iso_say = true,
        country_say = true,
        city_say = true,
    },

    say = {
        text = {
            color = SAY_TEXT,
            about = '\n\f2INFORMATION\n\t\fPSITE: \f5http://vah-clan.ga\n\t\fPEMAIL: \f5admin@vah-clan.ga\n\t\fPIRC: \f5freenode #vah\n\t\fPWIKI: \f5http://wiki.cubers.net/action/view/VAH_clan\n\t\fPFORUM: \f5http://forum.cubers.net/thread-8744.html\n\t\fPEnter \f3$help \fPto see a list of commands',
            key_about = '\n\t\t\fPPress \f3F11 \fPto display full information about the clan. \f0$about \fPor \f0$help \fPin cmd menu.',

            rules_map = '\nf0RULES:',
            rules_map_gema = '\n\f0RULES: \f2NO KILLING, NO CHEATING, NO HAHBIND',
            atention_gema = "\f0Attention \f9G\f2e\f1m\f0A ",
            autoteam = '\fPAutoteam is %s ',
            game_mode = '\f9%s \f2game mode. ',
            load_map = "\n\f2Installed \fP%s \f2playground. %s%s%s",
            welcome_name_map = '\n\f0You are to \fP%s \f2map. ',

            flag_drop = "\fPPlayer \f3%s \fPflag dropped",
            flag_lost = "\fPPlayer loses \f3%s \fPflag",

            iso = '%s \f5%s\f2, ',
            country = '%s \f0%s\f2, ',
            city = '%s \fP%s\f2, ',

            connect_welcome = "\f2FOR SERVER OF FRIENDS, WELCOME YOU ",
            connect_all = "%s \f2CONNECTED FROM %s",
            connect_all_chk_admin ='%s \f2CONNECTED FROM %s \f4IP: \f3%s',

            disconnect_all = "%s \f2HAS LEFT THE SERVER !!!",
            disconnect_reasson = '\f1Reason for leaving: \f3%s\f1.',

            auto_kick_name_message = '\f1Name \f3%s \f1component contains prohibited on this site. It is prohibited by the rules.',

            rename_message = "\f3!!! \f2Player name changes to %s \f3%s",
            not_rename_message = "\f2Player %s \f2tried to change the name on the \f3%s\f2. It is prohibited by the rules.",

            name_same_message = '\f3%s \fP- this name is already used by a player, present here. It is prohibited by the rules.',
            name_old_same_message = '\f3%s \fP- this name is already used by players who are here. It is prohibited by the rules.',

            admin_rename_message = "Player \f3%s \f2tried to become an administrator. Follow the rules, too use role.",
            admin_rename_kick_message = "\f9Administrator can not change the name \f3!!! \f9It is prohibited by the rules.",

            admin_role_change_admin_message_1 = "%s \f2has become the administrator of the game. \f3!!!",
            admin_role_change_admin_message_0 = "%s \f2administrator has become a regular player. \f3!!!",
        }
    },

    map = {
        -- листы проверки на gema
        list = {
            implicit = { "vah", "blue", 'gema' },
            code = { "g", "3e","m", "a@4" }
        },
        -- Автораспределение игроков на картах
        team = {
            auto = {
                --включить таймер автопроверки autoteam
                chk_tmr = true,
                -- проверка раз в 10 секунд
                chk_tmr_time = 10000,
                --на обычных картах
                map = true,
                -- на картах гема
                gema = false
            },
            -- где включать или отключать аутотеам в зависимости от карты gemf или нет
            -- на остальных режимах карт будет отключен
            mode = {
                TDM = true,
                TSURV = true,
                CTF = true,
                TOSOK = true,
                TKTF = true,
            }
        },
        say = {
            -- только при загрузке или перезагрузки карт но не при connect игрока
            -- Сказать какая карта загружена
            load_map = true,
            -- Сказать что это карта гема
            load_map_gema = true,
            -- Сказать какой режим карты
            load_map_mode = true,
            --сказать о состоянии autoteam когда карта загружена
            autoteam = false,
            -- Сказать правила игры при загрузке карты
            rules_map = true,
            -- Сказать правила игры при загрузке обычной карты
            rules_map_normal = false,
            -- Сказать правила игры при загрузке карты GEMA
            rules_map_gema = true
        },
        -- запуск сервера или загрузка карты в режиме master, w
        mode = {

        }
    },

    flag = {
        reset = {
            -- флаг возращается на место при сбросе флага игроком
            drop = true,
            -- сказать об этом
            say_drop = true,
            -- флаг возращается на место при гибели игрока
            lost = true,
            -- сказать об этом
            say_lost = true
        }
    },

    cn = {
        -- включить проверку на LoL name игрока
        auto_kick_name = true,
        -- сказать всем что поймался и выкинут
        auto_kick_name_say = true,
        -- лист запрещенных составляющих имени
        auto_kick_name_list = {
           'idiot', 'unarm', 'bich', 'stef', 'trol', 'tm'
        },

        -- использовать расщирение имени когда он что то сообщает кому то или всем
        connect_set_cn_name = true,
        -- format имени игрока когда он что то сообщает кому то или всем
        connect_set_cn_name_format = '(%g) %s: ',
        -- у каждого игрока свой цвет имени на весь connect
        connect_set_color_name = false,
        connect_set_colorize_char_name = true,
        -- говорить о бо мне если что
        connect_say = true,
        -- поприветствовать меня
        connect_say_me = true,
        -- сказать всем что я зашел
        connect_say_all = true,
        -- сказать мне абоут
        connect_say_about = true,

        -- только при соннекте игрока при загрузке карт следующих не действуют
        -- Сказать правила игры при загрузке карты
        connect_say_rules_map = true,
        -- Сказать правила игры при загрузке карты GEMA
        connect_say_rules_map_gema = true,
        -- Сказать правила игры при загрузке обычной карты
        connect_say_rules_map_normal = false,
        -- Сказать какая карта загружена
        connect_say_load_map = true,
        -- Сказать что это карта гема
        connect_say_load_map_gema = true,
        --сказать о состоянии autoteam когда карта загружена
        connect_say_autoteam = false,
        -- Сказать какой режим карты
        connect_say_load_map_mode =true,

        -- задержка вывода сообщений при коннекте
        connect_posts_delay = true,
        connect_posts_delay_time  = 1000,

        -- сказать всем чтоя ухожу
        disconnect_say = true,
        -- сказать код выхода
        disconnect_reasson_say = true,
        -- сказать причину выхода если есть
        disconnect_say_message = true,

        -- разрешить периименование
        rename = true,
        -- сообщить об этом всем
        rename_say = true,
        -- сказать всем что запрещено переименование
        not_rename_say = true,

        -- запретить или разрешить переименование админу если он в этой роли
        rename_admin = false,
        -- сказать всем что что админ нарушил правила но не выкидывая его
        rename_admin_say = true,
        -- выкинуть админа при перименовании если он в роли
        rename_admin_kick = true,
        -- сказать об этом всем что его выкинули
        rename_admin_kick_say = true,

        -- следить за сменой имени админа, пока он админ и убрать привилегию
        rename_chk_admin = true,
        -- сообщить что ты не можеш сменить роль, т.к. нарушил правила
        rename_chk_admin_say = true,

        -- сказать всем что админ сменил роль
        admin_role_change_say = true,

        --разрешить одинаковые имена
        name_same = false,
        -- сказать что обнапужены и будут наказаны
        name_same_say = true,
        --разрешить одинаковые имена уже бывшие во время игры у присутствующих игроков
        name_old_same = false,
        -- сказать всем про это
        name_old_same_say = true

    }

}
