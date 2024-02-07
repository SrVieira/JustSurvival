local screenW, screenH = guiGetScreenSize()
local centerX, centerY = screenW/2, screenH/2
local lastskin = 0
local lastGender = false
local lastBackpack = false
local lastWeapon = false
local myGender = false
local weaponBackObject = false
local backpackObject = false
local uiTable = {}
local oldClothes = {}

local buttonFont = guiCreateFont("fonts/font-3.ttf", 12)

local clothingCount = {
	hat = 0, hair = 0, chest = 0, legs = 0, foot = 0, glasses = 0
}

local lastClothingCount = {
	hat = 0, hair = 0, chest = 0, legs = 0, foot = 0, glasses = 0
}

local GUISelector = {
	button = {},window = {},radiobutton = {},label = {}
}

function setPlayerLoadScreen(state)
	if not isElement(loadLabel) then
		loadLabel = guiCreateLabel(0.01, 0.02, 0.98, 0.97, "CARGANDO", true)
		guiSetFont(loadLabel, guiCreateFont("fonts/teko_medium.ttf", 28))
		guiLabelSetHorizontalAlign(loadLabel, "center", true)
		guiLabelSetVerticalAlign(loadLabel, "center")   
		guiSetProperty(loadLabel, "Disabled", "True")
	end
	
	guiSetVisible(loadLabel, state)
	fadeCamera(not state, 0.1)
end
addEvent("setPlayerLoadScreen", true)
addEventHandler("setPlayerLoadScreen", root, setPlayerLoadScreen)

function resourceStart()
	
	if not getElementData(localPlayer, "Logeado") then
		dayzSoundtrack = playSound("sounds/misc/soundtrack.mp3", true)
		setCameraMatrix(189.9629974365234, 360.21728515625, 2992.54189453125, 190.8286743164063, 359.7214660644531, 2992.44)
		triggerEvent("DayZ_LoginPanel", localPlayer)
		setElementDimension(localPlayer, 100)
	end

	setPedTargetingMarkerEnabled(false)
	setPlayerHudComponentVisible("all", false)
	setPlayerHudComponentVisible("crosshair", true)
	
	fadeCamera(true)

	-- Apagado del trafico.
	setTrafficLightState("disabled")
	
	-- Remover la pantalla de carga.
	triggerServerEvent("onTextAuthRemove", localPlayer)

	toggleControl("radar", false)
end
addEventHandler("onClientResourceStart", resourceRoot, resourceStart)

function initMenuButtons()
	uiTable.dayz = guiCreateStaticImage(centerX-300, centerY-126, 227, 118, "images/misc/dayz.png", false, false)
	uiTable.start = createButton(centerX-270, centerY+25, 165, 25, "Comenzar", false, false)
	uiTable.character = createButton(centerX-270, centerY+55, 165, 25, "Personaje", false, false)
	uiTable.config = createButton(centerX-270, centerY+85, 165, 25, "Graficos", false, false)

	addEventHandler("onClientGUIClick", uiTable.start, startGame, false)
	addEventHandler("onClientGUIClick", uiTable.character, onClickCharacterButton, false)
	addEventHandler("onClientGUIClick", uiTable.config, showMenuConfig, false)
end

function showMenu(model, clothes, gender, backpack, weapon)
	showChat(false)
	showCursor(true)
	myGender = gender
	lastBackpack = backpack
	lastWeapon = weapon
	
	initMenuButtons()

	if myGender then
		createCharacter(model, clothes, lastBackpack, lastWeapon)
	else
		setUITableComponentVisible(false)
		skinMenu()
	end
end
addEvent("onPlayerStartMainMenu", true)
addEventHandler("onPlayerStartMainMenu", root, showMenu)

