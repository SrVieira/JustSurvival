-- Coke Can
txd = engineLoadTXD("coke.txd", 2823);
engineImportTXD(txd, 2823);
dff = engineLoadDFF("coke.dff", 2823);
engineReplaceModel(dff, 2823);

-- Pepsi Can
txd = engineLoadTXD("pepsi.txd", 2647);
engineImportTXD(txd, 2647);
dff = engineLoadDFF("pepsi.dff", 2647);
engineReplaceModel(dff, 2647);

-- Mountain Dew
txd = engineLoadTXD("mountain_dew.txd", 2342);
engineImportTXD(txd, 2342);
dff = engineLoadDFF("mountain_dew.dff", 2342);
engineReplaceModel(dff, 2342);

-- Water Bottle
txd = engineLoadTXD("water_bottle.txd", 2663);
engineImportTXD(txd, 2663);
dff = engineLoadDFF("water_bottle.dff", 2663);
engineReplaceModel(dff, 2663);

-- Red Bull
txd = engineLoadTXD("redbull.txd", 2683);
engineImportTXD(txd, 2683);
dff = engineLoadDFF("redbull.dff", 2683);
engineReplaceModel(dff, 2683);
