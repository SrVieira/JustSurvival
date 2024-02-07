local lossCount = {}
local maxLossCount = 6

if gameplayVariables["PingKicker"] then
	setTimer(function()
		for _, player in ipairs(getElementsByType("player")) do
			if isElement(player) and getElementData(player, "Logeado") then
				if not lossCount[player] then
					lossCount[player] = 0
				end
				if not hasObjectPermissionTo(player, "command.srun") then
					local ping = getPlayerPing(player)
					if ping > gameplayVariables["MAX_Ping"] then
						lossCount[player] = lossCount[player] + 1
						if lossCount[player] == maxLossCount then
							kickPlayer(player, "[DayZ] Reduce tu ping. ["..ping.."/"..gameplayVariables["MAX_Ping"].."]")
							lossCount[player] = nil
						else
							outputChatBox("** Baja tu ping o seras expulsado. ("..ping.."/"..gameplayVariables["MAX_Ping"]..") **", player, 255, 0, 0)
						end
					else
						lossCount[player] = 0
					end
				end
			end
		end
	end, 5000, 0)
end

function antiRelogEffect()
	if isElement(source) and getElementData(source, "combat") then
		if getElementData(source, "Logeado") then
			local account = getPlayerAccount(source)
			setAccountData(account, "blood", -1)
		end
	
		local serial = getPlayerSerial(source)
		addBan(nil, nil, tostring(serial), root, "[DayZ-AntiRelog] Evade attempt / Intento de evadir", gameplayVariables["banTime_Antirelog"])
	end

	if lossCount[source] then
		lossCount[source] = nil
	end
end
addEventHandler("onPlayerQuit", root, antiRelogEffect)