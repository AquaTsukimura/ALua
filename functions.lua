require("symbols")

local env = _ENV

function setglobal(env, name, val)
  env[name] = val
end

local lua = arr* (__array)
function lua.getglobal(name)
  if env then
    return env[name]
  end
end
function lua.loadbuffer(chunk, chunkname, size)
  local newScript = {}
  for i = 1, size do
    newScript[i] = string.sub(chunk, i, i)
  end
  newScript = table.concat(newScript)
  return load(newScript, chunkname)
end

setglobal(env, "lua_getglobal", lua.getglobal)
setglobal(env, "lua_loadbuffer", lua.loadbuffer)
