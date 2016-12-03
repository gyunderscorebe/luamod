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
                if self.parent.cn:chk_registered(cn) then
                    list = string.format('%s%s',self.cmd.list.aviable, self.cmd.list.registered)
                elseif self.parent.cn:chk_referee(cn) then
                    list = string.format('%s%s%s',self.cmd.list.aviable, self.cmd.list.registered, self.cmd.list.referee)
                elseif self.parent.cn:chk_root(cn) then
                    list = string.format('%s%s%s%s',self.cmd.list.aviable, self.cmd.list.registered, self.cmd.list.referee, self.cmd.list.root)
                elseif self.parent.cn:chk_admin(cn) then
                    list = string.format('%s%s%s%s%s',self.cmd.list.aviable, self.cmd.list.registered, self.cmd.list.referee, self.cmd.list.root, self.cmd.list.admin)
                else
                    self.parent.say:me(cn, self.cmd.list.aviable)
                end
                self.parent.say:me(cn,list:sub(0,#list-4))
            end
        },

        ['pm'] = {},
        ["$pm"] = {
            protected = { true, true, true, true, true, false  },
            cfn = function (self,cn, args)
                self.parent.log:i("used $pm",cn)
                if #args == 0 then
                    self.parent.say:me(cn,self.parent.cnf.cmd.text.pm_error) return
                elseif #args >= 1 then
                    if self.parent.fn:trim(args[1]) == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text.pm_help) return true end
                    local tcn, text = tonumber(args[1]), table.concat(args, " ", 2)
                    if not isconnected(tcn) or not self.parent.cn:chk_cn(tcn) then self.parent.say:me(cn,self.parent.cnf.cmd.text.pm_error_cn) return true end
                    local dcn = self.parent.cn.data_cn[cn]
                    local name = self.parent.cn.data[dcn].name
                    local c_name = self.parent.cn.data[dcn].c_name

                    text = self.parent.fn:colorize_text(text)
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
                if #args == 1 and args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.cmd.text.sudo_help) return end
                if self.parent.cn:chk_admin(cn) and isadmin(cn) then
                    setrole(cn,self.parent.cn:get_role('DEFAULT'), false)
                    callhandler('onPlayerRoleChange',cn, self.parent.cn:get_role('DEFAULT'))
                    self.parent.log:i("Chk disable ADMIN is "..tostring(self.parent.cn:chk_admin(cn)),cn)
                elseif not self.parent.cn:chk_admin(cn) then
                    if #args >= 1 then
                        local acn = self.parent.cn:get_admin()
                        if acn ~= nil then
                            setrole(acn,self.parent.cn:get_role('DEFAULT'), false)
                            callhandler('onPlayerRoleChange',acn, self.parent.cn:get_role('DEFAULT'))
                        end
                        local arg = self.parent.fn:trim(args[1])
                        local passwords = getadminpwds()
                        for _, password in pairs(passwords) do
                            if arg == password then
                                setrole(cn,self.parent.cn:get_role('ADMIN'), false)
                                callhandler('onPlayerRoleChange',cn, self.parent.cn:get_role('ADMIN'))
                                break
                            else
                                self.parent.say:me(cn,self.parent.cnf.cmd.text.sudo_error_valid)
                                self.parent.log:w(self.parent.cnf.cmd.text.sudo_error_valid,cn)
                                return
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
                    self.parent.say:me(cn,string.format('%s$g',self.parent.cnf.cmd.text.maptime_text,arg))
                end
            end
        }
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
                    self.list.registered = string.format('\f1%s \f4| \f1%s', k, self.list.registered)
                elseif self.commands[k].protected[3] then
                    self.list.referee = string.format('\f0%s \f4| \f0%s', k, self.list.referee)
                elseif self.commands[k].protected[2] then
                    self.list.root = string.format('\f9%s \f4| \f9%s', k,self.list.root)
                elseif self.commands[k].protected[1] then
                    self.list.admin = string.format('\3%s \f4| \f3%s', k, self.list.admin)
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
