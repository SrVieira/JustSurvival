-- Coke Can
txd = engineLoadTXD("coke.txd", 2823);
engineImportTXD(txd, 2823);
dff = engineLoadDFF("coke.dff", 2823);
engineReplaceModel(dff, 2823);
