--[[

    author: @psychol.
    models: @savenq
    script: @znaki drogowe

]]

local models=exports.px_models_encoder

local list={
    ["A-1"]='files/A-1.dff',
    ["A-2"]='files/A-2.dff',
    ["A-7"]='files/A-7.dff',
    ["A-10"]='files/A-10.dff',
    ["A-11a"]='files/A-11a.dff',
    ["A-14a"]='files/A-14.dff',
    ["A-30"]='files/A-30.dff',
    ["B-1"]='files/B-1.dff',
    ["B-2"]='files/B-2.dff',
    ["B-20"]='files/B-20.dff',
    ["B-25"]='files/B-25.dff',
    ["B-35"]='files/B-35.dff',
    ["B-36"]='files/B-36.dff',
    ["D-1"]='files/D-1.dff',
    ["D-9"]='files/D-9.dff',
    ["D-18"]='files/D-18.dff',
    ["D-19"]='files/D-19.dff',
    ["D-20"]='files/D-20.dff',
    ["D-23"]='files/D-23.dff',
    ["D-51"]='files/D-51.dff',
    ["T-14a"]='files/T-14a.dff',
    ["T-16"]='files/T-16.dff',
    ["T-14a"]='files/T-14a.dff',
    ["T-16"]='files/T-16.dff',
    ["C-5"]='files/C-5.dff',
    ["C-4"]='files/C-4.dff',
    ["C-2"]='files/C-2.dff',
 }

local txd=engineLoadTXD("files/znaki.txd", true)
local col=engineLoadCOL("files/znaki.col")

function loadModels()
    for name,_ in pairs(list) do
        local path="encoded/"..name..".encoded"
        if(fileExists(path))then
            local dffData=loadFile(path)
            if(dffData)then
                dffData=teaDecode(dffData,secret_key) or ""

                local id=engineRequestModel("object")
                if(id)then
                    engineImportTXD(txd, id)

                    local dff=engineLoadDFF(dffData)
                    if(dff)then
                        engineReplaceModel(dff, id)
                    end

                    engineReplaceCOL(col, id)

                    models:addCustomModel(name,id)
                end
            end
        end
    end
end
loadModels()

addEventHandler("onClientResourceStop", resourceRoot, function()
    for i,v in pairs(list) do
        models:removeCustomModel(i)
    end
end)