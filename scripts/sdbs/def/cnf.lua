-- Дефолтный конфигурационный файл

return {

    lock_server = true,

    c_log = true,

    disable_log_chk_mtr_autoteam = false,

    show_mod = true,

    sql = {
        flag = true,
        library = 'luasql.mysql',
        driver = 'mysql',
        db_name = 'sdbs_ac_gema',
        user = 'sdbs_ac_gema',
        pwd = 'sdbs_ac_gema',
        host = 'localhost',
        port = '3306'
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
        iso_say = false,
        country_say = true,
        city_say = true,
    },

    say = {
        text = {

            lock_server_message = '\f3%s \f1player trying to enter a locked server.',

            privat_prefix = '\f7Privat message from ',
            color = SAY_TEXT,

            about = '\n\f2INFORMATION\n\t\fPSITE: \f5http://vah-clan.ga\n\t\fPEMAIL: \f5admin@vah-clan.ga\n\t\fPIRC: \f5freenode #vah\n\t\fPWIKI: \f5http://wiki.cubers.net/action/view/VAH_clan\n\t\fPFORUM: \f5http://forum.cubers.net/thread-8744.html',
            about_message = '\n\t\fPEnter \f3$help \fPto see a list of commands',
            key_about = SAY_NTAB..'\fPPress \f3F11 \fPto display full information about the clan. Or enter \f0$about\fP, \f0$cmd \fPor \f0$help \fPin console.',

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

            connect_welcome = "\f2FOR SERVER OF FRIENDS, WELCOME YOU %s \f2of %s",
            connect_all = "%s \f2CONNECTED FROM %s",
            connect_all_chk_admin ='%s \f2CONNECTED FROM %s \f4IP: \f3%s',

            disconnect_all = "%s \f2HAS LEFT THE SERVER !!!",
            disconnect_reasson = '\f1Reason for leaving: \f3%s\f1.',

            auto_kick_name_message = '\f1Name \f3%s \f1component contains prohibited on this site. It is prohibited by the rules.',

            rename_message = "\f3!!! \f2Player name changes to %s \f3%s",
            not_rename_message = "\f2Player %s \f2tried to change the name on the \f3%s\f2. It is prohibited by the rules.",

            name_same_message = '\f3%s \fP- this name is already used by a player, present here. It is prohibited by the rules.',
            name_old_same_message = '\f3%s \fP- this name is already used by players who are here. It is prohibited by the rules.',

            role_rename_message = "Player \f3%s \f2tried to become an registered. Follow the rules, too use role.",
            role_rename_kick_message = "\f9Registered can not change the name \f3!!! \f9It is prohibited by the rules.",

            role_change_admin_message_1 = "%s \f2has become the administrator of the game. \f3!!!",
            role_change_admin_message_0 = "%s \f2administrator has become a regular player. \f3!!!",

            role_change_me_message_0 = "You have this role \f3%s !!!",
            role_change_me_message_1 = 'You change of \f0%s',

            chk_commands_fix_message = '\f2Invalid command call, Enter the \f3$HELP \f2to view a list of commands available to you.',
            chk_commands_not_alloved_message = 'You do not have rights to view.'

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

    cmd = {

        registered_activate = false,

        text = {

            about_help = '\f1Summary Clan of Frends',

            help_help = '\f1Tips for working with the console commands',
            help_text = '\fPTo display a list of commands, depending of type of access level, type \f0$cmd \fPconsole. For more information on individual commands, enter \f0$<command> -h',

            cmd_help = '\f1It displays a list of available commands',
            cmd_text = '\fPFor more information on individual commands, enter \f0$<command> -h',

            pm_help = "\fPPrivat message. \f2Format: \f0$pm <CN> <TEXT>",
            pm_error = 'Invalid command call, Enter the \f3 $pm -h \f2for reference.',
            pm_error_cn = '\fPThis user has no \f3!!!',

            maptime_help = 'System time of server \f1Format: \f0$maptime <MINUTE>. \f10 < MINUTE <= 60',
            maptime_error = 'Invalid command call, Enter the \f3 $pm -h \f2for reference.',
            maptime_text = 'Established a new time \f9maps \f2= \f0%g',

            sudo_help = 'Set player role. \f1Format: \f0$sudo <PASSWD> \f2or \f0$sudo \f2for disable player role',
            sudo_error_valid = 'Not valid password !!!',
            sudo_error_empty = 'Empty PASSWORD !!!',

            su_help = 'Delegation roles. \f1Format\f2: \f0$su <CN> [<FLAG>]\f2. <FLAG> = [<admin or ad or 1>, <root or rot or 50>, <referee or ref or 51>, <registered or reg or 52>, <default or def or 0>]. \f9If not<FLAG> then delegation your role. If you admin, then your role disabled\f2.',
            su_error = 'Invalid command call, Enter the \f3 $su -h \f2for reference.',
            su_no_user = 'This user has no !!!',
            su_no_valid_pwd = 'Not valid password !!!',
            su_empty_pwd = 'Empty password !!!',

            useradd_error = 'Invalid command call, Enter the \f3 $useradd -h \f2for reference.',
            useradd_help = 'Invalid command call, Enter the \f3 $useradd -h \f2for reference.',

        }

    },

    cn = {
        -- включить проверку на LoL name игрока
        auto_kick_name = true,
        -- сказать всем что поймался и выкинут
        auto_kick_name_say = true,
        -- лист запрещенных составляющих имени
        auto_kick_name_list = {
           'idiot', 'unarm', 'bich', 'stef', 'trol', 'scuchka'
        },

        -- использовать расщирение имени когда он что то сообщает кому то или всем
        connect_set_cn_name = false,
        -- format имени игрока когда он что то сообщает кому то или всем
        connect_set_cn_name_format = '(%s) %s: ',
        connect_set_default_name_format = '%s: ',
        -- у каждого игрока свой цвет имени на весь connect
        connect_set_color_name = true,
        connect_set_colorize_char_name = false,
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

        -- запретить или разрешить переименование пользователю если он в роли
        rename_role = false,
        -- сказать всем зарегистрированный юзер нарушил правила но не выкидывая его
        rename_role_say = true,
        -- выкинуть зарегистрированного узера при перименовании если он в роли
        rename_role_kick = true,
        -- сказать об этом всем что его выкинули
        rename_role_kick_say = true,

        -- следить за сменой имени узера, пока он зарегестрированный и убрать привилегию
        rename_chk_role = true,
        -- сообщить что ты не можеш сменить роль, т.к. нарушил правила
        rename_chk_role_say = true,

        -- сказать мне какая у меня теперь роль
        role_change_me_say = true,
        -- сказать всем что админ сменил роль
        role_change_admin_say = true,

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
