local random = math.random;
local tableInsert = table.insert;
lootPointsCols = {};

local function createLootObjects(col, group)
    local x, y, z = getElementPosition(col);
    local itemsInLoot = 1;
    local lootObjects = {};

    while itemsInLoot < 3 do
        for k, loot in ipairs(lootItems[group]) do
            lootObjects[itemsInLoot] = createObject(loot[4], x+random(-1, 1), y+random(-1, 1), z + loot[6]);
            setObjectScale(lootObjects[itemsInLoot], loot[5]);
            setElementCollisionsEnabled(lootObjects[itemsInLoot], false);
            setElementFrozen(lootObjects[itemsInLoot], true);
            itemsInLoot = itemsInLoot + 1;
        end
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