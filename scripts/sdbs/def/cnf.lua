-- Дефолтный конфигурационный файл

return {
    c_log = true,
    say = {
        cursor = {
            def_name = "ac",
            def_server = "frends",
            def_domain = "vah-clan.ga",
            active = true,
            randomcolor = false,
            format = "[<NAME>@<SERVER>.<DOMAIN>]$"
        },
        -- обертка имени игрока. типа >>>-{<NAME>}-> (0)
        wrapp = {
            active = true,
            randomcolor = true,
            format = ">>>~<NAME>~>(<CN>)",
        }
    },
    geo = {
        -- активировать загрузку баз
        activate = true,
        -- файл весит ~ 1 Mb
        country = true,
        -- файл весит ~ 17Mb
        city = true,
        -- пути к файлам баз GeoIp
        f_country = 'geo/GeoIP.dat',
        f_city = 'geo/GeoLiteCity.dat'
    },
    map = {
        list = {
            implicit = { "vah", "blue" },
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
        not_login_old_same_name = true,
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
        not_allow_old_same_name = true,
        -- сказать всем что игрока выкинули за переименование если правило это запрещает
        say_not_allow_old_same_name = true
    }
}