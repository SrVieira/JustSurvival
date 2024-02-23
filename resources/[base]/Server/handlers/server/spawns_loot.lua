local tableInsert = table.insert;
lootPointsCols = {};

local function createLootObjects(col, group)
    local x, y, z = getElementPosition(col);

    for k, loot in ipairs(lootItems[group]) do
       createObject(loot[4], x, y, z);
    end
end

local function createLootPoint(group)
    for k, point in ipairs(lootSpawnPoints[group]) do
        local col = createColSphere(point[1], point[2], point[3], 1.5);
        setElementData(col, "lootName", "Loot");
        setElementData(col, "maxSlots", point[4]);
        local colObjects = createLootObjects(col, group);
        tableInsert(lootPointsCols, col);
    end
end

local function createLootSpawnPoints()
    createLootPoint("RESIDENTIAL");
end
addEventHandler("onResourceStart", getRootElement(), createLootSpawnPoints);