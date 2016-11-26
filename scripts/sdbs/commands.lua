-- комманды

-- params: { admin allow, referee allow, aviable allow, message in chat allow }

return {

    commands = {

--[[
        ["<>"] = {
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i("",cn)
            end,
            help = ''
        },
]]

        -- AVAIABLE COMMANDS

        ["$pm"] = {
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i("used $pm",cn)
                if #args == 0 then
                    self.parent.say:me(cn,'Invalid command call, Enter the \f3 $pm -h \f2for reference.',nil,nil,SAY_WARN) return
                else
                    if args[1] == '-h' then self.parent.say:me(cn,self.help) return end
                    local tcn, text = tonumber(args[1]), table.concat(args, " ", 2)
                    if not self.parent.cn:chk_cn(tcn) then self.parent.say:sme(cn,'This user has no !!!',nil,nil,SAY_ERR) return true end
                    --if self.parent.cnf.say.colorize_text_cmd then text = self.parent.fn:colorize_text(text) end
                    --if  then text = string.gsub(text,"\\f","\f") end
                    self.parent.say:pm(cn,tcn,self.parent.say:colorize(text))
                end
            end,
            help = "\fPrivat message. \f2Format: \f0$pm <CN> <TEXT>"
        },
        ["$1"] = {
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i("used $1",cn)
                if args[1] == '-h' then self.parent.say:me(cn,self.help) return true end
                self.parent.say:allexme(cn, self.parent.fn:random_color().."!!!!!!!!! F1 PLLEEEAAAASSSSSEEEEEE !!!!!!!!!!!!!")
            end,
            help = '\f1Joke. \f0$1 - > \3F1 \f2:) \fPFormat: \f0$1'
        },
        ["$time"] = {
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i("used $time",cn)
                if args[1] == '-h' then self.parent.say:me(cn,self.help) return true end
                self.parent.say:sme(cn,"\f1Date is \f0"  .. os.date("%c"))
            end,
            help = '\f2System time of server \f2:) \fP\f4Format: \f0$time'
        },

        -- $ fixation skip and random password display all :): D
        ['su'] = {},
        ["$su"] = {
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i("used $set",cn)
                if #args == 0 then
                    self.parent.say:me(cn,'Invalid command call, Enter the \f3 $su -h \f2for reference.',nil,nil,SAY_WARN) return
                else
                    if args[1] == '-h' then self.parent.say:me(cn,self.help) return end
                    local tcn = tonumber(self.parent.fn:trim(args[1]))
                    if not self.parent.cn:chk_cn(tcn) then
                        self.parent.say:sme(cn,'This user has no !!!',nil,nil,SAY_ERR) return
                    else                        
                        if #args >= 2 then
                            local arg = self.parent.fn:trim(args[2])
                            local passwords = getadminpwds()
                            for _, password in pairs(passwords) do
                                if arg == password then 
                                    if not self.parent.cn:chk_admin(tcn) then
                                        local acn = self.parent.cn:chk_admin(cn)
                                        if not acn then acn = self.parent.cn:get_admin() else acn = cn end
                                        if acn ~= nil then
                                            setrole(acn,self.parent.cn:get_role('DEFAULT'), false)
                                            callhandler('onPlayerRoleChange',acn, self.parent.cn:get_role('DEFAULT'))
                                            self.parent.log:i("Chk disable old ADMIN is "..tostring(self.parent.cn:chk_admin(acn)),acn)
                                        end
                                        setrole(tcn,self.parent.cn:get_role('ADMIN'), false)
                                        callhandler('onPlayerRoleChange',tcn, self.parent.cn:get_role('ADMIN'))
                                        self.parent.log:i("Chk enable ADMIN is "..tostring(self.parent.cn:chk_admin(tcn)),tcn)
                                    else
                                        if #args >= 3 and tonumber(self.parent.fn:trim(args[3])) == 0 then 
                                            setrole(tcn,self.parent.cn:get_role('DEFAULT'), false)
                                            callhandler('onPlayerRoleChange',tcn, self.parent.cn:get_role('DEFAULT'))
                                            self.parent.log:i("Chk disable old ADMIN is "..tostring(self.parent.cn:chk_admin(acn)),tcn)
                                        else
                                            self.parent.say:sme(cn,self.parent.cn:get_name(tcn)..' is ADMIN !!!',nil,nil,SAY_WARN)
                                        end
                                    end
                                    break
                                else
                                    self.parent.say:sme(cn,'Not valid password !!!',nil,nil,SAY_ERR)
                                end
                            end
                        else
                            self.parent.say:sme(cn,'Empty PASSWORD !!!',nil,nil,SAY_ERR)
                        end
                    end
                    for _,v in ipairs(self.parent.cn.data) do
                        self.parent.log:i(string.format('Player cn = %s Admin status = %s Referee status = %s',tostring(v.cn),tostring(self.parent.cn:chk_admin(v.cn)),tostring(self.parent.cn:chk_referee(v.cn))),v.cn)
                    end
                    return
                    --return PLUGIN_BLOC
                    --if not isadmin(cn) then setrole(cn,self.parent.cn.get_role('ADMIN'), false) end
                end
            end,
            help = '\f2Delegation admin role. Format: $su <CN> <PASSWD> [<FLAG=0>], If the flag = 0 then removes the admin role delegated :) :D'
        },

        -- $ fixation skip and random password display all :): D
        ['sudo'] = {},
        ["$sudo"] = {
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i("used $set",cn)
                if args[1] == '-h' then self.parent.say:me(cn,self.help) return end
                if self.parent.cn:chk_admin(cn) then
                    setrole(cn,self.parent.cn:get_role('DEFAULT'), false)
                    callhandler('onPlayerRoleChange',cn, self.parent.cn:get_role('DEFAULT'))
                    self.parent.log:i("Chk disable ADMIN is "..tostring(self.parent.cn:chk_admin(cn)),cn)
                elseif not self.parent.cn:chk_admin(cn) then
                    if #args >= 1 then
                        local acn = self.parent.cn:get_admin()
                        if acn ~= nil then
                            setrole(acn,self.parent.cn:get_role('DEFAULT'), false)
                            callhandler('onPlayerRoleChange',acn, self.parent.cn:get_role('DEFAULT'))
                            self.parent.log:i("Chk disable old ADMIN is "..tostring(self.parent.cn:chk_admin(admin)),acn)
                        end
                        local arg = self.parent.fn:trim(args[1])
                        local passwords = getadminpwds()
                        for _, password in pairs(passwords) do
                            if arg == password then 
                                setrole(cn,self.parent.cn:get_role('ADMIN'), false)
                                callhandler('onPlayerRoleChange',cn, self.parent.cn:get_role('ADMIN'))
                                self.parent.log:i("Chk enable ADMIN is "..tostring(self.parent.cn:chk_admin(cn)),cn)
                                break
                            else
                                self.parent.say:sme(cn,'Not valid password !!!',nil,nil,SAY_ERR)
                            end
                        end
                    else
                        self.parent.say:sme(cn,'Empty PASSWORD !!!',nil,nil,SAY_ERR)
                    end
                end
                for _,v in ipairs(self.parent.cn.data) do
                    self.parent.log:i(string.format('Player cn = %s Admin status = %s Referee status = %s',tostring(v.cn),tostring(self.parent.cn:chk_admin(v.cn)),tostring(self.parent.cn:chk_referee(v.cn))),v.cn)
                end
                return 
                --PLUGIN_BLOC
            end,
            help = '\f2Set admin role. Format: $sudo <PASSWD> or $sudo for disable admin role'
        },
        
        -- ADMIN COMMANDS

        ["$set"] = {
            protected = { true, true, false, false },
            cfn = function (self,cn, args)
                self.parent.log:i("used $set",cn)
                if #args == 0 then
                    self.parent.say:me(cn,'Invalid command call, Enter the \f3 $set -h \f2for reference.',nil,nil,SAY_WARN) return
                else
                    if args[1] == '-h' then self.parent.say:me(cn,self.help) return end
                    if args[1] == 'maxcl' then
                        if #args >= 2 then
                            if args[2] == '-h' then self.parent.say:me(cn,'Format $set maxcl < 0 <MAXCLIENTS < 17 >') return true end
                            local mc = tonumber(self.parent.fn:trim(args[2]))
                            if mc > 16 then return end
                            setmaxcl(mc)
                            return
                        end
                    end
                end
            end,
            help = '\f2Set commands: maxcl, . Format: $set <command> [<data>,-h]'
        },
        ["$reload"] = {
            protected = { true, false, false, false },
            cfn = function (self,cn, args)
                self.parent.log:i("used $reload",cn)
                if args[1] == '-h' then self.parent.say:me(cn,self.help) return end
                if args[1] == 'mod' then
                    if #args >=1 then
                    --callhandler('onPlayerSayText',cn,'serverextention lua::reload',false,true)
                    --clientprint(cn,'serverextention lua::reload' )
                    return true
                end
                end
            end,
            help = '\f2Reload command. Format: $reload  <command> [<data>,-h]'
        }
    },


    init = function(self,obj)
        self.parent = obj
        self.commands['$help'] = {
            AVAIABLE = '\fXAVAIABLE COMMANDS: ',
            PROTECTED = '\f9PROTECTED COMMANDS: ',
            ADMIN = '\f3ADMIN COMMANDS: ',
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
                if #args < 1 then
                    self.parent.say:sme(cn,'\2There are subsections: \f9AVAIABLE \f1| \f9PROTECTED \f1| \f9ADMIN \f2Please enter \f9$help <sub> or $help 0[n]')
                    return
                end
                if #args < 2 then
                    if args[1] == 'AVAIABLE' or args[1] == '0' then
                        self.parent.say:sme(cn,string.format('%s Enter the \f3 $<COMMAND> -h \f2for reference.',self.AVAIABLE))
                    elseif args[1] == 'PROTECTED' or args[1] == '1' and ( self.parent.cn:chk_admin(cn) or self.parent.cn:chk_referee(cn) ) then
                        self.parent.say:sme(cn,string.format('%s Enter the \f3 $<COMMAND> -h \f2for reference.',self.PROTECTED))
                    elseif args[1] == 'ADMIN' or args[1] == '2' and self.parent.cn:chk_admin(cn) then
                        self.parent.say:sme(cn,string.format('%s Enter the \f3 $<COMMAND> -h \f2for reference.',self.ADMIN))
                    else 
                        self.parent.say:sme(cn,'You do not have rights to view.',nil,nil,SAY_WARN)
                    end
                end                
            end
        }

        local list = ''
        for k,_ in pairs(self.commands) do
            if  string.byte(k,1) == string.byte("$",1) then
                self.commands[k].parent = obj
                if self.commands[k].protected[3] then
                    self.commands['$help'].AVAIABLE = '\fP'..self.commands['$help'].AVAIABLE..'\fP'..k..' \f3| '
                elseif self.commands[k].protected[2] then
                    self.commands['$help'].PROTECTED = self.commands['$help'].PROTECTED..'\fP'..k..' \f3| '
                elseif self.commands[k].protected[1] then
                    self.commands['$help'].ADMIN = self.commands['$help'].ADMIN..'\fP'..k..' \f3| '
                end
            end
        end
        --sub(0,#self.data[self.data_cn[cn]].geo-2)
        self.commands['$help'].AVAIABLE = self.commands['$help'].AVAIABLE:sub(0,#self.commands['$help'].AVAIABLE-2)
        self.commands['$help'].PROTECTED = self.commands['$help'].PROTECTED:sub(0,#self.commands['$help'].PROTECTED-2)
        self.commands['$help'].ADMIN = self.commands['$help'].ADMIN:sub(0,#self.commands['$help'].ADMIN-2)
        --self.commands['$help'].AVAIABLE = self.commands['$help'].AVAIABLE:sub(0,-9)
        --self.commands['$help'].PROTECTED = self.commands['$help'].PROTECTED:sub(0,-9)
        --self.commands['$help'].ADMIN = self.commands['$help'].ADMIN:sub(0,#self.commands['$help'].ADMIN-9)
        --self.parent = setmetatable( {}, { __index = obj } )
        --self.parent = setmetatable( {}, { __index = obj, __newindex = obj } )
        self.parent.log:i('Module commands init is OK')
    end
}
