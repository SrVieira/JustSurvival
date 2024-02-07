local pingFails = 0

function playerPingCheck()
	if not localPlayer:getData('Iniciado') or localPlayer:getData('Admin') then return end
		if getPlayerPing(getLocalPlayer()) > 550 then
			if pingFails == 5 then return end
				pingFails = pingFails + 1
				triggerEvent('DayZ:MostrarMensaje', localPlayer, "#FF0000Tu ping es demasiado alto! (Aviso " .. pingFails .. " de 5)")
			if pingFails == 5 then
				triggerServerEvent("kickPlayerOnHighPing", localPlayer)
				return
			end
		if isTimer(pingTimer) then
			return
		end
		pingTimer = setTimer(function()
		pingFails = 0
		end, 30000, 1)
	end
end
setTimer(playerPingCheck, 4000, 0)
	