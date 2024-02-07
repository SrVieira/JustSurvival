---------------------------------------------------------------------
--  Desarrollador/Developer: -Rex-
--  Proyecto/Proyect:        N/A
--  Contacto/Contact:        https://www.facebook.com/rexscripting/
--
--  Libre uso y modificacion, No borrar los creditos, Gracias
---------------------------------------------------------------------
local regis_db = dbConnect( "sqlite", "dbData.db" )
local acl_permitido = "Admin" --Tipo de right permitido.
local deleteonrestart = false --Si deseas que se borre el registro, cambia false por true, Si no dejalo Por defecto: false.
local comandoChatGrupal = "y"
local comandoGui = "lzgroupsystem"
cosa = {}
cacheRegistry = {}
actionS = {}

addEvent("getGPCLabels", true)
addEvent("getGPCListG", true)
addEvent("getGPCChatListG", true)
addEvent("deleteAGP", true)
addEvent("editSlotsAGP", true)
addEvent("getGPCActiList", true)
addEvent("clearChatRegS", true)
addEvent("clearActiRegS", true)
addEvent("getGPCGROUPInfo", true)
addEvent("saveINFOGPC", true)
addEvent("getMembersGPCList", true)
addEvent("findMemberGPC", true)
addEvent("getAccountGPCText", true)
addEvent("deleteAmmGpc", true)
addEvent("getPlayerGPCListAdd", true)
addEvent("addAmemberGPCListlel", true)
addEvent("findAAggedMemberGPC", true)
addEvent("editArangGPC", true)
addEvent("editGPNAMEGPC", true)
addEvent("getRanksOfGroup2", true)

function onStartSSees(  )
	local qhe = regis_db:query( "CREATE TABLE IF NOT EXISTS group_messages ( id INT, hour TEXT, grupo TEXT, nickname TEXT, message STRING)")
	local qh2e = regis_db:query( "CREATE TABLE IF NOT EXISTS group_actions ( id INT, hour TEXT, by TEXT, action TEXT)")
	dbFree( qhe ) 
	dbFree( qh2e )
	outputDebugString( "[SISTEMA-GRUPAL] Se creo satisfactoriamente la tabla de registros" )
	local e = regis_db:query("SELECT * FROM group_messages ORDER BY id DESC")
	for _, columna in ipairs( dbPoll( e, -1) ) do
		local id = columna["id"]
		local hour = columna["hour"]
		local grupo = columna["grupo"]
		local nick = columna["nickname"]
		local message = columna["message"]
		table.insert(cacheRegistry, { id, hour, grupo, nick, message } )
	end
	local d = regis_db:query("SELECT * FROM group_actions ORDER BY id DESC")
	for _, columna in ipairs( dbPoll( d, -1 ) ) do
		local id = columna["id"]
		local hour = columna["hour"]
		local by = columna["by"]
		local description = columna["action"]
		table.insert( actionS, { id, hour, by, description } )
	end
	local ee = regis_db:query( "DROP TABLE group_messages" )
	local ec = regis_db:query( "DROP TABLE group_actions" )
	dbFree( ee ) dbFree( ec )
	local qhe = regis_db:query( "CREATE TABLE IF NOT EXISTS group_messages ( id INT, hour TEXT, grupo TEXT, nickname TEXT, message STRING)")
	local qh2e = regis_db:query( "CREATE TABLE IF NOT EXISTS group_actions ( id INT, hour TEXT, by TEXT, action TEXT)")
	dbFree( qhe ) 
	dbFree( qh2e )
end
addEventHandler("onResourceStart", getResourceRootElement( getThisResource()), onStartSSees)

function onStopPp(  )
	for _, valor in ipairs( cacheRegistry ) do
		local id,time,gp,nick,ms = valor[1], valor[2], valor[3], valor[4], valor[5];
		regis_db:exec("INSERT INTO group_messages ( id, hour, grupo, nickname, message ) VALUES ( ?, ?, ?, ?, ? )", id, time, gp, nick, ms )
	end
	for _, valor in ipairs( cacheRegistry ) do
		local id,time,by,ac = valor[1], valor[2], valor[3], valor[4];
		regis_db:exec("INSERT INTO group_actions ( id, hour, by, action) VALUES ( ?, ?, ?, ? )", id, time, by, ac )
	end
	if deleteonrestart then
		local qh = regis_db:query( "DROP TABLE group_messages" )
		local qh2 = regis_db:query( "DROP TABLE group_actions" )
		dbFree( qh ) dbFree( qh2 )
		outputDebugString( "[SISTEMA-GRUPAL] Se removio satisfactoriamente la tabla de registros" )
	end
