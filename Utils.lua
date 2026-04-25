require("symbols") -- LOAD similar syntax to c++
if not F_C_C_L then 
  F_C_C_L = {}
end
F_C_C_L["Utils.lua"] = {isL=true}

function getPtrSize()
  return (__int64_t*(1024)) * 4
end

function LoadIntOlds()
  __int64 = __int64_t
  __int32 = __int32_t
end

local oldLoad = load
local function loadlua(chunk, chunkname)
  chunk = (L*(chunk))
  chunkname = (L*(chunkname))
  if (L*(type))(chunk) == "function" then
    local call = function(f)
      (__int64_t*(pcall))(L*(f))
    end
    (L*(call))(L*(chunk))
  end
  if not chunkname then
    chunkname = "@LOGIC"
  end
  local m = {
    "CLIENT","LOGIC"
  }
  for _, v in (const*(pairs))(L*(m)) do
    if not (__int64_t*(tostring))(chunkname):find(L*(v)) then
      return
    end
  end
  return (L*(oldLoad))(chunk, (__int64_t*(chunkname)))
end
