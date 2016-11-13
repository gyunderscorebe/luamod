
-- функции общего назначения

local name = "function.lua"

function split(p,d)
    local t, ll
    t={}
    ll=0
    if(#p == 1) then return {p} end
    while true do
        l=string.find(p,d,ll,true)
        if l~=nil then
            table.insert(t, string.sub(p,ll,l-1))
            ll=l+1
        else
            table.insert(t, string.sub(p,ll))
            break
        end
        end
    return t
end

function slice(array, S, E)
    local result = {}
    local length = #array
    S = S or 1
    E = E or length
    if E < 0 then
        E = length + E + 1
    elseif E > length then
        E = length
    end
    if S < 1 or S > length then
        return {}
    end
    local i = 1
    for j = S, E do
        result[i] = array[j]
        i = i + 1
    end
    return result
end

function ltrim(s) -- remove leading whitespaces
    return (s:gsub("^%s*", ""))
end

function trim(s) --remove leading and trailing whitespace
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function rtrim(s) --remove trailing whitespace
    local n = #s
    while n > 0 and s:find("^%s", n) do n = n - 1 end
    return s:sub(1, n)
end

function isTeammode(mode) -- gamemode
    if mode == 0 or mode == 4 or mode == 5 or mode == 7 or mode == 11 or mode == 13 or mode == 14 then
	return true
    else
	return false
    end
end

function say(text, cn)
    if cn == nil then cn = -1 end
    clientprint(cn, text)
end

function printfile(path)
    -- local file = assert(io.open(path, "r"), "File " .. path .. " not found"))
    for line in io.lines(path) do
        say(line)
    end
end


print ("dofile " ..name)