-- Дефолтный конфигурационный файл

return {
    -- включать токо для отладки, идет вывод в сонсоль
    c_log = true,
    -- режим сообщений для гема
    say_gema = true,
    say = {
        cursor = {
            def_name = "ac",
            def_server = "frends",
            def_domain = "vah-clan.ga",
            active = false,
            randomcolor = false,
            color = SAY_GRAY,
            format = "[<NAME>@<SERVER>.<DOMAIN>]$"
        },
        -- обертка имени игрока. типа >>>-{<NAME>}-> (0). а также задание параметров отображения имени если даже active = false
        wrapp = {
            active = true,
            randomcolor = false,
            color = SAY_INFO,
            delimiter = SAY_LIGHTGRAY..' : ',
            format = '<CN> <NAME>', --">>>~<NAME>~>(<CN>)"
        },
        text = {
            color = SAY_TEXT,
            key_about = '\n\t\t\t\f9Press F11 to display full information about the clan.',
            about = '\n\f2INFORMATION\n\t\f1SITE: \f5http://vah-clan.ga\n\t\f1EMAIL: \f5admin@vah-clan.ga\n\t\f1IRC: \f5freenode #vah\n\t\f1WIKI: \f5http://wiki.cubers.net/action/view/VAH_clan\n\t\f1FORUM: \f5http://forum.cubers.net/thread-8744.html\n\t\f1enter \f3$help \f1in console to see a list of commands',
            rules_map = '\nf0RULES:',
            rules_map_gema = '\n\f0RULES: \f2NO KILLING, NO CHEATING, NO HAHBIND',
            atention_gema = "\f0Attention \f9G\f2e\f1m\f0A ",
            welcome = "FOR SERVER OF FRIENDS, WELCOME YOU ",
            welcome_name_map = '\nYou are to \fP%s \f2map. ',
            connect = "%s \f2CONNECTED FROM %s",
            connect_for_admin = "%s \f2CONNECTED FROM %s \f4IP: \f3%s",
            autoteam = '\fPAutoteam is %s ',
            game_mode = '\f9%s \f2game mode. ',
            load_map = "\n\f2Installed \fP%s \f2playground. %s%s%s",
            geo_iso = '%s \f5%s\f2, ',
            geo_country = '%s \f0%s\f2, ',
            geo_city = '%s \fP%s\f2, '
        },
        -- включить использование цветовых символов в выводе текста cmd комманд
        colorize_text_cmd = true
    },
    geo = {
        -- активировать загрузку баз
        activate = true,
        -- файл весит ~ 1 Mb
        country = true,
        -- файл весит ~ 17Mb
        city = true,
        say_iso = true,
        say_country = true,
        say_city = true,
        -- пути к файлам баз GeoIp
        f_country = 'geo/GeoIP.dat',
        f_city = 'geo/GeoLiteCity.dat'
    },
    map = {
        list = {
            implicit = { "vah", "blue", 'gema' },
            code = { "g", "3e","m", "a@4" }
        },
        -- Автораспределение игроков на картах
        team = {
            auto = {
                map = false,
                gema = true
            },
            mode = {
                TDM = true,
                TSURV = true,
                CTF = true,
                TOSOK = true,
                TKTF = true,
            }
        },
        say = {
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
        -- сказать ABOUT CLAN при заходе на сервер
        say_connect_about = true,
        -- Сказать какая карта при заходе игрока на сервер
        say_connect_load_map = true,
        -- Сказать что это карта гема
        say_connect_load_map_gema = true,
        -- Сказать какой режим карты
        say_connect_load_map_mode = true,
        --сказать о состоянии autoteam когда карта загружена
        say_connect_autoteam = true,
        -- сказать правила игры при заходе на сервер
        say_connect_rules_map = true,
        -- сказать правила нормальной игры при заходе на сервер
        say_connect_rules_map_normal = true,
        -- сказать правила режима GEMA при заходе на сервер
        say_connect_rules_map_gema = true,
        -- сказать всем что игрок на поле
        say_connect = true,
        -- поприветствовать игрока
        say_connect_me = true,
        -- сказать всем что игрок сбежал
        say_disconnect = true,
        -- запретить вход с одинаковыми именами
        not_connect_same_name = true,
        -- запретить вход с именем, если действующий игрок уже его использовал в игре
        not_connect_old_same_name = false,
        -- сказать что кто то стал админом
        say_admin_role_change = true,
        -- запретить смену имени админу, перед и после смен ролей на админа и ли не админа или пока админ
        not_admin_rename = true,
        -- сообщить что ты не можеш сменить роль, т.к. нарушил правила
        sya_not_admin_rename = true,
        -- если да то выкинет если нет то не даст стать админом
        not_admin_rename_kick = false,
        -- сказать всем что для админа это тоже действует
        say_not_admin_rename_kick = true,
        -- сказать всем о смене имени игроком
        say_rename = true,
        -- запретить переименование
        not_rename = false,
        -- сказать всем что игрока выкинули за переименование если правило это запрещает
        say_not_rename = true,
        -- запретить переименование если уже есть игрок с таким именем
        not_allow_same_name = true,
        -- сказать всем что игрока выкинули за переименование если правило это запрещает
        say_not_allow_same_name = true,
        -- запретить переименование , если какой - то действующий игрок уже его использовал в игре
        not_allow_old_same_name = false,
        -- сказать всем что игрока выкинули за переименование если правило это запрещает
        say_not_allow_old_same_name = true,
        -- проверять имена на запрещенные слова при connect и rename
        active_chkeck_ban_name = true,
        -- сказать всем что игрока выкинули за это если правило это запрещает
        say_active_chkeck_ban_name = true,
        -- чек лист с запрещенными состовляющими ника )))
        chkeck_ban_name_list = {
            'idioto', 'unarme', 'bich', 'stef', 'troll', 'tm'
        }
    }
}
