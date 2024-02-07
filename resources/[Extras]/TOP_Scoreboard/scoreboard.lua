local screenW, screenH = guiGetScreenSize()

scoreboard = {}
scoreboard.columns = {}
scoreboard.sortedPlayers = {}
scoreboard.boxSizes = {0, 0}

scoreboard.messageBottom = " "
scoreboard.serverName = "MTA:DayZ - Server"

scoreboard.maxPlayers = 100
scoreboard.currentPlayers = 0
scoreboard.maxColumnWitdh = 200
scoreboard.columnHeight = 25
scoreboard.minRows = 20
scoreboard.rolling = 0

scoreboard.visible = false

scoreboard.x = screenW/2
scoreboard.y = screenH/2

scoreboard.lineColor = {50, 50, 50, 222}
scoreboard.columnColor = {200, 200, 200, 222}
scoreboard.serverInfoColor = {255, 255, 255, 222}

function sortPlayers()
	-- We sort local player first.
	table.insert(scoreboard.sortedPlayers, localPlayer)

	-- Now the other players.
	for _, player in ipairs(getElementsByType("player")) do
		if player ~= localPlayer then
			table.insert(scoreboard.sortedPlayers, player)
		end
	end
end

function drawScoreboard()
	-- Background.
	dxDrawBorderedRectangle(scoreboard.x - scoreboard.boxSizes[1] / 2, scoreboard.y, scoreboard.boxSizes[1], scoreboard.boxSizes[2], 1, {0, 0, 0, 150}, false)
	-- Server info.
	dxDrawBorderedRectangle(scoreboard.x - scoreboard.boxSizes[1] / 2, scoreboard.y - scoreboard.columnHeight, scoreboard.boxSizes[1], scoreboard.columnHeight, 1, {0, 0, 0, 255}, false)
	dxDrawText(scoreboard.serverName, scoreboard.x - (scoreboard.boxSizes[1] / 2) + 5, scoreboard.y - scoreboard.columnHeight, scoreboard.x - (scoreboard.boxSizes[1] / 2) + scoreboard.boxSizes[1], scoreboard.y, tocolor(unpack(scoreboard.serverInfoColor)), 1, "arial", "left", "center", true)
	-- Bottom message.
	dxDrawText(scoreboard.messageBottom, scoreboard.x - (scoreboard.boxSizes[1] / 2), scoreboard.y + scoreboard.boxSizes[2], scoreboard.x - (scoreboard.boxSizes[1] / 2) + scoreboard.boxSizes[1], scoreboard.y + scoreboard.boxSizes[2] + 20, tocolor(222, 222, 222, 255), 1, "default-bold", "center", "center", true)
	-- Player's count.
	dxDrawText("Jugadores: "..tostring(#getElementsByType("player")).."/"..tostring(scoreboard.maxPlayers), scoreboard.x - (scoreboard.boxSizes[1] / 2) + 5, scoreboard.y - scoreboard.columnHeight, scoreboard.x - (scoreboard.boxSizes[1] / 2) + scoreboard.boxSizes[1] - 5, scoreboard.y, tocolor(unpack(scoreboard.serverInfoColor)), 1, "arial", "right", "center", true)
	-- Columns line bottom.
	dxDrawLine(scoreboard.x - (scoreboard.boxSizes[1] / 2), scoreboard.y + scoreboard.columnHeight, scoreboard.x - (scoreboard.boxSizes[1] / 2) + scoreboard.boxSizes[1], scoreboard.y + scoreboard.columnHeight, tocolor(unpack(scoreboard.lineColor)), 1, false)
	
	-- Draw local player selection.
	if scoreboard.rolling == 0 then
		dxDrawRectangle(scoreboard.x - scoreboard.boxSizes[1] / 2, scoreboard.y + scoreboard.columnHeight, scoreboard.boxSizes[1], scoreboard.columnHeight, tocolor(100, 100, 100, 100), false)
	end
	
	-- Draw our columns. 
	local sepx = 0

	for k, v in ipairs(scoreboard.columns) do
		local width = v[2] * scoreboard.maxColumnWitdh

		if v[3] == "playerID" then
			--dxDrawRectangle(scoreboard.x - (scoreboard.boxSizes[1] / 2), scoreboard.y, width, scoreboard.boxSizes[2], tocolor(0, 0, 0, 255), false)
		end
		
		dxDrawText(v[1], scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + 1, scoreboard.y + 1, scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + width + 1, scoreboard.y + scoreboard.columnHeight + 1, tocolor(0, 0, 0, 222), 1, "default-bold", "center", "center", true)
		dxDrawText(v[1], scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx, scoreboard.y, scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + width, scoreboard.y + scoreboard.columnHeight, tocolor(unpack(scoreboard.columnColor)), 1, "default-bold", "center", "center", true)

		-- Draw rows.
		local yOff = 0
		local alignx = "center"
		local isLogged = getElementData(localPlayer, "Logeado")
		
		for i = 1+scoreboard.rolling, scoreboard.minRows+scoreboard.rolling do
			local p = scoreboard.sortedPlayers[i]
			
			if p then
				local valueRow = (getElementData(p, v[3]) or '0')
				local color = tocolor(255, 255, 255, 222)
				
				if not isLogged then
					color = tocolor(255, 255, 255, 100)
				end
				
				if v[3] == "Name" then
					local playerName = getPlayerName(p)
					alignx = "left"
					dxDrawText(tostring(playerName):gsub("#%x%x%x%x%x%x", ""), scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + 6, yOff + scoreboard.y + scoreboard.columnHeight + 1, scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + width + 1, scoreboard.columnHeight + scoreboard.y + yOff + scoreboard.columnHeight + 1, tocolor(0, 0, 0, 222), 1, "default-bold", alignx, "center", true, false, false, false, false)
					dxDrawText(tostring(playerName), scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + 5, yOff + scoreboard.y + scoreboard.columnHeight, scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + width, scoreboard.columnHeight + scoreboard.y + yOff + scoreboard.columnHeight, color, 1, "default-bold", alignx, "center", true, false, false, true, false)
				elseif v[3] == "Alivetime" then
					if isLogged then
						local days = getElementData(p, "daysalive") or 0
						local hours = getElementData(p, "hoursalive") or 0
						local formatt = getElementData(p, 'alivetime').. ' mins.'
						dxDrawText(tostring(formatt):gsub("#%x%x%x%x%x%x", ""), scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + 6, yOff + scoreboard.y + scoreboard.columnHeight + 1, scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + width + 1, scoreboard.columnHeight + scoreboard.y + yOff + scoreboard.columnHeight + 1, tocolor(0, 0, 0, 222), 1, "default-bold", alignx, "center", true, false, false, false, false)
						dxDrawText(tostring(formatt), scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + 5, yOff + scoreboard.y + scoreboard.columnHeight, scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + width, scoreboard.columnHeight + scoreboard.y + yOff + scoreboard.columnHeight, color, 1, "default-bold", alignx, "center", true, false, false, true, false)
					end
				elseif v[3] == "Ping" then
					local playerPing = getPlayerPing(p)
					dxDrawText(tostring(playerPing):gsub("#%x%x%x%x%x%x", ""), scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + 6, yOff + scoreboard.y + scoreboard.columnHeight + 1, scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + width + 1, scoreboard.columnHeight + scoreboard.y + yOff + scoreboard.columnHeight + 1, tocolor(0, 0, 0, 222), 1, "default-bold", alignx, "center", true, false, false, false, false)
					dxDrawText(tostring(playerPing), scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + 5, yOff + scoreboard.y + scoreboard.columnHeight, scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + width, scoreboard.columnHeight + scoreboard.y + yOff + scoreboard.columnHeight, tocolor(math.min((255 * playerPing / 800), 255), 255 - math.min((255 * playerPing / 800), 255), 0, 222), 1, "default-bold", alignx, "center", true, false, false, true, false)
				elseif v[3] == "playerID" then
					local playerID = getElementData(p, "playerID") or false
					dxDrawText(tostring(playerID):gsub("#%x%x%x%x%x%x", ""), scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + 6, yOff + scoreboard.y + scoreboard.columnHeight + 1, scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + width + 1, scoreboard.columnHeight + scoreboard.y + yOff + scoreboard.columnHeight + 1, tocolor(0, 0, 0, 222), 1, "default-bold", alignx, "center", true, false, false, true, false)
					dxDrawText(tostring(playerID), scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + 5, yOff + scoreboard.y + scoreboard.columnHeight, scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + width, scoreboard.columnHeight + scoreboard.y + yOff + scoreboard.columnHeight, color, 1, "default-bold", alignx, "center", true, false, false, true, false)
				else
					if isLogged then
						dxDrawText(tostring(valueRow):gsub("#%x%x%x%x%x%x", ""), scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + 6, yOff + scoreboard.y + scoreboard.columnHeight + 1, scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + width + 1, scoreboard.columnHeight + scoreboard.y + yOff + scoreboard.columnHeight + 1, tocolor(0, 0, 0, 222), 1, "default-bold", alignx, "center", true, false, false, false, false)
						dxDrawText(tostring(valueRow), scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + 5, yOff + scoreboard.y + scoreboard.columnHeight, scoreboard.x - (scoreboard.boxSizes[1] / 2) + sepx + width, scoreboard.columnHeight + scoreboard.y + yOff + scoreboard.columnHeight, color, 1, "default-bold", alignx, "center", true, false, false, true, false)
					end
				end			

				yOff = yOff + scoreboard.columnHeight
			end
		end

		sepx = sepx + width
	end
	
	if getKeyState("mouse2") then
		showCursor(true)
	else
		showCursor(false)
	end
end

function scoreboardRolling(key, state, s)
	if --[[state == "down" and]] scoreboard.visible and isCursorShowing() and #scoreboard.sortedPlayers > scoreboard.minRows then
		if key == "mouse_wheel_up" then
			if (scoreboard.rolling > 0) then
				scoreboard.rolling = scoreboard.rolling - 1
			end
		else
			if (scoreboard.rolling + scoreboard.minRows < #scoreboard.sortedPlayers) then
				scoreboard.rolling = scoreboard.rolling + 1
			end
		end
	end
end
bindKey("mouse_wheel_down", "down", scoreboardRolling)
bindKey("mouse_wheel_up", "down", scoreboardRolling)


function addColumn(name, size, columnid)
	for _, cD in ipairs(scoreboard.columns) do
		if cD[1] == name then
			return
		end
	end

	table.insert(scoreboard.columns, {name, size, columnid})

	local boxWidth = 0

	for index = 1, #scoreboard.columns do
		local width = scoreboard.columns[index][2] * scoreboard.maxColumnWitdh
		boxWidth = boxWidth + width
	end
	
	scoreboard.boxSizes[1] = boxWidth
end

function updateScrollboardHeight()
	local newHeight = 0
	for count, _ in ipairs(scoreboard.sortedPlayers) do
		if (count <= scoreboard.minRows) then
			newHeight = newHeight + scoreboard.columnHeight
		end
	end
	scoreboard.boxSizes[2] = newHeight + scoreboard.columnHeight
	scoreboard.y = screenH/2 - scoreboard.boxSizes[2] / 2
end

function updateServerInfo(data)
	scoreboard.serverName = data.serverName
	scoreboard.maxPlayers = data.maxPlayers
end
addEvent("onScoreboardSendServerInfo", true)
addEventHandler("onScoreboardSendServerInfo", root, updateServerInfo)

function setScoreboardStatus(key, keyState)
	if not getElementData(localPlayer, "Logeado") then return end
	if keyState == "down" then
		scoreboard.visible = true
		updateScrollboardHeight()
		addEventHandler("onClientRender", root, drawScoreboard)
	else
		if isCursorShowing() then
			showCursor(false)
		end
		scoreboard.visible = false
		removeEventHandler("onClientRender", root, drawScoreboard)
	end
end
bindKey("TAB", "both", setScoreboardStatus)

function addNewPlayerIntoScoreboard()
	table.insert(scoreboard.sortedPlayers, source)
	updateScrollboardHeight()
end
addEventHandler("onClientPlayerJoin", root, addNewPlayerIntoScoreboard)

function removeNewPlayerIntoScoreboard()
	for k, p in ipairs(scoreboard.sortedPlayers) do
		if p == source then
			if scoreboard.rolling > 0 then
				scoreboard.rolling = scoreboard.rolling - 1
			end

			table.remove(scoreboard.sortedPlayers, k)
			updateScrollboardHeight()
			break
		end
	end
end
addEventHandler("onClientPlayerQuit", root, removeNewPlayerIntoScoreboard)
function getServerInform()
	 -- We sorts the whole server's player
	sortPlayers()
	-- Put default columns.
	addColumn("Jugadores", 0.9, "Name")
	addColumn("Nivel", 0.4, "level")
	addColumn("Asesinatos", 0.5, "murders")
	addColumn("Muertes", 0.5, "deaths")
	addColumn("Tiempo vivo", 0.6, "Alivetime")
	addColumn("Headshots", 0.6, "headshots")
	addColumn("Ping", 0.4, "Ping")
	-- Request server information.
	triggerServerEvent("onScoreboardGetServerInfo", localPlayer)
end
addEventHandler("onClientResourceStart", resourceRoot, getServerInform)