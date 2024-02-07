function sendServerInfo()
	local info = {
		maxPlayers = getMaxPlayers(),
		serverName = getServerName(),
	}
	triggerClientEvent(source, "onScoreboardSendServerInfo", source, info)
end
addEvent("onScoreboardGetServerInfo", true)
addEventHandler("onScoreboardGetServerInfo", root, sendServerInfo)