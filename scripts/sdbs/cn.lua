return {
    datacn = {},
    data = {},
    arb = {},
    disconnectReason = nil,
    getChkDataDataCn = function(self,cn)
        -- Вывод в лог проверку на соответствие при добавления и удаления <CN> игроков в data и datacn, т.е. соответствие dadacn[<CN>] = <DCN> в data[<DCN>].cn = <CN> и data[<DCN>].dcn = <DCN> и data[data<CN>].cn = <CN> и data[data<CN>].dcn = <DCN>
        if cn ~= nil  then
            if self.datacn[cn] ~= nil then self.parent.log:i('TABLE IN DATADC - Name: '..self.data[self.datacn[cn]].name..' CN: '..cn..' table in DATA CN: '..self.data[self.datacn[cn]].cn..' DCN: '..self.datacn[cn]..' table in DATA DCN: '..self.data[self.datacn[cn]].dcn) end
        else
            for k,v in pairs(self.data) do
                self.parent.log:i('TABLE IN DATA - Name: '..v.name..' CN: '..v.cn..' DCN: '..v.dcn..' ipairs: '..k..' countReName: '..v.countReName..' countOldName: '..v.countOldName)
            end
            for i = 0, maxclient() -1 do
                if self.datacn[i] ~= nil then self.parent.log:i('TABLE IN DATADC - Name: '..self.data[self.datacn[i]].name..' CN: '..i..' table in DATA CN: '..self.data[self.datacn[i]].cn..' DCN: '..self.datacn[i]..' table in DATA DCN: '..self.data[self.datacn[i]].dcn) end
            end
        end
    end,
    preconnect = function(self,cn)
        self.parent.log:i('Preconnect',cn)
        local name = getname(cn)
        local ip = getip(cn)
        if isconnected(cn) and #self.data > 0 and ( self.parent.cnf.Cn.notLoginSameName or self.parent.cnf.Cn.notLoginOldSameName ) then
            for k,v in ipairs(self.data) do
                if cn ~= v.cn and k == v.dcn then
                    if self.parent.cnf.Cn.notLoginSameName then
                        --self.parent.log:w("Name search ".. v.name)
                        if v.name == name then
                            -- self.parent.log:w(string.format("Find name: %s in name list players = true",name),cn)
                            if self.parent.cnf.Cn.sayAllNotLoginSameName then clientprint(-1, string.format("\f2Attempting to login a player with the name \f3%s\f2. This name is already used by a player, present here. It is prohibited by the rules.",name)) end
                            --disconnect(cn, DISC_BADNICK)
                            self.disconnectReason = DISC_BADNICK
                            --callhandler('onPlayerDisconnect',cn,DISC_BADNICK)
                            --delclient(cn)
                            return PLUGIN_BLOCK
                        end
                    end
                    if self.parent.cnf.Cn.notLoginOldSameName then
                        if #v.oldname > 0 then 
                            for _,vv in ipairs(v.oldname) do
                                -- self.parent.log:w("Oldname search "..vv..' name '..v.name,cn)
                                if vv == name then
                                    -- self.parent.log:w(string.format("Find name: %s in old name list players = true",name),cn)
                                    if self.parent.cnf.Cn.sayAllNotLoginOldSameName then clientprint(-1, string.format("\f2Attempting to login a player with the name \f3%s\f2. This name is already used by players who are here. It is prohibited by the rules.",name)) end
                                        --disconnect(cn, DISC_BADNICK)
                                        self.disconnectReason = DISC_BADNICK
                                        --callhandler('onPlayerDisconnect',cn,DISC_BADNICK)
                                        --delclient(cn)
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
        return PLUGIN_BLOCK
    end,
    addcn = function(self,cn)
        self.parent.log:i('AddCn',cn)
        if self.datacn[cn] == nil then
            local name = getname(cn)
            local ip = getip(cn)
            table.insert(self.data, {
                cn = cn,
                dcn = nil,
                name = name,
                oldname = {},
                countReName = 0,
                countOldName = 0,
                ip = ip,
                country = nil,
                iso = nil,
                city = nil,
                arb = CR_DEFAULT,
                role = CR_DEFAULT
            })

            self.data[#self.data].dcn = #self.data

            if self.datacn[cn] == nil then self.datacn[cn] = #self.data end

            if self.parent.cnf.Geo.Activate then
                if self.parent.cnf.Geo.Country then 
                    self.data[#self.data].country = geoip.ip_to_country(ip)
                    self.data[#self.data].iso = geoip.ip_to_country_code(ip)
                end
                if self.parent.cnf.Geo.City then self.data[#self.data].city = geoip.ip_to_city(ip) end
            end

            if self.parent.cnf.Cn.sayAllLoginName then clientprint(-1, string.format("\f0%s \f2players to join the game",self.data[self.datacn[cn]].name),cn) end
            if self.parent.cnf.Cn.sayMeLoginName then clientprint(cn, string.format("\f2We welcome you, \f0%s \f2player",self.data[self.datacn[cn]].name)) end
            self.parent.log:i('AddCn OK',cn)

            self:getChkDataDataCn()
        else 
            self.parent.log:i('Not is CN for add data cn. AddCn NO',cn)
        end
        return PLUGIN_BLOCK
    end,
    removecn = function(self,cn,reasson)
        self.parent.log:i('RemoveCn',cn)
        if self.datacn[cn] ~= nil and self.data[self.datacn[cn]].cn == cn and self.data[self.datacn[cn]].dcn == self.datacn[cn] then
            for k,v in ipairs(self.data) do
                if cn == v.cn then
                    table.remove(self.data,k)
                    self.datacn[cn] = nil
                    break
                end
            end
            for k,v in pairs(self.data) do
                for i = 0, maxclient() - 1 do
                    if self.datacn[i] ~= nil and i == v.cn then
                        self.datacn[i] = k
                        self.data[k].dcn = k
                    end
                end
            end
            self.parent.log:i('RemoveCn OK',cn)
        else 
            self.parent.log:i('Not is CN for remove data cn. RemoveCn NO',cn)
        end
        return PLUGIN_BLOCK
    end,
    connect = function(self,cn)
        self.parent.log:i('Connect....',cn)
        if self.disconnectReason  ~=nil then
            callhandler('onPlayerDisconnect',cn,self.disconnectReason)
        elseif isconnected(cn) then
            self:addcn(cn)
            self.parent.log:i('Connect OK',cn)
        else
            self.parent.log:i('Connect NO',cn)
        end
        return PLUGIN_BLOCK
    end,
    disconnect = function(self,cn,reasson)
        self.parent.log:i('Disconnect...',cn)
        if isconnected(cn) then
            self:removecn(cn,reasson)
            disconnect(cn,reasson)
            delclient(cn)
            self.parent.log:i('Disconnect OK',cn)
        else
            self.parent.log:i('Disconnect NO',cn)
        end
        self.disconnectReason = nil
        return PLUGIN_BLOCK
    end,
    rename = function(self,cn,newname)
        self.parent.log:i('Rename...',cn)
        if isconnected(cn) and self.datacn[cn] ~= nil then
            local dcn = self.datacn[cn]
            if self.parent.cnf.Cn.notRename then
                self.parent.log:i('Check rename OK',cn)
                if self.parent.cnf.Cn.sayAllNotRename then clientprint(-1, string.format("\f2Player \f3%s \f2tried to change the name on the \f3%s\f2. It is prohibited by the rules.",self.data[dcn].name,newname)) end
                
                --if self.parent.cnf.Cn.notRenameKick then
                    self.parent.log:i('Check rename and KICK OK',cn)
                    --self:removecn(cn)
                    --disconnect(cn, DISC_BADNICK)
                    callhandler('onPlayerDisconnect',cn,DISC_BADNICK)
                    --delclient(cn)
                --else
                    --setname(cn,self.data[dcn].name)
                --end

                return PLUGIN_BLOCK
            end
            if self.parent.cnf.Cn.notAllowSameName or self.parent.cnf.Cn.notAllowOldSameName then
                for k,v in ipairs(self.data) do
                    if cn ~= v.cn and k == v.dcn then
                        if self.parent.cnf.Cn.notAllowSameName then
                            if v.name == newname then
                                self.parent.log:i('Check some name OK',cn)
                                if self.parent.cnf.Cn.sayAllNotAllowSameName then clientprint(-1, string.format("\f2Player \f3%s \f2tried to change the name on the \f3%s\f2. This name is already used by a player, present here. It is prohibited by the rules.",self.data[dcn].name,newname)) end
                               
                                --if self.parent.cnf.Cn.notAllowSameNameKick then
                                    self.parent.log:i('Check some name and KICK OK',cn)
                                    --self:removecn(cn)
                                    --disconnect(cn, DISC_BADNICK)
                                    callhandler('onPlayerDisconnect',cn,DISC_BADNICK)
                                    --delclient(cn)
                                --else 
                                    --setname(cn,self.data[dcn].name)
                                --end
                                return PLUGIN_BLOCK
                            end
                        end
                        if self.parent.cnf.Cn.notAllowOldSameName then
                            if #v.oldname > 0 then 
                                for _,vv in ipairs(v.oldname) do
                                    if vv == newname then
                                        self.parent.log:i('Check old some name OK',cn)
                                        if self.parent.cnf.Cn.sayAllNotAllowOldSameName then clientprint(-1, string.format("\f2Player \f3%s \f2tried to change the name on the \f3%s\f2. This name is already used by players who are here. It is prohibited by the rules.",self.data[dcn].name,newname)) end
                                        
                                        --if self.parent.cnf.Cn.notAllowOldSameNameKick then
                                            self.parent.log:i('Check old some name and KICK OK',cn)
                                            --self:removecn(cn)
                                            --disconnect(cn, DISC_BADNICK)
                                            callhandler('onPlayerDisconnect',cn,DISC_BADNICK)
                                            --delclient(cn)
                                        --else
                                            --setname(cn,self.data[dcn].name)
                                        --end
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
                self.data[dcn].countOldName = self.data[dcn].countOldName + 1
            end
            self.data[dcn].countReName = self.data[dcn].countReName + 1
            self.parent.log:w("Rename: ".. self.data[dcn].name..' to '..newname..' Count rename: '..self.data[dcn].countReName.." Count OldName: "..self.data[dcn].countOldName,cn)
            if self.parent.cnf.Cn.sayAllRename then clientprint(-1, string.format("\f2The player changed his name to \f1%s \f0%s",self.data[dcn].name,newname),cn) end
            self.data[dcn].name = newname
            self.parent.log:i('Rename OK',cn)
        end
        return PLUGIN_BLOCK
    end
}