--[[
***********************************************************************************
						Multi Theft Auto DayZ
	Tipo: server
	Autores originales: Marwin W., Germany, Lower Saxony, Otterndorf
	Contribuyentes: L, CiBeR96, 1B0Y, Enargy
	
	Este modo de juego fue modificado por Enargy.
	Todos los derechos de autor reservados a sus contribuyentes
************************************************************************************
]]

backpackTable = {}
helmetTable = {}
armorTable = {}
weaponObject = {}
backpackWeaponObject = {}

function kevlarOffset(skinmodel, kevlar)
	-- return id, x, y, z, rx, ry, rz, scale
	if kevlar == "Police" then
		if skinmodel == 0 then
			return 1831, 0, 0.02, -0.45, 0, 0, 90, 0.9
		elseif skinmodel == 18 then
			return 1831, 0, 0.02, -0.46, 0, 0, 90, 0.9
		elseif skinmodel == 11 then
			return 1831, 0, 0, -0.55, 0, 0, 90, 0.9	
		elseif skinmodel == 7 then
			return 1831, 0, 0, -0.55, 0, 0, 90, 1		
		end
	elseif kevlar == "Basic" then
		if skinmodel == 0 then
			return 1838, -0.015, 0.02, 0.1, 4, -4, 0, 1.8
		elseif skinmodel == 7 then
			return 1838, -0.015, 0.02, 0.1, 4, -4, 0, 1.8
		elseif skinmodel == 18 then
			return 1838, -0.015, 0.02, 0.1, 4, -4, 0, 1.8
		elseif skinmodel == 11 then
			return 1838, -0.015, 0.02, 0, 4, -4, 0, 1.8			
		end
	elseif kevlar == "Civil" then
		if skinmodel == 0 then
			return 1837, 0, 0.05, 0.1, 4, -92, 0, 0.9
		elseif skinmodel == 18 then
			return 1837, 0, 0.05, 0.1, 4, -92, 0, 0.9
		elseif skinmodel == 11 then
			return 1837, 0, 0.05, 0, 4, -92, 0, 0.8
		elseif skinmodel == 7 then
			return 1837, 0, 0.05, 0.1, 4, -92, 0, 1
		end
	elseif kevlar == "War" then
		if skinmodel == 0 then
			return 1836, 0, 0, -0.45, 0,  0, 90, 0.9
		elseif skinmodel == 7 then
			return 1836, 0, 0, -0.55, 0,  0, 90, 1
		elseif skinmodel == 18 then
			return 1836, 0, 0, -0.55, 0,  0, 90, 1
		elseif skinmodel == 11 then
			return 1836, 0, 0, -0.5, 0,  0, 90, 0.8
		end		
	end

	return false
end

function helmetOffset(skinmodel, helmet)
	-- return id, x, y, z, rx, ry, rz, scale
	if helmet == "Moto" then
		if skinmodel == 0 then
			return 1833, 0, 0.05, -0.5, 0, 0, 90, 0.9
		elseif skinmodel == 18 then
			return 1833, 0, 0.05, -0.58, 0, 0, 90, 1
		elseif skinmodel == 11 then
			return 1833, 0, 0.05, -0.52, 0, 0, 90, 1
		elseif skinmodel == 10 then
			return 1833, 0, 0.05, -0.64, 0, 0, 90, 1.2
		elseif skinmodel == 7 then
			return 1833, 0, 0.05, -0.5, 0, 0, 90, 1
		end
	elseif helmet == "Basic" then
		if skinmodel == 0 then
			return 1832, 0, 0.02, 0.1, 0, -90, 0, 1
		elseif skinmodel == 18 then
			return 1832, 0, 0.02, 0.1, 0, -90, 0, 1
		elseif skinmodel == 11 then
			return 1832, 0, 0.02, 0.15, 0, -90, 0, 1
		elseif skinmodel == 7 then
			return 1832, 0, 0.02, 0.15, 0, -90, 0, 1			
		end
	elseif helmet == "War" then
		if skinmodel == 0 then
			return 1834, 0, 0.05, -0.55, 0, 0, 90, 1
		elseif skinmodel == 18 then
			return 1834, 0, 0.05, -0.55, 0, 0, 90, 1
		elseif skinmodel == 11 then
			return 1834, 0, 0.058, -0.518, 0, 0, 90, 1
		elseif skinmodel == 7 then
			return 1834, 0, 0.07, -0.52, 0, 0, 90, 1			
		end	
	elseif helmet == "Aviator" then
		if skinmodel == 0 then
			return 1830, 0, 0.05, -0.55, 0, 0, 90, 1
		elseif skinmodel == 18 then
			return 1830, 0, 0.07, -0.567, 0, 0, 90, 1
		elseif skinmodel == 11 then
			return 1830, 0, 0.07, -0.55, 0, 0, 90, 1.05	
		elseif skinmodel == 7 then
			return 1830, 0, 0.07, -0.55, 0, 0, 90, 1.05				
		end		
	end
	
	return false
