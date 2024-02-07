--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local custom_models={}

local with_windows={
    ["components_workshop"]=true,
    [16386]=true,
}

local modelsTypes={
    ["sara_skin_1"]="ped",
    ["sara_skin_2"]="ped",
    ["sara_skin_3"]="ped",
    ["sara_skin_4"]="ped",
    ["sara_skin_5"]="ped",
    ["sara_skin_6"]="ped",
    ["sara_skin_7"]="ped",
    ["sara_skin_8"]="ped",
}

function loadModel(v, max)
    local id, fileName, txdLength, dffLength, colLength=unpack(v)
    local name

    -- load file
    local file=fileOpen(fileName)
    if(not file)then return end

    if(not tonumber(id))then 
        name=id
        id=engineRequestModel(modelsTypes[name] or "object")
        custom_models[name]=id
    end

    -- start txd
    if(txdLength > 0)then
        local txdData=fileRead(file, txdLength)
        txdData=teaDecode(txdData,secret_key)

        saveFile(fileName..".tmpTxd", txdData)
        local txd=engineLoadTXD(fileName..".tmpTxd")
        if(txd)then
            engineImportTXD(txd, id)
        end
        fileDelete(fileName..".tmpTxd")
    end

    -- go to dff
    -- start dff
    if(dffLength > 0)then
        fileSetPos(file, txdLength)

        local dffData=fileRead(file, dffLength)
        dffData=teaDecode(dffData,secret_key)

        saveFile(fileName..".tmpDff", dffData)
        local dff=engineLoadDFF(fileName..".tmpDff")
        if(dff)then
            if(with_windows[name] or with_windows[id])then
                engineReplaceModel(dff, id, true)
            else
                engineReplaceModel(dff, id)
            end
        end
        fileDelete(fileName..".tmpDff")
    end

    -- go to col
    -- start col
    if(colLength > 0)then
        fileSetPos(file, txdLength+dffLength)

        local colData=fileRead(file, colLength)
        colData=teaDecode(colData,secret_key)

        saveFile(fileName..".tmpCol", colData)
        local col=engineLoadCOL(fileName..".tmpCol")
        if(col)then
            engineReplaceCOL(col, id)
        end
        fileDelete(fileName..".tmpCol")
    end

    -- close
    fileClose(file)
    --

    loaded=loaded+1

    outputConsole("[px_models_encoder] Successfull loaded ("..id..") "..loaded.." of "..max.." models.")
end

function loadFiles()
    loaded=0

    local file=loadFile("assets.json")
    if(file)then
        local tbl=fromJSON(file) or {}
        for x,v in pairs(tbl) do
            loadModel(v,#tbl)
        end
    end
end
setTimer(loadFiles, 1000, 1)

-- exports

function getCustomModels()
    return custom_models
end

function getCustomModelID(name)
    return custom_models[name]
end

function addCustomModel(name,id)
    custom_models[name]=id
end

function removeCustomModel(name)
    custom_models[name]=nil
end

-- events

addEventHandler("onClientResourceStop", resourceRoot, function()
    for i,v in pairs(custom_models) do
        if(tonumber(v))then
            engineFreeModel(v)
        end
    end
end)