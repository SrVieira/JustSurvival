local prone = {}
local sit = {}
local salute = {}
local handsUp = {}
local danding = {}

function keyBoundActions()
	for _, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "Logged") then
			bindActions(player)
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, keyBoundActions)

function keyBoundActionsOnStartGame()
	bindActions(source)
end
addEvent("onPlayerDayZSpawn", true)
addEventHandler("onPlayerDayZSpawn", root, keyBoundActionsOnStartGame)

function bindActions(player)
	sit[player] = false
	salute[player] = false
	handsUp[player] = false
	prone[player] = false
	danding[player] = false

	bindKey(player, "7", "down", playerSit)
	bindKey(player, "8", "down", playerHandsUp)
	bindKey(player, "9", "down", playerSalute)
	bindKey(player, "0", "down", playerDance)
	bindKey(player, "M", "down", playerProne)
end

function playerDance(player)
	if not isPedOnGround(player) then return end
	if getPedOccupiedVehicle(player) then return end

	if danding[player] then
		setPedAnimation(player)
		danding[player] = false
	else
		setPedAnimation(player, "DANCING", "DAN_Left_A", -1, true)
		danding[player] = true
	end
	
	triggerClientEvent(player, "onPlayerProne", player, false) -- Resetear el prone al hacer otra animacion.
end

function playerSit(player)
	if not isPedOnGround(player) then return end
	if getPedOccupiedVehicle(player) then return end

	if sit[player] then
		setPedAnimation(player)
		sit[player] = false
	else
		setPedAnimation(player, "BEACH", "ParkSit_M_loop", -1, false)
		sit[player] = true
	end
	
	triggerClientEvent(player, "onPlayerProne", player, false) -- Resetear el prone al hacer otra animacion.
end

function playerHandsUp(player)
	if not isPedOnGround(player) then return end
	if getPedOccupiedVehicle(player) then return end

	if handsUp[player] then
		setPedAnimation(player)
		handsUp[player] = false
	else
		setPedAnimation(player, "SHOP", "SHP_Rob_HandsUp", -1, false)
		handsUp[player] = true
	end	
	
	triggerClientEvent(player, "onPlayerProne", player, false) -- Resetear el prone al hacer otra animacion.
end

function playerSalute(player)
	if not isPedOnGround(player) then return end
	if getPedOccupiedVehicle(player) then return end

	if salute[player] then
		setPedAnimation(player)
		salute[player] = false
	else
		setPedAnimation(player, "GHANDS", "gsign5LH", -1, false)
		salute[player] = true
		setTimer(function(player) 
			triggerClientEvent(player, "onPlayerProne", player, false) -- Resetear el prone al hacer otra animacion.
			setPedAnimation(player)
			salute[player] = false
		end, 2000, 1, player)
	end
	
	triggerClientEvent(player, "onPlayerProne", player, false) -- Resetear el prone al hacer otra animacion.
end

function playerProne(player)
	if not isPedOnGround(player) then return end
	if getPedOccupiedVehicle(player) then return end

	if prone[player] then
		setPedAnimation(player, "ped", "getup_front", -1, false, true, false)
		setTimer(function(player) 
			triggerClientEvent(player, "onPlayerProne", player, false) -- Resetear el prone al hacer otra animacion.
			setPedAnimation(player) 
		end, 1500, 1, player)
		prone[player] = false
	else
		setPedAnimation(player, "ped", "FLOOR_hit_f", -1, false, true, false)
		prone[player] = true
	end

	triggerClientEvent(player, "onPlayerProne", player, prone[player])
end

function removeProneInCases()
	setPedAnimation(source) 
	prone[source] = false
end
addEvent("onPlayerRemoveProne", true)
addEventHandler("onPlayerRemoveProne", root, removeProneInCases)

function clearAnimationsPlayer()
	sit[source] = nil
	salute[source] = nil
	handsUp[source] = nil
	prone[source] = nil
end
addEventHandler("onPlayerQuit", root, clearAnimationsPlayer)