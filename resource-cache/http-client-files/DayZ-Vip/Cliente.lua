VIP = {{},{},{},{},{},{}}
sW, sH = guiGetScreenSize()
Tiempo = 0
Tiempo1 = 0
TiempoWall = 0
text = {}
text1 = ""
WallActivado = false

local Herramientas = {
	"GPS",
	"Mapa",
	"Caja de cerillas",
	"Lentes de visión nocturna",
	"Lentes infrarrojos",
	"Caja de herramientas",
	"Reloj",
	"Pepsi"
}

function iniciarVIP()
	VIP[1][1] = guiCreateWindow((sW - 350) / 2, (sH - 199) / 2, 350, 199, "Sistema VIP", false)
	guiBringToFront(VIP[1][1],true)
	guiWindowSetSizable(VIP[1][1], false)
	guiSetVisible(VIP[1][1], false)
	guiSetInputMode("no_binds_when_editing")

	VIP[2][1] = guiCreateTabPanel(10, 25, 340, 164, false, VIP[1][1])

	VIP[3][1] = guiCreateTab("General", VIP[2][1])

	VIP[4][1] = guiCreateLabel(10, 10, 310, 15, "Nombre: "..getPlayerName(localPlayer), false, VIP[3][1])
	guiLabelSetHorizontalAlign(VIP[4][1], "center", false)
	VIP[4][2] = guiCreateLabel(10, 25, 310, 15, "Humanidad: ", false, VIP[3][1])
	guiLabelSetHorizontalAlign(VIP[4][2], "center", false)
	VIP[4][3] = guiCreateLabel(10, 40, 310, 15, "Asesinatos: ", false, VIP[3][1])
	guiLabelSetHorizontalAlign(VIP[4][3], "center", false)
	VIP[4][4] = guiCreateLabel(10, 55, 310, 15, "Zombies asesinados: ", false, VIP[3][1])
	guiLabelSetHorizontalAlign(VIP[4][4], "center", false)
	VIP[4][5] = guiCreateLabel(10, 70, 310, 15, "Tiempo VIP restante: ", false, VIP[3][1])
	guiLabelSetHorizontalAlign(VIP[4][5], "center", false)
	VIP[5][1] = guiCreateEdit(10, 95, 238, 23, "", false, VIP[3][1])
	VIP[6][1] = guiCreateButton(248, 95, 72, 23, "Anunciar", false, VIP[3][1])

	VIP[3][2] = guiCreateTab("Opciones", VIP[2][1])

	VIP[6][2] = guiCreateButton(10, 10, 142, 30, "Obtener comida", false, VIP[3][2])
	VIP[6][3] = guiCreateButton(178, 10, 142, 30, "Obtener herramientas", false, VIP[3][2])
	VIP[6][5] = guiCreateButton(10, 50, 142, 30, "Mochila VIP", false, VIP[3][2])
	VIP[6][6] = guiCreateButton(178, 50, 142, 30, "Overcars", false, VIP[3][2])
	VIP[6][7] = guiCreateButton(10, 90, 142, 30, "Skin VIP", false, VIP[3][2])
	VIP[6][4] = guiCreateButton(178, 90, 142, 30, "Wallhack", false, VIP[3][2])

	VIP[3][2] = guiCreateTab("Vehiculos", VIP[2][1])

	VIP[5][2] = guiCreateEdit(10, 35, 138, 31, "Vehiculo", false, VIP[3][2])
	VIP[6][8] = guiCreateButton(10, 66, 138, 31, "Crear", false, VIP[3][2])
	VIP[6][9] = guiCreateButton(209, 10, 111, 31, "Reparar", false, VIP[3][2])
	VIP[6][10] = guiCreateButton(209, 41, 111, 31, "Voltear", false, VIP[3][2])
	VIP[6][11] = guiCreateButton(209, 72, 111, 31, "Nitro", false, VIP[3][2])
	VIP[6][12] = guiCreateButton(209, 103, 111, 31, "Destruir", false, VIP[3][2])
	
	VIP[3][3] = guiCreateTab("Ayuda", VIP[2][1])
	VIP[6][13] = guiCreateMemo(12, 10, 310, 125, "VIP:"..
	"\n\nFuncionamiento de algunas cosas :"..
	"\nPara enviar un mensaje global anda a la pestaña general, en el cuadro blanco escribe tu mensaje"..
	"y luego presiona en Anunciar para ponerlo"..
	"\nWallhack: al activar el wallhack podrás ver a los demas players a traves de las paredes, claro que a cierta distancia determinada"..
	"\nSkin VIP con esta opcion obtendrás un skin unico vip, pero al ponertelo no podrás cambair de skin hasta que mueras"..
    "\nOvercar: esta funcion hará que tu vehiculo flote cada vez que entres en el agua"..
	"\nTeleport: esta opcion solo estará disponible por 1 semana con el puedes darte warp a los lugares que se indica"..
	" una vez usado un teleport no podrás usar otro hasta pasar 7 minutos, y si te disparan no podrás usarlo durante 2 minutos"..
	"\nPara sacar un auto ve a la pestaña vehiculos"..
	" aqui puedes escribir el nombre de cualquier vehiculo y spawnearlo a excepcion de vehiculos aereos y rhino"..
	"\nPara cambiar tu tag a cualquiera que desees escribe en say '/tag cambiar mitag'"..
	"\n\nAlgun bug/error contactar con los administradores"..
	"\n\nReglas VIP:\n-Spawn de autos en entradas: Si un usuario VIP es sorprendido spawneando un auto para cubrir las entradas de"..
	"\ncualquier sitio, la sanción correspondiente será: Kick advirtiendo al usuario. Si éste continua Ban por 2 dias(2880 min) . "..
	"\nSi éste lo hace de una forma reiterada y sigue sin entender, Ban por 5 dias (7200 min)."..
	"\n-Insultos/descalificaciones por cualquier medio: Si un usuario VIP usa el anuncio o ChatVIP  o cualquier otro medio para insultar/descalificar"..
	"\na otro usuario la sanción correspondiente será: Kick advirtiendo al usuario.Si éste continua Ban por 2 horas (120 min). Si éste lo hace de una "..
	"\nforma reiterada y sigue sin entender, Ban por 3 días (4320 min)."..
	"\n-Bugear balas de armas (99999): Si un usuario VIP es sorprendido portando un arma vip con 9999 balas, la sanción correspondiente será: Quitar Items"..
	"\ny Kick advirtiendo al usuario.Si éste continua Ban por 2 horas (120 min)."..
	"\n-Tags Admin:  Si un usuario VIP es sorprendido portando tags con cualquier rango de la staff la sanción correspondiente será:  "..
	"\nKick advirtiendo al usuario.Si éste continua Ban por 1 horas (60 min)."..
	"\n-Relogeo para usar anuncio vip:  Si un usuario VIP es sorprendido reconectando para usar el anuncio vip antes de los 3 minutos establecidos la sancion"..
	"\ncorrespondiente será: Kick advirtiendo al usuario.Si éste continua Ban por 1 horas (60 min)."..
	"\n-Prestar cuenta VIP: Si un usuario VIP es sorprendido prestando su cuenta se aplicará Ban (2880 min) al dueño y Ban (1440 min) al que la usa, "..
	"\ninmediatamente un adminG cambiará la clave. Si este continua facilitando su contraseña la sanción correspondiente será, Ban (10040 mins.) sin derecho".. 
	"\na recuperar los días perdidos.", false, VIP[3][3])
	guiMemoSetReadOnly(VIP[6][13],true)
