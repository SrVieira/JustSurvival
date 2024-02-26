local screenW, screenH = guiGetScreenSize();
local centerX, centerY = screenW/2, screenH/2;

local inventory = {
    visible = false,
};

local function renderInventoryGUI()
    exports.dx:dxDrawBorderedRectangle(centerX + 157, centerY - 280, 232, 20, 1, {100, 100, 100, 225}, false);
end

local function openCloseInventory()
	if getElementData(localPlayer, "isLogged") and not getElementData(localPlayer, "isDead") then
		inventory.visible = not inventory.visible
		if inventory.visible then
			addEventHandler("onClientRender", getRootElement(), renderInventoryGUI);
		else
			removeEventHandler("onClientRender", getRootElement(), renderInventoryGUI);
		end
	end
end
bindKey("J", "down", openCloseInventory);
