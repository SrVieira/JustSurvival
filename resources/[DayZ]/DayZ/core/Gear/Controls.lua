local screenW, screenH = guiGetScreenSize()
local relX, relY = screenW / 800, screenH / 600
local headerFont = dxCreateFont("fonts/teko_medium.ttf", 46)
local isVisible = false
local controlInfo = ""
local backgroundBlur

keyLabel = {}
keyLabel["F1"] = {guiCreateLabel(84, 124, 50, 49, "", false), "Menu de grupos"}
keyLabel["F3"] = {guiCreateLabel(201, 124, 50, 49, "", false), "Controles del servidor"}
keyLabel["F4"] = {guiCreateLabel(259, 124, 50, 49, "", false), "Menu de puntajes"}
keyLabel["F9"] = {guiCreateLabel(548, 124, 50, 49, "", false), "Menu de ayuda"}
keyLabel["F11"] = {guiCreateLabel(665, 124, 50, 49, "", false), "Abrir / Cerrar mapa"}
keyLabel["1"] = {guiCreateLabel(84, 197, 50, 49, "", false), "Usar item #1 en la barra de atajos"}
keyLabel["2"] = {guiCreateLabel(142, 197, 50, 49, "", false), "Usar item #2 en la barra de atajos"}
keyLabel["3"] = {guiCreateLabel(201, 197, 50, 49, "", false), "Usar item #3 en la barra de atajos"}
keyLabel["4"] = {guiCreateLabel(259, 197, 50, 49, "", false), "Usar item #4 en la barra de atajos"}
keyLabel["5"] = {guiCreateLabel(316, 197, 50, 49, "", false), "Usar item #5 en la barra de atajos"}
keyLabel["6"] = {guiCreateLabel(374, 197, 50, 49, "", false), "Usar item #6 en la barra de atajos"}
keyLabel["7"] = {guiCreateLabel(433, 197, 50, 49, "", false), "Sentarse"}
keyLabel["8"] = {guiCreateLabel(491, 197, 50, 49, "", false), "Manos arriba"}
keyLabel["9"] = {guiCreateLabel(548, 197, 50, 49, "", false), "Saludar"}
keyLabel["0"] = {guiCreateLabel(606, 197, 50, 49, "", false), "Bailar"}
keyLabel["U"] = {guiCreateLabel(433, 254, 50, 49, "", false), "Chat Global"}
keyLabel["I"] = {guiCreateLabel(490, 254, 50, 49, "", false), "Activar / Desactivar vision infra-roja"}
keyLabel["K"] = {guiCreateLabel(490, 311, 50, 49, "", false), "Encender / Apagar motor del vehiculo"}
keyLabel["M"] = {guiCreateLabel(490, 368, 50, 49, "", false), "Cuerpo a tierra"}
keyLabel["N"] = {guiCreateLabel(432, 368, 50, 49, "", false), "Activar / Desactivar vision nocturna"}
keyLabel["-"] = {guiCreateLabel(666, 368, 50, 49, "", false), "Seleccionar opcion del menu izquierdo"}

function setKeyInfo()
	controlInfo = tostring(keyLabel[getElementData(source, "infoKey")][2])
end

function removeKeyInfo()
	controlInfo = ""
end

for key, label in pairs(keyLabel) do
	local x, y = guiGetPosition(label[1], false)
	guiSetPosition(label[1], relX*x, relY*y, false)
	setElementData(label[1], "infoKey", key, false)
	addEventHandler("onClientMouseEnter", label[1], setKeyInfo)
	addEventHandler("onClientMouseLeave", label[1], removeKeyInfo)
	guiSetEnabled(label[1], false)
end

function isControlMenuActive()
	return isVisible
end

function showControls()
	if not getElementData(localPlayer, "Logged") then return end
	if getElementData(localPlayer, "dead") then return end
	if isMapOpened() then return end
	if isInventoryVisible() then return end

	if isVisible then
		closeMenuControls()
	else
		showMenuControls()
		
	end
end
bindKey("F3", "down", showControls)

function drawControls()
	local x, y = screenW / 2 - 400, screenH / 2 - 183
	dxDrawText("CONTROLES", 0, y - 45, screenW, y - 45, tocolor(255, 255, 255, 255), 1, headerFont, "center", "center")
	dxDrawImage(x, y, 800, 366, "images/misc/kboard.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawText(controlInfo, 0, y + 383, screenW, y + 383, tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "center")
end

function showMenuControls()
	for _, label in pairs(keyLabel) do
		--guiSetEnabled(label[1], true)
	end
	backgroundBlur = createBlurBox(0, 0, screenW, screenH, 100, 100, 100, 255, false)
	addEventHandler("onClientRender", root, drawControls, true, "low-6.0")
	showCursor(true)
	isVisible = true
end

function closeMenuControls()
	if isVisible then
		for _, label in pairs(keyLabel) do
			guiSetEnabled(label[1], false)
		end
		removeEventHandler("onClientRender", root, drawControls)
		destroyBlurBox(backgroundBlur)
		backgroundBlur = nil
		isVisible = false
		showCursor(false)
		removeKeyInfo()
	end
end
addEventHandler("onClientPlayerWasted", localPlayer, closeMenuControls)