addEventHandler("onPlayerJoin", root,
function()
	local ip = getPlayerIP(source)
	--fetchRemote("http://ip-api.com/json/"..ip, outputJoin, "", false, source)
	outputChatBox("* "..getPlayerName(source):gsub("%x%x%x%x%x%x", "") .." ha entrado al servidor.", root, 0, 255, 0, true)
end)

--[[
function outputJoin(response, errno, thePlayer)
	local joinData = fromJSON(response)
	local country = joinData.country or "N/A"
	local region = joinData.regionName or "N/A"
	--city = joinData.city
	outputChatBox("#0096AD * "..getPlayerName(thePlayer):gsub("%x%x%x%x%x%x", "") .." ingresó al servidor! ["..country..", "..region.."]", root, 255, 255, 255, true)
end
]]
addEventHandler('onPlayerChangeNick', root,
	function(oldNick, newNick)
		cancelEvent ()
	end
)

addEventHandler('onPlayerQuit', root,
	function(reason)
		if reason == "Quit" then
			trullyReason = "Salida"
		elseif reason == "Kicked" then
			trullyReason = "Expulsado"
		elseif reason == "Banned" then
			trullyReason = "Baneado"
		elseif reason == "Bad Connection" then
			trullyReason = "Mala conexión"
		elseif reason == "Timed out" then
			trullyReason = "Tiempo de espera excedido"
		else
			trullyReason = "Desconocida"
		end
		outputChatBox("* "..getPlayerName(source):gsub("%x%x%x%x%x%x", "") .." salió del servidor [" .. trullyReason .. "]", root, 0, 255, 0, true)
	end
)