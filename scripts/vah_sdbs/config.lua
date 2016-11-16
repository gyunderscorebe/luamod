-- Конфигурационный файл

__sdbs.config = {
    name = "config.lua",
    -- Вывод сообщений скрипта в stdout. ждля отладки
    logLine = true,
    defaultDomain = "vah-clan.ga",
    defaultUser = "root",
    defaultServer = "frends",
    -- Авто ресет флаг при потере сбросе флага или гибели игрока
    flag = {
        reset = true,
        say = true,
    },
    -- Разрешить одинаковые имена
    allowSameName = false,
    -- Обворачивает имя игрока в >>>-(CN)-{ NAME }-> можно изменить
    wrapperName = true,
    -- Если игрок сменил имя на другое и хочет стать админом или наоборот админ меняет свое имя, то выкинуть с сервера
    disconnectLoLadmin = true,
    -- Говорить всем кто стал админом :D
    onSayAdminRoleChanged = true,
    -- автоопределение режима игры не отключать лучше
    autoDetectingMode = true,
    -- Предустановки карты при ее выборе и загрузке
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
            loadMap = true,
            -- Сказать что это карта гема
            loadMapGema = true
        }
    }
    -- автоопределение карты гема
    --autoDetectingGemaMode = true,
    --Выключить мод если не gema
    --tyrnOfModIsNotGema = false,
    --configrandommaprot = false --I like randomness
}

print ("dofile config.lua")