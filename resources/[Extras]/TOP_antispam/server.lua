antiSpam = {} 
function antiChatSpam() 
	if isTimer(antiSpam[source]) then
		cancelEvent()  
		outputChatBox("#ffffff"..getPlayerName(source).." #ff6600Ha sido silenciado! ( 30 segundos )", getRootElement(), 255, 255, 0,true) 
		setPlayerMuted(source, true)
		setTimer ( autoUnmute, 30000, 1, source)
	else
		antiSpam[source] = setTimer(function(source) antiSpam[source] = nil end, 1000, 1, source) 
	end
end
addEventHandler("onPlayerChat", root, antiChatSpam)


function autoUnmute ( player )
	if ( isElement ( player ) and isPlayerMuted ( player ) ) then
		setPlayerMuted ( player, false )
		outputChatBox ("#FFFFFF"..getPlayerName ( player ).." #ff6600Ha sido desmuteado !",getRootElement(), 255, 255, 0,true )
	end
end