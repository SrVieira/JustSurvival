--[[
	##
	##
	##	``DayZ Login Panel´´
	##
	##	Author: Enargy
	##	File: client.lua
	##	Type: client
	##
	##
]]

local sX, sY = guiGetScreenSize()
local messageData = {}
local tick = getTickCount()
local inLogin = true
local loginComponents = {}
local registerComponents = {}
local spinrot = 0
local isLogin
local font = {
	--[1] = dxCreateFont("font/better_together.ttf", 16),
	[1] = dxCreateFont("font/teko_medium.ttf", 20),
}

addEvent("onClientDXButtonClick", true)

function initDayZLogin()
	--if not getElementData(localPlayer, "Logeado") then
		addEventHandler("onClientRender", root, displayLogin)
		showChat(false)
		showCursor(true)
		initLogin()
	--end
end
addEvent("DayZ_LoginPanel", true)
addEventHandler("DayZ_LoginPanel", root, initDayZLogin)
--addEventHandler("onClientResourceStart", resourceRoot, initDayZLogin)

function initLogin()
	local userEdit = dxCreateEdit(sX / 2 - 108, sY * 0.4375, 217, 34, "", "Nombre de usuario", {150, 0, 0, 200}, false, false, true)
	local passEdit = dxCreateEdit(sX / 2 - 108, sY * 0.4973958333333333, 217, 34, "", "Contraseña", {150, 0, 0, 200}, true, false, true)
	local login = dxCreateButton(sX / 2 - 108, sY * 0.6888020833333333, 217, 34, "LOGIN", false, false, {50, 50, 50, 200}, true, 1, font[1], nil)
	local register = dxCreateButton(sX / 2 - 108, sY * 0.7526041666666667, 217, 34, "CREAR CUENTA", false, false, {50, 50, 50, 200}, true, 1, font[1], nil)

	if not fileExists("save.xml") then
		local settings = xmlCreateFile("save.xml","myAccount")
		local Username = xmlCreateChild(settings,"username")
		local Password = xmlCreateChild(settings,"password")
		xmlSaveFile(settings)
	end
	local node = xmlLoadFile ("save.xml")
	local Username = xmlFindChild(node,"username",0)
	local Password = xmlFindChild(node,"password",0)
	local pass = xmlNodeGetValue(Password)
	local usern = xmlNodeGetValue(Username)
	if usern == "none" or usern == "" then
		dxSetText(userEdit, "")
		dxSetText(passEdit, "")
	else
		dxSetText(userEdit, tostring(usern))
		dxSetText(passEdit, tostring(pass))
	end
	xmlUnloadFile(node)
	
	table.insert(loginComponents, {userEdit, passEdit, login, register})
		
	addEventHandler("onClientDXButtonClick", login, onClientLogInAttempt, false)
	addEventHandler("onClientDXButtonClick", register, onClientShowRegister, false)
	
	isLogin = true
end

