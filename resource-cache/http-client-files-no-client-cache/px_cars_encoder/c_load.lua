--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

function loadModel(name)
    local id=validVehicleModels[name]
    if(not id)then return false end

    local loaded=false
    for i,n in pairs(names) do
        local path="encoded/"..name..".encoded_"..n
        if(fileExists(path))then
            if(n == "txd")then
                local txdData=loadFile(path)
                if(txdData)then
                    txdData=teaDecode(txdData,secret_key) or ""

                    local txd=engineLoadTXD(txdData)
                    if(txd)then
                        engineImportTXD(txd, id)
                    end
                end
            elseif(n == "dff")then
                local dffData=loadFile(path)
                if(dffData)then
                    dffData=teaDecode(dffData,secret_key) or ""

                    local dff=engineLoadDFF(dffData)
                    if(dff)then
                        engineReplaceModel(dff, id)
                    end
                end
            end 

            loaded=true
        end
    end
    return loaded
end

function loadModels()
    local i=0
    for name,id in pairs(validVehicleModels) do
        i=i+1

        if(i%5 == 0)then
			setTimer(function() coroutine.resume(coroutine.load_vehs) end, 250, 1)
            coroutine.yield()
		end

        loadModel(name)
    end
end

setTimer(function()
    coroutine.load_vehs=coroutine.create(loadModels)
    coroutine.resume(coroutine.load_vehs)
end, 500, 1)