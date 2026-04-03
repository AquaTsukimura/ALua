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
  if type(chunk) ~= "string" then
    return
  elseif chunk == "" then
    return
  elseif (not chunk) then
    return
  end
  if type(chunkname) ~= "string" then
    return
  elseif chunkname == "" then
    chunkname = "=(@chunk)"
  elseif (not chunkname) then
    chunkname = "=(@chunk)"
  end
  if type(size) ~= "number" then
    size = #chunk
  end
  local newScript = {}
  for i = 1, size do
    newScript[i] = string.sub(chunk, i, i)
  end
  newScript = table.concat(newScript)
  return load(newScript, chunkname)
end

setglobal(env, "lua_getglobal", lua.getglobal)
setglobal(env, "lua_loadbuffer", lua.loadbuffer)
