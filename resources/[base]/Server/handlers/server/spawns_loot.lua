local random = math.random;
local tableInsert = table.insert;
lootPointsCols = {};

local function createLootObjects(col, group, slots)
    local items = getElementData(col, "itemsInLoot") or {};
    for i = 1, slots do
        if items[i] ~= nil then
            destroyElement(items[i].object);
            items[i] = nil;
        end
    end

    local counter = 0;
    local x, y, z = getElementPosition(col);
    local usedPositions = {};
    
    for _, item in pairs(lootItems[group]) do
        if getElementData(col, item[1]) and getElementData(col, item[1]) > 0 then
            counter = counter + 1;
            items[counter] = { itemData = item };
            items[counter].object = createObject(item[4], x + random(-1, 1), y + random(-1, 1), z + item[6]);
            setObjectScale(items[counter].object, item[5]);
            setElementCollisionsEnabled(items[counter].object, false);
            setElementFrozen(items[counter].object, true);
        end
    end

    setElementData(col, "itemsInLoot", items);
    return col;
end


local function createLootPoint(group)
    for k, point in ipairs(lootSpawnPoints[group]) do
        local col = createColSphere(point[1], point[2], point[3], 1.5);
        setElementData(col, "lootName", "Loot");
        setElementData(col, "maxSlots", point[4]);

        local counter = 0;

        while counter < point[4] do
            for i, item in ipairs(lootItems[group]) do
                local value = math.percentChance(item[3], random(1, 2));

                if value > 0 then
                    if getElementData(col, item[1]) and getElementData(col, item[1]) > 0 then
                        setElementData(col, item[1], getElementData(col, item[1]) + value);
                    else
                        setElementData(col, item[1], value);
                    end
                    counter = counter + 1;
                end

                if counter == point[4] then
                    break;
                end
            end
        end

        col = createLootObjects(col, group, point[4]);
        tableInsert(lootPointsCols, col);
    end
end

local function createLootSpawnPoints()
    lootPointsCols = {};
    createLootPoint("RESIDENTIAL");
end
addEventHandler("onResourceStart", getRootElement(), createLootSpawnPoints);
