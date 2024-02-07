---------------------------------------------------------------------
--  Desarrollador/Developer: -Rex-
--  Proyecto/Proyect:        N/A
--  Contacto/Contact:        https://www.facebook.com/rexscripting/
--
--  Libre uso y modificacion, No borrar los creditos, Gracias
---------------------------------------------------------------------

function centerWindow (center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    guiSetPosition(center_window, x, y, false)
end


GUIEditor = {
    checkbox = {},
    edit = {},
    button = {},
    window = {},
    label = {},
    gridlist = {}
}
GUIEditor.window[1] = guiCreateWindow(29, 58, 471, 303, "Administrar Alianzas", false)
guiWindowSetSizable(GUIEditor.window[1], false)

GUIEditor.gridlist[1] = guiCreateGridList(10, 34, 190, 259, false, GUIEditor.window[1])
a = guiGridListAddColumn(GUIEditor.gridlist[1], "Grupo", 0.5)
b = guiGridListAddColumn(GUIEditor.gridlist[1], "Miembros", 0.5)
GUIEditor.button[1] = guiCreateButton(224, 44, 109, 24, "Enviar solicitud", false, GUIEditor.window[1])
guiSetFont(GUIEditor.button[1], "default-bold-small")
guiSetProperty(GUIEditor.button[1], "NormalTextColour", "FFC7C7C7")
GUIEditor.button[2] = guiCreateButton(224, 78, 109, 24, "Actualizar lista", false, GUIEditor.window[1])
guiSetFont(GUIEditor.button[2], "default-bold-small")
guiSetProperty(GUIEditor.button[2], "NormalTextColour", "FFC7C7C7")
GUIEditor.button[3] = guiCreateButton(343, 44, 109, 24, "Eliminar alianza", false, GUIEditor.window[1])
guiSetFont(GUIEditor.button[3], "default-bold-small")
guiSetProperty(GUIEditor.button[3], "NormalTextColour", "FFC7C7C7")
GUIEditor.button[4] = guiCreateButton(343, 78, 109, 24, "Solicitudes", false, GUIEditor.window[1])
guiSetFont(GUIEditor.button[4], "default-bold-small")
guiSetProperty(GUIEditor.button[4], "NormalTextColour", "FFC7C7C7")

GUIEditor.checkbox[1] = guiCreateCheckBox(234, 141, 119, 15, "Blip's en el mapa", false, false, GUIEditor.window[1])

GUIEditor.label[1] = guiCreateLabel(224, 112, 101, 14, "Opciones:", false, GUIEditor.window[1])

GUIEditor.checkbox[2] = guiCreateCheckBox(234, 166, 119, 15, "Chat de grupo", false, false, GUIEditor.window[1])

GUIEditor.button[5] = guiCreateButton(428, 277, 33, 16, "X", false, GUIEditor.window[1])
guiSetFont(GUIEditor.button[5], "default-bold-small")
guiSetProperty(GUIEditor.button[5], "NormalTextColour", "FFC7C7C7")
GUIEditor.button[6] = guiCreateButton(343, 112, 109, 24, "Ver otras alianzas", false, GUIEditor.window[1])
guiSetFont(GUIEditor.button[6], "default-bold-small")
guiSetProperty(GUIEditor.button[6], "NormalTextColour", "FFC7C7C7")


GUIEditor.window[2] = guiCreateWindow(900, 15, 360, 355, "Enviar solicitud", false)
guiWindowSetSizable(GUIEditor.window[2], false)

GUIEditor.gridlist[2] = guiCreateGridList(10, 54, 158, 290, false, GUIEditor.window[2])
c = guiGridListAddColumn(GUIEditor.gridlist[2], "Grupo", 0.9)
GUIEditor.edit[1] = guiCreateEdit(10, 26, 121, 22, "", false, GUIEditor.window[2])
GUIEditor.button[7] = guiCreateButton(189, 64, 74, 29, "Enviar", false, GUIEditor.window[2])
guiSetFont(GUIEditor.button[7], "default-bold-small")
guiSetProperty(GUIEditor.button[7], "NormalTextColour", "FFAAAAAA")
GUIEditor.button[8] = guiCreateButton(273, 64, 74, 29, "Cerrar", false, GUIEditor.window[2])
guiSetFont(GUIEditor.button[8], "default-bold-small")
guiSetProperty(GUIEditor.button[8], "NormalTextColour", "FFAAAAAA")


GUIEditor.window[3] = guiCreateWindow(576, 68, 292, 167, "Solicitudes", false)
guiWindowSetSizable(GUIEditor.window[3], false)

GUIEditor.gridlist[3] = guiCreateGridList(10, 25, 134, 135, false, GUIEditor.window[3])
d = guiGridListAddColumn(GUIEditor.gridlist[3], "Grupo", 0.9)
GUIEditor.button[9] = guiCreateButton(154, 31, 59, 25, "Aceptar", false, GUIEditor.window[3])
guiSetFont(GUIEditor.button[9], "default-bold-small")
guiSetProperty(GUIEditor.button[9], "NormalTextColour", "FFAAAAAA")
GUIEditor.button[10] = guiCreateButton(223, 31, 59, 25, "Borrar", false, GUIEditor.window[3])
guiSetFont(GUIEditor.button[10], "default-bold-small")
guiSetProperty(GUIEditor.button[10], "NormalTextColour", "FFAAAAAA")
GUIEditor.button[11] = guiCreateButton(154, 66, 59, 25, "Actualizar", false, GUIEditor.window[3])
guiSetFont(GUIEditor.button[11], "default-bold-small")
guiSetProperty(GUIEditor.button[11], "NormalTextColour", "FFAAAAAA")
GUIEditor.button[12] = guiCreateButton(223, 66, 59, 25, "Cerrar", false, GUIEditor.window[3])
guiSetFont(GUIEditor.button[12], "default-bold-small")
guiSetProperty(GUIEditor.button[12], "NormalTextColour", "FFAAAAAA")


GUIEditor.window[4] = guiCreateWindow(370, 155, 380, 307, "Alianzas de otros grupos", false)
guiWindowSetSizable(GUIEditor.window[4], false)

GUIEditor.edit[2] = guiCreateEdit(10, 27, 121, 22, "", false, GUIEditor.window[4])
GUIEditor.gridlist[4] = guiCreateGridList(10, 55, 143, 241, false, GUIEditor.window[4])
e = guiGridListAddColumn(GUIEditor.gridlist[4], "Grupos", 0.9)

GUIEditor.label[2] = guiCreateLabel(163, 65, 97, 15, "", false, GUIEditor.window[4])
GUIEditor.label[3] = guiCreateLabel(163, 90, 207, 132, "", false, GUIEditor.window[4])
guiLabelSetHorizontalAlign(GUIEditor.label[3], "left", true)
GUIEditor.button[13] = guiCreateButton(342, 282, 30, 14, "X", false, GUIEditor.window[4])
guiSetFont(GUIEditor.button[13], "default-bold-small")
guiSetProperty(GUIEditor.button[13], "NormalTextColour", "FFAAAAAA")

centerWindow ( GUIEditor.window[1] )
centerWindow ( GUIEditor.window[2] )
centerWindow ( GUIEditor.window[3] )
centerWindow ( GUIEditor.window[4] )
guiSetVisible ( GUIEditor.window[1], false )
guiSetVisible ( GUIEditor.window[2], false )
guiSetVisible ( GUIEditor.window[3], false )
guiSetVisible ( GUIEditor.window[4], false )

guiSetVisible ( GUIEditor.label[2], false )
guiSetVisible ( GUIEditor.label[3], false )

function openClosePanel( )
    
    guiSetVisible ( GUIEditor.window[2], false )
    guiSetVisible ( GUIEditor.window[3], false )
    guiSetVisible ( GUIEditor.window[4], false )
    local status = not guiGetVisible( GUIEditor.window[1] )
    guiSetVisible ( GUIEditor.window[1], status )
    guiSetVisible(guiconfiggp, not status )
    --showCursor( status )
    if status then
        getGroupList ( )
    end
    triggerServerEvent( "requestGroupConfigs", getLocalPlayer(  ))
end
addEvent( "openGUI", true )
addEventHandler( "openGUI", getLocalPlayer(  ), openClosePanel )

function openCloseAli(  )
    triggerServerEvent( "requestOPENGui", getLocalPlayer(  ))
end
--addCommandHandler( "alianza", openCloseAli )

function closeALL( )
    guiSetVisible ( GUIEditor.window[1], false )
    guiSetVisible ( GUIEditor.window[2], false )
    guiSetVisible ( GUIEditor.window[3], false )
    guiSetVisible ( GUIEditor.window[4], false )
    guiSetVisible(guiconfiggp,true)
end

function getGroupList(  )
    guiGridListClear( GUIEditor.gridlist[1] )
    triggerServerEvent( "requestGPList", getLocalPlayer(  ))
end

function GPList( grupo, mi )
    local row = guiGridListAddRow( GUIEditor.gridlist[1] )
    guiGridListSetItemText( GUIEditor.gridlist[1], row, a, grupo, false, false )
    guiGridListSetItemText( GUIEditor.gridlist[1], row, b, mi, false, false )

    local row2 = guiGridListAddRow( GUIEditor.gridlist[2] )
    guiGridListSetItemText( GUIEditor.gridlist[2], row2, c, grupo, false, false )
end
addEvent( "addGPList", true )
addEventHandler( "addGPList", getLocalPlayer(  ), GPList )

local bools = 
{
    ["true"] = true,
    ["false"] = false,
}

function applyGroupConfigs( a, b )


    guiCheckBoxSetSelected( GUIEditor.checkbox[1], a )
    guiCheckBoxSetSelected( GUIEditor.checkbox[2], b )
   

end
addEvent( "groupConfigs", true )
addEventHandler( "groupConfigs", getLocalPlayer(  ), applyGroupConfigs )

function GPList2( grupo )
    local row2 = guiGridListAddRow( GUIEditor.gridlist[2] )
    guiGridListSetItemText( GUIEditor.gridlist[2], row2, c, grupo, false, false )
end
addEvent( "addGPList2", true )
addEventHandler( "addGPList2", getLocalPlayer(  ), GPList2 )

function clicks(  )
    
    if source == GUIEditor.button[5] then
        closeALL ( )

    elseif source == GUIEditor.button[1] then

        guiSetVisible ( GUIEditor.window[2], true )
        guiSetVisible ( GUIEditor.window[1], false )

        guiGridListClear( GUIEditor.gridlist[2] )
        triggerServerEvent( "requestFINDList", getLocalPlayer(  ), "" )

    elseif source == GUIEditor.button[8] then

        getGroupList(  )
        guiSetVisible ( GUIEditor.window[2], false )
        guiSetVisible ( GUIEditor.window[1], true )

    elseif source == GUIEditor.button[2] then
        getGroupList ( )
        guiSetEnabled( GUIEditor.button[2], false )

        setTimer( guiSetEnabled, 3000, 1, GUIEditor.button[2], true )

    elseif source == GUIEditor.checkbox[1] then

        triggerServerEvent( "requestChangeGPConig", getLocalPlayer(  ), ( guiCheckBoxGetSelected( GUIEditor.checkbox[1] ) ), guiCheckBoxGetSelected( GUIEditor.checkbox[2] ) )

    elseif source == GUIEditor.checkbox[2] then

        triggerServerEvent( "requestChangeGPConig", getLocalPlayer(  ), guiCheckBoxGetSelected( GUIEditor.checkbox[1] ), ( guiCheckBoxGetSelected( GUIEditor.checkbox[2] ) ) )

    elseif source == GUIEditor.button[7] then

        local row, col = guiGridListGetSelectedItem( GUIEditor.gridlist[2] )

        if row == -1 or col == -1 then
            createNotification( "Selecciona algo!", 242, 242, 242, true )
            return
        end

        local grupo = guiGridListGetItemText( GUIEditor.gridlist[2], row, col )
        triggerServerEvent( "requestsendInvGP", getLocalPlayer(  ), grupo )

        guiSetEnabled( GUIEditor.button[7], false )

        setTimer( guiSetEnabled, 3000, 1, GUIEditor.button[7], true )

    elseif source == GUIEditor.button[4] then

        guiSetVisible ( GUIEditor.window[1], false )
        guiSetVisible ( GUIEditor.window[3], true )
        loadInvs ( )

    elseif source == GUIEditor.button[11] then

        loadInvs ( )

    elseif source == GUIEditor.button[12] then
        getGroupList(  )
        guiSetVisible ( GUIEditor.window[1], true )
        guiSetVisible ( GUIEditor.window[3], false )


    elseif source == GUIEditor.button[9] then

        local row, col = guiGridListGetSelectedItem( GUIEditor.gridlist[3] )

        if row == -1 or col == -1 then
            createNotification( "Selecciona algo!", 242, 242, 242, true )
            return
        end

        local grupo = guiGridListGetItemText( GUIEditor.gridlist[3], row, col )
        guiGridListClear( GUIEditor.gridlist[3] )
        triggerServerEvent( "requestAcceptInv", getLocalPlayer(  ), grupo )

    elseif source == GUIEditor.button[3] then

        local row, col = guiGridListGetSelectedItem( GUIEditor.gridlist[1] )

        if row == -1 or col == -1 then
            createNotification( "Selecciona algo!", 242, 242, 242, true )
            return
        end

        local grupo = guiGridListGetItemText( GUIEditor.gridlist[1], row, col )
        triggerServerEvent( "requestDeleteAlianze", getLocalPlayer(  ), grupo )

    elseif source == GUIEditor.button[10] then

        local row, col = guiGridListGetSelectedItem( GUIEditor.gridlist[3] )

        if row == -1 or col == -1 then
            createNotification( "Selecciona algo!", 242, 242, 242, true )
            return
        end

        local grupo = guiGridListGetItemText( GUIEditor.gridlist[3], row, col )
        guiGridListClear( GUIEditor.gridlist[3] )
        triggerServerEvent( "requestDeleteInvGP", getLocalPlayer(  ), grupo )

    elseif source == GUIEditor.button[6] then

        guiSetVisible ( GUIEditor.window[1], false )
        guiSetVisible ( GUIEditor.window[4], true )
        loadGroupsA( )

    elseif source == GUIEditor.gridlist[4] then

        local row, col = guiGridListGetSelectedItem( GUIEditor.gridlist[4] )

        if row == -1 or col == -1 then
            guiSetVisible( GUIEditor.label[2], false )
            guiSetVisible( GUIEditor.label[3], false )
            return
        else
            guiSetVisible( GUIEditor.label[2], true )
            guiSetVisible( GUIEditor.label[3], true )
            guiSetText( GUIEditor.label[2], "" )
            guiSetText( GUIEditor.label[3], "" )
        end

        local grupo = guiGridListGetItemText( GUIEditor.gridlist[4], row, col )
        guiSetText( GUIEditor.label[2], "Grupo: "..grupo )
        triggerServerEvent( "requestGroupAlianzesInfo", getLocalPlayer(  ), grupo )
    elseif source == GUIEditor.button[13] then
        guiSetVisible ( GUIEditor.window[1], true )
        guiSetVisible ( GUIEditor.window[4], false )
    end
end
addEventHandler( "onClientGUIClick", getRootElement(  ), clicks )

function loadGroupsA( )
    guiGridListClear( GUIEditor.gridlist[4] )
    triggerServerEvent( "getALLGPList", getLocalPlayer(  ) )
end

function loadInvs( )
    guiGridListClear( GUIEditor.gridlist[3] )
    triggerServerEvent( "requestGetInvList", getLocalPlayer(  ) )
end

function changeGUI( )
    
    if source == GUIEditor.edit[1] then

        local text = guiGetText( GUIEditor.edit[1] )

        guiGridListClear( GUIEditor.gridlist[2] )
        triggerServerEvent( "requestFINDList", getLocalPlayer(  ), text )

    elseif source == GUIEditor.edit[2] then

        local text = guiGetText( GUIEditor.edit[2] )

        guiGridListClear( GUIEditor.gridlist[4] )
        triggerServerEvent( "requestFINDList2", getLocalPlayer(  ), text )
    end

end
addEventHandler( "onClientGUIChanged", getRootElement(  ), changeGUI )

function GPiNVlIST( grupo )
    local row = guiGridListAddRow( GUIEditor.gridlist[3] )
    guiGridListSetItemText( GUIEditor.gridlist[3], row, d, grupo, false, false )
end
addEvent( "addInvsList", true )
addEventHandler( "addInvsList", getLocalPlayer(  ), GPiNVlIST )

function GPAllList( grupo )
    local row = guiGridListAddRow( GUIEditor.gridlist[4] )
    guiGridListSetItemText( GUIEditor.gridlist[4], row, e, grupo, false, false )
end
addEvent( "addGPList2", true )
addEventHandler( "addGPList2", getLocalPlayer(  ), GPAllList )

function GPAllList2( grupo )
    local row = guiGridListAddRow( GUIEditor.gridlist[4] )
    guiGridListSetItemText( GUIEditor.gridlist[4], row, e, grupo, false, false )
end
addEvent( "addGPList3", true )
addEventHandler( "addGPList3", getLocalPlayer(  ), GPAllList2 )

function infoAlianzaGP( buffer )
    guiSetText( GUIEditor.label[3], "Grupo Aliados: "..buffer )
end
addEvent( "GPInfoAlList", true )
addEventHandler( "GPInfoAlList", getLocalPlayer(  ), infoAlianzaGP )


function isAliated( grupo )
    
	if not getElementData(getLocalPlayer(), "GroupsAliatedTable") then
		return false
	end

    for i, v in ipairs( getElementData( getLocalPlayer( ), "GroupsAliatedTable" ) ) do
        
        if grupo == v[1] then
            return true
        end

    end

    return false

end

function aliatedBlipColor( grupo )
    
    for i, v in ipairs( getElementData( getLocalPlayer( ), "GroupsAliatedTable" ) ) do
        
        if grupo == v[1] then
            
            local r, g, b = getColorFromString( v[2] )
            return r, g, b
        end

    end

    return 200, 200, 0

end