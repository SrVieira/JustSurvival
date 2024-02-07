local s = engineLoadCOL ( "out.col" )
engineReplaceCOL ( s, 1773 )
local s = engineLoadTXD ( "out.txd" )
engineImportTXD ( s, 1773 )
local s = engineLoadDFF ( "out.dff" )
engineReplaceModel ( s, 1773 )

s = nil
setOcclusionsEnabled( false )

