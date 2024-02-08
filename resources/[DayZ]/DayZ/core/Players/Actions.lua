local itemPlaceTimer = {}

function setClothing(itemName)
	local gender = getElementData(source, "gender")
	setPedAnimation(source, "BOMBER", "BOM_Plant", -1, false, false, nil, false)

	if itemName == "Traje Ghillie" then
		setElementModel(source, 7)
	elseif itemName == "Police Suit" then
		setElementModel(source, 40)	
	elseif itemName == "Veterano Suit" then
		setElementModel(source, 16)	
	elseif itemName == "Camo Suit" then
		setElementModel(source, 17)			
	elseif itemName == "Survivor Suit" then
		if gender == "male" then
			setElementModel(source, 0)
				
			local clothes = getAccountData(getPlayerAccount(source), "clothing")
			if clothes then
				for index = 0, 17 do
					local texture, model = getPedClothes(source, index)
					if texture and model then
						removePedClothes(source, index)
					end
				end			
			
				for _, clothing in ipairs(fromJSON(clothes) or {}) do
					local texture, clothemodel, index = clothing[1], clothing[2], clothing[3]
					addPedClothes(source, texture, clothemodel, index)
				end	
			end
		else
			setElementModel(source, 11)
		end
	end
end
addEvent("onPlayerClothingUp", true)
addEventHandler("onPlayerClothingUp", root, setClothing)

function addPlayerWeapon(weapon, ammo, switch)
	takeAllWeapons(source)

	if not switch then
		switch = false
	end
	
	local slot = getWeaponSlot(weapon)
	
	if slot == 1 then
		slot = "PRIMARY"
	elseif slot == 2 then
		slot = "SECONDARY"
	elseif slot == 3 then
		slot = "SPECIAL"
	end
	
	setElementData(source, tostring(slot).."_Weapon", weapon)

	for _, text in ipairs({"PRIMARY", "SECONDARY", "SPECIAL"}) do
		local val = getElementData(source, text.."_Weapon")
			
		if val then
			if getWeaponAmmoName(val) then
				local id = getIDFromWeaponName(val)
				local data = getElementData(source, getWeaponAmmoName(val))
				
				if getWeaponAmmoName(val) == "Melee" then
					giveWeapon(source, id, 1, switch)
				else
					if data and data > 0 then
						giveWeapon(source, id, data, switch)
					end
				end
			end
		end
	end
	
	updateWeaponBack(source)
end
addEvent("onPlayerRearmWeapon", true)
addEventHandler("onPlayerRearmWeapon", root, addPlayerWeapon)

function onWeaponOnDrop()
	takeAllWeapons(source)
	
	for _, text in ipairs({"PRIMARY", "SECONDARY", "SPECIAL"}) do
		local val = getElementData(source, text.."_Weapon")
			
		if val then
			local ammo = getWeaponAmmoName(val)
			local id = getIDFromWeaponName(val)
			local data = getElementData(source, ammo)
			
			if data and data > 0 then
				giveWeapon(source, id, data, false)
			else
				setElementData(source, text.."_Weapon", nil)
				triggerEvent("removeWeaponAttachedOnBack", source, getWeaponSlot(val))
			end
		end
	end
	
	triggerClientEvent(source, "onClientInventoryUpdate", source)
end
addEvent("onPlayerDropWeaponAmmo", true)
addEventHandler("onPlayerDropWeaponAmmo", root, onWeaponOnDrop)

function onWeaponPickup(cartidge, ammo)
	for _, text in ipairs({"PRIMARY", "SECONDARY", "SPECIAL"}) do
		local val = getElementData(source, text.."_Weapon")
			
		if val then
			local id = getIDFromWeaponName(val)
			local weapAmmo = getWeaponAmmoName(val)
			
			if weapAmmo and weapAmmo == cartidge then
				local data = getElementData(source, cartidge)
				
				if data and data > 0 then
					giveWeapon(source, id, ammo, false)
				end
			end
		end
	end
end
addEvent("onPlayerPickupWeaponAmmo", true)
addEventHandler("onPlayerPickupWeaponAmmo", root, onWeaponPickup)

