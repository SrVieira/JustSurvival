local resourceRoot = getResourceRootElement(getThisResource())
     
addEventHandler("onClientResourceStart",resourceRoot,
function ()
    
    txd = engineLoadTXD ( "wmymech.txd" )
    engineImportTXD ( txd, 268 )

    dff = engineLoadDFF ( "wmymech.dff", 268 )
    engineReplaceModel ( dff, 268 )
    
end)

