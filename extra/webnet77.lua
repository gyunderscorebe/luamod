
module(...,package.seeall)

_VERSION = "1.0.2 IP to country using the free webnet77.com database"

--[==[--------------------------------------------------------

SUMMARY

> require 'webnet77'                -- load module
> w = webnet77.new()                -- create new lookup object
> w:load('IpToCountry.csv')         -- load webnet77.com data 
> iso,name = w:lookup('127.0.0.1')  -- lookup IP by string
> iso,name = w:lookup(1006632297)   -- lookup IP by u32
> w = nil                           -- done, allow garbage collection

Under Linux on a 1.8GHz Intel-chip laptop, load()ing takes about one
second (with the webnet77.com data at 6MB uncompressed). Throughput
is about 50,000 lookup()s per second for IP strings and 60,000 per
second when you pass in u32s (since Lua doesn't need to parse the 
strings and multiply out the raw IP number.)

The latest IpToCountry data file can be downloaded from the 'Tools'
section of webnet77.com, which links to:

http://software77.net/cgi-bin/ip-country/geo-ip.pl

The data file itself, compressed with gzip, is at:

http://software77.net/cgi-bin/ip-country/geo-ip.pl?action=download


DETAILS

* w = webnet77.new([name[,strict]])

Returns a webnet77 object which you can use for IP to country lookup.
The methods below are available to the returned object. The parameter
name is optional; if given, the IpToCountry file name is loaded. In 
other words, writing:

> w = webnet77.new('IpToCountry.csv')

is a shortcut for:

> w = webnet.new()
> w:load('IpToCountry.csv')

If name is given and the file cannot be loaded, new() returns nil,err
in the same way as load() below. For the meaning of the optional
parameter strict, see load().


* w:load(name[,strict])

Read in the IpToCountry CSV file called name and create sorted search
tables inside the object w. (You need to decompress the file you 
downloaded from webnet77.com yourself.)

On a 1.8GHz Pentium with a laptop drive, loading a 6MB CSV (the size
of the webnet77 database at the start of 2008) takes about a second.
Note that the whole database is loaded and kept in memory (or at 
least an equivalent representation of it) for each webnet77 object.
The data isn't shared between objects. 

If there is a problem loading the file, you will get nil,err back, 
where err describes the error. If strict is true, then the loader 
will return nil,"ip data out of order" if there are any anomalies.
There is currently one such anomaly, split into two parts, in the 
webnet77.com data -- an IP range which is 'claimed' both by ARIN for
the United States and by RIPE for the EU domain. By default, 
out-of-order data records are silently ignored. 


* co,country = w:lookup(ip)

Pass in an ip number as an integer from 0 to 2^32-1 inclusive, or as
a string in the format 'num.num.num.num' (each num from 0 to 255).
Looks up the IP number in the webnet77 database and returns the 
two-letter ISO country code in co, and the full country name in
country.

If the IP number is missing from the webnet77 database, you will get
a response of '--','UNALLOCATED'. 

If there is an error, such as an illegal IP number, or some corruption
in the database tables (which isn't supposed to happen, of course)
you will get nil,error back, where error is a description such as 'bad
ip number' or 'lookup error'.

For example:

> require 'webnet77'
> w = webnet77.new('IpToCountry.csv')
> = w._VERSION
1.0.1 IP to country using the free webnet77.com database
> = w:lookup('127.0.0.1')
ZZ      RESERVED
> = w:lookup(2^24)
--      UNALLOCATED
> = w:lookup(100663297)
US      UNITED STATES
> = w:lookup(2^32)
nil     bad ip number
> = w:lookup('121.218.73.206')
AU      AUSTRALIA
> = w:lookup('76.256.8.1')
nil     bad ip string
> w = nil


LICENCE

This code is free for any use, for what that's worth. But there is no
warranty, liability, or anything like that. If you use this code, you 
take any and all responsibilities arising from anything which happens
as a result. It's provided just in case you might like it.


--]==]--------------------------------------------------------


function load(self,name,strict)
    local last = -1
    local ib,ie,ia,_,co,cou,coun
    local ibn, ien
    local iptab,cotab = {},{}
    local f = io.open(name,"rt")
    
    --is the file actually there?
    if f == nil then return nil,"file not found" end
    --iterate through the file
    for str in f:lines() do
        --try to split the line into fields
	  local ib,ie,ia,_,co,cou,coun
          if str:sub(1,1) == '"' then 
	    local strr = str:lower():gsub('","', "#")
	    str = string.sub(strr,2,string.len(str)-3)
	    local x = ""
	    local count = 1
	    local var = {}
	    for i=1,string.len(str) do
	      local y = string.sub(str,i,i)
	      if y ~= "#" then x = x .. string.sub(str,i,i)
	      else
		var[count] = x
		count = count + 1
		x = ""
	      end
	    end
	    ib = var[1]
	    ie = var[2]
	    ia = var[3]
	    co = var[5]
	    cou = var[6]
	    coun = string.sub(x,1,string.len(x)-1)
	end
      
        --check that it was a well-formed line
        if ib == nil or ie == nil or co == nil then
            --unparseable lines are ignored unless they start with '"'
            --this prevents new-format lines getting ignored for ever
            --note we must skip lines where co=nil lest we return it
            if str:sub(1,1) == '"' then 
	      return nil,"bad line in file" 
	    end
        else
            --parseable lines belong in the table
            ibn, ien = tonumber(ib), tonumber(ie)
            if ibn <= last or ien < ibn then
                --don't accept this record if it's out-of-order
                --(see comments above about repeated ranges in real data)
                if strict then return nil,"ip data out of order" end
            else
                --if this record doesn't follow on from the last, fill the 'gap'
                if ibn ~= last+1 then
                    iptab[#iptab+1] = last+1
                    cotab[#cotab+1] = "-- UNALLOCATED"
                end
                --and add this record to the (sorted) lists 
                --note: lua internalises strings so the regular repetition
                --of common country names doesn't waste memory
                iptab[#iptab+1] = ibn
                cotab[#cotab+1] = co..' '..coun
                last = ien
            end
        end
    end    
    
    --add a catchall record (doesn't matter if out of 32-bit range)
    iptab[#iptab+1] = last+1
    cotab[#cotab+1] = "-- UNALLOCATED"
    
    self.iptab, self.cotab = iptab, cotab
    return self
end


function lookup(self,ip)
    --validate and convert the ip parameter
    if type(ip) == 'number' then 
       if ip<0 or ip>=2^32 then return nil,"bad ip number" end
    elseif type(ip) == 'string' then
       local a,b,c,d = ip:match('(%d+).(%d+).(%d+).(%d+)')
       if a==nil or b==nil or c==nil or d==nil then return nil, "bad ip string" end
       a,b,c,d = a+0,b+0,c+0,d+0
       if a<0 or b<0 or c<0 or d<0 then return nil,"bad ip string" end
       if a>255 or b>255 or c>255 or d>255 then return nil,"bad ip string" end
       ip = a*2^24 + b*2^16 + c*2^8 + d
    else
       return nil, "bad ip parameter"
    end
    
    --check that ip number is inside our table's coverage
    local bot,top = 1,#self.iptab
    if ip <  self.iptab[bot] then return "--","UNALLOCATED" end
    if ip >= self.iptab[top] then return "--","UNALLOCATED" end
    
    --now binary chop the table until we find the country
    --this should never take more than log-base-2(tablesize) chops
    --lap and lim are there just in case, to ensure no infinite loops
    local lap,lim = 0,(math.log(#self.iptab)/math.log(2))*1.5
    repeat
        lap = lap+1
        local mid = bot + math.floor((top-bot)/2)
        --see if we've found the answer
        if ip >= self.iptab[mid] and ip < self.iptab[mid+1] then
            return self.cotab[mid]:match('(%C%C) (.*)')
        end
        --if not, chop off the half it can't be in
        if ip < self.iptab[mid] then top = mid else bot = mid+1 end
    until bot >= top or lap > lim
    
    --this isn't supposed to happen unless the table is corrupt
    return nil,"lookup error"
end

    
function new(name,strict)
    local w = setmetatable({},{__index=_M})
    if type(name) == 'string' then 
        local t,e = w:load(name,strict)
        if t == nil then w = nil; return nil,e end
    end
    return w
end
