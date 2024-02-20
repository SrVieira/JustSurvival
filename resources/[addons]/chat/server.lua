local concat = table.concat;

function globalMessage(thePlayer, cmd, ...) 
    local message = concat( { ... }, " " );
    local name = getPlayerName(thePlayer);
    outputChatBox("(GLOBAL) "..name..": "..message, getRootElement(), 255, 255, 255, true);
end
addCommandHandler("GlobalChat", globalMessage);

function onPlayerChat(message, messageType)
    cancelEvent();

    local x, y, z = getElementPosition(source);
    local players = getElementsByType("player");
    
    for _, player in ipairs(players) do
        local px, py, pz = getElementPosition(player)
        local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz);
        if distance <= 10 then
            outputChatBox("(LOCAL) "..getPlayerName(source)..": "..message, player);
        end
    end
end
addEventHandler("onPlayerChat", root, onPlayerChat);
