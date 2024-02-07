---------------------------------------------------------------------
--  Desarrollador/Developer: -Rex-
--  Proyecto/Proyect:        N/A
--  Contacto/Contact:        https://www.facebook.com/rexscripting/
--
--  Libre uso y modificacion, No borrar los creditos, Gracias
---------------------------------------------------------------------

GUIEditor = {
    label = {}
}

function centerWindow (center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    guiSetPosition(center_window, x, y, false)
end
        

        grouppanel = guiCreateWindow(412, 195, 405, 240, "Panel de grupos", false)
        guiWindowSetSizable(grouppanel, false)

        editcrgp = guiCreateEdit(11, 45, 220, 32, "", false, grouppanel)
        label1 = guiCreateLabel(12, 24, 109, 17, "Crear nuevo grupo:", false, grouppanel)
        guiSetFont(label1, "default-bold-small")
        creategpb = guiCreateButton(241, 45, 69, 33, "Crear", false, grouppanel)
        guiSetFont(creategpb, "default-bold-small")
        guiSetProperty(creategpb, "NormalTextColour", "FFAAAAAA")
        actualizgrplabel = guiCreateLabel(12, 87, 300, 17, "Grupo actual: ", false, grouppanel)
        guiSetFont(actualizgrplabel, "default-bold-small")
        invt = guiCreateButton(12, 114, 185, 25, "Mis invitaciones", false, grouppanel)
        guiSetFont(invt, "default-bold-small")
        guiSetProperty(invt, "NormalTextColour", "FFAAAAAA")
        grouplistb = guiCreateButton(207, 114, 185, 25, "Lista de grupos", false, grouppanel)
        guiSetFont(grouplistb, "default-bold-small")
        guiSetProperty(grouplistb, "NormalTextColour", "FFAAAAAA")
        infogp = guiCreateButton(12, 149, 185, 25, "Información del grupo", false, grouppanel)
        guiSetFont(infogp, "default-bold-small")
        guiSetProperty(infogp, "NormalTextColour", "FFAAAAAA")
        gpmoney = guiCreateButton(207, 149, 185, 25, "Salir del grupo", false, grouppanel)
        guiSetFont(gpmoney, "default-bold-small")
        guiSetProperty(gpmoney, "NormalTextColour", "FFAAAAAA")
        members = guiCreateButton(12, 184, 185, 25, "Miembros", false, grouppanel)
        guiSetFont(members, "default-bold-small")
        guiSetProperty(members, "NormalTextColour", "FFAAAAAA")
        configgp = guiCreateButton(207, 184, 185, 25, "Administrar grupo", false, grouppanel)
        guiSetFont(configgp, "default-bold-small")
        guiSetProperty(configgp, "NormalTextColour", "FFAAAAAA")
        newclose = guiCreateButton(330, 215, 62, 15, "Cerrar", false, grouppanel)
        guiSetFont(newclose, "default-bold-small")
        guiSetProperty(newclose, "NormalTextColour", "FFBABABA")    

     guiSetVisible(grouppanel,false)
      centerWindow(grouppanel)


        infopanelg = guiCreateWindow(10, 45, 378, 323, "Informacion", false)
        guiWindowSetSizable(infopanelg, false)

        memoinfogp = guiCreateMemo(9, 25, 359, 254, "", false, infopanelg)
        guiMemoSetReadOnly(memoinfogp, true)
		
        closebinfo = guiCreateButton(292, 287, 71, 27, "Cerrar", false, infopanelg)
        guiSetFont(closebinfo, "default-bold-small")
        guiSetProperty(closebinfo, "NormalTextColour", "FFAAAAAA")

     guiSetVisible(infopanelg,false)
centerWindow (infopanelg)


        gplistgw = guiCreateWindow(961, 0, 309, 324, "Lista de grupos", false)
        guiWindowSetSizable(gplistgw, false)

        gridlistgps = guiCreateGridList(13, 33, 284, 225, false, gplistgw)
        namegpl = guiGridListAddColumn(gridlistgps, "Nombre del grupo", 0.5)
        membgpl = guiGridListAddColumn(gridlistgps, "Miembros", 0.4)
        cerrarglgps = guiCreateButton(228, 282, 71, 32, "Cerrar", false, gplistgw)
        guiSetFont(cerrarglgps, "default-bold-small")
        guiSetProperty(cerrarglgps, "NormalTextColour", "FFAAAAAA")
     guiSetVisible(gplistgw,false)
centerWindow (gplistgw)
       
guiconfiggp = guiCreateWindow(386, 113, 420, 367, "Configuración", false)
guiWindowSetSizable(guiconfiggp, false)

gridlistconfigmv = guiCreateGridList(14, 34, 392, 200, false, guiconfiggp)
namecol = guiGridListAddColumn(gridlistconfigmv, "Nick", 0.4)
acccol = guiGridListAddColumn(gridlistconfigmv, "Ult. Activo", 0.25)
rangcol = guiGridListAddColumn(gridlistconfigmv, "Rango", 0.3)
--statecol = guiGridListAddColumn(gridlistconfigmv, "Estado", 0.2)
kickmembersb = guiCreateButton(24, 244, 81, 30, "Expulsar", false, guiconfiggp)
guiSetFont(kickmembersb, "default-bold-small")
guiSetProperty(kickmembersb, "NormalTextColour", "FFAAAAAA")
banmembers = guiCreateButton(118, 244, 81, 30, "Personalizar Chat", false, guiconfiggp)
guiSetFont(banmembers, "default-bold-small")
guiSetProperty(banmembers, "NormalTextColour", "FFAAAAAA")
promotemembers = guiCreateButton(214, 244, 81, 30, "Cambiar rangos", false, guiconfiggp)
guiSetFont(promotemembers, "default-bold-small")
guiSetProperty(promotemembers, "NormalTextColour", "FFAAAAAA")
buyslots = guiCreateButton(311, 244, 81, 30, "Mis Alianzas", false, guiconfiggp)
guiSetFont(buyslots, "default-bold-small")
guiSetProperty(buyslots, "NormalTextColour", "FFAAAAAA")
invnewmemb = guiCreateButton(24, 284, 81, 30, "Invitar Jugador", false, guiconfiggp)
guiSetFont(invnewmemb, "default-bold-small")
guiSetProperty(invnewmemb, "NormalTextColour", "FFAAAAAA")
editinfo = guiCreateButton(118, 284, 81, 30, "Editar informacion", false, guiconfiggp)
guiSetFont(editinfo, "default-bold-small")
guiSetProperty(editinfo, "NormalTextColour", "FFAAAAAA")
deletegp = guiCreateButton(214, 284, 81, 30, "Borrar grupo", false, guiconfiggp)
guiSetFont(deletegp, "default-bold-small")
guiSetProperty(deletegp, "NormalTextColour", "FFAAAAAA")
leavegroup = guiCreateButton(311, 284, 81, 30, "Administrar rangos", false, guiconfiggp)
guiSetFont(leavegroup, "default-bold-small")
guiSetProperty(leavegroup, "NormalTextColour", "FFAAAAAA")
logsOpen = guiCreateButton(24, 324, 81, 30, "Logs", false, guiconfiggp)
guiSetFont(logsOpen, "default-bold-small")
guiSetProperty(logsOpen, "NormalTextColour", "FFAAAAAA")

closeconfiggui = guiCreateButton(118, 324, 81, 30, "Cerrar", false, guiconfiggp)
guiSetFont(closeconfiggui, "default-bold-small")
guiSetProperty(closeconfiggui, "NormalTextColour", "FFAAAAAA")


loggui = guiCreateWindow(485, 129, 475, 377, "Logs", false)
guiWindowSetSizable(loggui, false)

memolog = guiCreateMemo(10, 29, 455, 322, "", false, loggui)
guiMemoSetReadOnly(memolog, true)
xlog = guiCreateButton(426, 351, 29, 17, "X", false, loggui)
guiSetFont(xlog, "default-bold-small")
guiSetProperty(xlog, "NormalTextColour", "FFFFFFFF")    

guiSetVisible( loggui, false )
centerWindow( loggui )

function OpenLog(  )
	guiSetText( memolog, "")
	triggerServerEvent( "getLogsGroup", getLocalPlayer(  ))
end
addEventHandler("onClientGUIClick", logsOpen, OpenLog, false)

function closeLLogs(  )
	guiSetVisible( loggui, false )
end
addEventHandler("onClientGUIClick", xlog, closeLLogs, false)

function memoSetLogs( texto )
	guiSetText( memolog, texto)
	guiBringToFront( loggui )
	guiSetVisible( loggui, true )
end
addEvent("memoLog",true)
addEventHandler("memoLog", getLocalPlayer(  ),memoSetLogs)

          guiSetVisible(guiconfiggp,false)
centerWindow (guiconfiggp)

        guiinfogpedit = guiCreateWindow(425, 104, 339, 317, "Editar información", false)
        guiWindowSetSizable(guiinfogpedit, false)

        memoinfoedit = guiCreateMemo(13, 32, 315, 226, "", false, guiinfogpedit)
        saveinfob = guiCreateButton(15, 271, 83, 34, "Guardar", false, guiinfogpedit)
        guiSetFont(saveinfob, "default-bold-small")
        guiSetProperty(saveinfob, "NormalTextColour", "FFAAAAAA")
        closeeditinfobt = guiCreateButton(108, 271, 83, 34, "Cerrar", false, guiinfogpedit)
        guiSetFont(closeeditinfobt, "default-bold-small")
        guiSetProperty(closeeditinfobt, "NormalTextColour", "FFAAAAAA")  
        guiSetVisible(guiinfogpedit,false)  
centerWindow (guiinfogpedit)
  
guiinviteplayer = guiCreateWindow(434, 118, 443, 381, "Invitar un nuevo juador", false)
guiWindowSetSizable(guiinviteplayer, false)

asdasd = guiCreateLabel(17, 34, 117, 15, "Lista de jugadores", false, guiinviteplayer)
guiSetFont(asdasd, "default-bold-small")
gridlistsendinv = guiCreateGridList(17, 59, 199, 312, false, guiinviteplayer)
plinvd = guiGridListAddColumn(gridlistsendinv, "Jugador", 0.8)
plyon = guiGridListAddColumn(gridlistsendinv, "Grupo", 0.2)
sendinvit = guiCreateButton(231, 69, 87, 34, "Mandar invitación", false, guiinviteplayer)
guiSetFont(sendinvit, "default-bold-small")
guiSetProperty(sendinvit, "NormalTextColour", "FFAAAAAA")
refreshlist = guiCreateButton(328, 69, 87, 34, "Actualizar lista", false, guiinviteplayer)
guiSetFont(refreshlist, "default-bold-small")
guiSetProperty(refreshlist, "NormalTextColour", "FFAAAAAA")
cerrapanelivn = guiCreateButton(231, 113, 87, 34, "Cerrar panel", false, guiinviteplayer)
guiSetFont(cerrapanelivn, "default-bold-small")
guiSetProperty(cerrapanelivn, "NormalTextColour", "FFAAAAAA")


        guiSetVisible(guiinviteplayer,false)  
        centerWindow (guiinviteplayer)

        promotegui = guiCreateWindow(461, 193, 439, 333, "Promover rango", false)
        guiWindowSetSizable(promotegui, false)

        aasdedd = guiCreateLabel(10, 30, 147, 17, "Selecciona el nuevo rango", false, promotegui)
        guiSetFont(aasdedd, "default-bold-small")
        boxpromote = guiCreateComboBox(10, 53, 214, 102, "", false, promotegui)

        promotebutton = guiCreateButton(20, 155, 75, 35, "Promover", false, promotegui)
        guiSetFont(promotebutton, "default-bold-small")
        guiSetProperty(promotebutton, "NormalTextColour", "FFAAAAAA")
        closepromotegui = guiCreateButton(139, 155, 75, 35, "Cerrar", false, promotegui)
        guiSetFont(closepromotegui, "default-bold-small")
        guiSetProperty(closepromotegui, "NormalTextColour", "FFAAAAAA")
        gridlistpromotepl = guiCreateGridList(237, 44, 190, 279, false, promotegui)
        plprompl = guiGridListAddColumn(gridlistpromotepl, "Miembro", 0.5)
        plrangpl = guiGridListAddColumn(gridlistpromotepl, "Rango", 0.5)    
        guiSetVisible( promotegui,false)  
        centerWindow ( promotegui )


        guicolor = guiCreateWindow(494, 252, 319, 134, "Color del grupo", false)
        guiWindowSetSizable(guicolor, false)

        GUIEditor.label[1] = guiCreateLabel(8, 27, 139, 17, "Escribe los colores R,G,B", false, guicolor)
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        editr = guiCreateEdit(34, 60, 43, 24, "", false, guicolor)
        guiEditSetMaxLength(editr, 3)
        GUIEditor.label[2] = guiCreateLabel(9, 64, 15, 14, "R:", false, guicolor)
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        editg = guiCreateEdit(94, 60, 43, 24, "", false, guicolor)
        guiEditSetMaxLength(editg, 3)
        editb = guiCreateEdit(153, 60, 43, 24, "", false, guicolor)
        guiEditSetMaxLength(editb, 3)
        GUIEditor.label[3] = guiCreateLabel(79, 64, 15, 14, "G:", false, guicolor)
        guiSetFont(GUIEditor.label[3], "default-bold-small")
        GUIEditor.label[4] = guiCreateLabel(138, 64, 15, 14, "B:", false, guicolor)
        guiSetFont(GUIEditor.label[4], "default-bold-small")
        GUIEditor.label[5] = guiCreateLabel(8, 94, 155, 17, "Ejemplo Color rojo: 255,0,0", false, guicolor)
        guiSetFont(GUIEditor.label[5], "default-bold-small")
        acepchangcolor = guiCreateButton(189, 100, 54, 24, "Aceptar", false, guicolor)
        guiSetFont(acepchangcolor, "default-bold-small")
        guiSetProperty(acepchangcolor, "NormalTextColour", "FFAAAAAA")
        cancelcolorclose = guiCreateButton(253, 100, 54, 24, "Cancelar", false, guicolor)
        guiSetFont(cancelcolorclose, "default-bold-small")
        guiSetProperty(cancelcolorclose, "NormalTextColour", "FFAAAAAA")   
        guiSetVisible( guicolor,false)  
        centerWindow ( guicolor ) 

        guimembersgp = guiCreateWindow(386, 113, 420, 287, "Miembros", false)
        guiWindowSetSizable(guimembersgp, false)

        gridmiemview = guiCreateGridList(14, 34, 392, 200, false, guimembersgp)
        plggm = guiGridListAddColumn(gridmiemview, "Nick", 0.4)
        plgac = guiGridListAddColumn(gridmiemview, "Ult. Activo", 0.25)
        plrac = guiGridListAddColumn(gridmiemview, "Rango", 0.3)
        --plstac = guiGridListAddColumn(gridmiemview, "Estado", 0.2)
        closemembgui = guiCreateButton(328, 244, 68, 33, "Cerrar", false, guimembersgp)
        guiSetFont(closemembgui, "default-bold-small")
        guiSetProperty(closemembgui, "NormalTextColour", "FFAAAAAA")
        guiSetVisible( guimembersgp,false)  
        centerWindow ( guimembersgp )     

        colorchangegui = guiCreateWindow(514, 189, 225, 252, "Colores del chat", false)
        guiWindowSetSizable(colorchangegui, false)

        GUIEditor.label[1] = guiCreateLabel(10, 29, 60, 15, "Color Tag", false, colorchangegui)
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        GUIEditor.label[2] = guiCreateLabel(10, 91, 85, 15, "Color Mensaje", false, colorchangegui)
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        GUIEditor.label[3] = guiCreateLabel(10, 194, 219, 63, "Web de colores Hexadecimales:\n\nhttps://color.adobe.com/es/explore/", false, colorchangegui)
        guiSetFont(GUIEditor.label[3], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[3], "left", true)    


        editcolortag = guiCreateEdit(10, 50, 199, 31, "#00ff00", false, colorchangegui)
        guiEditSetMaxLength(editcolortag, 7)

        editcolormsj = guiCreateEdit(10, 116, 199, 31, "#00ff00", false, colorchangegui)
        guiEditSetMaxLength(editcolormsj, 7)

        savecolorcg = guiCreateButton(85, 157, 52, 27, "Guardar", false, colorchangegui)
        guiSetFont(savecolorcg, "default-bold-small")
        colorchatclose = guiCreateButton(147, 157, 52, 27, "Cancelar", false, colorchangegui)
        guiSetFont(colorchatclose, "default-bold-small")


        guiSetVisible( colorchangegui,false)  
        centerWindow ( colorchangegui )
        


function adsds(  )
    guiSetVisible ( GUIEditor.window[2], false )
   guiSetVisible ( GUIEditor.window[3], false )
   guiSetVisible ( GUIEditor.window[4], false )
   guiSetVisible ( GUIEditor.window[1], false )
   guiSetVisible(gplistgw,false)
   guiSetVisible(grouppanel,false)
   guiSetVisible(guicolor,false)
   guiSetVisible( guimembersgp,false) 
   guiSetVisible(guiinfogpedit,false) 
   guiSetVisible(promotegui,false)
   guiSetVisible(guiinviteplayer,false)
   guiSetVisible(guiconfiggp,false)
   guiSetVisible( colorchangegui,false)  
   guiSetVisible( infopanelg,false)  
   guiSetVisible ( rangosMain, false)
   guiSetVisible ( admRangos.window[1], false)
   guiSetVisible ( notyfy.window[1], false )
   guiSetVisible( loggui, false )
   disableGPCGui()
   showCursor(false)
   guiSetInputEnabled( false )
end
addEventHandler("onClientGUIClick", newclose, adsds, false)

function openRangos(  )
    triggerServerEvent ( "getRanksGroup", getLocalPlayer(  ) )
    guiSetVisible( guiconfiggp, false )
    guiSetVisible ( admRangos.window[1], true )
end
addEventHandler("onClientGUIClick", leavegroup, openRangos, false)

function leavegrousp(  )
    guiSetVisible ( Confirm.window[1], true )
    centerWindow ( Confirm.window[1] )
    guiBringToFront( Confirm.window[1] )
end
addEventHandler("onClientGUIClick", gpmoney, leavegrousp, false)

function openconfiggroup(  )
    guiSetVisible(grouppanel,false)
    guiSetVisible(guiconfiggp,true)
    clearCList()
end
addEventHandler("onClientGUIClick", configgp, openconfiggroup, false)

function openmaingroup(  )
    guiSetVisible(grouppanel,true)
    guiSetVisible(guiconfiggp,false)
end
addEventHandler("onClientGUIClick", closeconfiggui, openmaingroup, false)

function listgroups(  )
    guiSetEnabled( grouplistb, false )
    setTimer( guiSetEnabled, 3000, 1, grouplistb, true )
    guiGridListClear(gridlistgps)
    guiSetVisible(grouppanel,false)
    guiSetVisible(guiconfiggp,false)
    guiSetVisible(gplistgw,true)
    triggerServerEvent("gtlistgpsv",getLocalPlayer(  ))
end
addEventHandler("onClientGUIClick", grouplistb, listgroups, false)

function sxdsxs(  )
    guiSetVisible(grouppanel,true)
    guiSetVisible(gplistgw,false)
end
addEventHandler("onClientGUIClick", cerrarglgps, sxdsxs, false)

function editinsadfo(  )
    guiSetEnabled( editinfo, false )
    setTimer( guiSetEnabled, 3000, 1, editinfo, true )
    guiSetVisible(grouppanel,false)
    guiSetVisible(guiconfiggp,false)
    guiSetVisible(guiinfogpedit,true)
    triggerServerEvent("setinfotoedit",getLocalPlayer(  ))
end
addEventHandler("onClientGUIClick", editinfo, editinsadfo, false)

function viewinfo()
    guiSetVisible(grouppanel,false)
    guiSetVisible(infopanelg,true)
    triggerServerEvent("gpgpphelpinfo",getLocalPlayer())
end
addEventHandler("onClientGUIClick", infogp, viewinfo, false)

function sss(  )
    guiSetVisible(infopanelg,false)
    guiSetVisible(grouppanel,true)
end
addEventHandler("onClientGUIClick", closebinfo, sss, false)

function ssss(  )
    guiSetVisible(guiinfogpedit,false)
    guiSetVisible(guiconfiggp,true)
end
addEventHandler("onClientGUIClick", closeeditinfobt, ssss, false)

function openviewmyinvities()
    guiSetEnabled( invt, false )
    setTimer( guiSetEnabled, 3000, 1, invt, true )

    local InvTab = getElementData( getLocalPlayer( ) , "InvTable" ) or false

    if InvTab then
        createNotification( "Tienes una invitacion de: "..InvTab.." Usa /aceptar")
    else
        createNotification( "No tienes invitaciones.")
    end
end
addEventHandler("onClientGUIClick", invt, openviewmyinvities, false)

function openivinte(  )
    guiSetVisible(guiconfiggp,false)
    guiSetVisible(guiinviteplayer,true)
    requestListInvitation( )
end
addEventHandler("onClientGUIClick", invnewmemb, openivinte, false)

function closeingv(  )
    guiSetVisible(guiconfiggp,true)
    guiSetVisible(guiinviteplayer,false)
end
addEventHandler("onClientGUIClick", cerrapanelivn, closeingv, false)

function openpromotegui(  )
    guiGridListClear( gridlistpromotepl )
    guiSetVisible(promotegui,true)
    guiSetVisible(guiconfiggp,false)
    triggerServerEvent("reproms",getLocalPlayer())
end
addEventHandler("onClientGUIClick", promotemembers, openpromotegui, false)

function closepromoteguis(  )
    guiSetVisible(promotegui,false)
    guiSetVisible(guiconfiggp,true)
end
addEventHandler("onClientGUIClick", closepromotegui, closepromoteguis, false)

function openchangecolor(  )
	triggerServerEvent("coloresOfGroup",getLocalPlayer())
    guiSetVisible(guiconfiggp,false)
    guiSetVisible( colorchangegui, true ) 
end
addEventHandler("onClientGUIClick", banmembers, openchangecolor, false)

function closechangecolor(  )
    guiSetVisible(guiconfiggp,true)
    guiSetVisible(colorchangegui,false)
end
addEventHandler("onClientGUIClick", colorchatclose, closechangecolor, false)

function opemmebviewgui(  )
    guiSetVisible(guimembersgp,true)
    guiSetVisible(grouppanel,false)
    guiGridListClear( gridmiemview ) 
    triggerServerEvent("viewmembersall",getLocalPlayer(  ))
end
addEventHandler("onClientGUIClick", members, opemmebviewgui, false)

function closemebviewgui(  )
    guiSetVisible(guimembersgp,false)
    guiSetVisible(grouppanel,true)
end
addEventHandler("onClientGUIClick", closemembgui, closemebviewgui, false)

function donechangecolor(  )
    local colorTag  = editcolortag:getText()
    local colorChat = editcolormsj:getText()


    if getColorFromString( colorTag ) and getColorFromString( colorChat ) then
        guiSetVisible(guiconfiggp,true)
        guiSetVisible(colorchangegui,false)
        triggerServerEvent("donecolorchange",getLocalPlayer(  ), colorTag, colorChat )
    else
        createNotification("Colores invalidos!", 200, 0, 0, true)
    end
    guiSetEnabled( savecolorcg, false )
    setTimer( guiSetEnabled, 20000, 1, savecolorcg, true )
end
addEventHandler("onClientGUIClick", savecolorcg, donechangecolor, false)

function re(  )
    requestListInvitation( )
    guiSetEnabled( refreshlist, false )
    setTimer( guiSetEnabled, 3000, 1, refreshlist, true )
end
addEventHandler("onClientGUIClick", refreshlist, re, false)

function requestListInvitation(  )
    guiGridListClear( gridlistsendinv )
    triggerServerEvent("getlistofplinvto",getLocalPlayer(  ))
end

function deletebuttongp(  )
    triggerServerEvent( "deletemygp", getLocalPlayer(  ) )
    guiSetVisible(guiconfiggp,false)
    guiSetVisible ( guiconfig, false)
    guiSetVisible(grouppanel,true)
    triggerServerEvent("getdatasgroup",getLocalPlayer(  ))
end
addEventHandler("onClientGUIClick", deletegp, deletebuttongp, false)

function saveeditedinfo(  )
    guiSetVisible(guiinfogpedit,false)
    guiSetVisible(guiconfiggp,true)
    local text = memoinfoedit:getText()
    triggerServerEvent("saveAeditedinfos",getLocalPlayer(),text)
end
addEventHandler("onClientGUIClick", saveinfob, saveeditedinfo, false)

function kickAmember(  )
    local row,col = guiGridListGetSelectedItem( gridlistconfigmv )
    local name = guiGridListGetItemText( gridlistconfigmv, row, namecol )
    if row == -1 or col == -1 then return false end
    --[[
    triggerServerEvent("kickamemberoption",getLocalPlayer(),name)
    guiGridListClear(gridlistconfigmv)
    triggerServerEvent("getcdtgroup",getLocalPlayer())
    triggerServerEvent("getdatasgroup",getLocalPlayer(  ))
    guiSetEnabled( kickmembersb, false )
    setTimer( guiSetEnabled, 3000, 1, kickmembersb, true )]]--

    showRS( name )
end
addEventHandler("onClientGUIClick", kickmembersb, kickAmember, false)

function invAmember(  )
    local row,col = guiGridListGetSelectedItem( gridlistsendinv )
    local name = guiGridListGetItemText( gridlistsendinv, row, plinvd )
    if row == -1 or col == -1 then return false end
    triggerServerEvent("sendainvtopl",getLocalPlayer(),name)
    guiSetEnabled( sendinvit, false )
    setTimer( guiSetEnabled, 3000, 1, sendinvit, true )
end
addEventHandler("onClientGUIClick", sendinvit, invAmember, false)


function promoterangamem(  )
    local rowe,cole = guiComboBoxGetSelected(boxpromote)
    local text = guiComboBoxGetItemText(boxpromote, rowe)
    local row,col = guiGridListGetSelectedItem( gridlistpromotepl )
    local name = guiGridListGetItemText( gridlistpromotepl, row, plprompl )
    if rowe == -1 or cole == -1 then return false end
    if row == -1 or col == -1 then return false end
    triggerServerEvent("newrangforplayer",getLocalPlayer(),name,text)
    guiGridListClear(gridlistconfigmv)
    guiGridListClear( gridlistpromotepl )
    triggerServerEvent("getcdtgroup",getLocalPlayer())
    guiSetEnabled( promotebutton, false )
    setTimer( guiSetEnabled, 3000, 1, promotebutton, true )
end
addEventHandler("onClientGUIClick", promotebutton, promoterangamem, false)

function createagroup(  )
    local name = string.gsub( guiGetText(editcrgp),"%s",'_')
    local k = name
    local ag = string.lower(k)
    if string.len(name) < 4 then 
        createNotification("Solo un nombre mayor a 4 caracteres", 255, 255, 255, true )
        return
    elseif type ( tonumber( name ) ) == "number" then
        createNotification( "Nombre invalido!", 255, 255, 255, true  )
        return
    --elseif string.find(name,"%p") or string.find(name,"%c") then outputChatBox("No se permiten caracteres") 
        --return 
    end
    triggerServerEvent("createnewGroup",localPlayer,k)
    triggerServerEvent("getdatasgroup",getLocalPlayer(  ))
    guiSetText( editcrgp, "")
end
addEventHandler("onClientGUIClick", creategpb, createagroup, false)


function openAlianza(  )
    triggerServerEvent( "requestOPENGui", getLocalPlayer(  ))
end
addEventHandler("onClientGUIClick", buyslots, openAlianza, false)