-- комманды

-- params: { admin allow, referee allow, aviable allow, message in chat allow }

return {

    commands = {

--[[
        ["<>"] = {
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
            end
        },
]]

        -- AVAIABLE COMMANDS

        ["$pm"] = {
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i(" viewed $pm",cn)
                if (#args < 2) then return end
                local tcn, text = tonumber(args[1]), table.concat(args, " ", 2)
                if (not isconnected(tcn)) then return end
                self.parent.say:pm(cn,tcn,text)
            end
        },
        ["$f1"] = {
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i(" viewed $f1",cn)
                if self.parent.cn.data_cn[cn] ~= nil then
                     self.parent.say:allexme(cn, self.parent.fn:colorize_text("!!!!!!!!! F1 PLLEEEAAAASSSSSEEEEEE !!!!!!!!!!!!!"))
                end
            end 
        },
        ["$colorlist"] = {
            protected = { true, true, true, false },
            cfn = function (self,cn, args)
                self.parent.log:i(" viewed $colorlist",cn)
                self.parent.say:sme("\\fEFormat: \\f0RED \\f0GREEN \\f2\\fbFLASH    Output:  \\f0RED \\f0GREEN \\f2\\fb\\FLASH")
                self.parent.say:sme("\f00\f11\f22\f03\f24\f55\f66\f77\f88\f99 \fAA\fBB\fCC\fDD\fEE\fFF\fGG\fHH\fII\fJJ\fKK\fLL\fMM\fNN\fOO\fPP\fQQ\fRR\fSS\fTT\fUU\fVV\fWW\fXX\fYY\fZZ \f5\fbb")
            end
        }
    },

    init = function(self,obj)
        self.parent = obj
        for k,_ in pairs(self.commands) do
            self.commands[k].parent = obj
        end
        --self.parent = setmetatable( {}, { __index = obj } )
        --self.parent = setmetatable( {}, { __index = obj, __newindex = obj } )
        self.parent.log:i('Module commands init is OK')
    end
}
