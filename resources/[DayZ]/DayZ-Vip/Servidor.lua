function vipv(Jugador)
end
addEvent("vipv", true )
addEventHandler("vipv", root, vipv)

function ChatVIP(Jugador, cmd, ...)
	local MSG = table.concat({...}, " ")

	--Se chequea la cuenta del jugador
	local Cuenta = getPlayerAccount(Jugador)
	if not Cuenta then return end
	
	if isPlayerMuted(Jugador) then outputChatBox("Estas muteado!",Jugador,255,0,0) return end
	if getAccountData(Cuenta, "donatorEnabled") == 1 then
		for k, v in ipairs(getElementsByType("player")) do
			local Cuenta = getPlayerAccount(v)
			if Cuenta and getAccountData(Cuenta, "donatorEnabled") == 1 then
				outputChatBox("[Chat VIP] " .. (getPlayerName(Jugador)) .. ": #ffffff" .. MSG, v, 238, 238, 0, true)
			end
		end
		outputServerLog("[Chat VIP] " .. getPlayerName ( Jugador) .. ": " .. MSG)
	end
end
addCommandHandler("ChatVIP", ChatVIP)

function onResStart()
	  for index, player in ipairs(getElementsByType("player")) do
		local cuenta = getPlayerAccount(player)
		  if getAccountData(cuenta, "donatorEnabled") == 1 then
			bindKey(player, "B", "down", "chatbox", "ChatVIP")
		  end
	  end 
  end 
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), onResStart)

function chequearVIP(Jugador)
	if not Jugador then return end
		
	local Cuenta = getPlayerAccount(Jugador)
	
	if getAccountData(Cuenta,"donatorEnabled") == 1 then
		local donatorTime = tonumber(getAccountData(Cuenta,"donatorTime"))
		if donatorTime then
			local currentTime = getRealTime()
			if donatorTime > currentTime.timestamp then
				local donatorState,donatorTime = true,secoundsToDays(donatorTime-currentTime.timestamp)
				outputChatBox("[DayZ-VIP] Tu tiempo VIP expira en: "..donatorTime..".", Jugador,0, 255, 0)
				outputChatBox("[DayZ-VIP] Usa F6 para abrir el panel.",Jugador, 0, 255, 0)
				outputChatBox("[DayZ-VIP] Usa B para abrir el Chat VIP.",Jugador, 0, 255, 0)
				bindKey(source, "B", "down", "chatbox", "ChatVIP")
				setElementData(Jugador, "Jugador VIP", true)
			else
				outputChatBox("[DayZ-VIP] Tu tiempo VIP expiró!",Jugador,0,255,0)
				setAccountData(Cuenta,"donatorEnabled",0)
				setAccountData(Cuenta,"donatorTime",0)
				return
			end
		end
	end
end


addEventHandler("onPlayerLogin", getRootElement(), function()
	chequearVIP(source)
end)


function Informacion(Jugador)
	local Cuenta = getPlayerAccount(Jugador)
	
	if Cuenta then
		local datos = {}
		Nombre = getPlayerName(Jugador)
		Humanidad = getElementData(Jugador, "humanity") or 2500
		Asesinatos = getElementData(Jugador, "murders") or 0
		zAsesinados = getElementData(Jugador, "zombieskilled") or 0
		Tiempo = getAccountData(Cuenta, "donatorTime")
		if Tiempo then
			local currentTime = getRealTime()
			Tiempo = secoundsToDays(Tiempo-currentTime.timestamp)
		else
			Tiempo = "No disponible"
		end
		
		table.insert(datos, Nombre)
		table.insert(datos, Humanidad)
		table.insert(datos, Asesinatos)
		table.insert(datos, zAsesinados)
		table.insert(datos, Tiempo)
		triggerClientEvent(Jugador,"actualizarPanel",Jugador,datos)
	end
end
addEvent("actualizarInfo", true )
addEventHandler("actualizarInfo", resourceRoot, Informacion)