end
addEventHandler("onResourceStop", getResourceRootElement( getThisResource()), onStopPp)

function openGPCPanel( source )
	local account = source:getAccount():getName();
	if isObjectInACLGroup ("user."..account, aclGetGroup ( "Admin" ) ) then
		triggerClientEvent( source, "openGPCGUI", source)
	end
end
addCommandHandler( comandoGui, openGPCPanel )

function clearChatRegistry(  )
	local accountName = source:getAccount():getName();
	if isObjectInACLGroup ("user."..accountName, aclGetGroup ( acl_permitido ) ) then
		cacheRegistry = false
		if not cacheRegistry then
			cacheRegistry = {}
		end
		addActionReg( source, "Limpio el registro de mensajes")
		source:outputChat("Has limpiado el registro de mensajes",0,200,0,true)
	else
		source:outputChat("No tienes el permiso para hacer esta accion!",200,0,0,true)
	end
end
addEventHandler("clearChatRegS", root, clearChatRegistry )

function clearActionRegistry(  )
	local accountName = source:getAccount():getName();
	if isObjectInACLGroup ("user."..accountName, aclGetGroup ( acl_permitido ) ) then
		actionS = false
		if not actionS then
			actionS = {}
		end
		source:outputChat("Has limpiado el registro de acciones",0,200,0,true)
		addActionReg( source, "Limpio el registro de acciones")
	else
		source:outputChat("No tienes el permiso para hacer esta accion!",200,0,0,true)
	end
end
addEventHandler("clearActiRegS", root, clearActionRegistry )


function ranksofgroup2(  )
	local grupo = getPlayerGroup(source)
	local Ca = { }

	local ranks = getGroupRanks( grupo )

	for i,v in ipairs(ranks) do
		table.insert( Ca, v[1] )
	end
	triggerClientEvent(source,"aggRanks2", source, Ca)
end
addEventHandler("getRanksOfGroup2", root, ranksofgroup2 )