function skinMenu()
	GUISelector.window[1] = guiCreateWindow(10, screenH-380, 240, 279, "Personaje", false)
	guiWindowSetSizable(GUISelector.window[1], false)
	guiWindowSetMovable(GUISelector.window[1], false)

	GUISelector.label[1] = guiCreateLabel(10, 28, 88, 25, "Genero", false, GUISelector.window[1])
	guiLabelSetVerticalAlign(GUISelector.label[1], "center")
	GUISelector.label[2] = guiCreateLabel(10, 53, 88, 25, "Cabeza", false, GUISelector.window[1])
	guiLabelSetVerticalAlign(GUISelector.label[2], "center")
	GUISelector.label[3] = guiCreateLabel(10, 78, 88, 25, "Cabello", false, GUISelector.window[1])
	guiLabelSetVerticalAlign(GUISelector.label[3], "center")
	GUISelector.label[4] = guiCreateLabel(10, 103, 88, 25, "Torso", false, GUISelector.window[1])
	guiLabelSetVerticalAlign(GUISelector.label[4], "center")
	GUISelector.label[5] = guiCreateLabel(10, 128, 88, 25, "Pantalones", false, GUISelector.window[1])
	guiLabelSetVerticalAlign(GUISelector.label[5], "center")
	GUISelector.label[6] = guiCreateLabel(10, 153, 88, 25, "Zapatos", false, GUISelector.window[1])
	guiLabelSetVerticalAlign(GUISelector.label[6], "center")
	GUISelector.label[7] = guiCreateLabel(10, 178, 88, 25, "Gafas", false, GUISelector.window[1])
	guiLabelSetVerticalAlign(GUISelector.label[7], "center")
	GUISelector.button[1] = guiCreateButton(10, 223, 220, 23, "Guardar", false, GUISelector.window[1])
	guiSetProperty(GUISelector.button[1], "NormalTextColour", "FFAAAAAA")
	GUISelector.button[2] = guiCreateButton(10, 246, 220, 23, "Volver", false, GUISelector.window[1])
	guiSetProperty(GUISelector.button[2], "NormalTextColour", "FFAAAAAA")
	GUISelector.radiobutton[1] = guiCreateRadioButton(108, 27, 68, 15, "Hombre", false, GUISelector.window[1])
	
	GUISelector.radiobutton[2] = guiCreateRadioButton(177, 27, 67, 15, "Mujer", false, GUISelector.window[1])
	GUISelector.button[3] = guiCreateButton(108, 53, 29, 25, "<", false, GUISelector.window[1])
	guiSetProperty(GUISelector.button[3], "NormalTextColour", "FFAAAAAA")
	GUISelector.button[4] = guiCreateButton(108, 78, 29, 25, "<", false, GUISelector.window[1])
	guiSetProperty(GUISelector.button[4], "NormalTextColour", "FFAAAAAA")
	GUISelector.button[5] = guiCreateButton(108, 103, 29, 25, "<", false, GUISelector.window[1])
	guiSetProperty(GUISelector.button[5], "NormalTextColour", "FFAAAAAA")
	GUISelector.button[6] = guiCreateButton(108, 128, 29, 25, "<", false, GUISelector.window[1])
	guiSetProperty(GUISelector.button[6], "NormalTextColour", "FFAAAAAA")
	GUISelector.button[7] = guiCreateButton(108, 153, 29, 25, "<", false, GUISelector.window[1])
	guiSetProperty(GUISelector.button[7], "NormalTextColour", "FFAAAAAA")
	GUISelector.button[8] = guiCreateButton(108, 178, 29, 25, "<", false, GUISelector.window[1])
	guiSetProperty(GUISelector.button[8], "NormalTextColour", "FFAAAAAA")

	GUISelector.label[8] = guiCreateLabel(139, 53, 54, 25, "0", false, GUISelector.window[1])
	guiLabelSetHorizontalAlign(GUISelector.label[8], "center", false)
	guiLabelSetVerticalAlign(GUISelector.label[8], "center")
	GUISelector.label[9] = guiCreateLabel(139, 78, 54, 25, "0", false, GUISelector.window[1])
	guiLabelSetHorizontalAlign(GUISelector.label[9], "center", false)
	guiLabelSetVerticalAlign(GUISelector.label[9], "center")
	GUISelector.label[10] = guiCreateLabel(139, 103, 54, 25, "0", false, GUISelector.window[1])
	guiLabelSetHorizontalAlign(GUISelector.label[10], "center", false)
	guiLabelSetVerticalAlign(GUISelector.label[10], "center")
	GUISelector.label[11] = guiCreateLabel(139, 128, 54, 25, "0", false, GUISelector.window[1])
	guiLabelSetHorizontalAlign(GUISelector.label[11], "center", false)
	guiLabelSetVerticalAlign(GUISelector.label[11], "center")
	GUISelector.label[12] = guiCreateLabel(139, 153, 54, 25, "0", false, GUISelector.window[1])
	guiLabelSetHorizontalAlign(GUISelector.label[12], "center", false)
	guiLabelSetVerticalAlign(GUISelector.label[12], "center")
	GUISelector.label[13] = guiCreateLabel(139, 178, 54, 25, "0", false, GUISelector.window[1])
	guiLabelSetHorizontalAlign(GUISelector.label[13], "center", false)
	guiLabelSetVerticalAlign(GUISelector.label[13], "center")
	
	GUISelector.button[9] = guiCreateButton(193, 53, 29, 25, ">", false, GUISelector.window[1])
	guiSetProperty(GUISelector.button[9], "NormalTextColour", "FFAAAAAA")
	GUISelector.button[10] = guiCreateButton(193, 78, 29, 25, ">", false, GUISelector.window[1])
	guiSetProperty(GUISelector.button[10], "NormalTextColour", "FFAAAAAA")
	GUISelector.button[11] = guiCreateButton(193, 103, 29, 25, ">", false, GUISelector.window[1])
	guiSetProperty(GUISelector.button[11], "NormalTextColour", "FFAAAAAA")
	GUISelector.button[12] = guiCreateButton(193, 128, 29, 25, ">", false, GUISelector.window[1])
	guiSetProperty(GUISelector.button[12], "NormalTextColour", "FFAAAAAA")
	GUISelector.button[13] = guiCreateButton(193, 153, 29, 25, ">", false, GUISelector.window[1])
	guiSetProperty(GUISelector.button[13], "NormalTextColour", "FFAAAAAA")
	GUISelector.button[14] = guiCreateButton(193, 178, 29, 25, ">", false, GUISelector.window[1])
	guiSetProperty(GUISelector.button[14], "NormalTextColour", "FFAAAAAA")
	
	if not myGender then
		enableChangeButtonClothes(false)
		guiSetEnabled(GUISelector.button[1], false)
		guiSetEnabled(GUISelector.button[2], false)
	end
	
	addEventHandler("onClientGUIClick", GUISelector.radiobutton[1], selectGender, false)
	addEventHandler("onClientGUIClick", GUISelector.radiobutton[2], selectGender, false)
	addEventHandler("onClientGUIClick", GUISelector.button[1], saveSkin, false)
	addEventHandler("onClientGUIClick", GUISelector.button[2], closeSkinSelector, false)
	
	if isElement(lastPedElement) and (getElementModel(lastPedElement) == 0) then
		for index = 0, 17 do
			local texture, model = getPedClothes(lastPedElement, index)
			if texture then
				for k, v in ipairs(gameplayVariables["clothingTable"]["Hats"]) do
					if v[1] == texture then
						guiSetText(GUISelector.label[8], tostring(k))
						clothingCount.hat = k
					end
				end
				for k, v in ipairs(gameplayVariables["clothingTable"]["Hair"]) do
					if v[1] == texture then
						guiSetText(GUISelector.label[9], tostring(k))
						clothingCount.hair = k
					end
				end
				for k, v in ipairs(gameplayVariables["clothingTable"]["Chest"]) do
					if v[1] == texture then
						guiSetText(GUISelector.label[10], tostring(k))
						clothingCount.chest = k
					end
				end
				for k, v in ipairs(gameplayVariables["clothingTable"]["Legs"]) do
					if v[1] == texture then
						guiSetText(GUISelector.label[11], tostring(k))
						clothingCount.legs = k
					end
				end
				for k, v in ipairs(gameplayVariables["clothingTable"]["Foot"]) do
					if v[1] == texture then
						guiSetText(GUISelector.label[12], tostring(k))
						clothingCount.foot = k
					end
				end
				for k, v in ipairs(gameplayVariables["clothingTable"]["Glasses"]) do
					if v[1] == texture then
						guiSetText(GUISelector.label[13], tostring(k))
						clothingCount.glasses = k
					end
				end				
			end
		end
	end
