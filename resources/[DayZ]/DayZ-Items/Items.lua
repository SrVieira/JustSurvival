--// Creador: TheCrazy
--// Fecha: 11/04/2016
--// Proposito: Funcionamiento general de los items

----------------------------
-- Definiciones de items --
----------------------------

Tipos = {
	"Granja",
	"Industrial",
	"Militar",
	"Residencial",
	"Supermercado"
}

----------------------------
-- Definiciones de zonas --
----------------------------

Zonas = {}

Zonas["Granja"] = {
	{"Bidon vacio", 60},
	{"Cuchillo", 60},
	{"Revolver", 50},
	{"Winchester 1866", 40},
	{"Ballesta", 30},
	{"Pila de madera", 80},
	{"Machado", 70},
	{"Benelli", 40},	
	{"Mountain Light Backpack", 60},	
	{"Camping Backpack", 70},	
}

Zonas["Industrial"] = {
	{"Neumatico", 70},
	{"Motor", 35},
	{"Rotador", 30},
	{"Bidon vacio", 80},
	{"Trozo de metal", 40},
	{"Machado", 20},
	{"Cuchillo", 20},
	{"Caixa de Ferramentas", 80},
	{"Caixa de Fósforo", 40},
	{"Improvised Backpack", 30},
}

Zonas["Militar"] = {
	{"M9", 60},
	{"M16", 50},
	{"Mk14-EBR", 30},
	{"Steyr AUG", 40},
	{"USP45", 40},
	{"Beretta M92F", 50},
	{"AK-74", 40},
	{"AK-74 PSO", 30},
	{"AKS-74UN Kobra", 20},
	{"PKM", 30},
	{"AS50", 20},
	{"USP45 SD", 50},
	{"M107", 30},
	{"M4A3 CCO", 40},
	{"G36C", 40},
	{"PDW", 50},
	{"Remington 870", 50},
	{"M1911", 60},
	{"MP5A5", 65},
	{"Bizon PP-19 SD", 40},
	{"Barret 50", 20},
	{"Binóculos", 80},
	{"Cuchillo", 70},
	{"GPS", 60},
	{"Óculos de Visão Noturna", 35},
	{"Óculos de Visão Termal", 35},
	{"Mapa", 60},
	{"Assault Light Backpack", 60},
	{"Bússola", 70},
	{"Cabo Backpack", 40},
	{"Mochila Asalto", 60},
	{"Mochila Coyote", 70},
	{"Traje Ghillie", 30},
	{"Police Suit", 30},
	{"Veterano Suit", 30},
	{"Camo Suit", 30},
}

Zonas["Residencial"] = {
	{"Mountain Dew", 40},
	{"Relógio", 50},
	{"Bússola", 20},
	{"Mapa", 40},
	{"Beretta M92F", 30},
	{"M1911", 30},
	{"Cuchillo", 80},
	{"Caixa de Fósforo",90},
	{"Revolver", 30},
	{"Assault Light Backpack", 40},
	{"Czech Camo Backpack", 50},
	{"Mochila Asalto", 60},
	{"Mochila Alice", 40},
	{"Winchester 1866", 30},
	{"Tienda basica", 20},
	{"Survivor Suit", 60},
	{"Ballesta", 10},
	{"Binóculos", 30},
	{"Pila de madera", 40},
	{"Palanca", 40},
	{"Benelli", 10},
}

Zonas["Supermercado"] = {
	{"Relógio", 60},
	{"Bússola", 30},
	{"Mapa", 80},
	{"M1911", 30},
	{"Cuchillo", 60},
	{"Caixa de Fósforo", 80},
	{"Revolver", 15},
	{"Survivor Backpack", 60},
	{"Mochila Asalto", 60},
	{"Schoolar Backpack", 70},
	{"Mountain Backpack", 50},
	{"Mochila Alice", 50},
	{"Tienda basica", 30},
	{"Ballesta", 10},
	{"Binóculos", 60},
	{"Pila de madera",20},
	{"Remington 870", 20},
}

----------------------
-- Funciones utiles --
----------------------