function createItemOnGround(data)
	local weapon1 = getElementData(source, "PRIMARY_Weapon")
	local weapon2 = getElementData(source, "SECONDARY_Weapon")
	local weapon3 = getElementData(source, "SPECIAL_Weapon")
	local x, y, z, item, count = data.X, data.Y, data.Z, data.Item, data.Valor

	triggerEvent("Items:Crear", resourceRoot, data)
	--createPickupItem(item, x + math.random(-1, 1) * math.cos(math.rad(math.random(0, 360) + 90)), y + math.random(-1, 1) * math.sin(math.rad(math.random(0, 360) + 90)), z, count)

	-- Actualizar las armas si el item es una municion.
	if weapon1 then
		local ammo = getWeaponAmmoName(weapon1)
		if ammo and ammo == item then
			triggerEvent("onPlayerDropWeaponAmmo", source)
		end
	end
	if weapon2 then
		local ammo = getWeaponAmmoName(weapon2)
		if ammo and ammo == item then
			triggerEvent("onPlayerDropWeaponAmmo", source)
		end
	end
	if weapon3 then
		local ammo = getWeaponAmmoName(weapon3)
		if ammo and ammo == item then
			triggerEvent("onPlayerDropWeaponAmmo", source)
		end
	end
	
	triggerClientEvent(source, "onClientInventoryUpdate", source)
end
addEvent("onPlayerCreatePickupItem", true)
addEventHandler("onPlayerCreatePickupItem", root, createItemOnGround)

function pickupItemFromGround(col, item, amount)
	if isElement(col) then
		local currentSlot = getElementData(source, "CURRENT_Slots") or 0
		local maxSlot = getElementData(source, "MAX_Slots")
		local weapon1 = getElementData(source, "PRIMARY_Weapon")
		local weapon2 = getElementData(source, "SECONDARY_Weapon")
		local weapon3 = getElementData(source, "SPECIAL_Weapon")
		local itemPlus = 1 
		
		if item == "12 Gauge" then
			itemPlus = 12
		elseif item == "5.45x39mm" then
			itemPlus = 39
		elseif item == "5.56x45mm" then
			itemPlus = 45
		elseif item == "7.62x51mm" then
			itemPlus = 100
		elseif item == "7.62x54mm" then
			itemPlus = 54
		elseif item == "11.43x23mm" then
			itemPlus = 23
		elseif item == "1866 Slug" then
			itemPlus = 10
		elseif item == "9x18mm" then
			itemPlus = 18
		elseif item == "9x19mm" then
			itemPlus = 19
		elseif item == ".308 Winchester" then
			itemPlus = 14
		end

		if amount then
			itemPlus = amount
		end

		triggerClientEvent(source, "onClientInventoryUpdate", source)
		
		local object = getElementData(col, "parent")
		if currentSlot + getItemWeight(item) * itemPlus <= maxSlot then
			triggerEvent("destroyPickupItem", source, col)		
			setElementData(source, item, (getElementData(source, item) or 0) + itemPlus)
			
			-- Actualizar las armas si el item es una municion.
			triggerEvent("onPlayerPickupWeaponAmmo", source, item, itemPlus)
		else
			triggerClientEvent(source, "displayClientInfo", source, "Inventario lleno", {255, 0, 0})
		end
	end
end
addEvent("onPlayerPickupItem", true)
addEventHandler("onPlayerPickupItem", root, pickupItemFromGround)

function requestFullCanister(patrolstation)
	local x, y = getElementPosition(source)
	local angle = findRotation(x, y, getElementPosition(patrolstation))
	setPedAnimation(source, "BOMBER", "BOM_Plant_Loop", -1, true, false, false)
	setElementRotation(source, 0, 0, angle)

	itemPlaceTimer[source] = setTimer(function(player) 
		setPedAnimation(player, "BOMBER", "BOM_Plant_2Idle", -1, false, false, false)
		setTimer(setPedAnimation, 1000, 1, player)
		itemPlaceTimer[player] = nil
		setElementData(player, "Bidon vacio", getElementData(player, "Bidon vacio") - 1)
		setElementData(player, "Bidon de gasolina", (getElementData(player, "Bidon de gasolina") or 0) + 1)
		triggerClientEvent(player, "unblockInventory", player)
	end, 5000, 1, source)
