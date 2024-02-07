--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local Stain={}

Stain.Variables={}
Stain.Time=(1000*60)

Stain.OnVehicleEnter=function(player,seat,veh)
    if(player ~= localPlayer)then return end

    if(veh)then
        source=veh
    end

    if(seat ~= 0)then return end

    local distance=getElementData(source, "vehicle:distance")
    if(distance and tonumber(distance) and tonumber(distance) > 200000 and not Stain.Variables.Timer)then
        Stain.Variables.Timer=setTimer(function(v)
            local rnd=math.random(0,20)
            if(rnd == 10)then
                local pos={getElementPosition(v)}
                pos[3]=getGroundPosition(pos[1],pos[2],pos[3])
                triggerServerEvent("Get.Stain", resourceRoot, pos)
            end
        end, Stain.Time, 0, source)

        addEventHandler("onClientRender", root, Stain.Render)
        addEventHandler("onClientVehicleExit", root, Stain.OnVehicleExit)

        Stain.Variables.Vehicle=source
    end
end
addEventHandler("onClientVehicleEnter", root, Stain.OnVehicleEnter)

Stain.OnVehicleExit=function(player,seat)
    if(player ~= localPlayer)then return end

    killTimer(Stain.Variables.Timer)

    removeEventHandler("onClientRender", root, Stain.Render)
    removeEventHandler("onClientVehicleExit", root, Stain.OnVehicleExit)

    Stain.Variables={}
end

Stain.Render=function()
    if(Stain.Variables.Timer and (not Stain.Variables.Vehicle or (Stain.Variables.Vehicle and not isElement(Stain.Variables.Vehicle))))then
        killTimer(Stain.Variables.Timer)

        removeEventHandler("onClientRender", root, Stain.Render)
        removeEventHandler("onClientVehicleExit", root, Stain.OnVehicleExit)

        Stain.Variables={}
    end
end

addEvent("Stain.OnHit", true)
addEventHandler("Stain.OnHit", resourceRoot, function(vehicle)
    if(vehicle and isElement(vehicle))then
        local rnd=math.random(1,2)
        setPedControlState("handbrake", true)
        setPedControlState(rnd == 1 and "vehicle_left" or "vehicle_right", true)
        setElementData(vehicle, "vehicle:handbrake", true)
        setTimer(function()
            if(vehicle and isElement(vehicle))then
                setElementData(vehicle, "vehicle:handbrake", false)
            end
            setPedControlState("handbrake", false)
            setPedControlState(rnd == 1 and "vehicle_left" or "vehicle_right", false)
        end, 500, 1)
    end
end)

--- on start

local v=getPedOccupiedVehicle(localPlayer)
if(v)then
    Stain.OnVehicleEnter(localPlayer,getVehicleController(v) == localPlayer and 0 or 1,v)
end

--- progressbar

local zoom = 1
local fh = 1920

local sw, sh = guiGetScreenSize()

if sw < fh then
  zoom = math.min(2,fh/sw)
end

addEvent("faction_oils->runProgressBar", true)
addEventHandler("faction_oils->runProgressBar", resourceRoot, function()
    exports.px_progressbar:createProgressbar(sw/2-671/2/zoom, sh-50/zoom, 671/zoom, 4/zoom, "Trwa zasypywanie plamy piaskiem...", 15/zoom, 15000, false, 0)
    setTimer(function()
        exports.px_progressbar:destroyProgressbar()
    end, 15000, 1)
end)