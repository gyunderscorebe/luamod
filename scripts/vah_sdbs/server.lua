
server = {} 

server.name = "server.lua"

-- Muted players' table

server.muted = {}
     
--[[
     
      server.mute - Mute a player
     
      Parameters:
      - cn
        - integer
          - player client number
      - tcn
        - integer
          - player client number
      - reason
        - string
          - reason for mute
     
]]

function server.mute(cn, tcn, reason)
    table.insert(self.muted, getip(tcn))
    local msg = string.format("You have been muted by %s", getname(cn))    
    if reason ~= "" then
       msg = msg .. string.format(" - Reason: %s", reason)
    end
    say("\f2[SERVER INFO] \f2" .. msg, tcn)
end
     
--[[
     
      server.unmute - Unmute a player
     
      Parameters:
      - cn
        - integer
          - player client number
     
]]

function server.unmute(cn)
    table.itemremove(self.muted, getip(cn))    
    say("\f2[SERVER INFO] \fEYou have been unmuted.", cn)
end
     
--[[
     
      server.is_muted - Check if a player is muted
     
      Parameters:
      - cn
        - integer
          - player client number
     
]]

function server.is_muted(cn)
    return table.contains(self.muted, getip(cn))
end
     
--[[
     
      LOCAL translate_number_letters - Replace numbers (4 => a, 3 => e, etc)
     
      Parameters:
      - text
        - string
          - text to escape
     
]]

function server.translate_number_letters(text)
    text = text:gsub("4", "a")
    text = text:gsub("3", "e")
    text = text:gsub("1", "i")
    text = text:gsub("0", "o")
    return text
end
     
--[[
     
      block_text - Block a player's text from being sent (handled with "onPlayerSayText" event)
     
      Parameters:
      - cn
        - integer
          - player client number
      - text
        - string
          - mute trigger
     
]]

function server.block_text(cn, text)
    if server.is_muted(cn) then
        say("\f2[SERVER INFO] \f3Your chat messages are being blocked.", cn)
        return true
    else -- Check for mute triggers in their message
        text = string.lower(self.translate_number_letters(text))
        for _, trigger in pairs(mute_words) do
            if text:match(trigger) then
                say("\f2[SERVER INFO] \f3Your chat messages are being blocked due to offensive language.", cn)
                table.insert(self.muted, getip(cn))
                return true
            end
        end
    end
end

print ("dofile " ..server.name)
