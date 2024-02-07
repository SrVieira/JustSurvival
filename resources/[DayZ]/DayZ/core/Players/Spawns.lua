local bloodTypes = {"A+", "B+", "A-", "B-", "O+", "O-", "AB-", "AB+"}
local pCol = {}

local bodypartAnimation = {
	[9] = {"PED", "KO_shot_face"}, -- cabeza
	[3] = {"PED", "KO_shot_stom"}, -- pecho
	[8] = {"PED", "KD_right"}, -- pierna derecha
	[7] = {"PED", "KD_left"}, -- pierna izquierda
	[6] = {"PED", "KO_spin_R"}, -- brazo derecho
	[5] = {"PED", "KO_spin_L"}, -- brazo izquierdo
	[4] = {"PED", "KO_skid_back"}, -- culo
}

function createColPlayerOnStart()
	for _, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "Logeado") then
			createColPlayer(player)
		end
	end
	
	table.merge(gameplayVariables["playerDataTable"], gameplayVariables["world_items"])
end
addEventHandler("onResourceStart", resourceRoot, createColPlayerOnStart)

function createColPlayer(player)
	local x, y, z = getElementPosition(player)
	pCol[player] = createColSphere(x, y, z, 1.8)
	setElementData(pCol[player], "player", true)
	setElementData(player, "parent", pCol[player])
	setElementData(pCol[player], "parent", player)
	attachElements(pCol[player], player, 0, 0, 0)
end

function removeColPlayer(player)
	if isElement(pCol[player]) then
		destroyElement(pCol[player])
		pCol[player] = nil
	end
end

