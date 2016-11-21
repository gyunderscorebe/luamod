-- Дефолтный конфигурационный файл

return {
    -- Токо когда утерян или испорчен файл конфигурации
    CreateDefCnf = false,
    -- Встроенный модуль GeoIp http://geolite.maxmind.com
    Geo = {
        Activate = true,
        -- файл весит ~ 1 Mb
        Country = true,
        -- файл весит ~ 17Mb
        City = true,
        -- пути к файлам баз GeoIp
        FCountry = 'geo/GeoIP.dat',
        FCity = 'geo/GeoLiteCity.dat',
    },
    Cursor = {
        -- по дефолту вывод сообщений в консоль игры будет предваряться в следующем виде: [root@frends.vah-clan.ga]$  в качестве системного сообщения
        -- ну а для каждого игрока [<NAME>@<MODE>.vah-clan.ga]$
        user = "root",
        server = "frends",
        domain = "vah-clan.ga"
    },
    Cn = {
        --сказать всем что игрок зашел в игру
        sayAllLoginName = true,
        -- поприветствовать игрока
        sayMeLoginName = true,
        -- Запретить одинаковые имена в игре при входе и выкнинуть
        notLoginSameName = true,
        -- Сообщать всем о попытке входа игрока с именем которое уже используется в игре при notLoginSameName = true
        sayAllNotLoginSameName = true,
        -- запретить вход новому игроку  если у какого-то игрока уже было такое имя, но он сменил его на другое, перед входом нового игрока и выкинуть выкиннуть
        notLoginOldSameName = false,
        -- Сообщать всем о попытке входа игрока с именем которое уже использовалось присутствующем в игре игроком при notLoginOldSameName = false
        sayAllNotLoginOldSameName = true,
        
        -- Сказать что игрок <NAME> сменил на <NEWNAME>, если конечно не выкинут
        sayAllRename = true,
        -- Запретить смену имени в игре и выкинуть
        notRename = false,
        -- В процессе, пока только выкидует
        -- true - выкинуть если запрещено переименование false - оставить старое имя на стороне сервера и на стороне клиента
        -- notRenameKick = false,
        -- Сообщать всем о попытке смены имени игрока при смене имени если notRename = true
        sayAllNotRename = true,

        -- Запретить смену имени в игре если уже есть такое имя и выкинуть
        notAllowSameName = true,
        -- В процессе, пока только выкидует
        -- Выкинуть если запрещены одинаковые имена при смене имени
        --notAllowSameNameKick = true,
        -- Сообщать всем о попытке смены имени игрока если уже есть такое имя при notAllowSameName = true
        sayAllNotAllowSameName = true,

        -- Запретить смену имени в игре если уже было такое имя у действующего игрока и выкинуть
        notAllowOldSameName = false,
        -- В процессе, пока только выкидует
        -- Выкинуть если уже было такое имя у действующего игрока
        --notAllowOldSameNameKick = true,
        -- Сообщать всем о попытке смены имени игрока если уже было такое имя у действующего игрока notAllowOldSameName = true
        sayAllNotAllowOldSameName = true,
        
        -- Запретить вход игроку с именем из списка
        abortName = false,
        listAbortName = { 'unarmed' }
    },
    Flag = {
        autoReset = true
    },
    Game = {
        autoTeam = true,
        gemaAutoTeam = false
    }
}
