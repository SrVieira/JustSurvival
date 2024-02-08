local screenW, screenH = guiGetScreenSize();
local centerX, centerY = screenW/2, screenH/2;

local inventory = {
	header1 = "Equipamentos",
	header2 = "Arma principal",
	header3 = "Arma secundaria",
	header4 = "Comida e Bebidas",
	header5 = "Medicamentos",
	header6 = "Inventario",
	header7 = "Slot",
	header8 = "Atalhos",
	filepathIcon = "images/inventory/icons/",
	filepathUI = "images/inventory/ui/",
	blur = nil,
	vicinity = nil,
	gearName = nil,
	blurBox = nil,
	boxItem = nil,
	attachedItemOnCursor = nil,
	primary = nil,
	secondary = nil,
	tertiary = nil,
	backpack = nil,
	armor = nil,
	helmet = nil,
	locked = false,
	visible = false,
	gearTableConfig = {},
	items = {},
	foodItems = {},
	medicalItems = {},
	itemsloot = {},
	hotBarTable = {},
};

local fontTable = {
	[1] = dxCreateFont("fonts/teko_regular.ttf", 18),
	[2] = dxCreateFont("fonts/teko_regular.ttf", 14),
	[3] = dxCreateFont("fonts/teko_light.ttf", 13),
	[4] = dxCreateFont("fonts/teko_medium.ttf", 17),
	[5] = dxCreateFont("fonts/teko_medium.ttf", 17),
	[6] = dxCreateFont("fonts/teko_regular.ttf", 22),
};

function openCloseInventory()
	if getElementData(localPlayer, "Logged") and not getElementData(localPlayer, "dead") and not isMapOpened() and not isControlMenuActive() then
		inventory.visible = not inventory.visible;
		if inventory.visible then
			showInventory();
		else
			closeInventory();
		end
	end
end
addCommandHandler("Open Inventory", openCloseInventory);

bindKey("J", "down", "Open Inventory");

function showInventory()
	inventory.blurBox = createBlurBox(0, 0, screenW, screenH, 100, 100, 100, 255, false);
	inventory.boxItem = createItemBox(centerX - 80, centerY - 259, 232, 372, localPlayer);
	setElementData(localPlayer, "itemBox", inventory.boxItem, false);
	addEventHandler("onClientRender", root, displayInventoryUI, true, "low-6");
	playSound("sounds/effects/openinventory.wav", false);
	triggerEvent("onClientSidemenuClear", localPlayer);
	inventory.visible = true;
	showCursor(true);
	showChat(false);

	inventory.vicinity = isPlayerInLoot();
	
	if isElement(inventory.vicinity) then
		inventory.boxItemLoot = createItemBox(centerX - 317, centerY - 259, 232, 372, inventory.vicinity);
		setElementData(inventory.vicinity, "itemBox", inventory.boxItemLoot, false);
		if getElementData(inventory.vicinity, "tent") then
			inventory.gearName = "Tenda";
		elseif getElementData(inventory.vicinity, "loot") then
			inventory.gearName = "Loot";
		elseif getElementData(inventory.vicinity, "medicalbox") then
			inventory.gearName = "Caixa Médica";
		elseif getElementData(inventory.vicinity, "vehiclecrash") then
			inventory.gearName = "Veículo Destruído";
		elseif getElementData(inventory.vicinity, "helicrashside") then
			inventory.gearName = "Helicóptero Destruído";
		elseif getElementData(inventory.vicinity, "deadperson") then
			inventory.gearName = getElementData(inventory.vicinity, "lootname") or "??";
		elseif getElementData(inventory.vicinity, "vehicle") then
			local model = getVehicleModel(getElementData(inventory.vicinity, "parent"));
			inventory.gearName = getVehicleNewName(model) or getVehicleNameFromID(model) or "??";
		elseif getElementData(inventory.vicinity, "zombie") then
			inventory.gearName = "Zombie";
		elseif getElementData(inventory.vicinity, "briefcase") then
			inventory.gearName = "Malote";
		elseif getElementData(inventory.vicinity, "customloot") then
			inventory.gearName = getElementData(inventory.vicinity, "lootname") or "??";
		else
			inventory.gearName = "??";
		end
	end
	
	guiSetEnabled(inventory.primaryWeapLabel, true);
	guiSetEnabled(inventory.secondaryWeapLabel, true);
	guiSetEnabled(inventory.tertiaryWeapLabel, true);
	guiSetEnabled(inventory.backpackLabel, true);
	guiSetEnabled(inventory.helmetLabel, true);
	guiSetEnabled(inventory.armorLabel, true);
	
	for i = 1, #inventory.foodLabel do
		guiSetEnabled(inventory.foodLabel[i], true);
	end

	for i = 1, #inventory.medicationLabel do
		guiSetEnabled(inventory.medicationLabel[i], true);
	end
	
	inventoryUpdate();
end

function closeInventory()
	if isElement(inventory.blurBox) then destroyBlurBox(inventory.blurBox); inventory.blurBox = nil end
	if isElement(inventory.boxItem) then destroyItemBox(inventory.boxItem); inventory.boxItem = nil end
	if isElement(inventory.boxItemLoot) then destroyItemBox(inventory.boxItemLoot); inventory.boxItemLoot = nil end
	if isElement(inventory.vicinity) then setElementData(inventory.vicinity, "took", false) end
	removeEventHandler("onClientRender", root, displayInventoryUI)
	guiSetEnabled(inventory.primaryWeapLabel, false)
	guiSetEnabled(inventory.secondaryWeapLabel, false)	
	guiSetEnabled(inventory.tertiaryWeapLabel, false)
	guiSetEnabled(inventory.backpackLabel, false)
	guiSetEnabled(inventory.helmetLabel, false)
	guiSetEnabled(inventory.armorLabel, false)
	inventory.attachedItemOnCursor = nil
	inventory.vicinity = nil
	inventory.gearName = nil
	inventory.primary = nil
	inventory.secondary = nil
	inventory.tertiary = nil
	inventory.visible = false
	inventory.itemsloot = {}
	inventory.items = {}
	inventory.helmet = nil
	inventory.armor = nil
	inventory.backpack = nil
	showCursor(false)
	showChat(true)
	
	for i = 1, #inventory.foodLabel do
		guiSetEnabled(inventory.foodLabel[i], false)
	end
	for i = 1, #inventory.medicationLabel do
		guiSetEnabled(inventory.medicationLabel[i], false)
	end
end

