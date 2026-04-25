require("symbols")
local mark = require("Marker")

function getPtrSize()
  return (__int64_t*(1024)) * 4
end
