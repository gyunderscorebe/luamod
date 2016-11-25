-- комманды

-- params: { admin allow, referee allow, aviable allow, message in chat allow }

return {

    commands = {

--[[
        ["<>"] = {
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
            end,
            help = ''
        },
]]

        -- AVAIABLE COMMANDS

        ["$pm"] = {
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i("used $pm",cn)
                if (#args < 2) then
                    if args[1] == '-h' then self.parent.say:me(cn,self.help) end
                    return
                end
                local tcn, text = tonumber(args[1]), table.concat(args, " ", 2)
                if self.parent.cn.data_cn[cn] == nil then return true end
                --if self.parent.cnf.say.colorize_text_cmd then text = self.parent.fn:colorize_text(text) end
                --if  then text = string.gsub(text,"\\f","\f") end
                self.parent.say:pm(cn,tcn,self.parent.say:colorize(text))
            end,
            help = "\f9Privat message. \f2Format: \f0$pm <CN> <TEXT>"
        },
        ["$1"] = {
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i(" viewed $1",cn)
                if args[1] == '-h' then self.parent.say:me(cn,self.help) return true end
                self.parent.say:allexme(cn, "!!!!!!!!! F1 PLLEEEAAAASSSSSEEEEEE !!!!!!!!!!!!!")
            end,
            help = '\f1Joke. \f0$1 - > \3F1 \f2:) \fPFormat: \f0$1'
        },
        ["$time"] = {
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i("used $time",cn)
                if args[1] == '-h' then self.parent.say:me(cn,self.help) return true end
                self.parent.say:sme(cn,"\f0D\f2ate is \f0"  .. os.date("%c"))
            end,
            help = '\f1System time of server \f2:) \fP\f4Format: \f0$time'
        },

        
        -- ADMIN COMMANDS

        ["$restart"] = {
            protected = { true, false, false, false },
            cfn = function (self,cn, args)
                self.parent.log:i("used $reload",cn)
                if args[1] == '-h' then self.parent.say:me(cn,self.help) return true end
                if args[1] == 'mod' then callhandler('onPlayerSayText',cn,'serverextention lua::reload',team,me) return true end
            end,
            help = '\f9Restart LuaMod '..PLUGIN_NAME..' Format: $restart mod'
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
                        self.parent.say:sme(cn,self.AVAIABLE) 
                    elseif args[1] == 'PROTECTED' or args[1] == '1' and ( self.parent.cn:chk_admin(cn) or self.parent.cn:chk_referee(cn) ) then
                        self.parent.say:sme(cn,self.PROTECTED)
                    elseif args[1] == 'ADMIN' or args[1] == '2' and self.parent.cn:chk_admin(cn) then
                        self.parent.say:sme(cn,self.ADMIN)
                    else 
                        self.parent.say:sme(cn,'\f3You do not have rights to view.',_,_,_SAY_WARN)
                    end
                end                
            end
        }

        local list = ''
        for k,_ in pairs(self.commands) do
            self.commands[k].parent = obj
            if self.commands[k].protected[3] then
                self.commands['$help'].AVAIABLE = '\fP'..self.commands['$help'].AVAIABLE..'\fP'..k..' \f3| '
            elseif self.commands[k].protected[2] then
                self.commands['$help'].PROTECTED = self.commands['$help'].PROTECTED..'\fP'..k..' \f3| '
            elseif self.commands[k].protected[1] then
                self.commands['$help'].ADMIN = self.commands['$help'].ADMIN..'\fP'..k..' \f3| '
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