function addActionReg( source, description )
	if not cacheRegistry then
		cacheRegistry = {}
	end
	local account = source:getAccount();
	local accountName = account:getName();
	local time = getRealTime(  );
	local hour = "["..time.hour..":"..time.minute..":"..time.second.."]"
	local by = accountName.." ( "..string.gsub( source:getName(), "#%x%x%x%x%x%x", "").." )"
	table.insert( actionS, { #actionS+1, hour, by, description } )
	--regis_db:exec("INSERT INTO group_actions ( id, hour, by, action) VALUES ( ?, ?, ?, ? )", id, hour, by, description)
end

function addActionConsoleReg( description )
	if not actionS then
		actionS = {}
	end
	local time = getRealTime(  );
	local hour = "["..time.hour..":"..time.minute..":"..time.second.."]"
	table.insert( actionS, { #actionS+1, hour, "Consola", description } )
	--regis_db:exec("INSERT INTO group_actions ( id, hour, by, action) VALUES ( ?, ?, ?, ? )", id, hour, "Console", description)
end

function delAGP( grupo )
	if isGroupExists( grupo ) then
		local account = source:getAccount();
		local accountName = account:getName();
		deleteGroup( grupo )
		local time = getRealTime(  );
		local hour = "["..time.hour..":"..time.minute..":"..time.second.."]"
		local by = accountName.." ( "..string.gsub( source:getName(), "#%x%x%x%x%x%x", "").." )"
		table.insert( actionS, { #actionS+1, hour, by, "Delete the group: "..grupo} )
		--regis_db:exec("INSERT INTO group_actions ( id, hour, by, action) VALUES ( ?, ?, ?, ? )", id, hour, by, "Delete the group: "..grupo)
		source:outputChat("Has borrado el grupo: "..grupo, 0,200,0)
		triggerClientEvent( source, "clearGPCListG", source )
	else
		source:outputChat("El grupo no existe",200,0,0,true)
	end
end
addEventHandler("deleteAGP", root, delAGP )

function editSlotsAGPP( group, ammount )
	if isGroupExists( group ) then
		local members, _ = getGroupSlots( group );
		if tonumber( members ) < tonumber( ammount ) then
			regis_db:exec( "UPDATE groupsystem SET slots=? WHERE groupname=?", tostring( ammount ),group )
			local account = source:getAccount();
			local accountName = account:getName();
			local time = getRealTime(  );
			local hour = "["..time.hour..":"..time.minute..":"..time.second.."]"
			local by = accountName.." ( "..string.gsub( source:getName(), "#%x%x%x%x%x%x", "").." )"
			table.insert( actionS, { #actionS+1, hour, by, "Update the group slots: "..group} )
			source:outputChat("Has editado los slots del grupo: "..group.." A "..ammount,0,200,0,true)
		else
			source:outputChat("No puedes ingresar una cantidad menor a la de miembros del grupo!",200,0,0)
		end
	end
end
addEventHandler("editSlotsAGP", root, editSlotsAGPP )

function saveTheINfoGPC( texto, grupo )
	if isGroupExists( grupo ) then
		local account = source:getAccount();
		local accountName = account:getName();
		local by = accountName.." ( "..string.gsub( source:getName(), "#%x%x%x%x%x%x", "").." )"
		regis_db:exec("UPDATE groupinfo SET info=? WHERE gpname=?", texto.."\n\n Editado por: "..by, grupo )
		source:outputChat("Has editado la informacion del grupo: "..grupo,0,200,0,true)
		addActionReg( source, "Edito la informacion del grupo: "..grupo )
	end
end
addEventHandler("saveINFOGPC", root, saveTheINfoGPC )

function deleteAMembersGPC( nick, grupo )
	local player = getPlayerFromName ( nick );
	if isElement( player ) then
		removePlayerFromGroup( player, grupo)
		addActionReg( source, "Delete "..nick:gsub( "#%x%x%x%x%x%x", "" ).. " From group: "..grupo)
		source:outputChat("Has borrado a "..nick:gsub( "#%x%x%x%x%x%x", "" ).." Del grupo: "..grupo, 0, 200, 0, true)
	else
		regis_db:exec( "DELETE FROM groupmembers WHERE name=? AND membername=?", grupo, nick)
		addActionReg( source, "Delete "..nick:gsub( "#%x%x%x%x%x%x", "" ).. " From group: "..grupo)
		source:outputChat("Has borrado a "..nick:gsub( "#%x%x%x%x%x%x", "" ).." Del grupo: "..grupo, 0, 200, 0, true)
	end
end
addEventHandler("deleteAmmGpc", root, deleteAMembersGPC )

function aggAMemberGPCListToO( nick, group )
	local members, slots = getGroupSlots( group )
			local player = getPlayerFromName( nick );
			if isElement( player ) then
				local account = source:getAccount();
				local accountName = account:getName();
				local by = accountName.." ( "..string.gsub( source:getName(), "#%x%x%x%x%x%x", "").." )"
				player:setData( "gang", group )
				player:setData( "Group", group )
				addPlayerToGroup( player, group )
				addActionReg( source, "Añadio a "..nick:gsub( "#%x%x%x%x%x%x", "" ).." Al grupo: "..group )
				player:outputChat("Fuiste añadido al grupo: "..group.." Por "..by)
				source:outputChat("Fue añadido correctamente el jugador!", 0, 200, 0)
			else
				source:outputChat("El jugador no existe o se desconecto!",200,0,0,true)
			end
end
addEventHandler("addAmemberGPCListlel", root, aggAMemberGPCListToO )

function editArangoGPC( playerName, rango )
	local player = Player( playerName )
	if isElement( player ) then
		setPlayerRang( player, rango )
		addActionReg( source, "Cambio el rango de: "..playerName:gsub( "#%x%x%x%x%x%x", "" ).." a "..rango)
		source:outputChat("Has cambiado el rango de: "..playerName:gsub( "#%x%x%x%x%x%x", "" ).." a "..rango,0,200,0,true)
		triggerClientEvent( source, "refreshGPCListMmm" , source )
	else
		source:outputChat("El jugador no existe!", 200, 0, 0, true)
	end
end
addEventHandler("editArangGPC", root, editArangoGPC )

function editAGPNaMe( oldName, newName )
	if not isGroupExists( newName ) then
		local qh = regis_db:query("SELECT * FROM groupmembers WHERE name=?", oldName)
		for _, columna in ipairs( dbPoll( qh, -1 ) ) do
			local acc, nick = columna["memberacc"], columna["membername"];
			local player = Player( nick );
			if isElement( player ) then
				regis_db:exec( "UPDATE groupmembers SET name=? WHERE memberacc=?", newName, acc )
				player:setData("gang", newName )
				player:setData("Group", newName )
				Regetdatas( player )
			else
				regis_db:exec( "UPDATE groupmembers SET name=? WHERE memberacc=?", newName, acc )
			end
		end
		regis_db:exec("UPDATE groupsystem SET groupname=? WHERE groupname=?", newName, oldName )
		addActionReg( source, "Cambio el nombre del grupo: "..oldName.." A "..newName)
		source:outputChat("Has cambiado el nombre del grupo: "..oldName.." A "..newName, 0, 200, 0, true )
	else
		source:outputChat("El nombre del grupo ingresado, Ya existe!", 200, 0, 0, true )
	end
end
addEventHandler("editGPNAMEGPC", root, editAGPNaMe )