function aVehiculo(Jugador, Opcion, Argumento)
	if Opcion == "Vehiculo" then
		crearVehiculo(Jugador, Argumento)
	elseif Opcion == "Reparar" then
		local Vehiculo = getPedOccupiedVehicle(Jugador)
		if Vehiculo then
			fixVehicle(Vehiculo)
			outputChatBox("[DayZ-VIP] Vehiculo reparado con exito!", Jugador, 0, 255, 0)
		else
			outputChatBox("[DayZ-VIP] Debes estar en un vehiculo para repararlo!", Jugador, 255, 0, 0)
			return
		end
	elseif Opcion == "Voltear" then
		local Vehiculo = getPedOccupiedVehicle(Jugador)
		if Vehiculo then
			local rX, rY, rZ = getElementRotation(Vehiculo)
			setElementRotation(Vehiculo, 0, 0, rZ)
			outputChatBox("[DayZ-VIP] Vehiculo volteado con exito!", Jugador, 0, 255, 0)
		else
			outputChatBox("[DayZ-VIP] Debes estar en un vehiculo para voltearlo!", Jugador, 255, 0, 0)
			return
		end
	elseif Opcion == "Nitro" then
		if isElement(Vehiculo[Jugador]) then
			addVehicleUpgrade(Vehiculo[Jugador], 1010)
			outputChatBox("[DayZ-VIP] Ahora tu vehiculo VIP tiene nitro!", Jugador, 0, 255, 0)
		else
			outputChatBox("[DayZ-VIP] No tienes un vehiculo VIP!", Jugador, 255, 0, 0)
			return
		end
	elseif Opcion == "Destruir" then
		if isElement(Vehiculo[Jugador]) then
			destroyElement(Vehiculo[Jugador])
			outputChatBox("[DayZ-VIP] Tu vehiculo VIP fue destruido correctamente!", Jugador, 0, 255, 0)
		else
			outputChatBox("[DayZ-VIP] No tienes un vehiculo VIP!", Jugador, 255, 0, 0)
			return
		end
	end
end
addEvent("aVehiculo", true )
addEventHandler("aVehiculo", root, aVehiculo)

function comida(Jugador,Opcion)
	local pizza = getElementData(Jugador, "Carne cocida")
	local agua = getElementData(Jugador, "Garrafa de Água")
	if Opcion == "Pedir Comida" then
		if (Jugador:getData('Carne cocida') and Jugador:getData('Carne cocida') > 0) or (Jugador:getData('Garrafa de Água') and Jugador:getData('Garrafa de Água') > 0) then
			outputChatBox("[DayZ-VIP] Ya tienes comida en tu inventario!",Jugador, 255, 0, 0)
			return
		end

		setElementData(Jugador, "Carne cocida", 5)
		setElementData(Jugador, "Garrafa de Água", 5)
		outputChatBox("[DayZ-VIP] Obtubiste comida con exito!",Jugador, 0, 255, 0)
	end
end
addEvent("comida", true)
addEventHandler("comida", root, comida)

