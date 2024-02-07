local s = engineLoadCOL ( "in.col" )
engineReplaceCOL ( s, 1777 )
local s = engineLoadTXD ( "in.txd" )
engineImportTXD ( s, 1777 )
local s = engineLoadDFF ( "in.dff" )
engineReplaceModel ( s, 1777 )

s = nil
setOcclusionsEnabled( false )

