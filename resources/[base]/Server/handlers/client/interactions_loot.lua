function onClientColShapeHit(theElement, matchingDimension)
    if (theElement == localPlayer) then
        local sourceElement = getElementData(source, "lootName");
        if sourceElement == "Loot" then
            local itemsInLoot = getElementData(source, "itemsInLoot");
            for k, item in pairs(itemsInLoot) do
               local itemData = item.itemData;
            end
        end
    end
end
addEventHandler("onClientColShapeHit", root, onClientColShapeHit);

function onClientColShapeLeave(theElement, matchingDimension)
    if (theElement == localPlayer) then
        outputChatBox("saiu")
    end
end
addEventHandler("onClientColShapeLeave", root, onClientColShapeLeave);