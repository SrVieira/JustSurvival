-- Level System
function onRanksStart ()
  for k, v in ipairs (getElementsByType ("player")) do
    for id, object in ipairs (aclGroupListObjects (aclGetGroup ("Admin"))) do
	local user = "user."..getAccountName (getPlayerAccount (v))
	  if object == user then
        setElementData(v, "adminRanks", true)
      end
    end	  
  end
end
addEventHandler ( "onResourceStart", root, onRanksStart)  
 
function onRanksPlayerJoin ()
  for id, object in ipairs (aclGroupListObjects (aclGetGroup ("Admin"))) do
  local user = "user."..getAccountName (getPlayerAccount (source))
    if object == user then
      setElementData(source, "adminRanks", true)
    end
  end
end
addEventHandler ( "onPlayerLogin", root, onRanksPlayerJoin)