function skin (Jugador, Opcion)
	local sk = getElementModel(Jugador),getElementData(Jugador, "skin")
	if Opcion == "SkinVIP2" then
		if sk == 19 then
		outputChatBox("[DayZ-VIP] Ya tienes Equipado el Skin VIP 2!",Jugador,255,0,0)
		else
		setElementModel(Jugador, 19)
		setElementData(Jugador, "skin", 19)
		outputChatBox("[DayZ-VIP] Skin VIP 2 Obtenido con exito!",Jugador,0,255,0)
		end
	elseif Opcion == "SkinVIP1" then
		if sk == 23 then
		outputChatBox("[DayZ-VIP] Ya tienes Equipado el Skin VIP 1!",Jugador,255,0,0)
		else
		setElementModel(Jugador, 23)
		setElementData(Jugador, "skin", 23)
		outputChatBox("[DayZ-VIP] Skin VIP 1 Obtenido con exito!",Jugador,0,255,0)
		end
	elseif Opcion == "SkinVIP3" then
		if sk == 11 then
		outputChatBox("[DayZ-VIP] Ya tienes Equipado el Skin VIP 3!",Jugador,255,0,0)
		else
		setElementModel(Jugador, 11)
		setElementData(Jugador, "skin", 11)
		outputChatBox("[DayZ-VIP] Skin VIP 3 Obtenido con exito!",Jugador,0,255,0)
		end
	elseif Opcion == "SkinVIP4" then
		if sk == 163 then
		outputChatBox("[DayZ-VIP] Ya tienes Equipado el Skin VIP 4!",Jugador,255,0,0)
		else
		setElementModel(Jugador, 163)
		setElementData(Jugador, "skin", 163)
		outputChatBox("[DayZ-VIP] Skin VIP 4 Obtenido con exito!",Jugador,0,255,0)
		end
	elseif Opcion == "SkinVIP5" then
		if sk == 12 then
		outputChatBox("[DayZ-VIP] Ya tienes Equipado el Skin VIP 5!",Jugador,255,0,0)
		else
		setElementModel(Jugador, 12)
		setElementData(Jugador, "skin", 12)
		outputChatBox("[DayZ-VIP] Skin VIP 5 Obtenido con exito!",Jugador,0,255,0)
		end
	elseif Opcion == "TrajeMilitar" then
		if sk == 287 then
		outputChatBox("[DayZ-VIP] Ya tienes Equipado el Traje Militar!",Jugador,255,0,0)
		else
		setElementModel(Jugador, 287)
		setElementData(Jugador, "skin", 287)
		outputChatBox("[DayZ-VIP] Traje Militar Obtenido con exito!",Jugador,0,255,0)
		end
	elseif Opcion == "TrajeCivil" then
		if sk == 179 then
		outputChatBox("[DayZ-VIP] Ya tienes Equipado el Traje Civil!",Jugador,255,0,0)
		else
		setElementModel(Jugador, 179)
		setElementData(Jugador, "skin", 179)
		outputChatBox("[DayZ-VIP] Traje Civil Obtenido con exito!",Jugador,0,255,0)
		end
	elseif Opcion == "TrajeCamuflaje" then
		if sk == 285 then
		outputChatBox("[DayZ-VIP] Ya tienes Equipado el Traje Camuflaje!",Jugador,255,0,0)
		else
		setElementModel(Jugador, 285)
		setElementData(Jugador, "skin", 285)
		outputChatBox("[DayZ-VIP] Traje Camuflaje Obtenido con exito!",Jugador,0,255,0)
		end
	elseif Opcion == "TrajePolicial" then
		if sk == 270 then
		outputChatBox("[DayZ-VIP] Ya tienes Equipado el Traje Policial!",Jugador,255,0,0)
		else
		setElementModel(Jugador, 270)
		setElementData(Jugador, "skin", 270)
		outputChatBox("[DayZ-VIP] Traje Policial Obtenido con exito!",Jugador,0,255,0)
		end
	elseif Opcion == "Bandido" then
		if sk == 288 then
		outputChatBox("[DayZ-VIP] Ya tienes Equipado el Traje de Bandido!",Jugador,255,0,0)
		else
		setElementModel(Jugador, 288)
		setElementData(Jugador, "skin", 288)
		outputChatBox("[DayZ-VIP] Traje de Bandido Obtenido con exito!",Jugador,0,255,0)
		end
	elseif Opcion == "Bandido2" then
		if sk == 180 then
		outputChatBox("[DayZ-VIP] Ya tienes Equipado el Traje de Bandido 2!",Jugador,255,0,0)
		else
		setElementModel(Jugador, 180)
		setElementData(Jugador, "skin", 180)
		outputChatBox("[DayZ-VIP] Traje de Bandido 2 Obtenido con exito!",Jugador,0,255,0)
		end
	elseif Opcion == "Heroe" then
		if sk == 210 then
		outputChatBox("[DayZ-VIP] Ya tienes Equipado el Traje de Heroe!",Jugador,255,0,0)
		else
		setElementModel(Jugador, 210)
		setElementData(Jugador, "skin", 210)
		outputChatBox("[DayZ-VIP] Traje de Heroe Obtenido con exito!",Jugador,0,255,0)
		end
	end
