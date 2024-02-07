---------------------------------------------------------------------
--  Desarrollador/Developer: -Rex-
--  Proyecto/Proyect:        N/A
--  Contacto/Contact:        https://www.facebook.com/rexscripting/
--
--  Libre uso y modificacion, No borrar los creditos, Gracias
---------------------------------------------------------------------

local connection = dbConnect( "sqlite", "dbData.db" )
local DELETEGROUPS_ONSTOP = false
local TOTALSLOTS_ONCREATE = 100
local costoSlots = 5000
local r,g,b,a = 255,255,255,255
local INFORMATION_NEWGROUP = "Coloca aquí la informacion del grupo."

inv_table = {}
count = {}
groupCacheTable = {}
function onstart(  )
    local qh = dbQuery( connection,"CREATE TABLE IF NOT EXISTS groupsystem (groupname STRING NOT NULL, colorTag STRING NOT NULL, colorChat STRING NOT NULL, slots INTEGER NOT NULL)")
    local qh1 = dbQuery( connection,"CREATE TABLE IF NOT EXISTS groupmembers (name STRING, memberacc STRING, membername STRING, rang STRING, status STRING, uactive STRING )")
    local qh2 = dbQuery( connection,"CREATE TABLE IF NOT EXISTS groupinfo (gpname STRING, info STRING)")

	dbFree( qh ) dbFree( qh1 ) dbFree( qh2 ) 

	for _, player in ipairs( getElementsByType("player") ) do
		local account = player:getAccount ( )
   		if not account:isGuest ( ) then
   			local accname = account:getName()
   			connection:exec( "UPDATE groupmembers SET membername=? WHERE memberacc=?", player:getName(), accname )
   		end
    	if isPlayerInGroup( player ) then
			local grupo = getPlayerGroup( player )
			setGroup ( player, grupo )
		else
			setGroup ( player, "N/A" )
		end
    end
end
addEventHandler("onResourceStart",getResourceRootElement( getThisResource() ),onstart)


function onstop()
	if DELETEGROUPS_ONSTOP then
    	local qh = dbQuery( connection,"DROP TABLE groupsystem" )
    	local qh1 = dbQuery( connection,"DROP TABLE  groupmembers" )
    	local qh2 = dbQuery( connection,"DROP TABLE  groupinfo" )
		dbFree( qh ) dbFree( qh1 ) dbFree( qh2 ) 
    	outputDebugString( "[SISTEMA-GRUPAL] Se removio satisfactoriamente la tabla de Grupos" )
    	addActionConsoleReg( "La base de datos fue eliminada")
    end
end
addEventHandler("onResourceStop",getResourceRootElement( getThisResource() ),onstop)

function setElData( _, _, player )
	if isPlayerInGroup( player ) then
		local grupo = getPlayerGroup( player )
		setGroup ( player, grupo )	
	else
		setGroup ( player, "N/A" )
	end
end
addEvent("onPlayerDayZLogin", true)
addEventHandler("onPlayerDayZLogin", getRootElement(), setElData)

function coloresDelChat( queflojeraxd )
	local colorG = { getGroupColor( getPlayerGroup( source ) ) }

	local tag = colorG[1]
	local chat = colorG[2]

	triggerClientEvent(source,"coloorChat",source, tag, chat)
end
addEvent("coloresOfGroup", true)
addEventHandler("coloresOfGroup", getRootElement(), coloresDelChat)

function createNewGroup(name)

	if not isGroupExists(name) then

			if not isPlayerInGroup(source) then
				local acc = getAccountName(getPlayerAccount( source ))
				local myname = getPlayerName(source)

				local date = getTimes ( )

				dbExec( connection,"INSERT INTO groupsystem ( groupname, colorTag, colorChat,slots) VALUES(?,?,?,?)", name, "#00ff00", "#ffffff",TOTALSLOTS_ONCREATE )
				dbExec( connection,"INSERT INTO groupmembers ( name,memberacc,membername,rang,status, uactive) VALUES(?,?,?,?,?,?)", name, acc, myname, "Creador", "Activo", date )
				dbExec( connection,"INSERT INTO groupinfo ( gpname,info) VALUES(?,?)", name, INFORMATION_NEWGROUP )
				--createNewGroupRank( name, "Creador", "true", "true", "true", "true", "true", "true" )
				createNewGroupRank( name, "Trial", "false", "false", "false", "false", "false", "false" )
				setGroup ( source, name )
				addActionReg( source, "Creo el grupo: "..name)
				addGroupLog( name, myname.." ( "..acc.." ) Fundo el grupo." )
			else	
				createNotification("Ya tienes un grupo!",source,255, 255, 255, true)
			end
		else

		createNotification("El grupo ya existe!",source,255, 255, 255, true)
	end
