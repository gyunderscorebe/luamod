-- комманды

-- params: { admin allow, root allow, referee allow, registered allow, aviable allow, message in chat allow }

return {

    commands = {

--[[
        ["<>"] = {PP
            protected = { true, true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i("",cn)
            end,
            help = ''
        },
]]
        -- AVIABLE --

        ['about'] = {},
        ["$about"] = {
            protected = { true, true, true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i("used $about",cn)
                if #args > 0 and self.parent.fn:trim(args[1]) == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text.about_help) return true end
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
            cfn = function (self,cn, args)
                self.parent.log:i("used $help",cn)
                if #args > 0 and self.parent.fn:trim(args[1]) == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text.help_help) return true end
                self.parent.say:me(cn,self.parent.cnf.cmd.text.help_text)
            end
        },

        ['cmd'] = {},
        ["$cmd"] = {
            protected = { true, true, true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i("used $cmd",cn)
                if #args >=1 and self.parent.fn:trim(args[1]) == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text.cmd_help) return true end
                self.parent.say:me(cn,self.parent.cnf.cmd.text.cmd_text)
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
            cfn = function (self,cn, args)
                self.parent.log:i("used $pm",cn)
                if #args == 0 then
                    self.parent.say:me(cn,self.parent.cnf.cmd.text.pm_error) return
                elseif #args >= 1 then
                    local arg = self.parent.fn:trim(args[1])
                    if arg == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text.pm_help) return true end
                    local tcn, text = tonumber(arg), table.concat(args, " ", 2)
                    if not isconnected(tcn) or not self.parent.cn:chk_cn(tcn) then self.parent.say:me(cn,self.parent.cnf.cmd.text.pm_error_cn) return true end
                    local dcn = self.parent.cn.data_cn[cn]
                    local name = self.parent.cn.data[dcn].name
                    local c_name = self.parent.cn.data[dcn].c_name

                    text = self.parent.fn:format_say_text_out(text)
                    text = string.format('%s%s',self.parent.cnf.say.text.color,text)

                    if self.parent.cnf.cn.connect_set_cn_name then
                        name = string.format(self.parent.cnf.cn.connect_set_cn_name_format,tostring(cn),name)
                        text = string.format('%s%s%s%s',self.parent.cnf.say.text.privat_prefix,c_name,name,text)
                    end

                    self.parent.say:to(cn,tcn,text)
                    --sayas(text,cn,false,false)
                    --return PLUGIN_BLOC
                end
            end
        },

        -- $ fixation skip and random password display all :): D#
        ['sudo'] = {},
        ["$sudo"] = {
            protected = { true, true, true, true, true, false  },
            cfn = function (self,cn, args)
                self.parent.log:i("used $sudo",cn)
                if self.parent.cn:chk_admin(cn) and #args == 0 then
                    --setrole(cn,self.parent.cn:get_role('DEFAULT'), false)
                    callhandler('onPlayerRoleChange',cn, self.parent.cn:get_role('DEFAULT'))
                else
                    if #args >= 1 then
                        local arg = self.parent.fn:trim(args[1])
                        if arg == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text.sudo_help) return end

                        local passwords = getadminpwds()
                        for _, password in pairs(passwords) do
                            if arg == password then
                                --[[local acn = self.parent.cn:get_admin()
                                if acn ~= nil then
                                    --setrole(acn,self.parent.cn:get_role('DEFAULT'), false)
                                    callhandler('onPlayerRoleChange',acn, self.parent.cn:get_role('DEFAULT'))
                                end
                                --setrole(cn,self.parent.cn:get_role('ADMIN'), false)]]
                                callhandler('onPlayerRoleChange',cn, self.parent.cn:get_role('ADMIN'))
                                break
                            end
                        end
                    else
                        self.parent.say:me(cn,self.parent.cnf.cmd.text.sudo_error_empty)
                        self.parent.log:w(self.parent.cnf.cmd.text.sudo_error_empty,cn)
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
            cfn = function (self,cn, args)
                self.parent.log:i("used $maptime",cn)
                if #args == 0 then
                    self.parent.say:me(cn,self.parent.cnf.cmd.text.maptime_error) return true
                elseif #args >= 1 then
                    local arg = self.parent.fn:trim(args[1])
                    if arg == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text.maptime_help) return true end
                    arg = tonumber(arg)
                    if arg < 1 or arg > 60 then self.parent.say:me(cn,self.parent.cnf.cmd.text.maptime_error) return true end
                    settimeleft(arg)
                    self.parent.say:me(cn,string.format(self.parent.cnf.cmd.text.maptime_text,arg))
                end
            end
        },

        -- ROOT --

        ['su'] = {},
        ["$su"] = {
            protected = { true, true, false, false, false, false },
            cfn = function (self,cn, args)
                self.parent.log:i("used $su",cn)
                if #args == 0 then
                    self.parent.say:me(cn,self.parent.cnf.cmd.text.su_error) return
                elseif #args >= 1 then
                    local tcn = self.parent.fn:trim(args[1])
                    if tcn == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text.su_help) return end

                    tcn = tonumber(tcn)

                    if not self.parent.cn:chk_cn(tcn) or not isconnected(tcn) then
                        self.parent.say:me(cn,self.parent.cnf.cmd.text.su_no_user) return
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
                end
                    --return PLUGIN_BLOC
                    --if not isadmin(cn) then setrole(cn,self.parent.cn.get_role('ADMIN'), false) end
            end
        },

        ['useradd'] = {},
        ["$useradd"] = {
            protected = { true, true, false, false, false, false  },
            cfn = function (self,cn, args)
                self.parent.log:i("used $useradd",cn)
                if #args == 0 then
                    self.parent.say:me(cn,self.parent.cnf.cmd.text.useradd_error) return true
                elseif #args >= 1 then
                    local arg = self.parent.fn:trim(args[1])
                    if arg == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text.useradd_help) return true end


                    name = arg[1] or self.parent.cn.data[self.parent.cn.data_cn[cn]].name

                    -- name, role, password
                    self.parent.sql:query(string.format('NSERT INTO user VALUES (\'%s\', \'%s\')]]', arg[1],arg[2],arg[3]))
                end
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
                    self.list.aviable = string.format('\2%s \f4| \f2%s', k, self.list.aviable)
                elseif self.commands[k].protected[4] then
                    self.list.registered = string.format('\f0%s \f4| \f0%s', k, self.list.registered)
                elseif self.commands[k].protected[3] then
                    self.list.referee = string.format('\f1%s \f4| \f1%s', k, self.list.referee)
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
