--Create Clark Devlin .. tipo OOP

GUIEditor = {
    tab = {},
    window = {},
    tabpanel = {},
    button = {}
}
        GUIEditor.window[1] = guiCreateWindow(337, 164, 746, 417, "Recompensas por Nivel", false)
        guiWindowSetSizable(GUIEditor.window[1], false)
        guiSetAlpha(GUIEditor.window[1], 1.00)
        guiSetVisible(GUIEditor.window[1], false)

        GUIEditor.tabpanel[1] = guiCreateTabPanel(11, 25, 725, 382, false, GUIEditor.window[1])

        GUIEditor.tab[1] = guiCreateTab("Usuario Free", GUIEditor.tabpanel[1])

        b_palmas = guiCreateButton(15, 15, 179, 87, "Nivel 10\nDesbloquea: Palmas", false, GUIEditor.tab[1])
        guiSetEnabled ( b_palmas, false )
        b_risa = guiCreateButton(278, 21, 192, 81, "Nivel 20\nDesbloquea: Risa", false, GUIEditor.tab[1])
        guiSetEnabled ( b_risa, false )
        b_baile = guiCreateButton(553, 21, 162, 81, "Nivel 30\nDebloquea: Baile", false, GUIEditor.tab[1])
        guiSetEnabled ( b_baile, false )
        b_skinV = guiCreateButton(247, 223, 246, 101, "NIVEL 70\nDesbloquea:\nSkin Veterano", false, GUIEditor.tab[1])
        guiSetEnabled ( b_skinV, false )

        GUIEditor.tab[2] = guiCreateTab("Usuario VIP", GUIEditor.tabpanel[1])

        bVip_baile = guiCreateButton(15, 15, 125, 77, "Nivel 5\nDesbloquea: Baile VIP", false, GUIEditor.tab[2])
        guiSetProperty(bVip_baile, "NormalTextColour", "FF03BF19")
        guiSetEnabled (bVip_baile , false )
        bVip_baileEpico = guiCreateButton(156, 15, 130, 77, "Nivel 10\nDesbloquea: Baile Epico", false, GUIEditor.tab[2])
        guiSetProperty(bVip_baileEpico, "NormalTextColour", "FF0A16B7")
        guiSetEnabled ( bVip_baileEpico, false )
        bVip_relax = guiCreateButton(296, 15, 129, 77, "Nivel 18\nDebloquea: Baile PRO", false, GUIEditor.tab[2])
        guiSetProperty(bVip_relax, "NormalTextColour", "FF03BF19")
        guiSetEnabled ( bVip_relax, false )
        bVip_skinOA = guiCreateButton(244, 152, 260, 141, "NIVEL 40\nDesbloquea:\nSkin Legendario", false, GUIEditor.tab[2])
        guiSetProperty(bVip_skinOA, "NormalTextColour", "FFC4B400")
        guiSetEnabled (bVip_skinOA , false )
        bVip_fumar = guiCreateButton(435, 19, 118, 73, "Nivel 45\nDesbloquea: Fumar", false, GUIEditor.tab[2])
        guiSetProperty(bVip_fumar, "NormalTextColour", "FF03BF19")
        guiSetEnabled ( bVip_fumar, false )
        bVip_baileLeg = guiCreateButton(563, 19, 133, 73, "Nivel 48\nDesbloquea: Baile Legendario", false, GUIEditor.tab[2])
        guiSetEnabled (bVip_baileLeg , false )
        bVip_orinar = guiCreateButton(24, 176, 191, 117, "Nivel 60\nAnimaciones Legendaria\nDesbloquea: Orinar", false, GUIEditor.tab[2])
        guiSetProperty(bVip_orinar, "NormalTextColour", "FF03BEC0")
        guiSetEnabled (bVip_orinar , false )
        bVip_skinO = guiCreateButton(523, 177, 192, 116, "Nivel 70\nDesbloquea: Skin Epico", false, GUIEditor.tab[2])
        guiSetProperty(bVip_skinO, "NormalTextColour", "FF03BEC0")
        guiSetEnabled ( bVip_skinO, false )

bindKey("F1", "down",
        function()
                guiSetVisible(GUIEditor.window[1], not guiGetVisible(GUIEditor.window[1]))
                showCursor(not isCursorShowing())
                desbloqueo()
        end
)

