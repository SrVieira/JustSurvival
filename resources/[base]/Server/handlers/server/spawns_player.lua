local random = math.random;

local function getRandomSpawnByRegion(region)
    return playerSpawnPositions[region][random(1, #playerSpawnPositions[region])];
end

-- Temp
function handleCheckPlayerJoin()
    clearChatBox(source);
    local randomPos = getRandomSpawnByRegion("LOS SANTOS");
    spawnPlayer(source, randomPos[1], randomPos[2], randomPos[3], 0, 0, 0, 0);
    fadeCamera(source, true);
    setCameraTarget(source, source);
    setElementData(source, "isLogged", true);
    setElementData(source, "isDead", false);
end
addEventHandler("onPlayerJoin", getRootElement(), handleCheckPlayerJoin);

function pegaritem(sourcePlayer, commandName, ...)
    local itemName = table.concat({...}, " ");
    if itemName ~= "" then
        setElementData(sourcePlayer, itemName, 1);
    else
        outputChatBox("Por favor, especifique o nome do item.", sourcePlayer);
    end
end
addCommandHandler("pegaritem", pegaritem);
