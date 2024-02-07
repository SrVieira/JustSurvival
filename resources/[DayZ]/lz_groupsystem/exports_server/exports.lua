
-----------------------------------------------
--  Desarrollador/Developer: -Rex-
--  Proyecto/Proyect:        N/A
--  Contacto/Contact:        https://www.facebook.com/rexscripting/
--
--  Libre uso y modificacion, No borrar los creditos, Gracias
-----------------------------------------------

local database = dbConnect( "sqlite", "dbData.db" )

function isGroupExists( groupnames )
	
	--assert( groupnames, "Error bad argument @ 'groupnames' [Expected at argument 1, got "..tostring(groupnames).." ]")

	local qh = database:query( "SELECT groupname FROM groupsystem WHERE groupname=?", tostring( groupnames ) )
	local consulta = dbPoll( qh, -1 )

	for k,con in pairs(consulta) do
		if con["groupname"] then
			return true
		else
			return false
		end
	end	
end

function getPlayerGroup( player )

	assert( getElementType( player ) == "player", "Error bad argument @ 'player' [Expected at argument 1, got "..tostring(player).." ]")
	local acc = getAccountName(getPlayerAccount( player ))

	local qh = database:query( "SELECT * FROM groupmembers")
	local table = dbPoll( qh, -1 )
	
	for i, con in ipairs( table ) do
		if con["memberacc"] == tostring( acc ) then
			local gangname = tostring(con["name"])
			return gangname or false
		end
	end 
end

function isPlayerFounder( player, gang )

	assert( getElementType( player ) == "player", "Error bad argument @ 'player' [Expected at argument 2, got "..tostring(player).." ]")
	assert( type( gang ) == "string", "Error bad argument @ 'gang' [Expected at argument 2, got "..tostring(gang).." ]" )
	
	local acc = getAccountName(getPlayerAccount( player ))
	
	local qh = database:query( "SELECT rang FROM groupmembers WHERE name=? AND memberacc=?",gang,acc)
	local consulta = dbPoll( qh, -1 )

	for i,con in ipairs (consulta) do	

		if con["rang"] == "Creador" then

			return true
		else
			return false
		end
	end
end

function isAccountOfFounder( account, gang )
	

	local qh = database:query( "SELECT rang FROM groupmembers WHERE name=? AND memberacc=?",gang, account)
	local consulta = dbPoll( qh, -1 )

	for i,con in ipairs (consulta) do	

		if con["rang"] == "Creador" then

			return true
		else
			return false
		end
	end

end

function getAccountFromName( name )
	

	local qh = database:query( "SELECT * FROM groupmembers WHERE membername=?", name )
	local consulta = dbPoll( qh, -1 )

	for i,con in ipairs (consulta) do	
		return con["memberacc"]
	end

end


function isPlayerLeader( player, gang )

	assert( getElementType( player ) == "player", "Error bad argument @ 'player' [Expected at argument 2, got "..tostring(player).." ]")
	assert( type( gang ) == "string", "Error bad argument @ 'gang' [Expected at argument 2, got "..tostring(gang).." ]" )
	
	local acc = getAccountName(getPlayerAccount( player ))
	
	local qh = database:query( "SELECT rang FROM groupmembers WHERE name=? AND memberacc=?",gang,acc)
	local consulta = dbPoll( qh, -1 )

	for i,con in ipairs (consulta) do	

		if con["rang"] == "Lider" then

			return true
		else
			return false
		end
	end
end

function isPlayerInGroup( player )

	assert( getElementType( player ) == "player", "Error bad argument @ 'player' [Expected at argument 1, got "..tostring(player).." ]")

	local acc = getAccountName(getPlayerAccount( player ))

	local qh = database:query( "SELECT memberacc FROM groupmembers WHERE memberacc=?",acc )
	local consulta = dbPoll( qh, -1 )

	for i,con in ipairs(consulta) do
		if con["memberacc"] then
			return true
		else
			return false
		end
	end 
end

function isAccountInGroup( acc )

	local qh = database:query( "SELECT memberacc FROM groupmembers WHERE memberacc=?",acc )
	local consulta = dbPoll( qh, -1 )

	for i,con in ipairs(consulta) do
		if con["memberacc"] then
			return true
		else
			return false
		end
	end 
end

function addPlayerToGroup( player, gang)
	assert( getElementType( player ) == "player" and isElement(player), "Error bad argument @ 'player' [Expected at argument 2, got "..tostring(player).." ]")
	assert( type(gang) == "string", "Error bad argument @ 'gang' [Expected at argument 2, got "..tostring(gang).." ]" )
	if isGroupExists( gang ) then
		local acc = getAccountName(getPlayerAccount( player ))
		database:exec("INSERT INTO groupmembers ( name,memberacc,membername,rang,status) VALUES(?,?,?,?,?)", gang, acc, getPlayerName(player), "Trial","Activo" )
	else
		error("Error bad argument @ 'gang [ Group is nil ] ")
	end
end

function addAccountToGroup( acc, gang)

		database:exec("INSERT INTO groupmembers ( name,memberacc,membername,rang,status) VALUES(?,?,?,?,?)", gang, acc, "Player", "Trial","Activo" )
	
end

function setPlayerRang( player, rang )
	assert( getElementType( player ) == "player" and isElement(player), "Error bad argument @ 'player' [Expected at argument 2, got "..tostring(player).." ]")

	assert( type(rang) == "string", "Error bad argument @ 'rang' [Expected at argument 2, got "..tostring(rang).." ]" )
	if not getPlayerAccount( player ):isGuest() then
		local acc = getAccountName(getPlayerAccount( player ))
		local gang = getPlayerGroup(player)
		if isGroupExists( gang ) then
			database:exec( "UPDATE groupmembers SET rang=? WHERE memberacc=? AND name=?", tostring( rang ),acc,gang )
		else
			error( "Error bad argument @ 'gang' [Expected at argument 1, Group is nil ]" )
		end
	end
