--Symbols.lua
L = {org = function(v) return v end}

setmetatable(L, { 
    __mul = function(_, v) return L.org(v) end,
    __concat = function(_, v) return L.org(v) end,
    __add = function(_, v) return L.org(v) end,
    __sub = function(_, v) return L.org(v) end,
    __div = function(_, v) return L.org(v) end,
    __call = function(t, v) return L.org(v) end
})

const = {}

setmetatable(const, { 
    __mul = function(_, v) return L.org(v) end,
    __concat = function(_, v) return L.org(v) end,
    __add = function(_, v) return L.org(v) end,
    __sub = function(_, v) return L.org(v) end,
    __div = function(_, v) return L.org(v) end,
    __call = function(t, v) return L.org(v) end
})

arr = {}

setmetatable(arr, { 
    __mul = function(_, v)   return {}   end,
    __concat = function(_, v)   return {}   end,
    __add = function(_, v)   return {}   end,
    __sub = function(_, v)   return {}   end,
    __div = function(_, v)   return {}   end,
    __call = function(t, v)   return {}   end
})

arr64 = {}

setmetatable(arr64, { 
    __mul = function(_, v)   return {is64 = true}   end,
    __concat = function(_, v)   return {is64 = true}   end,
    __add = function(_, v)   return {is64 = true}   end,
    __sub = function(_, v)   return {is64 = true}   end,
    __div = function(_, v)   return {is64 = true}   end,
    __call = function(t, v)   return {is64 = true}   end
})

arr32 = {}

setmetatable(arr32, { 
    __mul = function(_, v)   return {is32 = false}   end,
    __concat = function(_, v)   return {is32 = false}   end,
    __add = function(_, v)   return {is32 = false}   end,
    __sub = function(_, v)   return {is32 = false}   end,
    __div = function(_, v)   return {is32 = false}  end,
    __call = function(t, v)   return {is32 = false}   end
})

__int64 = {}

setmetatable(__int64, { 
    __mul = function(_, v) local m = getmetatable(v) if m then m.__64Bit = true end return L.org(v) end,
    __concat = function(_, v) local m = getmetatable(v) if m then m.__64Bit = true end return L.org(v) end,
    __add = function(_, v) local m = getmetatable(v) if m then m.__64Bit = true end return L.org(v) end,
    __sub = function(_, v) local m = getmetatable(v) if m then m.__64Bit = true end return L.org(v) end,
    __div = function(_, v) local m = getmetatable(v) if m then m.__64Bit = true end return L.org(v) end,
    __call = function(t, v) local m = getmetatable(v) if m then m.__64Bit = true end return L.org(v) end
})

__int32 = {}

setmetatable(__int32, {
    __mul = function(_, v) local m = getmetatable(v) if m then m.__32Bit = true end return L.org(v) end,
    __concat = function(_, v) local m = getmetatable(v) if m then m.__32Bit = true end return L.org(v) end,
    __add = function(_, v) local m = getmetatable(v) if m then m.__32Bit = true end return L.org(v) end,
    __sub = function(_, v) local m = getmetatable(v) if m then m.__32Bit = true end return L.org(v) end,
    __div = function(_, v) local m = getmetatable(v) if m then m.__32Bit = true end return L.org(v) end,
    __call = function(t, v) local m = getmetatable(v) if m then m.__32Bit = true end return L.org(v) end
})

function getVer()
    local luaVersion;
    local _v = _VERSION
    luaVersion = L*(_v)
    if not (L*(luaVersion)) then
        print("Failed to get lua version.")
        return "1"
    end
    local String = L*(string)
    String.gsub = L*(String.gsub)
    if String.gsub then
        luaVersion = (L*(String.gsub))(L*(luaVersion), L*("Lua"), L*(""))
        luaVersion = (L*(String.gsub))(L*(luaVersion), L*("%."), L*(""))
        if (L*(luaVersion)) then
            return (L*(tonumber))(L*(luaVersion))
        end
    end
end