end
addEvent("skin", true)
addEventHandler("skin", root, skin)

--ACA PUEDO QUITAR LAS ID DE LOS VEHICULOS NO INCLUIDOS--

Vehiculo = {}
ID = {}
VehNoIncluidos = {432,544,407,601,441,464,594,501,465,564,571,431,506,496,409,477,544,400}
function crearVehiculo(Jugador, Modelo)
	if ID[Jugador] then
		outputChatBox("Ya estas creando un vehiculo!", Jugador, 255, 0, 0)
		return
	end

	ID[Jugador] = getVehicleModelFromName(Modelo)
	if not ID[Jugador] then
		outputChatBox("[DayZ-VIP] Vehiculo no encontrado!", Jugador, 255, 0, 0)
		ID[Jugador] = false
		return
	end

	if getVehicleType(ID[Jugador]) == "Bike" or getVehicleType(ID[Jugador]) == "Automobile" then

        for idex, vehicleID in ipairs (VehNoIncluidos) do
            if ID[Jugador] == vehicleID then
                outputChatBox("[DayZ-VIP] No puedes crear este vehiculo!", Jugador, 255, 0, 0)
				ID[Jugador] = false
                return
            end
        end
			outputChatBox("[DayZ-VIP] Creando vehiculo espera unos segundos para que aparezcan!", Jugador, 0, 255, 0)
		setTimer(function()
			if isElement(Vehiculo[Jugador]) then destroyElement(Vehiculo[Jugador]) end

			x, y, z = getElementPosition(Jugador)
			Vehiculo[Jugador] = createVehicle(ID[Jugador], x, y, z)
			setElementData(Vehiculo[Jugador], "VIP", true)
			warpPedIntoVehicle(Jugador, Vehiculo[Jugador])
			ID[Jugador] = false
			return
		end,5000,1)
	else
		outputChatBox("[DayZ-VIP] Solo puedes crear automoviles y motos!", Jugador, 255, 0, 0)
		ID[Jugador] = false
	end
end

addEventHandler("onPlayerQuit", root,
function()
	 if isElement(Vehiculo[source]) then
		  destroyElement(Vehiculo[source])
		  Vehiculo[source] = nil
	 end
end)

function anunciar(Texto)
	triggerClientEvent ( "announce", root, Texto, getPlayerName(source))
end
addEvent( "enviarAnuncioVIP", true )
addEventHandler( "enviarAnuncioVIP", root, anunciar)


function findPlayerByName (name)
	local player = getPlayerFromName(name)
	if player then return player end
	for i, player in ipairs(getElementsByType("player")) do
		if string.find(string.gsub(getPlayerName(player):lower(),"#%x%x%x%x%x%x", ""), name:lower(), 1, true) then
			return player
		end
	end
return false
end

function addDonatorTime(Jugador,Comando,Tipo,Usuario,Tiempo)
	
	local Cuenta = getPlayerAccount(Jugador)
	local asd = getAccountName(Cuenta)
