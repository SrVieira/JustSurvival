x,y = guiGetScreenSize()
local buttonsSystem = {}
local tableSight = {
	{"Crosshair #1","images/1.png"},
	{"Crosshair #2","images/2.png"},
	{"Crosshair #3","images/3.png"},
	{"Crosshair #4","images/4.png"},
	{"Crosshair #5","images/5.png"},
	{"Crosshair #6","images/6.png"},
	{"Crosshair #7","images/7.png"},
	{"Crosshair #8","images/8.png"},
	{"Crosshair #9","images/9.png"},
	{"Crosshair #10","images/10.png"},
	{"Crosshair #11","images/11.png"},
	{"Crosshair #12","images/12.png"},
	{"Crosshair #13","images/13.png"},
	{"Crosshair #14","images/14.png"},
}
	
buttonElements = {}

function createSettingsWindow()
	playerSettingsWindow = guiCreateWindow((x/2)-(375/2), (y/2)-(255/2), 375, 255, "Panel de miras", false)
    guiWindowSetSizable(playerSettingsWindow, false)

    playerSettingsTab = guiCreateTabPanel(10, 30, 400, 215, false, playerSettingsWindow)
	crosshairSettings = guiCreateTab("Crosshair", playerSettingsTab)
	buttonsSystem["GRIDLIST"] = guiCreateGridList(8, 10, 240, 173, false,crosshairSettings)
	buttonsSystem["COLUMN"] = guiGridListAddColumn(buttonsSystem["GRIDLIST"], "Selecciona una mira:", 0.7)
	buttonsSystem["STATICIMAGE"] = guiCreateStaticImage(267, 32, 64, 64, "images/false.png", false,crosshairSettings)
	buttonsSystem["BUTTON"] = guiCreateButton(266, 106, 65, 32, "Escoger", false,crosshairSettings)
	Reinicio = guiCreateButton(266, 142, 65, 32, "Reiniciar", false,crosshairSettings)
	guiSetVisible(playerSettingsWindow,false)
	
	addEventHandler ( "onClientGUIClick",buttonsSystem["BUTTON"], function()
		local selectsight = guiGridListGetItemText(buttonsSystem["GRIDLIST"],guiGridListGetSelectedItem(buttonsSystem["GRIDLIST"]),1)
		for _, data in ipairs(tableSight) do
			if data[1] == selectsight then
				setElementData(getLocalPlayer(),"sight",data[2])
				showPlayerSettingsWindow()
				break
			end
		end	
	end)
	
	addEventHandler("onClientGUIClick", Reinicio, function()
		if getElementData(localPlayer, 'sight') then
			setElementData(localPlayer, 'sight', false)
			engineRemoveShaderFromWorldTexture(Crosshair_table, "siteM16")
			outputChatBox("Mira reiniciada!", 0, 255, 0)
			showCursor(false)
			guiSetVisible(playerSettingsWindow, false) 
		end
	end)
	
	addEventHandler ( "onClientGUIClick",buttonsSystem["GRIDLIST"], function()
		local selectsight = guiGridListGetItemText(buttonsSystem["GRIDLIST"],guiGridListGetSelectedItem(buttonsSystem["GRIDLIST"]),1)
		for _, data in ipairs(tableSight) do
			if data[1] == selectsight then
				guiStaticImageLoadImage(buttonsSystem["STATICIMAGE"], data[2])
				break
			end
		end	
	end)
	
	for _, data in ipairs(tableSight) do
		local row = guiGridListAddRow(buttonsSystem["GRIDLIST"])
		guiGridListSetItemText(buttonsSystem["GRIDLIST"],row,1,data[1],false,false)
	end
end
addEventHandler ( "onClientResourceStart", getResourceRootElement (), createSettingsWindow )
		
function showPlayerSettingsWindow ()
	if guiGetVisible (playerSettingsWindow) then
		showCursor(false)
		guiSetVisible(playerSettingsWindow, false) 
	else
		showCursor(true)
		guiSetVisible(playerSettingsWindow, true) 
	end
end
bindKey ( "F7", "down", showPlayerSettingsWindow )	

bindKey("mouse2","down",function()
	Crosshair_table = {}
	if getElementData(getLocalPlayer(),"sight") then
		if oldSight and oldSight == getElementData(getLocalPlayer(),"sight") then
			return 
		end	
		default = dxCreateTexture(getElementData(getLocalPlayer(),"sight"))
		oldSight = getElementData(getLocalPlayer(),"sight")
		Crosshair_table = dxCreateShader("texreplace.fx")
		engineApplyShaderToWorldTexture(Crosshair_table, "siteM16")
		dxSetShaderValue(Crosshair_table, "gTexture", default)
	end	
end)		