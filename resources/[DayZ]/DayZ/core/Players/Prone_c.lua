local prone = {
	state = false, ped = nil, isRender = false, pressed = nil, tick = nil,
}

function setProneControls(b)
	if (b) then
		bindKey("W", "both", moveProne, "forwards")
		bindKey("S", "both", moveProne, "backwards")
		bindKey("A", "both", moveProne, "left")
		bindKey("D", "both", moveProne, "right")
	else
		unbindKey("W", "both", moveProne)
		unbindKey("S", "both", moveProne)
		unbindKey("A", "both", moveProne)
		unbindKey("D", "both", moveProne)
	end
end

function moveProne(_, s, k)
	if isCursorShowing() then return end
	local rs = (s == "down" and true) or false

	setPedControlState(prone.ped, "walk", true)
	setPedControlState(prone.ped, k, rs)

	if (rs) then
		prone.pressed = k
	else
		prone.pressed = nil
	end
end

function switchProne(state)
	prone.state = state
	if (prone.state) then
		if not prone.isRender then
			local x, y, z = getElementPosition(localPlayer)
			local rX, rY, rZ = getElementRotation(localPlayer)
			prone.ped = createPed(0, x, y, z, rZ)
			setElementAlpha(prone.ped, 0)
			attachElements(localPlayer, prone.ped, 0, 0, 0)
			setElementCollidableWith(localPlayer, prone.ped, false)
			setPedAnimation(localPlayer, "ped", "FLOOR_hit_f", -1, false, true, false)
			addEventHandler("onClientPreRender", root, checkProneState)
			addEventHandler("onClientRender", root, setPlayerLookAt)
			prone.tick = getTickCount()
			setProneControls(true)
			prone.isRender = true
		end	
	else
		if prone.isRender then
			if isElement(prone.ped) then 
				destroyElement(prone.ped) 
				prone.ped = nil
			end
			
			setPedAnimation(localPlayer, "ped", "getup_front", -1, false, true, false)
			removeEventHandler("onClientPreRender", root, checkProneState)
			removeEventHandler("onClientRender", root, setPlayerLookAt)
			prone.isRender = false
			setProneControls(false)
		end
	end
	
	setElementData(localPlayer, "prone", state)
end
addEvent("onPlayerProne", true)
addEventHandler("onPlayerProne", root, switchProne)

function setPlayerLookAt()
	if not getElementData(localPlayer, "dead") then
		local rotation = 360 - getPedCameraRotation(localPlayer)
		setElementRotation(localPlayer, 0, 0, rotation)
	end
end

function checkProneState()
	if not getElementData(localPlayer, "dead") then
		local rotation = getPedCameraRotation(localPlayer)
		local x, y, z = getElementPosition(localPlayer)
		local block, anim = getPedAnimation(localPlayer)
		if block == "ped" and anim == "FLOOR_hit_f" then
			if not isElementInWater(localPlayer) then
				if isPedOnGround(localPlayer) then
					if prone.pressed and prone.pressed == "left" then
						rotation = rotation - 90
					elseif prone.pressed and prone.pressed == "right" then
						rotation = rotation + 90
					elseif prone.pressed and prone.pressed == "backwards" then
						rotation = rotation + 180
					end
					
					setElementRotation(prone.ped, 0, 0, rotation)
					prone.tick = getTickCount()
				else
					if (getTickCount() > prone.tick + 500) then
						prone.tick = getTickCount()
						removeProne()
					end
				end
			else
				removeProne()
			end
		else
			removeProne()
		end
	end
end

function removePronePedDamage()
	if isElement(prone.ped) and source == prone.ped then
		cancelEvent()
	end
end
addEventHandler("onClientPedDamage", root, removePronePedDamage)

function removeProne()
	if isElement(prone.ped) then 
		destroyElement(prone.ped)
		prone.ped = nil
	end
	
	if prone.isRender then
		removeEventHandler("onClientPreRender", root, checkProneState)
		removeEventHandler("onClientRender", root, setPlayerLookAt)
		prone.isRender = false
	end
	
	triggerServerEvent("onPlayerRemoveProne", localPlayer)
	setElementData(localPlayer, "prone", false)
	setPedAnimation(localPlayer)
	setProneControls(false)
end

addEventHandler("onClientPlayerDamage",localPlayer,
function()
	if prone.isRender then
		removeProne()
	end
end)

addEventHandler("onClientPlayerWasted",localPlayer,
function()
	if prone.isRender then
		removeProne()
	end
end)