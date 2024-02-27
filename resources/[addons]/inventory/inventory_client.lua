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

	-- Primary Weapon
	exports.dx:dxDrawBorderedRectangle(centerX + 430, centerY - 255, 232, 20, 1, {100, 100, 100, 225}, false);
    exports.dx:dxDrawBorderedRectangle(centerX + 430, centerY - 233, 232, 80, 1, {100, 100, 100, 125}, false);
    exports.dx:dxCustomDrawText('SKS BLACK', centerX + 432, centerY - 255, centerX + 157 + 432, centerY - 255 + 22, tocolor(255, 255, 255, 200), 'SubTitleInventory', "left", "center");

	-- Secondary Weapon
	exports.dx:dxDrawBorderedRectangle(centerX + 430, centerY - 148, 232, 20, 1, {100, 100, 100, 225}, false);
    exports.dx:dxDrawBorderedRectangle(centerX + 430, centerY - 126, 232, 80, 1, {100, 100, 100, 125}, false);
    exports.dx:dxCustomDrawText('WTF WEAPON', centerX + 432, centerY - 148, centerX + 157 + 432, centerY - 148 + 22, tocolor(255, 255, 255, 200), 'SubTitleInventory', "left", "center");

	-- Vest
	exports.dx:dxDrawBorderedRectangle(centerX + 430, centerY - 41, 232, 20, 1, {100, 100, 100, 225}, false);
	exports.dx:dxDrawBorderedRectangle(centerX + 430, centerY - 19, 232, 68, 1, {100, 100, 100, 125}, false);
	exports.dx:dxCustomDrawText('UK ASSAULT VEST', centerX + 432, centerY - 41, centerX + 157 + 432, centerY - 41 + 22, tocolor(255, 255, 255, 200), 'SubTitleInventory', "left", "center");

	-- Shirt
	exports.dx:dxDrawBorderedRectangle(centerX + 430, centerY - (-54), 232, 20, 1, {100, 100, 100, 225}, false);
	exports.dx:dxDrawBorderedRectangle(centerX + 430, centerY - (-76), 232, 68, 1, {100, 100, 100, 125}, false);
	exports.dx:dxCustomDrawText('TACTICAL JACKET', centerX + 432, centerY - (-54), centerX + 157 + 432, centerY - (-54) + 22, tocolor(255, 255, 255, 200), 'SubTitleInventory', "left", "center");

	-- Pants
	exports.dx:dxDrawBorderedRectangle(centerX + 430, centerY - (-149), 232, 20, 1, {100, 100, 100, 225}, false);
	exports.dx:dxDrawBorderedRectangle(centerX + 430, centerY - (-171), 232, 68, 1, {100, 100, 100, 125}, false);
	exports.dx:dxCustomDrawText('BLUE PANTS', centerX + 432, centerY - (-149), centerX + 157 + 432, centerY - (-149) + 22, tocolor(255, 255, 255, 200), 'SubTitleInventory', "left", "center");

	-- Backpack
	exports.dx:dxDrawBorderedRectangle(centerX + 430, centerY - (-244), 232, 20, 1, {100, 100, 100, 225}, false);
	exports.dx:dxDrawBorderedRectangle(centerX + 430, centerY - (-266), 232, 100, 1, {100, 100, 100, 125}, false);
	exports.dx:dxCustomDrawText('MOCHILA DE ASSALTO', centerX + 432, centerY - (-244), centerX + 157 + 432, centerY - (-244) + 22, tocolor(255, 255, 255, 200), 'SubTitleInventory', "left", "center");
end

local function openCloseInventory()
	if getElementData(localPlayer, "isLogged") and not getElementData(localPlayer, "isDead") then
		inventory.visible = not inventory.visible
		showCursor(inventory.visible);
		if inventory.visible then
			addEventHandler("onClientRender", getRootElement(), renderInventoryGUI);
		else
			removeEventHandler("onClientRender", getRootElement(), renderInventoryGUI);
		end
	end
end
bindKey("J", "down", openCloseInventory);
