
txd = engineLoadTXD("KOMIS1ZAJEBANY.txd") 
dff = engineLoadDFF("KOMIS1ZAJEBANY.dff") 

engineImportTXD(txd, 8133) 
engineReplaceModel(dff, 8133, true) 



setOcclusionsEnabled( false )   
