---------------------------------------------------------------------
--  Desarrollador/Developer: -Rex-
--  Proyecto/Proyect:        N/A
--  Contacto/Contact:        https://www.facebook.com/rexscripting/
--
--  Libre uso y modificacion, No borrar los creditos, Gracias
---------------------------------------------------------------------
notyfy = {
button = {},
window = {},
label = {}
}

notyfy.window[1] = guiCreateWindow(470, 241, 341, 105, "Notificacion", false)
guiWindowSetSizable(notyfy.window[1], false)

notyfy.label[1] = guiCreateLabel(10, 36, 321, 29, "Esta es una advertencia", false, notyfy.window[1])
guiLabelSetHorizontalAlign(notyfy.label[1], "center", true)
guiLabelSetVerticalAlign(notyfy.label[1], "center")
notyfy.button[1] = guiCreateButton(143, 79, 54, 17, "Ok", false, notyfy.window[1])
guiSetFont(notyfy.button[1], "default-bold-small")    
centerWindow ( notyfy.window[1] )
guiSetVisible ( notyfy.window[1], false )


function createNotification( mensaje )
    centerWindow ( notyfy.window[1] )
    guiSetText( notyfy.label[1], mensaje )
    guiBringToFront ( notyfy.window[1] )
    guiSetVisible ( notyfy.window[1], true )
end

function clickNotify(  )

    if source == notyfy.button[1] then
        guiSetVisible ( notyfy.window[1], false )
    end

end
addEventHandler("onClientGUIClick", root, clickNotify )

function serverNotify( mensaje )
    createNotification( mensaje )
end
addEvent("NClient",true)
addEventHandler("NClient",getLocalPlayer(),serverNotify)


RSystem = {
    button = {},
    window = {},
    edit = {},
    label = {}
}
RSystem.window[1] = guiCreateWindow(471, 233, 352, 119, "Razón", false)
guiWindowSetSizable(RSystem.window[1], false)

RSystem.label[1] = guiCreateLabel(10, 31, 141, 16, "Escribe una razón", false, RSystem.window[1])
guiSetFont(RSystem.label[1], "default-bold-small")
RSystem.edit[1] = guiCreateEdit(10, 51, 332, 30, "", false, RSystem.window[1])
guiEditSetMaxLength( RSystem.edit[1], 50 )
RSystem.button[1] = guiCreateButton(216, 92, 61, 17, "Listo", false, RSystem.window[1])
guiSetFont(RSystem.button[1], "default-bold-small")
RSystem.button[2] = guiCreateButton(281, 92, 61, 17, "X", false, RSystem.window[1])
guiSetFont(RSystem.button[2], "default-bold-small")
RSystem.label[2] = guiCreateLabel(10, 99, 184, 18, "Jugador: Rexito-", false, RSystem.window[1])
guiSetFont(RSystem.label[2], "default-small")
centerWindow ( RSystem.window[1] )
guiSetVisible ( RSystem.window[1], false )


local temporalNick
function showRS( playerNick )
	
	if playerNick then
		guiSetVisible( guiconfiggp, false)
		temporalNick = playerNick
		guiSetText( RSystem.label[2], "Jugador "..temporalNick )
		guiSetVisible ( RSystem.window[1], true )
		guiBringToFront( RSystem.window[1] )
		centerWindow ( RSystem.window[1] )
	end

end

function clicksRS(  )
	

	if source == RSystem.button[1] then

		if temporalNick then

			local razon = guiGetText( RSystem.edit[1] )

			if razon:len( ) >= 2 then
				triggerServerEvent("kickamemberoption",getLocalPlayer(), temporalNick, razon )
	    		guiGridListClear(gridlistconfigmv)
	    		triggerServerEvent("getcdtgroup",getLocalPlayer())
	    		triggerServerEvent("getdatasgroup",getLocalPlayer(  ))
	    		guiSetEnabled( kickmembersb, false )
	    		setTimer( guiSetEnabled, 3000, 1, kickmembersb, true )
				guiSetVisible ( RSystem.window[1], false )
				guiSetVisible( guiconfiggp, true)
				temporalNick = nil
			else
				createNotification( "Razón muy corta!" )
			end

		end

	elseif source == RSystem.button[2] then
		temporalNick = nil
		guiSetVisible ( RSystem.window[1], false )
		guiSetVisible( guiconfiggp, true)
	end

end
addEventHandler("onClientGUIClick", root, clicksRS )



Confirm = {
    button = {},
    window = {},
    label = {}
}
Confirm.window[1] = guiCreateWindow(498, 243, 338, 105, "Advertencia", false)
guiWindowSetSizable(Confirm.window[1], false)

Confirm.label[1] = guiCreateLabel(10, 38, 318, 18, "¿Estás seguro que deseas salir?", false, Confirm.window[1])
guiSetFont(Confirm.label[1], "default-bold-small")
guiLabelSetHorizontalAlign(Confirm.label[1], "center", false)
Confirm.button[1] = guiCreateButton(93, 75, 76, 20, "Si", false, Confirm.window[1])
guiSetFont(Confirm.button[1], "default-bold-small")
Confirm.button[2] = guiCreateButton(179, 75, 76, 20, "No", false, Confirm.window[1])
guiSetFont(Confirm.button[2], "default-bold-small")
centerWindow ( Confirm.window[1] )
guiSetVisible ( Confirm.window[1], false )


function ClicksC(  )
	
	if source == Confirm.button[1] then
		guiSetVisible ( Confirm.window[1], false )
		triggerServerEvent("leaveofgroup",getLocalPlayer(  ))
    	guiSetVisible ( guiconfiggp, false)
    	guiSetVisible(grouppanel,true )
    	triggerServerEvent("getdatasgroup",getLocalPlayer(  ))
    	guiSetText( editcrgp, "")
	elseif source == Confirm.button[2] then
		guiSetVisible ( Confirm.window[1], false )
	end

end
addEventHandler("onClientGUIClick", root, ClicksC )