end
addEvent("createnewGroup",true)
addEventHandler("createnewGroup",getRootElement(  ),createNewGroup)


function getdatas()
	local gang = getPlayerGroup(source)

	if not isPlayerInGroup(source) then
		triggerClientEvent(source,"datosdegui",source,"N/A","no", "no")
	else

		if isPlayerFounder(source,gang) then
			triggerClientEvent(source,"datosdegui",source,gang,"si","si", "true", "true", "true", "true", "true", "true")
		else

			local rango       = getPlayerRang( source )
			local c           = { getGroupRankPermisos( gang, rango ) }
			local kick        = c[1]
        	local chat        = c[2]
        	local Crangos     = c[3]
        	local Alianzas    = c[4]
        	local apelaciones = c[5]
        	local informacion = c[6]

        	if kick == "true" or chat == "true" or Crangos == "true" or Alianzas == "true" or apelaciones == "true" or informacion == "true" then
        		triggerClientEvent(source,"datosdegui",source,gang,"si","no", "si", kick, chat, Crangos, Alianzas, apelaciones, informacion )
        	else
        		triggerClientEvent(source,"datosdegui",source,gang,"si","no", "no" )
        	end

		end

	end
end
addEvent("getdatasgroup",true)
addEventHandler("getdatasgroup",getRootElement(  ),getdatas)

function Regetdatas( player )
	local gang = getPlayerGroup(source)

	if not isPlayerInGroup(source) then
		triggerClientEvent(source,"datosdegui",source,"N/A","no", "no")
	else

		if isPlayerFounder(source,gang) then
			triggerClientEvent(source,"datosdegui",source,gang,"si","si", "true", "true", "true", "true", "true", "true")
		else

			local rango       = getPlayerRang( source )
			local c           = { getGroupRankPermisos( gang, rango ) }
			local kick        = c[1]
        	local chat        = c[2]
        	local Crangos     = c[3]
        	local Alianzas    = c[4]
        	local apelaciones = c[5]
        	local informacion = c[6]

        	if kick == "true" or chat == "true" or Crangos == "true" or Alianzas == "true" or apelaciones == "true" or informacion == "true" then
        		triggerClientEvent(source,"datosdegui",source,gang,"si","no", "si", kick, chat, Crangos, Alianzas, apelaciones, informacion )
        	else
        		triggerClientEvent(source,"datosdegui",source,gang,"si","no", "no" )
        	end

		end

	end
end


function getTimes()
	local time = getRealTime()
	local dia = time.monthday

	if dia < 10 then
		dia = "0"..tostring(dia)
	end

	local mes = time.month+1

	if mes < 10 then
		mes = "0"..tostring(mes)
	end

	local date = dia.."/"..(mes).."/20"..( time.year - 100 )

	return date
end

