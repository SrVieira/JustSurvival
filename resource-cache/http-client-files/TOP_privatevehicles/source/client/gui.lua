--[[
	#	MTA:DayZ Reserved Vehicles 2017 (C)
	#
	#	Author: Enargy
	#	Type: client-side.
	#	File: source/client/gui.lua
	#
	#	All rights reserved to his developers.
]]

reservedVehicles = {}
reservedVehicles["window"] = guiCreateWindow(309, 170, 396, 388, "DayZ - Vehiculos reservados", false)
guiWindowSetSizable(reservedVehicles["window"], false)
guiSetVisible(reservedVehicles["window"], false)

reservedVehicles["veh_grid"] = guiCreateGridList(10, 26, 375, 319, false, reservedVehicles["window"])
guiGridListAddColumn(reservedVehicles["veh_grid"], "comando", 0.2)
guiGridListAddColumn(reservedVehicles["veh_grid"], "dueño", 0.2)
guiGridListAddColumn(reservedVehicles["veh_grid"], "vehiculo", 0.2)
guiGridListAddColumn(reservedVehicles["veh_grid"], "periodo", 0.3)
--guiGridListAddColumn(reservedVehicles["veh_grid"], "n. items", 0.2)
reservedVehicles["add_veh"] = guiCreateButton(10, 351, 67, 28, "Agregar", false, reservedVehicles["window"])
guiSetProperty(reservedVehicles["add_veh"], "NormalTextColour", "FFAAAAAA")
reservedVehicles["remove_veh"] = guiCreateButton(81, 351, 67, 28, "Quitar", false, reservedVehicles["window"])
guiSetProperty(reservedVehicles["remove_veh"], "NormalTextColour", "FFAAAAAA")
reservedVehicles["edit_info"] = guiCreateButton(152, 351, 67, 28, "Editar", false, reservedVehicles["window"])
guiSetProperty(reservedVehicles["edit_info"], "NormalTextColour", "FFAAAAAA")
reservedVehicles["inventory"] = guiCreateButton(225, 351, 67, 28, "Inventario", false, reservedVehicles["window"])
guiSetProperty(reservedVehicles["inventory"], "NormalTextColour", "FFAAAAAA")
reservedVehicles["close_all"] = guiCreateButton(318, 351, 67, 28, "Cerrar", false, reservedVehicles["window"])
guiSetProperty(reservedVehicles["close_all"], "NormalTextColour", "FFAAAAAA")
--#
--#
reservedVehicles["edit_window"] = guiCreateWindow(362, 220, 296, 302, "Editar informacion del vehiculo", false)
guiWindowSetSizable(reservedVehicles["edit_window"], false)
guiSetVisible(reservedVehicles["edit_window"], false)

reservedVehicles["label_owner"] = guiCreateLabel(10, 43, 67, 15, "Dueño:", false, reservedVehicles["edit_window"])
reservedVehicles["label_period"] = guiCreateLabel(10, 77, 67, 15, "Periodo:", false, reservedVehicles["edit_window"])
reservedVehicles["label_vehicle"] = guiCreateLabel(10, 113, 67, 15, "Vehiculo:", false, reservedVehicles["edit_window"])
reservedVehicles["textbox_owner"] = guiCreateEdit(77, 37, 201, 26, "", false, reservedVehicles["edit_window"])
guiEditSetReadOnly(reservedVehicles["textbox_owner"], true)  
reservedVehicles["textbox_period"] = guiCreateEdit(77, 72, 97, 26, "", false, reservedVehicles["edit_window"])
reservedVehicles["textbox_vehicle"] = guiCreateEdit(77, 108, 201, 26, "", false, reservedVehicles["edit_window"])
reservedVehicles["rad_months"] = guiCreateRadioButton(179, 73, 37, 25, "m.", false, reservedVehicles["edit_window"])
reservedVehicles["rad_days"] = guiCreateRadioButton(226, 73, 37, 25, "d.", false, reservedVehicles["edit_window"])
guiRadioButtonSetSelected(reservedVehicles["rad_days"], true)
reservedVehicles["cancel_edit"] = guiCreateButton(67, 263, 77, 28, "Cancelar", false, reservedVehicles["edit_window"])
guiSetProperty(reservedVehicles["cancel_edit"], "NormalTextColour", "FFAAAAAA")
reservedVehicles["accept_edit"] = guiCreateButton(152, 263, 77, 28, "Aceptar", false, reservedVehicles["edit_window"])
guiSetProperty(reservedVehicles["accept_edit"], "NormalTextColour", "FFAAAAAA")
--#
--#
reservedVehicles["inv_window"] = guiCreateWindow(378, 188, 234, 418, "Inventario del vehiculo", false)
guiWindowSetSizable(reservedVehicles["inv_window"], false)
guiSetVisible(reservedVehicles["inv_window"], false)