function Porcentaje(Val)
	local Num = math.random(0, 100)

	if Num <= Val then
		return 1
	end

	return 0
end

function destroyItem(Col)
	if isElement(Col) then
		killTimer(Col:getData('Timer'))
		destroyElement(Col:getData('parent'))
		destroyElement(Col)
	end
end
addEvent("destroyPickupItem", true)
addEventHandler("destroyPickupItem", getRootElement(), destroyItem)

-------------------------
-- Funciones de items --
-------------------------

-- Crea un item en el suelo, que puede ser tomado
function Items.Crear(Datos)
	local Info = getItemData(Datos.Item)

	if not Info then
		outputDebugString("Error, no se encontró la información de "..Datos.Item)
		return
	end

	local Item = createObject(Info[1], Datos.X, Datos.Y, Datos.Z, Info[3] or 0, 0, math.random(0, 360))
	
	if not isElement(Item) then
		outputChatBox("Modelo invalido para "..Datos.Item, root, 255, 0, 0)
	end

	local Col = createColSphere(Datos.X, Datos.Y, Datos.Z + 0.8, 0.75)

	setObjectScale(Item, Info[2] or 1)
	setElementCollisionsEnabled(Item, false)
	setElementFrozen(Item, true)

	Col:setData('item', Datos.Item)
	Col:setData('parent', Item)
	Col:setData('value', Datos.Valor or 1)

	Col:setData('Timer', setTimer(destroyItem, 900000, 1, Col))
end
addEvent("Items:Crear", true)
addEventHandler("Items:Crear", getRootElement(), Items.Crear)

function createItem(Item, Value)
	if source:getData(Item) <= 0 then return end

	local X, Y, Z = getElementPosition(source)

	Datos = {}

	Datos.X = X + math.random(-1.1, 1.1)
	Datos.Y = Y + math.random(-1.1, 1.1)
	Datos.Z = Z - 0.875
	Datos.Item = Item

	if Value then
		Datos.Valor = Value
	else
		Datos.Valor = 1
	end

	Items.Crear(Datos)

	source:setData(Item, source:getData(Item) - Datos.Valor)

	triggerEvent('Jugador:TirarItem', source, Item)
end
addEvent("onPlayerDropItem", true)
addEventHandler("onPlayerDropItem", getRootElement(), createItem)

function onPlayerTakeItem(Col)
	if not isElement(Col) then return end

	local Item = Col:getData('item')

	source:setData(Item, (source:getData(Item) or 0) + Col:getData('value'))

	triggerEvent('Jugador:TakeItem', source, Item, Col:getData('value'))

	killTimer(Col:getData('Timer'))
	destroyElement(Col:getData('parent'))
	destroyElement(Col)
end
addEvent("onPlayerTakeItem", true)
addEventHandler("onPlayerTakeItem", getRootElement(), onPlayerTakeItem)

-----------------------------------
-- Funcionamiento del recurso --
-----------------------------------

lootPoints = {}
lootCounter = 0

function Items.Inicio()
	for i, Zona in ipairs(Tipos) do
		local Archivo = fileOpen("Zonas/"..Zona..".txt")
		local Bytes = fileGetSize(Archivo)
		local Buffer = fileRead(Archivo, tonumber(Bytes))
		local Datos = split(Buffer, "\n")

		for k, v in ipairs(Datos) do
			local Pos = split(v, ",")

			if Pos[1] and Pos[2] and Pos[3] then 
				lootCounter = lootCounter + 1
				lootPoints[lootCounter] = createColSphere(Pos[1], Pos[2], Pos[3], 1.25)
				lootPoints[lootCounter]:setData('Zona', Zona)
				lootPoints[lootCounter]:setData('loot', true)
				lootPoints[lootCounter]:setData('lootname', "Zona")
				lootPoints[lootCounter]:setData('MAX_Slots', 0)
				lootPoints[lootCounter]:setData('PosData', Zona..": "..v)

				refrescarLoot(lootPoints[lootCounter], true)
			else
				outputDebugString("Error "..v..":"..i)
			end
		end

		fileClose(Archivo)
	end
