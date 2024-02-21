local apiKey = '99daf59aedc54ca19d8174743242002';
local apiUrl = 'https://api.weatherapi.com/v1/current.json?';

setMinuteDuration(60000);

function handleResponse(response, error, player)
    if error == 0 then
        outputServerLog(response);
        triggerClientEvent(player, "onSetClientWeather", resourceRoot, fromJSON(response));
    else
        outputServerLog("Erro ao solicitar a API de Clima: " .. tostring(error));
    end
end

function getRealWeatherByZone(player, zone)
    local newUrl = '';

    if zone == "Los Santos" then
        newUrl = apiUrl.."q=Los Angeles&key="..apiKey;
    elseif zone == "San Fierro" then
        newUrl = apiUrl.."q=San Francisco&key="..apiKey;
    elseif zone == "Las Venturas" then
        newUrl = apiUrl.."q=Las Vegas&key="..apiKey;
    elseif zone == "Red County" then
        newUrl = apiUrl.."q=Modesto&key="..apiKey;
    elseif zone == "Bone County" then
        newUrl = apiUrl.."q=89001&key="..apiKey;
    elseif zone == "Flint County" then
        newUrl = apiUrl.."q=Berkeley&key="..apiKey;
    elseif zone == "Whetstone" then
        newUrl = apiUrl.."q=Yosemite&key="..apiKey;
    elseif zone == "Tierra Robada" then
        newUrl = apiUrl.."q=Ridgecrest&key="..apiKey;
    end
    
    fetchRemote(newUrl, handleResponse, "", false, player);
end
addEvent("onGetRealWeather", true);
addEventHandler("onGetRealWeather", resourceRoot, getRealWeatherByZone);