function getdatasofgroupg(  )

	local date = getTimes ( )

	local qh = dbQuery( connection, "SELECT * FROM groupmembers WHERE name=?",getPlayerGroup(source))

	local activesTable   = { }
	local inactivesTable = { }

	for i,columna in ipairs( dbPoll( qh, -1 ) ) do

		local accountName  = columna["memberacc"]
		local nickName     = columna["membername"]
		local rankMember   = columna["rang"]
		local status       = columna["status"]

		local player = getPlayerFromName( columna["membername"] )

		if rankMember == "Creador" then

			if isElement ( player ) then
				table.insert( activesTable, 1, { "Ahora", nickName, rankMember, 0, 200, 0 })
			else
				table.insert( activesTable, 1, { ( columna["uactive"] or date ), nickName, rankMember, 200, 0, 0 })
			end
			break
		end

	end

	local qh = dbQuery( connection, "SELECT * FROM groupmembers WHERE name=?",getPlayerGroup(source))
	for i,columna in ipairs( dbPoll( qh, -1 ) ) do

		local accountName  = columna["memberacc"]
		local nickName     = columna["membername"]
		local rankMember   = columna["rang"]
		local status       = columna["status"]

		local player = getPlayerFromName( columna["membername"] )

		if rankMember ~= "Creador" then

			if isElement ( player ) then
				table.insert( activesTable,   { "Ahora", nickName, rankMember, 0, 200, 0 })
			else
				table.insert( inactivesTable, { ( columna["uactive"] or date ), nickName, rankMember, 200, 0, 0 })
			end

		end

	end

	triggerClientEvent(source,"addCgListM",source, activesTable, inactivesTable )
end
addEvent("getcdtgroup",true)
addEventHandler("getcdtgroup",getRootElement(  ),getdatasofgroupg)

function kickmembera( name, razon )
	
	local group         = getPlayerGroup( source )
	local myName        = getPlayerName ( source )
	local myAccountName = getAccountName( getPlayerAccount ( source ) )
	local player        = getPlayerFromName( name )
	local accountName = getAccountFromName( name )

	if not isAccountOfFounder( accountName, group ) then

		connection:exec( "DELETE FROM groupmembers WHERE memberacc=? AND name=?", accountName, group )

		addGroupLog( group, name.." Fue expulsado por "..myName.." ( "..myAccountName.." )".." Razón: "..razon )
		createNotification("Jugador expulsado!",source)

		if isElement ( player ) then
			outputChatBox("Fuiste expulsado de "..group.." Por: "..myName, player, 255, 255, 255, true)
		else
			addAcountMsg( accountName, "Fuiste expulsado por "..myName.." Razón: "..razon )
		end

	else
		createNotification("No se puede expulsar al Fundador!",source)
	end


end
addEvent("kickamemberoption",true)
addEventHandler("kickamemberoption",getRootElement(  ),kickmembera)

function changMmNewNick( _, nick )
	local account = source:getAccount ( )
   	if not account:isGuest ( ) then
   		local accname = account:getName()
   		connection:exec( "UPDATE groupmembers SET membername=? WHERE memberacc=?", nick,accname )
   	end
end
addEventHandler("onPlayerChangeNick", getRootElement(), changMmNewNick)

function checkStateOnJoins()
	local date = getTimes ( )
	local account = source:getAccount()
	local accountName = account:getName()
	connection:exec( "UPDATE groupmembers SET membername=?,status=?, uactive=? WHERE memberacc=?", source:getName(), "Activo", date, accountName )
	setElData( false, false, source )
end
addEventHandler ("onPlayerLogin", getRootElement(), checkStateOnJoins )

function leavePlayergroup(  )
	local acc = getAccountName(getPlayerAccount( source ))
	local gang = getPlayerGroup(source)
	if not isPlayerFounder( source, gang) then
		if gang then
			createNotification("Abandonaste el grupo!", source )
			removePlayerFromGroup(source, gang)
			setGroup ( source, "N/A" )
			addGroupLog( gang, getPlayerName( source ).." ( "..acc.." )".." abandonó el grupo." )
		end
	else
		createNotification("Debes eliminar el grupo para poder salirte!", source )
	end
end
addEvent("leaveofgroup",true)
addEventHandler("leaveofgroup",getRootElement(  ),leavePlayergroup)

function getServerListTT(  )
	local qh = connection:query( "SELECT groupname FROM groupsystem")
	local tablec = dbPoll( qh, -1 )
	if tablec then
		local listCache = { }

		for i,columna in ipairs(tablec) do

			for _,grupo in pairs ( columna ) do

				local GPSlot  = { getGroupSlots(grupo) }
				local players = GPSlot[1]
				local slots   = GPSlot[2]

				if players and slots then
					table.insert( listCache, { grupo, players.."/"..slots })
				end

			end

		end

		triggerClientEvent(source,"addGLLListM",source, listCache )
	end
