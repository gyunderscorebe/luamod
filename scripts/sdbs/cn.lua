return {

    d_reasson = {
            --number
        [DISC_NONE] = 'NONE',
        [DISC_EOP] = 'EOP',
        [DISC_CN] = 'CN',
        [DISC_MKICK] = 'MKICK',
        [DISC_MBAN] = 'MBAN',
        [DISC_TAGT] = 'TAGT',
        [DISC_BANREFUSE] = 'BANREFUSE',
        [DISC_WRONGPW] = 'WRONGPW',
        [DISC_SOPLOGINFAIL] = 'SOPLOGINFAIL',
        [DISC_MAXCLIENTS] = 'MAXCLIENTS',
        [DISC_MASTERMODE] = 'MASTERMODE',
        [DISC_AUTOKICK] = 'AUTOKICK',
        [DISC_AUTOBAN] = 'AUTOBAN',
        [DISC_DUP] = 'DUP',
        [DISC_BADNICK] = 'BADNICK',
        [DISC_OVERFLOW] = 'OVERFLOW',
        [DISC_ABUSE] = 'ABUSE',
        [DISC_AFK] = 'AFK',
        [DISC_FFIRE] = 'FFIRE',
        [DISC_CHEAT] = 'CHEAT',
            --string
        NONE = DISC_NONE,
        EOP = DISC_EOP,
        CN = DISC_CN,
        MKICK = DISC_MKICK,
        MBAN = DISC_MBAN,
        TAGT = DISC_TAGT,
        BANREFUSE = DISC_BANREFUSE,
        WRONGPW = DISC_WRONGPW,
        SOPLOGINFAIL = DISC_SOPLOGINFAIL,
        MAXCLIENTS = DISC_MAXCLIENTS,
        MASTERMODE = DISC_MASTERMODE,
        AUTOKICK = DISC_AUTOKICK,
        AUTOBAN = DISC_AUTOBAN,
        DUP = DISC_DUP,
        BADNICK = DISC_BADNICK,
        OVERFLOW = DISC_OVERFLOW,
        ABUSE = DISC_ABUSE,
        AFK = DISC_AFK,
        FFIRE = DISC_FFIRE,
        CHEAT = DISC_CHEAT
    },
    get_d_reasson = function(self,reasson)
        if self.d_reasson[reasson] ~= nil then
            return self.d_reasson[reasson]
        end
        return nil
    end,

    d_force = {
        cn = nil,
        reasson = nil,
        message = nil
    },

    roles = {
            --clientroles
        [CR_ADMIN] = 'ADMIN',
        [CR_DEFAULT] = 'DEFAULT',
        [CR_ROOT] = 'ROOT',
        [CR_REFEREE] = 'REFEREE',
        [CR_REGISTERED] = 'REGISTERED',
        ADMIN = CR_ADMIN,
        DEFAULT = CR_DEFAULT,
        ROOT = CR_ROOT,
        REFEREE = CR_REFEREE,
        REGISTERED = CR_REGISTERED,
        AD = CR_ADMIN,
        DEF = CR_DEFAULT,
        ROT = CR_ROOT,
        REF = CR_REFEREE,
        REG = CR_REGISTERED
    },
    get_role = function(self,role)
        if type(role) == 'string' then
            if  tonumber(role) == nil then role = string.upper(role) else role = self:get_role(tonumber(role)) end
        end
        if self.roles[role] ~= nil then
            return self.roles[role]
        end
        return nil
    end,

    data = {},
    data_cn = {},

    chk_cn = function(self,cn)
        if self.data_cn[cn] ~= nil and self.data[self.data_cn[cn]] ~= nil and self.data[self.data_cn[cn]].cn == cn then
            return true
        end
        return false
    end,
    chk_admin = function(self,cn)
        if self:chk_cn(cn) and ( self.data[self.data_cn[cn]].role == self:get_role('ADMIN') or isadmin(cn)) then return true end
        return false
    end,
    chk_registered = function(self,cn)
        if self:chk_cn(cn) and self.data[self.data_cn[cn]].role == self:get_role('REGISTERED') then return true end
        return false
    end,
    chk_referee = function(self,cn)
        if self:chk_cn(cn) and self.data[self.data_cn[cn]].role == self:get_role('REFEREE') then return true end
        return false
    end,
    chk_root = function(self,cn)
        if self:chk_cn(cn) and self.data[self.data_cn[cn]].role == self:get_role('ROOT') then return true end
        return false
    end,
    chk_role = function(self,cn)
        if self:chk_cn(cn) and ( self.data[self.data_cn[cn]].role ~= self:get_role('DEFAULT') or isadmin(cn) ) then return true end
        return false
    end,

    chk_show_mod = function(self,cn)
        if self:chk_cn(cn) and self.data[self.data_cn[cn]].show_mod == true then
            return true
        end
        return false
    end,

    set_role = function(self,cn,role)
        if self:chk_cn(cn) then
            local dcn = self.data_cn[cn]
            if self:get_role(role) ~= nil then self.data[dcn].role = self:get_role(role) end
            if role ~= 'DEFAULT' then self.data[dcn].show_mod = true else self.data[dcn].show_mod = false end
        end
    end,

    get_role_cn = function(self,cn)
        if self:chk_cn(cn) then return self.data[self.data_cn[cn]].role end
        return nil
    end,

    get_name = function(self,cn)
        if self:chk_cn(cn) then
            return self.data[self.data_cn[cn]].name
        end
        return false
    end,
    get_admin = function(self)
        for _,v in ipairs(self.data) do
            if self:chk_admin(v.cn) and isadmin(v.cn) then return v.cn end
        end
        return nil
    end,
    get_chk_data_cn = function(self,cn)
        if self:chk_cn(cn)  then
            self.parent.log:i('get_chk_data_cn',cn)
            self.parent.log:i(string.format('TABLE DATA_CN - CN: %s DCN: %s | TABLE DATA - Name: %s CN: %s DCN: %s | Role: %s status: %s | Show_mod: %s',cn,self.data_cn[cn],self.data[self.data_cn[cn]].name, self.data[self.data_cn[cn]].cn, self.data[self.data_cn[cn]].dcn, self:get_role(self.data[self.data_cn[cn]].role), tostring(self:chk_role(cn)), tostring(self:chk_show_mod(cn))))
        else
            self.parent.log:i('get_chk_data_cn in DATA',cn)
            for _,v in pairs(self.data) do
                self.parent.log:i(string.format('TABLE DATA_CN - CN: %s DCN: %s | TABLE DATA - Name: %s CN: %s DCN: %s | Role: %s status: %s | Show_mod: %s',v.cn,self.data_cn[v.cn],v.name, v.cn, v.dcn, self:get_role(v.role), tostring(self:chk_role(v.cn)), tostring(self:chk_show_mod(v.cn))))
            end
            self.parent.log:i('get_chk_data_cn in DATA_CN',cn)
            for i = 0, maxclient() -1 do
                if self.data_cn[i] ~= nil then
                    self.parent.log:i(string.format('TABLE DATA_CN - CN: %s DCN: %s | TABLE DATA - Name: %s CN: %s DCN: %s | Role: %s status: %s | Show_mod: %s',i,self.data_cn[i],self.data[self.data_cn[i]].name, self.data[self.data_cn[i]].cn, self.data[self.data_cn[i]].dcn, self:get_role(self.data[self.data_cn[i]].role), tostring(self:chk_role(cn)), tostring(self:chk_show_mod(i))))
                end
            end
        end
    end,

    chk_role_status = function(self,cn)
        if self:chk_cn(cn) then
            self.parent.log:i(string.format('Player cn: %s, Role : %s, status: %s, Show_mod: %s',tostring(self.data[cn].cn),self:get_role(self.data[self.data_cn[cn]].role), tostring(self:chk_role(cn)), tostring(self:chk_show_mod(cn))))
        else
            for _,v in ipairs(self.data) do
                self.parent.log:i(string.format('Player cn: %s, Role : %s, status: %s, Show_mod: %s',tostring(v.cn),self:get_role(v.role), tostring(self:chk_role(v.cn)), tostring(self:chk_show_mod(v.cn))))
            end
        end
    end,

    auto_kick_name = function(self,cn,name)
        sdbs.log:i('Check kick_name_list', cn)
        local lname = name:lower()
        if self.parent.cnf.cn.auto_kick_name then
            for _,v in ipairs(self.parent.cnf.cn.auto_kick_name_list) do
                if name:find(v) then
                    self.parent.log:w("Find name in kick_name_list OK",cn)
                    self.d_force.cn = cn
                    self.d_force.reasson = self:get_d_reasson('BADNICK')
                    if self.parent.cnf.cn.auto_kick_name_say then
                        self.d_force.message = string.format(self.parent.cnf.say.text.auto_kick_name_message,name)
                    end
                    --self:force_disconnect()
                    return true
                end
            end
        end
        return false
    end,

    chk_same_and_old_same_name = function (self,cn,name)
        if #self.data > 0 and ( not self.parent.cnf.cn.name_same or not self.parent.cnf.cn.name_old_same ) then
            --self.parent.log:w("Name search ")
            local lname = name:lower()
            for k,v in ipairs(self.data) do
                if cn ~= v.cn and k == v.dcn then
                    if not self.parent.cnf.cn.name_same then
                        --self.parent.log:w("Name search ".. v.name)
                        if v.name:lower() == lname then
                            self.parent.log:w(string.format("Find name: %s in name list players = true",name),cn)
                            self.d_force.cn = cn
                            self.d_force.reasson = self:get_d_reasson('DUP')
                            if self.parent.cnf.cn.name_same_say then
                                self.d_force.message = string.format(self.parent.cnf.say.text.name_same_message,name)
                            end
                            return true
                        end
                    end
                    if not self.parent.cnf.cn.name_old_same then
                        if #v.oldname > 0 then
                            for _,vv in ipairs(v.oldname) do
                                -- self.parent.log:w("Oldname search "..vv..' name '..v.name,cn)
                                if vv:lower() == lname then
                                    self.parent.log:w(string.format("Find name: %s in old name list players = true",name),cn)
                                    self.d_force.n = cn
                                    self.d_force.reasson = self:get_d_reasson('DUP')
                                    if self.parent.cnf.cn.name_old_same_say then
                                        self.d_force.message = string.format(self.parent.cnf.say.text.name_old_same_message,name)
                                    end
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end
        return false
        -- PLUGIN_BLOCK
    end,

    on_preconnect = function(self,cn)
        sdbs.log:i('Preconnect...', cn)
        if isconnected(cn) then
            local name = getname(cn)
            self.parent.log:i('Preconnect OK',cn)

            if self.parent.flag.lock_server and #self.data > 0 then
                self.parent.log:w(string.format("Player: %s connect in server. Flag lock_server:",name,self.parent.flag.lock_server),cn)
                self.d_force.cn = cn
                self.d_force.reasson = self:get_d_reasson('MASTERMODE')
                if self.parent.cnf.cn.name_same_say then
                    self.d_force.message = string.format(self.parent.cnf.say.text.lock_server_message,name)
                end
                return  PLUGIN_BLOCK
            end

            if self:auto_kick_name(cn,name) then
                return  PLUGIN_BLOCK
            end
            if self:chk_same_and_old_same_name(cn,name) then
                return  PLUGIN_BLOCK
            end
        else
            sdbs.log:w('Preconnect NO', cn)
            --return PLUGIN_BLOCK
            return
        end
    end,

    add_cn = function(self,cn)
        self.parent.log:i('AddCn...',cn)
        if self.data_cn[cn] == nil then
            --if cn == 1 then setip(1,'212.20.45.40') end
            local name = getname(cn)
            local ip = getip(cn)
            table.insert(self.data, {
                cn = cn,
                dcn = nil,
                name = name,
                c_name = SAY_INFO,
                oldname = {},
                count_rename = 0,
                count_old_name = 0,
                ip = ip,
                country = '',
                iso = '',
                city = '',
                geo = '',
                role = nil,
                login = false,
                show_mod = false,
                tmr_connect_say = nil
            })

            local dcn = #self.data
            self.data_cn[cn] = dcn
            self.data[dcn].dcn = dcn
            if isadmin(cn) then
                self.data[dcn].role = self:get_role('ADMIN')
                self.data[dcn].show_mod = true
            else self.data[dcn].role = self:get_role('DEFAULT') end

            if self.parent.cnf.cn.connect_set_color_name then
                self.data[dcn].c_name = self.parent.fn:random_color_cn()
            end

            local c_name = self.data[dcn].c_name

            if self.parent.cnf.geo.active then
                if self.parent.cnf.geo.country then
                    self.data[dcn].country = geoip.ip_to_country(ip)
                    if self.data[dcn].country == 'unknown' then self.data[dcn].country = 'Country' end
                    self.data[dcn].iso = geoip.ip_to_country_code(ip)
                    if self.data[dcn].iso == 'n/a' then self.data[dcn].iso = 'ISO' end
                    if self.parent.cnf.geo.iso_say then
                        self.data[dcn].geo = string.format(self.parent.cnf.say.text.iso, self.data[dcn].geo,self.data[dcn].iso)
                    end
                    if self.parent.cnf.geo.country_say then
                        self.data[dcn].geo = string.format(self.parent.cnf.say.text.country, self.data[dcn].geo,self.data[dcn].country)
                    end
                end
                if self.parent.cnf.geo.city then
                    self.data[dcn].city = geoip.ip_to_city(ip)
                    if self.data[dcn].city == '' then self.data[dcn].city = 'Moon' end
                    if self.parent.cnf.geo.city_say then
                        self.data[dcn].geo = string.format(self.parent.cnf.say.text.city, self.data[dcn].geo,self.data[dcn].city)
                    end
                end
            end

            if #self.data[dcn].geo > 0 then self.data[dcn].geo = self.data[dcn].geo:sub(0,#self.data[dcn].geo-2) end

            if self.parent.cnf.cn.connect_say then

                if self.parent.cnf.cn.connect_say_all then
                    for _,v in ipairs(self.data) do
                        if v.cn ~= cn and isconnected(v.cn) then
                            local show_mod = v.show_mod
                            v.show_mod = true
                            if self:chk_role(v.cn) then
                                self.parent.say:to(cn,v.cn,string.format(self.parent.cnf.say.text.connect_all_chk_admin,c_name..self.data[dcn].name,self.data[dcn].geo,self.data[dcn].ip))
                            else
                                self.parent.say:to(cn,v.cn,string.format(self.parent.cnf.say.text.connect_all,c_name..self.data[dcn].name,self.data[dcn].geo))
                            end
                            v.show_mod = show_mod
                        end
                    end
                end

                if self.parent.cnf.cn.connect_say_me then

                    local key_about, map, gema, mode, autoteam  = '', '', '','',''

                    if self.parent.cnf.cn.connect_say_load_map then

                        map =string.format(self.parent.cnf.say.text.welcome_name_map, self.parent.gm.map.name)

                        if self.parent.cnf.cn.connect_say_load_map_gema and self.parent.gm.map:is_gema_map() then
                            gema = self.parent.cnf.say.text.atention_gema
                        end

                        if self.parent.cnf.cn.connect_say_autoteam then
                            if getautoteam() then
                                if self.parent.gm.map:is_gema_map() then
                                    autoteam = string.format(self.parent.cnf.say.text.autoteam, SAY_ENABLED_3)
                                else
                                    autoteam = string.format(self.parent.cnf.say.text.autoteam, SAY_ENABLED_0)
                                end
                            else
                                if self.parent.gm.map:is_gema_map() then
                                    autoteam = string.format(self.parent.cnf.say.text.autoteam, SAY_DISABLED_0)
                                else
                                    autoteam = string.format(self.parent.cnf.say.text.autoteam, SAY_DISABLED_3)
                                end
                            end
                        elseif self.parent.gm.map:is_gema_map() then
                            if getautoteam() then autoteam = string.format(self.parent.cnf.say.text.autoteam, SAY_ENABLED_3) end
                        end

                        if self.parent.cnf.cn.connect_say_load_map_mode then
                            mode = string.format(self.parent.cnf.say.text.game_mode, self.parent.gm.map.mode_str)
                        end
                    end


                    self['tmr_connect_say_'..tostring(dcn)] = function ()

                        if self.parent.cnf.cn.connect_say_about or ( self.parent.cnf.cn.connect_say_rules_map and (self.parent.cnf.cn.connect_say_rules_map_gema or self.parent.cnf.cn.connect_say_rules_map_normal) ) then
                            key_about =  self.parent.cnf.say.text.key_about
                        end

                        if self.parent.cnf.cn.connect_say_about then
                            self.parent.say:me(cn, string.format('%s%s', self.parent.cnf.say.text.about, self.parent.cnf.say.text.about_message ))
                        end
                        if self.parent.cnf.cn.connect_say_rules_map then
                            if self.parent.gm.map:is_gema_map() and self.parent.cnf.cn.connect_say_rules_map_gema then
                                self.parent.say:me(cn, self.parent.cnf.say.text.rules_map_gema)
                            elseif not self.parent.gm.map:is_gema_map() and self.parent.cnf.cn.connect_say_rules_map_normal then
                                self.parent.say:me(cn, self.parent.cnf.say.text.rules_map)
                            end
                        end
                        self.parent.say:me(cn, string.format("%s%s%s%s",map,mode,gema,autoteam))
                        local show_mod = self.data[dcn].show_mod
                        self.data[dcn].show_mod = true
                        self.parent.say:me(cn, string.format(self.parent.cnf.say.text.connect_welcome,c_name..name,self.data[dcn].geo))
                        self.data[dcn].show_mod = show_mod
                        self.parent.say:me(cn, string.format("%s",key_about))
                        if self.data[dcn].tmr_connect_say ~= nil then
                            tmr.remove(self.data[dcn].tmr_connect_say)
                            self.parent.log:w('TMR REMOVE N - '..tostring(self.data[dcn].tmr_connect_say),cn)
                            self.data[dcn].tmr_connect_say = nil
                        end
                        --[[for i = 0, maxclient() -1 do
                            if self.data[i].tmr_connect_say ~= nil then
                                self.parent.log:w('TMR FORCE REMOVE N - '..tostring(self.data[i].tmr_connect_say),i)
                                tmr.remove(self.data[i].tmr_connect_say)
                            end
                        end]]

                        self.parent.log:w('chk TMR REMOVE N '..tostring(self.data[dcn].dcn)..' TMR = '..tostring(self.data[dcn].tmr_connect_say),cn)
                    end

                    if self.parent.cnf.cn.connect_posts_delay then
                        self.data[dcn].tmr_connect_say = dcn
                        tmr.create(self.data[dcn].tmr_connect_say,self.parent.cnf.cn.connect_posts_delay_time,self['tmr_connect_say_'..tostring(dcn)])
                        self.parent.log:w('TMR CREATE N - '..tostring(self.data[dcn].tmr_connect_say),cn)
                    else
                        self['tmr_connect_say_'..tostring(dcn)]()
                    end

                end
            end

            self.parent.log:w('AddCn OK',cn)
            return true
        else
            self.parent.log:i('Not add data cn, cn ~= nil AddCn NO',cn)
            return false
        end
    end,

    on_connect = function(self,cn)
        sdbs.log:i('Connect...', cn)
        if isconnected(cn) then

            if self.d_force.cn ~= nil and self.d_force.cn == cn then
                self.parent.log:w('Connect NO. disconnect reasson: '..(self:get_d_reasson(self.d_force.reasson)),cn)
                self:force_disconnect(self.d_force.cn,self.d_force.reasson, self.d_force.message )
                return
                -- PLUGIN_BLOCK
            end
            self:add_cn(cn)
            self.parent.log:i('Connect OK',cn)
            if self.parent.flag.C_LOG then self:get_chk_data_cn() end
            return true
        else
            if self.parent.flag.C_LOG then self:get_chk_data_cn() end
            self.parent.log:w('Connect NO',cn)
            return false
        end
    end,

    force_disconnect = function(self,cn,reasson,message)
        self.parent.log:w('Force_disconnect',cn)
        if isconnected(cn) then
            callhandler('onPlayerDisconnect',cn,reasson)
            disconnect(cn,reasson)
            delclient(cn)
            --reloadas(cn)
            return true
        end
        return false
        -- PLUGIN_BLOCK
    end,

    remove_cn = function(self,cn,name)
        self.parent.log:i('RemoveCn....',cn)
        if self:chk_cn(cn) then
            for k,v in ipairs(self.data) do
                if cn == v.cn then
                    table.remove(self.data,k)
                    self.data_cn[cn] = nil
                    break
                end
            end
            for k,v in ipairs(self.data) do
                for i = 0, maxclient() - 1 do
                    if self.data_cn[i] ~= nil and i == v.cn then
                        self.data_cn[i] = k
                        self.data[k].dcn = k
                    end
                end
            end
            self.parent.log:i('RemoveCn OK',cn)
        else
            self.parent.log:w('Not is CN for remove data cn. RemoveCn NO',cn)
        end
    end,

    on_disconnect = function(self,cn,reasson)
        self.parent.log:i('Disconnect...',cn)
        if isconnected(cn) then
            self.parent.log:i('Disconnect is CN ok ...',cn)
            if self.parent.cnf.cn.disconnect_say then
                local name = nil
                if self:chk_cn(cn) then
                    name = self.data[self.data_cn[cn]].c_name..self.data[self.data_cn[cn]].name
                else
                    name = '\f3'..getname(cn) or 'NOT_NAME'
                end

                local say_disconnect = string.format(self.parent.cnf.say.text.disconnect_all,name)

                if self.parent.cnf.cn.disconnect_reasson_say then
                    say_disconnect = string.format('%s %s',say_disconnect, self.parent.cnf.say.text.disconnect_reasson )
                    say_disconnect = string.format(say_disconnect, (self:get_d_reasson(reasson) or 'DISCONNECT'))
                end

                if self.parent.cnf.cn.disconnect_say_message then
                    if self.d_force.message ~= nil then
                        --sayas(self.d_force.message,cn)
                        say_disconnect = string.format('%s \n%s',say_disconnect ,self.d_force.message)
                    end
                end

                self.parent.say:all(say_disconnect)


            end

            self:remove_cn(cn)

            if self.d_force.cn ~= nil then
                self.d_force.cn = nil
                self.d_force.reasson = nil
                self.d_force.message = nil
            end

            if self.parent.flag.lock_server and #self.data == 0 then self.parent.flag.lock_server = false  end

            self.parent.log:w('Disconnect OK',cn)
            if self.parent.flag.C_LOG then self:get_chk_data_cn() end
        else
            self.parent.log:w('Disconnect NO',cn)
            if self.parent.flag.C_LOG then self:get_chk_data_cn() end
        end
        return true
    end,

    on_rename = function(self,cn,newname)
        self.parent.log:i('Rename...',cn)
        if self:chk_cn(cn) then
            local dcn = self.data_cn[cn]
            local c_name = self.data[dcn].c_name
            self.parent.log:i('Check rename...',cn)

            if self:auto_kick_name(cn,newname) then
                self:force_disconnect(self.d_force.cn,self.d_force.reasson,self.d_force.message)
                return--PLUGIN_BLOCK
            end

            if self.parent.cnf.cn.rename_chk_role and self:chk_role(cn) then
                self.parent.log:i('Check Player Rename. KICK OK',cn)
                if self.parent.cnf.cn.rename_chk_role_say then self.parent.say:me(cn, string.format(self.parent.cnf.say.text.role_rename_message, c_name..self.data[dcn].name)) end
                --setrole(cn,self:get_role('DEFAULT'), false)
                callhandler('onPlayerRoleChange',cn, self:get_role('DEFAULT'))
            end

            if not self.parent.cnf.cn.rename then
                self.parent.log:w('Check rename. KICK OK',cn)
                self.d_force.cn = cn
                self.d_force.reasson = self:get_d_reasson('AUTOKICK')
                if self.parent.cnf.cn.not_rename_say then
                    self.d_force.message = string.format(self.parent.cnf.say.text.not_rename_message,c_name..self.data[dcn].name,newname)
                end
                self:force_disconnect(self.d_force.cn,self.d_force.reasson,self.d_force.message)
                return PLUGIN_BLOCK
                -- PLUGIN_BLOCK
            end

            if self:chk_same_and_old_same_name(cn,newname) then
                self:force_disconnect(cn,self.d_force.reasson,self.d_force.message)
                return  PLUGIN_BLOCK
            end

            local kk = true
            for _,v in ipairs(self.data[dcn].oldname) do
                if v == self.data[dcn].name then kk = false break end
            end
            if kk then
                table.insert(self.data[dcn].oldname,self.data[dcn].name)
                self.data[dcn].count_old_name = self.data[dcn].count_old_name + 1
            end
            self.data[dcn].count_rename = self.data[dcn].count_rename + 1
            self.parent.log:w("Rename: ".. self.data[dcn].name..' to '..newname..' Count rename: '..self.data[dcn].count_rename.." Count OldName: "..self.data[dcn].count_old_name,cn)
            if self.parent.cnf.cn.rename_say then
                self.parent.say:allexme(cn,string.format(self.parent.cnf.say.text.rename_message,c_name..self.data[dcn].name,c_name..newname))
            end
            self.data[dcn].name = newname
            self.parent.log:i('Rename OK',cn)
        end
        return true
    end,

    on_role_change = function(self,cn, new_role, hash, pwd, isconnect)

        --print(cn) print(new_role) print(hash) print(pwd) print(isconnect)
        self.parent.log:i('Role change...',cn)
        if self:chk_cn(cn) then
            --self.parent.log:w(string.format('Change args: cn: %s, new_role: %s, hash: %s, pwd: %s, isconnect: %s',tostring(cn),self:get_role(new_role),tostring(hash),tostring(pwd),tostring(isconnect)),cn)

            local dcn = self.data_cn[cn]
            local name = self.data[dcn].name
            local c_name = self.data[dcn].c_name

            if not self.parent.cnf.cn.rename_role and #self.data[dcn].oldname ~= 0 then
                if self.parent.cnf.cn.rename_role_kick then
                    self.parent.log:w('Check role rename in role change. KICK OK',cn)
                    self.d_force.cn = cn
                    self.d_force.reasson = self:get_d_reasson('AUTOKICK')
                    if self.parent.cnf.cn.rename_role_kick_say then
                        self.d_force.message = self.parent.cnf.say.text.role_rename_kick_message
                    end
                    self:force_disconnect(self.d_force.cn,self.d_force.reasson,self.d_force.message)
                    --return PLUGIN_BLOC
                else
                    if self.parent.cnf.cn.rename_role_say then self.parent.say:me(cn, string.format(self.parent.cnf.say.text.role_rename_message, c_name..name)) end

                        if self:chk_admin(cn) and self.parent.cnf.cn.role_change_admin_say then self.parent.say:allexme(cn,string.format(self.parent.cnf.say.text.admin_role_change_admin_message_0,c_name..name)) end

                        setrole(cn,self:get_role('DEFAULT'))
                        self:set_role(cn, 'DEFAULT')

                    if self.parent.flag.C_LOG then self:chk_role_status() end
                    --return PLUGIN_BLOC
                end
            else
                if ( pwd == nil and has == nil ) or ( isconnect~=nil and isconnect ) then
                    if  new_role ~= self.data[dcn].role then
                        if new_role == self:get_role('ADMIN') then

                            if not isadmin(cn) then
                                local admin = self:get_admin()
                                if admin ~= nil then callhandler('onPlayerRoleChange',admin,self:get_role('DEFAULT')) end

                                    setrole(cn,self:get_role('ADMIN'),true)
                                    self:set_role(cn,'ADMIN')
                                    if self.parent.cnf.cn.role_change_admin_say then self.parent.say:allexme(cn,string.format(self.parent.cnf.say.text.role_change_admin_message_1,c_name..name)) end
                            end

                        elseif  new_role == self:get_role('DEFAULT') then
                            if pwd == nil and has == nil then
                                if isadmin(cn) and self.parent.cnf.cn.role_change_admin_say then self.parent.say:allexme(cn,string.format(self.parent.cnf.say.text.role_change_admin_message_0,c_name..name)) end
                                setrole(cn,self:get_role('DEFAULT'))
                                self:set_role(cn,'DEFAULT')
                            end
                        else

                            if isadmin(cn) and self.parent.cnf.cn.role_change_admin_say then
                                self.parent.say:allexme(cn,string.format(self.parent.cnf.say.text.role_change_admin_message_0,c_name..name))
                                setrole(cn,self:get_role('DEFAULT'))
                            end

                            if new_role == self:get_role('ROOT') then

                                self:set_role(cn, 'ROOT')

                            elseif new_role == self:get_role('REFEREE') then

                                self:set_role(cn, 'REFEREE')

                            elseif new_role == self:get_role('REGISTERED') then

                                self:set_role(cn, 'REGISTERED')
                            else
                                self:set_role(cn,'DEFAULT')
                            end

                        end

                        if self.parent.cnf.cn.role_change_me_say then self.parent.say:me(cn,string.format(self.parent.cnf.say.text.role_change_me_message_1,self:get_role(self.data[dcn].role))) end

                        if self.parent.flag.C_LOG then self:chk_role_status() end
                    else
                        self.parent.say:me(cn,string.format(self.parent.cnf.say.text.role_change_me_message_0,self:get_role(self.data[dcn].role) ) )
                    end
                end
            end

            self.parent.log:w(string.format('Role change OK. Role: %s, id_role: %g',self:get_role(self.data[dcn].role),tostring(self.data[dcn].role)),cn)
        else
            self.parent.log:w('Role change NO. not cn',cn)
        end
        --return true
        return PLUGIN_BLOCK
    end,

    -- CMD CHK COMMAND

    on_say_text = function (self,cn,text,team,me)

        if not isconnected(cn) or not self:chk_cn(cn) then  return true end

        local dcn = self.data_cn[cn]
        local name = self.data[dcn].name
        local c_name = self.data[dcn].c_name

        --local show_mod = self.data[dcn].show_mod
        --self.data[dcn].show_mod = true

        local data = self.parent.fn:split(text, " ")
        local command, args = string.lower(data[1]), self.parent.fn:slice(data, 2)
        local admin, root, referee, registered = false, false, false, false

        if self.parent.cmd.commands[command] ~= nil then

            if string.byte(command,1) ~= string.byte("$",1) then
                self.parent.say:me(cn,self.parent.cnf.say.text.chk_commands_fix_message)
                return PLUGIN_BLOCK
            end

            local cmd = self.parent.cmd.commands[command]

            if ( self:chk_admin(cn) and cmd.protected[1]) or ( self:chk_root(cn) and cmd.protected[2]) or ( self:chk_referee(cn) and cmd.protected[3] ) or ( self:chk_registered(cn) and cmd.protected[4] ) or cmd.protected[5] then
                cmd:cfn(cn, args)
                if not cmd.protected[6] then return PLUGIN_BLOCK end
                return PLUGIN_BLOCK
            else
                self.parent.say:me(cn,self.parent.cnf.say.text.chk_commands_not_alloved_message)
                return PLUGIN_BLOCK
            end

        elseif string.byte(command,1) == string.byte("$",1) then
            self.parent.say:me(cn,self.parent.cnf.say.text.chk_commands_fix_message)
            return PLUGIN_BLOCK
        end

        --self.data[dcn].show_mod = show_mod

        if self.parent.cnf.show_mod then

            text = string.format('%s%s',self.parent.cnf.say.text.color,text)

            if self.parent.cnf.cn.connect_set_cn_name then
                name = string.format(self.parent.cnf.cn.connect_set_cn_name_format,tostring(cn),name)
            else
                name = string.format(self.parent.cnf.cn.connect_set_default_name_format,name)
            end
            text = string.format('%s%s%s',c_name,name,text)
            self.parent.say:allexme(cn,self.parent.fn:format_say_text_out(text))
            --self.parent.say:allexme(cn,text)
            return PLUGIN_BLOCK
        end
        return true
    end,

    init = function(self,obj)
        self.parent = obj
        --self.parent = setmetatable( {}, { __index = obj } )
        --self.parent = setmetatable( {}, { __index = obj, __newindex = obj } )
        self.parent.log:w('Module cn init OK')
    end

}