end

function closeWindowNews()
	setUITableComponentVisible(true)
	destroyElement(windowNews)
	destroyElement(btnNewsBack)
end

function showMenuConfig()
	setUITableComponentVisible(false)
	
	btnLowG = createButton(centerX-270, centerY+25, 165, 25, "Bajo", false, false)
	btnMediumG = createButton(centerX-270, centerY+55, 165, 25, "Normal", false, false)
	btnHighG = createButton(centerX-270, centerY+85, 165, 25, "Alto", false, false)
	
	addEventHandler("onClientGUIClick", btnLowG, applyConfig, false)
	addEventHandler("onClientGUIClick", btnMediumG, applyConfig, false)
	addEventHandler("onClientGUIClick", btnHighG, applyConfig, false)
end

function applyConfig()
	if source == btnLowG or source == btnMediumG or source == btnHighG then 
		if source == btnLowG then -- Aplying low graphs..
			setTimer(function()
				triggerEvent("switchGraphics", localPlayer, "low")
				setElementData(localPlayer, "graphics", "low", false)
			end, 2000, 1)
		elseif source == btnMediumG then -- Aplying medium graphs..
			setTimer(function()
				triggerEvent("switchGraphics", localPlayer, "medium")
				setElementData(localPlayer, "graphics", "medium", false)
			end, 2000, 1)
		elseif source == btnHighG then -- Aplying highest graphs..
			setTimer(function()
				triggerEvent("switchGraphics", localPlayer, "high")
				setElementData(localPlayer, "graphics", "high", false)
			end, 2000, 1)
		end
	
		destroyElement(btnLowG)
		destroyElement(btnMediumG)
		destroyElement(btnHighG)
		
		setPlayerLoadScreen(true)
		setTimer(setPlayerLoadScreen, 5000, 1, false)
		setTimer(setUITableComponentVisible, 5000, 1, true)
	end