end
addEvent("onPlayerEmptyCanisterRefill", true)
addEventHandler("onPlayerEmptyCanisterRefill", root, requestFullCanister)

function onPlayerNutrition(itemName, actionID)
	for _, itemData in ipairs(gameplayVariables["nutritions"]) do
		if itemName == itemData[1] and (getElementData(source, itemData[1]) > 0) then
			if itemName == "Carne Crua" then
				setElementData(source, "infection", 1)
			elseif itemName == "Pepsi" or itemName == "Coca-Cola" or itemName == "Mountain Dew" then
				--triggerClientEvent(source, "onClientHasItemBox", source, "Lata de soda vacia")
				setElementData(source, "Lata de soda vacia", (getElementData(source, "Lata de soda vacia") or 0) + 1)
			elseif itemName == "Garrafa de Água" then
				--triggerClientEvent(source, "onClientHasItemBox", source, "Garrafa de Água vacia")
				setElementData(source, "Garrafa de Água vacia", (getElementData(source, "Garrafa de Água vacia") or 0) + 1)
			elseif itemName == "Feijões Enlatados" or itemName == "Macarrão Enlatado" or itemName == "Sardinhas Enlatadas" or itemName == "Salchichas Enlatadas" or itemName == "Milho Enlatado" or itemName == "Ervilhas Enlatadas" or itemName == "Porco Enlatado" or itemName == "Sopa de Peixe" or itemName == "Ravioles Enlatados" or itemName == "Frutas Enlatadas" or itemName == "Leite" then
				--triggerClientEvent(source, "onClientHasItemBox", source, "Lata vacia")
				setElementData(source, "Lata vacia", (getElementData(source, "Lata vacia") or 0) + 1)
			end

			setElementData(source, itemName, getElementData(source, itemName) - 1)
			triggerClientEvent(source, "displayClientInfo", source, "Has consumido: "..itemName, {255,255, 255})
			
			if (itemData[2] > 0) then
				if (getElementData(source, "blood") + itemData[2]) > 12000 then
					setElementData(source, "blood", 12000)
				else
					setElementData(source, "blood", getElementData(source, "blood") + itemData[2])
				end
			end
			if (itemData[3] > 0) then
				if actionID == "eat" then
					setPedAnimation(source, "FOOD", "EAT_Burger", -1, false, false, nil, false)	
				end
				if (getElementData(source, "food") + itemData[3]) > 100 then
					setElementData(source, "food", 100)
				else
					setElementData(source, "food", getElementData(source, "food") + itemData[3])
				end
			end	
			if (itemData[4] > 0) then
				if actionID == "drink" then
					setPedAnimation(source, "VENDING", "VEND_Drink2_P", -1, false, false, nil, false)	
				end
				if (getElementData(source, "thirst") + itemData[4]) > 100 then
					setElementData(source, "thirst", 100)
				else
					setElementData(source, "thirst", getElementData(source, "thirst") + itemData[4])
				end
			end
			if (itemData[5] > 0) then
				setElementData(source, "temperature", getElementData(source, "temperature") + itemData[5])
			end
			if (getElementData(source, itemName) <= 0) then
				triggerClientEvent(source, "onClientRemoveItemFromInventory", source, itemName)
			end

			triggerClientEvent(source, "onClientInventoryUpdate", source)
		end
	end
end
addEvent("onPlayerConsumeNutrition", true)
addEventHandler("onPlayerConsumeNutrition", root, onPlayerNutrition)

function applyMedicalItem(item, itemName)
	if getElementData(source, item) > 0 then
		local applied = false
		if item == "Analgésicos" then
			setElementData(source, "pain", 0)
			applied = true
		elseif item == "Antibioticos"then
			setElementData(source, "infection", 0)
			applied = true		
		elseif item == "Curativo" then
			setElementData(source, "bleeding", 0)
			applied = true
		elseif item == "Morfina" then
			setElementData(source, "brokenbone", 0)
			applied = true
		elseif item == "Kit de Primeiros Socorros" then
			setElementData(source, "blood", 12000)
			applied = true
		elseif item == "Bolsa Térmica" then
			setElementData(source, "temperature", 41)
			setElementData(source, "cold", 0)
			applied = true		
		end
		
		if applied then
			setElementData(source, item, getElementData(source, item) - 1)
			triggerClientEvent(source, "displayClientInfo", source, "Objeto medico consumido: "..itemName, {255,2550, 255})
			setPedAnimation(source, "BOMBER", "BOM_Plant", -1, false, false, nil, false)
			
			if (getElementData(source, itemName) <= 0) then
				triggerClientEvent(source, "onClientRemoveItemFromInventory", source, itemName)
			end

			triggerClientEvent(source, "onClientInventoryUpdate", source)
		end
	end