end

function getAttachmentOnStart()
	for _, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "Logged") then
			local x, y, z = getElementPosition(player)
			local currentHelmet = getElementData(player, "helmet")
			local currentArmor = getElementData(player, "kevlar")
			local currentBackpack = getElementData(player, "backpack")
			if currentHelmet then
				local id, ox, oy, oz, orx, ory, orz, size = helmetOffset(getElementModel(player), currentHelmet)
				helmetTable[player] = createObject(id, x, y, z)
				attachElementToBone(helmetTable[player], player, 1, ox, oy, oz, orx, ory, orz)
				setElementData(player, "helmetObject", helmetTable[player])
				setObjectScale(helmetTable[player], size)
			end
			if currentArmor then
				local id, ox, oy, oz, orx, ory, orz, size = kevlarOffset(getElementModel(player), currentArmor)
				armorTable[player] = createObject(id, x, y, z)
				setElementData(player, "armorObject", armorTable[player])
				attachElementToBone(armorTable[player], player, 3, ox, oy, oz, orx, ory, orz)
				setObjectScale(armorTable[player], size)			
			end
			if currentBackpack then
				local model = getBackpackObjectModel(currentBackpack)

				if model then
					backpackTable[player] = createObject(model, x, y, z)
					setElementData(player, "backpackObject", backpackTable[player])
					
					if currentBackpack == "Mountain Light" then
						attachElementToBone(backpackTable[player], player, 3, 0, -0.065, 0.06, 0, 0, 0)
					elseif currentBackpack == "Camping" then
						attachElementToBone(backpackTable[player], player, 3, 0, -0.225, 0.06, 0, 0, 0)
					elseif currentBackpack == "Improvised" then
						attachElementToBone(backpackTable[player], player, 3, 0, -0.065, 0.06, 0, 0, 180)
					elseif currentBackpack == "Czech Camo" then
						attachElementToBone(backpackTable[player], player, 3, 0, -0.225, 0.06, -90, 0, 180)
					else
						attachElementToBone(backpackTable[player], player, 3, 0, -0.225, 0.06, 90, 0, 0)
					end
				end
			end
			-- weapon attachment.
			local slot = nil
			if getPedWeapon(player) == 34 then -- SNIPERS
				slot = "PRIMARY"
			elseif getPedWeapon(player) == 25 then -- SHOTGUNS
				slot = "PRIMARY"
			elseif getPedWeapon(player) == 33 then -- RIFLES
				slot = "PRIMARY"
			elseif getPedWeapon(player) == 31 then -- ASSAULTS RIFLE
				slot = "PRIMARY"
			elseif getPedWeapon(player) == 30 then -- GRENADE LAUNCHER
				slot = "PRIMARY"			
			elseif getPedWeapon(player) == 23 then -- PISTOLS
				slot = "SECONDARY"
			elseif getPedWeapon(player) == 24 then -- REVOLVERS
				slot = "SECONDARY"
			elseif getPedWeapon(player) == 29 then -- SUB FUSIL
				slot = "SECONDARY"
			elseif getPedWeapon(player) == 8 then -- AXE
				slot = "SECONDARY"	
			elseif getPedWeapon(player) == 4 then -- HUNTING KNIFE
				slot = "SECONDARY"	
			elseif getPedWeapon(player) == 5 then -- CROWBAR
				slot = "SECONDARY"	
			end
		
			if slot then
				local weapName = getElementData(player, tostring(slot).."_Weapon")
				if weapName then
					local weapID = getWeaponObjectID(weapName)
					if weapID then
						local x, y, z = getElementPosition(player)
						weaponObject[player] = createObject(weapID, x, y, z)
						attachElementToBone(weaponObject[player], player, 12, 0, 0, 0, 0, -90, 0)
						setElementData(player, "weaponObjectCarry", weaponObject[player])
					end
				end
			end
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, getAttachmentOnStart)

