local tick = {}

addEventHandler("onResourceStart", resourceRoot, 
	function()
		for key, player in ipairs(getElementsByType("player")) do
			if getElementData(player, "Logeado") then
				triggerEvent("onPlayerChatBound", player)
			end
		end
	end
)

addEventHandler("onPlayerJoin", root, 
	function()
		triggerEvent("onPlayerChatBound", source)
	end
)

addEvent("onPlayerChatBound", true)
addEventHandler("onPlayerChatBound", root, 
	function()
		tick[source] = {}
		bindKey(source, "x", "down", "chatbox", "global")
	end
)

addEvent("onPlayerDayZSpawn", true)
addEventHandler("onPlayerDayZSpawn", root, 
	function()
		tick[source] = {}
		bindKey(source, "x", "down", "chatbox", "global")
	end
)

addEventHandler("onPlayerQuit", root, 
	function()
		if tick[source] then
			if tick[source]["global"] then
				if isTimer(tick[source]["global"]) then
					killTimer(tick[source]["global"])
				end
				tick[source]["global"] = nil
			end
			if tick[source]["localchat"] then
				if isTimer(tick[source]["localchat"]) then
					killTimer(tick[source]["localchat"])
				end
				tick[source]["localchat"] = nil
			end
		end
	end
)

function chatGlobal(player, _, ...)
	if getElementData(player, "Logeado") and not isPlayerMuted(player) then
		local account = getPlayerAccount(player)
		if isGuestAccount(account) then return end
		if not tick[player] then return end
		
		if not tick[player]["global"] then
			local Texto = {...}
			local Mensaje = table.concat(Texto, " ")
			local Tag = ""

			if not getElementData(player, "hideadmin") then
				if isObjectInACLGroup ("user."..getAccountName(account), aclGetGroup ("Moderator")) then
					Tag = "#00FF00[Moderador]"			
				elseif isObjectInACLGroup ("user."..getAccountName(account), aclGetGroup ("SuperModerator")) then
					Tag = "#00AA00[S.Mod]"
				elseif isObjectInACLGroup ("user."..getAccountName(account), aclGetGroup ("Admin")) then
					Tag = "#FF0000[Admin]"			
				end
			end

			if getAccountName(account) == 'Sukor' then
				Tag = "#0030FF[Dueño]#00a2ff"
			end

			local Texto = string.format("%s %s: %s", Tag, ""..getPlayerName(player), "#FFFFFF"..Mensaje.."#FFFFFF")	
			outputChatBox(Texto, root, 0, 108, 151, true)
			outputServerLog(Texto:gsub("#%x%x%x%x%x%x", ""))
			
			tick[player]["global"] = true
			setTimer(unabled, 1000, 1, player, "global")
		end
	end
end
addCommandHandler("global", chatGlobal)

function hideadmin(p)
	if hasObjectPermissionTo(p, "command.mute") then
		setElementData(p, "hideadmin", not getElementData(p, "hideadmin"))
	end
end
addCommandHandler("hideadmin", hideadmin)

function chatLocal(Mensaje, tipo)
	cancelEvent()
	
	if getElementData(source, "Logeado") then
		local account = getPlayerAccount(source)
		if isGuestAccount(account) then return end
		--if tipo == 1 then return end
		if not tick[source] then return end
		
		if not tick[source]["localchat"] then
			if tipo == 0 then			
				local Texto = string.format("%s %s: %s", "[LOCAL] ", getPlayerName(source):gsub("#%x%x%x%x%x%x", ""), "#FFFFFF"..Mensaje)	
				
				for _, Otros in ipairs(getElementsByType("player")) do
					local PuntoA = {getElementPosition(source)}
					local PuntoB = {getElementPosition(Otros)}
					if getDistanceBetweenPoints3D(PuntoA[1], PuntoA[2], PuntoA[3], PuntoB[1], PuntoB[2], PuntoB[3]) <= 10 then
						outputChatBox(Texto, Otros, 150, 150, 150, true)
					end
				end
			end
		
			tick[source]["localchat"] = true
			setTimer(unabled, 1000, 1, source, "localchat")
		end
	end
end
addEventHandler("onPlayerChat", root, chatLocal)

function unabled(ply, str)
	tick[ply][str] = nil
end