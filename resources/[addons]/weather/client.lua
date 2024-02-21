local timeToUpdate = 43200000; -- 12 hours

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
            triggerServerEvent("onGetRealWeather", resourceRoot, localPlayer, newValue);
        end
    end
end
addEventHandler("onClientElementDataChange", root, setWeatherByZone);

local function handleLoadWeather()
    local currentLocation = getElementData(localPlayer, "currentLocation") or nil;
    
    if currentLocation ~= nil or currentLocation ~= "unknown" then
        triggerServerEvent("onGetRealWeather", resourceRoot, localPlayer, currentLocation);
    end
end
addEventHandler("onClientResourceStart", root, handleLoadWeather);

function setWeatherToClient(data)
    if data then
        local temperature = data.current.temp_c;
        local weather = data.current.condition.code;

        outputChatBox(weather)

        setElementData(localPlayer, "weather", weather);
        outputChatBox(weathers[weather][1]);
        setWeather(weathers[weather][1]);
    end
end
addEvent("onSetClientWeather", true);
addEventHandler("onSetClientWeather", root, setWeatherToClient);

