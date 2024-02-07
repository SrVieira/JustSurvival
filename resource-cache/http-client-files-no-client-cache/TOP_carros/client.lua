function ReplaceCar()


txd = engineLoadTXD('475.txd', 402)
engineImportTXD(txd, 402)
dff = engineLoadDFF('475.dff', 402)
engineReplaceModel(dff, 402)
end
addEventHandler( 'onClientResourceStart', getResourceRootElement(getThisResource()), ReplaceCar)