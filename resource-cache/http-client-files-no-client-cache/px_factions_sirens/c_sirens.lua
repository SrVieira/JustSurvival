--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

Siren={}

Siren.State=false

Siren.Timers={}

Siren.Block=false

Siren.Factions={
    ["SAPD"]=true,
    ["SARA"]=true,
    ["PSP"]=true,
}

function Siren.Start(vehicle)
    if(getElementData(vehicle, "vehicle:group_ownerName") and Siren.Factions[getElementData(vehicle, "vehicle:group_ownerName")])then
        local components=getElementData(vehicle, "vehicle:components") or {}
        components["siren_on"]="siren_on"
        setElementData(vehicle, "vehicle:components", components)
    end
end

function Siren.Stop(vehicle)
    local components=getElementData(vehicle, "vehicle:components") or {}
    components["siren_on"]=nil
    setElementData(vehicle, "vehicle:components", components)
end

bindKey("J", "down", function()
    local veh=getPedOccupiedVehicle(localPlayer)
    if(not veh)then return end

    if(getVehicleController(veh) ~= localPlayer)then return end

    if(Siren.Block)then return end

    if(not Siren.State)then
        Siren.Start(veh)
        Siren.State=veh
    else
        Siren.Stop(veh)
        Siren.State=false
    end

    Siren.Block=setTimer(function()
        Siren.Block=false
    end, 500, 1)
end)

addEventHandler("onClientElementDataChange", root, function(data,old,new)
    if(data == "vehicle:components" and getElementData(source, "vehicle:group_ownerName") and Siren.Factions[getElementData(source, "vehicle:group_ownerName")])then
        local vehicle=source
        if(new and new["siren_on"])then
            if(Siren.Timers[vehicle])then
                killTimer(Siren.Timers[vehicle])
            end
            Siren.Timers[vehicle]=nil
            
            Siren.Timers[vehicle]=setTimer(function()
                if(vehicle and isElement(vehicle))then
                    if(getVehicleLightState(vehicle, 0) == 1)then
                        setVehicleLightState(vehicle,0,0)
                        setVehicleLightState(vehicle,1,1)
                        setVehicleLightState(vehicle,2,0)
                        setVehicleLightState(vehicle,3,1)
                    else
                        setVehicleLightState(vehicle,0,1)
                        setVehicleLightState(vehicle,1,0)
                        setVehicleLightState(vehicle,2,1)
                        setVehicleLightState(vehicle,3,0)
                    end
                else
                    if(Siren.Timers[vehicle])then
                        killTimer(Siren.Timers[vehicle])
                    end
                    Siren.Timers[vehicle]=nil
                end
            end, 200, 0)
        else
            if(Siren.Timers[vehicle])then
                killTimer(Siren.Timers[vehicle])
                Siren.Timers[vehicle]=nil
            end
        
            setVehicleLightState(vehicle,0,0)
            setVehicleLightState(vehicle,1,0)
            setVehicleLightState(vehicle,2,0)
            setVehicleLightState(vehicle,3,0)
        end
    end
end)

function isSirensOn()
    return Siren.State == getPedOccupiedVehicle(localPlayer)
end