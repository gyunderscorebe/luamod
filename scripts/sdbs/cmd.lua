-- комманды

-- params: { admin allow, referee allow, registered allow, aviable allow, message in chat allow }

return {

    commands = {

--[[
        ["<>"] = {
            protected = { true, true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i("",cn)
            end,
            help = ''
        },
]]
        


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