end

function selectGender()
	if not isElement(lastPedElement) then
		createCharacter(0, {}, lastBackpack, lastWeapon)
		guiSetEnabled(GUISelector.button[1], true)
	end
	
	if myGender and myGender == "male" then
		if source == GUISelector.radiobutton[1] then
			setElementModel(lastPedElement, lastskin)
			if (getElementModel(lastPedElement) == 0) then 
				enableChangeButtonClothes(true) 
			end
		elseif source == GUISelector.radiobutton[2] then
			setElementModel(lastPedElement, 11)
			enableChangeButtonClothes(false)
		end	
	elseif myGender and myGender == "female" then
		if source == GUISelector.radiobutton[1] then
			setElementModel(lastPedElement, 0)
			enableChangeButtonClothes(true)
		elseif source == GUISelector.radiobutton[2] then
			setElementModel(lastPedElement, lastskin)
			enableChangeButtonClothes(false)
		end
	else
		if source == GUISelector.radiobutton[1] then
			myGender = "male"
			setElementModel(lastPedElement, 0)
			enableChangeButtonClothes(true)
		elseif source == GUISelector.radiobutton[2] then
			myGender = "female"
			setElementModel(lastPedElement, 9)
			enableChangeButtonClothes(false)
		end
	end
end

function createCharacter(model, clothes, backpack, weapon)
	lastPedElement = createPed(model, 192.75533, 358.15067, 2992.10010)
	setElementDimension(lastPedElement, 100)
	setElementRotation(lastPedElement, 0, 0, 60)

	for index = 0, 17 do
		local texture, model = getPedClothes(lastPedElement, index)
		if texture and model then
			removePedClothes(lastPedElement, index)
		end
	end
	if (clothes and #clothes > 0) and model == 0 then
		for _, val in ipairs(clothes) do
			local texture, model, index = val[1], val[2], val[3]
			addPedClothes(lastPedElement, texture, model, index)			
		end
	end
	if backpack then -- Pegar la ultima mochila usada.
		if isElement(backpackObject) then
			detachElementFromBone(backpackObject)
			destroyElement(backpackObject)
			backpackObject = nil
		end
		
		for _, bp in ipairs(gameplayVariables["backpack_table"]) do
			if bp[3] == backpack then
				backpackObject = createObject(bp[2], getElementPosition(lastPedElement))
				attachElementToBone(backpackObject, lastPedElement, 3, 0, -0.225, 0.05, 90, 0, 0)
			end
		end
	end
	--[[
	if weapon then -- Pegar la ultima arma principal usada.
		if isElement(weaponBackObject) then
			detachElementFromBone(weaponBackObject)
			destroyElement(weaponBackObject)
			weaponBackObject = nil
		end
		local object = getWeaponObjectID(weapon)
		if object then
			weaponBackObject = createObject(object, getElementPosition(lastPedElement))
			if isElement(backpackObject) then
				attachElementToBone(weaponBackObject, lastPedElement, 3, 0.19, -0.31, -0.1, 0, 270, -90)
			else
				if weapon == "Ballesta" then
					attachElementToBone(weaponBackObject, lastPedElement, 3, 0.26, -0.12, -0.1, 0, 270, 10)
				else
					attachElementToBone(weaponBackObject, lastPedElement, 3, 0.19, -0.11, 0.16, 0, 60, 190)
				end
			end
		end
	end
	]]
end

function enableChangeButtonClothes(bool)
	for i = 3, 14 do
		guiSetEnabled(GUISelector.button[i], bool)
	end
end

function saveSkin()
	if guiRadioButtonGetSelected(GUISelector.radiobutton[1]) then
		myGender = "male"
	elseif guiRadioButtonGetSelected(GUISelector.radiobutton[2]) then
		myGender = "female"
	end
	local clothes = {}
	local skinmodel = getElementModel(lastPedElement)
	if skinmodel == 0 then
		for i = 0, 17 do
			local texture, model = getPedClothes(lastPedElement, i)
			if texture and model then
				table.insert(clothes, {texture, model, i})
			end
		end
	end
	if myGender == "female" then
		clothingCount.hat = 0
		clothingCount.hair = 0
		clothingCount.chest = 0
		clothingCount.legs = 0
		clothingCount.foot = 0
		clothingCount.glasses = 0
		destroyElement(lastPedElement)
		createCharacter(skinmodel, {}, lastBackpack, lastWeapon)
	end
	triggerServerEvent("onClientCharacterSave", localPlayer, myGender, clothes, skinmodel)
	destroyElement(GUISelector.window[1])
	setUITableComponentVisible(true)	
end

function closeSkinSelector()
	clothingCount.hat = lastClothingCount.hat
	clothingCount.hair = lastClothingCount.hair
	clothingCount.chest = lastClothingCount.chest
	clothingCount.legs = lastClothingCount.legs
	clothingCount.foot = lastClothingCount.foot
	clothingCount.glasses = lastClothingCount.glasses
	myGender = lastGender
	setElementModel(lastPedElement, lastskin)
	destroyElement(GUISelector.window[1])
	setUITableComponentVisible(true)
	if lastskin == 0 then
		for i = 0, 17 do
			local texture, model = getPedClothes(localPlayer, i)
			if texture and model then
				removePedClothes(lastPedElement, i)
			end
		end
		for i, v in ipairs(oldClothes) do
			addPedClothes(lastPedElement, v[1], v[2], v[3])
		end
	end
	if myGender == "female" then
		destroyElement(lastPedElement)
		createCharacter(lastskin, {}, lastBackpack, lastWeapon)
	end
	oldClothes = {}
end

function onClickCharacterButton()
	setUITableComponentVisible(false)
	skinMenu()
	lastGender = myGender
	lastskin = getElementModel(lastPedElement)
	lastClothingCount.hat = clothingCount.hat
	lastClothingCount.hair = clothingCount.hair
	lastClothingCount.chest = clothingCount.chest
	lastClothingCount.legs = clothingCount.legs
	lastClothingCount.foot = clothingCount.foot
	lastClothingCount.glasses = clothingCount.glasses
	if myGender and myGender == "male" then
		guiRadioButtonSetSelected(GUISelector.radiobutton[1], true)
	elseif myGender and myGender == "female" then
		guiRadioButtonSetSelected(GUISelector.radiobutton[2], true)
	end
	if (lastskin == 0) then
		for i = 0, 17 do
			local texture, model = getPedClothes(lastPedElement, i)
			if texture and model then
				table.insert(oldClothes, {texture, model, i})
			end
		end
	else
		enableChangeButtonClothes(false) 
	end
end

function changeCJClothes()
	-- Hats.
	local clicked, index, cloth, tableClothes = false, false, false, false
	if source == GUISelector.button[3] then
		clothingCount.hat = clothingCount.hat - 1
		if clothingCount.hat < 0 then
			clothingCount.hat = #gameplayVariables["clothingTable"]["Hats"]
		end
		index = clothingCount.hat
		cloth = 16
		clicked = true
		tableClothes = gameplayVariables["clothingTable"]["Hats"][index]
		guiSetText(GUISelector.label[8], tostring(index))
	end
	if source == GUISelector.button[9] then
		clothingCount.hat = clothingCount.hat + 1
		if clothingCount.hat > #gameplayVariables["clothingTable"]["Hats"] then
			clothingCount.hat = 0
		end
		index = clothingCount.hat
		cloth = 16
		clicked = true
		tableClothes = gameplayVariables["clothingTable"]["Hats"][index]
		guiSetText(GUISelector.label[8], tostring(index))
	end
	--
	-- Hair.
	if source == GUISelector.button[4] then
		clothingCount.hair = clothingCount.hair - 1
		if clothingCount.hair < 0 then
			clothingCount.hair = #gameplayVariables["clothingTable"]["Hair"]
		end
		index = clothingCount.hair
		cloth = 1
		clicked = true
		tableClothes = gameplayVariables["clothingTable"]["Hair"][index]
		guiSetText(GUISelector.label[9], tostring(index))
	end
	if source == GUISelector.button[10] then
		clothingCount.hair = clothingCount.hair + 1
		if clothingCount.hair > #gameplayVariables["clothingTable"]["Hair"] then
			clothingCount.hair = 0
		end
		index = clothingCount.hair
		cloth = 1
		clicked = true
		tableClothes = gameplayVariables["clothingTable"]["Hair"][index]
		guiSetText(GUISelector.label[9], tostring(index))
	end
	--
	-- Chest.
	if source == GUISelector.button[5] then
		clothingCount.chest = clothingCount.chest - 1
		if clothingCount.chest < 0 then
			clothingCount.chest = #gameplayVariables["clothingTable"]["Chest"]
		end
		index = clothingCount.chest
		cloth = 0
		clicked = true
		tableClothes = gameplayVariables["clothingTable"]["Chest"][index]
		guiSetText(GUISelector.label[10], tostring(index))
	end
	if source == GUISelector.button[11] then
		clothingCount.chest = clothingCount.chest + 1
		if clothingCount.chest > #gameplayVariables["clothingTable"]["Chest"] then
			clothingCount.chest = 0
		end
		index = clothingCount.chest
		cloth = 0
		clicked = true
		tableClothes = gameplayVariables["clothingTable"]["Chest"][index]
		guiSetText(GUISelector.label[10], tostring(index))
	end
	--
	-- Legs.
	if source == GUISelector.button[6] then
		clothingCount.legs = clothingCount.legs - 1
		if clothingCount.legs < 0 then
			clothingCount.legs = #gameplayVariables["clothingTable"]["Legs"]
		end
		index = clothingCount.legs
		cloth = 2
		clicked = true
		tableClothes = gameplayVariables["clothingTable"]["Legs"][index]
		guiSetText(GUISelector.label[11], tostring(index))
	end
	if source == GUISelector.button[12] then
		clothingCount.legs = clothingCount.legs + 1
		if clothingCount.legs > #gameplayVariables["clothingTable"]["Legs"] then
			clothingCount.legs = 0
		end
		index = clothingCount.legs
		cloth = 2
		clicked = true
		tableClothes = gameplayVariables["clothingTable"]["Legs"][index]
		guiSetText(GUISelector.label[11], tostring(index))
	end
	--
	-- Shoes.
	if source == GUISelector.button[7] then
		clothingCount.foot = clothingCount.foot - 1
		if clothingCount.foot < 0 then
			clothingCount.foot = #gameplayVariables["clothingTable"]["Foot"]
		end
		index = clothingCount.foot
		cloth = 3
		clicked = true
		tableClothes = gameplayVariables["clothingTable"]["Foot"][index]
		guiSetText(GUISelector.label[12], tostring(index))
	end
	if source == GUISelector.button[13] then
		clothingCount.foot = clothingCount.foot + 1
		if clothingCount.foot > #gameplayVariables["clothingTable"]["Foot"] then
			clothingCount.foot = 0
		end
		index = clothingCount.foot
		cloth = 3
		clicked = true
		tableClothes = gameplayVariables["clothingTable"]["Foot"][index]
		guiSetText(GUISelector.label[12], tostring(index))
	end
	--
	-- Shoes.
	if source == GUISelector.button[8] then
		clothingCount.glasses = clothingCount.glasses - 1
		if clothingCount.glasses < 0 then
			clothingCount.glasses = #gameplayVariables["clothingTable"]["Glasses"]
		end
		index = clothingCount.glasses
		cloth = 15
		clicked = true
		tableClothes = gameplayVariables["clothingTable"]["Glasses"][index]
		guiSetText(GUISelector.label[13], tostring(index))
	end
	if source == GUISelector.button[14] then
		clothingCount.glasses = clothingCount.glasses + 1
		if clothingCount.glasses > #gameplayVariables["clothingTable"]["Glasses"] then
			clothingCount.glasses = 0
		end
		index = clothingCount.glasses
		cloth = 15
		clicked = true
		tableClothes = gameplayVariables["clothingTable"]["Glasses"][index]
		guiSetText(GUISelector.label[13], tostring(index))
	end	
	
	if clicked then
		if index > 0 then
			local texture, model = tableClothes[1], tableClothes[2]
			addPedClothes(lastPedElement, texture, model, cloth)
		else
			removePedClothes(lastPedElement, cloth)
		end
	end
end
addEventHandler("onClientGUIClick", resourceRoot, changeCJClothes)

function setUITableComponentVisible(bool)
	for index, button in pairs(uiTable) do
		guiSetVisible(button, bool)
	end
end

function startGame()
	local selectedClothes = {}
		
	if getElementModel(lastPedElement) == 0 then
		for index = 0, 17 do
			local texture, model = getPedClothes(lastPedElement, index)
			if texture and model then
				table.insert(selectedClothes, {texture, model, index})
			end
		end
		
		local hatText, hatModel = getPedClothes(lastPedElement, 16)
		local hairText, hairModel = getPedClothes(lastPedElement, 1)
		setElementData(localPlayer, "CJHeadWearing", {{hatText, hatModel}, {hairText, hairModel}})
	end

	setTimer(function(selectedClothes)
		triggerServerEvent("onPlayerStartDayZGame", localPlayer, getElementModel(lastPedElement), selectedClothes, myGender)
		
		if isElement(weaponBackObject) then
			destroyElement(weaponBackObject)
		end
		if isElement(backpackObject) then
			destroyElement(backpackObject)
		end
		
		destroyElement(lastPedElement)
		
		backpackObject = nil
		weaponBackObject = nil
		lastPedElement = nil
		selectedClothes = nil
		lastBackpack = nil
		lastWeapon = nil
	end, 4000, 1, selectedClothes)

	setUITableComponentVisible(false)
	stopSound(dayzSoundtrack)
	setPlayerLoadScreen(true)
	showCursor(false)
end

function createButton(x, y, w, h, text, relative, gui)
	local btn = guiCreateStaticImage(x, y, w, h, "images/misc/background_button.png", relative, gui)
	local label = guiCreateLabel(0.00, 0.00, 1.00, 1.00, text, true, btn)
	setElementData(btn, "button_label", label, false)
	setElementData(btn, "isLobbyButton", true, false)
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	guiSetProperty(label, "Disabled", "True")
	guiSetFont(label, buttonFont)
	return btn
end

function cursorInLobbyButton()
	if not getElementData(source, "isLobbyButton") == true then return end
	local label = getElementData(source, "button_label")
	if label then
		guiLabelSetColor(label, 255, 0, 0)
		setSoundVolume(playSound("sounds/misc/button_hover.mp3"), 0.2)
	end
end
addEventHandler("onClientMouseEnter", resourceRoot, cursorInLobbyButton) 

function cursorOutOfLobbyButton()
	if not getElementData(source, "isLobbyButton") == true then return end
	local label = getElementData(source, "button_label")
	if label then
		guiLabelSetColor(label, 255, 255, 255)
	end
end
addEventHandler("onClientMouseLeave", resourceRoot, cursorOutOfLobbyButton) 