end
addEventHandler("onResourceStart", resourceRoot, Items.Inicio)

function refrescarLoot(Col, Refresh)
    local Objetos = Col:getData('Objetos')
	local Zona = Col:getData('Zona')

	-- Se destruyen los objetos que ya existian
    if Objetos then
		for k, v in ipairs(Objetos) do
			if isElement(v) then
				destroyElement(v)
			end
		end
    end

	if Refresh then
		for k, v in ipairs(Items) do
			Col:setData(v, 0)
		end

		for i = 1, 3 do
			local Random = math.random(1, #Zonas[Zona])
			local Value = Porcentaje(Zonas[Zona][Random][2])
			--local Dato = exports.DayZ:getWeaponData(Zonas[Zona][Random][1])

			Col:setData(Zonas[Zona][Random][1], Value)
			
			if Value >= 1 and exports.DayZ:isWeapon(Zonas[Zona][Random][1]) then
				local Datos = exports.DayZ:getWeaponData(Zonas[Zona][Random][1])
				
				for i = 1, math.random(1, 2) do
					Col:setData(Datos[1], math.ceil((Col:getData(Datos[1]) or 0) + Datos[2] * (math.random(70, 130) / 100)))
				end
			end
			--if Value >= 1 and Dato and Dato[3] ~= Zonas[Zona][Random][1] then
				--Col:setData(Dato[3], Dato[4] * math.random(1,2))
			--end
		end
	end

    local Numero = 0
    local Objetos = {}

    for i, Item in ipairs(Items) do
        if getElementData(Col, Item) and getElementData(Col, Item) > 0 then
			Numero = Numero + 1
			local Info = getItemData(Item)
            local X, Y, Z = getElementPosition(Col)
            Objetos[Numero] = createObject(Info[1], X + math.random(-1, 1), Y + math.random(-1, 1), Z - 0.875, Info[3] or 0)
			setObjectScale(Objetos[Numero], Info[2] or 1)
            setElementCollisionsEnabled(Objetos[Numero], false)
            setElementFrozen(Objetos[Numero], true)
        end
    end

	setElementData(Col, "Objetos", Objetos)
end
addEvent("refrescarLoot", true)
addEventHandler("refrescarLoot", getRootElement(), refrescarLoot)
refreshTimer = false

function refrescarZonas()
	aviso = false

	for i = 1, 175 do
		refrescarLoot(lootPoints[i], true)
	end
	
	refreshCounter = 175
	refreshLimit = (175 * 2)

	refreshTimer = setTimer(function()
		for i = refreshCounter, refreshLimit do
			if lootPoints[i] then
				refrescarLoot(lootPoints[i], true)
			else
				if not aviso then
					outputDebugString("Refresco finalizado !")
					aviso = true
					killTimer(refreshTimer)
				end
			end
		end
		
		refreshCounter = refreshCounter + 175
		refreshLimit = refreshLimit + 175
	end, 10000, 50)
end
Temporizador = setTimer(refrescarZonas, 3600000, 0)

addCommandHandler('Refrescar', function(Jugador)
	killTimer(Temporizador)

	outputChatBox('#6CA53F[Información] #FFFFFF'..Jugador.name..' #6CA53Finició el refresco manual de items!', root, 0, 0, 0, true)
	refrescarZonas()
	
	Temporizador = setTimer(refrescarZonas, 3600000, 0)
end, true, true)

function secondsToTimeDesc( seconds )
	if seconds then
		local results = {}
		local sec = math.floor(( seconds %60 ))
		local min = math.floor ( ( seconds % 3600 ) /60 )
 
		if min > 0 then table.insert( results, min .. ( min == 1 and " minuto" or " minutos" ) ) end
		if sec > 0 then table.insert( results, sec .. ( sec == 1 and " segundo" or " segundos" ) ) end
 
		return string.reverse ( table.concat ( results, ", " ):reverse():gsub(" ,", " y ", 1 ) )
	end

	return ""
end