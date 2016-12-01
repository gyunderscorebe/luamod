-- Дефолтный конфигурационный файл

return {

    c_log = true,
    show_mod = true,

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

            iso = '%s \f5%s\f2, ',
            country = '%s \f0%s\f2, ',
            city = '%s \fP%s\f2, ',

            connect_welcome = "\f2FOR SERVER OF FRIENDS, WELCOME YOU ",
            connect_all = "%s \f2CONNECTED FROM %s",
            connect_all_chk_admin ='%s \f2CONNECTED FROM %s \f4IP: \f3%s',

            disconnect_all = "%s \f2HAS LEFT THE SERVER !!!",
            disconnect_reasson = '\f1Reason for leaving: \f3%s\f1.',


            flag_drop = "\fPPlayer \f3%s \fPflag dropped",
            flag_lost = "\fPPlayer loses \f3%s \fPflag",

            auto_kick_name = 'Name %s component contains prohibited on this site. It is prohibited by the rules.',
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
            autoteam = true,
            -- Сказать правила игры при загрузке карты
            rules_map = true,
            -- Сказать правила игры при загрузке обычной карты
            rules_map_normal = true,
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
           'idioto', 'unarm', 'bich', 'stef', 'troll', 'tm'
        },
        -- использовать расщирение имени когда он что то сообщает кому то или всем
        connect_set_cn_name = true,
        -- format имени игрока когда он что то сообщает кому то или всем
        connect_set_cn_name_format = '(%g) %s: ',
        -- у каждого игрока свой цвет имени на весь connect
        connect_set_color_name = true,
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
        connect_say_rules_map_normal = true,
        -- Сказать какая карта загружена
        connect_say_load_map = true,
        -- Сказать что это карта гема
        connect_say_load_map_gema = true,
        --сказать о состоянии autoteam когда карта загружена
        connect_say_autoteam = true,
        -- Сказать какой режим карты
        connect_say_load_map_mode =true,
        
        -- сказать всем чтоя ухожу
        disconnect_say = true,
        -- сказать код выхода
        say_disconnect_reasson = true,
        -- сказать причину выхода если есть
        disconnect_say_message = true
    }
  
}
