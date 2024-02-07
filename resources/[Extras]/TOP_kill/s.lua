local secs = {}
addCommandHandler("kill",
	function(p)
		if not getElementData(p, "Logeado") then return end
		if getElementData(p, "dead") then return end
		
		local mysecs = getRealTime().timestamp
		local k = false
		
		if not secs[p] then
			secs[p] = mysecs + 60
			k = true
		else
			local r = secs[p] - mysecs
			if (r <= 0) then
				secs[p] = nil
				k = true
			else
				outputChatBox("* Tienes que esperar "..r.." segundos para usar este comando.", p, 255, 0, 0)
			end
		end
		
		if k == true then
			setElementData(p, "blood", 0)
			outputDebugString(getPlayerName(p):gsub("#%x%x%x%x%x%x", "") .. " has been killed himself!")
		end
	end
)

addEventHandler("onPlayerQuit", root,
	function()
		secs[source] = nil
	end
)

--- PENDIENTE
addEventHandler("onVehicleExplode", root,
	function()
		for _, ocupant in ipairs(getVehicleOccupants(source) or {}) do
			if isElement(ocupant) then
				setElementData(ocupant, "blood", 0)
			end
		end
	end
)