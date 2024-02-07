local screenW, screenH = guiGetScreenSize()
local sidemenu = {}
local count_row = 0
local cache = false
local header = false
local newbieMessage = false
local currentCol = false
local dupTimer

function getPlayerInCol(tab)
	for _,v in ipairs(tab) do
		if (v ~= localPlayer) then
			return true
		end
	end
	return false
end

function displaySidemenu()
	if getElementData(localPlayer, "Logeado") then
		if #sidemenu > 0 then
			if string.find(header, "#%x%x%x%x%x%x") then 
				header = string.gsub(header, "#%x%x%x%x%x%x", "") 
			end

			local offH = 5
			local rowHeight = dxGetFontHeight(1, "default")
			local headerHeight = dxGetFontHeight(1, "default-bold")
			local rheight = headerHeight + offH + (rowHeight * #sidemenu)
			local py = (screenH / 2 - 50) - (rheight/2)
			
			dxDrawRectangle(0, py, 210, rheight, tocolor(0, 0, 0, 100), false)
			dxDrawRectangle(0, py, 210, headerHeight + offH, tocolor(0, 0, 0, 100), false)
			dxDrawText(header, 5, py + offH/2, 5, 0, tocolor(50, 100, 134, 255), 1, "default-bold", "left", "top")
			dxDrawText(newbieMessage or "", 6, py + rheight + offH + 1, 0, 0, tocolor(0, 0, 0, 200), size, "default-bold", "left", "top")
			dxDrawText(newbieMessage or "", 5, py + rheight + offH, 0, 0, tocolor(255, 255, 255, 200), size, "default-bold", "left", "top")

			for i, d in ipairs(sidemenu) do
				if count_row and count_row == i then
					dxDrawRectangle(0, py + headerHeight + offH + (i-1)*rowHeight, 210, rowHeight, tocolor(50, 100, 134, 200), false)
					dxDrawText(d[1], 5, py + headerHeight + offH + (i-1)*rowHeight, 5, 0, tocolor(0, 0, 0, 200), 1, "default-bold", "left", "top")
				else
					dxDrawText(d[1], 5, py + headerHeight + offH + (i-1)*rowHeight, 5, 0, tocolor(255, 255, 255, 200), 1, "default-bold", "left", "top")
				end	
			end
			
			if isElement(currentCol) then
				local x, y, z = getElementPosition(currentCol)
				local sx, sy = getScreenFromWorldPosition(x, y, z)
				if sx and sy and getElementData(localPlayer, "loot") then
					dxDrawImage(sx, sy, 128, 80, "images/misc/loot.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				end
			end			
		end
	end
end
addEventHandler("onClientRender", root, displaySidemenu)

function checkLootOnVehicle(player, seat)
	if player == localPlayer then
		if (seat == 0) then
			local col = getElementData(source, "parent")
			if isElement(col) then
				if getPedOccupiedVehicle(localPlayer) then -- will make that vehicleStartEnter's event does not effect anything.
					setElementData(localPlayer, "currentCol", col)
					setElementData(localPlayer, "loot", true)
				end
			end
		end
		clearMenuTable()
	end
end
addEventHandler("onClientVehicleEnter", root, checkLootOnVehicle)
addEventHandler("onClientVehicleStartEnter", root, checkLootOnVehicle)

function checkLootOnLeaveVehicle(player, seat)
	if player == localPlayer then
		setElementData(localPlayer, "currentCol", nil)
		setElementData(localPlayer, "loot", nil)
		if isInventoryVisible() then
			closeInventory()
		end
	end
end
addEventHandler("onClientVehicleExit", root, checkLootOnLeaveVehicle)
addEventHandler("onClientVehicleStartExit", root, checkLootOnLeaveVehicle)

function clearMenuOnDestroy()
	if source == getElementData(localPlayer, "currentCol") then
		clearMenuTable()
	end
end
addEventHandler("onClientElementDestroy", root, clearMenuOnDestroy)

--[[
function proccedLootCheckTimer()
	local loot = getElementData(localPlayer, "currentCol")
	if isElement(loot) then
		if (#getElementsWithinColShape(loot, "player") > 1) then
			if isInventoryVisible() then
				closeInventory()
			end
			killTimer(dupTimer)
		end
	end
end
]]

function proccedLootCheckTimer()
	local loot = getElementData(localPlayer, "currentCol")
	if isElement(loot) then
		if (#getElementsWithinColShape(loot, "player") > 1) then
			setElementData(localPlayer, "loot", false)
			inventoryUpdate()
			clearMenuTable()
			killTimer(dupTimer)
		end
	end
end

function onPlayerColShapeEnterData(element)
	if (element == localPlayer) and getElementData(localPlayer, "Logeado") and not getElementData(localPlayer, "dead") and not getPedOccupiedVehicle(localPlayer) then
		if (getElementData(source, "parent") == localPlayer) then 
			return 
		end
		if (tostring(getPedSimplestTask(localPlayer)) == "TASK_SIMPLE_GO_TO_POINT") then
			return
		end
		if isInventoryVisible() then
			clearMenuTable()
			return
		end
		if element == localPlayer then
			if isTimer(dupTimer) then
				killTimer(dupTimer)
			end
			dupTimer = setTimer(proccedLootCheckTimer, 200, 0)
		end
		if getElementData(source, "player") then
			setElementData(localPlayer, "currentCol", source)
			setElementData(localPlayer, "loot", false)
			insertMenuTypeTable("player", source)
			return
		end
		if isElement(getPlayerInCol(getElementsWithinColShape(source, "player"))) then
			return
		end
		if (#getElementsWithinColShape(source, "player") > 1) then
			return
		end
		if getElementData(source, "loot") then
			setElementData(localPlayer, "currentCol", source)
			setElementData(localPlayer, "loot", true)
			insertMenuTypeTable("loot", source)
			return
		end
		if getElementData(source, "tent") then
			setElementData(localPlayer, "currentCol", source)	
			setElementData(localPlayer, "loot", true)
			insertMenuTypeTable("tent", source)
			return
		end
		if getElementData(source, "deadanimal") then
			setElementData(localPlayer, "currentCol", source)
			setElementData(localPlayer, "loot", false)
			insertMenuTypeTable("deadanimal", source)
			return
		end
		if getElementData(source, "tramp") then
			setElementData(localPlayer, "currentCol", source)
			setElementData(localPlayer, "loot", false)
			insertMenuTypeTable("tramp", source)		
			return
		end
		if getElementData(source, "item") then
			setElementData(localPlayer, "currentCol", source)
			setElementData(localPlayer, "loot", false)
			insertMenuTypeTable("item", source)
			return
		end
		if getElementData(source, "vehicle") then
			local vehicle = getElementData(source, "parent")
			if isElement(vehicle) and getElementType(vehicle) == "vehicle" then
				if not getVehicleController(vehicle) and not isVehicleBlown(vehicle) then
					setElementData(localPlayer, "currentCol", source)
					setElementData(localPlayer, "loot", true)
					insertMenuTypeTable("vehicle", source)
					return
				end
			end
		end
		if getElementData(source, "deadperson") then
			setElementData(localPlayer, "currentCol", source)
			setElementData(localPlayer, "loot", true)
			insertMenuTypeTable("deadperson", source)
			return
		end
		if getElementData(source, "zombie") then
			setElementData(localPlayer, "currentCol", source)
			setElementData(localPlayer, "loot", true)
			insertMenuTypeTable("zombie", source)
			return
		end		
		if getElementData(source, "vehiclecrash") then
			setElementData(localPlayer, "currentCol", source)
			setElementData(localPlayer, "loot", true)
			insertMenuTypeTable("vehiclecrash", source)	
			return
		end
		if getElementData(source, "helicrashside") then
			setElementData(localPlayer, "currentCol", source)
			setElementData(localPlayer, "loot", true)
			insertMenuTypeTable("helicrashside", source)	
			return
		end
		if getElementData(source, "medicalbox") then
			setElementData(localPlayer, "currentCol", source)
			setElementData(localPlayer, "loot", true)
			insertMenuTypeTable("medicalbox", source)
			return
		end
		if getElementData(source, "patrolstation") then
			setElementData(localPlayer, "currentCol", source)	
			setElementData(localPlayer, "loot", false)
			insertMenuTypeTable("patrolstation", source)
			return
		end
		if getElementData(source, "wirefence") then
			setElementData(localPlayer, "currentCol", source)
			setElementData(localPlayer, "loot", false)
			insertMenuTypeTable("wirefence", source)
			return
		end
		if getElementData(source, "briefcase") then
			setElementData(localPlayer, "currentCol", source)
			setElementData(localPlayer, "loot", true)
			insertMenuTypeTable("briefcase", source)
			return
		end
		if getElementData(source, "fireplace") then
			setElementData(localPlayer, "currentCol", source)
			setElementData(localPlayer, "loot", false)
			insertMenuTypeTable("fireplace", source)
			return
		end
		if getElementData(source, "customloot") then
			setElementData(localPlayer, "currentCol", source)
			if getElementData(source, "MAX_Slots") then
				setElementData(localPlayer, "loot", true)
			else
				setElementData(localPlayer, "loot", false)
			end
			insertMenuTypeTable("customloot", source)	
			return
		end
	end
end
addEventHandler("onClientColShapeHit", root, onPlayerColShapeEnterData)

function onPlayerColShapeLeaveData(element)
	if element == localPlayer then
		if (getElementData(source, "parent") == localPlayer) then
			return
		end

		setElementData(localPlayer, "currentCol", nil)
		setElementData(localPlayer, "loot", false)	
		
		if isInventoryVisible() and not getPedOccupiedVehicle(localPlayer) then
			closeInventory()
		end
		
		if isTimer(dupTimer) then
			killTimer(dupTimer)
		end
		
		clearMenuTable()
	end
end
addEventHandler("onClientColShapeLeave", root, onPlayerColShapeLeaveData)

function setNewbieMessage(col, title, content)
	currentCol = col
	header = tostring(title)
	newbieMessage = tostring(content)
end

function insertMenuTypeTable(menuType, col)
	if menuType then	
		clearMenuTable()
		currentCol = col
	
		bindKey("-", "down", applySelection)
		bindKey("mouse3", "down", applySelection)

		if menuType == "player" then
			local player = getElementData(col, "parent")
			if isElement(player) and not getPedOccupiedVehicle(player) and player ~= localPlayer then
				if getElementData(player, "bleeding") and getElementData(player, "bleeding") > 0 then
					if getElementData(localPlayer, "Curativo") and getElementData(localPlayer, "Curativo") > 0 then
						table.insert(sidemenu, {"Detener sangrado", "stop_bleeding"})
						setNewbieMessage(col, getPlayerName(player):gsub("#%x%x%x%x%x%x", ""), "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
					end
				end
				
				if getElementData(player, "pain") and getElementData(player, "pain") > 0 then
					if getElementData(localPlayer, "Analgésicos") and getElementData(localPlayer, "Analgésicos") > 0 then
						table.insert(sidemenu, {"Curar dolores", "stop_pain"})
						setNewbieMessage(col, getPlayerName(player):gsub("#%x%x%x%x%x%x", ""), "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
					end
				end				
				
				if getElementData(player, "brokenbone") and getElementData(player, "brokenbone") > 0 then
					if getElementData(localPlayer, "Morfina") and getElementData(localPlayer, "Morfina") > 0 then
						table.insert(sidemenu, {"Curar hueso roto", "reset_bonecrack"})
						setNewbieMessage(col, getPlayerName(player):gsub("#%x%x%x%x%x%x", ""), "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
					end
				end
				
				if getElementData(player, "infection") and getElementData(player, "infection") > 0 then
					if getElementData(localPlayer, "Antibioticos") and getElementData(localPlayer, "Antibioticos") > 0 then
						table.insert(sidemenu, {"Detener infeccion", "stop_infection"})
						setNewbieMessage(col, getPlayerName(player):gsub("#%x%x%x%x%x%x", ""), "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
					end
				end				
				
				if getElementData(player, "blood") and getElementData(player, "blood") < 12000 then
					--if getElementData(localPlayer, "Transfusor de sangre") and getElementData(localPlayer, "Transfusor de sangre") > 0 then
						--local hisBloodType = getElementData(player, "bloodType")
						if getElementData(localPlayer, "Bolsa de sangre") and getElementData(localPlayer, "Bolsa de sangre") > 0 then
							table.insert(sidemenu, {"Realizar transfusion", "make_bloodtransfusion"})
							setNewbieMessage(col, getPlayerName(player):gsub("#%x%x%x%x%x%x", ""), "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
						end
					--end
					if getElementData(localPlayer, "Botiquin") and getElementData(localPlayer, "Botiquin") > 0 then
						table.insert(sidemenu, {"Aplicar botiquin", "medickit"})
						setNewbieMessage(col, getPlayerName(player):gsub("#%x%x%x%x%x%x", ""), "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
					end
				end
			end
			
		elseif menuType == "patrolstation" then
			if getElementData(col, "isfull") then
				table.insert(sidemenu, {"Llenar bidon", "fill_canister"})
				setNewbieMessage(col, "Patrol", "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
			else
				triggerEvent("displayClientInfo", localPlayer, "Este contenedor no tiene gasolina", {255,255,255})
			end
		elseif menuType == "wirefence" then
			table.insert(sidemenu, {"Remover valla de alambre", "remove_wirefence"})	
			setNewbieMessage(col, "Valla de alambre", "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
		elseif menuType == "tramp" then
			if getElementData(localPlayer, "Caja de herramientas") and getElementData(localPlayer, "Caja de herramientas") > 0 then
				table.insert(sidemenu, {"Desactivar '"..tostring(getElementData(col, "tramp")).."'", "remove_tramp"})
				setNewbieMessage(col, tostring(getElementData(col, "tramp")), "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")	
			end
		elseif menuType == "medicalbox" then
			table.insert(sidemenu, {"Gear (Caja medica)", "check"})
			setNewbieMessage(col, "Caja medica", "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
		elseif menuType == "briefcase" then
			table.insert(sidemenu, {"Gear (Maletin)", "check"})
			setNewbieMessage(col, "Maletin", "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")			
		elseif menuType == "deadperson" then
			table.insert(sidemenu, {"Revisar cuerpo", "check"})
			table.insert(sidemenu, {"Informacion del cuerpo", "check_info"})
			setNewbieMessage(col, getElementData(col, "lootname") or "Cadaver", "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
		elseif menuType == "zombie" then
			table.insert(sidemenu, {"Revisar cuerpo", "check"})
			table.insert(sidemenu, {"Informacion del cuerpo", "check_info"})
			setNewbieMessage(col, "Zombie", "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")			
		elseif menuType == "tent" then
			table.insert(sidemenu, {"Gear (Tienda)", "check"})	
			table.insert(sidemenu, {"Desmontar Tienda", "remove_tent"})
			setNewbieMessage(col, "Tienda", "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
		elseif menuType == "vehiclecrash" then
			table.insert(sidemenu, {"Gear (Vehiculo destruido)", "check"})
			setNewbieMessage(col, "Vehiculo destruido", "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
		elseif menuType == "helicrashside" then
			table.insert(sidemenu, {"Gear (Helicoptero destruido)", "check"})
			setNewbieMessage(col, "Helicoptero destruido", "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")			
		elseif menuType == "loot" then
			table.insert(sidemenu, {"Gear ("..(getElementData(col, "lootname") or "??")..")", "check"})
			setNewbieMessage(col, getElementData(col, "lootname") or "??", "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
		elseif menuType == "deadanimal" then
			table.insert(sidemenu, {"Obtener carne", "get_rawmeat"})
			table.insert(sidemenu, {"Informacion del animal", "check_info"})
			setNewbieMessage(col, "Animal muerto", "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
		elseif menuType == "customloot" then
			table.insert(sidemenu, {"Gear ("..(getElementData(col, "lootname") or "??")..")", "check"})
			setNewbieMessage(col, getElementData(col, "lootname") or "??", "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
		elseif menuType == "fireplace" then	
			if getElementData(localPlayer, "cold") and getElementData(localPlayer, "cold") > 0 then
				table.insert(sidemenu, {"Calentarse", "heatup"})
			end
			if getElementData(col, "fireplaceOn") then
				if getElementData(localPlayer, "Carne cruda") and getElementData(localPlayer, "Carne cruda") > 0 then
					table.insert(sidemenu, {"Cocinar carne", "cook"})
				end
				table.insert(sidemenu, {"Apagar Fogata", "switch_fireplace"})
			else
				table.insert(sidemenu, {"Encender Fogata", "switch_fireplace"})
			end			
			table.insert(sidemenu, {"Informacion de la fogata", "check_info"})
			setNewbieMessage(col, "Fogata", "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
		elseif menuType == "item" then
			local itemName = getItemName(getElementData(col, menuType))
			table.insert(sidemenu, {"Recoger '"..tostring(itemName).."'", "pickup"})
			if getElementData(col, menuType) == "Pila de madera" then
				table.insert(sidemenu, {"Hacer una fogata", "fireplace"})
			end
			setNewbieMessage(col, tostring(itemName), "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")
		elseif menuType == "vehicle" then
			local vehicle = getElementData(col, "parent")
			
			if isElement(vehicle) then 
				local id = getElementModel(vehicle)
				local vehiclecol = col

				table.insert(sidemenu, {"Gear ("..(getVehicleNewName(getElementModel(vehicle)) or getVehicleName(vehicle))..")", "check"})
				setNewbieMessage(col, getVehicleNewName(getElementModel(vehicle)) or getVehicleName(vehicle), "Pulsa 'Middle-Mouse' o '-' para seleccionadar!")

				if (getElementHealth(vehicle)) < 800 then
					table.insert(sidemenu, {"Reparar Vehiculo", "restore_vehicle"})
				end				
				if getVehicleType(vehicle) ~= "BMX" then
					if getVehicleType(vehicle) ~= "Helicopter" then
						if getVehicleMaxTires(id) then
							if (getElementData(vehiclecol, "vehicleTires") or 0) < getVehicleMaxTires(id) then
								table.insert(sidemenu, {"Reparar Neumaticos ("..(getElementData(vehiclecol, "vehicleTires") or 0)..")", "fix_tires"})
							end
						end
					else
						if getVehicleMaxRotary(id) then
							if (getElementData(vehiclecol, "vehicleRotary") or 0) < getVehicleMaxRotary(id) then
								table.insert(sidemenu, {"Reparar Rotador ("..(getElementData(vehiclecol, "vehicleRotary") or 0)..")", "fix_rotary"})
							end	
						end
					end
					if getVehicleMaxFuel(id) and getVehicleMaxFuelTank(id) then
						if (getElementData(vehiclecol, "vehicleFuel") or 0) < getVehicleMaxFuel(id) then
							local percent = 100 * (getElementData(vehiclecol, "vehicleFuel") or 0) / getVehicleMaxFuel(id)
							if percent > 100 then percent = 100 end
							if percent < 0 then percent = 0 end
							table.insert(sidemenu, {"Llenar Tanque ("..math.floor(percent).."%)", "refill_vehfuel"})
						end
					end
					if getVehicleMaxEngine(id) then
						if (getElementData(vehiclecol, "vehicleBatery") or 0) < getVehicleMaxBatery(id) then
							table.insert(sidemenu, {"Reparar Bateria ("..(getElementData(vehiclecol, "vehicleBatery") or 0)..")", "fix_batery"})
						end
					end
					if getVehicleMaxEngine(id) then
						if (getElementData(vehiclecol, "vehicleEngine") or 0) < getVehicleMaxEngine(id) then
							table.insert(sidemenu, {"Reparar Motor ("..(getElementData(vehiclecol, "vehicleEngine") or 0)..")", "fix_engine"})
						end
					end
					if getVehicleMaxFuelTank(id) then
						if (getElementData(vehiclecol, "vehicleFuelTank") or 0) < getVehicleMaxFuelTank(id) then
							table.insert(sidemenu, {"Reparar Tanque ("..(getElementData(vehiclecol, "vehicleFuelTank") or 0)..")", "fix_fueltank"})
						end
					end
				end
			end
		end

		count_row = 1
		if sidemenu[count_row] then
			cache = sidemenu[count_row][2]
		end
		
		bindKey("mouse_wheel_up", "down", changeRowSelection, -1)
		bindKey("mouse_wheel_down", "down", changeRowSelection, 1)
	end
end
addEventHandler("insertMenuTypeTable", root, insertMenuTypeTable)

function clearMenuTable()
	sidemenu = {}
	count_row = 0
	cache = false
	header = false
	newbieMessage = false
	currentCol = false

	unbindKey("-", "down", applySelection)
	unbindKey("mouse3", "down", applySelection)
	unbindKey("mouse_wheel_up", "down", changeRowSelection, -1)
	unbindKey("mouse_wheel_down", "down", changeRowSelection, 1)
end
addEvent("onClientSidemenuClear", true)
addEventHandler("onClientSidemenuClear", root, clearMenuTable)

function changeRowSelection(_, _, scroll)
	if cache then
		if count_row then
			if (#sidemenu > 1) then
				playSoundFrontEnd(550)
			end
			count_row = count_row + scroll
			
			if count_row <= 0 then
				count_row = #sidemenu
			elseif count_row > #sidemenu then
				count_row = 1
			end
			
			cache = sidemenu[count_row][2]
		end
	end
end

function applySelection()
	if sidemenu then
		local opt = cache
		local col = currentCol
		
		if opt == "stop_bleeding" then
			setElementData(localPlayer, "Curativo", getElementData(localPlayer, "Curativo") - 1)
			setElementData(getElementData(col, "parent"), "bleeding", 0)
			triggerEvent("displayClientInfo", localPlayer, "Has detenido el sangrado", {255,255,255})
			triggerServerEvent("onPlayerApplyMedicalAttention", localPlayer, getElementData(col, "parent"))
			inventoryUpdate()
			clearMenuTable()
			return
		end
		
		if opt == "stop_infection" then
			setElementData(localPlayer, "Antibioticos", getElementData(localPlayer, "Antibioticos") - 1)
			setElementData(getElementData(col, "parent"), "infection", 0)
			triggerEvent("displayClientInfo", localPlayer, "Has detenido la infeccion", {255,255,255})
			triggerServerEvent("onPlayerApplyMedicalAttention", localPlayer, getElementData(col, "parent"))
			inventoryUpdate()
			clearMenuTable()
			return
		end
		
		if opt ==  "reset_bonecrack" then	
			setElementData(localPlayer, "Morfina", getElementData(localPlayer, "Morfina") - 1)
			setElementData(getElementData(col, "parent"), "brokenbone", 0)
			triggerEvent("displayClientInfo", localPlayer, "Has curado el hueso roto", {255,255,255})
			triggerServerEvent("onPlayerApplyMedicalAttention", localPlayer, getElementData(col, "parent"))
			inventoryUpdate()
			clearMenuTable()
			return
		end
		
		if opt ==  "stop_pain" then	
			setElementData(localPlayer, "Analgésicos", getElementData(localPlayer, "Analgésicos") - 1)
			setElementData(getElementData(col, "parent"), "pain", 0)
			triggerEvent("displayClientInfo", localPlayer, "Has curado los dolores", {255,255,255})
			triggerServerEvent("onPlayerApplyMedicalAttention", localPlayer, getElementData(col, "parent"))
			inventoryUpdate()
			clearMenuTable()
			return
		end
		
		if opt ==  "medickit" then
			setElementData(localPlayer, "Botiquin", getElementData(localPlayer, "Botiquin") - 1)
			setElementData(getElementData(col, "parent"), "blood", 12000)
			triggerServerEvent("onPlayerApplyMedicalAttention", localPlayer, getElementData(col, "parent"))
			inventoryUpdate()
			clearMenuTable()
			return
		end		
		
		if opt ==  "heatup" then
			setElementData(localPlayer, "cold", 0)
			setElementData(localPlayer, "temperature", 37)
			triggerServerEvent("onPlayerHeatUpFireplace", localPlayer)
			clearMenuTable()
			return
		end
		
		if opt == "make_bloodtransfusion" then
			setElementData(localPlayer, "Bolsa de sangre ("..getElementData(getElementData(col, "parent"), "bloodType")..")", getElementData(localPlayer, "Bolsa de sangre ("..getElementData(getElementData(col, "parent"), "bloodType")..")") - 1)
			setElementData(getElementData(col, "parent"), "blood", (getElementData(getElementData(col, "parent"), "blood") or 0) + 6000)
			triggerEvent("displayClientInfo", localPlayer, "Transfusion realizada", {255,255,255})
			triggerServerEvent("onPlayerApplyMedicalAttention", localPlayer, getElementData(col, "parent"))
			if getElementData(getElementData(col, "parent"), "blood") > 12000 then
				setElementData(getElementData(col, "parent"), "blood", 12000)
			end	
			inventoryUpdate()
			clearMenuTable()
			return
		end
		
		if opt == "fill_canister" then
			if getElementData(localPlayer, "Bidon vacio") and getElementData(localPlayer, "Bidon vacio") > 0 then
				blockInventory(true)
				setElementData(col, "isfull", false)
				playSound("sounds/effects/action_refuel.ogg")
				triggerServerEvent("onPlayerEmptyCanisterRefill", localPlayer, col)
			else
				triggerEvent("displayClientInfo", localPlayer, "Necesitas un bidon para obtener la gasolina", {255,0,0})
			end
			clearMenuTable()
			return
		end
			
		if opt == "fireplace" then
			triggerServerEvent("onCreateFireplace", localPlayer, col)	
			clearMenuTable()
			return
		end

		if opt == "switch_fireplace" then
			local state = getElementData(col, "fireplaceOn")
			if state then
				triggerServerEvent("onPlayerSwitchFireplace", localPlayer, col, false)
			else
				if getElementData(localPlayer, "Cerillos") and getElementData(localPlayer, "Cerillos") > 0 then
					triggerServerEvent("onPlayerSwitchFireplace", localPlayer, col, true)
				else
					triggerEvent("displayClientInfo", localPlayer, "Necesitas cerillos para hacer una fogata", {255,0,0})
				end
			end

			clearMenuTable()
			return
		end
		
		if opt == "remove_tent" then
			local data = getElementData(col, "tent")
			triggerServerEvent("onPlayerRemoveTent", localPlayer, col, data)
			clearMenuTable()
			return
		end
		--[[
		if opt == "Remover valla de alambre" then
			if getElementData(localPlayer, "Caja de herramientas") and getElementData(localPlayer, "Caja de herramientas") > 0 then
				triggerServerEvent("onPlayerRemoveWirefence", localPlayer, col)
			else
				triggerEvent("displayClientInfo", localPlayer, "Necesitas una caja de herramientas para removerla", {255,255,255})
			end
			
			clearMenuTable()
			return
		end
		]]
		if opt == "get_rawmeat" then
			if getElementData(localPlayer, "Cuchillo") and getElementData(localPlayer, "Cuchillo") > 0 then
				local ped = getElementData(col, "parent")

				if isElement(ped) then
					triggerServerEvent("onPlayerRawmeatTaken", localPlayer, ped, col)
				end
			else
				triggerEvent("displayClientInfo", localPlayer, "Necesitas un cuchillo para obtener la carne", {255,0,0})
			end
			
			clearMenuTable()
			return
		end
		
		if opt == "cook" then
			playSound("sounds/effects/action_cook.ogg", false)
			
			setElementData(localPlayer, "Carne cocinada", (getElementData(localPlayer, "Carne cocinada") or 0) + getElementData(localPlayer, "Carne cruda"))
			setElementData(localPlayer, "Carne cruda", 0)
			inventoryUpdate()
			clearMenuTable()
			return
		end
		
		if opt == "check" then
			showInventory()
			clearMenuTable()
			return
		end
		
		if opt == "remove_tramp" then
			local _, _, z = getElementPosition(col)
			triggerServerEvent("onPlayerRemoveTramp", localPlayer, col, z)		
			clearMenuTable()
			return
		end
		
		if opt == "pickup" then
			triggerServerEvent("onPlayerPickupItem", localPlayer, col, tostring(getElementData(col, "item")), tonumber(getElementData(col, "itemPlus")))
			clearMenuTable()
			return
		end
		
		if opt == "check_info" then
			local info = getElementData(col, "info")
			if info then
				triggerEvent("displayClientInfo", localPlayer, info, {255,255,255})	
			end
			clearMenuTable()
			return
		end

		--	MENU DE LOS VEHICULOS	//
		local parent = getElementData(col, "parent")
		if isElement(parent) and getElementType(parent) == "vehicle" then
			local toolbox = getElementData(localPlayer, "Caja de herramientas") and (getElementData(localPlayer, "Caja de herramientas") > 0)
		
			if opt == "refill_vehfuel" then
				if getElementData(col, "vehicleFuelTank") >= getVehicleMaxFuelTank(getElementModel(parent)) then
					if getElementData(localPlayer, "Bidon de gasolina") and (getElementData(localPlayer, "Bidon de gasolina") > 0) then			
						blockInventory(true)
						playSound("sounds/effects/action_refuel.ogg")
						triggerServerEvent("onVehicleGotFixedComplement", localPlayer, "Refuel", parent)
					else	
						triggerEvent("displayClientInfo", localPlayer, "Necesitas un bidon de basolina", {255,0,0})
					end
				else
					triggerEvent("displayClientInfo", localPlayer, "Este vehiculo no tiene un tanque de combustible", {255,0,0})
				end	

				clearMenuTable()
				return				
			end	

			if toolbox then		
				if opt == "restore_vehicle" then
					blockInventory(true)
					playSound("sounds/effects/repair.mp3")
					triggerServerEvent("onVehicleGotFixedComplement", localPlayer, "Normal Fixing", parent)
					clearMenuTable()
					return
				end
				
				if opt == "fix_tires" then
					if getElementData(localPlayer, "Neumatico") and (getElementData(localPlayer, "Neumatico") > 0) then 
						blockInventory(true)
						playSound("sounds/effects/repair.mp3")
						triggerServerEvent("onVehicleGotFixedComplement", localPlayer, "Tires", parent)					
					else
						triggerEvent("displayClientInfo", localPlayer, "No tienes neumaticos", {255,0,0})
					end
					
					clearMenuTable()
					return
				end
				
				if opt == "fix_batery" then
					if getElementData(localPlayer, "Bateria") and (getElementData(localPlayer, "Bateria") > 0) then 
						blockInventory(true)
						playSound("sounds/effects/repair.mp3")
						triggerServerEvent("onVehicleGotFixedComplement", localPlayer, "Batery", parent)
					else
						triggerEvent("displayClientInfo", localPlayer, "Necesitas una bateria", {255,0,0})
					end
					
					clearMenuTable()
					return
				end
				
				if opt == "fix_engine" then
					if getElementData(localPlayer, "Motor") and (getElementData(localPlayer, "Motor") > 0) then 
						blockInventory(true)
						playSound("sounds/effects/repair.mp3")
						triggerServerEvent("onVehicleGotFixedComplement", localPlayer, "Engine", parent)					
					else
						triggerEvent("displayClientInfo", localPlayer, "Necesitas un motor para reparar este vehiculo", {255,0,0})
					end		

					clearMenuTable()
					return
				end
				
				if opt == "fix_fueltank" then
					if getElementData(localPlayer, "Tanque de combustible") and (getElementData(localPlayer, "Tanque de combustible") > 0) then 
						blockInventory(true)
						playSound("sounds/effects/repair.mp3")
						triggerServerEvent("onVehicleGotFixedComplement", localPlayer, "Fuel Tank", parent)					
					else
						triggerEvent("displayClientInfo", localPlayer, "Necesitas un tanque de combustible", {255,0,0})
					end		
					
					clearMenuTable()
					return
				end
				
				if opt == "fix_rotary" then
				
					if getVehicleType(parent) == "Helicopter" then 
						if getElementData(localPlayer, "Rotador") and (getElementData(localPlayer, "Rotador") > 0) then 
							blockInventory(true)
							playSound("sounds/effects/repair.mp3")
							triggerServerEvent("onVehicleGotFixedComplement", localPlayer, "Rotary", parent)						
						else
							triggerEvent("displayClientInfo", localPlayer, "Necesitas un rotador de helicoptero", {255,0,0})
						end		
					else
						triggerEvent("displayClientInfo", localPlayer, "Esta pieza no es ajustable a este vehiculo", {255,0,0})
					end
					
					clearMenuTable()
					return
				end
				
			else
				triggerEvent("displayClientInfo", localPlayer, "Necesitas una caja de herramientas", {255,0,0})
				clearMenuTable()
			end
		end
	end
end