vehicleTimer = {}
fixTimer = {}

function enterVehicleCheck(player, seat)
	local col = getElementData(source, "parent")
	
	if isElement(col) and getElementData(col, "vehicle") then
		if seat == 0 then
			if getVehicleType(source) == "BMX" then return end
		
			if not getVehicleMaxEngine(getElementModel(source)) then return end
			if not getVehicleMaxTires(getElementModel(source)) then return end
			if not getVehicleMaxBatery(getElementModel(source)) then return end
			if not getVehicleMaxFuelTank(getElementModel(source)) then return end
			if not getVehicleMaxRotary(getElementModel(source)) then return end

			if not getElementData(col, "vehicleEngine") or getElementData(col, "vehicleEngine") < getVehicleMaxEngine(getElementModel(source)) then
				setElementData(source, "vehicle_parts", false, false)
				setVehicleEngineState(source, false)
				return
			end

			if getVehicleType(source) ~= "Helicopter" then
				if not getElementData(col, "vehicleTires") or getElementData(col, "vehicleTires") < getVehicleMaxTires(getElementModel(source)) then
					setElementData(source, "vehicle_parts", false, false)
					setVehicleEngineState(source, false)
					return
				end
			end

			if not getElementData(col, "vehicleBatery") or getElementData(col, "vehicleBatery") < getVehicleMaxBatery(getElementModel(source)) then
				setElementData(source, "vehicle_parts", false, false)
				setVehicleEngineState(source, false)
				return
			end

			if not getElementData(col, "vehicleFuel") or math.floor(getElementData(col, "vehicleFuel")) <= 0 then
				setElementData(source, "vehicle_parts", false, false)
				setVehicleEngineState(source, false)
				return
			end

			if not getElementData(col, "vehicleFuelTank") or getElementData(col, "vehicleFuelTank") < getVehicleMaxFuelTank(getElementModel(source)) then
				setElementData(source, "vehicle_parts", false, false)
				setVehicleEngineState(source, false)
				return
			end

			if not getElementData(col, "vehicleRotary") or getElementData(col, "vehicleRotary") < getVehicleMaxRotary(getElementModel(source)) then
				if getVehicleType(source) == "Helicopter" then
					setElementData(source, "vehicle_parts", false, false)
					setVehicleEngineState(source, false)
					return
				end
			end

			bindKey(player, "k", "down", "eng")
			outputChatBox("Pulsa 'K' para encender/apagar el motor", player, 255, 255, 255)
			setElementData(source, "vehicle_parts", true, false)
			setVehicleEngineState(source, false)
		end
	else
		setVehicleEngineState(source, false)
	end
end
addEventHandler("onVehicleEnter", root, enterVehicleCheck)

function toggleVehicleEngine(player)
	local vehicle = getPedOccupiedVehicle(player)
	if vehicle and getElementData(vehicle, "vehicle_parts") and getVehicleController(vehicle) and getVehicleController(vehicle) == player and getVehicleType(vehicle) ~= "BMX" then
		setVehicleEngineState(vehicle, not getVehicleEngineState(vehicle))
	end
end
addCommandHandler("eng", toggleVehicleEngine)

function startVehicleFuelConsummation()
	for _,v in pairs(getElementsByType("vehicle")) do
		if (getElementModel(v) ~= 510) then
			local name = getVehicleName(v)
			local consumition = gameplayVariables["vehicle_consummation"][name]
			if consumition then
				if (getVehicleEngineState(v) == true) then
					local col = getElementData(v, "parent")
					if isElement(col) and getElementData(col, "vehicleFuel") and (getElementData(col, "vehicleFuel") > 0) then
						setElementData(col, "vehicleFuel", getElementData(col, "vehicleFuel") * consumition)
					else
						setVehicleEngineState(v, false)
						if isElement(getVehicleController(v)) then
							unbindKey(getVehicleController(v), "k", "down", "eng")
						end
					end
				end
			end
		end
	end
end
setTimer(startVehicleFuelConsummation, 60000, 0)

function turnOffVehicle(player, seat)
	if (seat == 0) then
		setVehicleEngineState(source, false)
		unbindKey(player, "k", "down", "eng")
	end
end
addEventHandler("onVehicleExit", root, turnOffVehicle)

