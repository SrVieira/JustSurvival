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

function loggedInPlayer(_, account)
	local clothesTable = {}
	local lastSkin = getAccountData(account, "skin") or 0
	local gender = getAccountData(account, "gender") or false
	local lastBackpack = getAccountData(account, "backpack") or false
	local lastWeapon = getAccountData(account, "PRIMARY_Weapon") or false

	if getAccountData(account, "clothes") then
		clothesTable = fromJSON(getAccountData(account, "clothes"))
	end

	triggerClientEvent(source, "onPlayerStartMainMenu", source, lastSkin, clothesTable, gender, lastBackpack, lastWeapon)
end
addEventHandler("onPlayerLogin", root, loggedInPlayer)

function savePlayerCharacter(gender, clothes, skin)
	local account = getPlayerAccount(source)
	setAccountData(account, "skin", skin)
	setAccountData(account, "gender", gender)
	setAccountData(account, "clothes", toJSON(clothes))
end
addEvent("onClientCharacterSave", true)
addEventHandler("onClientCharacterSave", root, savePlayerCharacter)

function savePlayerProgress(player)
	local account = getPlayerAccount(player)
	if account and not isGuestAccount(account) then
		if getElementData(player, "Logged") then
			local x, y, z = getElementPosition(player)
			local skin = getElementModel(player)
			local dead = getElementData(player, "dead")

			if dead == true then
				dead = true
			else
				dead = false
			end
			
			if isElementInWater(player) then
				z = z + 5
			end
			
			setAccountData(account, "last_x", tonumber(x))
			setAccountData(account, "last_y", tonumber(y))
			setAccountData(account, "last_z", tonumber(z))
			setAccountData(account, "skin", tonumber(skin))
			setAccountData(account, "dead", dead)
			
			if skin == 0 then
				local clothesTable = {}
				-- Obtener la ultima prenda del jugador de su cabeza antes de haber obtenido un casco
				local head = getElementData(player, "CJHeadWearing")
				
				for index = 0, 17 do
					local texture, model = getPedClothes(player, index)
					if texture and model then
					
						-- Sustituir los valores texture y model por los que estan en la variable head.
						if type(head) == "table" then
							if index == 1 then
								local hairTex, hairModel = head[2][1], head[2][2]
								if hairTex and hairModel then
									texture = hairTex
									model = hairModel
								end
							elseif index == 16 then
								local hatTex, hatModel = head[1][1], head[1][2]
								if hatTex and hatModel then
									texture = hatTex
									model = hatModel
								end
							end
						end

						table.insert(clothesTable, {texture, model, index})
					end
				end
				
				setAccountData(account, "clothes", toJSON(clothesTable))
			end
			
			for index, v in ipairs(gameplayVariables["playerDataTable"]) do
				local d = getElementData(player, v[1])
				setAccountData(account, v[1], d)
			end
		end
	end
end

addEventHandler("onPlayerQuit", root, 
	function()
		savePlayerProgress(source)
		removeColPlayer(source)
	end
)

addEventHandler("onResourceStop", resourceRoot, 
	function()
		for _, v in ipairs(getElementsByType("player")) do
			savePlayerProgress(v)
		end
	end
)