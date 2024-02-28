local screenW, screenH = guiGetScreenSize();
local centerX, centerY = screenW/2, screenH/2;

local renderTargetWidth, renderTargetHeight = 232, screenH - 70;
local renderTargetX = (screenW - renderTargetWidth) - 30;
local renderTargetY = (screenH - renderTargetHeight) / 2;
local inventoryTarget = dxCreateRenderTarget(232, screenH, true);

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
	if inventoryTarget then
		dxSetRenderTarget(inventoryTarget, true);
		dxSetBlendMode("blend");
		dxDrawRectangle(0, 0, renderTargetWidth, renderTargetHeight, tocolor(0, 0, 0, 0))

		-- Equipaments
		exports.dx:dxDrawBorderedRectangle(0, 1, 232, 20, 1, {100, 100, 100, 225}, false);
		exports.dx:dxDrawBorderedRectangle(0, 22, 232, 75, 1, {100, 100, 100, 125}, false);
		exports.dx:dxCustomDrawText(string.upper(inventory.header1), 4, 0, 232, 22, tocolor(255, 255, 255, 255), 'TitleInventory', "left", "center");

		-- Slots
		renderIconSlot(4, 26, "helmet"); -- Helmet
		renderIconSlot(40, 26, "armor"); -- Armor
		renderIconSlot(76, 26, "mask"); -- Mask
		renderIconSlot(112, 26, "hand"); -- Hand
		renderIconSlot(148, 26, "shoes"); -- Shoes
		renderIconSlot(184, 26, "sword"); -- Sword

		renderIconSlot(4, 62, "radio"); -- Radio
		renderIconSlot(40, 62, "binoculars"); -- Binoculars
		renderIconSlot(76, 62, "gps"); -- GPS
		renderIconSlot(112, 62, "map"); -- Map
		renderIconSlot(148, 62, "compass"); -- Compass

		-- Primary Weapon
		exports.dx:dxDrawBorderedRectangle(0, 102, 232, 20, 1, {100, 100, 100, 225}, false);
		exports.dx:dxDrawBorderedRectangle(0, 124, 232, 80, 1, {100, 100, 100, 125}, false);
		exports.dx:dxCustomDrawText('SKS BLACK', 4, 102, 232, 124, tocolor(255, 255, 255, 255), 'SubTitleInventory', "left", "center");

		-- Secondary Weapon
		exports.dx:dxDrawBorderedRectangle(0, 209, 232, 20, 1, {100, 100, 100, 225}, false);
		exports.dx:dxDrawBorderedRectangle(0, 231, 232, 80, 1, {100, 100, 100, 125}, false);
		exports.dx:dxCustomDrawText('WTF WEAPON', 4, 209, 232, 231, tocolor(255, 255, 255, 255), 'SubTitleInventory', "left", "center");

		-- Vest
		exports.dx:dxDrawBorderedRectangle(0, 316, 232, 20, 1, {100, 100, 100, 225}, false);
		exports.dx:dxDrawBorderedRectangle(0, 338, 232, 68, 1, {100, 100, 100, 125}, false);
		exports.dx:dxCustomDrawText('UK ASSAULT VEST', 4, 316, 232, 338, tocolor(255, 255, 255, 200), 'SubTitleInventory', "left", "center");

		-- Shirt
		exports.dx:dxDrawBorderedRectangle(0, 411, 232, 20, 1, {100, 100, 100, 225}, false);
		exports.dx:dxDrawBorderedRectangle(0, 433, 232, 68, 1, {100, 100, 100, 125}, false);
		exports.dx:dxCustomDrawText('TACTICAL JACKET', 4, 411, 232, 433, tocolor(255, 255, 255, 200), 'SubTitleInventory', "left", "center");

		-- Pants
		exports.dx:dxDrawBorderedRectangle(0, 506, 232, 20, 1, {100, 100, 100, 225}, false);
		exports.dx:dxDrawBorderedRectangle(0, 528, 232, 68, 1, {100, 100, 100, 125}, false);
		exports.dx:dxCustomDrawText('BLUE PANTS', 4, 506, 232, 528, tocolor(255, 255, 255, 200), 'SubTitleInventory', "left", "center");

		-- Backpack
		exports.dx:dxDrawBorderedRectangle(0, 601, 232, 20, 1, {100, 100, 100, 225}, false);
		exports.dx:dxDrawBorderedRectangle(0, 623, 232, 120, 1, {100, 100, 100, 125}, false);
		exports.dx:dxCustomDrawText('MOCHILA DE ASSALTO', 4, 601, 232, 623, tocolor(255, 255, 255, 200), 'SubTitleInventory', "left", "center");
				
		dxSetRenderTarget();
	end
end

local function drawRenderTargetOnScreen()
    dxDrawImage(renderTargetX, renderTargetY, renderTargetWidth, renderTargetHeight, inventoryTarget);
end

local function openCloseInventory()
	if getElementData(localPlayer, "isLogged") and not getElementData(localPlayer, "isDead") then
		inventory.visible = not inventory.visible
		showCursor(inventory.visible);
		if inventory.visible then
			addEventHandler("onClientRender", getRootElement(), renderInventoryGUI);
			addEventHandler("onClientRender", getRootElement(), drawRenderTargetOnScreen);
		else
			removeEventHandler("onClientRender", getRootElement(), renderInventoryGUI);
			removeEventHandler("onClientRender", getRootElement(), drawRenderTargetOnScreen);
		end
	end
end
bindKey("J", "down", openCloseInventory);