function desbloqueo ()
        if guiGetVisible(GUIEditor.window[1]) == false then
                return
        end
        local nivelD = localPlayer:getData("level")
        local VIP = localPlayer:getData("Jugador VIP")
        if nivelD >= 10 and nivelD < 20 then
                guiSetEnabled ( b_palmas, true )
                guiSetText(b_palmas, "Palmas\nDesbloqueado")
        elseif nivelD >= 20 and nivelD < 30 then
                guiSetEnabled ( b_risa, true );guiSetEnabled ( b_palmas, true )
                guiSetText(b_risa, "Risa\nDesbloqueado");guiSetText(b_palmas, "Palmas\nDesbloqueado")
        elseif nivelD >= 30 and nivelD < 70 then
                guiSetEnabled ( b_baile,true );guiSetEnabled ( b_risa, true );guiSetEnabled ( b_palmas, true )
                guiSetText(b_baile, "Baile\nDesbloqueado");guiSetText(b_risa, "Risa\nDesbloqueado");guiSetText(b_palmas, "Palmas\nDesbloqueado")
        elseif nivelD >= 70 then
                guiSetEnabled ( b_skinV, true );guiSetEnabled ( b_baile,true );guiSetEnabled ( b_risa, true );guiSetEnabled ( b_palmas, true )
                guiSetText(b_skinV, "Skin Veterano\nDesbloqueado");guiSetText(b_baile, "Baile\nDesbloqueado");guiSetText(b_risa, "Risa\nDesbloqueado");guiSetText(b_palmas, "Palmas\nDesbloqueado")
        end
        if nivelD >= 5 and nivelD < 10 and VIP then
                guiSetEnabled (bVip_baile , true )
                guiSetText(bVip_baile, "Baile VIP\nDesbloqueado")
        elseif nivelD >= 10 and nivelD < 18 and VIP then
                guiSetEnabled ( bVip_baileEpico,  true );guiSetEnabled (bVip_baile , true )
                guiSetText(bVip_baileEpico, "Baile Epico\nDesbloqueado");guiSetText(bVip_baile, "Baile VIP\nDesbloqueado")
        elseif nivelD >= 18 and nivelD < 40 and VIP then
                guiSetEnabled ( bVip_relax,  true );guiSetEnabled ( bVip_baileEpico,  true );guiSetEnabled (bVip_baile , true )
                guiSetText(bVip_relax, "Baile PRO\nDesbloqueado");guiSetText(bVip_baileEpico, "Baile Epico\nDesbloqueado");guiSetText(bVip_baile, "Baile VIP\nDesbloqueado")
        elseif nivelD >= 40 and nivelD < 45 and VIP then
                guiSetEnabled ( bVip_fumar,  true );guiSetEnabled ( bVip_relax,  true );guiSetEnabled ( bVip_baileEpico,  true );guiSetEnabled (bVip_baile , true )
                guiSetText(bVip_fumar, "Fumar\nDesbloqueado");guiSetText(bVip_relax, "Baile PRO\nDesbloqueado");guiSetText(bVip_baileEpico, "Baile Epico\nDesbloqueado");guiSetText(bVip_baile, "Baile VIP\nDesbloqueado")
        elseif nivelD >= 45 and nivelD < 48 and VIP then
                guiSetEnabled (bVip_baileLeg ,  true );guiSetEnabled ( bVip_fumar,  true );guiSetEnabled ( bVip_relax,  true );guiSetEnabled ( bVip_baileEpico,  true );guiSetEnabled (bVip_baile , true )
                guiSetText(bVip_baileLeg, "Baile Legendario\nDesbloqueado");guiSetText(bVip_fumar, "Fumar\nDesbloqueado");guiSetText(bVip_relax, "Baile PRO\nDesbloqueado");guiSetText(bVip_baileEpico, "Baile Epico\nDesbloqueado");guiSetText(bVip_baile, "Baile VIP\nDesbloqueado")
        elseif nivelD >= 48 and nivelD < 60 and VIP then
                guiSetEnabled (bVip_orinar ,  true );guiSetEnabled (bVip_baileLeg ,  true );guiSetEnabled ( bVip_fumar,  true );guiSetEnabled ( bVip_relax,  true );guiSetEnabled ( bVip_baileEpico,  true );guiSetEnabled (bVip_baile , true )
                guiSetText(bVip_orinar, "Orinar\nDesbloqueado");guiSetText(bVip_baileLeg, "Baile Legendario\nDesbloqueado");guiSetText(bVip_fumar, "Fumar\nDesbloqueado");guiSetText(bVip_relax, "Baile PRO\nDesbloqueado");guiSetText(bVip_baileEpico, "Baile Epico\nDesbloqueado");guiSetText(bVip_baile, "Baile VIP\nDesbloqueado")
        elseif nivelD >= 60 and nivelD < 70 and VIP then
                guiSetEnabled ( bVip_skinO,  true );guiSetEnabled (bVip_orinar ,  true );guiSetEnabled (bVip_baileLeg ,  true );guiSetEnabled ( bVip_fumar,  true );guiSetEnabled ( bVip_relax,  true );guiSetEnabled ( bVip_baileEpico,  true );guiSetEnabled (bVip_baile , true )
                guiSetText(bVip_skinO, "Skin Epico\nDesbloqueado");guiSetText(bVip_orinar, "Orinar\nDesbloqueado");guiSetText(bVip_baileLeg, "Baile Legendario\nDesbloqueado");guiSetText(bVip_fumar, "Fumar\nDesbloqueado");guiSetText(bVip_relax, "Baile PRO\nDesbloqueado");guiSetText(bVip_baileEpico, "Baile Epico\nDesbloqueado");guiSetText(bVip_baile, "Baile VIP\nDesbloqueado")
        elseif nivelD >= 70 and VIP then
                guiSetEnabled (bVip_skinOA ,  true );guiSetEnabled ( bVip_skinO,  true );guiSetEnabled (bVip_orinar ,  true );guiSetEnabled (bVip_baileLeg ,  true );guiSetEnabled ( bVip_fumar,  true );guiSetEnabled ( bVip_relax,  true );guiSetEnabled ( bVip_baileEpico,  true );guiSetEnabled (bVip_baile , true )
                guiSetText(bVip_skinOA, "Skin Legendario\nDesbloqueado");guiSetText(bVip_skinO, "Skin Epico\nDesbloqueado");guiSetText(bVip_orinar, "Orinar\nDesbloqueado");guiSetText(bVip_baileLeg, "Baile Legendario\nDesbloqueado");guiSetText(bVip_fumar, "Fumar\nDesbloqueado");guiSetText(bVip_relax, "Baile PRO\nDesbloqueado");guiSetText(bVip_baileEpico, "Baile Epico\nDesbloqueado");guiSetText(bVip_baile, "Baile VIP\nDesbloqueado")
        end
        addEventHandler("onClientGUIClick", root,
                function ( boton, estado )
                        if not boton ~= "left" and estado ~= "up" then
                                return
                        end
                        local nivelD = localPlayer:getData("level")
                        local VIP = localPlayer:getData("Jugador VIP")
                        if source == b_palmas and nivelD >= 10 then
                                triggerServerEvent("onPedAnimation", getLocalPlayer(), 'dancing', 'bd_clap1')
								outputChatBox("Usa /parar para terminar la animacion.", 255, 255, 255, true) 
                        elseif source == b_risa and nivelD >= 20 then
                                triggerServerEvent("onPedAnimation", getLocalPlayer(), 'rapping', 'Laugh_01')
								outputChatBox("Usa /parar para terminar la animacion.", 255, 255, 255, true) 
                        elseif source == b_baile and nivelD >= 30 then
                                triggerServerEvent("onPedAnimation", getLocalPlayer(), 'dancing', 'dan_left_a')
								outputChatBox("Usa /parar para terminar la animacion.", 255, 255, 255, true) 
                        elseif source == b_skinV and nivelD >= 70 then
                                setElementModel(localPlayer, 43)										
									setElementData(localPlayer, "skin",43)	
                        elseif source == bVip_baile and nivelD >= 5 and VIP then
                                triggerServerEvent("onPedAnimation", getLocalPlayer(), 'dancing', 'dan_left_a')
								outputChatBox("Usa /parar para terminar la animacion.", 255, 255, 255, true) 
                        elseif source == bVip_baileEpico and nivelD >= 10 and VIP then
                                triggerServerEvent("onPedAnimation", getLocalPlayer(), 'dancing', 'dnce_M_a')
								outputChatBox("Usa /parar para terminar la animacion.", 255, 255, 255, true) 
                        elseif source == bVip_relax and nivelD >= 18 and VIP then
                                triggerServerEvent("onPedAnimation", getLocalPlayer(), 'dancing', 'dan_down_a')
								outputChatBox("Usa /parar para terminar la animacion.", 255, 255, 255, true) 
                        elseif source == bVip_fumar and nivelD >= 40 and VIP then
                                triggerServerEvent("onPedAnimation", getLocalPlayer(), 'smoking', 'M_smk_in')
								outputChatBox("Usa /parar para terminar la animacion.", 255, 255, 255, true) 
                        elseif source == bVip_baileLeg and nivelD >= 45 and VIP then
                                triggerServerEvent("onPedAnimation", getLocalPlayer(), 'dancing', 'dance_loop')
								outputChatBox("Usa /parar para terminar la animacion.", 255, 255, 255, true) 
                        elseif source == bVip_orinar and nivelD >= 48 and VIP then
                                triggerServerEvent("onPedAnimation", getLocalPlayer(), 'paulnmac', 'Piss_in')
								outputChatBox("Usa /parar para terminar la animacion.", 255, 255, 255, true) 
                        elseif source == bVip_skinO and nivelD >= 60 and VIP then
                                setElementModel(localPlayer, 37)										
									setElementData(localPlayer, "skin",37)	
                        elseif source == bVip_skinOA and nivelD >= 70 and VIP then
                                setElementModel(localPlayer, 17)										
									setElementData(localPlayer, "skin",32)	
                        end
                end
         )
end