function playerBackpack(data)
	if source and getElementType(source) == "player" then
		local x, y, z = getElementPosition(source)
		local val = getElementData(source, data)

		if data == "helmet" then
			local head = getElementData(source, "CJHeadWearing")
			local newHelmet = getElementData(source, "helmet")
			if newHelmet then
				local id, ox, oy, oz, orx, ory, orz, size = helmetOffset(getElementModel(source), newHelmet)
				if id then
					if isElement(helmetTable[source]) then
						setElementModel(helmetTable[source], id)
						setObjectScale(helmetTable[source], size)
						setElementBonePositionOffset(helmetTable[source], ox, oy, oz)
						setElementBoneRotationOffset(helmetTable[source], orx, ory, orz)
					else
						helmetTable[source] = createObject(id, x, y, z)
						attachElementToBone(helmetTable[source], source, 1, ox, oy, oz, orx, ory, orz)
						setElementData(source, "helmetObject", helmetTable[source])
						setObjectScale(helmetTable[source], size)
						
						-- Remover las prendas de la cabeza del cj.
						if getElementModel(source) == 0 then 
							removePedClothes(source, 16)
							removePedClothes(source, 1)
						end
					end
				end
			else	
				if getElementModel(source) == 0 then -- Agregar las prendas de la cabeza del cj que habian sido removidas por el casco.
					if head then
						local hatTex, hatModel = head[1][1], head[1][2]
						local hairTex, hairModel = head[2][1], head[2][2]

						if hatTex then
							addPedClothes(source, hatTex, hatModel, 16)
						end
						if hairTex then
							addPedClothes(source, hairTex, hairModel, 1)
						end
					end
				end
				removePlayerHelmet(source) -- Destruir el casco.
			end
		end
		
		if data == "kevlar" then
			local newKevlar = getElementData(source, "kevlar")
			if newKevlar then
				local id, ox, oy, oz, orx, ory, orz, size = kevlarOffset(getElementModel(source), newKevlar)
				if id then
					if isElement(armorTable[source]) then
						setElementModel(armorTable[source], id)
						setObjectScale(armorTable[source], size)
						setElementBonePositionOffset(armorTable[source], ox, oy, oz)
						setElementBoneRotationOffset(armorTable[source], orx, ory, orz)
					else
						armorTable[source] = createObject(id, x, y, z)
						setElementData(source, "armorObject", armorTable[source])
						attachElementToBone(armorTable[source], source, 3, ox, oy, oz, orx, ory, orz)
						setObjectScale(armorTable[source], size)
					end
				end
			else
				removePlayerArmor(source) -- Destruir el armor.
			end
		end
		
		if data == "backpack" then
			local newVal = getElementData(source, "backpack")
			local x, y, z = getElementPosition(source)
			local slots = getBackpackMaxSlots(newVal)
			local model = getBackpackObjectModel(newVal)

			if model then
				if isElement(backpackTable[source]) then
					destroyElement(backpackTable[source])
					backpackTable[source] = nil
				end
				
				backpackTable[source] = createObject(model, x, y, z)
				setElementData(source, "backpackObject", backpackTable[source])
				
				if newVal == "Mountain Light" then
					attachElementToBone(backpackTable[source], source, 3, 0, -0.065, 0.06, 0, 0, 0)
				elseif newVal == "Camping" then
					attachElementToBone(backpackTable[source], source, 3, 0, -0.225, 0.06, 0, 0, 0)
				elseif newVal == "Improvised" then
					attachElementToBone(backpackTable[source], source, 3, 0, -0.065, 0.06, 0, 0, 180)
				elseif newVal == "Czech Camo" then
					attachElementToBone(backpackTable[source], source, 3, 0, -0.225, 0.06, -90, 0, 180)
				else
					attachElementToBone(backpackTable[source], source, 3, 0, -0.225, 0.06, 90, 0, 0)
				end

				setElementData(source, "MAX_Slots", slots)
			else
				if isElement(backpackTable[source]) then
					destroyElement(backpackTable[source])
					backpackTable[source] = nil
				end
				setElementData(source, "MAX_Slots", gameplayVariables["MAX_Inventory_Slots"])
			end
			
			updateWeaponBack(source) -- Actualizar la posicion del arma en la mochila.
		end
	end
end
addEventHandler("onElementDataChange", root, playerBackpack)

