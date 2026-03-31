-- TO USE THIS FILE, PLS USE REQUIRE() OR DOFILE() OR LOAD() or LOADFILE()
local env = {[-1] = require, [-2] = load, [-3] = loadfile, [-4] = dofile}

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

if getVer() < 52 then
    (L*(print))(L*("Cant go to version 5.1 and lower."))
    return
end

function require(mod)
    if not env then
        return
    end
    if not env.loadedModules then
        env.loadedModules = {}
    end
    local p = env[-1](mod)
    if p then
        env.loadedModules[mod] = true
        return p
    end
end

local old_type = type
type = {org = old_type}

setmetatable(type, { 
    __mul = function(_, v) return type.org(v) end,
    __concat = function(_, v) return type.org(v) end,
    __add = function(_, v) return type.org(v) end,
    __sub = function(_, v) return type.org(v) end,
    __div = function(_, v) return type.org(v) end,
    __call = function(t, v) return type.org(v) end
})
local onStack = {}
function getglobal(env, _name)
  onStack[_name] = 
  return env[_name]
end

function getstack(_name)
  return onStack[_env]
end