end
addEvent("gtlistgpsv",true)
addEventHandler("gtlistgpsv",getRootElement(  ),getServerListTT)

function getGroupList(  )
	local newT = {}
	local qh = connection:query( "SELECT groupname FROM groupsystem")
	local tableT = dbPoll( qh, -1 )
	for i,columna in ipairs(tableT) do
		table.insert( newT, {columna["groupname"]} )
	end
	return newT
end

function gtgpinfo()
	local qh = connection:query( "SELECT * FROM groupinfo WHERE gpname=?",getPlayerGroup(source))
	local table = dbPoll( qh, -1 )

	triggerClientEvent(source,"goupinfo", source, table[1].info)
end
addEvent("gpgpphelpinfo",true)
addEventHandler("gpgpphelpinfo",getRootElement(  ),gtgpinfo)

function getinfotoedit()
	local gang = getPlayerGroup(source)
	local qh = connection:query("SELECT * FROM groupinfo WHERE gpname=?",gang)
	local table = dbPoll( qh, -1 )

	triggerClientEvent(source,"toeditinfogp",source,table[1].info)
end
addEvent("setinfotoedit",true)
addEventHandler("setinfotoedit",getRootElement(  ),getinfotoedit)

function saveandUpgradeInfo( text )
	local mygang = getPlayerGroup( source )
	--if isPlayerFounder( source, mygang) or isPlayerLeader( source, mygang) then
		connection:exec( "UPDATE groupinfo SET info=? WHERE gpname=?", text, mygang )
		createNotification("Has actualizado la informacion del grupo", source, 255, 255, 255, true)
		addActionReg( source, "Se actualizo la informacion del grupo "..mygang)
	--end
end
addEvent("saveAeditedinfos",true)
addEventHandler("saveAeditedinfos",getRootElement(  ),saveandUpgradeInfo)

function deleteagroup(  )
	local acc = source:getAccount()
	if not acc:isGuest() then
		local gang = getPlayerGroup( source )
		if gang then
			if isPlayerFounder(  source, gang ) then
				local qh = connection:query("SELECT * FROM groupmembers WHERE name=?", gang)
				for _, columna in ipairs( dbPoll( qh, -1 ) ) do
					local acc, nick = columna["memberacc"], columna["membername"];
					local player = Player( nick );
					if isElement( player ) then
						setGroup ( player, "N/A" )
					end
				end

				deleteGroup( gang )
				createNotification("Grupo eliminado!",source)
				addActionReg( source, "Delete group: "..gang)
				setGroup ( source, "N/A" )
			else
				createNotification("Permiso denegado!",source,200,0,0,true)
			end
		end
	end
end
addEvent("deletemygp",true)
addEventHandler("deletemygp",getRootElement(  ),deleteagroup)

function setGroup ( player, gang )
	player:setData( "gang", gang )
	player:setData( "Group", gang )
end

function plinvgg(  )
	for i, player in ipairs( getElementsByType("player") ) do

		if source ~= player then 

			local acc = player:getAccount()
			local namePlayer = player:getName()
			local gang = getPlayerGroup( player )
			if not acc:isGuest() then
				if isPlayerInGroup ( player ) then
					local groupString = "Si"
					triggerClientEvent( source, "listofplayerinv",source, namePlayer, groupString)
				else
					local groupString = "No"
					triggerClientEvent( source, "listofplayerinv",source, namePlayer, groupString)
				end
			end
		end
	end
end
addEvent("getlistofplinvto",true)
addEventHandler("getlistofplinvto",getRootElement(  ),plinvgg)

--inv_table

