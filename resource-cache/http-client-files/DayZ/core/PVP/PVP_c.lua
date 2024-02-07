local isRelogEventHandled = false
local stopCounter = false

function startAntiRelog(attacker, weapon)
	if isElement(attacker) and getElementType(attacker) == "player" and attacker ~= source and weapon ~= 0 then
		if not isRelogEventHandled then
			stopCounter = getRealTime().timestamp + gameplayVariables["banTime_duration"]
			setElementData(localPlayer, "combat", true)
			isRelogEventHandled = true
			addEventHandler("onClientRender", root, drawAntiRelogCounter)
		end
	end
end
addEventHandler("onClientPlayerDamage", localPlayer, startAntiRelog)

function rejectAntirelog(attacker, weapon)
	if getElementData(localPlayer, "combat") then
		removeEventHandler("onClientRender", root, drawAntiRelogCounter)
		setElementData(localPlayer, "combat", false)
		isRelogEventHandled = false	
	end
end
addEventHandler("onClientPlayerWasted", localPlayer, rejectAntirelog)

function drawAntiRelogCounter()
	local now = getRealTime().timestamp
	local remaining = stopCounter - now
	local sx, sy = guiGetScreenSize()

	if remaining <= 0 then
		removeEventHandler("onClientRender", root, drawAntiRelogCounter)
		setElementData(localPlayer, "combat", false)
		isRelogEventHandled = false
	end
	
	dxDrawText("Anti-Relog: "..tostring(remaining).."\n ¡No abandones el servidor!", 0, sy * 0.078125, sx, sy * 0.078125, tocolor(255, 0, 0, 255), 1.00, "default-bold", "center", "center")
end