end
addEvent("onPlayerMedicalAttention", true)
addEventHandler("onPlayerMedicalAttention", root, applyMedicalItem)
 
function playerNeedMedicalAttention(who)
	local x, y = getElementPosition(who)
	local x1, y1 = getElementPosition(source)
	local angle = findRotation(x1, y1, x, y)
	setElementRotation(source, 0, 0, angle)
	setCameraTarget(source, source)
	setPedAnimation(source, "CASINO", "Slot_Plyr", -1, false, false, nil, false)
end
addEvent("onPlayerApplyMedicalAttention", true)
addEventHandler("onPlayerApplyMedicalAttention", root, playerNeedMedicalAttention)

function createBearTrampOnGround(data)
	setPedAnimation(source, "BOMBER", "BOM_Plant_Loop", -1, true, false, false)

	itemPlaceTimer[source] = setTimer(function(data, player) 
		local tramp = createObject(1866, data.x, data.y, data.z, 0, 0, data.rot)
		local col = createColSphere(data.x, data.y, data.z, 2.2)
		local marker = createMarker(data.x, data.y, data.z + 1, "arrow", 0.8, 255, 255, 255, 0, nil)
			
		setElementData(marker, "col", col)
		setElementData(col, "tramp", "Armadilha para Urso")	
		setElementData(player, "Armadilha para Urso", getElementData(player, "Armadilha para Urso") - 1)
		setElementCollisionsEnabled(tramp, false)
			
		setPedAnimation(player, "BOMBER", "BOM_Plant_2Idle", -1, false, false, false)
		setTimer(setPedAnimation, 1000, 1, player)

		triggerClientEvent(player, "unblockInventory", player)
		setElementData(tramp, "parent", col)
		setElementData(col, "parent", tramp)
		
		attachElements(col, tramp)
		itemPlaceTimer[player] = nil
		--triggerClientEvent(player, "onClientInventoryUpdate", player)

		setElementVisibleTo(marker, root, false)
		setElementData(col, "marker", marker)

		addEventHandler("onMarkerHit", marker, playerPutFeetOnTramp)
	end, 5000, 1, data, source)
end
addEvent("onPlayerBearTrampPlace", true)
addEventHandler("onPlayerBearTrampPlace", root, createBearTrampOnGround)

function createMineOnGround(data)
	setPedAnimation(source, "BOMBER", "BOM_Plant_Loop", -1, true, false, false)

	itemPlaceTimer[source] = setTimer(function(data, player) 
		local tramp = createObject(1864, data.x, data.y, data.z, 0, 0, data.rot)
		local col = createColSphere(data.x, data.y, data.z, 2.2)
		local marker = createMarker(data.x, data.y, data.z + 1, "arrow", 0.8, 255, 255, 255, 0, nil)
			
		setElementData(marker, "col", col)	
		setElementData(col, "tramp", "Mina")	
		setElementData(player, "Mina", getElementData(player, "Mina") - 1)
		setElementData(col, "mineowner", player)
		setElementCollisionsEnabled(tramp, false)

		setPedAnimation(player, "BOMBER", "BOM_Plant_2Idle", -1, false, false, false)
		setTimer(setPedAnimation, 1000, 1, player)

		triggerClientEvent(player, "unblockInventory", player)
		setElementData(tramp, "parent", col)
		setElementData(col, "parent", tramp)
		attachElements(col, tramp)
		
		--triggerClientEvent(player, "onClientInventoryUpdate", player)

		setElementVisibleTo(marker, root, false)
		setElementData(col, "marker", marker)
		itemPlaceTimer[player] = nil
		
		addEventHandler("onMarkerHit", marker, playerPutFeetOnTramp)
	end, 5000, 1, data, source)
