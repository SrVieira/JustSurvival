local resourceRoot = getResourceRootElement(getThisResource())
     
addEventHandler("onClientResourceStart",resourceRoot,
function ()
    
    txd = engineLoadTXD ( "wmymech.txd" )
    engineImportTXD ( txd, 309 )

    dff = engineLoadDFF ( "wmymech.dff", 309 )
    engineReplaceModel ( dff, 309 )
    
end)

