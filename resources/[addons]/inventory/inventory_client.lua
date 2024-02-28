local screenW, screenH = guiGetScreenSize();
local centerX, centerY = screenW/2, screenH/2;

local renderTargetWidth, renderTargetHeight = 232, screenH - 70;
local renderTargetX = (screenW - renderTargetWidth) - 30;
local renderTargetY = (screenH - renderTargetHeight) / 2;
local inventoryTarget = dxCreateRenderTarget(232, screenH, true);

local inventory = {
    visible = false,
    header1 = 'Equipamento',
	backpack = nil,
	primaryWeapon = nil,
	secondaryWeapon = nil,
	vest = nil,
	shirt = nil,
	pants = nil,
};

local function renderIconSlot(x, y, slotName)
	exports.dx:dxDrawBorderedRectangle(x, y, 30, 30, 1, {255, 255, 255, 25}, false);
	if getElementData(localPlayer, slotName) and getElementData(localPlayer, slotName) > 0 then
		dxDrawImage(x, y, 30, 30, "items/"..slotName..".png", 0, 0, 0, tocolor(255, 255, 255, 255), false);
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

		-- Variáveis para controlar a posição Y dos próximos itens
		local nextYBoxA = 102
		local nextYBoxB = 124

		-- Função para renderizar um slot e atualizar as variáveis de posição Y
		local function renderSlot(itemExists, height)
			if itemExists then
				exports.dx:dxDrawBorderedRectangle(0, nextYBoxA, 232, 20, 1, {100, 100, 100, 225}, false);
				exports.dx:dxDrawBorderedRectangle(0, nextYBoxB, 232, height, 1, {100, 100, 100, 125}, false);
				exports.dx:dxCustomDrawText(itemExists, 4, nextYBoxA, 232, nextYBoxB, tocolor(255, 255, 255, 255), 'SubTitleInventory', "left", "center");
				nextYBoxA = nextYBoxA + height + 27
				nextYBoxB = nextYBoxB + height + 27
			end
		end

		-- Renderizar os slots e atualizar as variáveis de posição Y
		renderSlot(inventory.primaryWeapon, 80)
		renderSlot(inventory.secondaryWeapon, 80)
		renderSlot(inventory.vest, 68)
		renderSlot(inventory.shirt, 68)
		renderSlot(inventory.pants, 68)
		renderSlot(inventory.backpack, 120)
			
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
