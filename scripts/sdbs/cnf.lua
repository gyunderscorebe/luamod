-- Дефолтный конфигурационный файл

return {
    c_log = true,
    say = {
        cursor = {
            def_name = "ac",
            def_server = "frends",
            def_domain = "vah-clan.ga",
            active = true,
            randomcolor = true,
            color = SAY_GRAY,
            format = "[<NAME>@<SERVER>.<DOMAIN>]$"
        },
        -- обертка имени игрока. типа >>>-{<NAME>}-> (0)
        wrapp = {
            active = false,
            randomcolor = true,
            color = SAY_INFO,
            format = ">>>~<NAME>~>(<CN>)",
        },
        text = {
            color = SAY_TEXT
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
        say_country = true,
        say_iso = false,
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
                map = true,
                gema = false
            }
        },
        say = {
            -- Сказать какая карта загружена
            load_map = true,
            -- Сказать что это карта гема
            load_map_gema = true
        }
    },
    flag = {
        reset = {
            -- флаг возращается на место при сбросе флага игроком
            drop = true,
            -- сказать об этом
            say_drop = true,
            -- флаг возращается на место при гибели игрока
            lost = false,
            -- сказать об этом
            say_lost = true
        }
    },
    cn = {
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

    }
}