function updateWeaponBack(player)
	local x, y, z = getElementPosition(player)
	local backpack = backpackTable[player]
	local primary = getElementData(player, "PRIMARY_Weapon")	
	local backpackName = getElementData(player, "backpack")	
	local offX = 0.19
	
	if isElement(backpackWeaponObject[player]) then
		destroyElement(backpackWeaponObject[player])
		backpackWeaponObject[player] = nil
	end

	if backpackName and backpackName == "Improvised" then
		offX = 0.14
	elseif backpackName and backpackName == "Assault Light" then
		offX = 0.14
	elseif backpackName and backpackName == "Mountain Light" then
		offX = 0.16
	elseif backpackName and backpackName == "Survivor" then
		offX = 0.26
	end
	
	if primary then
		backpackWeaponObject[player] = createObject(getWeaponObjectID(primary), x, y, z)
	end

	if isElement(backpack) then
		if isElement(backpackWeaponObject[player]) then
			attachElementToBone(backpackWeaponObject[player], player, 3, offX, -0.31, -0.15, 0, 270, -90)
		end
	else
		if isElement(backpackWeaponObject[player]) then
			if primary == "Ballesta" then
				attachElementToBone(backpackWeaponObject[player], player, 3, 0.26, -0.12, -0.15, 0, 270, 10)
			else
				attachElementToBone(backpackWeaponObject[player], player, 3, offX, -0.11, 0.11, 0, 60, 190)
			end
		end
	end
end

function onPlayerChangeWeaponObject(prevWeapon, currentSlot)
	-- Update holding weapon.
	if getElementData(source, "Logged") then
		local x, y, z = getElementPosition(source)
		local slot = nil
		
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
		end
		
		removeWeaponObject(source) -- Destruir el arma en mano.
		
		if slot then
			local weapName = getElementData(source, slot.."_Weapon")
			local weapID = getWeaponObjectID(weapName)
			weaponObject[source] = createObject(weapID, x, y, z)
			attachElementToBone(weaponObject[source], source, 12, 0, 0, 0, 0, -90, 0)
			setElementData(source, "weaponObjectCarry", weaponObject[source])
		end
		
		-- Update weapons back.
		local primary = getElementData(source, "PRIMARY_Weapon")
		local secondary = getElementData(source, "SECONDARY_Weapon")
		local primaryID = getIDFromWeaponName(primary)
		local secondaryID = getIDFromWeaponName(secondary)

		removeWeaponBack(source) -- Destruir el arma en la mochila.

		if primaryID ~= currentSlot then
			if getWeaponObjectID(primary) then
				--backpackWeaponObject[source] = createObject(getWeaponObjectID(primary), x, y, z)
				
				updateWeaponBack(source)
			end
		end

		if isElement(backpackWeaponObject[source]) then
			setObjectScale(backpackWeaponObject[source],0.875)
			setElementDoubleSided(backpackWeaponObject[source], true)
			setElementData(source, "weaponOnBack", backpackWeaponObject[source])
		end
	end
end
addEventHandler("onPlayerWeaponSwitch", root, onPlayerChangeWeaponObject)

function removeWeaponAttachedOnBack()
	removeWeaponBack(source)
end
addEvent("removeWeaponAttachedOnBack", true)
addEventHandler("removeWeaponAttachedOnBack", root, removeWeaponAttachedOnBack)

function removeCarryingWeapon(weapon)
	removeWeaponObject(source)
	takeWeapon(source, getIDFromWeaponName(weapon))
end
addEvent("onPlayerWeaponRemove", true)
addEventHandler("onPlayerWeaponRemove", root, removeCarryingWeapon)

function removeWeaponObject(player)
	if weaponObject[player] and isElement(weaponObject[player]) then
		destroyElement(weaponObject[player])
		weaponObject[player] = nil			
	end
end

function removePlayerBackpack(player)
	if isElement(backpackTable[player]) then
		detachElementFromBone(backpackTable[player])
		destroyElement(backpackTable[player])
		backpackTable[player] = nil
	end
end
addEvent("removeBackpackAttachedOn", true)
addEventHandler("removeBackpackAttachedOn", root, removePlayerBackpack)

function removeWeaponBack(player)
	if isElement(backpackWeaponObject[player]) then
		detachElementFromBone(backpackWeaponObject[player])
		destroyElement(backpackWeaponObject[player])
		backpackWeaponObject[player] = nil
	end
end

function removePlayerHelmet(player)
	if isElement(helmetTable[player]) then
		detachElementFromBone(helmetTable[player])
		destroyElement(helmetTable[player])
		helmetTable[player] = nil
	end
end

function removePlayerArmor(player)
	if isElement(armorTable[player]) then
		detachElementFromBone(armorTable[player])
		destroyElement(armorTable[player])
		armorTable[player] = nil
	end
end

function onAttachmentQuit()
	removePlayerBackpack(source)
	removePlayerArmor(source)
	removePlayerHelmet(source)
	removeWeaponObject(source)
	removeWeaponBack(source)
end
addEventHandler("onPlayerQuit", root, onAttachmentQuit)

addEventHandler("onPlayerWasted", root, 
	function()
		removeWeaponObject(source)
	end
)