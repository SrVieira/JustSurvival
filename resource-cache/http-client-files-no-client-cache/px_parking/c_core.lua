--[[
    @author: Xyrusek
    @mail: xyrusowski@gmail.com
    @project: Pixel (MTA)
]]

parking = {}
    parking.last = {}
    parking.buttons = exports["px_buttons"]
    parking.editboxes = exports["px_editbox"]
    parking.scroll = exports["px_scroll"]
    parking.blur = exports.blur

parking.tryRemoveRentPlayer = function(ownerID, playerID)
    if not ownerID or not playerID then return false end

    if parking.last.removeRent and getTickCount()-parking.last.removeRent < 5000 then
        local time = string.format("%.1f", ((parking.last.removeRent+5000)-getTickCount())/1000)
        sendNotification("Poczekaj "..time.." s, aby ponownie wyrzucić jednego z użytkowników.")
        return false
    end
    parking.last.removeRent = getTickCount()
    triggerLatentServerEvent("px_parking:removeRentFromGarage", 5000, false, getResourceRootElement(), ownerID, playerID)
end

parking.tryAddRentPlayer = function(ownerID, findValue)
    if not ownerID or not findValue then return false end

    local player = findPlayer(findValue)
    if not player then
        sendNotification("Nie odnaleziono użytkownika o nickname/id: "..findValue.." :(")
        return false
    end

    if player == localPlayer then
        sendNotification("Chcesz dodać samego siebie? Dziwne.")
        return false
    end
    
    local playerID = getPlayerUID(player)
    if not playerID then return false end

    if parking.last.addRent and getTickCount()-parking.last.addRent < 5000 then
        local time = string.format("%.1f", ((parking.last.addRent+5000)-getTickCount())/1000)
        sendNotification("Poczekaj "..time.." s, aby ponownie dodać jednego z użytkowników.")
        return false
    end

    parking.last.addRent = getTickCount()
    triggerLatentServerEvent("px_parking:addRentToGarage", 5000, false, getResourceRootElement(), ownerID, playerID, getPlayerName(player))
end

parking.tryEnterGarage = function(ownerID)
    if not ownerID then return false end

    if parking.last.enterGarage and getTickCount()-parking.last.enterGarage < 5000 then
        local time = string.format("%.1f", ((parking.last.enterGarage+5000)-getTickCount())/1000)
        sendNotification("Poczekaj "..time.." s, aby ponownie wejść do garażu.")
        return false
    end

    parking.last.enterGarage = getTickCount()
    triggerLatentServerEvent("px_parking:enterGarage", 5000, false, getResourceRootElement(), ownerID)
end

addEvent("px_parking:onEnterParking", true)
addEventHandler("px_parking:onEnterParking", getResourceRootElement(), function(ownerID)
    parking.garage = {}
    parking.garage.sliders = {}
    parking.ownerID = ownerID
    
    local playerID = getElementDimension(localPlayer)
    for i, v in ipairs({{2457.02, 1761.24, -15.196}, {2472.65, 1761.24, -15.19}}) do
        local x, y, z = unpack(v)
        local index = #parking.garage.sliders+1

        parking.garage.sliders[index] = {
            object = createObject(1777, x, y, z, 0, 0, 0),
            col = createColSphere(x, y, z, 2.2),
        }
        for i, v in pairs(parking.garage.sliders[index]) do setElementDimension(v, playerID) end

        addEventHandler("onClientColShapeHit", parking.garage.sliders[index].col, parking.tryExitGarageWithVehicle)
    end

    parking.garage.exit = createMarker(2464.78, 1767.34, -12.9609, "cylinder", 1.5, 254, 123, 123)
    setElementData(parking.garage.exit, "icon", ":px_parking/textures/outMarker.png", false)
    setElementData(parking.garage.exit, "pos:z", -12.9609-0.97)
    setElementDimension(parking.garage.exit, playerID)
    setElementData(parking.garage.exit, "text", {text="Wyjście", desc="Wyjście na zewnątrz"})

    addEventHandler("onClientMarkerHit", parking.garage.exit, parking.tryExitGarage)
end)

local controls = {"accelerate", "brake_reverse", "enter_exit", "vehicle_left", "vehicle_right"}

parking.tryExitGarageWithVehicle = function(hit, md)
    if not hit or not md or hit ~= localPlayer then return false end
    if isTimer(parking.exitGarageTimer) then return false end

    local vehicle = getPedOccupiedVehicle(hit)
    if not vehicle then return false end

    local ownerID = parking.ownerID
    local vehicleID = getElementData(vehicle, "vehicle:id")
    if not ownerID or not vehicleID then return false end

    local sliderData = (source == parking.garage.sliders[1].col and parking.garage.sliders[1] or parking.garage.sliders[2])

    local x, y, z = getElementPosition(sliderData.object)

    moveObject(sliderData.object, 5000, x, y, z-6, 0, 0, 0, "InOutQuad")

    for i, v in ipairs(controls) do toggleControl(v, false) end
    fadeCamera(false, 5)

    toggleAllControls(false)
    local _,_,z=getElementPosition(vehicle)
    local x,y,_=getElementPosition(sliderData.object)
    setElementPosition(vehicle, x, y, z)
    setElementRotation(vehicle, 0, 0, 0)
    setElementFrozen(vehicle, true)
    setTimer(function()
        setElementFrozen(vehicle, false)
    end, 50, 1)

    setTimer(function()
        setElementFrozen(vehicle, true)
        exports.px_loading:createLoadingScreen(true, false, 7000)
    end, 5000, 1)

    parking.exitGarageTimer = setTimer(function(vehicle, ownerID)
        for i, v in ipairs(controls) do toggleControl(v, true) end
        fadeCamera(true, 3)
        triggerServerEvent("px_parking:getVehicleFromParking", getResourceRootElement(), vehicle, ownerID)

        for i, v in ipairs(parking.garage.sliders or {}) do
            for i2, v2 in pairs(v) do destroyElement(v2) end
        end
    
        parking.garage.sliders = nil
        if isElement(parking.garage.exit) then destroyElement(parking.garage.exit) end
        parking.ownerID = nil

        setElementFrozen(vehicle, false)

        toggleAllControls(true)
        toggleControl("radar",false)
    end, 8000, 1, vehicle, ownerID)
end

parking.tryExitGarage = function(hit, md)
    if not hit or not md or hit ~= localPlayer or getPedOccupiedVehicle(localPlayer) then return false end

    local ownerID = parking.ownerID
    if not ownerID then return false end

    triggerLatentServerEvent("px_parking:exitGarage", 5000, false, getResourceRootElement(), ownerID)

    for i, v in ipairs(parking.garage.sliders or {}) do
        for i2, v2 in pairs(v) do destroyElement(v2) end
    end

    parking.garage.sliders = nil
    if isElement(parking.garage.exit) then destroyElement(parking.garage.exit) end
    parking.ownerID = nil
end

parking.tryRemoveVehicleFromGarage = function(ownerID, vehicleID)
    if not ownerID or not vehicleID then return false end

    if parking.last.removeVehicleFromGarage and getTickCount()-parking.last.removeVehicleFromGarage < 5000 then
        local time = string.format("%.1f", ((parking.last.removeVehicleFromGarage+5000)-getTickCount())/1000)
        sendNotification("Poczekaj "..time.." s, aby ponownie dodać jednego z użytkowników.")
        return false
    end

    parking.last.removeVehicleFromGarage = getTickCount()
    triggerLatentServerEvent("px_parking:removeVehicleFromParking", 5000, false, getResourceRootElement(), ownerID, vehicleID)
end