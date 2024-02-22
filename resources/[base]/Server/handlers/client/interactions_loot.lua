function onClientColShapeHit(theElement, matchingDimension)
    if (theElement == localPlayer) then
        outputChatBox("entrou")
    end
end
addEventHandler("onClientColShapeHit", root, onClientColShapeHit);

function onClientColShapeLeave(theElement, matchingDimension)
    if (theElement == localPlayer) then
        outputChatBox("saiu")
    end
end
addEventHandler("onClientColShapeLeave", root, onClientColShapeLeave);