function moveItemOutOfInventory(item)
	if getElementData(localPlayer, item) > 0 then
		local x, y, z = getElementPosition(localPlayer)
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

		if item == "Survivor Suit" then
			if (getElementData(localPlayer, item) <= 1) then
				triggerEvent("displayClientInfo", localPlayer, "No puedes tirar este item", {255, 0, 0})
				return
			end
		end
		
		setElementData(localPlayer, item, getElementData(localPlayer, item) - itemPlus)
		
		local itemData = {
			X = x + math.random(-1, 1) * math.cos(math.rad(math.random(0, 360) + 90)),
			Y = y + math.random(-1, 1) * math.sin(math.rad(math.random(0, 360) + 90)),
			Z = (getGroundPosition(x, y, z) + 0.1),
			Item = item,
			Valor = itemPlus
		}

		triggerServerEvent("onPlayerCreatePickupItem", localPlayer, itemData)

		if (item == "Óculos de Visão Termal" and getElementData(localPlayer, "Óculos de Visão Termal") <= 0) or (item == "Óculos de Visão Noturna" and getElementData(localPlayer, "Óculos de Visão Noturna") <= 0) then
			resetCameraVisionMode()
		end
		
		if (getElementData(localPlayer, item) <= 0) then
			removeItemFromInventory(item)

			if getWeaponAmmoName(item) then -- Si el item es un arma equipada.
				for _, slot in ipairs({"PRIMARY", "SECONDARY", "SPECIAL"}) do
					if getCurrentWeaponHolding(slot) and getCurrentWeaponHolding(slot) == item then
						triggerServerEvent("removeWeaponAttachedOnBack", localPlayer)
						triggerServerEvent("onPlayerWeaponRemove", localPlayer, item)
						setElementData(localPlayer, slot.."_Weapon", nil)
					end
				end
			end
		end
	end
end

function movePlayerItemInLoot(item, loot)
	if loot and isElement(loot) and getElementData(localPlayer, item) > 0 then
		local currentSlot = getElementData(loot, "CURRENT_Slots")
		local maxSlot = getElementData(loot, "MAX_Slots")
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

		if item == "Survivor Suit" then
			if (getElementData(localPlayer, item) <= 1) then
				triggerEvent("displayClientInfo", localPlayer, "No puedes mover este item", {255, 0, 0})
				return
			end
		end
		
		if currentSlot + getItemWeight(item) * itemPlus <= maxSlot then
		--[[
			if not getElementData(loot, item) or (getElementData(loot, item) <= 0) then
				local lootBox = getElementData(loot, "itemBox")
				addItemIntoBox(lootBox, item)
			end
		]]
			setElementData(localPlayer, item, getElementData(localPlayer, item) - itemPlus)
			setElementData(loot, item, (getElementData(loot, item) or 0) + itemPlus)
			triggerServerEvent("refrescarLoot", localPlayer, loot)

			if (item == "Óculos de Visão Termal" and getElementData(localPlayer, "Óculos de Visão Termal") <= 0) or (item == "Óculos de Visão Noturna" and getElementData(localPlayer, "Óculos de Visão Noturna") <= 0) then
				resetCameraVisionMode()
			end

			-- Actualizar las armas si el item es una municion.
			local weapon1 = getElementData(localPlayer, "PRIMARY_Weapon")
			local weapon2 = getElementData(localPlayer, "SECONDARY_Weapon")
			local weapon3 = getElementData(localPlayer, "SPECIAL_Weapon")

			if weapon1 then
				local ammo = getWeaponAmmoName(weapon1)
				if ammo and ammo == item then
					triggerServerEvent("onPlayerDropWeaponAmmo", localPlayer)
				end
			end
			if weapon2 then
				local ammo = getWeaponAmmoName(weapon2)
				if ammo and ammo == item then
					triggerServerEvent("onPlayerDropWeaponAmmo", localPlayer)
				end
			end
			if weapon3 then
				local ammo = getWeaponAmmoName(weapon3)
				if ammo and ammo == item then
					triggerServerEvent("onPlayerDropWeaponAmmo", localPlayer)
				end
			end

			if (getElementData(localPlayer, item) <= 0) then
				removeItemFromInventory(item)

				if getWeaponAmmoName(item) then -- Si el item es un arma equipada.
					for _, slot in ipairs({"PRIMARY", "SECONDARY", "SPECIAL"}) do
						if getCurrentWeaponHolding(slot) and getCurrentWeaponHolding(slot) == item then
							triggerServerEvent("removeWeaponAttachedOnBack", localPlayer)
							triggerServerEvent("onPlayerWeaponRemove", localPlayer, item)
							setElementData(localPlayer, slot.."_Weapon", nil)
						end
					end
				end
			end
		else
			triggerEvent("displayClientInfo", localPlayer, "Inventario lleno", {255, 0, 0})
		end

		triggerEvent("onClientInventoryUpdate", localPlayer)
	end
