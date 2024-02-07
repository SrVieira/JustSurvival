function adminchat ( thePlayer, _, ... )
    local message = table.concat ( { ... }, " " )
    if ( isPlayerOnGroup ( thePlayer ) ) then
        for _, player in ipairs ( getElementsByType ( "player" ) ) do
            if ( isPlayerOnGroup ( player ) ) then
                outputChatBox ( "#7CC576[AdminChat]#FFFFFF ".. getPlayerName ( thePlayer ) ..": ".. message, player, 255, 255, 255, true )
            end
        end
    else
        outputChatBox ( "#FFFFFF no eres Admin!", thePlayer, 255, 255, 255, true )
    end
end
addCommandHandler ( "a", adminchat )
 
function isPlayerOnGroup ( thePlayer )
    local account = getPlayerAccount ( thePlayer )
    local inGroup = false
    for _, group in ipairs ( { "Console", "Admin", "SuperModerator", "Moderator", "HELP", "antihack" } ) do  
        if isObjectInACLGroup ( "user.".. getAccountName ( account ), aclGetGroup ( group ) )   then
            inGroup = true
            break
        end
    end
 
    return inGroup
end