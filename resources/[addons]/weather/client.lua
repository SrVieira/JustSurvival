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

local function handleLoadWeather(theKey, oldValue, newValue)
    local currentLocation = newValue;

    if currentLocation ~= nil or currentLocation ~= "unknown" then
        triggerServerEvent("getCurrentWeatherByRegion", resourceRoot, localPlayer, currentLocation);
    end
end
addEventHandler("onClientElementDataChange", root, handleLoadWeather);

function updateClientWeather(player, weatherData)
    if (getElementData(localPlayer, "changedWeather") or false) then
        setWeather(weatherData.weather);
        setElementData(localPlayer, "changedWeather", true);
    else
        setWeatherBlended(weatherData.weather);
    end
end
addEvent("updateClientWeather", true);
addEventHandler("updateClientWeather", root, updateClientWeather);

