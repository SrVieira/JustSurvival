local concat = table.concat;

function globalMessage(thePlayer, cmd, ...) 
    local message = concat( { ... }, " " );
    local name = getPlayerName(thePlayer);
    outputChatBox("(GLOBAL) "..name..": "..message, getRootElement(), 255, 255, 255, true);
end
addCommandHandler("GlobalChat", globalMessage);
