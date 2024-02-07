local resourceRoot = getResourceRootElement(getThisResource())
     
addEventHandler("onClientResourceStart",resourceRoot,
function ()
    
    txd = engineLoadTXD ( "wmymech.txd" )
    engineImportTXD ( txd, 50 )

    dff = engineLoadDFF ( "wmymech.dff", 50 )
    engineReplaceModel ( dff, 50 )
    
end)

