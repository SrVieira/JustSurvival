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
end
addEventHandler("onPlayerJoin", getRootElement(), handleCheckPlayerJoin);
