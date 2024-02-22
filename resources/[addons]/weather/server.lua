local apiKey = '99daf59aedc54ca19d8174743242002';
local apiUrl = 'https://api.weatherapi.com/v1/current.json?';
local weathersLoaded = {
    ["Los Santos"] = { weather = nil, temperature = nil },
    ["San Fierro"] = { weather = nil, temperature = nil },
    ["Las Venturas"] = { weather = nil, temperature = nil },
    ["Red County"] = { weather = nil, temperature = nil },
    ["Bone County"] = { weather = nil, temperature = nil },
    ["Flint County"] = { weather = nil, temperature = nil },
    ["Whetstone"] = { weather = nil, temperature = nil },
    ["Tierra Robada"] = { weather = nil, temperature = nil },
};
local timeToUpdateWeather = 43200000; -- 12 hours

setMinuteDuration(60000);

local function handleResponse(response, error, zone)
    if error == 0 then
        local data = fromJSON(response);
        weathersLoaded[zone].temperature = data.current.temp_c;
        weathersLoaded[zone].weather = weathers[data.current.condition.code][1];
    else
        outputServerLog("Erro ao solicitar a API de Clima: " .. tostring(error));
    end
end

local function generateWeatherByZone(zone)
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

    fetchRemote(newUrl, handleResponse, "", false, zone);
end

local function generateAllWeathers()
    generateWeatherByZone("Los Santos");
    generateWeatherByZone("San Fierro");
    generateWeatherByZone("Las Venturas");
    generateWeatherByZone("Red County");
    generateWeatherByZone("Bone County");
    generateWeatherByZone("Flint County");
    generateWeatherByZone("Whetstone");
    generateWeatherByZone("Tierra Robada");   
end
addEventHandler("onResourceStart", getRootElement(), generateAllWeathers);
setTimer(generateAllWeathers, timeToUpdateWeather, 0);

function getCurrentWeatherByRegion(player, zone)
    local weather = weathersLoaded[zone];

    triggerClientEvent(player, "updateClientWeather", player, player, weather);    
end
addEvent("getCurrentWeatherByRegion", true);
addEventHandler("getCurrentWeatherByRegion", getRootElement(), getCurrentWeatherByRegion);
