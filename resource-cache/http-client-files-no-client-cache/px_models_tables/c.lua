txd = engineLoadTXD ("tabliczka.txd", 961)
engineImportTXD(txd, 961)
dff = engineLoadDFF ("tabliczka.dff", 961,true)
engineReplaceModel(dff, 961)
col = engineLoadCOL ("tabliczka.col")
engineReplaceCOL(col,961)