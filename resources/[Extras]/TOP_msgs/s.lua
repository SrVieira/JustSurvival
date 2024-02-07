addEventHandler("onPlayerCommand", root,
	function(cmd)
		if cmd == "msg" then
			executeCommandHandler("spm", source)
			cancelEvent()
		end
	end
)

function sendPrivateMessage(myself, _, name, ...)
	local theotherguy = getPlayerFromPartialName(name);
	message = {...}
	
	if (not message or #message == 0) or (not name) then
		outputChatBox("Error de sintáxis: /spm <jugador> <mensaje>", myself, 255, 0, 0);
		return
	end

	if not isElement(theotherguy) then
		outputChatBox("No existe este jugador!", myself, 255, 0, 0);
		return
	end
	
	if not getElementData(theotherguy, "Logeado") then
		return
	end
	
	if getElementData(theotherguy, "nopm") then
		outputChatBox("Este jugador no acepta mensajes privados", myself, 255, 255, 255);
		return
	end

	local text = table.concat(message, " ")
	outputChatBox("*! "..getPlayerName(myself):gsub("#%x%x%x%x%x%x", "").." > "..getPlayerName(theotherguy):gsub("#%x%x%x%x%x%x", "")..": "..text, myself, 255, 100, 0);
	outputChatBox("*! "..getPlayerName(myself):gsub("#%x%x%x%x%x%x", "")..": "..text, theotherguy, 100, 255, 100);
end
addCommandHandler("spm", sendPrivateMessage)

addCommandHandler("epm",
	function(player)
		setElementData(player, "nopm", not getElementData(player, "nopm"))
		if getElementData(player, "nopm") then
			outputChatBox("Mensajes privados activados!", player, 255,255,0)
		else
			outputChatBox("Mensajes privados desactivados!", player, 255,255,0)
		end
	end
)

function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end