function startDayZGame(skinmodel, clothes, gender)
	local account = getPlayerAccount(source)
	local coords = gameplayVariables["player_spawnpoint"]["Los Santos"][math.random(1, #gameplayVariables["player_spawnpoint"]["Los Santos"])]
	local x, y, z = tonumber(getAccountData(account, "last_x")), tonumber(getAccountData(account, "last_y")), tonumber(getAccountData(account, "last_z"))

	triggerEvent("onPlayerDayZSpawn", source)

	setElementData(source, "gender", gender)
	setElementData(source, "Logeado", true)
	setElementDimension(source, 0)
	setCameraTarget(source, source)
	fadeCamera(source, true, 2.0)
	createColPlayer(source)
	showChat(source, true)
	reloadPedWeapon(source) -- Actualizar la municion del arma actual en caso de haber algun bug.
	
	triggerClientEvent(source, "setPlayerLoadScreen", source, false)
	triggerClientEvent("displayClientInfo", root, ""..getPlayerName(source):gsub("#%x%x%x%x%x%x", "").."#FFFFFF ha comenzado a sobrevivir.", {255,255,255})
	
	if (#clothes > 0) then
		for index = 0, 17 do
			local texture, model = getPedClothes(source, index)
			if texture and model then
				removePedClothes(source, index)
			end
		end
		for _, clothing in ipairs(clothes) do
			local texture, clothemodel, index = clothing[1], clothing[2], clothing[3]
			addPedClothes(source, texture, clothemodel, index)
		end
	end

	if x and y and z then
		spawnPlayer(source, x, y, z + 1, 0, skinmodel)

		for index, v in ipairs(gameplayVariables["playerDataTable"]) do
			local d = getAccountData(account, v[1])
			if tostring(d) == "nil" then d = nil end
			if tostring(d) == "false" then d = false end	

			if d then
				setElementData(source, v[1], d)

				if v[1] == "PRIMARY_Weapon" or v[1] == "SECONDARY_Weapon" or v[1] == "SPECIAL_Weapon" then
					local weapon = getElementData(source, v[1])
					if weapon then
						setTimer(function(source, weapon)
							local ammo = getWeaponAmmoName(weapon)
							if ammo then
								triggerEvent("onPlayerRearmWeapon", source, weapon, ammo, false)
							end
						end, 3000, 1, source, weapon)
					end
				end
			end
		end
	else
		spawnPlayer(source, coords[1], coords[2], coords[3] + 1, 0, skinmodel)
	
		loadDefaultItems(source)
		setElementData(source, "blood", 12000)
		setElementData(source, "food", 100)
		setElementData(source, "thirst", 100)
		setElementData(source, "humanity", 2500)
		setElementData(source, "temperature", 38)
		setElementData(source, "hero", 0)
		setElementData(source, "bandit", 0)
		setElementData(source, "hero", 0)
		setElementData(source, "bloodType", bloodTypes[math.random(1, #bloodTypes)])
		setElementData(source, "MAX_Slots", gameplayVariables["MAX_Inventory_Slots"])
	end

	if (getAccountData(account, "dead") == true) then
		setAccountData(account, "dead", false)
		setElementData(source, "dead", false)
		setElementData(source, "blood", 0)
		--killDayZPlayer(false, false, false, 3)
	end
end
addEvent("onPlayerStartDayZGame", true)
addEventHandler("onPlayerStartDayZGame", root, startDayZGame)

function killDayZPlayer(killer, headshot, weapon, bodypart)
	local message = ""
	local account = getPlayerAccount(source)
		
	if (killer and killer ~= source and getElementType(killer) == "player") then
		local gender = getElementData(killer, "gender")
		local humanity = getElementData(killer, "humanity") or 0
		local isBandit = (getElementData(source, "bandit") and getElementData(source, "bandit") > 0)
		
		setElementData(killer, "murders", (getElementData(killer, "murders") or 0) + 1)

		if headshot then
			setElementData(killer, "headshots", (getElementData(killer, "headshots") or 0) + 1)
		end
		
		if isBandit then
			setElementData(killer, "banditskilled", (getElementData(killer, "banditskilled") or 0) + 1)
			setElementData(killer, "humanity", humanity + math.random(1000, 2500))
			
			if (getElementData(killer, "humanity") > 0) then
				setElementData(killer, "bandit", 0)
			elseif (getElementData(killer, "humanity") >= 2500) then
				setElementData(killer, "hero", 1)
			end
		else
			setElementData(killer, "humanity", humanity - math.random(1000, 2500))
			
			if (getElementData(killer, "humanity") < 0) then
				setElementData(killer, "bandit", 1)
			elseif (getElementData(killer, "humanity") < 2500) then
				setElementData(killer, "hero", 0)
			end
		end

		message = ""..getPlayerName(killer):gsub("#%x%x%x%x%x%x", "").."#FFFFFF ha matado a "..getPlayerName(source):gsub("#%x%x%x%x%x%x", "")
	else
		message = ""..getPlayerName(source):gsub("#%x%x%x%x%x%x", "").." ha muerto"
	end

	triggerClientEvent("displayClientInfo", root, message, {255,255,255})

	triggerEvent("removeWeaponCarry", source)
	triggerEvent("removeWeaponAttachedOnBack", source)
	triggerEvent("removeBackpackAttachedOn", root, source)
	
	setElementData(source, "dead", true)
	setAccountData(account, "dead", true)
	removeColPlayer(source)
	killPed(source)
	setElementAlpha(source, 0)
	setElementCollisionsEnabled(source, false)
	
	if getElementData(source, "alivetime") and getElementData(source, "alivetime") > 5 then
		local x, y, z = getElementPosition(source)
		local _, _, r = getElementRotation(source)
		local skin = getElementModel(source)
		local account = getPlayerAccount(source)
		local hour, minute = getTheTime()	
		local ped = createPed(skin, x, y, z+0.5)
		local col = createColSphere(x, y, z, 1.2)		

		setElementRotation(ped, 0, 0, r)
		setElementData(ped, "BotTeam", getTeamFromName("Zombies"))
		setElementData(ped, "parent", col)
		setElementData(col, "parent", ped)
		setElementData(col, "deadperson", true)
		setElementData(col, "lootname", getPlayerName(source))
		setElementData(col, "MAX_Slots", getElementData(source, "MAX_Slots") or 0)
		setElementData(col, "CURRENT_Slots", 0)
		setElementData(col, "info", "Al parecer esta muerto. (Tiempo estimado de muerte: "..hour..":"..minute..", Arma: "..(weapon or "??")..")")
		attachElements(col, ped)
		attachElements(source, ped, 0, 0, -2)
		
		if (getElementModel(source) == 0) then
			for i = 0, 17 do
				local texture, model = getPedClothes(source, i)
				if texture and model then
					addPedClothes(ped, texture, model, i)
				end
			end
		end

		for index, item in ipairs(gameplayVariables["world_items"]) do
			setElementData(col, item[1], getElementData(source, item[1]))
		end

		if bodyparty then
			local block, anim = bodypartAnimation[bodyparty][1], bodypartAnimation[bodyparty][2]
			setTimer(setPedAnimation, 200, 1, ped, block, anim, -1, false, true, false)
			setTimer(setElementData, 500, 1, ped, "anim", {block, anim})
		else
			setTimer(setPedAnimation, 200, 1, ped, "PED", "KO_skid_front", -1, false, true, false)
			setTimer(setElementData, 500, 1, ped, "anim", {"PED", "KO_skid_front"})
		end

		setTimer(setElementHealth, 500, 1, ped, 0)
		setTimer(destroyPedLoot, 60000*6, 1, ped, col)
	end
	
	setElementData(source, "brokenbone", 0)
	setElementData(source, "pain", 0)
	setElementData(source, "bleeding", 0)
	setElementData(source, "cold", 0)
	setElementData(source, "murders", 0)
	setElementData(source, "infection", 0)
	setElementData(source, "alivetime", 0)
	setElementData(source, "hoursalive", 0)
	setElementData(source, "daysalive", 0)
	setElementData(source, "banditskilled", 0)
	setElementData(source, "zombieskilled", 0)
	setElementData(source, "headshots", 0)
	setElementData(source, "PRIMARY_Weapon", nil)
	setElementData(source, "SECONDARY_Weapon", nil)
	setElementData(source, "SPECIAL_Weapon", nil)
	setElementData(source, "backpack", nil)
	setElementData(source, "kevlar", nil)
	setElementData(source, "helmet", nil)
end
addEvent("onPlayerDayZWasted", true)
addEventHandler("onPlayerDayZWasted", root, killDayZPlayer)

function spawnDayZPlayer(city)
	local player = source
	local account = getPlayerAccount(player)
	local coords = gameplayVariables["player_spawnpoint"][city][math.random(1, #gameplayVariables["player_spawnpoint"][city])]

	for index, item in ipairs(gameplayVariables["world_items"]) do
		setElementData(player, item[1], 0)
	end

	spawnPlayer(player, coords[1], coords[2], coords[3] + 1, 0, getElementModel(player))
	triggerClientEvent(player, "onPlayerDeadScreenHide", player)
	setElementCollisionsEnabled(player, true)
	
	setAccountData(account, "dead", false)
	setElementData(player, "dead", false)
	setElementData(player, "blood", 12000)
	setElementData(player, "thirst", 100)
	setElementData(player, "food", 100)
	setElementData(player, "temperature", 38)
	setElementData(player, "humanity", 2500)
	setElementData(player, "hero", 0)
	setElementData(player, "bandit", 0)
	
	setElementData(player, "MAX_Slots", gameplayVariables["MAX_Inventory_Slots"])
	
	setCameraTarget(player, player)
	setElementAlpha(player, 255)

	createColPlayer(player)
	loadDefaultItems(player)
	updateWeaponBack(player)
end
addEvent("onPlayerDayZSelectSpawnpoint", true)
addEventHandler("onPlayerDayZSelectSpawnpoint", root, spawnDayZPlayer)

function destroyPedLoot(ped, col)
	destroyElement(ped)
	destroyElement(col)
end

function loadDefaultItems(player)
	setElementData(player, "Botella de agua", 1)
	setElementData(player, "Pasta", 1)
	setElementData(player, "Vendaje", 2)
	setElementData(player, "Hacha", 1)
	setElementData(player, "Morfina", 1)
	setElementData(player, "Analgesicos", 2)
	setElementData(player, "GPS", 1)
	setElementData(player, "Survivor Suit", 1)
end