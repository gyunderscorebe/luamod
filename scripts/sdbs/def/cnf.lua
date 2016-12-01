-- Дефолтный конфигурационный файл

return {

    c_log = true,
    hidden_mod = false,

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
        city_say = true
    },

    cn = {
        kick_name = true,
        kick_name_say = true,
        kick_name_say_text = 'Name %s component contains prohibited on this site. It is prohibited by the rules.',
        kick_name_list = {
           'idioto', 'unarm', 'bich', 'stef', 'troll', 'tm'
        },
        connect_say = true,
        connect_say_text_me ='',
        connect_say_text_all ='',
        disconnect_say = true,
        disconnect_say_text = ''
    }
  
}
