-- комманды

-- params: { admin allow, referee allow, registered allow, aviable allow, message in chat allow }

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

        ['about'] = {},
        ["$about"] = {
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i("used $about",cn)
                if self.parent.fn:trim(args[1]) == '-h' then self.parent.say:me(cn,self.help) return true end
                self.parent.say:me(cn, elf.parent.cnf.say.text.about)
                if self.parent.gm.map:is_gema_map() then
                    self.parent.say:me(cn, self.parent.cnf.say.text.rules_map_gema)
                else
                    self.parent.say:me(cn, self.parent.cnf.say.text.rules_map)
                end
                    self.parent.say:me(cn, self.parent.cnf.say.text.key_about)
            end,
            help = ''
        }
    },


    init = function(self,obj)
        self.parent = obj
        local list = ''
        for k,_ in pairs(self.commands) do
            if  string.byte(k,1) == string.byte("$",1) then
                self.commands[k].parent = self.parent
            end
        end

        self.parent.log:i('Module commands init is OK')
    end
}