end

function moveItemLootInInventory(item, loot)
	if getElementData(loot, item) > 0 then
		local currentSlot = getElementData(localPlayer, "CURRENT_Slots")
		local maxSlot = getElementData(localPlayer, "MAX_Slots")
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

		if currentSlot + getItemWeight(item) * itemPlus <= maxSlot then
		--[[
			if not getElementData(localPlayer, item) or (getElementData(localPlayer, item) <= 0) then
				local lootBox = getElementData(localPlayer, "itemBox")
				addItemIntoBox(lootBox, item)
			end
		]]
			setElementData(loot, item, getElementData(loot, item) - itemPlus)
			setElementData(localPlayer, item, (getElementData(localPlayer, item) or 0) + itemPlus)

			triggerServerEvent("refrescarLoot", localPlayer, loot)

			-- Actualizar las armas si el item es una municion.
			triggerServerEvent("onPlayerPickupWeaponAmmo", localPlayer, item, itemPlus)
			
			if (getElementData(loot, item) <= 0) then
				removeItemFromLoot(item)
			end
		else
			triggerEvent("displayClientInfo", localPlayer, "Inventario lleno", {255, 0, 0})
		end

		triggerEvent("onClientInventoryUpdate", localPlayer)
	end
end

function getCurrentWeaponHolding(slot)
	if not slot or not slot == "PRIMARY" or not slot == "SECONDARY" or not slot == "SPECIAL" then return end
	return getElementData(localPlayer, tostring(slot).."_Weapon")
end

function placeBuilding(itemName)
	if isElement(objPlacing) then destroyElement(objPlacing) end
	if isElement(markerPlacing) then destroyElement(markerPlacing) end

	local x, y, z = getElementPosition(localPlayer)
	
	if itemName == "Tienda basica" then
		for _, v in ipairs(gameplayVariables["tents"]) do
			if itemName == v[5] then
				objPlacing = createObject(v[2], x, y, z - 1)
				markerPlacing = createMarker(x, y, z - 3.1, "cylinder", 3.5, 255, 0, 0, 105)
				setElementData(objPlacing, "tentdata", {v[1], v[2], v[3], v[4], v[5]}, false)
				attachElements(objPlacing, localPlayer, 0, v[3] * 3.2, -1, 0, 0, 180)
				setElementCollisionsEnabled(objPlacing, false)
				setObjectScale(objPlacing, v[3])
				addEventHandler("onClientMarkerLeave", markerPlacing, removeBuildingForPlace)
				break
			end
		end
	elseif itemName == "Fireplace" then
		objPlacing = createObject(1906, x, y, z - 0.95)
		markerPlacing = createMarker(x, y, z - 3.1, "cylinder", 3.5, 255, 0, 0, 105)
		attachElements(objPlacing, localPlayer, 0, 1, -0.95)
		setElementCollisionsEnabled(objPlacing, false)
		addEventHandler("onClientMarkerLeave", markerPlacing, removeBuildingForPlace)
	elseif itemName == "Armadilha para Urso" then
		objPlacing = createObject(1866, x, y, z - 1)
		markerPlacing = createMarker(x, y, z - 3.1, "cylinder", 3.5, 255, 0, 0, 105)
		attachElements(objPlacing, localPlayer, 0, 1.2, -0.95)
		setElementCollisionsEnabled(objPlacing, false)
		addEventHandler("onClientMarkerLeave", markerPlacing, removeBuildingForPlace)
	elseif itemName == "Mina" then
		objPlacing = createObject(1864, x, y, z - 1)
		markerPlacing = createMarker(x, y, z - 3.1, "cylinder", 3.5, 255, 0, 0, 105)
		attachElements(objPlacing, localPlayer, 0, 1.2, -0.95)
		setElementCollisionsEnabled(objPlacing, false)
		addEventHandler("onClientMarkerLeave", markerPlacing, removeBuildingForPlace)
	end
	
	if isElement(objPlacing) then
		triggerEvent("onPlayerStatusPlaceBuilding", localPlayer, true)
	end
end

function removeBuildingForPlace(elem)
	if elem and elem ~= localPlayer then return end
	if not isElement(markerPlacing) then return end
	if not isElement(objPlacing) then return end

	destroyElement(objPlacing)
	destroyElement(markerPlacing)

	triggerEvent("onPlayerStatusPlaceBuilding", localPlayer, false)
end

addEventHandler("onClientVehicleStartEnter", root,
	function()
		removeBuildingForPlace()
	end
)

