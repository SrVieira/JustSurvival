--[[
	#	MTA:DayZ Reserved Vehicles 2017 (C)
	#
	#	Author: Enargy
	#	Type: client-side.
	#	File: source/client/manager.lua
	#
	#	All rights reserved to his developers.
]]

local screenW, screenH = guiGetScreenSize()
local vehicleIDTable = {}
local vehicleInfoTable = {}

function managerGUIHandler()
	local status = guiGetVisible(reservedVehicles["window"])
	if not status then
		triggerServerEvent("onClientRequestPermission", localPlayer)
	end
end
addCommandHandler("pvmanager", managerGUIHandler)

function showGUIManager(vehicleTable)
	guiSetPosition(reservedVehicles["window"], screenW/2-198, screenH/2-194, false)
	guiSetVisible(reservedVehicles["window"], true)
	guiBringToFront(reservedVehicles["window"])
	guiSetInputMode("no_binds_when_editing")
	showCursor(true)
	updateVehicleList(vehicleTable)
end
addEvent("onRequestVehicleManagerShows", true)
addEventHandler("onRequestVehicleManagerShows", root, showGUIManager)

function updateVehicleList(t)
	vehicleIDTable = {}
	vehicleInfoTable = t
	guiGridListClear(reservedVehicles["veh_grid"])
	for owner, ownerData in pairs(t) do		
		for command, idData in pairs(ownerData) do
			local row = guiGridListAddRow(reservedVehicles["veh_grid"])
			guiGridListSetItemText(reservedVehicles["veh_grid"], row, 1, tostring(command), false, false)
			guiGridListSetItemText(reservedVehicles["veh_grid"], row, 2, tostring(owner), false, false)
			vehicleIDTable[command] = true
			for column, value in pairs(idData) do
				if column == "vehicle" then
					guiGridListSetItemText(reservedVehicles["veh_grid"], row, 3, tostring(value), false, false)
				elseif column == "period" then
					local seconds = value - getRealTime().timestamp
					local milliseconds = seconds * 1000
					local month, day, hour, min = convertTime(milliseconds)
					local formatText = ""
					if month > 0 then
						formatText = month.."m-"..day.."d"
					else
						if day > 0 then
							formatText = day.."d-"..hour.."h"
						else
							formatText = hour.."h-"..min.."min"
						end
					end
					guiGridListSetItemText(reservedVehicles["veh_grid"], row, 4, tostring(formatText), false, false)
				end
			end
		end
	end
end
addEvent("onClientRefreshVehicleList", true)
addEventHandler("onClientRefreshVehicleList", root, updateVehicleList)

function closeManager()
	if guiGetVisible(reservedVehicles["inv_window"]) then
		closeVehicleInventory()
	end
	if guiGetVisible(reservedVehicles["edit_window"]) then
		closeVehicleInfo()
	end
	if guiGetVisible(reservedVehicles["add_window"]) then
		closeVehicleAdd()
	end	
	guiSetVisible(reservedVehicles["window"], false)
	guiSetInputMode("allow_binds")
	guiGridListClear(reservedVehicles["veh_grid"])
	showCursor(false)
end
addEventHandler("onClientGUIClick", reservedVehicles["close_all"], closeManager, false)

function showVehicleInventory()
	if not guiGetVisible(reservedVehicles["inv_window"]) then
		local row, col = guiGridListGetSelectedItem(reservedVehicles["veh_grid"])
		if row ~= -1 and col ~= -1 then
			local command = guiGridListGetItemText(reservedVehicles["veh_grid"], row, 1)
			local owner = guiGridListGetItemText(reservedVehicles["veh_grid"], row, 2)
			guiSetPosition(reservedVehicles["inv_window"], screenW/2-117, screenH/2-209, false)
			guiSetVisible(reservedVehicles["inv_window"], true)
			guiBringToFront(reservedVehicles["inv_window"])
			guiGridListClear(reservedVehicles["inv_list"])
			guiGridListSetItemText(reservedVehicles["inv_list"], guiGridListAddRow(reservedVehicles["inv_list"]), 1, "...", true, true)
			triggerServerEvent("onClientRequestVehicleInventory", localPlayer, command, owner)
		else
			outputChatBox("* Selecciona un vehiculo.", 255, 0, 0, false)
		end
	end