reservedVehicles["inv_list"] = guiCreateGridList(10, 28, 214, 352, false, reservedVehicles["inv_window"])
guiGridListAddColumn(reservedVehicles["inv_list"], "item", 0.65)
guiGridListAddColumn(reservedVehicles["inv_list"], "monto", 0.2)
reservedVehicles["inv_close"] = guiCreateButton(51, 386, 128, 22, "Ok", false, reservedVehicles["inv_window"])
guiSetProperty(reservedVehicles["inv_close"], "NormalTextColour", "FFAAAAAA")
--#
--#
reservedVehicles["add_window"] = guiCreateWindow(371, 254, 278, 220, "Agregar un vehiculo", false)
guiWindowSetSizable(reservedVehicles["add_window"], false)
guiSetVisible(reservedVehicles["add_window"], false)

reservedVehicles["label_acc"] = guiCreateLabel(10, 31, 77, 15, "Cuenta:", false, reservedVehicles["add_window"])
reservedVehicles["editbox_account"] = guiCreateEdit(87, 26, 179, 25, "", false, reservedVehicles["add_window"])
reservedVehicles["editbox_vehicleid"] = guiCreateEdit(87, 61, 179, 25, "", false, reservedVehicles["add_window"])
reservedVehicles["edit_vehicleperiod"] = guiCreateEdit(87, 96, 94, 25, "", false, reservedVehicles["add_window"])
reservedVehicles["label_vid"] = guiCreateLabel(10, 66, 77, 15, "Vehiculo (ID):", false, reservedVehicles["add_window"])
reservedVehicles["rad_vehmonths"] = guiCreateRadioButton(191, 96, 39, 25, "m.", false, reservedVehicles["add_window"])
reservedVehicles["rad_vehdays"] = guiCreateRadioButton(230, 96, 39, 25, "d.", false, reservedVehicles["add_window"])
guiRadioButtonSetSelected(reservedVehicles["rad_vehdays"], true)
reservedVehicles["label_vperiod"] = guiCreateLabel(10, 100, 77, 15, "Periodo:", false, reservedVehicles["add_window"])
reservedVehicles["editbox_vehiclecancel"] = guiCreateButton(62, 179, 77, 32, "Cancelar", false, reservedVehicles["add_window"])
guiSetProperty(reservedVehicles["editbox_vehiclecancel"], "NormalTextColour", "FFAAAAAA")
reservedVehicles["editbox_acceptveh"] = guiCreateButton(143, 179, 77, 32, "Aceptar", false, reservedVehicles["add_window"])
guiSetProperty(reservedVehicles["editbox_acceptveh"], "NormalTextColour", "FFAAAAAA")
reservedVehicles["editbox_command"] = guiCreateEdit(87, 131, 94, 25, "", false, reservedVehicles["add_window"])
reservedVehicles["label_command"] = guiCreateLabel(10, 135, 77, 15, "Comando:", false, reservedVehicles["add_window"])