--[[
function showMineForPlace()
	local x, y, z = getElementPosition(localPlayer)

	mine = createObject(1864, x, y, z - 1)
	marker = createMarker(x, y, z - 3.1, "cylinder", 3.5, 255, 0, 0, 105)
	attachElements(mine, localPlayer, 0, 1.2, -0.95)
	setElementCollisionsEnabled(mine, false)
	addEventHandler("onClientMarkerLeave", marker, removeTrampForPlace)
end

function showBearTrampForPlace()
	local x, y, z = getElementPosition(localPlayer)

	beartramp = createObject(1866, x, y, z - 1)
	marker = createMarker(x, y, z - 3.1, "cylinder", 3.5, 255, 0, 0, 105)
	attachElements(beartramp, localPlayer, 0, 1.2, -0.95)
	setElementCollisionsEnabled(beartramp, false)
	addEventHandler("onClientMarkerLeave", marker, removeTrampForPlace)
end

function removeTrampForPlace(elem)
	if elem and elem ~= localPlayer then return end
	if not isElement(marker) then return end
	
	removeEventHandler("onClientMarkerLeave", marker, removeTrampForPlace)
	
	if isElement(mine) then
		destroyElement(mine)
	end
	if isElement(beartramp) then
		destroyElement(beartramp)
	end	
	
	destroyElement(marker)
	
	triggerEvent("onPlayerPlacingTrampEnd", localPlayer)
end
]]

function changeCameraVisionMode(key)
	if getElementData(localPlayer, "Logged") and not getElementData(localPlayer, "dead") then
		if key == "n" then
			if getElementData(localPlayer, "Óculos de Visão Noturna") and getElementData(localPlayer, "Óculos de Visão Noturna") > 0 then
				local effect = (getCameraGoggleEffect() == "normal" and "nightvision") or (getCameraGoggleEffect() == "nightvision" and "normal")
				if effect then
					setCameraGoggleEffect(effect)
				end
			end		
		end
		if key == "i" then
			if getElementData(localPlayer, "Óculos de Visão Termal") and getElementData(localPlayer, "Óculos de Visão Termal") > 0 then
				local effect = (getCameraGoggleEffect() == "normal" and "thermalvision") or (getCameraGoggleEffect() == "thermalvision" and "normal")
				if effect then
					setCameraGoggleEffect(effect)
				end
			end
		end
	end
end
bindKey("n", "down", changeCameraVisionMode)
bindKey("i", "down", changeCameraVisionMode)

function resetCameraVisionMode()
	setCameraGoggleEffect("normal")
end
addEventHandler("onClientPlayerWasted", localPlayer, resetCameraVisionMode)

function weaponAmmoUse(weapon, total, inClip)
	local weapon = false
	local weaponAmmo = false
	local currentSlot = getPedWeapon(source)
	local weaponSlot = false
	
	if currentSlot == 34 then -- SNIPERS
		slot = "PRIMARY"
	elseif currentSlot == 25 then -- SHOTGUNS
		slot = "PRIMARY"
	elseif currentSlot == 33 then -- RIFLES
		slot = "PRIMARY"
	elseif currentSlot == 31 then -- ASSAULTS RIFLE
		slot = "PRIMARY"
	elseif currentSlot == 30 then -- GRENADE LAUNCHER
		slot = "PRIMARY"				
	elseif currentSlot == 23 then -- PISTOLS
		slot = "SECONDARY"
	elseif currentSlot == 24 then -- REVOLVERS
		slot = "SECONDARY"
	elseif currentSlot == 29 then -- SUB FUSIL
		slot = "SECONDARY"
	elseif currentSlot == 8 then -- AXE
		slot = "SECONDARY"	
	elseif currentSlot == 4 then -- HUNTING KNIFE
		slot = "SECONDARY"	
	elseif currentSlot == 5 then -- CROWBAR
		slot = "SECONDARY"
	elseif currentSlot == 16 then -- GRANADA
		slot = "SPECIAL"
	elseif currentSlot == 43 then -- BINOCULARES
		slot = "SPECIAL"
	elseif currentSlot == 46 then -- PARACAIDAS
		slot = "SPECIAL"		
	end
	
	if slot then
		weapon = getElementData(localPlayer, tostring(slot).."_Weapon")
		weaponAmmo = getWeaponAmmoName(weapon)
		
		if weaponAmmo and weaponAmmo ~= "Melee" then
			local ammo = getElementData(localPlayer, weaponAmmo)

			if ammo and ammo > 0 then
				setElementData(localPlayer, weaponAmmo, getElementData(localPlayer, weaponAmmo) - 1)
				if (total + inClip == 0) then
					triggerServerEvent("removeWeaponAttachedOnBack", localPlayer, getWeaponSlot(weapon))
					setTimer(setElementData, 200, 1, localPlayer, tostring(slot).."_Weapon", nil) -- I decided add this line with a timer for the fact that when someone shoots with the last bullet it does not sound.
					setElementData(localPlayer, weaponAmmo, 0)
				end
			end
		else
			if currentSlot == 16 then
				setElementData(localPlayer, "Granada", getElementData(localPlayer, "Granada") - 1)
			end
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", localPlayer, weaponAmmoUse)