function onClientLogInAttempt()
	local username = dxGetText(loginComponents[1][1])
	local password = dxGetText(loginComponents[1][2])
	if (#username == 0) then
		onClientLoginNotification("Escribe una cuenta existente", "error")
		return
	elseif (#password == 0) then
		onClientLoginNotification("Escribe una contraseña válida", "error")
		return
	end

	triggerServerEvent("onLoginPlayer", localPlayer, username, password)
end

function onClientShowRegister()
	destroyLoginUI()
	initRegister()
end

function destroyLoginUI()
	for index, value in ipairs(loginComponents[1])  do
		dxDestroy(value)
	end
	loginComponents = {}
end

function destroyRegisterUI()
	for index, value in ipairs(registerComponents[1])  do
		dxDestroy(value)
	end
	registerComponents = {}
end

function initRegister()
	local userEdit = dxCreateEdit(sX / 2 - 108, sY * 0.4375, 217, 34, "", "Nombre de usuario", {150, 0, 0, 200}, false, false, true)
	local passEdit = dxCreateEdit(sX / 2 - 108, sY * 0.4973958333333333, 217, 34, "", "Contraseña", {150, 0, 0, 200}, true, false, true)
	local confPassEdit = dxCreateEdit(sX / 2 - 108, sY * 0.5572916666666667, 217, 36, "", "Confirmar contraseña", {150, 0, 0, 200}, true, false, true)
	local cancel = dxCreateButton(sX / 2 - 108, sY * 0.6888020833333333, 217, 34, "CANCELAR", false, false, {50, 50, 50, 200}, true, 1, font[1], nil)
	local create = dxCreateButton(sX / 2 - 108, sY * 0.7526041666666667, 217, 34, "CREAR CUENTA", false, false, {50, 50, 50, 200}, true, 1, font[1], nil)

	table.insert(registerComponents, {userEdit, passEdit, confPassEdit, cancel, create})
		
	addEventHandler("onClientDXButtonClick", cancel, onClientRegisterCancelled, false)
	addEventHandler("onClientDXButtonClick", create, onClientRequestNewAccount, false)
	
	isLogin = false
end

function onClientRegister()
	destroyLoginUI()
	initRegister()
end

function onClientRegisterCancelled()
	destroyRegisterUI()
	initLogin()
end

function onClientRequestNewAccount()
	local username = dxGetText(registerComponents[1][1])
	local password = dxGetText(registerComponents[1][2])
	local confpassword = dxGetText(registerComponents[1][3])
	if (#username == 0) then
		onClientLoginNotification("Debes escribir el nombre para la cuenta", "error")
		return
	elseif (#password == 0) then
		onClientLoginNotification("Debes escribir una contraseña para la cuenta", "error")
		return
	elseif (#password == 0) then
		onClientLoginNotification("Debes comprobar la contraseña para la cuenta", "error")
		return
	elseif password ~= confpassword then
		onClientLoginNotification("Las contraseñas deben coincidir", "error")
		return			
	end
	triggerServerEvent("onRegisterPlayer", localPlayer, username, password)
end

function displayLogin()
	dxDrawImage(0, 0, sX, sY, "img/background.jpg", 0, 0, 0, tocolor(255, 255, 255, 255), false)

	if messageData.text ~= nil then
		local color = tocolor(255, 255, 255, 255)
		if messageData.type == "successfully" then
			color = tocolor(0, 255, 0, 255)
		elseif messageData.type == "error" then
			color = tocolor(255, 0, 0, 255)
		end
		
		dxDrawText(messageData.text, 1, (sY * 0.8828125) + 1, sX, (sY * 0.8828125) + 1, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center")
		dxDrawText(messageData.text, 0, sY * 0.8828125, sX, sY * 0.8828125, color, 1, "default-bold", "center", "center")
		if getTickCount() > messageData.currentTick then
			messageData = {}
		end
	end
end

function onClientRegistrationFinish(accountName)
	onClientRegisterCancelled()
	onClientLoginNotification("Tu cuenta '"..accountName.."' fue creada exitosamente", "successfully")
end
addEvent("onRegisterGUIClose", true)
addEventHandler("onRegisterGUIClose", root, onClientRegistrationFinish)

function onClientLoginSuccessfully(username, password)
	showCursor(false)
	destroyLoginUI()
	removeEventHandler("onClientRender", root, displayLogin)
	
	local node = xmlLoadFile ("save.xml")
	local usernameNode = xmlFindChild(node,"username",0)
	local passwordNode = xmlFindChild(node,"password",0)
	xmlNodeSetValue(usernameNode,username)
	xmlNodeSetValue(passwordNode,password)
	xmlSaveFile(node)	
	xmlUnloadFile(node)
end
addEvent("onLoginGUIClose", true)
addEventHandler("onLoginGUIClose", root, onClientLoginSuccessfully)

function onClientLoginNotification(message, theType)
	messageData.text = message
	messageData.type = theType
	messageData.currentTick = getTickCount() + 2000
end
addEvent("onClientLoginNotifyFromServer", true)
addEventHandler("onClientLoginNotifyFromServer", root, onClientLoginNotification)