end
addEventHandler("onClientResourceStart", resourceRoot, iniciarVIP)


function SkinVIPS()
	Skins = guiCreateWindow((sW - 247) / 2, (sH - 275) / 2, 246, 312, "Skins VIP", false)
	guiWindowSetSizable(Skins, false)
	showCursor (true)

	SkinVIP1 = guiCreateButton(16, 33, 84, 32, "Skin VIP 1", false, Skins)
	SkinVIP2 = guiCreateButton(16, 75, 84, 32, "Skin VIP 2", false, Skins)
	SkinVIP3 = guiCreateButton(16, 117, 84, 32, "Skin VIP 3", false, Skins)
	SkinVIP4 = guiCreateButton(16, 159, 84, 32, "Skin VIP 4", false, Skins)
	SkinVIP5 = guiCreateButton(16, 199, 84, 32, "Skin VIP 5", false, Skins)
	TrajeMilitar = guiCreateButton(145, 33, 84, 32, "Traje Militar", false, Skins)
	TrajeCivil = guiCreateButton(145, 75, 84, 32, "Traje Civil", false, Skins)
	TrajeCamuflaje = guiCreateButton(145, 117, 84, 32, "Traje Camuflaje", false, Skins)
	TrajePolicial = guiCreateButton(145, 159, 84, 32, "Traje Policial", false, Skins)
	Bandido2 = guiCreateButton(16, 239, 84, 32, "Traje Bandido 1", false, Skins)
	Bandido = guiCreateButton(145, 239, 84, 32, "Traje Bandido 2", false, Skins)
	Heroe = guiCreateButton(145, 199, 84, 32, "Traje Heroe", false, Skins)
	Cerrar = guiCreateButton(172, 288, 57, 25, "Cerrar", false, Skins)
	addEventHandler("onClientGUIClick", Cerrar, ocultarskinvip )
	addEventHandler("onClientGUIClick", SkinVIP1, opcionskin )
	addEventHandler("onClientGUIClick", SkinVIP2, opcionskin )
	addEventHandler("onClientGUIClick", SkinVIP3, opcionskin )
	addEventHandler("onClientGUIClick", SkinVIP4, opcionskin )
	addEventHandler("onClientGUIClick", SkinVIP5, opcionskin )
	addEventHandler("onClientGUIClick", TrajeMilitar, opcionskin )
	addEventHandler("onClientGUIClick", TrajeCivil, opcionskin )
	addEventHandler("onClientGUIClick", TrajeCamuflaje, opcionskin )
	addEventHandler("onClientGUIClick", TrajePolicial, opcionskin )
	addEventHandler("onClientGUIClick", Bandido, opcionskin )
	addEventHandler("onClientGUIClick", Bandido2, opcionskin )
	addEventHandler("onClientGUIClick", Heroe, opcionskin )