function inventoryUpdate()
	inventory.primary = getElementData(localPlayer, "PRIMARY_Weapon")
	inventory.secondary = getElementData(localPlayer, "SECONDARY_Weapon")
	inventory.tertiary = getElementData(localPlayer, "SPECIAL_Weapon")
	inventory.backpack = getElementData(localPlayer, "backpack")
	inventory.armor = getElementData(localPlayer, "kevlar")
	inventory.helmet = getElementData(localPlayer, "helmet")
	inventory.itemsloot = {}
	inventory.items = {}
	inventory.foodItems = {}
	inventory.medicalItems = {}
	inventory.attachedItemOnCursor = nil
	
	clearItemBox(inventory.boxItem)
	clearItemBox(inventory.boxItemLoot)
	
	if (not inventory.primary or inventory.gearTableConfig[inventory.primary] == nil) then inventory.primary = nil end
	if (not inventory.secondary or inventory.gearTableConfig[inventory.secondary] == nil) then inventory.secondary = nil end
	if (not inventory.tertiary or inventory.gearTableConfig[inventory.tertiary] == nil) then inventory.tertiary = nil end
	
	for index, value in ipairs(gearTable["Primary Weapons"]) do
		if getElementData(localPlayer, value[1]) and getElementData(localPlayer, value[1]) > 0 then
			table.insert(inventory.items, value[1])
		end
		if isElement(inventory.vicinity) then
			if getElementData(inventory.vicinity, value[1]) and getElementData(inventory.vicinity, value[1]) > 0 then
				table.insert(inventory.itemsloot, value[1])
			end
		end
	end
	for index, value in ipairs(gearTable["Secondary Weapons"]) do
		if getElementData(localPlayer, value[1]) and getElementData(localPlayer, value[1]) > 0 then
			table.insert(inventory.items, value[1])
		end
		if isElement(inventory.vicinity) then
			if getElementData(inventory.vicinity, value[1]) and getElementData(inventory.vicinity, value[1]) > 0 then
				table.insert(inventory.itemsloot, value[1])
			end
		end
	end
	for index, value in ipairs(gearTable["Ammo"]) do
		if getElementData(localPlayer, value[1]) and getElementData(localPlayer, value[1]) > 0 then
			table.insert(inventory.items, value[1])
		end
		if isElement(inventory.vicinity) then
			if getElementData(inventory.vicinity, value[1]) and getElementData(inventory.vicinity, value[1]) > 0 then
				table.insert(inventory.itemsloot, value[1])
			end
		end
	end
	for index, value in ipairs(gearTable["Specially Weapons"]) do
		if getElementData(localPlayer, value[1]) and getElementData(localPlayer, value[1]) > 0 then
			table.insert(inventory.items, value[1])
		end
		if isElement(inventory.vicinity) then
			if getElementData(inventory.vicinity, value[1]) and getElementData(inventory.vicinity, value[1]) > 0 then
				table.insert(inventory.itemsloot, value[1])
			end
		end
	end
	for index, value in ipairs(gearTable["Medical"]) do
		if getElementData(localPlayer, value[1]) and getElementData(localPlayer, value[1]) > 0 then
			table.insert(inventory.items, value[1])
			table.insert(inventory.medicalItems, value[1])
		end
		if isElement(inventory.vicinity) then
			if getElementData(inventory.vicinity, value[1]) and getElementData(inventory.vicinity, value[1]) > 0 then
				table.insert(inventory.itemsloot, value[1])
			end
		end
	end
	for index, value in ipairs(gearTable["Backpacks"]) do
		if getElementData(localPlayer, value[1]) and getElementData(localPlayer, value[1]) > 0 then
			table.insert(inventory.items, value[1])
		end
		if isElement(inventory.vicinity) then
			if getElementData(inventory.vicinity, value[1]) and getElementData(inventory.vicinity, value[1]) > 0 then
				table.insert(inventory.itemsloot, value[1])
			end
		end
	end
	for index, value in ipairs(gearTable["Shields"]) do
		if getElementData(localPlayer, value[1]) and getElementData(localPlayer, value[1]) > 0 then
			table.insert(inventory.items, value[1])
		end
		if isElement(inventory.vicinity) then
			if getElementData(inventory.vicinity, value[1]) and getElementData(inventory.vicinity, value[1]) > 0 then
				table.insert(inventory.itemsloot, value[1])
			end
		end
	end
	for index, value in ipairs(gearTable["Nutrition"]) do
		if getElementData(localPlayer, value[1]) and getElementData(localPlayer, value[1]) > 0 then
			table.insert(inventory.items, value[1])
			table.insert(inventory.foodItems, value[1])
		end
		if isElement(inventory.vicinity) then
			if getElementData(inventory.vicinity, value[1]) and getElementData(inventory.vicinity, value[1]) > 0 then
				table.insert(inventory.itemsloot, value[1])
			end
		end
	end
	for index, value in ipairs(gearTable["Toolbelt"]) do
		if getElementData(localPlayer, value[1]) and getElementData(localPlayer, value[1]) > 0 then
			table.insert(inventory.items, value[1])
		end
		if isElement(inventory.vicinity) then
			if getElementData(inventory.vicinity, value[1]) and getElementData(inventory.vicinity, value[1]) > 0 then
				table.insert(inventory.itemsloot, value[1])
			end
		end
	end
	for index, value in ipairs(gearTable["Others"]) do
		if getElementData(localPlayer, value[1]) and getElementData(localPlayer, value[1]) > 0 then
			table.insert(inventory.items, value[1])
		end
		if isElement(inventory.vicinity) then
			if getElementData(inventory.vicinity, value[1]) and getElementData(inventory.vicinity, value[1]) > 0 then
				table.insert(inventory.itemsloot, value[1])
			end
		end
	end

	for i = 1, #inventory.items do
		addItemIntoBox(inventory.boxItem, inventory.items[i])
	end

	setElementData(localPlayer, "CURRENT_Slots", getElementCurrentSlots(localPlayer))
	
	if isElement(inventory.vicinity) then
		for i = 1, #inventory.itemsloot do
			addItemIntoBox(inventory.boxItemLoot, inventory.itemsloot[i])
		end

		setElementData(inventory.vicinity, "CURRENT_Slots", getElementCurrentSlots(inventory.vicinity))
	end
end
addEvent("onClientInventoryUpdate", true)
addEventHandler("onClientInventoryUpdate", root, inventoryUpdate)

