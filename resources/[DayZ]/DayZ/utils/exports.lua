--[[
----@
----@
----@	MTA:DayZ
----@	Autor: Enargy,
----@	Archivo: utils.lua
----@	Tipo: shared	
----@	Funcionamiento: Funciones utiles.
----@
----@
]]

function getVehicleData(id)
	for Indice, val in ipairs(gameplayVariables["world_vehicles"]) do
		if val[1] == id then
			return val[2], val[3], val[4], val[5], val[6], val[7], val[8]
		end
	end
end

function getTheTime()
	local hour, minutes = getTime()
	if hour < 10 then
		hour = "0"..hour
	else
		hour = hour
	end
	if minutes < 10 then
		minutes = "0"..minutes
	else
		minutes = minutes
	end
	return hour, minutes
end

function getIDFromWeaponName(weapon)
	for key, weap in ipairs(gameplayVariables["world_weapons"]) do
		if weap[1] == weapon then
			return weap[3]
		end
	end
end

function getWeaponSlot(weapon)
	for key, weap in ipairs(gameplayVariables["world_weapons"]) do
		if weap[1] == weapon then
			return weap[8]
		end
	end
end

function getWeaponAmmoName(weapon)
	for key, weap in ipairs(gameplayVariables["world_weapons"]) do
		if weap[1] == weapon then
			return weap[2]
		end
	end
end

function doesItemWeaponAmmo(item)
	for key, weap in ipairs(gameplayVariables["world_weapons"]) do
		if weap[2] == item then
			return weap[2] ~= "Flecha" and true
		end
	end
end

function getWeaponNoiseFactor(weapon)
    for i,weapon2 in ipairs(gameplayVariables["weaponNoiseTable"]) do
        if weapon == weapon2[1] then
            return weapon2[3]
        end
    end
	return 5
end

function getWeaponNoise(weapon)
	for i,weapon2 in ipairs(gameplayVariables["weaponNoiseTable"]) do
		if weapon == weapon2[1] then
			return weapon2[2]
		end
	end
	return 0
end

function getWeaponDamage2(weapon)
	for key, weap in ipairs(gameplayVariables["world_weapons"]) do
		if weap[1] == weapon then
			return weap[4]
		end
	end
end

function getItemName(item)
	for key, value in ipairs(gearTable["Primary Weapons"]) do
		if value[1] == item then
			return value[6]
		end
	end
	for key, value in ipairs(gearTable["Secondary Weapons"]) do
		if value[1] == item then
			return value[6]
		end
	end
	for key, value in ipairs(gearTable["Specially Weapons"]) do
		if value[1] == item then
			return value[6]
		end
	end
	for key, value in ipairs(gearTable["Ammo"]) do
		if value[1] == item then
			return value[6]
		end
	end
	for key, value in ipairs(gearTable["Medical"]) do
		if value[1] == item then
			return value[6]
		end
	end
	for key, value in ipairs(gearTable["Backpacks"]) do
		if value[1] == item then
			return value[6]
		end
	end
	for key, value in ipairs(gearTable["Shields"]) do
		if value[1] == item then
			return value[6]
		end
	end
	for key, value in ipairs(gearTable["Nutrition"]) do
		if value[1] == item then
			return value[6]
		end
	end
	for key, value in ipairs(gearTable["Toolbelt"]) do
		if value[1] == item then
			return value[6]
		end
	end
	for key, value in ipairs(gearTable["Others"]) do
		if value[1] == item then
			return value[6]
		end
	end		
end

function getPlayerCurrentWeapon(player)
	for _, v in ipairs(gameplayVariables["world_weapons"]) do
		if v[3] == getPedWeapon(player) then
			if tostring(getElementData(player, "PRIMARY_Weapon")) == v[1] then
				return v[1]
			end
			if tostring(getElementData(player, "SECONDARY_Weapon")) == v[1] then
				return v[1]
			end
			if tostring(getElementData(player, "SPECIAL_Weapon")) == v[1] then
				return v[1]
			end
		end
	end
	return false
end

function getWeaponDamage(player, weaponmodel)
	for key, weap in ipairs(gameplayVariables["world_weapons"]) do
		if tostring(getElementData(player, "PRIMARY_Weapon")) == weap[1] and weap[3] == weaponmodel then
			return weap[4]
		end
		if tostring(getElementData(player, "SECONDARY_Weapon")) == weap[1] and weap[3] == weaponmodel then
			return weap[4]
		end
		if tostring(getElementData(player, "SPECIAL_Weapon")) == weap[1] and weap[3] == weaponmodel then
			return weap[4]
		end		
	end
	return false
end

function getWeaponObjectID(weapon)
	for key, weap in ipairs(gameplayVariables["world_weapons"]) do
		if weap[1] == weapon then
			return weap[6]
		end
	end
end

