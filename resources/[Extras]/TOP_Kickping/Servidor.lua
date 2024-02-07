function kickPlayerOnHighPing()
	if getElementData(source, "Admin") then return end

	outputChatBox(getPlayerName(source).." #FF0000ha sido expulsado por su alto ping!",getRootElement(),27,89,224,true)
	kickPlayer(source, "Console", "Ping muy alto!")
end
addEvent("kickPlayerOnHighPing", true)
addEventHandler("kickPlayerOnHighPing", getRootElement(), kickPlayerOnHighPing)