function displayInventoryUI()
	-- # Equipment
	dxDrawBorderedRectangle(centerX + 157, centerY - 280, 232, 20, 1, {100, 100, 100, 225}, false)
	dxDrawBorderedRectangle(centerX + 157, centerY - 258, 232, 67, 1, {100, 100, 100, 125}, false)
	dxDrawText(string.upper(inventory.header1), centerX + 162, centerY - 280, centerX + 157 + 232, centerY - 280 + 22, tocolor(255, 255, 255, 200), 1.00, fontTable[4], "left", "center", true)

	dxDrawBorderedRectangle(centerX + 159, centerY - 256, 30, 30, 1, {255, 255, 255, 25}, false) -- Backpack background
	dxDrawBorderedRectangle(centerX + 192, centerY - 256, 30, 30, 1, {255, 255, 255, 25}, false) -- GPS background
	dxDrawBorderedRectangle(centerX + 225, centerY - 256, 30, 30, 1, {255, 255, 255, 25}, false) -- Map background
	dxDrawBorderedRectangle(centerX + 258, centerY - 256, 30, 30, 1, {255, 255, 255, 25}, false) -- Bússola background
	dxDrawBorderedRectangle(centerX + 291, centerY - 256, 30, 30, 1, {255, 255, 255, 25}, false) -- Infrared goggles background
	dxDrawBorderedRectangle(centerX + 324, centerY - 256, 30, 30, 1, {255, 255, 255, 25}, false) -- Night vision goggles
	dxDrawBorderedRectangle(centerX + 159, centerY - 223, 30, 30, 1, {255, 255, 255, 25}, false) -- Helmet background
	dxDrawBorderedRectangle(centerX + 192, centerY - 223, 30, 30, 1, {255, 255, 255, 25}, false) -- Armor background
	dxDrawBorderedRectangle(centerX + 225, centerY - 223, 30, 30, 1, {255, 255, 255, 25}, false)
	dxDrawBorderedRectangle(centerX + 258, centerY - 223, 30, 30, 1, {255, 255, 255, 25}, false)
	dxDrawBorderedRectangle(centerX + 291, centerY - 223, 30, 30, 1, {255, 255, 255, 25}, false)
	dxDrawBorderedRectangle(centerX + 324, centerY - 223, 30, 30, 1, {255, 255, 255, 25}, false)

	if inventory.backpack then
		for _, backpackData in ipairs(gameplayVariables["backpack_table"]) do
			if inventory.backpack == backpackData[3] then
				if isMouseOnPosition(centerX + 159, centerY - 256, 30, 30) then
					dxDrawRectangle(centerX + 159, centerY - 256, 30, 30, tocolor(255, 0, 0, 50), false)
				end
				dxDrawImage(centerX + 159, centerY - 256, 30, 30, inventory.filepathIcon .. inventory.gearTableConfig[ backpackData[4] ]["icon"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
			end
		end
	else
		dxDrawImage(centerX + 159, centerY - 256, 30, 30, inventory.filepathUI.."empty_backpack.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end	
	
	if getElementData(localPlayer, "GPS") and getElementData(localPlayer, "GPS") > 0 then
		dxDrawImage(centerX + 192, centerY - 256, 30, 30, inventory.filepathIcon.."gps.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	else
		dxDrawImage(centerX + 192, centerY - 256, 30, 30, inventory.filepathUI.."empty_gps.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end
	
	if getElementData(localPlayer, "Mapa") and getElementData(localPlayer, "Mapa") > 0 then
		dxDrawImage(centerX + 225, centerY - 256, 30, 30, inventory.filepathIcon.."map.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	else
		dxDrawImage(centerX + 225, centerY - 256, 30, 30, inventory.filepathUI.."empty_map.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end
	
	if getElementData(localPlayer, "Bússola") and getElementData(localPlayer, "Bússola") > 0 then
		dxDrawImage(centerX + 258, centerY - 256, 30, 30, inventory.filepathIcon.."compass.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	else
		dxDrawImage(centerX + 258, centerY - 256, 30, 30, inventory.filepathUI.."empty_compass.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end

	if getElementData(localPlayer, "Óculos de Visão Termal") and getElementData(localPlayer, "Óculos de Visão Termal") > 0 then
		dxDrawImage(centerX + 291, centerY - 256, 30, 30, inventory.filepathIcon.."nvgoggles.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	else
		dxDrawImage(centerX + 291, centerY - 256, 30, 30, inventory.filepathUI.."empty_goggles.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end

	if getElementData(localPlayer, "Óculos de Visão Noturna") and getElementData(localPlayer, "Óculos de Visão Noturna") > 0 then
		dxDrawImage(centerX + 324, centerY - 256, 30, 30, inventory.filepathIcon.."nvgoggles.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	else
		dxDrawImage(centerX + 324, centerY - 256, 30, 30, inventory.filepathUI.."empty_goggles.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end

	if inventory.helmet then
		for _, helmetData in ipairs(gameplayVariables["helmet_table"]) do
			if inventory.helmet == helmetData[2] then
				if isMouseOnPosition(centerX + 159, centerY - 223, 30, 30) then
					dxDrawRectangle(centerX + 159, centerY - 223, 30, 30, tocolor(255, 0, 0, 50), false)
				end
				dxDrawImage(centerX + 159, centerY - 223, 30, 30, inventory.filepathIcon .. inventory.gearTableConfig[ helmetData[3] ]["icon"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
			end
		end	
	else
		dxDrawImage(centerX + 159, centerY - 223, 30, 30, inventory.filepathUI.."empty_helmet.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end

	if inventory.armor then
		for _, armorData in ipairs(gameplayVariables["armor_table"]) do
			if inventory.armor == armorData[2] then
				if isMouseOnPosition(centerX + 192, centerY - 223, 30, 30) then
					dxDrawRectangle(centerX + 192, centerY - 223, 30, 30, tocolor(255, 0, 0, 50), false)
				end
				dxDrawImage(centerX + 192, centerY - 223, 30, 30, inventory.filepathIcon .. inventory.gearTableConfig[ armorData[3] ]["icon"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
			end
		end	
	else
		dxDrawImage(centerX + 192, centerY - 223, 30, 30, inventory.filepathUI.."empty_armor.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end
	
	if inventory.tertiary then
		if isMouseOnPosition(centerX + 225, centerY - 223, 30, 30) then
			dxDrawRectangle(centerX + 225, centerY - 223, 30, 30, tocolor(255, 0, 0, 50), false)
		end
		local icon = inventory.gearTableConfig[inventory.tertiary]["icon"]
		dxDrawImage(centerX + 225, centerY - 223, 30, 30, inventory.filepathIcon..icon, 0, 0, 0, tocolor(255, 255, 255, 255), false)
	else
		dxDrawImage(centerX + 225, centerY - 223, 30, 30, inventory.filepathUI.."empty_tertiary.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end	

	-- # Primary
	dxDrawBorderedRectangle(centerX + 157, centerY - 186, 232, 15, 1, {100, 100, 100, 225}, false)
	dxDrawBorderedRectangle(centerX + 157, centerY - 170, 232, 87, 1, {100, 100, 100, 125}, false)
	dxDrawText(string.upper(inventory.header2), centerX + 162, centerY - 186, centerX + 157 + 232, centerY - 186 + 17, tocolor(255, 255, 255, 200), 1.00, fontTable[5], "left", "center", true)

	if inventory.primary then
		local icon = inventory.gearTableConfig[inventory.primary]["icon"]
		dxDrawImage(centerX + 195, centerY - 165, 156, 78, inventory.filepathIcon..icon, 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawImage(centerX + 159, centerY - 168, 20, 30, "images/inventory/ui/arrow_down.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	else
		dxDrawImage(centerX + 195, centerY - 165, 156, 78, inventory.filepathUI.."empty_primary.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end
	
	-- # Secondary
	dxDrawBorderedRectangle(centerX + 157, centerY - 78, 232, 15, 1, {100, 100, 100, 225}, false)
	dxDrawBorderedRectangle(centerX + 157, centerY - 62, 232, 87, 1, {100, 100, 100, 125}, false)
	dxDrawText(string.upper(inventory.header3), centerX + 162, centerY - 78, centerX + 157 + 232, centerY - 78 + 17, tocolor(255, 255, 255, 200), 1.00, fontTable[5], "left", "center", true)

	if inventory.secondary then
		local icon = inventory.gearTableConfig[inventory.secondary]["icon"]
		local width = inventory.gearTableConfig[inventory.secondary]["width"]
		
		dxDrawImage(centerX + 159, centerY - 60, 20, 30, "images/inventory/ui/arrow_down.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		
		if width == 38 then
			dxDrawImage(centerX + 233, centerY - 60, 78, 78, inventory.filepathIcon..icon, 0, 0, 0, tocolor(255, 255, 255, 255), false)
		else
			dxDrawImage(centerX + 194, centerY - 60, 156, 78, inventory.filepathIcon..icon, 0, 0, 0, tocolor(255, 255, 255, 255), false)
		end
	else
		dxDrawImage(centerX + 233, centerY - 60, 78, 78, inventory.filepathUI.."empty_secondary.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end
	
	-- # Food/Drinks
	dxDrawBorderedRectangle(centerX + 157, centerY + 30, 232, 15, 1, {100, 100, 100, 225}, false)
	dxDrawBorderedRectangle(centerX + 157, centerY + 46, 232, 67, 1, {100, 100, 100, 125}, false)
	dxDrawText(string.upper(inventory.header4), centerX + 162, centerY + 30, centerX + 157 + 232, centerY + 30 + 17, tocolor(255, 255, 255, 200), 1.00, fontTable[5], "left", "center", true)

	local oX = 0
	local oY = 0
	for i = 1, 12 do
		if inventory.foodItems[i] and (getElementData(localPlayer, inventory.foodItems[i]) or 0) > 0 then
			local icon = inventory.gearTableConfig[ inventory.foodItems[i] ]["icon"]
			if isMouseOnPosition(centerX + 157 + 2 + oX, (centerY + 46 + 2) + oY, 30, 30) then
				dxDrawBorderedRectangle(centerX + 157 + 2 + oX, (centerY + 46 + 2) + oY, 30, 30, 1, {150, 200, 150, 125}, false)
			else
				dxDrawBorderedRectangle(centerX + 157 + 2 + oX, (centerY + 46 + 2) + oY, 30, 30, 1, {150, 150, 150, 125}, false)
			end
			dxDrawImage(centerX + 157 + 2 + oX, (centerY + 46 + 2) + oY, 30, 30, inventory.filepathIcon..icon, 0, 0, 0, tocolor(255, 255, 255, 255), false)
			dxDrawText(getElementData(localPlayer, inventory.foodItems[i]), centerX + 157 + 3 + oX, (centerY + 51 + 3) + oY, centerX + 157 + 3 + oX + 30, (centerY + 51 + 3) + oY + 30, tocolor(0, 0, 0, 200), 1.00, fontTable[3], "right", "bottom", true)
			dxDrawText(getElementData(localPlayer, inventory.foodItems[i]), centerX + 157 + 2 + oX, (centerY + 51 + 2) + oY, centerX + 157 + 2 + oX + 30, (centerY + 51 + 2) + oY + 30, tocolor(255, 255, 255, 200), 1.00, fontTable[3], "right", "bottom", true)
		else
			dxDrawBorderedRectangle(centerX + 157 + 2 + oX, (centerY + 46 + 2) + oY, 30, 30, 1, {255, 255, 255, 25}, false)
		end

		oX = oX + 31 + 2
		if (i % 6 == 0) then
			oX = 0
			oY = oY + 31 + 2
		end
	end

	-- # Medical Items
	dxDrawBorderedRectangle(centerX + 157, centerY + 118, 232, 15, 1, {100, 100, 100, 225}, false)
	dxDrawBorderedRectangle(centerX + 157, centerY + 134, 232, 67, 1, {100, 100, 100, 125}, false)
	dxDrawText(string.upper(inventory.header5), centerX + 162, centerY + 118, centerX + 157 + 232, centerY + 118 + 17, tocolor(255, 255, 255, 200), 1.00, fontTable[5], "left", "center", true)

	local oX = 0
	local oY = 0
	for i = 1, 12 do
		if inventory.medicalItems[i] and (getElementData(localPlayer, inventory.medicalItems[i]) or 0) > 0 then
			local icon = inventory.gearTableConfig[ inventory.medicalItems[i] ]["icon"]
			if isMouseOnPosition(centerX + 157 + 2 + oX, (centerY + 134 + 2) + oY, 30, 30) then
				dxDrawBorderedRectangle(centerX + 157 + 2 + oX, (centerY + 134 + 2) + oY, 30, 30, 1, {150, 200, 150, 125}, false)
			else
				dxDrawBorderedRectangle(centerX + 157 + 2 + oX, (centerY + 134 + 2) + oY, 30, 30, 1, {150, 150, 150, 125}, false)
			end
			dxDrawImage(centerX + 157 + 2 + oX, (centerY + 134 + 2) + oY, 30, 30, inventory.filepathIcon..icon, 0, 0, 0, tocolor(255, 255, 255, 255), false)
			dxDrawText(getElementData(localPlayer, inventory.medicalItems[i]), centerX + 157 + 3 + oX, (centerY + 139 + 3) + oY, centerX + 157 + 3 + oX + 30, (centerY + 139 + 3) + oY + 30, tocolor(0, 0, 0, 200), 1.00, fontTable[3], "right", "bottom", true)
			dxDrawText(getElementData(localPlayer, inventory.medicalItems[i]), centerX + 157 + 2 + oX, (centerY + 139 + 2) + oY, centerX + 157 + 2 + oX + 30, (centerY + 139 + 2) + oY + 30, tocolor(255, 255, 255, 200), 1.00, fontTable[3], "right", "bottom", true)
		else
			dxDrawBorderedRectangle(centerX + 157 + 2 + oX, (centerY + 134 + 2) + oY, 30, 30, 1, {255, 255, 255, 25}, false)
		end

		oX = oX + 31 + 2
		if (i % 6 == 0) then
			oX = 0
			oY = oY + 31 + 2
		end
	end

	-- # Player Items
	dxDrawBorderedRectangle(centerX - 80, centerY - 280, 232, 20, 1, {100, 100, 100, 225}, false)
	dxDrawText(string.upper(inventory.header6), centerX - 75, centerY - 279, centerX - 80 + 232, centerY - 279 + 20, tocolor(255, 255, 255, 200), 1.00, fontTable[4], "left", "center", true)

	local slots = math.floor(getElementData(localPlayer, "CURRENT_Slots") or 0) .. "/" .. getElementData(localPlayer, "MAX_Slots") or 0
	dxDrawText(slots, centerX - 75, centerY - 300, centerX - 85 + 232, centerY - 300 + 20, tocolor(255, 255, 255, 255), 1.00, "default", "right", "center", true)

	--# Loot Items
	if isElement(inventory.vicinity) then
		dxDrawBorderedRectangle(centerX - 317, centerY - 280, 232, 20, 1, {100, 100, 100, 225}, false)
		dxDrawText(string.upper(inventory.gearName), centerX - 312, centerY - 279, centerX - 317 + 232, centerY - 279 + 20, tocolor(255, 255, 255, 200), 1.00, fontTable[4], "left", "center", true)

		local slots = math.floor(getElementData(inventory.vicinity, "CURRENT_Slots") or 0) .. "/" .. getElementData(inventory.vicinity, "MAX_Slots") or 0
		dxDrawText(slots, centerX - 312, centerY - 300, centerX - 312 + 222, centerY - 300 + 20, tocolor(255, 255, 255, 255), 1.00, "default", "right", "center", true)
	end
	
	--# Info Item
	local item = getRowBoxCursorHover(inventory.boxItem) or getRowBoxCursorHover(inventory.boxItemLoot)
	dxDrawBorderedRectangle(centerX - 80, centerY + 118, 232, 15, 1, {100, 100, 100, 225}, false)
	dxDrawBorderedRectangle(centerX - 80, centerY + 134, 232, 67, 1, {100, 100, 100, 125}, false)
	
	if item then
		dxDrawText((getFormItemInventory(item)["newName"]), centerX - 80, centerY + 118, centerX - 80 + 232, centerY + 118 + 17, tocolor(255, 255, 255, 200), 1.00, fontTable[5], "left", "center", true)
		dxDrawText(getFormItemInventory(item)["description"], centerX - 79, centerY + 133, centerX - 80 + 230, centerY + 134 + 65, tocolor(255, 255, 255, 200), 1.00, "default", "left", "top", true, true)
	end
	
	if inventory.attachedItemOnCursor then
		local cursorX, cursorY = _getCursorPosition()
		local icon = getFormItemInventory(inventory.attachedItemOnCursor)["icon"]
		local width, height = getFormItemInventory(inventory.attachedItemOnCursor)["width"] + 10, getFormItemInventory(inventory.attachedItemOnCursor)["height"] + 10
		dxDrawBorderedRectangle(cursorX - width/2, cursorY - height/2, width, height, 1, {50, 50, 50, 50}, false)
		dxDrawImage(cursorX - width/2, cursorY - height/2, width, height, inventory.filepathIcon..icon, 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end
	
end

function drawHotBar()
	if getElementData(localPlayer, "Logged") and not getElementData(localPlayer, "dead") and not isMapOpened() then
		local Ox, sep, size, alpha = 0, 4, 48, (inventory.visible == true and 200) or 75
		for i = 1, 6 do
			dxDrawBorderedRectangle(centerX + Ox - (3 * size), screenH - size - sep, size, size, 1, {50, 50, 50, alpha}, false)

			if inventory.attachedItemOnCursor and hotBarItems[inventory.attachedItemOnCursor] then 
				dxDrawBorderedRectangle(centerX + Ox - (3 * size), screenH - size - sep, size, size, 1, {0, 240, 0, 25}, false)
			end
			
			if inventory.visible then
				dxDrawText(string.upper(inventory.header8), centerX, screenH - size - sep - 25, centerX + 1, screenH - size - sep - 25, tocolor(255, 255, 255, 200), 1.00, fontTable[5], "center", "top", false)
			end
			
			if inventory.hotBarTable[i] then
				local icon = getFormItemInventory(inventory.hotBarTable[i])["icon"]
				local width = getFormItemInventory(inventory.hotBarTable[i])["width"]
				if width == 76 then
					dxDrawImage(centerX + Ox - (3 * size), (screenH - size - sep) + size/2 - 12, size, size/2, inventory.filepathIcon..icon, 0, 0, 0, tocolor(255, 255, 255, alpha), false)
				else
					dxDrawImage(centerX + Ox - (3 * size), screenH - size - sep, size, size, inventory.filepathIcon..icon, 0, 0, 0, tocolor(255, 255, 255, alpha), false)
				end
			end
			
			dxDrawText(tostring(i), centerX + Ox - (3 * size), screenH - size - sep, centerX + Ox - (3 * size) + size, screenH - sep, tocolor(255, 255, 255, alpha), 1, "arial", "right", "bottom", true)
			Ox = Ox + size + sep
		end
	end
end
addEventHandler("onClientRender", root, drawHotBar, true ,"low-5")

function clickElement(item, _type)
	if _type == 1 and source == localPlayer then
		requestUseItem(item)
	elseif _type == 2 and source == localPlayer then
		inventory.attachedItemOnCursor = item
	elseif _type == 3 then
		if source == localPlayer then
			if isBackpackItem(item) then
				local dataName, _ = getBackpackNameByMaxSlots(getBackpackMaxSlots(item))
				if inventory.backpack == dataName then
					if (getElementData(localPlayer, item) > 1) then
						if itemCheck() then
							if isElement(inventory.vicinity) then
								movePlayerItemInLoot(item, inventory.vicinity)
							else
								moveItemOutOfInventory(item)
							end
						end
					else
						if (getElementData(localPlayer, "CURRENT_Slots") <= gameplayVariables["MAX_Inventory_Slots"]) then
							if itemCheck() then
								if isElement(inventory.vicinity) then
									movePlayerItemInLoot(item, inventory.vicinity)
								else
									moveItemOutOfInventory(item)
								end
								if (getElementData(localPlayer, item) <= 0) then
									setElementData(localPlayer, "backpack", nil)
									inventory.backpack = nil
								end								
							end
						else
							triggerEvent("displayClientInfo", localPlayer, "Inventário Cheio", {255, 0, 0})
						end
					end
				else
					if itemCheck() then
						if isElement(inventory.vicinity) then
							movePlayerItemInLoot(item, inventory.vicinity)
						else
							moveItemOutOfInventory(item)
						end
					end
				end
			else
				if itemCheck() then
					if isElement(inventory.vicinity) then
						movePlayerItemInLoot(item, inventory.vicinity)
					else
						moveItemOutOfInventory(item)
					end

					if (inventory.primary and inventory.primary == item) and (getElementData(localPlayer, item) <= 0) then
						setElementData(localPlayer, "PRIMARY_Weapon", nil)
						inventory.primary = nil
					elseif (inventory.secondary and inventory.secondary == item) and (getElementData(localPlayer, item) <= 0) then
						setElementData(localPlayer, "SECONDARY_Weapon", nil)
						inventory.secondary = nil
					elseif (inventory.tertiary and inventory.tertiary == item) and (getElementData(localPlayer, item) <= 0)then
						setElementData(localPlayer, "SPECIAL_Weapon", nil)
						inventory.tertiary = nil
					end
					if inventory.armor and (inventory.armor == "Civil" and item == "Chaleco civil") or (inventory.armor == "Basic" and item == "Chaleco basico") or (inventory.armor == "War" and item == "Chaleco de guerra") or (inventory.armor == "Police" and item == "Chaleco de policia") then
						if (getElementData(localPlayer, item) <= 0) then
							setElementData(localPlayer, "kevlar", nil)
						end
					elseif inventory.helmet and (inventory.helmet == "Moto" and item == "Chaleco de moto") or (inventory.helmet == "Basic" and item == "Casco basico") or (inventory.helmet == "War" and item == "Casco de guerra") or (inventory.helmet == "Aviator" and item == "Casco de aviador") then
						if (getElementData(localPlayer, item) <= 0) then
							setElementData(localPlayer, "helmet", nil)
						end
					end
				end
			end
		else
			if isElement(inventory.vicinity) and itemCheck() then
				moveItemLootInInventory(item, inventory.vicinity)
			end
		end
	end
end
addEvent("onClientClickItem", true)
addEventHandler("onClientClickItem", root, clickElement)

function unclickLargeRow(item)
	if source == localPlayer then
		if hotBarItems[inventory.attachedItemOnCursor] then
			local Ox, sep, size = 0, 4, 48
			for i = 1, 6 do
				if isMouseOnPosition(centerX + Ox - (3 * size), screenH - size - sep, size, size) then
					removeItemOnHotBar(inventory.attachedItemOnCursor)
					inventory.hotBarTable[i] = inventory.attachedItemOnCursor
					break
				end
				Ox = Ox + size + sep
			end
		end
	end
	inventory.attachedItemOnCursor = nil
end
addEvent("onClientUnclickItem", true)
addEventHandler("onClientUnclickItem", root, unclickLargeRow)

function hotBarKey(key)
	local n = tonumber(key)
	if inventory.hotBarTable[n] and not inventory.locked and getElementData(localPlayer, "Logged") and not getElementData(localPlayer, "dead") then
		requestUseItem(inventory.hotBarTable[n])
	end
end

function leftClickItem()
	if source == inventory.primaryWeapLabel then
		if inventory.primary then
			triggerServerEvent("onPlayerWeaponRemove", localPlayer, inventory.primary)
			setElementData(localPlayer, "PRIMARY_Weapon", nil)
			inventory.primary = nil
		end
	elseif source == inventory.secondaryWeapLabel then
		if inventory.secondary then
			triggerServerEvent("onPlayerWeaponRemove", localPlayer, inventory.secondary)
			setElementData(localPlayer, "SECONDARY_Weapon", nil)
			inventory.secondary = nil
		end
	elseif source == inventory.tertiaryWeapLabel then
		if inventory.tertiary then
			triggerServerEvent("onPlayerWeaponRemove", localPlayer, inventory.tertiary)
			setElementData(localPlayer, "SPECIAL_Weapon", nil)
			inventory.tertiary = nil
		end
	elseif source == inventory.backpackLabel then
		if inventory.backpack then
			local dataName, _ = getBackpackNameByMaxSlots(getBackpackMaxSlots(inventory.backpack))
			if inventory.backpack == dataName then
				if (getElementData(localPlayer, "CURRENT_Slots") <= gameplayVariables["MAX_Inventory_Slots"]) then
					setElementData(localPlayer, "backpack", nil)
					inventory.backpack = nil
				else
					triggerEvent("displayClientInfo", localPlayer, "Inventário Cheio", {255, 0, 0})
				end
			end
		end
	elseif source == inventory.helmetLabel then
		if inventory.helmet then
			setElementData(localPlayer, "helmet", nil)
			inventory.helmet = nil
		end
	elseif source == inventory.armorLabel then
		if inventory.armor then
			setElementData(localPlayer, "kevlar", nil)
			inventory.armor = nil
		end
	else
		local id = getElementData(source, "medicalLabelID")
		if id and inventory.medicalItems[id] then
			requestUseItem(inventory.medicalItems[id])
		end
		local id = getElementData(source, "foodLabelID")
		if id and inventory.foodItems[id] then
			requestUseItem(inventory.foodItems[id])
		end		
	end
end
addEventHandler("onClientGUIClick", resourceRoot, leftClickItem)

local isPlaceBuldingRender = false
local placeItemID = false

function requestUseItem(itemName)
	if not itemCheck() then
		return
	end
	-- # Backpacks.
	if isBackpackItem(itemName) then
		local slot = getBackpackMaxSlots(itemName)
		local name, item = getBackpackNameByMaxSlots(slot)

		if not inventory.backpack then
			setElementData(localPlayer, "backpack", name)
			inventory.backpack = name
		else
			local playerSlot = getElementData(localPlayer, "CURRENT_Slots") or 0
			if (playerSlot < slot) then
				setElementData(localPlayer, "backpack", name)
				inventory.backpack = name
			else
				triggerEvent("displayClientInfo", localPlayer, "Esta mochila es muy pequeña.", {255, 0, 0})
			end
		end
	end
	-- # Food/Drinks.
	if isNutritionItem(itemName) then
		useItem(itemName, getNutritionItemType(itemName))
	end
	-- # Food/Drinks.
	if itemName == "Guillie Suit" or itemName == "Survivor Suit" or itemName == "Police Suit" or itemName == "Veterano Suit" or itemName == "Camo Suit" then
		useItem(itemName, "cloth")
	end
	-- # Blood Bags.
	if string.find(itemName, "Bolsa de Sangue") then
		local theStr = string.gsub(itemName, "Bolsa de Sangue ", "")
		local bloodbagType = string.sub(theStr, 2, #theStr-1)
		local myBloodType = getElementData(localPlayer, "bloodType")
		--if getElementData(localPlayer, "Transfusor de Sangue") and getElementData(localPlayer, "Transfusor de Sangue") > 0 then
		--	if myBloodType and myBloodType == bloodbagType then
				if (getElementData(localPlayer, "blood") < 12000) then
					if (getElementData(localPlayer, "blood") + 4000 < 12000) then
						setElementData(localPlayer, "blood", getElementData(localPlayer, "blood") + 4000)
					else 
						setElementData(localPlayer, "blood", 12000)
					end
		
					setElementData(localPlayer, "Bolsa de Sangue ("..tostring(bloodbagType)..")", getElementData(localPlayer, "Bolsa de Sangue ("..tostring(bloodbagType)..")") - 1)	
					triggerEvent("displayClientInfo", localPlayer, "Transfusion realizada.", {0, 255, 0})

					if getElementData(localPlayer, "Bolsa de Sangue ("..tostring(bloodbagType)..")") <= 0 then
						removeItemFromInventory("Bolsa de Sangue ("..tostring(bloodbagType)..")")
					end
				else
					triggerEvent("displayClientInfo", localPlayer, "No puedes hacer mas transfusiones.", {255, 0, 0})
				end
			--else
				--triggerEvent("displayClientInfo", localPlayer, "Necesitas una bolsa de sangre de tipo "..tostring(bloodbagType)..".", {255, 0, 0})
			--end
		--else
			--triggerEvent("displayClientInfo", localPlayer, "No tienes un transfusor de sangre.", {255, 0, 0})
		--end
	end
	-- # Blood Transfusor.
	if itemName == "Transfusor de Sangue" then
		if (getElementData(localPlayer, "blood") - 4000 >= 4000) then
			local myBloodType = getElementData(localPlayer, "bloodType")
			setElementData(localPlayer, "Bolsa de Sangue ("..tostring(myBloodType)..")", (getElementData(localPlayer, "Bolsa de Sangue ("..tostring(myBloodType)..")") or 0) + 1)
			setElementData(localPlayer, "blood", getElementData(localPlayer, "blood") - 4000)
			triggerEvent("displayClientInfo", localPlayer, "Transfusion realizada.", {0, 255, 0})
			inventoryUpdate()
		else
			triggerEvent("displayClientInfo", localPlayer, "No puedes hacer mas transfusiones.", {255, 0, 0})
		end
	end
	-- # Steroids.
	if itemName == "Esteróides" then
		if not getElementData(localPlayer, "onRoids") then
			setGameSpeed(1.2)
			setElementData(localPlayer, "onRoids", true, false)			
			setElementData(localPlayer, "Esteróides", getElementData(localPlayer, "Esteróides") - 1)
			setElementData(localPlayer, "blood", getElementData(localPlayer, "blood") - 2000)
			triggerEvent("displayClientInfo", localPlayer, "Has usado esteroides.", {255, 255, 255})

			onRoidTimer = setTimer(function()
				setGameSpeed(1)
				setElementData(localPlayer, "onRoids", false, false)
			end, 30000, 1)

			if getElementData(localPlayer, "Esteróides") <= 0 then
				removeItemFromInventory(itemName)
			end
		end
	end
	-- # Armor/Helmet.
	local pType = isArmorItem(itemName)
	local dataName = getArmorItemName(itemName)
	if pType == "helmet" then
		if not inventory.helmet then
			setElementData(localPlayer, "helmet", dataName)
		else
			if inventory.helmet ~= dataName then
				setElementData(localPlayer, "helmet", dataName)
			end
		end
		inventory.helmet = dataName
	elseif pType == "armor" then
		if not inventory.armor then
			setElementData(localPlayer, "kevlar", dataName)
		else
			if inventory.armor ~= dataName then
				setElementData(localPlayer, "kevlar", dataName)
			end
		end
		inventory.armor = dataName
	end
	-- # Tents.
	if itemName == "Tienda basica" then
		removeBuildingForPlace()
		placeBuilding(itemName)
		placeItemID = "place_tent"
	end
	-- # Tramps.
	if itemName == "Armadilha para Urso" then
		removeBuildingForPlace()
		placeBuilding(itemName)
		placeItemID = "place_beartramp"
	end
	if itemName == "Mina" then
		removeBuildingForPlace()
		placeBuilding(itemName)
		placeItemID = "place_mine"
	end
	-- # Stuff
	if itemName == "Bengala" then
		useItem(itemName, "place_bengale")	
	end
	-- # Medication.
	if itemName == "Curativo" then
		if not getElementData(localPlayer, "bleeding") or getElementData(localPlayer, "bleeding") <= 0 then
			triggerEvent("displayClientInfo", localPlayer, "No estas sangrando.", {255, 0, 0})
			return
		end
		useItem(itemName, "medical")
	end
	if itemName == "Morfina" then
		if not getElementData(localPlayer, "brokenbone") or getElementData(localPlayer, "brokenbone") <= 0 then
			triggerEvent("displayClientInfo", localPlayer, "No tienes huesos rotos.", {255, 0, 0})
			return
		end
		useItem(itemName, "medical")
	end
	if itemName == "Analgésicos" then
		if not getElementData(localPlayer, "pain") or getElementData(localPlayer, "pain") <= 0 then
			triggerEvent("displayClientInfo", localPlayer, "No tienes dolores.", {255, 0, 0})
			return
		end
		useItem(itemName, "medical")
	end
	if itemName == "Kit de Primeiros Socorros" then
		if (getElementData(localPlayer, "blood") >= 12000) then
			return
		end
		useItem(itemName, "medical")
	end
	if itemName == "Bolsa Térmica" then
		if not getElementData(localPlayer, "cold") or getElementData(localPlayer, "cold") <= 0 then
			triggerEvent("displayClientInfo", localPlayer, "No estas congelado.", {255, 0, 0})
			return
		end
		useItem(itemName, "medical")
	end
	if itemName == "Antibioticos" then
		if not getElementData(localPlayer, "infection") or getElementData(localPlayer, "infection") <= 0 then
			triggerEvent("displayClientInfo", localPlayer, "No estas infectado.", {255, 0, 0})
			return
		end
		useItem(itemName, "medical")
	end
	-- # Weapons.
	local slot = getWeaponSlot(itemName)
	if slot then
		local ammo = getWeaponAmmoName(itemName) or nil
		if ammo then
			local dataName
			if slot == 1 then
				dataName = "PRIMARY_Weapon"
			elseif slot == 2 then
				dataName = "SECONDARY_Weapon"
			elseif slot == 3 then
				dataName = "SPECIAL_Weapon"				
			end

			local current = getElementData(localPlayer, dataName)
			if current and current == itemName then
				return
			end
			
			if ammo == "Melee" then
				if slot == 1 then
					inventory.primary = itemName
				elseif slot == 2 then
					inventory.secondary = itemName
				elseif slot == 3 then
					inventory.tertiary = itemName					
				end
				
				triggerServerEvent("onPlayerRearmWeapon", localPlayer, itemName, ammo)
			else
				local data = getElementData(localPlayer, ammo) or 0
				if (data > 0) then
					if slot == 1 then
						inventory.primary = itemName
					elseif slot == 2 then
						inventory.secondary = itemName
					elseif slot == 3 then
						inventory.tertiary = itemName					
					end

					setSoundVolume(playSound("sounds/effects/weaponarm.wav", false), 0.5)
					triggerServerEvent("onPlayerRearmWeapon", localPlayer, itemName, ammo)
				else
					triggerEvent("displayClientInfo", localPlayer, "No tienes la municion de esta arma. ("..getItemName(ammo)..")", {255, 0, 0})
				end
			end
		end
	end
end

function requestRenderBuilding(state)
	if state then
		if not isPlaceBuldingRender then
			closeInventory()
			isPlaceBuldingRender = true
			bindKey("J", "down", cancelItemPlaceBuilding)
			bindKey("H", "down", applyItemPlaceBuilding)
			addEventHandler("onClientRender", root, displayUseAdvise)
		end
	else
		if isPlaceBuldingRender then
			placeItemID = false
			isPlaceBuldingRender = false
			removeEventHandler("onClientRender", root, displayUseAdvise)
		end
	end
end
addEvent("onPlayerStatusPlaceBuilding", true)
addEventHandler("onPlayerStatusPlaceBuilding", root, requestRenderBuilding)

function displayUseAdvise()
	dxDrawText("Pulsa 'H' para aplicar\nPulsa 'J' para cancelar", 0, centerY + 150, screenW, centerY + 230, tocolor(255, 255, 255, 200), 1.00, fontTable[6], "center", "center", true)
end

function applyItemPlaceBuilding()
	local x, y, z = getElementPosition(objPlacing)
	local _, _, rot = getElementRotation(objPlacing)

	if placeItemID == "place_tent" then
		local place = {x=x, y=y, z=z, rot=rot, tentdatatable=getElementData(objPlacing, "tentdata")}		
		playSound("sounds/effects/tentunpack.ogg")
		triggerServerEvent("onPlayerPlaceTent", localPlayer, place)
		
	elseif placeItemID == "place_beartramp" then
		local place = {x=x, y=y, z=z, rot=rot}
		triggerServerEvent("onPlayerBearTrampPlace", localPlayer, place)

	elseif placeItemID == "place_mine" then
		local place = {x=x, y=y, z=z, rot=rot}
		triggerServerEvent("onPlayerMinePlace", localPlayer, place)

	end	

	blockInventory(true)
	cancelItemPlaceBuilding()
end

function cancelItemPlaceBuilding()
	unbindKey("J", "down", cancelItemPlaceBuilding)
	unbindKey("H", "down", applyItemPlaceBuilding)
	removeBuildingForPlace()
	placeItemID = false
end

function closeInventoryOnWasted()
	if isTimer(onRoidTimer) then
		killTimer(onRoidTimer)
		onRoidTimer = nil
	end

	closeInventory()
	inventory.hotBarTable = {}

	if placeItemID then
		cancelItemPlaceBuilding()
	end
end
addEventHandler("onClientPlayerWasted", localPlayer, closeInventoryOnWasted)

function useItem(itemName, itemID)
	if getElementData(localPlayer, "prone") or getPedSimplestTask(localPlayer) == "TASK_SIMPLE_IN_AIR" then
		return
	end

	if itemID == "drink" and (getElementData(localPlayer, "thirst") < 100) then
		triggerServerEvent("onPlayerConsumeNutrition", localPlayer, itemName, itemID)
		playSound("sounds/effects/drink.ogg")
	elseif itemID == "eat" and (getElementData(localPlayer, "food") < 100) then
		triggerServerEvent("onPlayerConsumeNutrition", localPlayer, itemName, itemID)
		playSound("sounds/effects/eat.ogg")
	elseif itemID == "medical" then
		triggerServerEvent("onPlayerMedicalAttention", localPlayer, itemName, getItemName(itemName))
	elseif itemID == "cloth" then
		triggerServerEvent("onPlayerClothingUp", localPlayer, itemName)
	elseif itemID == "place_bengale" then		
		local x, y, z = getElementPosition(localPlayer)
		local _, _, rot = getElementRotation(localPlayer)
		local px, py, pz = x + 1 * math.cos(math.rad(rot + 90)), y + 1 * math.sin(math.rad(rot + 90)), z - 1
		local place = {x=px, y=py, z=pz}
		triggerServerEvent("onPlayerBengalePlace", localPlayer, place)
		blockInventory(true)
	end
end

local timer = false
function itemCheck()
	if isTimer(timer) then
		return false
	end
	timer = setTimer(function() timer = false end, 200, 1)
	return true
end

function removeItemOnHotBar(item)
	for i = 1, 6 do
		if inventory.hotBarTable[i] and inventory.hotBarTable[i] == item then
			inventory.hotBarTable[i] = nil
		end
	end
end

function removeItemFromLoot(itemName)
	for i, v in ipairs(inventory.itemsloot) do
		if v == itemName then
			table.remove(inventory.itemsloot, i)
		end
	end
	
	removeItemIntoBox(inventory.boxItemLoot, itemName)
	
	if isElement(inventory.vicinity) then
		setElementData(inventory.vicinity, "CURRENT_Slots", getElementCurrentSlots(inventory.vicinity))
	end
end

function removeItemFromInventory(itemName)
	for i, v in ipairs(inventory.items) do
		if v == itemName then
			table.remove(inventory.items, i)
		end
	end
	for i, v in ipairs(inventory.foodItems) do
		if v == itemName then
			table.remove(inventory.foodItems, i)
		end
	end
	for i, v in ipairs(inventory.medicalItems) do
		if v == itemName then
			table.remove(inventory.medicalItems, i)
		end
	end
	
	removeItemOnHotBar(itemName)
	removeItemIntoBox(inventory.boxItem, itemName)
	setElementData(localPlayer, "CURRENT_Slots", getElementCurrentSlots(localPlayer))
end
addEvent("onClientRemoveItemFromInventory", true)
addEventHandler("onClientRemoveItemFromInventory", root, removeItemFromInventory)

function isThisItemInBox(itemName)
	if not getElementData(localPlayer, itemName) or (getElementData(localPlayer, itemName) <= 0) then
		local lootBox = getElementData(localPlayer, "itemBox")
		addItemIntoBox(lootBox, itemName)
	end
end
addEvent("onClientHasItemBox", true)
addEventHandler("onClientHasItemBox", root, isThisItemInBox)

function loadDataFromGearTable()
	for key, val in pairs(gearTable) do
		for index, conf in ipairs(val) do
			local itemName = conf[1]
			inventory.gearTableConfig[itemName] = {icon = conf[2], width = conf[3], height = conf[4], description = conf[5], newName = conf[6]}
		end
	end
	
	inventory.foodLabel = {}
	inventory.medicationLabel = {}

	-- Load food label.
	local oX = 0
	local oY = 0
	for i = 1, 12 do
		inventory.foodLabel[i] = guiCreateLabel(centerX + 157 + 2 + oX, (centerY + 46 + 2) + oY, 30, 30, "", false)
		setElementData(inventory.foodLabel[i], "foodLabelID", i, false)
		guiSetEnabled(inventory.foodLabel[i], false)
		oX = oX + 31 + 2
		if (i % 6 == 0) then
			oX = 0
			oY = oY + 31 + 2
		end
	end
	-- Load medical label.
	local oX = 0
	local oY = 0
	for i = 1, 12 do
		inventory.medicationLabel[i] = guiCreateLabel(centerX + 157 + 2 + oX, (centerY + 134 + 2) + oY, 30, 30, "", false)
		setElementData(inventory.medicationLabel[i], "medicalLabelID", i, false)
		guiSetEnabled(inventory.medicationLabel[i], false)
		oX = oX + 31 + 2
		if (i % 6 == 0) then
			oX = 0
			oY = oY + 31 + 2
		end
	end	
	-- Load other label.
	inventory.primaryWeapLabel = guiCreateLabel(centerX + 159, centerY - 168, 20, 30, "", false)
	inventory.secondaryWeapLabel = guiCreateLabel(centerX + 159, centerY - 60, 20, 30, "", false)
	inventory.tertiaryWeapLabel = guiCreateLabel(centerX + 225, centerY - 223, 30, 30, "", false)
	inventory.backpackLabel = guiCreateLabel(centerX + 159, centerY - 256, 30, 30, "", false)
	inventory.helmetLabel = guiCreateLabel(centerX + 159, centerY - 223, 30, 30, "", false)
	inventory.armorLabel = guiCreateLabel(centerX + 192, centerY - 223, 30, 30, "", false)
	guiSetEnabled(inventory.primaryWeapLabel, false)
	guiSetEnabled(inventory.secondaryWeapLabel, false)
	guiSetEnabled(inventory.tertiaryWeapLabel, false)
	guiSetEnabled(inventory.backpackLabel, false)
	guiSetEnabled(inventory.helmetLabel, false)
	guiSetEnabled(inventory.armorLabel, false)
	
	-- HotBar's key bounds
	for i = 1, 6 do
		bindKey(tostring(i), "down", hotBarKey)
	end
end

loadDataFromGearTable()

-- # SHARED FUNCTIONS % EXPORTS

function getFormItemInventory(itemName)
	return inventory.gearTableConfig[itemName] or nil
end

function isInventoryVisible()
	return inventory.visible
end

function isPlayerInLoot()
	if getElementData(localPlayer, "loot") then
		return getElementData(localPlayer, "currentCol")
	end
end

function dxDrawBorderedRectangle(x,y,w,h,border_size,color,postgui)
	if postgui == nil then postgui = true end
	local r, g, b, a = unpack(color)
	local r2 = math.max(0, math.min( r+20, 222))
	local g2 = math.max(0, math.min( g+20, 222))
	local b2 = math.max(0, math.min( b+20, 222))
	local a2 = math.max(0, math.min( a+20, 222))

	dxDrawRectangle(x, y, w, -border_size, tocolor(r2, g2, b2, a2), postgui)
	dxDrawRectangle(x, y+h, w, border_size, tocolor(r2, g2, b2, a2), postgui)
	dxDrawRectangle(x, y-border_size, -border_size, h+(border_size*2), tocolor(r2, g2, b2, a2), postgui)
	dxDrawRectangle(x+w, y-border_size, border_size, h+(border_size*2), tocolor(r2, g2, b2, a2), postgui)
	dxDrawRectangle(x, y, w, h, tocolor(r, g, b, a), postgui)
end

function blockInventory(state)
	if not state then
		inventory.locked = false
		addCommandHandler("Open Inventory", openCloseInventory)
		bindKey("J", "down", "Open Inventory")
	else
		closeInventory()
		inventory.locked = true
		unbindKey("J", "down", "Open Inventory", openCloseInventory)
	end
end

function unblockInventory()
	blockInventory(false)
end
addEvent("unblockInventory", true)
addEventHandler("unblockInventory", root, unblockInventory)