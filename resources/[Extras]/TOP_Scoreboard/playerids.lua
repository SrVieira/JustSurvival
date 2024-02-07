local playerid = { }

function newPlayerID( player )
	for i = 1, getMaxPlayers( ) do
		if not ( playerid[ i ] ) then
			playerid[ i ] = player
			setElementData( player, "playerID", i )
			break
		end
	end
end

function getPlayerByID( id )
	for i = 1, getMaxPlayers( ) do
		if ( playerid[ i ] ) then
			return playerid[ i ]
		end
	end
end

addEventHandler( "onPlayerQuit", root,
	function( )
		for i = 1, getMaxPlayers( ) do
			if ( playerid[ i ] == source ) then
				playerid[ i ] = nil
				break
			end
		end
	end
)

addEventHandler( "onPlayerJoin", root, 
	function( ) 
		newPlayerID( source ) 
	end 
)

addEventHandler( "onResourceStart", resourceRoot, 
	function( ) 
		local players = getElementsByType( "player" ) 
		for i = 1, #players do 
			newPlayerID( players[ i ] ) 
		end 
	end 
)