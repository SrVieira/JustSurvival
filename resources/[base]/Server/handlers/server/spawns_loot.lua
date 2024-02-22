lootPointsCols = {};

local function createLootPoint(group)
    for k, point in ipairs(lootSpawnPoints[group]) do
        local col = createColSphere(point[1], point[2], point[3], 1.5);
    end
end

local function createLootSpawnPoints()
    createLootPoint("RESIDENTIAL");
end
addEventHandler("onResourceStart", getRootElement(), createLootSpawnPoints);