--[[

    author: @psychol.
    models: @jokerofficial
    script: @replace windows

]]

local models=exports.px_models_encoder

local windows={
    {"urzad",pos={{942.55,1733.2598,13.2}},doublesided=true},
    {"GlassBank",pos={{2448.0439,2376.8799,13.9}}},
    {"glasssalon",pos={{2201.0801,1394.402,14.66},{1948.55,2068.532,14.6588,0,0,270}}},
    {"glassjanusz",pos={{2765.4375,1451.9247,9.8389,0,0,90}},col=true},

    {"glasstaxi",pos={{2506.123,920.66992,13.236,0,0,180}}},
    {"glasstaxiplus",pos={{2497.2791,920.84399,11.56,0,0,180}}},
    {"glasstaxiplus2",pos={{2503.0701,921.69501,15.079,0,0,180}}},

    {"glasspolice",pos={{2341.47,2459.6499,17.6}}},
    {"glasspolice2",pos={{2322.9399,2471.2444,17.7}}},
    {"glasspolice3",pos={{2286.251,2423.9141,11.898,0,0,180}},dim=997,doublesided=true},
    {"glasspolice4",pos={{2251.248,2490.9146,11.9,0,0,90}},dim=997,doublesided=true},

    {"glassjobstation",pos={{262.30176,1431.8799,11.8}}},
    {"glassbinco",pos={{2101.5449,2243.1797,11.566},{2101.5449,2250.335,11.562},{2101.5449,2264.6299,11.556}},col=true},
    {"glassbinco2",pos={{2101.5439,2257.5127,11.566}},col=true},

    {"hamowniaglass",pos={{-2502.3999,2349.1201,6.0078}},doublesided=true},
    {"hamowniaglass2",pos={{-2501.96,2349.1201,10.9,0,0,180}},doublesided=true},
    {"hamowniaglass3",pos={{-2489.3,2351.3999,10.87777,0,0,180}},doublesided=true},
    {"hamowniaglass4",pos={{-2494.0669,2341.7,10.9,0,0,180}},doublesided=true},

    {"glassud",pos={{2541.5701,2149.5,12.47189,0,0,90}}},
    {"glassgielda",pos={{2792.82,1258.88,11.5,0,0,270}}},

    {"g1",pos={{2795.1001,1991.2,12},{2795.1001,1995.5551,12},{2795.1001,1999.9,12},{2795.1001,2004.2,12},{2821,1991.1801,12},{2821,1995.54,12},{2821,1999.9,12},{2821,2004.26,12}},col=true},
    {"g2",pos={{2818.5,1987.5,11.4},{2797.6001,1987.5,11.4},{2816.1299,1987.5,11.4},{2813.76,1987.5,11.4},{2811.3999,1987.5,11.4},{2799.97,1987.5,11.4},{2802.3401,1987.5,11.4},{2804.71,1987.5,11.4}},col=true},
    {"g3",pos={{2809.7,2006.9,12.4},{2813.2,2006.9,12.4},{2816.7,2006.9,12.4}},col=true},
    {"g4",pos={{2811.8501,1998.244,15.62},{2804.2898,1998.25,15.62}},col=true},
}

for i,v in pairs(windows) do
    local id=engineRequestModel("object")
    if(id)then
        local txd=engineLoadTXD("files/"..v[1]..".txd", true)
        engineImportTXD(txd, id)

        local dff=engineLoadDFF("files/"..v[1]..".dff")
        engineReplaceModel(dff, id, true)

        if(fileExists("files/"..v[1]..".col"))then
            local col=engineLoadCOL("files/"..v[1]..".col")
            if(col)then
                engineReplaceCOL(col, id)
            end
        end

        models:addCustomModel(v[1],id)

        for i,k in pairs(v.pos) do
            local obj=createObject(id, unpack(k))
            if(v.dim)then
                setElementDimension(obj,v.dim)
            end
            if(v.doublesided)then
                setElementDoubleSided(obj,true)
            end
            if(v.col)then
                setElementCollisionsEnabled(obj,false)
            end
        end
    end
end

setOcclusionsEnabled(false)

addEventHandler("onClientResourceStop", resourceRoot, function()
    for i,v in pairs(windows) do
        models:removeCustomModel(v[1])
    end
end)