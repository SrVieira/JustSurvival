function importGNSkins()
engineImportTXD(engineLoadTXD("Militar.txd"),16)
engineReplaceModel(engineLoadDFF("Militar.dff",0),16)
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),importGNSkins)
