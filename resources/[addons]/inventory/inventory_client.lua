local screenW, screenH = guiGetScreenSize();
local centerX, centerY = screenW/2, screenH/2;

local inventory = {
    visible = false,
    header1 = 'Equipamento',
	hasBackpack = nil,
};

local function renderIconSlot(x, y, slotName)
	exports.dx:dxDrawBorderedRectangle(x, y, 30, 30, 1, {255, 255, 255, 25}, false);
	if inventory[slotName] then
		outputChatBox(slotName);
	else
		dxDrawImage(x, y, 30, 30, "ui/empty_"..slotName..".png", 0, 0, 0, tocolor(255, 255, 255, 255), false);
	end	
end

local function renderInventoryGUI()
	-- Equipaments
    exports.dx:dxDrawBorderedRectangle(centerX + 430, centerY - 350, 232, 20, 1, {100, 100, 100, 225}, false);
    exports.dx:dxDrawBorderedRectangle(centerX + 430, centerY - 328, 232, 68, 1, {100, 100, 100, 125}, false);
    exports.dx:dxCustomDrawText(string.upper(inventory.header1), centerX + 432, centerY - 350, centerX + 157 + 432, centerY - 350 + 22, tocolor(255, 255, 255, 200), 'TitleInventory', "left", "center");

	-- Slots
	renderIconSlot(centerX + 432, centerY - 326, "helmet"); -- Helmet
	renderIconSlot(centerX + 466, centerY - 326, "armor"); -- Armor
	renderIconSlot(centerX + 500, centerY - 326, "mask"); -- Mask
	renderIconSlot(centerX + 534, centerY - 326, "hand"); -- Hand
	renderIconSlot(centerX + 568, centerY - 326, "shoes"); -- Shoes
	renderIconSlot(centerX + 602, centerY - 326, "sword"); -- Sword
	renderIconSlot(centerX + 432, centerY - 292, "radio"); -- Radio
	renderIconSlot(centerX + 466, centerY - 292, "binoculars"); -- Binoculars
	renderIconSlot(centerX + 500, centerY - 292, "gps"); -- GPS
	renderIconSlot(centerX + 534, centerY - 292, "map"); -- Map
	renderIconSlot(centerX + 568, centerY - 292, "compass"); -- Compass
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
