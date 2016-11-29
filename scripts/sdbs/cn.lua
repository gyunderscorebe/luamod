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
        [CR_ADMIN] = ADMIN,
        [CR_DEFAULT] = DEFAULT,
        [100] = REFEREE,
        REFEREE = 100,
        ADMIN = CR_ADMIN,
        DEFAULT = CR_DEFAULT
    },
    get_role = function(self,role)
        if self.roles[role] ~= nil then
            return self.roles[role]
        end
        return nil
    end,
    data = {},
    data_cn = {},
    coun_cn = nil,
    get_chk_data_cn = function(self,cn)
        -- Вывод в лог проверку на соответствие при добавления и удаления <CN> игроков в data и datacn, т.е. соответствие dadacn[<CN>] = <DCN> в data[<DCN>].cn = <CN> и data[<DCN>].dcn = <DCN> и data[data<CN>].cn = <CN> и data[data<CN>].dcn = <DCN>
        if self:chk_cn(cn)  then
            self.parent.log:i('TABLE IN DATADC - Name: '..self.data[self.data_cn[cn]].name..' CN: '..cn..' table in DATA CN: '..self.data[self.data_cn[cn]].cn..' DCN: '..self.data_cn[cn]..' table in DATA DCN: '..self.data[self.data_cn[cn]].dcn)
        else
            for k,v in pairs(self.data) do
                self.parent.log:i('TABLE IN DATA - Name: '..v.name..' CN: '..v.cn..' DCN: '..v.dcn..' ipairs: '..k..' countReName: '..v.count_rename..' countOldName: '..v.count_old_name)
            end
            for i = 0, maxclient() -1 do
                if self.data_cn[i] ~= nil then self.parent.log:i('TABLE IN DATADC - Name: '..self.data[self.data_cn[i]].name..' CN: '..i..' table in DATA CN: '..self.data[self.data_cn[i]].cn..' DCN: '..self.data_cn[i]..' table in DATA DCN: '..self.data[self.data_cn[i]].dcn) end
            end
        end
    end,
    get_admin = function(self)
        for _,v in ipairs(self.data) do
            if self:chk_admin(v.cn) then return v.cn end
        end
        return nil
    end,
    chk_admin = function(self,cn)
        if self:chk_cn(cn) and self.data[self.data_cn[cn]].role == self:get_role(ADMIN) and isadmin(cn) then return true end
        return false
    end,
    chk_referee = function(self,cn)
        if self:chk_cn(cn) and self.data[self.data_cn[cn]].referee == self:get_role(REFEREE) then return true end
        return false
    end,
    chk_role = function(self,cn)
        if self:chk_cn(cn) and ( self.data[self.data_cn[cn]].referee == self:get_role(REFEREE) or ( self.data[self.data_cn[cn]].role == self:get_role(ADMIN) and isadmin(cn) ) )then return true end
        return false
    end,
    chk_cn = function(self,cn)
        if isconnected(cn) and self.data_cn[cn] ~= nil and self.data[self.data_cn[cn]] ~= nil and self.data[self.data_cn[cn]].cn == cn then
            return true
        end
        return false
    end,
    get_name = function(self,cn)
        if self:chk_cn(cn) then
            return self.data[self.data_cn[cn]].name
        end
        return nil
    end,
    get_rndcolor_name = function(self,cn)
        if self:chk_cn(cn) then
            return self.parent.fn:random_color()..self.data[self.data_cn[cn]].name
        end
        return nil
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
                country = nil,
                iso = nil,
                city = nil,
                geo = '',
                role = nil,
                referee = nil,
                show_gema = false,
                disconnect_reason = false
            })

            local dcn = #self.data
            self.data_cn[cn] = dcn
            self.data[dcn].dcn = dcn
            self.data[dcn].role = self:get_role(DEFAULT)
            self.data[dcn].referee = self:get_role(DEFAULT)
            if isadmin(cn) then self.data[dcn].role = self:get_role(ADMIN) end

            for _,v in ipairs(self.parent.cnf.chk_list_show_gema) do
                if name:find(v) then
                    self.data[dcn].show_gema = true
                end
            end

            if self.parent.cnf.say.wrapp.randomcolor then
                self.data[dcn].c_name = self.parent.fn:random_color()
            elseif self.parent.cnf.say.wrapp.random_color_fix then
                self.data[dcn].c_name = self.parent.fn:random_color_fix()
            else
                self.data[dcn].c_name = SAY_INFO
            end

            local c_name = self.data[dcn].c_name

            if self.parent.cnf.geo.activate then
                if self.parent.cnf.geo.country then 
                    self.data[dcn].country = geoip.ip_to_country(ip)
                    self.data[dcn].iso = geoip.ip_to_country_code(ip)
                    if self.parent.cnf.geo.say_iso then
                        self.data[dcn].geo = string.format(self.parent.cnf.say.text.geo_iso, self.data[dcn].geo,self.data[dcn].iso)
                    end
                    if self.parent.cnf.geo.say_country then
                        self.data[dcn].geo = string.format(self.parent.cnf.say.text.geo_country, self.data[dcn].geo,self.data[dcn].country)
                    end  
                end
                if self.parent.cnf.geo.city then
                    self.data[dcn].city = geoip.ip_to_city(ip)
                    if self.parent.cnf.geo.say_city then
                        self.data[dcn].geo = string.format(self.parent.cnf.say.text.geo_city, self.data[dcn].geo,self.data[dcn].city)
                    end
                end
            end
            if #self.data[dcn].geo > 0 then self.data[dcn].geo = self.data[dcn].geo:sub(0,#self.data[dcn].geo-2) end

            if self.parent.cnf.cn.say_connect then
                for _,v in ipairs(self.data) do
                    if v.cn ~= cn then
                        if isadmin(v.cn) then
                            --if self.parent.cnf.geo.activate and self.parent.cnf.geo.city and self.parent.cnf.geo.say_city then
                            --        geo = string.format('%s\f9%s ',geo,self.data[dcn].city)
                            --end
                            self.parent.say:sto(cn,v.cn,string.format(self.parent.cnf.say.text.connect_for_admin,c_name..self.data[dcn].name,self.data[dcn].geo,self.data[dcn].ip),nil,nil,SAY_WARN)
                        else
                            self.parent.say:sto(cn,v.cn,string.format(self.parent.cnf.say.text.connect,c_name..self.data[dcn].name,self.data[dcn].geo,(self.data[dcn].iso or '')),nil,nil,SAY_WARN)
                        end
                    end
                end
            end
            if self.parent.cnf.cn.say_connect_me then
                local key_about, map, gema, mode, autoteam  = '', '', '','',''
                if self.parent.cnf.cn.say_connect_load_map then
                    map =string.format(self.parent.cnf.say.text.welcome_name_map, self.parent.gm.map.name)
                    if self.parent.cnf.cn.say_connect_load_map_gema and self.parent.gm.map:is_gema_map() then 
                        --if self.parent.cnf.map.team.auto.gema then autoteam = autoteam..'\f9ENABLED' else autoteam = autoteam..'\f9DISABLED' end
                        gema = self.parent.cnf.say.text.atention_gema
                    end
                    --if self.parent.cnf.map.team.auto.map then autoteam = autoteam..'\f9ENABLED' else autoteam = autoteam..'\f9DISABLED' end
                    if self.parent.cnf.cn.say_connect_autoteam then
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

                    if self.parent.cnf.cn.say_connect_load_map_mode then
                        mode = string.format(self.parent.cnf.say.text.game_mode, self.parent.gm.map.mode_str)
                    end
                end
                if self.parent.cnf.cn.say_connect_about then
                    self.parent.say:sall(cn, self.parent.cnf.say.text.about)
                end
                if self.parent.cnf.cn.say_connect_rules_map then
                    if self.parent.gm.map:is_gema_map() and self.parent.cnf.cn.say_connect_rules_map_gema then
                        self.parent.say:sme(cn, self.parent.cnf.say.text.rules_map_gema)
                    elseif not self.parent.gm.map:is_gema_map() and self.parent.cnf.cn.say_connect_rules_map_normal then
                        self.parent.say:sme(cn, self.parent.cnf.say.text.rules_map)
                    end
                end
                if self.parent.cnf.cn.say_connect_about or ( self.parent.cnf.cn.say_connect_rules_map and (self.parent.cnf.cn.say_connect_rules_map_gema or self.parent.cnf.cn.say_connect_rules_map_normal) ) then
                    key_about =  self.parent.cnf.say.text.key_about
                end
                self.parent.say:sme(cn, string.format("%s%s%s%s",map,mode,gema,autoteam))
                self.parent.say:sme(cn, string.format("%s %s",self.parent.cnf.say.text.welcome,c_name..self.data[dcn].name))
                self.parent.say:sme(cn, string.format("%s",key_about))

            end
            self.parent.log:i('AddCn OK',cn)
            --if self.parent.C_LOG then self:get_chk_data_cn() end
            return true
        else 
            self.parent.log:i('Not is CN for add data cn. AddCn NO',cn)
            return false
        end
    end,
    remove_cn = function(self,cn,reasson)
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
            self.parent.log:i('Not is CN for remove data cn. RemoveCn NO',cn)
        end
    end,

    connect = function(self,cn)
        if isconnected(cn) then
            self.parent.log:i('Connect....',cn)
            if self.d_force.cn ~= nil and self.d_force.cn == cn then
                self.parent.log:i('Connect NO, Kick',cn)
                self:force_disconnect(self.d_force.cn,self.d_force.reasson)
                --delclient(cn)
                return PLUGIN_BLOCK
            end
            self:add_cn(cn)
            self.parent.log:i('Connect OK',cn)
        else
            self.parent.log:i('Connect NO',cn)
        end
        if self.parent.C_LOG then self:get_chk_data_cn() end
        return true
    end,
    force_disconnect = function(self,cn,reasson,message)
        if self.d_force.cn == nil then
            self.d_force = {
                cn = cn,
                reasson = reasson
                --message = message or ''
            }
        end
        callhandler('onPlayerDisconnect',cn,reasson)
        disconnect(cn,reasson)
        --reloadas(cn)
        delclient(cn)
        return true
        -- PLUGIN_BLOCK
    end,
    disconnect = function(self,cn,reasson)
        if isconnected(cn) then
            self.parent.log:i('Disconnect...',cn)
            if self.parent.cnf.cn.say_disconnect then
                local name = nil
                if self.data_cn[cn] ~= nil then
                    name = self.data[self.data_cn[cn]].c_name..self.data[self.data_cn[cn]].name
                else
                    name = '\f3'..getname(cn) or 'NOT_NAME'
                end

                local say_disconnect = string.format(self.parent.cnf.say.text.disconnect,name)

                if self.parent.cnf.cn.say_disconnect_reasson then
                    say_disconnect = string.format('%s %s',say_disconnect, self.parent.cnf.say.text.disconnect_reasson )
                    say_disconnect = string.format(say_disconnect, self:get_d_reasson(reasson) or DISCONNECT)
                end

                if self.parent.cnf.cn.say_disconnect_message then
                    if self.d_force.message ~= nil then 
                        --sayas(self.d_force.message,cn)
                        say_disconnect = string.format('%s \n%s',say_disconnect ,self.d_force.message)
                    end                    
                end

                self.parent.say:sall(cn,say_disconnect)


            end
            if self.d_force.cn ~= nil then
                self.d_force.cn = nil
                self.d_force.reasson = nil
                self.d_force.message = nil
            end
            self:remove_cn(cn,reasson)
            self.parent.log:i('Disconnect OK',cn)
        else
            self.parent.log:i('Disconnect NO',cn)
        end
        if self.parent.C_LOG then self:get_chk_data_cn() end
        return true
        -- PLUGIN_BLOCK
    end,
    preconnect = function(self,cn)
        self.parent.log:i('Preconnect',cn)
        local name = getname(cn)
        local ip = getip(cn)
        name = name:lower()       
        if self.parent.cnf.cn.active_chkeck_ban_name then
            for _,v in ipairs(self.parent.cnf.cn.chkeck_ban_name_list) do
               if name:find(v) then
                    self.parent.log:w(string.format("Find name: %s in name ban list players = true",name),cn)
                        --self:force_disconnect(cn,self:get_d_reasson('BADNICK'),' This name is already used by a player, present here. It is prohibited by the rules.')
                    self.d_force = {
                        cn = cn,
                        reasson = self:get_d_reasson('BADNICK'),
                    }
                    if self.parent.cnf.cn.say_active_chkeck_ban_name then
                        self.d_force.message = self.parent.cnf.say.text.chkeck_ban_name_message
                    end
                    return PLUGIN_BLOCK
                end
            end
        end
        if isconnected(cn) and #self.data > 0 and ( self.parent.cnf.cn.not_connect_same_name or self.parent.cnf.cn.not_login_old_same_name ) then
            --self.parent.log:w("Name search ")
            for k,v in ipairs(self.data) do
                if cn ~= v.cn and k == v.dcn then
                    if self.parent.cnf.cn.not_connect_same_name then
                        --self.parent.log:w("Name search ".. v.name)
                        if v.name:lower() == name then
                            self.parent.log:w(string.format("Find name: %s in name list players = true",name),cn)
                            
                            --self:force_disconnect(cn,self:get_d_reasson('BADNICK'),' This name is already used by a player, present here. It is prohibited by the rules.')
                            self.d_force = {
                                cn = cn,
                                reasson = self:get_d_reasson('DUP')
                            }
                            if self.parent.cnf.cn.say_not_connect_same_name then
                                self.d_force.message = self.parent.cnf.say.text.not_connect_same_name_message
                            end
                            return PLUGIN_BLOCK
                        end
                    end
                    if self.parent.cnf.cn.not_connect_old_same_name then
                        if #v.oldname > 0 then 
                            for _,vv in ipairs(v.oldname) do
                                -- self.parent.log:w("Oldname search "..vv..' name '..v.name,cn)
                                if vv:lower() == name then
                                    self.parent.log:w(string.format("Find name: %s in old name list players = true",name),cn)
                                    --self:force_disconnect(cn,self:get_d_reasson('BADNICK'),' This name is already used by players who are here. It is prohibited by the rules.')
                                    
                                    self.d_force = {
                                        cn = cn,
                                        reasson = self:get_d_reasson('DUP')
                                    }
                                    if self.parent.cnf.cn.say_not_connect_old_same_name then
                                        self.d_force.message = self.parent.cnf.say.text.not_connect_old_same_name_message
                                    end
                                    return PLUGIN_BLOCK
                                end
                            end
                        end
                    end
                    -- Вывод в лог сообщений о количестве предидущих имен игроков
                    -- self.parent.log:w(' Count OldName: '..self.data[v.dcn].countOldName..' Player: '..self.data[v.dcn].name,cn)
                    -- Вывод в лог сообщений о количестве раз переименования игроков
                    -- self.parent.log:w(' Count rename: '..self.data[v.dcn].countReName..' Player: '..self.data[v.dcn].name,cn)
                end
            end
        end
        return false
        -- PLUGIN_BLOCK
    end,
    rename = function(self,cn,newname)
        self.parent.log:i('Rename...',cn)
        if self:chk_cn(cn) then
            local dcn = self.data_cn[cn]
            local c_name = self.data[dcn].c_name
            self.parent.log:i('Check rename...',cn)
            if self.parent.cnf.cn.chk_admin_rename and self:chk_admin(cn) then
                self.parent.log:i('Check admin rename. KICK OK',cn)
                if self.parent.cnf.cn.say_chk_admin_rename then self.parent.say:sme(cn, string.format(self.parent.cnf.say.text.not_admin_rename_message, c_name..self.data[dcn].name)) end
                setrole(cn,self:get_role('DEFAULT'), false)
                callhandler('onPlayerRoleChange',cn, self:get_role('DEFAULT'))
            end
            if self.parent.cnf.cn.not_rename then
                self.parent.log:i('Check rename. KICK OK',cn)
                self.d_force = {
                    cn = cn,
                    reasson = self:get_d_reasson('AUTOKICK')
                }
                if self.parent.cnf.cn.say_not_rename then
                    self.d_force.message = string.format(self.parent.cnf.say.text.not_rename_message,c_name..self.data[dcn].name,newname)
                end
                self:force_disconnect(self.d_force.cn,self.d_force.reasson)
                return PLUGIN_BLOCK
                -- PLUGIN_BLOCK
            end
            if self.parent.cnf.cn.active_chkeck_ban_name then
                self.parent.log:i('Check list ban name. KICK OK',cn)
                local lnewname = newname:lower()
                for _,v in ipairs(self.parent.cnf.cn.chkeck_ban_name_list) do
                   if lnewname:find(v) then
                        self.parent.log:w(string.format("Find name: %s in name list players = true",name),cn)
                            --self:force_disconnect(cn,self:get_d_reasson('BADNICK'),' This name is already used by a player, present here. It is prohibited by the rules.')
                            self.d_force = {
                            cn = cn,
                            reasson = self:get_d_reasson('BADNICK'),
                        }
                        if self.parent.cnf.cn.say_active_chkeck_ban_name then
                            self.d_force.message = string.format(self.parent.cnf.say.text.active_chkeck_ban_name_message,c_name..self.data[dcn].name)
                        end
                        self:force_disconnect(self.d_force.cn,self.d_force.reasson)
                        return PLUGIN_BLOCK
                    end
                end
            end
            if self.parent.cnf.cn.not_allow_same_name or self.parent.cnf.cn.not_allow_old_same_name then
                for k,v in ipairs(self.data) do
                    if cn ~= v.cn and k == v.dcn then
                        if self.parent.cnf.cn.not_allow_same_name then
                            if v.name:lower() == newname:lower() then                            
                                self.parent.log:i('Check some name. KICK OK',cn)
                                self.d_force = {
                                    cn = cn,
                                    reasson = self:get_d_reasson('DUP')
                                }
                                if self.parent.cnf.cn.say_not_allow_same_name then
                                    self.d_force.message = string.format(self.parent.cnf.say.text.not_allow_same_name_message,c_name..self.data[dcn].name,newname)
                                end
                                self:force_disconnect(self.d_force.cn,self.d_force.reasson)
                                return PLUGIN_BLOCK
                            end
                        end
                        if self.parent.cnf.cn.not_allow_old_same_name then
                            if #v.oldname > 0 then 
                                for _,vv in ipairs(v.oldname) do
                                    if vv:lower() == newname:lower() then
                                        self.parent.log:i('Check old some name. KICK OK',cn)
                                        self.d_force = {
                                            cn = cn,
                                            reasson = self:get_d_reasson('DUP')
                                        }
                                        if self.parent.cnf.cn.say_not_allow_old_same_name then
                                            self.d_force.message = string.format(self.parent.cnf.say.text.not_allow_old_same_name_message,c_name..self.data[dcn].name,newname)
                                        end
                                        self:force_disconnect(self.d_force.cn,self.d_force.reasson)
                                        return PLUGIN_BLOCK
                                    end
                                end
                            end
                        end
                    end
                end
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
            if self.parent.cnf.cn.say_rename then
                self.parent.say:sallexme(cn,string.format(self.parent.cnf.say.text.rename_message,c_name..self.data[dcn].name,newname)) 
            end
            self.data[dcn].name = newname
            self.parent.log:i('Rename OK',cn)
        end
        return true
    end,
    role_change = function(self,cn, new_role, hash, pwd, isconnect)
        if self:chk_cn(cn) then
            local dcn = self.data_cn[cn]
            local name = self.data[dcn].name
            local c_name = self.data[dcn].c_name
            if self.parent.cnf.cn.not_admin_rename and #self.data[dcn].oldname ~= 0 then
                if self.parent.cnf.cn.not_admin_rename_kick then
                    self.parent.log:i('Check admin rename. KICK OK',cn)
                    self.d_force = {
                        cn = cn,
                        reasson = self:get_d_reasson('AUTOKICK')
                    }
                    if self.parent.cnf.cn.say_not_admin_rename_kick then
                        self.d_force.message = string.format(self.parent.cnf.say.text.not_admin_rename_kick_message,c_name..name)
                    end
                    self:force_disconnect(self.d_force.cn,self.d_force.reasson)
                    return PLUGIN_BLOC
                else
                    if self.parent.cnf.cn.sya_not_admin_rename then self.parent.say:sme(cn, string.format(self.parent.cnf.say.text.not_admin_rename_message, c_name..name)) end
                        setrole(cn,self:get_role('DEFAULT'))
                        if self.parent.cnf.cn.say_admin_role_change then self.parent.say:sallexme(cn,string.format(self.parent.cnf.say.text.admin_role_change_admin_message_0,c_name..name)) end
                        self.data[dcn].role = self:get_role('DEFAULT')
                    
                    if self.C_LOG then
                        for _,v in ipairs(self.parent.cn.data) do
                            self.parent.log:i(string.format('Player cn = %s Admin status = %s Referee status = %s',tostring(v.cn),tostring(self:chk_admin(v.cn)),tostring(self:chk_referee(v.cn))),v.cn)
                        end
                    end
                    return PLUGIN_BLOC
                end
            else
                if new_role == self:get_role('ADMIN') then
                    self.data[dcn].role = self:get_role('ADMIN')
                    if self.parent.cnf.cn.say_admin_role_change then self.parent.say:sallexme(cn,string.format(self.parent.cnf.say.text.admin_role_change_admin_message_1,c_name..name)) end

                else
                    self.data[dcn].role = self:get_role('DEFAULT')
                    if self.parent.cnf.cn.say_admin_role_change then self.parent.say:sallexme(cn,string.format(self.parent.cnf.say.text.admin_role_change_admin_message_0,c_name..name)) end
                end
                if self.C_LOG then
                    for _,v in ipairs(self.parent.cn.data) do
                        self.parent.log:i(string.format('Player cn = %s Admin status = %s Referee status = %s',tostring(v.cn),tostring(self:chk_admin(v.cn)),tostring(self:chk_referee(v.cn))),v.cn)
                    end
                end
            end
        end
        return true
    end,
    chk_commands = function(self,cn,text,team,me)
        local data = self.parent.fn:split(text, " ")
        local command, args = data[1], self.parent.fn:slice(data, 2)
        local admin, referee,name = false, false, ''
        if self.data_cn[cn] == nil then  return true end
        if self.parent.cmd.commands[command] ~= nil then
            if string.byte(command,1) ~= string.byte("$",1) then 
                self.parent.say:sme(cn,self.parent.cnf.say.text.chk_commands_fix_message)
                return PLUGIN_BLOCK
            end
            local cmd = self.parent.cmd.commands[command]
            if ( self:chk_admin(cn) and cmd.protected[1]) or ( self:chk_referee(cn) and cmd.protected[2] ) or cmd.protected[3] then
                cmd:cfn(cn, args)
                if not cmd.protected[4] then return PLUGIN_BLOCK end
                return PLUGIN_BLOCK
            else
                self.parent.say:sme(cn,self.parent.cnf.say.text.chk_commands_not_alloved_message,nil,nil,SAY_WARN)
                return PLUGIN_BLOCK
            end
        elseif string.byte(command,1) == string.byte("$",1) then
            self.parent.say:sme(cn,self.parent.cnf.say.text.chk_commands_fix_message)
            return PLUGIN_BLOCK
        end
        --if self.parent.cnf.say.colorize_text_cmd then text = self.parent.fn:colorize_text(text) end
        if not self.parent.cnf.hidden_gema then
            self.parent.say:allexme(cn,text)
        --self.parent.say:sme(cn,text)
            return PLUGIN_BLOCK
        end
        return true
    end,
    init = function(self,obj)
        self.parent = obj
        --self.parent = setmetatable( {}, { __index = obj } )
        --self.parent = setmetatable( {}, { __index = obj, __newindex = obj } )
        self.parent.log:i('Module cn init is OK')
    end
}