local invitaciones = { }
function createainv( fromname )
	local player         = getPlayerFromName( fromname )
	local gang           = getPlayerGroup( source )
	local members, slots = getGroupSlots( gang )
	local myname         = source:getName()
	local accsource      = source:getAccount()
	local accpl          = player:getAccount()
	local accname        = accpl:getName()

	if not accsource:isGuest() then

		if not accpl:isGuest() then

			if myname ~= fromname then

				--if isPlayerFounder( source, gang ) or isPlayerLeader( source, gang ) then

					if not isPlayerInGroup( player ) then

						invitaciones[player] = nil
						if not haveInvitation( player, gang ) then
							invitaciones[player] = gang
							setElementData( player, "InvTable", invitaciones[player] )
							outputChatBox( "Recibiste una invitacion de: "..gang.."! Usa #00FF00/aceptar", player, 255, 255, 255, true )
							createNotification( "Invitación enviada!", source, 255, 255, 255, true )
							addGroupLog( gang, getPlayerName( source ).." ( "..getAccountName( getPlayerAccount( source ) ).." ) Envió una solicitud para: "..getPlayerName( player ) )
						else
							createNotification( "Invitación enviada!", source, 255, 255, 255, true )
						end

					else

						createNotification("El Jugador ya tiene grupo!",source, 255, 255, 255, true)
					end
				--end
				
			else
				createNotification("No puedes invitarte tu mismo",source,200,0,0,true)
			end
		end
	end
end
addEvent("sendainvtopl",true)
addEventHandler("sendainvtopl",getRootElement(  ),createainv)


function aceptarInvitacion( player, cmd )
	
	local grupo = invitaciones[player]
	local members, slots = getGroupSlots( grupo )
	if (members or 0) >= (slots or 100) then
		outputChatBox("No hay slots disponibles!", player, 255, 255, 255, true)
		return
	end

	if haveInvitation( player, grupo ) then

		invitaciones[player] = nil
		setElementData( player, "InvTable", nil )
		if isGroupExists( grupo ) then

			outputChatBox("Aceptaste la solicitud de "..grupo, player, 255, 255, 255, true)

			for _, players in ipairs( getElementsByType( "player" ) ) do
				
				local GGroup = getElementData( players, "gang" )

				if GGroup == grupo then
					outputChatBox(getPlayerName( player ).."#ffffff Entro al grupo", players, 255, 255, 255, true)
				end

			end

			addGroupLog( grupo, getPlayerName( player ).." Ingreso al grupo." )

			addPlayerToGroup( player, grupo, "Trial" )
			setGroup(player, grupo)
		end

	else
		createNotification( "No tienes una invitacion de: #00ff00"..grupo, player, 255, 255, 255, true )
	end

end
addCommandHandler( "aceptar", aceptarInvitacion )

function haveInvitation( player, group )
	
	if invitaciones[player] then
		return true
	end
	return false
end

function allgpdateforpromote(  )
	local grupo = getPlayerGroup(source)
	local qh    = dbQuery( connection, "SELECT * FROM groupmembers WHERE name=? ORDER BY uactive ASC", grupo)
	local tableC = dbPoll( qh, -1 )
	for _,columna in ipairs(tableC) do
		accmember,accname,rangmember,status = columna["memberacc"],columna["membername"],columna["rang"],columna["status"]
		triggerClientEvent(source,"addPronmgListM",source,accname,rangmember)
	end

	local Ca = { }

	local ranks = getGroupRanks( grupo )

	for i,v in ipairs(ranks) do
		table.insert( Ca, v[1] )
	end
	triggerClientEvent(source,"agregarRangos", source, Ca)
end
addEvent("reproms",true)
addEventHandler("reproms",getRootElement(  ),allgpdateforpromote)

function allgpdateforpromote2( player )
	local qh = dbQuery( connection, "SELECT * FROM groupmembers WHERE name=? ORDER BY uactive ASC",getPlayerGroup(player))
	local table = dbPoll( qh, -1 )
	for _,columna in ipairs(table) do
		accmember,accname,rangmember,status = columna["memberacc"],columna["membername"],columna["rang"],columna["status"]
		triggerClientEvent(player,"addPronmgListM",player,accname,rangmember)
	end
end

