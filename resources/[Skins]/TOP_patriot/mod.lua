function replaceModel() 
  txd = engineLoadTXD("patriot.txd", 470 )
  engineImportTXD(txd, 470)
  dff = engineLoadDFF("patriot.dff", 470 )
  engineReplaceModel(dff, 470)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

addCommandHandler ( "reloadcar", replaceModel )