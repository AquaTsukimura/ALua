Main_Logic_Files = {}
Main_Client_Files = {}
Main_Loaded_Files = {}

function mark(USING_NAMESPACE, name)
  if USING_NAMESPACE == "USING NAMESPACE LOGIC" then
    Main_Logic_Files[name] = true
  elseif USING_NAMESPACE == "USING NAMESPACE CLIENT" then
    Main_Client_Files[name] = true
  elseif USING_NAMESPACE == "USING SAMESPACE LOADED" then
    Main_Loaded_Files[name] = true
  end
end

return function(namespace, name)
  mark(namespace, name)
end
