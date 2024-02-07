isVehicleDBEmpty = true
vehicleTable = {}
tentTable = {}

function loadDayZBackups()
	databaseVehicles = dbConnect("sqlite", "DATABASE/SQL/vehicles.db")
	databaseTents = dbConnect("sqlite", "DATABASE/SQL/tents.db")
	
	dbExec(databaseVehicles, "CREATE TABLE IF NOT EXISTS `vehicles` (name TEXT, pos_x INTEGER, pos_y INTEGER, pos_z INTEGER, rot_x INTEGER, rot_y INTEGER,rot_z INTEGER, native_pos TEXT)")
	dbExec(databaseVehicles, "CREATE TABLE IF NOT EXISTS `components` (id INTEGER, engine INTEGER, tires INTEGER,batery INTEGER,fuel INTEGER,fueltank INTEGER,rotary INTEGER, scrapsmetal INTEGER, items TEXT)")
	dbExec(databaseTents, "CREATE TABLE IF NOT EXISTS `tents` (name TEXT,x INTEGER,y INTEGER,z INTEGER,rot INTEGER,items TEXT,owner TEXT,slots INTEGER)")
	
	dbQuery(loadTentsFromDB, {}, databaseTents, "SELECT * FROM `tents`")
	dbQuery(loadVehiclesFromDB, {}, databaseVehicles, "SELECT * FROM `vehicles`")
	
	setTimer(loadVehicles, 30000, 1)
end
addEventHandler("onResourceStart", resourceRoot, loadDayZBackups)

setTimer(
	function()
		Async:foreach(getElementsByType("player"), function(v)
			savePlayerProgress(v)
		end, savePlayerProgressFinished)

		saveTents(true)
		saveVehicles(true)
				
		outputDebugString("AUTO-SAVE Procceding.")
		outputChatBox("** GUARDANDO LOS PROCESOS ACTUALES **.", root, 0, 255, 0)
	end, 3600000*10, 0
)

function getDBVehicleConnection() return databaseVehicles end
function getDBTentConnection() return databaseTents end