end

function getPlayerRang( player)

	assert( getElementType( player ) == "player" and isElement(player), "Error bad argument @ 'player' [Expected at argument 2, got "..tostring(player).." ]")
	local gang = getPlayerGroup(player)

	if isPlayerInGroup ( player ) then
		local acc = getAccountName(getPlayerAccount( player ))
		local qh = database:query( "SELECT rang FROM groupmembers WHERE memberacc=? AND name=?",acc, gang )
		local consulta = dbPoll( qh, -1 )
		for i,columna in pairs( consulta ) do
			local rang = columna["rang"]
			if rang then
				return rang
			end
		end
	else
		error( "Error bad argument @ 'gang' [Expected at argument 1, Group is nil ]" )
	end
end

function removePlayerFromGroup( player, gang)
	assert( getElementType( player ) == "player", "Error bad argument @ 'player' [Expected at argument 1, got "..tostring(player).." ]")
	assert( type( gang ) == "string", "Error bad argument @ 'gang' [Expected at argument 2, got "..tostring(gang).." ]" )

	if isGroupExists( gang ) then
		if isElement( player ) then
			local acc = getAccountName(getPlayerAccount( player ))
			database:exec( "DELETE FROM groupmembers WHERE name=? AND memberacc=?", gang,acc)
		else
			error("Error bad argument @player [ player is nil or player is offline ]")
		end
	else
		error( "Error bad argument @ 'gang' [Expected at argument 1, Group is nil ]" )
	end
end

--members,slots = getGroupSlots("prueba")
function getGroupSlots( gangname )
	--assert( type( gangname ) == "string", "Error bad argument @ 'gangname' [Expected at argument 1, got "..tostring(gangname).." ]" )
	--if isGroupExists ( gangname ) then
		local qh = database:query( "SELECT slots FROM groupsystem WHERE groupname=?",gangname)
		local table = dbPoll( qh, -1 ) 
		for _,columna in pairs(table) do
			slots = tonumber( columna["slots"] )
			local rqh = database:query( "SELECT memberacc FROM groupmembers WHERE name=?",gangname)
			local total = dbPoll( rqh, -1 ) 
			if total then
				return #total,slots
			end
		end
	--else
		--error( "Error bad argument @ 'gang' [Expected at argument 1, Group is nil ]" )
	--end
end

function addGroupSlots( group, ammount )
	assert( type( group ) == "string", "Error bad argument @ 'group' [Expected at argument 1, got "..tostring(group).." ]" )
	assert( type( tonumber(ammount) ) == "number","Error bad argument @ 'ammount' [Expected at argument 2, got number" )
	if isGroupExists( group ) then
		local qh = database:query( "SELECT * FROM groupsystem WHERE groupname=?",group)
		local table = dbPoll( qh, -1 )
		for i,columna in pairs( table)  do
			local slots = columna["slots"]		
			local s = tonumber(slots) + tonumber(ammount)
			database:exec( "UPDATE groupsystem SET slots=? WHERE groupname=?", tostring( s ),group )
			outputServerLog(  group.." Changed slots to: "..tostring(s) )
		end
	else
		error( "Error bad argument @ 'group' [Expected at argument 1, got nil" )
	end
end


function deleteGroup( gang )
	--assert( type(gang) == "string", "Error bad argument @ 'gang' [Expected at argument 1, got "..tostring(gang).." ]" )
	local alianzas = getGroupAlianzes( gang )
	for i,v in ipairs( alianzas ) do
		deleteAlianze( gang, v )
	end

	local ranksTable  = getGroupRanks ( gang )

	for _, c in ipairs( ranksTable ) do
		deleteGroupRank( gang, c[1] )
	end
	database:exec( "DELETE FROM groupsystem WHERE groupname=?", gang)
	database:exec( "DELETE FROM groupinfo WHERE gpname=?", gang)
	local qh = database:query("SELECT * FROM groupmembers WHERE name=?",gang)
	for _, columna in ipairs( dbPoll( qh, -1 ) ) do
		local acc = columna["memberacc"]
		database:exec("DELETE FROM groupmembers WHERE memberacc=?", acc)
	end
	database:exec( "DELETE FROM groupmembers WHERE name=?", gang)
	outputServerLog( "The group "..gang.." Has been deleted" )
end

function setGroupColor( gang, colorT, colorC )
	assert( type( gang ) == "string", "Error bad argument @ 'gang' [Expected at argument 1, got "..tostring( gang ).." ]" )

	if isGroupExists ( gang ) then
		database:exec( "UPDATE groupsystem SET colorTag=?, colorChat=? WHERE groupname=?", colorT, colorC, gang )
	else
		error("Error bad argument @ 'gang [ Group is nil ] ")
	end
end

function getGroupColor( gang )
	assert( type( gang ) == "string", "Error bad argument @ 'gang' [Expected at argument 1, got "..tostring( gang ).." ]" )

	if isGroupExists ( gang ) then
		local qh = database:query( "SELECT colorTag, colorChat FROM groupsystem WHERE groupname=?",gang)
		local table = dbPoll( qh, -1 )
		for _,columna in pairs(table) do
			return columna["colorTag"], columna["colorChat"]
		end
	end
end

function isDbTableEmpty( database, tabla )
	local testQuery = dbQuery( database, "SELECT * FROM "..tabla )
	local poll      = dbPoll( testQuery, -1 )
	if #poll == 0 then
		return true
	end
	return false
end