addEvent("onVehicleGotFixedComplement", true)
function vehicleRequestStatusChange(complement, vehicle)
	local x1, y1, z1 = getElementPosition(source)
	local x2, y2, z2 = getElementPosition(vehicle)
	local col = getElementData(vehicle, "parent")
	local angle = findRotation(x1, y1, x2, y2)

	setPedAnimation(source, "COP_AMBIENT", "Copbrowse_loop", -1, true, false, false)
	setElementRotation(source, 0, 0, angle)

	setElementData(vehicle, "repairer", source)
	setElementData(source, "fixingcar", true)
	setElementFrozen(vehicle, true)

	fixTimer[source] = setTimer(function(source, vehicle, col, complement)
		setElementData(vehicle, "repairer", false)
		setElementData(source, "fixingcar", false)
		setElementFrozen(vehicle, false)
		setPedAnimation(source)
		fixTimer[source] = nil

		if complement == "Fuel Tank" then
			local value = getElementData(source, "Tanque de combustible")
			local currcomp = getElementData(col, "vehicleFuelTank")
			setElementData(col, "vehicleFuelTank", currcomp + 1)
			setElementData(source, "Tanque de combustible", value - 1)
		elseif complement == "Engine" then
			local maxcomp = getVehicleMaxTires(getElementModel(vehicle))
			local value = getElementData(source, "Motor")
			local currcomp = getElementData(col, "vehicleEngine")
			setElementData(col, "vehicleEngine", currcomp + 1)
			setElementData(source, "Motor", value - 1)
		elseif complement == "Rotary" then
			local value = getElementData(source, "Rotador")
			local currcomp = getElementData(col, "vehicleRotary")
			setElementData(col, "vehicleRotary", currcomp + 1)
			setElementData(source, "Rotador", value - 1)
		elseif complement == "Batery" then
			local value = getElementData(source, "Bateria")
			local currcomp = getElementData(col, "vehicleBatery")
			setElementData(col, "vehicleBatery", currcomp + 1)
			setElementData(source, "Bateria", value - 1)	
		elseif complement == "Tires" then
			local value = getElementData(source, "Neumatico")
			local currcomp = getElementData(col, "vehicleTires")
			setElementData(col, "vehicleTires", currcomp + 1)
			setElementData(source, "Neumatico", value - 1)			
		elseif complement == "Refuel" then
			setElementData(col, "vehicleFuel", getVehicleMaxFuel(getElementModel(vehicle)))
			setElementData(source, "Bidon de gasolina", getElementData(source, "Bidon de gasolina") - 1) 
			setElementData(source, "Bidon vacio", (getElementData(source, "Bidon vacio") or 0) + 1) 
		elseif complement == "Normal Fixing" then
			fixVehicle(vehicle)
		end
		triggerClientEvent(source, "onClientInventoryUpdate", source)
		triggerClientEvent(source, "unblockInventory", source)
	end, 6000, 1, source, vehicle, col, complement)
end
addEventHandler("onVehicleGotFixedComplement", root, vehicleRequestStatusChange)

function cancelVehicleUpgrade()
	if fixTimer[source] and isTimer(fixTimer[source]) then
		killTimer(fixTimer[source])
		fixTimer[source] = nil
	end
end
addEventHandler("onPlayerWasted", root, cancelVehicleUpgrade)

addEventHandler("onPlayerQuit", root, function()
	for _,v in ipairs(getElementsByType("vehicle")) do
		if (getElementData(v, "repairer") and getElementData(v, "repairer") == source) then
			setElementFrozen(v, false)
			setElementData(v, "repairer", nil)
			break
		end 
	end
	if fixTimer[source] and isTimer(fixTimer[source]) then
		killTimer(fixTimer[source])
		fixTimer[source] = nil
	end
end)

function hasVehicleFixen()
	if isElement(getElementData(source, "repairer")) then
		cancelEvent()
	end
end
addEventHandler("onVehicleStartEnter", root, hasVehicleFixen)

function restoreBlownVehicles()
	for _, vehicle in ipairs(getElementsByType("vehicle")) do
		if isElement(vehicle) and isVehicleBlown(vehicle) and isElement(getElementData(vehicle, "parent")) then
			restoreVehicleDefaultPosition(vehicle)
		end
	end
end
setTimer(restoreBlownVehicles, 20000, 0)

function restoreVehiclesUnderWater()
	for _, vehicle in ipairs(getElementsByType("vehicle")) do
		if isElement(vehicle) and isElementInWater(vehicle) and isElement(getElementData(vehicle, "parent")) then
			restoreVehicleDefaultPosition(vehicle)
		end
	end
end
setTimer(restoreVehiclesUnderWater, gameplayVariables["VehicleRespawnTimerWater"], 0)

function restoreVehicleDefaultPosition(vehicle)
	local col = getElementData(vehicle, "parent")
	local oldcoords = getElementData(col, "native_pos")
	
	if oldcoords then
		local oldx, oldy, oldz = gettok(oldcoords, 1, ","), gettok(oldcoords, 2, ","), gettok(oldcoords, 3, ",")
		local oldrx, oldry, oldrz = gettok(oldcoords, 4, ","), gettok(oldcoords, 5, ","), gettok(oldcoords, 6, ",")
		
		respawnVehicle(vehicle)
		setTimer(function(vehicle)
			setElementPosition(vehicle, oldx, oldy, oldz)
			setElementRotation(vehicle, oldrx, oldry, oldrz)
		end, 500, 1, vehicle)
		
		setElementData(col, "vehicleEngine", 0)
		setElementData(col, "vehicleTires", 0)
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", 0)
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		
		vehicleTimer[vehicle] = nil
	end
end