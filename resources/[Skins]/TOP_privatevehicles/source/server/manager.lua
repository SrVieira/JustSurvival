--[[
	#	MTA:DayZ Reserved Vehicles 2017 (C)
	#
	#	Author: Enargy
	#	Type: server-side.
	#	File: source/server/manager.lua
	#
	#	All rights reserved to his developers.
]]

local vehicleInfoTable = {}
local vehicleElementTable = {}
local tickTable = {}
local vehicleDatabase = dbConnect("sqlite", "database/privatevehicles.db")
local startetTimestamp = getRealTime().timestamp
local checkInterval = 1800000 -- How many milliseconds will loop the db table to check every period.

addEventHandler("onResourceStart", resourceRoot,
	function()
		dbExec(vehicleDatabase, "CREATE TABLE IF NOT EXISTS `privateVehicles` (`command` TEXT, `owner` TEXT, `period` INTEGER, `vehicle` INTEGER)")
		
		--[[
		for _, item in ipairs(dayzItemTable) do
			dbExec(vehicleDatabase, "ALTER TABLE `privateVehicles` ADD `"..item[1].."` INTEGER")
		end
		]]
		
		local total = 0
		local time = getRealTime().timestamp
		local qh = dbQuery(vehicleDatabase, "SELECT * FROM `privateVehicles`")
		if qh then
			local poll = dbPoll(qh, -1)
			for _, v in ipairs(poll) do
				if not vehicleInfoTable[v.owner] then
					vehicleInfoTable[v.owner] = {}
				end
				
				if time >= v.period then
					outputDebugString("PRIVATE VEHICLE PERIOD FROM '"..v.command.."' HAS FINISHED.")
					dbExec(vehicleDatabase, "DELETE FROM `privateVehicles` WHERE command=?", v.command)
				else
					vehicleInfoTable[v.owner][v.command] = {}
					addCommandHandler(v.command, playerVehiclePrivate)				

					for column, row in pairs(v) do
						vehicleInfoTable[v.owner][v.command][column] = row
					end
					total = total + 1				
				end
			end
		end
		outputDebugString("LOADED PRIVATE VEHICLES: ".. total)
	end
)

addEventHandler("onPlayerLogin", root,
	function(_, account)
		local name = getAccountName(account)
		if vehicleInfoTable[name] then
			for command in pairs(vehicleInfoTable[name]) do
				addCommandHandler(command, playerVehiclePrivate)
			end
		end
	end
)

function playerVehiclePrivate(player, cmd)
	local account = getPlayerAccount(player)
	local x, y, z = getElementPosition(player)
	if account then
		local name = getAccountName(account)
		if not vehicleElementTable[cmd] then
			if vehicleInfoTable[name] and vehicleInfoTable[name][cmd] then
				if tickTable[player] then
					if getTickCount() < tickTable[player] + 10000 then
						outputChatBox("* No puedes aparecer un vehiculo aún.", player, 255, 0, 0, false)
						return
					end
				end
				
				if getPedOccupiedVehicle(player) then return end
				if getElementData(player, "combattime") then return end
				
				local model = vehicleInfoTable[name][cmd]["vehicle"]
				local col = createColSphere(x, y, z, 4)
				vehicleElementTable[cmd] = createVehicle(model, x, y, z+0.5)
				warpPedIntoVehicle(player, vehicleElementTable[cmd])
				setVehicleDamageProof(vehicleElementTable[cmd], true)
				setElementData(vehicleElementTable[cmd], "reserved", tostring(name))
				--setElementData(col, "vehicle", true)
				setElementData(col, "customloot", true)
				setElementData(col, "lootname", "Reservado: "..tostring(name))
				setElementData(col, "parent", vehicleElementTable[cmd])
				setElementData(vehicleElementTable[cmd], "parent", col)
				attachElements(col, vehicleElementTable[cmd], 0, 0, 0)
				setElementData(col, "vehicleEngine", 9999)
				setElementData(col, "vehicleTires", 9999)
				setElementData(col, "vehicleBatery", 9999)
				setElementData(col, "vehicleFuel", 9999)
				setElementData(col, "vehicleFuelTank", 9999)
				setElementData(col, "vehicleRotary", 9999)
				setElementData(col, "MAX_Slots", 100)
				setVehicleEngineState(vehicleElementTable[cmd], true)
				
				for k, v in ipairs(dayzItemTable) do
					local data = vehicleInfoTable[name][cmd][ v[1] ] or 0
					setElementData(col, v[1], data)
				end
			end
		else
			for k, v in ipairs(dayzItemTable) do
				local data = getElementData(getElementData(vehicleElementTable[cmd], "parent"), v[1]) or 0
				dbExec(vehicleDatabase, "UPDATE `privateVehicles` SET '"..v[1].."'=? WHERE command=?", data, cmd)
				vehicleInfoTable[name][cmd][ v[1] ] = data
			end
			
			triggerClientEvent(player, "onClientSidemenuClear", player)
			destroyVehicleFromCommand(cmd)
			tickTable[player] = getTickCount()
		end
	end
end

function confirmPermission()
	if hasObjectPermissionTo(source, "general.privateVehicleDayZ") then
		triggerClientEvent(source, "onRequestVehicleManagerShows", source, vehicleInfoTable)
	end
end
addEvent("onClientRequestPermission", true)
addEventHandler("onClientRequestPermission", root, confirmPermission)

