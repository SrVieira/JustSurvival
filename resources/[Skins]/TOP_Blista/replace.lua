txd = engineLoadTXD("blista.txd")
engineImportTXD(txd, 496)
dff = engineLoadDFF("blista.dff", 496)
engineReplaceModel(dff, 496)

-- generated with http://mta.dzek.eu/