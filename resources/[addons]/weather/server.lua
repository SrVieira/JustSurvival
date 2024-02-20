local apiKey = '99daf59aedc54ca19d8174743242002';
local apiUrl = 'https://api.weatherapi.com/v1/current.json?';

setMinuteDuration(60000);

function getRealWeatherByZone(zone)
    local newUrl = '';

    if zone == "Los Santos" then
        newUrl = apiUrl.."q=Los Santos&key="..apiKey;
    elseif zone == "San Fierro" then
        newUrl = apiUrl.."q=San Fierro&key="..apiKey;
    elseif zone == "Las Venturas" then
        newUrl = apiUrl.."q=Las Venturas&key="..apiKey;
    elseif zone == "Red County" then
        newUrl = apiUrl.."q=Red County&key="..apiKey;
    elseif zone == "Bone County" then
        newUrl = apiUrl.."q=Bone County&key="..apiKey;
    elseif zone == "Flint County" then
        newUrl = apiUrl.."q=Flint County&key="..apiKey;
    elseif zone == "Whetstone" then
        newUrl = apiUrl.."q=Whetstone&key="..apiKey;
    elseif zone == "Tierra Roubada" then
        newUrl = apiUrl.."q=Tierra Roubada&key="..apiKey;
    end

    exports.http:fetchData(newUrl);
end
addEvent("onGetRealWeather", true);
addEventHandler("onGetRealWeather", resourceRoot, getRealWeatherByZone);