end
addEvent("onPlayerMinePlace", true)
addEventHandler("onPlayerMinePlace", root, createMineOnGround)

function playerPutFeetOnTramp(element)
	if element and getElementType(element) == "vehicle" or getElementType(element) == "player" or getElementType(element) == "ped" then
		if isElement(source) then
			local col = getElementData(source, "col")
			if isElement(col) then
				local object = getElementData(col, "parent")
				local theType = getElementData(col, "tramp")
				if theType and theType == "Mina" then
					local x, y, z = getElementPosition(source)
					if getElementType(element) == "player" or getElementType(element) == "ped" then
						setElementData(element, "attackedBy", getElementData(col, "mineowner"))
					end
					createExplosion(x, y, z + 1, 10)
					destroyElement(source)
					destroyElement(object)
					destroyElement(col)
				elseif theType and theType == "Armadilha para Urso" then
					if getElementType(element) == "player" then
						setElementData(element, "brokenbone", 1)
						setElementData(element, "pain", 1)
						setElementData(element, "bleeding", math.random(25, 65))
						triggerClientEvent(element, "onClientBearTrampCapture", element)
					elseif getElementType(element) == "ped" then
						setElementData(element, "brokenbone", 1)
					end
	
					destroyElement(source)
					destroyElement(object)
					destroyElement(col)				
				end
			end
		end
	end
end

function removeTramp(col, z)
	local x, y, _ = getElementPosition(source)
	local object = getElementData(col, "parent")
	local theType = getElementData(col, "tramp")
	local marker = getElementData(col, "marker")
	
	if object then				
		if theType == "Mina" then
			createPickupItem("Mina", x, y, z + 1)
		elseif theType == "Armadilha para Urso" then
			createPickupItem("Armadilha para Urso", x, y, z + 1)	
		end
		
		destroyElement(marker)
		destroyElement(object)
		destroyElement(col)
	end
end
addEvent("onPlayerRemoveTramp", true)
addEventHandler("onPlayerRemoveTramp", root, removeTramp)

fire = {}

function createFireplace(col)
	setPedAnimation(source, "BOMBER", "BOM_Plant", -1, false, false, nil, false)
	setTimer(function(source, col) 
		local object = getElementData(col, "parent")
		local hour, minutes = getTheTime()
		setElementData(col, "info", "Al parecer alguien estuvo aqui. (Tiempo estimado: "..hour..":"..minutes..")")
		setElementData(col, "item", false)
		setElementData(col, "fireplace", true)
		setElementModel(object, 1906)
		setTimer(function(object, col)
			triggerEvent("onPlayerSwitchFireplace", root, col, false)
			destroyElement(object)
			destroyElement(col)
		end, 600000, 1, object, col)
	end, 1000, 1, source, col)
end
addEvent("onCreateFireplace", true)
addEventHandler("onCreateFireplace", root, createFireplace)

function createFlameOnFireplace(col, state)
	local object = getElementData(col, "parent")
	
	if isElement(object) then
		if state then
			setElementData(source, "Caixa de Fósforo", getElementData(source, "Caixa de Fósforo") - 1)
			setElementData(col, "fireplaceOn", true)
			
			if not isElement(fire[object]) then
				local x, y, z = getElementPosition(object)
				fire[object] = createObject(3461, x, y, z)
				setElementCollisionsEnabled(fire[object], false)
				attachElements(fire[object], object, 0, 0, -1.2)
				setObjectScale(fire[object], 0)
				triggerClientEvent("onClientFireplaceSound", root, object, true)
			end
		else
			if isElement(fire[object]) then
				destroyElement(fire[object])
				fire[object] = nil
			end
			
			setElementData(col, "fireplaceOn", false)
			triggerClientEvent("onClientFireplaceSound", root, object, false)
		end
	end
end
addEvent("onPlayerSwitchFireplace", true)
addEventHandler("onPlayerSwitchFireplace", root, createFlameOnFireplace)

