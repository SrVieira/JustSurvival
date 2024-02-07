--// Creador: TheCrazy
--// Fecha: 05/03/2017
--// Proposito: Envio de datos a los clientes

addCommandHandler("anun", function(Jugador, Comando, ...)
	local Texto = table.concat({...}," ")

	if isObjectInACLGroup ("user."..getAccountName(getPlayerAccount(Jugador)), aclGetGroup("Admin")) or isObjectInACLGroup ("user."..getAccountName(getPlayerAccount(Jugador)), aclGetGroup("Moderator"))
	or isObjectInACLGroup ("user."..getAccountName(getPlayerAccount(Jugador)), aclGetGroup("SuperModerator")) then
		triggerClientEvent('RecibirAnuncio', getRootElement(), Texto, getPlayerName(Jugador))
	end
end)