end
addEventHandler("onClientGUIClick", reservedVehicles["inventory"], showVehicleInventory, false)

function closeVehicleInventory()
	guiSetVisible(reservedVehicles["inv_window"], false)
	guiGridListClear(reservedVehicles["inv_list"])
end
addEventHandler("onClientGUIClick", reservedVehicles["inv_close"], closeVehicleInventory, false)

function refreshVehicleInventoryList(items)
	if #items > 0 then
		guiGridListClear(reservedVehicles["inv_list"])
		for _, v in ipairs(items) do
			local row = guiGridListAddRow(reservedVehicles["inv_list"])
			guiGridListSetItemText(reservedVehicles["inv_list"], row, 1, v[1], true, true)
			guiGridListSetItemText(reservedVehicles["inv_list"], row, 2, tostring(v[2]), true, true)
		end
	end
end
addEvent("onClientRefreshVehicleInventory", true)
addEventHandler("onClientRefreshVehicleInventory", root, refreshVehicleInventoryList)

local lastVehicle, command
function showVehicleInfo()
	if not guiGetVisible(reservedVehicles["edit_window"]) then
		local row, col = guiGridListGetSelectedItem(reservedVehicles["veh_grid"])
		if row ~= -1 and col ~= -1 then
			local cmd = guiGridListGetItemText(reservedVehicles["veh_grid"], row, 1)
			local owner = guiGridListGetItemText(reservedVehicles["veh_grid"], row, 2)
			local vehicle = guiGridListGetItemText(reservedVehicles["veh_grid"], row, 3)
			lastVehicle, command = vehicle, cmd
			
			guiSetPosition(reservedVehicles["edit_window"], screenW/2-148, screenH/2-151, false)
			guiSetVisible(reservedVehicles["edit_window"], true)
			guiBringToFront(reservedVehicles["edit_window"])
			--[[
			local months = guiRadioButtonGetSelected(reservedVehicles["rad_months"])
			local days = guiRadioButtonGetSelected(reservedVehicles["rad_days"])
			]]

			guiSetText(reservedVehicles["textbox_owner"], owner)
			guiSetText(reservedVehicles["textbox_vehicle"], vehicle)
			--guiSetText(reservedVehicles["textbox_period"], lastPeriod)
		else
			outputChatBox("* Selecciona un vehiculo.", 255, 0, 0, false)
		end
	end
end
addEventHandler("onClientGUIClick", reservedVehicles["edit_info"], showVehicleInfo, false)

function closeVehicleInfo()
	lastVehicle, command = nil, nil
	guiSetVisible(reservedVehicles["edit_window"], false)
end
addEventHandler("onClientGUIClick", reservedVehicles["cancel_edit"], closeVehicleInfo, false)

function setVehicleInfo()
	local who = guiGetText(reservedVehicles["textbox_owner"])
	local vehid = guiGetText(reservedVehicles["textbox_vehicle"])
	local period = guiGetText(reservedVehicles["textbox_period"])
	local months = guiRadioButtonGetSelected(reservedVehicles["rad_months"])
	local days = guiRadioButtonGetSelected(reservedVehicles["rad_days"])
	
	if who ~= "" and vehid ~= "" and cmd ~= "" then
		if getVehicleNameFromModel(tonumber(vehid)) then
			local format = false
			if period ~= "" then
				if months then
					format = tonumber(period) * ((60*24)*60000)*31
				else
					format = tonumber(period) * (60*24)*60000
				end
			end
			
			triggerServerEvent("onClientVehicleInfoEdit", localPlayer, who, command, vehid, lastVehicle, format)
		else
			outputChatBox("* ID invalida.", 255, 0, 0, false)
		end
	else
		outputChatBox("* Debes llenar los campos requeridos.", 255, 0, 0, false)
	end
	
	closeVehicleInfo()