end

function opcionskin()
	if source == SkinVIP1 then
		triggerServerEvent("skin", root, localPlayer, "SkinVIP1")
	elseif source == SkinVIP2 then
		triggerServerEvent("skin", root, localPlayer, "SkinVIP2")
	elseif source == SkinVIP3 then
		triggerServerEvent("skin", root, localPlayer, "SkinVIP3")
	elseif source == SkinVIP4 then
		triggerServerEvent("skin", root, localPlayer, "SkinVIP4")
	elseif source == SkinVIP5 then
		triggerServerEvent("skin", root, localPlayer, "SkinVIP5")
	elseif source == TrajeMilitar then
		triggerServerEvent("skin", root, localPlayer, "TrajeMilitar")
	elseif source == TrajeCivil then
		triggerServerEvent("skin", root, localPlayer, "TrajeCivil")
	elseif source == TrajeCamuflaje then
		triggerServerEvent("skin", root, localPlayer, "TrajeCamuflaje")
	elseif source == TrajePolicial then
		triggerServerEvent("skin", root, localPlayer, "TrajePolicial")
	elseif source == Bandido then
		triggerServerEvent("skin", root, localPlayer, "Bandido")
	elseif source == Bandido2 then
		triggerServerEvent("skin", root, localPlayer, "Bandido2")
	elseif source == Heroe then
		triggerServerEvent("skin", root, localPlayer, "Heroe")
	end
end

function ocultarskinvip ()
	if source ~= Cerrar then return end
	destroyElement(Skins)
	Skins = false
end

function ocultarVIP()
	removeEventHandler("onClientResourceStart", resourceRoot, iniciarVIP)
	showCursor(false)
end

function aPanel(Datos)
	guiSetText(VIP[4][1], "Nombre: "..Datos[1])
	guiSetText(VIP[4][2], "Humanidad: "..Datos[2])
	guiSetText(VIP[4][3], "Asesinatos: "..Datos[3])
	guiSetText(VIP[4][4], "Zombies asesinados: "..Datos[4])
	guiSetText(VIP[4][5], "Tiempo VIP restante: "..Datos[5])
end
addEvent("actualizarPanel", true )
addEventHandler("actualizarPanel", localPlayer, aPanel)

bindKey("F2", "down", function()
	-- Si el usuario no es VIP, se cancela
	if not localPlayer:getData('Jugador VIP') then return end

	if guiGetVisible(VIP[1][1]) then
		guiSetVisible(VIP[1][1], false)
		showCursor(false)

		if isElement(Skins) and guiGetVisible(Skins) then
			destroyElement(Skins)
		end
	else
		showCursor(true)
		guiSetVisible(VIP[1][1], true)
		triggerServerEvent("actualizarInfo", resourceRoot, getLocalPlayer())
	end
end)

addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), function()
    if source == VIP[6][1] then
		if getTickCount() - Tiempo > 180000 then 
			Texto = guiGetText(VIP[5][1])
			triggerServerEvent("enviarAnuncioVIP", localPlayer, Texto)
			Tiempo = getTickCount()
		else 
			outputChatBox("[DayZ-VIP] Debes esperar 3 minutos para enviar otro anuncio!", 0, 255, 0)
		end
	elseif source == VIP[6][2] then
		triggerServerEvent("comida", root, localPlayer, "Pedir Comida")
	elseif source == VIP[6][3] then
		Resultado = 0
		for k, v in ipairs(Herramientas) do
			if not localPlayer:getData(v) or localPlayer:getData(v) < 1 then
				localPlayer:setData(v, 1)
				Resultado = Resultado + 1
			end
		end

		if Resultado == 0 then
			outputChatBox("[DayZ-VIP] Ya tienes herramientas en tu inventario!", 255, 0, 0)
		else
			outputChatBox("[DayZ-VIP] Obtubiste herramientas con exito!", 0, 255, 0)
		end
	elseif source == VIP[6][4] then
		if getTickCount() - TiempoWall > 1800000 then
			if WallActivado then
				outputChatBox("El wallhack ya está activado!", 255, 100, 0)
				return
			end
			activarWall()
			WallActivado = true
			setTimer( function ()
				if WallActivado == true then 
					desactivarWall()
					WallActivado = false 
				end
			end,30000,1)
			TiempoWall = getTickCount()
		else
			outputChatBox("[DayZ-VIP] Debes esperar 30 minutos usar denuevo el wallhack!", 0, 255, 0)
		end
	elseif source == VIP[6][5] then
	if getElementData(localPlayer, "MAX_Slots") == 170 then
		outputChatBox("[DayZ-VIP] Ya tienes equipada una mochila VIP!", 255, 0, 0)
		return
	else
		setElementData(localPlayer, "MAX_Slots", 170)
		outputChatBox("[DayZ-VIP] Mochila equipada con exito!", 0, 255, 0)
	end
	elseif source == VIP [6][6] then
	if isWorldSpecialPropertyEnabled("hovercars") then
		outputChatBox("[DayZ-VIP] Vehiculo flotador desactivado!", 255, 0, 0)
		setWorldSpecialPropertyEnabled("hovercars", false)
	else
		outputChatBox("[DayZ-VIP] Vehiculo flotador activado!", 0, 255, 0)
		setWorldSpecialPropertyEnabled("hovercars", true)
	end
	elseif source == VIP[6][7] then
	ocultarVIP()
	SkinVIPS()
	elseif source == VIP[6][8] then
	triggerServerEvent("aVehiculo", root, localPlayer, "Vehiculo", guiGetText(VIP[5][2]))
	elseif source == VIP[6][9] then
	triggerServerEvent("aVehiculo", root, localPlayer, "Reparar")
	elseif source == VIP[6][10] then
	triggerServerEvent("aVehiculo", root, localPlayer, "Voltear")
	elseif source == VIP[6][11] then
	triggerServerEvent("aVehiculo", root, localPlayer, "Nitro")
	elseif source == VIP[6][12] then
	triggerServerEvent("aVehiculo", root, localPlayer, "Destruir")
    end
end)

function Draw()
	if move == "positif" then
	count = count+1
	else
	count = count-1
	end

	if count <= 100 then alpha = 255*(count/100) end
	
	dxDrawText("[VIP] " .. text.nick .. "#ffffff:",0,70,sW,sH,tocolor(0,255,0,alpha),2,"default-bold","center","top", false, false, false, true, false)
	dxDrawText(text.ann,0,100,sW,sH,tocolor(255,255,255,alpha),2,"default-bold","center","top",false,false,true)

	if count == 2 then
	removeEventHandler("onClientRender",getRootElement(),Draw)
	end

	if count == 200 then
	count = 100
	move = "negatif"
	end
end

function preDraw(MSG, TXT)
	text.ann = MSG
	text.nick = TXT
	count = 3
	alpha = 0
	move = "positif"
	addEventHandler("onClientRender", getRootElement(), Draw)
end
addEvent("announce",true)
addEventHandler("announce",getLocalPlayer(),preDraw)

function DayzDisparosVIP ( attacker, weapon, bodypart, loss )
	if getElementData(source, "Jugador VIP", true) then
	 if weapon and weapon > 1 and attacker and getElementType(attacker) == "player" then
		Tiempo1 = (getTickCount()-300000)
	 end
	 end
   end
addEventHandler ( "onClientPlayerDamage", getLocalPlayer (), DayzDisparosVIP )


function explosionOnSpawn()
	if getElementData(source, "Jugador VIP", true) then
	triggerServerEvent("vipv", root, localPlayer)
	end
end
addEventHandler("onClientPlayerSpawn", getLocalPlayer(), explosionOnSpawn)