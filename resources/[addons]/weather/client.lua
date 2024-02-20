local function checkCurrentZone()
    local currentLocation = getElementData(localPlayer, "currentLocation") or nil;
    local currentWeather = getElementData(localPlayer, "currentWeather") or nil;
    local x, y, z = getElementPosition(localPlayer);
    local zoneName = getZoneName(x, y, z, true);

    if currentLocation == nil or currentLocation ~= zoneName then
        setElementData(localPlayer, "currentLocation", zoneName);
    end
end
setTimer(checkCurrentZone, 1000, 0);

local function setWeatherByZone(theKey, oldValue, newValue)
    if (getElementType(source) == "player") and (theKey == "currentLocation") then
        if newValue ~= "Unknown" and newValue ~= nil then
            triggerServerEvent("onGetRealWeather", localPlayer, newValue);
        end
    end
end
addEventHandler("onClientElementDataChange", root, setWeatherByZone);

local function handleLoadWeather()
    local currentLocation = getElementData(localPlayer, "currentLocation") or nil;
    
    if currentLocation ~= nil or currentLocation ~= "unknown" then
        triggerServerEvent("onGetRealWeather", resourceRoot, currentLocation);
    end
end
addEventHandler("onClientResourceStart", root, handleLoadWeather);