function loadTentsFromDB(qh)
	if qh then
		local result = dbPoll(qh, -1)
		for _, val in ipairs(result) do 
			createTentsFromDB(val["name"], val["x"], val["y"], val["z"], val["rot"], val["owner"], val["items"], val["slots"])
		end
	end
	outputDebugString("LOADED TENTS: "..#tentTable)
end

function savePlayerProgressFinished()
	outputDebugString("[BACKUP] Server player's progress has been saved.")
end

function createTentsFromDB(name, x, y, z, rot, owner, items, slots)
	local items = fromJSON(items) or {}
	--if #items == 0 then return end -- only if you wanna remove empty tents
	
	local tentID
	local scale
	local slots
	
	for _, v in ipairs(gameplayVariables["tents"]) do
		if name == v[1] then
			tentID = v[2]
			scale = v[3]
			slots = v[4]
			break
		end
	end
		
	if tentID then
		local tent = createObject(tentID, x, y, z, 0, 0, rot)
		local col = createColSphere(x, y, z, 3.5)

		setElementData(tent, "parent", col)
		setElementData(col, "parent", tent)
		setElementData(col, "tent", name)
		setElementData(col, "MAX_Slots", slots)
		setElementData(col, "owner", owner)
		attachElements(col, tent, 0, 0, 0)
		setElementDoubleSided(tent, true)
		setObjectScale(tent, scale)
		
		for index, value in ipairs(items) do
			setElementData(col, value[1], value[2])
		end

		moveTentIntoDB(col)
	end
end

function moveTentIntoDB(tent)
	table.insert(tentTable, tent)
end
addEvent("moveTentIntoDB", true)
addEventHandler("moveTentIntoDB", root, moveTentIntoDB)

function removeTentFromDB(tent)
	for i, v in ipairs(tentTable) do
		if v == tent then
			table.remove(tentTable, i)
			break
		end
	end
end
addEvent("removeTentFromDB", true)
addEventHandler("removeTentFromDB", root, removeTentFromDB)

function loadVehiclesFromDB(qh)
	if qh then
		local result = dbPoll(qh, -1)
		if #result > 0 then
			local components = dbPoll(dbQuery(databaseVehicles, "SELECT * FROM `components`"), -1)
			
			if #components > 0 then
				for index, value in ipairs(result) do
					local engine = components[index]["engine"]
					local tires = components[index]["tires"]
					local batery = components[index]["batery"]
					local fuel = components[index]["fuel"]
					local fueltank = components[index]["fueltank"]
					local rotary = components[index]["rotary"]
					local scrapsmetal = components[index]["scrapsmetal"]
					local items = components[index]["items"]
					
					local name = value["name"]
					local x = value["pos_x"]
					local y = value["pos_y"]
					local z = value["pos_z"]
					local rx = value["rot_x"]
					local rz = value["rot_y"]
					local rz = value["rot_z"]					
					local nativepos = value["native_pos"]	

					createVehiclesFromDB(name, x, y, z, rx, ry, rz, engine, tires, batery, fuel, fueltank, rotary, scrapsmetal, items, nativepos)					
				end
			end
			
			isVehicleDBEmpty = false
			outputDebugString("[DayZ] Los vehiculos fueron cargados desde la base de datos!")
		end
	end
end

function createVehiclesFromDB(name, x, y, z, rx, ry, rz, engine, tires, batery, fuel, fueltank, rotary, scrapsmetal, items, nativepos)
	local id = getVehicleModelFromName(name)
	local colsize = getVehicleColshapeSize(id)
	local maxslots = getVehicleMaxSlots(id)
	local vehicle = createVehicle(id, x, y, z, rx, ry, rz)
	local col = createColSphere(x, y, z, colsize)
	local vname = getVehicleNewName(id)
	setElementData(col, "parent", vehicle)
	setElementData(vehicle, "parent", col)
	attachElements(col, vehicle, 0, 0, 0)
	
	setElementData(col, "vehicle", true)
	setElementData(col, "native_pos", nativepos)
	setElementData(col, "vehicleEngine", engine)
	setElementData(col, "vehicleTires", tires)
	setElementData(col, "vehicleBatery", batery)
	setElementData(col, "vehicleFuel", fuel)
	setElementData(col, "vehicleFuelTank", fueltank)
	setElementData(col, "vehicleRotary", rotary)
	setElementData(col, "vehicleScrapsMetal", scrapsmetal)
	setElementData(col, "MAX_Slots", maxslots)
	setElementData(col, "lootname", vname)

	if items then
		for _, v in ipairs(fromJSON(items)) do
			setElementData(col, v[1], v[2])
		end
	end
	
	table.insert(vehicleTable, col)
end

function saveVehicles(async)
	if not databaseVehicles then return end
	if #vehicleTable == 0 then return end
	dbExec(databaseVehicles, "DROP TABLE `vehicles`")
	dbExec(databaseVehicles, "DROP TABLE `components`")
	dbExec(databaseVehicles, "CREATE TABLE IF NOT EXISTS `vehicles` (name TEXT, pos_x INTEGER, pos_y INTEGER, pos_z INTEGER, rot_x INTEGER, rot_y INTEGER,rot_z INTEGER, native_pos TEXT)")
	dbExec(databaseVehicles, "CREATE TABLE IF NOT EXISTS `components` (engine INTEGER, tires INTEGER,batery INTEGER,fuel INTEGER,fueltank INTEGER,rotary INTEGER, scrapsmetal INTEGER, items TEXT)")
	
	if not async then
		for index, val in ipairs(vehicleTable) do
			if isElement(val) then
				local vehicle = getElementData(val, "parent")
				if isElement(vehicle) then
					local x, y, z = getElementPosition(vehicle)
					local rx, ry, rz = getElementRotation(vehicle)
					local name = getVehicleName(vehicle)
					
					local nativepos = getElementData(val, "native_pos")
					local engine = getElementData(val, "vehicleEngine") or 0
					local tires = getElementData(val, "vehicleTires") or 0
					local batery = getElementData(val, "vehicleBatery") or 0
					local fuel = getElementData(val, "vehicleFuel") or 0
					local fueltank = getElementData(val, "vehicleFuelTank") or 0
					local rotary = getElementData(val, "vehicleRotary") or 0
					local scrapsmetal = getElementData(val, "vehicleScrapsMetal") or 0
					
					local items = {}
					for _, v in ipairs(gameplayVariables["world_items"]) do
						local data = getElementData(val, v[1])
						if data and data > 0 then
							table.insert(items, {v[1], data})
						end
					end
									
					items = toJSON(items)

					dbExec(databaseVehicles, "INSERT INTO `vehicles` (name, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, native_pos) VALUES(?,?,?,?,?,?,?,?)", name, x, y, z, rx, ry, rz, nativepos)
					dbExec(databaseVehicles, "INSERT INTO `components` (engine, tires, batery, fuel, fueltank, rotary, scrapsmetal, items) VALUES(?,?,?,?,?,?,?,?)", engine, tires, batery, fuel, fueltank, rotary, scrapsmetal, items)
				end
			end
		end
		saveVehicleFinished()
	else
		Async:foreach(vehicleTable, function(val)
			if isElement(val) then
				local vehicle = getElementData(val, "parent")
				if isElement(vehicle) then
					local x, y, z = getElementPosition(vehicle)
					local rx, ry, rz = getElementRotation(vehicle)
					local name = getVehicleName(vehicle)
					
					local nativepos = getElementData(val, "native_pos")
					local engine = getElementData(val, "vehicleEngine") or 0
					local tires = getElementData(val, "vehicleTires") or 0
					local batery = getElementData(val, "vehicleBatery") or 0
					local fuel = getElementData(val, "vehicleFuel") or 0
					local fueltank = getElementData(val, "vehicleFuelTank") or 0
					local rotary = getElementData(val, "vehicleRotary") or 0
					local scrapsmetal = getElementData(val, "vehicleScrapsMetal") or 0
					
					local items = {}
					for _, v in ipairs(gameplayVariables["world_items"]) do
						local data = getElementData(val, v[1])
						if data and data > 0 then
							table.insert(items, {v[1], data})
						end
					end
									
					items = toJSON(items)

					dbExec(databaseVehicles, "INSERT INTO `vehicles` (name, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, native_pos) VALUES(?,?,?,?,?,?,?,?)", name, x, y, z, rx, ry, rz, nativepos)
					dbExec(databaseVehicles, "INSERT INTO `components` (engine, tires, batery, fuel, fueltank, rotary, scrapsmetal, items) VALUES(?,?,?,?,?,?,?,?)", engine, tires, batery, fuel, fueltank, rotary, scrapsmetal, items)
				end
			end
		end, saveVehicleFinished)
	end
end

function saveVehicleFinished()
	outputDebugString("[BACKUP] Server vehicles has been saved. TOTAL VEHICLES: "..#vehicleTable)
end

function saveTents(async)
	if not databaseTents then return end
	dbExec(databaseTents, "DROP TABLE `tents`")
	dbExec(databaseTents, "CREATE TABLE IF NOT EXISTS `tents` (name TEXT,x INTEGER,y INTEGER,z INTEGER,rot INTEGER,items TEXT,owner TEXT,slots INTEGER)")

	if not async then
		for index, tent in ipairs(tentTable) do
			if isElement(tent) then
			local object = getElementData(tent, "parent")
			
				if isElement(object) then
					local items = {}
					local x, y, z = getElementPosition(object)
					local _, _, rz = getElementRotation(object)
					local owner = getElementData(tent, "owner")
					local slots = getElementData(tent, "MAX_Slots")
					local name = getElementData(tent, "tent")
					
					for _, v in ipairs(gameplayVariables["world_items"]) do
						local data = getElementData(tent, v[1])
						if data and data > 0 then
							table.insert(items, {v[1], data})
						end
					end

					items = toJSON(items)
					dbExec(databaseTents, "INSERT INTO `tents` (name, x, y, z, rot, items, owner, slots) VALUES(?,?,?,?,?,?,?,?)", name, x, y, z, rz, items, owner, slots)
				end
			end
		end
		saveTentFinished()
	else
		Async:foreach(tentTable, function(tent)
			if isElement(tent) then
				local object = getElementData(tent, "parent")
			
				if isElement(object) then
					local items = {}
					local x, y, z = getElementPosition(object)
					local _, _, rz = getElementRotation(object)
					local owner = getElementData(tent, "owner")
					local slots = getElementData(tent, "MAX_Slots")
					local name = getElementData(tent, "tent")
					
					for _, v in ipairs(gameplayVariables["world_items"]) do
						local data = getElementData(tent, v[1])
						if data and data > 0 then
							table.insert(items, {v[1], data})
						end
					end

					items = toJSON(items)
					dbExec(databaseTents, "INSERT INTO `tents` (name, x, y, z, rot, items, owner, slots) VALUES(?,?,?,?,?,?,?,?)", name, x, y, z, rz, items, owner, slots)
				end
			end
		end, saveTentFinished)
	end
end

function saveTentFinished()
	outputDebugString("[BACKUP] Server tents has been saved. TOTAL TENTS: "..#tentTable)
end

function loadVehicles()
	if isVehicleDBEmpty == false then return end
	
	for i, data in ipairs(gameplayVariables["launcspawn"]) do
		local id = 595
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))
			
		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)
			
		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))
		
		table.insert(vehicleTable, col)

	end			
	for i, data in ipairs(gameplayVariables["sunrisespawn"]) do
		local id = 550
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))
			
		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)
			
		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))
			
		table.insert(vehicleTable, col)

	end			
	for i, data in ipairs(gameplayVariables["blistacompatspawn"]) do
		local id = 496
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))
			
		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)
			
		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))
			
		table.insert(vehicleTable, col)

	end		
	for i, data in ipairs(gameplayVariables["barrackspawn"]) do
		local id = 433
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))
			
		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)
			
		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))
			
		table.insert(vehicleTable, col)

	end	
	for i, data in ipairs(gameplayVariables["dunespawn"]) do
		local id = 573
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))
			
		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)
			
		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))
			
		table.insert(vehicleTable, col)

	end	
	for i, data in ipairs(gameplayVariables["policecarspawn"]) do
		local id = 596
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))
			
		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)
			
		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))
			
		table.insert(vehicleTable, col)

	end	
	for i, data in ipairs(gameplayVariables["infernusspawn"]) do
		local id = 411
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))
			
		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)
			
		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))
			
		table.insert(vehicleTable, col)

	end
	for i, data in ipairs(gameplayVariables["banditospawn"]) do
		local id = 568
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))
			
		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)
			
		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))
			
		table.insert(vehicleTable, col)

	end		
	for i, data in ipairs(gameplayVariables["bfinjectionspawn"]) do
		local id = 424
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))
			
		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)
			
		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))
			
		table.insert(vehicleTable, col)

	end		
	for i, data in ipairs(gameplayVariables["fcr900spawn"]) do
		local id = 521
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))
			
		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)
			
		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))
			
		table.insert(vehicleTable, col)

	end	
	for i, data in ipairs(gameplayVariables["patriotspawn"]) do
		local id = 470
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))
			
		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)
			
		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))
			
		table.insert(vehicleTable, col)

	end
	for i, data in ipairs(gameplayVariables["voodoospawn"]) do
		local id = 412
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))
			
		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)
			
		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))
		
		table.insert(vehicleTable, col)

	end			
	for i, data in ipairs(gameplayVariables["buffalospawn"]) do
		local id = 402
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))
			
		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)
			
		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))
		
		table.insert(vehicleTable, col)

	end		
	for i, data in ipairs(gameplayVariables["reeferspawn"]) do
		local id = 453
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))
			
		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)
			
		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))

		table.insert(vehicleTable, col)
	end			
	for i, data in ipairs(gameplayVariables["landstalkerspawns"]) do
		local id = 400
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))

		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)

		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))

		table.insert(vehicleTable, col)
	end			
	for i, data in ipairs(gameplayVariables["bikespawns"]) do
		local id = 510
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))

		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)

		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))
		
		table.insert(vehicleTable, col)
	end		
	for i, data in ipairs(gameplayVariables["busspawns"]) do
		local id = 431
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))

		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)
		
		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))

		table.insert(vehicleTable, col)
	end	
	for i, data in ipairs(gameplayVariables["bobcatspawn"]) do
		local id = 422
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))

		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)

		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))

		table.insert(vehicleTable, col)
	end
	for i, data in ipairs(gameplayVariables["maverickspawn"]) do
		local id = 487
		local vehicle = createVehicle(id, data[1], data[2], data[3], data[4], data[5], data[6])
		local col = createColSphere(data[1], data[2], data[3], getVehicleColshapeSize(id))

		setElementData(col, "vehicle", true)
		setElementData(vehicle, "parent", col)
		setElementData(col, "parent", vehicle)
		attachElements(col, vehicle, 0, 0, 0)

		setElementData(col, "native_pos", tostring(data[1]..","..data[2]..","..data[3]..","..data[4]..","..data[5]..","..data[6]))
		setElementData(col, "vehicleEngine", math.random(0, 1))
		setElementData(col, "vehicleTires", math.random(0, getVehicleMaxTires(id)))
		setElementData(col, "vehicleBatery", 0)
		setElementData(col, "vehicleFuel", math.random(0, getVehicleMaxFuel(id)))
		setElementData(col, "vehicleFuelTank", 0)
		setElementData(col, "vehicleRotary", 0)
		setElementData(col, "vehicleScrapsMetal", 0)
		setElementData(col, "MAX_Slots", getVehicleMaxSlots(id))
		setElementData(col, "lootname", getVehicleNewName(id))

		table.insert(vehicleTable, col)
	end

	outputDebugString("[DayZ] Los vehiculos fueron cargados!")
end

function saveDayZProgress()
	saveVehicles()
	saveTents()
end
addEventHandler("onResourceStop", resourceRoot, saveDayZProgress)

function manualBackup(player)
	if hasObjectPermissionTo(player, "general.ModifyOtherObjects") then
		outputDebugString("[BACKUP] "..getPlayerName(player).." has started manual server save.")
		
		Async:foreach(getElementsByType("player"), function(v)
			savePlayerProgress(v)
		end, savePlayerProgressFinished)
		
		saveTents()
		saveVehicles()
	end
end
addCommandHandler("backup", manualBackup)