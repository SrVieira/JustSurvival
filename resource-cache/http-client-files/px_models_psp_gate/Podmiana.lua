local s = engineLoadCOL ( "2885.col" )
engineReplaceCOL ( s, 2885 )
local s = engineLoadTXD ( "2885.txd" )
engineImportTXD ( s, 2885 )
local s = engineLoadDFF ( "2885.dff" )
engineReplaceModel ( s, 2885, true)

s = nil
