-- Infos
local theTableMenuScroll = {};
local msgShow = false;
local msgKey = "";
local msgText = "";
local msgPosition = 0, 0, 0;

local function setLootInfo(show, key, text, element)
	msgShow = show;
	msgKey = key;
	msgText = text;
	msgPosition = element;
end

local function disableLootInfo()
	msgShow = false;
	msgKey = "";
	msgText = "";
	msgPosition = 0, 0, 0;
end

local function onClientColShapeHit(theElement, matchingDimension)
    if (getElementData(localPlayer, "isDead") or false) then 
		return;
	end
    if (theElement == localPlayer) then
        local sourceElement = getElementData(source, "lootName");
        if sourceElement == "Loot" then
            setLootInfo(true, "J", "Checar Loot", source);
        end
    end
end
addEventHandler("onClientColShapeHit", root, onClientColShapeHit);

local function onClientColShapeLeave(theElement, matchingDimension)
    if (theElement == localPlayer) then
        disableLootInfo();
    end
end
addEventHandler("onClientColShapeLeave", root, onClientColShapeLeave);

function renderLootInfo()
	if not msgShow or not isElement(msgPosition) then
	    return;
	end

	local x, y, z = getElementPosition(msgPosition);
	local x, y = getScreenFromWorldPosition(x, y, z);

    local textWidth = dxGetTextWidth(msgText, 1.1, "default-bold-small");
	dxDrawRectangle(x, y, textWidth + 70, 40, tocolor(0, 0, 0, 180));
    dxDrawText(msgText, x + 42, y + 12, x, y, tocolor(255, 255, 255), 1.1, "default-bold-small");

	for id, value in pairs(theTableMenuScroll) do
		if id == numberMenuScroll then
			r, g, b = 0, 0, 0;
		else
			r, g, b = 8, 8, 8;
		end
		dxDrawRectangle(0, 250+id*boxSpace, screenWidth*0.2, boxSpace, tocolor(r, g, b, 180));
		if id == numberMenuScroll then
			dxDrawingColorTextMenuScroll("> "..value[1], 6, 250+id*boxSpace, 6, 250+(id+1)*boxSpace, tocolor(value[2], value[3], value[4], 170), 170, 1, "default-bold", "center", "center");
		else
			dxDrawingColorTextMenuScroll(value[1], 6, 250+id*boxSpace, 6, 250+(id+1)*boxSpace, tocolor(value[2], value[3], value[4], 170), 170, 1, "default-bold", "center", "center");
		end
	end

    dxDrawLinedRectangle(x + 7, y + 7, 26, 26, tocolor(255, 255, 255, 255), 1);
    dxDrawText(msgKey, x + 21, y + 19, x + 21, y + 19, tocolor(255, 255, 255), 1.4, "default-bold-small", "center", "center");
end
addEventHandler("onClientRender", getRootElement(), renderLootInfo);