--// Si no tiene acceso al panel administrativo, cancelar
	if asd == "Mati" then	
		if Jugador and Tipo then
			if Tipo == "Agregar" then
				local donatorPlayer = findPlayerByName(Usuario)
				if donatorPlayer then
					local donatorAccount = getPlayerAccount(donatorPlayer)
					if not isGuestAccount(donatorAccount) then
						local currentTime = getRealTime()
						if tonumber(Tiempo) then
							local daysToDonate = 86400 * Tiempo
							setAccountData(donatorAccount,"donatorEnabled",1)
							setAccountData(donatorAccount,"donatorTime",currentTime.timestamp + daysToDonate)
							setElementData(donatorPlayer, "Jugador VIP", true)
							outputChatBox("[DayZ-VIP] Agregaste "..Tiempo.." dias de VIP a: "..getPlayerName(donatorPlayer),Jugador,0,255,0,true)
							outputChatBox("[DayZ-VIP] Recibiste "..Tiempo.." dias de VIP, felicidades!",donatorPlayer,0,255,0,true)
							outputChatBox("[DayZ-VIP] Usa F6 para abrir el panel.!",donatorPlayer,0,255,0,true)
							outputChatBox("[DayZ-VIP] Usa B para abrir el Chat VIP!",donatorPlayer,0,255,0,true)
							for index, player in ipairs(getElementsByType("player")) do
								local cuenta = getPlayerAccount(player)
								if getAccountData(cuenta, "donatorEnabled") == 1 then
									bindKey(player, "B", "down", "chatbox", "ChatVIP")
								end
							end
						end
					end
				else
					local Cuenta = getAccount(Usuario)
					if Cuenta then
						local currentTime = getRealTime()
						if tonumber(Tiempo) then
							local daysToDonate = 86400 * Tiempo
							setAccountData(Cuenta,"donatorEnabled",1)
							setAccountData(Cuenta,"donatorTime",currentTime.timestamp + daysToDonate)
							outputChatBox("[DayZ-VIP] Agregaste "..Tiempo.." dias de VIP a la cuenta de: "..Usuario, Jugador,0,255,0,true)
						end
					else
						outputChatBox("[DayZ-VIP] No se puede encontrar al jugador ni la cuenta!",Jugador,255,0,0,true)
					end
				end
			elseif Tipo == "Quitar" then
				local donatorPlayer = findPlayerByName(Usuario)
				if donatorPlayer then
					local donatorAccount = getPlayerAccount(donatorPlayer)
					if not isGuestAccount(donatorAccount) then
						if getAccountData(donatorAccount,"donatorEnabled") == 1 then
							setAccountData(Cuenta, "Tag", false)
							setAccountData(donatorAccount,"donatorEnabled",0)
							setAccountData(donatorAccount,"donatorTime",0)
							setElementData(donatorPlayer, "Jugador VIP", false)
							outputChatBox("[DayZ-VIP] VIP de: "..getPlayerName(donatorPlayer).." removido correctamente.",Jugador,0,255,0)
							outputChatBox("[DayZ-VIP] Tu VIP ha sido removido por: ".. getPlayerName(Jugador),donatorPlayer,0,255,0)
							for index, player in ipairs(getElementsByType("player")) do
								local cuenta = getPlayerAccount(player)
								  if getAccountData(cuenta, "donatorEnabled") == 0 then
									unbindKey(player, "B", "down", "chatbox", "ChatVIP")
								  end
							end
						end
					else
						outputChatBox("[DayZ-VIP] No se encuentra la cuenta del jugador!",Jugador,255,0,0,true)
					end
				else
					outputChatBox("[DayZ-VIP] No se puede encontrar al jugador!",Jugador,255,0,0,true)
				end
			end
		else
			outputChatBox("[DayZ-VIP] Sintaxis /VIP [Agregar/Remover] [Usuario] [Dias]",Jugador,255,0,0,true)
		end
	else
	outputChatBox("No tienes permiso para esto!",Jugador,255,0,0)  
	end
end
addCommandHandler("VIP",addDonatorTime)


