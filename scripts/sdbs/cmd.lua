-- комманды

return {

    commands = {

        -- params: { admin allow, root allow, referee allow, registered allow, aviable allow, message in chat allow }

        -- AVIABLE --

        ['about'] = {},
        ["$about"] = {
            protected = { true, true, true, true, true, false },
            name = 'about',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name,cn)
                if #args > 0 and self.parent.fn:trim(args[1]) == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_help']) return true end
                self.parent.say:me(cn, self.parent.cnf.say.text.about)
                if self.parent.gm.map:is_gema_map() then
                    self.parent.say:me(cn, self.parent.cnf.say.text.rules_map_gema)
                else
                    self.parent.say:me(cn, self.parent.cnf.say.text.rules_map)
                end
                    self.parent.say:me(cn, self.parent.cnf.say.text.key_about)
            end
        },

        ['help'] = {},
        ["$help"] = {
            protected = { true, true, true, true, true, false },
            name = 'help',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name,cn)
                if #args > 0 and self.parent.fn:trim(args[1]) == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name'_help']) return true end
                self.parent.say:me(cn,self.parent.cnf.cmd.text.help_text)
            end
        },

        ['cmd'] = {},
        ["$cmd"] = {
            protected = { true, true, true, true, true, false },
            name = 'cmd',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name,cn)
                if #args >=1 and self.parent.fn:trim(args[1]) == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_help']) return true end
                self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_text'])
                local list = ''
                if self.parent.cn:chk_admin(cn) then
                    list = string.format('%s%s%s%s%s',self.cmd.list.aviable, self.cmd.list.registered, self.cmd.list.referee, self.cmd.list.root, self.cmd.list.admin)
                elseif self.parent.cn:chk_registered(cn) then
                    list = string.format('%s%s',self.cmd.list.aviable, self.cmd.list.registered)
                elseif self.parent.cn:chk_referee(cn) then
                    list = string.format('%s%s%s',self.cmd.list.aviable, self.cmd.list.registered, self.cmd.list.referee)
                elseif self.parent.cn:chk_root(cn) then
                    list = string.format('%s%s%s%s',self.cmd.list.aviable, self.cmd.list.registered, self.cmd.list.referee, self.cmd.list.root)
                else
                    list = self.cmd.list.aviable
                end
                self.parent.say:me(cn,list:sub(2,#list-7))
            end
        },

        ['pm'] = {},
        ["$pm"] = {
            protected = { true, true, true, true, true, false },
            name = 'pm',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name,cn)
                if #args >= 1 then
                    local arg = self.parent.fn:trim(args[1])
                    if arg == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_help']) return true end
                    local tcn, text = tonumber(arg), table.concat(args, " ", 2)
                    if not isconnected(tcn) or not self.parent.cn:chk_cn(tcn) then self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_error_cn']) return true end
                    local dcn = self.parent.cn.data_cn[cn]
                    local name = self.parent.cn.data[dcn].name
                    local c_name = self.parent.cn.data[dcn].c_name

                    --[[
                    text = self.parent.fn:format_say_text_out(text)
                    text = string.format('%s%s',self.parent.cnf.say.text.color,text)
                    if self.parent.cnf.cn.connect_set_cn_name then
                        name = string.format(self.parent.cnf.cn.connect_set_cn_name_format,tostring(cn),name)
                        text = string.format('%s%s%s%s',self.parent.cnf.say.text.privat_prefix,c_name,name,text)
                    end
                    ]]

                    text = string.format('%s%s',self.parent.cnf.say.text.color,text)
                    if self.parent.cnf.cn.connect_set_cn_name then
                        name = string.format(self.parent.cnf.cn.connect_set_cn_name_format,tostring(cn),name)
                    else
                        name = string.format(self.parent.cnf.cn.connect_set_default_name_format,name)
                    end
                    --text = string.format('%s%s%s%s',self.parent.cnf.say.text.privat_prefix,c_name,name,text)
                    self.parent.say:to(cn,tcn,string.format('%s%s%s',self.parent.cnf.say.text.privat_prefix,c_name,name))
                    self.parent.say:to(cn,tcn,self.parent.fn:format_say_text_out(text))

                    --self.parent.say:to(cn,tcn,text)
                    --sayas(text,cn,false,false)
                    --return PLUGIN_BLOC
                    return
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.cmd.text.cmd_error,self.name)) return
            end
        },


        -- $ fixation skip and random password display all :): D#
        ['sudo'] = {},
        ["$sudo"] = {
            protected = { true, true, true, true, true, false  },
            name = 'sudo',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name,cn)
                if --[[self.parent.cn:chk_admin(cn) and]] #args == 0 then
                    callhandler('onPlayerRoleChange',cn, self.parent.cn:get_role('DEFAULT'))
                else
                    if #args >= 1 then
                        local arg = self.parent.fn:trim(args[1])
                        if arg == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_help']) return end

                        local access,dcn = nil, self.parent.cn.data_cn[cn]

                        access = self.parent.sql:login(self.parent.cn.data[dcn].name,arg)

                        if  type(access) ~= 'number' then
                            local passwords = getadminpwds()
                            for _, password in pairs(passwords) do
                                if arg == password then
                                    access = self.parent.cn:get_role('ADMIN')
                                    break
                                end
                            end
                        end

                        if type(access) == 'number' then
                            callhandler('onPlayerRoleChange',cn, access)
                            self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_login'] )
                        else
                            self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_error_valid'])
                            self.parent.say:me(cn,access)
                        end

                    else
                        self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_error_empty'])
                        return
                    end
                end
                return
                --PLUGIN_BLOC
            end
        },

        -- REGISTERED --

        ['maptime'] = {},
        ["$maptime"] = {
            protected = { true, true, true, true, false, false  },
            name = 'maptime',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name,cn)
                if #args >= 1 then
                    local arg = self.parent.fn:trim(args[1])
                    if arg == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_help']) return end
                    arg = tonumber(arg)
                    if arg < 1 or arg > 60 then self.parent.say:me(cn,string.format(self.parent.cnf.cmd.text.cmd_error,self.name)) return true end
                    settimeleft(arg)
                    self.parent.say:me(cn,string.format(self.parent.cnf.cmd.text.maptime_text,arg))
                    return
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.cmd.text.cmd_error,self.name)) return
            end
        },

        --REFEREE --

        ['lock'] = {},
        ["$lock"] = {
            protected = { true, true, true, false, false, false  },
            name = 'lock',
            cfn = function (self,cn, args)
                function s(self,cn)
                    if self.parent.flag.lock_server then
                        self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_text_0'])
                    else
                        self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_text_1'])
                    end
                end
                self.parent.log:i("used "..self.name,cn)
                if #args >= 1 then
                    local arg = self.parent.fn:trim(args[1])
                    if arg == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_help']) return end
                    if arg == '-s' then s(self,cn) return true end
                    self.parent.say:me(cn,string.format(self.parent.cnf.cmd.text.cmd_error,self.name))
                    return
                end
                self.parent.flag.lock_server = not self.parent.flag.lock_server
                s(self)
                return
            end
        },

        -- ROOT --

        ['su'] = {},
        ["$su"] = {
            protected = { true, true, false, false, false, false },
            name = 'su',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name,cn)
                if #args >= 1 then
                    local tcn = self.parent.fn:trim(args[1])
                    if tcn == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_help']) return end

                    tcn = tonumber(tcn)

                    if not self.parent.cn:chk_cn(tcn) or not isconnected(tcn) then
                        self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'no_user']) return
                    end

                    if #args == 1 then callhandler('onPlayerRoleChange',tcn, self.parent.cn:get_role_cn(cn)) return end

                    local role = self.parent.fn:trim(args[2])

                    if  self.parent.cn:get_role(role) == self.parent.cn:get_role('DEFAULT') then
                        callhandler('onPlayerRoleChange',tcn, self.parent.cn:get_role('DEFAULT'))
                        return
                    end
                    if  self.parent.cn:get_role(role) == self.parent.cn:get_role('ADMIN') then
                        callhandler('onPlayerRoleChange',tcn, self.parent.cn:get_role('ADMIN'))
                        return
                    end
                    if  self.parent.cn:get_role(role) == self.parent.cn:get_role('ROOT') then
                        callhandler('onPlayerRoleChange',tcn, self.parent.cn:get_role('ROOT'))
                        return
                    end
                    if  self.parent.cn:get_role(role) == self.parent.cn:get_role('REFEREE') then
                        callhandler('onPlayerRoleChange',tcn, self.parent.cn:get_role('REFEREE'))
                        return
                    end
                    if  self.parent.cn:get_role(role) == self.parent.cn:get_role('REGISTERED') then
                        callhandler('onPlayerRoleChange',tcn, self.parent.cn:get_role('REGISTERED'))
                        return
                    end
                    return
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.cmd.text.cmd_error,self.name)) return
                    --return PLUGIN_BLOC
                    --if not isadmin(cn) then setrole(cn,self.parent.cn.get_role('ADMIN'), false) end
            end
        },

        ['useradd'] = {},
        ["$useradd"] = {
            protected = { true, true, false, false, false, false  },
            name= 'useradd',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name,cn)
                if #args >= 1 then
                    local arg1 = self.parent.fn:trim(args[1])
                    if arg1 == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_help']) return end
                    if args[2] == nil or args[3] == nil then self.parent.say:me(cn,string.format(self.parent.cnf.cmd.text.cmd_error,self.name)) return end
                    local arg2,arg3 = self.parent.cn:get_role(self.parent.fn:trim(args[2])),self.parent.fn:trim(args[3])
                    local res = self.parent.sql:useradd(arg1,arg2,arg3)
                    self.parent.say:me(cn,res)
                    return

                end
                self.parent.say:me(cn,string.format(self.parent.cnf.cmd.text.cmd_error,self.name)) return
            end
        },

        ['userdel'] = {},
        ["$userdel"] = {
            protected = { true, true, false, false, false, false  },
            name= 'userdel',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name,cn)
                if #args ==1 then
                    local arg1 = self.parent.fn:trim(args[1])
                    if arg1 == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text[self.name..'_help']) return end
                    local res,flag = self.parent.sql:userdel(arg1)
                    self.parent.say:me(cn,res)
                    if flag then callhandler('onPlayerRoleChange',self.parent.cn:get_cn(arg1), self.parent.cn:get_role('DEFAULT')) end
                    return
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.cmd.text.cmd_error,self.name)) return
            end
        },
    },

    init = function(self,obj)
        self.parent = obj
        self.list = {
            aviable = '',
            registered = '',
            referee = '',
            root = '',
            admin = ''
        }
        for k,_ in pairs(self.commands) do
            if  string.byte(k,1) == string.byte("$",1) then
                self.commands[k].parent = self.parent
                self.commands[k].cmd = self
                if self.commands[k].protected[5] then
                    if k ~= '$sudo' then self.list.aviable = string.format('\2%s \f4| \f2%s', k, self.list.aviable) end
                elseif self.commands[k].protected[4] then
                    if k ~= '$sudo' then self.list.registered = string.format('\f0%s \f4| \f0%s', k, self.list.registered) end
                elseif self.commands[k].protected[3] then
                    if k ~= '$sudo' then self.list.referee = string.format('\f1%s \f4| \f1%s', k, self.list.referee) end
                elseif self.commands[k].protected[2] then
                    self.list.root = string.format('\f9%s \f4| \f9%s', k,self.list.root)
                elseif self.commands[k].protected[1] then
                    self.list.admin = string.format('\f3%s \f4| \f3%s', k, self.list.admin)
                end
            end
        end
        --[[if #self.list.aviable > 0 then self.list.aviable = self.list.aviable:sub(0,#self.list.aviable-4) end
        if #self.list.registered > 0 then self.list.registered = self.list.registered:sub(0,#self.list.registered-4) end
        if #self.list.referee > 0 then self.list.referee = self.list.referee:sub(0,#self.list.referee-4) end
        if #self.list.root > 0 then self.list.root = self.list.root:sub(0,#self.list.root-4) end
        if #self.list.admin > 0 then self.list.admin = self.list.admin:sub(0,#self.list.admin-4) end]]

        self.parent.log:i('Module commands init is OK')
    end
}