function newgprangme( pl, rang )
	local player = getPlayerFromName( pl )
	local accsource = source:getAccount()
	local myname = source:getName()
	local gang = getPlayerGroup( source )
	if myname ~= pl then

		if isElement( player ) then
			if isPlayerFounder( player, gang ) then
				createNotification("No puedes cambiarle el rango al Creador",source,255, 255, 255, true)
				return
			end
			setPlayerRang( player, rang)
			outputChatBox(myname.." te promovio al rango: "..rang,player, 255, 255, 255, true)

		else

			if isAccountOfFounder( getAccountFromName( pl ), gang ) then
				createNotification("No puedes cambiarle el rango al Creador",source,255, 255, 255, true)
				return
			end

			dbExec( connection, "UPDATE groupmembers SET rang=? WHERE memberacc=? AND name=?", rang, getAccountFromName( pl ), gang )
		end

		addActionReg( source, "Cambio el rango de: "..pl:gsub("#%x%x%x%x%x%x", "").." al: "..rang)
		addGroupLog( gang, getPlayerName( source ).." ( "..getAccountName ( accsource ).." ) Modifico el rango de "..pl.." Ahora es "..rang )
		createNotification("Rango cambiado!",source)
	else
		createNotification("Elige un jugador que no seas tú",source, 255, 255, 255, true)
	end
	allgpdateforpromote2( source )
end
addEvent("newrangforplayer",true)
addEventHandler("newrangforplayer",getRootElement(  ),newgprangme)

function changecolorgp( colorTag, colorChat )
	local apl = source:getAccount()
	local accname = apl:getName()
	local gang = getPlayerGroup( source )
	if not apl:isGuest() then
		setGroupColor( gang, colorTag, colorChat )
		createNotification("Nuevos colores asignados!",source, 255, 255, 255, true)
		addActionReg( source, "Change "..gang.." Color")
		addGroupLog( gang, getPlayerName( source ).." ( "..accname.." ) modificó los colores." )
	end
end
addEvent("donecolorchange",true)
addEventHandler("donecolorchange",getRootElement(  ),changecolorgp)

function getmembers(  )
	local date = getTimes ( )

	local qh = dbQuery( connection, "SELECT * FROM groupmembers WHERE name=?",getPlayerGroup(source))

	local activesTable   = { }
	local inactivesTable = { }

	for i,columna in ipairs( dbPoll( qh, -1 ) ) do

		local accountName  = columna["memberacc"]
		local nickName     = columna["membername"]
		local rankMember   = columna["rang"]
		local status       = columna["status"]

		local player = getPlayerFromName( columna["membername"] )

		if rankMember == "Creador" then

			if isElement ( player ) then
				table.insert( activesTable, 1, { "Ahora", nickName, rankMember, 0, 200, 0 })
			else
				table.insert( activesTable, 1, { ( columna["uactive"] or date ), nickName, rankMember, 200, 0, 0 })
			end
			break
		end

	end

	local qh = dbQuery( connection, "SELECT * FROM groupmembers WHERE name=?",getPlayerGroup(source))
	for i,columna in ipairs( dbPoll( qh, -1 ) ) do

		local accountName  = columna["memberacc"]
		local nickName     = columna["membername"]
		local rankMember   = columna["rang"]
		local status       = columna["status"]

		local player = getPlayerFromName( columna["membername"] )

		if rankMember ~= "Creador" then

			if isElement ( player ) then
				table.insert( activesTable,   { "Ahora", nickName, rankMember, 0, 200, 0 })
			else
				table.insert( inactivesTable, { ( columna["uactive"] or date ), nickName, rankMember, 200, 0, 0 })
			end

		end

	end

	triggerClientEvent(source,"listofmebers",source, activesTable, inactivesTable )
end
addEvent("viewmembersall",true)
addEventHandler("viewmembersall",getRootElement(  ),getmembers)

function onQuitSD( )
	local date = getTimes ( )
	local account = source:getAccount()
	local accountName = account:getName()
	connection:exec( "UPDATE groupmembers SET membername=?, status=?, uactive=? WHERE memberacc=?", "Inactivo", source:getName(), "Inactivo", date, accountName )
	if inv_table[source] then
		inv_table[source] = nil
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), onQuitSD )

function refreshDatas()
	for i, players in ipairs(getElementsByType("player")) do
		local grupo = getPlayerGroup ( players )
		if grupo then
			setGroup(players, grupo)
		else
			setGroup(players, "N/A")
		end
	end
end
setTimer( refreshDatas, 30000, 0 )