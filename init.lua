local old_type = type
type = {org = old_type}

setmetatable(type, { 
    __mul = function(_, v) return type.org(v) end,
    __concat = function(_, v) return type.org(v) end,
    __add = function(_, v) return type.org(v) end,
    __sub = function(_, v) return type.org(v) end,
    __div = function(_, v) return type.org(v) end,
    __call = function(t, v) return t.org(v) end
})
local onStack = {}
function getglobal(env, _name)
  onStack[_name] = 
  return env[_name]
end

function getstack(_name)
  return onStack[_env]
end