function getMagSizeFromWeapon(weapon)
	for key, weap in ipairs(gameplayVariables["world_weapons"]) do
		if weap[1] == weapon then
			return weap[7]
		end
	end
end

function getVehicleNewName(id)
	for index, val in ipairs(gameplayVariables["world_vehicles"]) do
		if id == getVehicleModelFromName(val[11]) then
			return val[10]
		end
	end
	return getVehicleNameFromModel(id) or id
end

function getVehicleMaxBatery(id)
	for index, val in ipairs(gameplayVariables["world_vehicles"]) do
		if id == getVehicleModelFromName(val[11]) then
			return val[7]
		end
	end
	return false
end

function getVehicleMaxScrapsMetal(id)
	for index, val in ipairs(gameplayVariables["world_vehicles"]) do
		if id == getVehicleModelFromName(val[11]) then
			return val[5]
		end
	end
	return false
end

function getVehicleMaxRotary(id)
	for index, val in ipairs(gameplayVariables["world_vehicles"]) do
		if id == getVehicleModelFromName(val[11]) then
			return val[4]
		end
	end
	return false
end

function getVehicleMaxFuelTank(id)
	for index, val in ipairs(gameplayVariables["world_vehicles"]) do
		if id == getVehicleModelFromName(val[11]) then
			return val[3]
		end
	end
	return false
end

function getVehicleColshapeSize(id)
	for index, val in ipairs(gameplayVariables["world_vehicles"]) do
		if id == getVehicleModelFromName(val[11]) then
			return val[8]
		end
	end
	return false
end

function getVehicleMaxSlots(id)
	for index, val in ipairs(gameplayVariables["world_vehicles"]) do
		if id == getVehicleModelFromName(val[11]) then
			return val[9]
		end
	end
	return false
end

function getVehicleMaxFuel(id)
	for index, val in ipairs(gameplayVariables["world_vehicles"]) do
		if id == getVehicleModelFromName(val[11]) then
			return val[6]
		end
	end
	return false
end

function getVehicleMaxTires(id)
	for index, val in ipairs(gameplayVariables["world_vehicles"]) do
		if id == getVehicleModelFromName(val[11]) then
			return val[2]
		end
	end
	return false
end

function getVehicleMaxEngine(id)
	for index, val in ipairs(gameplayVariables["world_vehicles"]) do
		if id == getVehicleModelFromName(val[11]) then
			return val[1]
		end
	end
	return false
end

function getBackpackNameByMaxSlots(slot)
	if slot then
		for _, d in ipairs(gameplayVariables["backpack_table"]) do
			if d[1] == slot then
				return d[3], d[4]
			end
		end
	end
	return false
end

function getBackpackMaxSlots(bp)
	if bp then
		for _, d in ipairs(gameplayVariables["backpack_table"]) do
			if d[3] == bp or bp == d[4] then
				return d[1]
			end
		end
	end
	return false
end

function getBackpackObjectModel(bp)
	if bp then
		for _, d in ipairs(gameplayVariables["backpack_table"]) do
			if d[3] == bp or bp == d[4] then
				return d[2]
			end
		end
	end
	return false
end

function isBackpackItem(itemName)
	if itemName then
		for _, d in ipairs(gameplayVariables["backpack_table"]) do
			if d[4] == itemName then
				return true
			end
		end
	end
	return false
end

function isArmorItem(itemName)
	if itemName then
		for _, d in ipairs(gameplayVariables["helmet_table"]) do
			if d[3] == itemName then
				return "helmet"
			end
		end
		for _, d in ipairs(gameplayVariables["armor_table"]) do
			if d[3] == itemName then
				return "armor"
			end
		end		
	end
	return false
end

function getArmorItemName(itemName)
	if itemName then
		for _, d in ipairs(gameplayVariables["helmet_table"]) do
			if d[3] == itemName then
				return d[2], d[3]
			end
		end
		for _, d in ipairs(gameplayVariables["armor_table"]) do
			if d[3] == itemName then
				return d[2], d[3]
			end
		end		
	end
	return false
end

function isNutritionItem(itemName)
	if itemName then
		for _, d in ipairs(gameplayVariables["nutritions"]) do
			if d[1] == itemName then
				return true
			end
		end
	end	
	return false
end

function getNutritionItemType(itemName)
	if itemName then
		for _, d in ipairs(gameplayVariables["nutritions"]) do
			if d[1] == itemName then
				return d[6]
			end
		end
	end	
	return false
end

function getElementCurrentSlots(element)
	local itemTable = {}
	local slots = 0
	
	for item, weight in pairs(itemWeightTable) do
		local data = getElementData(element, item)
		if data and data > 0 then
			local itemPlus = weight * data
			slots = slots + itemPlus
		end
	end
	
	return slots
end

function getItemWeight(item)
	return itemWeightTable[item]
end