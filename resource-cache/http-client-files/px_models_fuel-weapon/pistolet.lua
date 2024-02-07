function pistolet()

txd = engineLoadTXD ("pistolet.txd", 346) 
engineImportTXD(txd, 346)
dff = engineLoadDFF ("pistolet.dff", 346)
engineReplaceModel(dff, 346)

end

addEventHandler("onClientResourceStart", resourceRoot, pistolet )
