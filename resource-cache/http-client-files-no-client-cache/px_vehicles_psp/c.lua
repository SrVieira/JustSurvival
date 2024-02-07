--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local places={
    [407]=true,
    [578]=true,
}

local timerTrigger=false

function onFiretruckStartEnter()
    if(getElementData(localPlayer, "user:faction") ~= "PSP")then return end

    local data=getElementData(localPlayer, "inFiretruck")
    if(data)then
        if(not timerTrigger)then
            triggerServerEvent("onFiretruckStartEnter", resourceRoot, data)
            timerTrigger=setTimer(function()
                timerTrigger=false
            end, 1000, 1)
        end
    else
        if(getPedOccupiedVehicle(localPlayer))then return end
        
        local pos={getElementPosition(localPlayer)}
        local vehs=getElementsWithinRange(pos[1],pos[2],pos[3],1,"vehicle")
        if(#vehs > 0)then
            for i,v in pairs(vehs) do
                if(places[getElementModel(v)] and not timerTrigger)then
                    triggerServerEvent("onFiretruckStartEnter", resourceRoot, v)
                    timerTrigger=setTimer(function()
                        timerTrigger=false
                    end, 1000, 1)
                end
            end
        end
    end
end
bindKey("J", "down", onFiretruckStartEnter)

--

local truck=false
function render()
    if(truck and isElement(truck))then
        local _,_,rz=getElementRotation(truck)
        setPedRotation(localPlayer,rz)
    end
end

addEventHandler("onClientElementDataChange", root, function(data,old,new)
    if(source ~= localPlayer or data ~= "inFiretruck")then return end

    removeEventHandler("onClientRender",root,render)
    truck=false
    if(new)then
        addEventHandler("onClientRender",root,render)
        truck=new
    end
end)