function addVehicleIntoDB(account, vehicle, period, command)
	if getAccount(account) then
		if allowedVehicleTable[getVehicleNameFromModel(tonumber(vehicle))] then
			if not vehicleInfoTable[account] then
				vehicleInfoTable[account] = {}
			end

			local seconds = period / 1000
			
			vehicleInfoTable[account][command] = {}
			vehicleInfoTable[account][command]["vehicle"] = vehicle
			vehicleInfoTable[account][command]["period"] = math.floor(getRealTime().timestamp + seconds)
			
			addCommandHandler(command, playerVehiclePrivate)
			
			triggerClientEvent("onClientRefreshVehicleList", resourceRoot, vehicleInfoTable)
			dbExec(vehicleDatabase, "INSERT INTO `privateVehicles` (`command`, `owner`, `vehicle`, `period`) VALUES (?,?,?,?)", command, account, vehicleInfoTable[account][command]["vehicle"], vehicleInfoTable[account][command]["period"])
			outputChatBox("* Has añadido un "..getVehicleNameFromModel(vehicle).." a la cuenta "..account.."", source, 0, 255, 0, false)
			
			for _, data in ipairs(dayzItemTable) do
				dbExec(vehicleDatabase, "UPDATE `privateVehicles` SET '"..data[1].."'=? WHERE command=?", 0, command)
			end
		else
			outputChatBox("* Este vehiculo no esta en la lista de vehiculos permitidos.", source, 255, 0, 0, false)		
		end
	else
		outputChatBox("* Esta cuenta no existe.", source, 255, 0, 0, false)
	end
end
addEvent("onClientMoveVehicleToDB", true)
addEventHandler("onClientMoveVehicleToDB", root, addVehicleIntoDB)

function removeVehicleFromDB(command, owner)
	destroyVehicleFromCommand(command)
	vehicleInfoTable[owner][command] = nil
	dbExec(vehicleDatabase, "DELETE FROM `privateVehicles` WHERE command=?", command)
	triggerClientEvent("onClientRefreshVehicleList", resourceRoot, vehicleInfoTable)
end
addEvent("onClientRemoveReservedVehicle", true)
addEventHandler("onClientRemoveReservedVehicle", root, removeVehicleFromDB)

function getTheVehicleInventory(command, owner)
	local items = {}
	
	for k, v in ipairs(dayzItemTable) do
		if isElement(vehicleElementTable[command]) then
			local data = getElementData(getElementData(vehicleElementTable[command], "parent"), v[1]) or 0
			table.insert(items, {v[1], data})
		else				
			local data = vehicleInfoTable[owner][command][ v[1] ] or 0
			table.insert(items, {v[1], data})
		end
	end

	triggerClientEvent(source, "onClientRefreshVehicleInventory", source, items)
end
addEvent("onClientRequestVehicleInventory", true)
addEventHandler("onClientRequestVehicleInventory", root, getTheVehicleInventory)

function editVehicleInfo(owner, command, newVehicle, lastVehicle, period)
	if period then
		local seconds = period / 1000
		vehicleInfoTable[owner][command]["period"] = math.floor(getRealTime().timestamp + seconds)
		dbExec(vehicleDatabase, "UPDATE `privateVehicles` SET 'period'=? WHERE command=?", command)
	end

	if newVehicle ~= lastVehicle then
		destroyVehicleFromCommand(command)
		vehicleInfoTable[owner][command]["vehicle"] = newVehicle
		dbExec(vehicleDatabase, "UPDATE `privateVehicles` SET 'vehicle'=? WHERE command=?", newVehicle, command)
	end
	
	outputDebugString("PRIVATE VEHICLE INFO FROM '"..command.."' WAS MODIFIED TO 'owner="..owner..", veh="..newVehicle..", period="..(period or "nil").."'")
	triggerClientEvent("onClientRefreshVehicleList", resourceRoot, vehicleInfoTable)
end
addEvent("onClientVehicleInfoEdit", true)
addEventHandler("onClientVehicleInfoEdit", root, editVehicleInfo)

function destroyVehicleFromCommand(command)
	if isElement(vehicleElementTable[command]) then
		destroyElement(getElementData(vehicleElementTable[command], "parent"))
		destroyElement(vehicleElementTable[command])
		vehicleElementTable[command] = nil
	end
end

setTimer(function()
	for _, vehicle in ipairs(getElementsByType("vehicle", resourceRoot)) do
		if isElement(vehicle) then
			local driver = getVehicleController(vehicle)
			if isElement(driver) then
				setVehicleEngineState(vehicle, true)
			else
				setVehicleEngineState(vehicle, false)
			end
		end
	end
end, 3000, 0)

setTimer(function()
	local qh = dbQuery(vehicleDatabase, "SELECT * FROM `privateVehicles`")
	if qh then
		local poll = dbPoll(qh, -1)
		local time = getRealTime().timestamp
		for _, v in ipairs(poll) do
			if isElement(vehicleElementTable[v.command]) then
				for _, item in ipairs(dayzItemTable) do
					local data = getElementData(vehicleElementTable[v.command], item[1]) or 0
					dbExec(vehicleDatabase, "UPDATE `privateVehicles` SET '"..item[1].."'=? WHERE command=?", data, v.command)
				end
			end

			if time >= v.period then
				outputDebugString("PRIVATE VEHICLE PERIOD FROM '"..v.command.."' HAS FINISHED.")
				removeVehicleFromDB(v.command, v.owner)
			end
			triggerClientEvent("onClientRefreshVehicleList", resourceRoot, vehicleInfoTable)
		end
	end
end, checkInterval, 0)