end
addEventHandler("onClientGUIClick", reservedVehicles["accept_edit"], setVehicleInfo, false)

function showVehicleAdd()
	if not guiGetVisible(reservedVehicles["add_window"]) then
		guiSetPosition(reservedVehicles["add_window"], screenW/2-139, screenH/2-110, false)
		guiSetVisible(reservedVehicles["add_window"], true)
		guiBringToFront(reservedVehicles["add_window"])
	end
end
addEventHandler("onClientGUIClick", reservedVehicles["add_veh"], showVehicleAdd, false)

function closeVehicleAdd()
	guiSetVisible(reservedVehicles["add_window"], false)
end
addEventHandler("onClientGUIClick", reservedVehicles["editbox_vehiclecancel"], closeVehicleAdd, false)

function addVehicle()
	local who = guiGetText(reservedVehicles["editbox_account"])
	local vehid = guiGetText(reservedVehicles["editbox_vehicleid"])
	local period = guiGetText(reservedVehicles["edit_vehicleperiod"])
	local cmd = guiGetText(reservedVehicles["editbox_command"])
	local months = guiRadioButtonGetSelected(reservedVehicles["rad_vehmonths"])
	local days = guiRadioButtonGetSelected(reservedVehicles["rad_vehdays"])
	if who ~= "" and vehid ~= "" and period ~= "" and cmd ~= "" then
		if getVehicleNameFromModel(tonumber(vehid)) then
			if not vehicleIDTable[cmd] then
				local format = false
				if months then
					format = tonumber(period) * ((60*24)*60000)*31
				else
					format = tonumber(period) * (60*24)*60000
					--format = tonumber(period) * 60000
				end
				closeVehicleAdd()
				triggerServerEvent("onClientMoveVehicleToDB", localPlayer, who, vehid, format, cmd)
			else
				outputChatBox("* Elige un comando que no esta en uso.", 255, 0, 0, false)
			end
		else
			outputChatBox("* ID invalida.", 255, 0, 0, false)
		end
	else
		outputChatBox("* Debes llenar los campos vacios.", 255, 0, 0, false)
	end
end
addEventHandler("onClientGUIClick", reservedVehicles["editbox_acceptveh"], addVehicle, false)

function removeVehicle()
	local row, col = guiGridListGetSelectedItem(reservedVehicles["veh_grid"])
	if row ~= -1 and col ~= -1 then
		local command = guiGridListGetItemText(reservedVehicles["veh_grid"], row, 1)
		local owner = guiGridListGetItemText(reservedVehicles["veh_grid"], row, 2)
		local vehicle = guiGridListGetItemText(reservedVehicles["veh_grid"], row, 3)
		local period = guiGridListGetItemText(reservedVehicles["veh_grid"], row, 4)
		triggerServerEvent("onClientRemoveReservedVehicle", localPlayer, command, owner, vehicle)
	else
		outputChatBox("* Selecciona un vehiculo para quitar.", 255, 0, 0, false)
	end
end
addEventHandler("onClientGUIClick", reservedVehicles["remove_veh"], removeVehicle, false)

function onlyNumbers()
	if source == reservedVehicles["edit_vehicleperiod"] or source == reservedVehicles["textbox_period"] or source == reservedVehicles["textbox_vehicle"] or source == reservedVehicles["edit_vehicleperiod"] then
		local text = guiGetText(source):gsub("%e", "")
		guiSetText(source, text)
	end
end
addEventHandler("onClientGUIChanged", resourceRoot, onlyNumbers)

--# SHARED FUNCTIONS #--

function convertTime (ms) 
	local ms = tonumber(ms)
    local month = math.floor ( ms / 2592000000 )
    local day = math.floor ( ms / 86400000 )
    local hour = math.floor ( ms / 3600000 )
    local min = math.floor ( ms / 60000 )
    local sec = math.floor ( ( ms / 1000 ) % 60 ) 
    return month, day, hour, min, sec 
end