function createTentOnGround(data)
	setPedAnimation(source, "BOMBER", "BOM_Plant_Loop", -1, true, false, false)

	itemPlaceTimer[source] = setTimer(function(data, player) 
		if isElement(player) then
			local tentName = data.tentdatatable[1]
			local tentID = data.tentdatatable[2]
			local tentScale = data.tentdatatable[3]
			local tentSlots = data.tentdatatable[4]
			local tentDataName = data.tentdatatable[5]
				
			local tent = createObject(tentID, data.x, data.y, data.z, 0, 0, data.rot)
			local col = createColSphere(data.x, data.y, data.z, 3.5)
			local hour, minutes = getTheTime()
				
			setElementData(tent, "parent", col)
			setElementData(col, "parent", tent)
			setElementData(col, "tent", tentName)
			setElementData(col, "MAX_Slots", tentSlots)
			setElementData(col, "owner", tostring(getAccountName(getPlayerAccount(player))))
			attachElements(col, tent, 0, 0, 0)
			setElementDoubleSided(tent, true)
			setObjectScale(tent, tentScale)
				
			triggerEvent("moveTentIntoDB", root, col)

			setPedAnimation(player, "BOMBER", "BOM_Plant_2Idle", -1, false, false, false)
			setTimer(setPedAnimation, 1000, 1, player)
			itemPlaceTimer[player] = nil
				
			setElementData(player, tentDataName, getElementData(player, tentDataName) - 1)
			triggerClientEvent(player, "unblockInventory", player)
		end
	end, 5000, 1, data, source)
end
addEvent("onPlayerPlaceTent", true)
addEventHandler("onPlayerPlaceTent", root, createTentOnGround)

function heatUpFireplace(data)
	setPedAnimation(source, "BOMBER", "BOM_Plant", -1, false, false, false)
	setTimer(setPedAnimation, 3000, 1, source)
end
addEvent("onPlayerHeatUpFireplace", true)
addEventHandler("onPlayerHeatUpFireplace", root, heatUpFireplace)

function removeTent(tent, name)
	local x, y, z = getElementPosition(source)
	local object = getElementData(tent, "parent")
		
	if object then
		for _, v in ipairs(gameplayVariables["tents"]) do
			if name == v[1] then
				triggerEvent("removeTentFromDB", root, tent)
				
				destroyElement(object)
				destroyElement(tent)
				
				createPickupItem(v[5], x, y, z)
				triggerClientEvent(source, "onTentpackSound", source)
				setPedAnimation(source, "BOMBER", "BOM_Plant", -1, false, false, nil, false)
				break
			end
		end
	end
end
addEvent("onPlayerRemoveTent", true)
addEventHandler("onPlayerRemoveTent", root, removeTent)

function createFlareOnGround(data)
	setPedAnimation(source, "BOMBER", "BOM_Plant", -1, false, false, nil, false)

	itemPlaceTimer[source] = setTimer(function(data, player)
		local roadflare = createObject(354, data.x, data.y, data.z)
		local light = createObject(1939, data.x, data.y, data.z)
		setElementCollisionsEnabled(roadflare, false)
		setElementCollisionsEnabled(light, false)
		setObjectScale(roadflare, 0.6)
		
		setTimer(triggerClientEvent, 300000, 1, "onRoadFlareSoundStop", root, roadflare)	
		setTimer(destroyElement, 300000, 1, roadflare)
		setTimer(destroyElement, 300000, 1, light)
		itemPlaceTimer[player] = nil
		
		setElementData(player, "Bengala", getElementData(player, "Bengala") - 1)

		triggerClientEvent(player, "unblockInventory", player)
		triggerClientEvent("onRoadFlareSound", root, roadflare)
	end, 2000, 1, data, source)
end
addEvent("onPlayerBengalePlace", true)
addEventHandler("onPlayerBengalePlace", root, createFlareOnGround)

function cancelItemPlacing()
	if isTimer(itemPlaceTimer[source]) then
		killTimer(itemPlaceTimer[source])
		itemPlaceTimer[source] = nil
	end
end
addEventHandler("onPlayerWasted", root, cancelItemPlacing)

function clearItemPlaceCache()
	itemPlaceTimer[source] = nil
end
addEventHandler("onPlayerQuit", root, clearItemPlaceCache)