--// Comando para ver los VIP's conectados
addCommandHandler("vips", function(Jugador)
	--// Si no tiene acceso al panel administrativo, cancelar
	if not hasObjectPermissionTo(Jugador, "general.adminpanel") then return end

	Resultado = 0
	outputChatBox("Usuarios VIP's conectados:", Jugador, 0, 255, 0, true)
	for i, v in ipairs(getElementsByType("player")) do
		local Cuenta = getPlayerAccount(v)
		if Cuenta and getAccountData(Cuenta, "donatorEnabled") == 1 then
			Resultado = Resultado + 1
			local currentTime = getRealTime()
			local donatorTime = tonumber(getAccountData(Cuenta,"donatorTime"))
			local Tiempo = secoundsToDays(donatorTime-currentTime.timestamp)
			outputChatBox(" * "..getPlayerName(v).." #00ff00("..getAccountName(Cuenta)..") ("..Tiempo..")", Jugador, 0, 255, 0, true)
		end
	end
	
	--// Si no hay VIP's conectados, informar
	if Resultado == 0 then
		outputChatBox("Ninguno", Jugador, 0, 255, 0, true)
	end
end)

addCommandHandler("listavip", function(Jugador)
	--// Si no tiene acceso al panel administrativo, cancelar
	if not hasObjectPermissionTo(Jugador, "general.adminpanel") then return end

	Resultado = 0
	outputChatBox("---------------------------", Jugador, 0, 230, 50)
	outputChatBox("-- Lista de usuarios VIP --", Jugador, 0, 230, 50)
	outputChatBox("---------------------------", Jugador, 0, 230, 50)

	for i, v in ipairs(getAccounts()) do
		if getAccountData(v, "donatorEnabled") and getAccountData(v, "donatorEnabled") == 1 then
			Resultado = Resultado + 1
			local currentTime = getRealTime()
			local donatorTime = tonumber(getAccountData(v,"donatorTime"))
			if donatorTime-currentTime.timestamp >= 1 then
				local Tiempo = secoundsToDays(donatorTime-currentTime.timestamp)
				outputChatBox(" - "..getAccountName(v).." ("..Tiempo..")", Jugador, 0, 230, 50, true)
			end
		end
	end
	
	--// Si no hay VIP's conectados, informar
	if Resultado == 0 then
		outputChatBox("Ninguno", Jugador, 0, 255, 0, true)
	end
end)

function secoundsToDays(secound)
	if secound then
		local value,state
		if secound >= 86400 then
			value = math.floor(secound/86400)
			if secound - (value*86400) > (60*60) then
				value = value.." dias y "..math.floor((secound - (value*86400))/(60*60)).." horas"
			else
				value = value.." dias"
			end
			state = 1
		else
			value = 0 .." dias y "..math.floor(secound/(60*60)).." horas"
			state = 2
		end
		return value
	else
		return false
	end
end


function donatorLogin(thePlayer)
	if thePlayer then
		local account = getPlayerAccount(thePlayer)
		if not isGuestAccount(account) then
			local donatorState,donatorTime = false,"No disponible"
			if getAccountData(account,"donatorEnabled") == 1 then
				local donatorTime = tonumber(getAccountData(account,"donatorTime"))
				if donatorTime then
					local currentTime = getRealTime()
					if donatorTime > currentTime.timestamp then
						local donatorState,donatorTime = true,secoundsToDays(donatorTime-currentTime.timestamp)
						outputChatBox("#FFFF00[VIP]#ffffff Tu tiempo de V.I.P expira en "..donatorTime..". Gracias por comprar el sistema VIP.",thePlayer,255,255,255,true)
						callClientFunction(thePlayer,"setDonatorInfo",donatorState,donatorTime)
					else
						setAccountData(account,"donatorEnabled",0)
						outputChatBox("#306EFF[DONATOR]#ffffff Tu tiempo de V.I.P ha expirado",thePlayer,255,255,255,true)
						return donatorLogin(thePlayer)
					end
				end
			else
				local donatorState,donatorTime = false,"No disponible"
				callClientFunction(thePlayer,"setDonatorInfo",donatorState,donatorTime)
			end
		end
	end
end
