local scX, scY = guiGetScreenSize()

local fading = 0
local fadingBool = true

local headTick = false
local headCount = 0
local headshot = {}

local mps = 0
local playerSpeed = 0
local playerHunger = 0
local playerThirst = 0

local deadLabelFont = guiCreateFont("fonts/teko_medium.ttf", 28)
local deadLabelFont2 = guiCreateFont("fonts/teko_medium.ttf", 22)

local startCount = 6
local spawnLabel = {}
local spawnsLabel = false
local spawnLabelFont = guiCreateFont("fonts/teko_medium.ttf", 0.05 * scY)

local spawnpointName = {
	"Los Santos","Las Venturas","Bone County","Whetstone",
	"Tierra Robada","San Fierro","Flint County","Red County",
}

addEventHandler("onClientPlayerStealthKill", root, 
	function ()
		cancelEvent()
	end
)

function setPedAnimationTooFar()
	for _, v in ipairs(getElementsByType("ped", resourceRoot)) do
		local lastAnim = getElementData(v, "anim")
		if lastAnim then
			local b, a = getPedAnimation(v)
			if a == nil then
				setPedAnimation(v, lastAnim[1], lastAnim[2], -1, false, true, false)
			end
		end
	end
end
setTimer(setPedAnimationTooFar, 1000, 0)

function onPlayerGetHurt(killer, weapon, bodypart, loss)
	cancelEvent()

	if not getElementData(source, "dead") then
		local playerWeapon = false
		local isHeadshot = false
		local value = 200
		
		if weapon == 51 or weapon == 19 or weapon == 59 or weapon == 63 or weapon == 16 then -- Daño por explosion.
			value = 12001
		elseif isElement(killer) and getElementType(killer) == "vehicle" then -- Daño por vehiculo.
			if loss >= 30 then
				value = 12001
			end
		elseif weapon == 53 then -- Daño por ahogamiento.
			value = gameplayVariables["waterdamage"]
		elseif weapon == 50 then -- Daño por helices de helicopteros.
			killer = getVehicleController(getPedOccupiedVehicle(killer))
			value = 12001
		elseif weapon == 54 then -- Daño por caida.
			if loss > 25 and loss < 45 then
				setElementData(source, "bleeding", math.random(50, 150))
				setElementData(source, "brokenbone", 1)
				setElementData(source, "pain", 1)
				playSound("sounds/effects/brokenbone.mp3")
				value = 600				
			elseif loss >= 45 then
				value = 12001
			end
		else	
			if isElement(killer) then				
				if killer ~= source then
					if getElementData(killer, "zombie") then
						local protection_chance = 50
						
						value = gameplayVariables["ZombieDamage"]
						
						if getElementData(source, "kevlar") then 
							value = value / 2
							protection_chance = 15
						end

						if (math.random(0, 200) / 2) < protection_chance then 
							setElementData(source, "infection", 1) 
						end
					elseif getElementData(killer, "zombie") then
						value = math.random(300, 3000)
						
						if getElementData(source, "kevlar") then 
							value = value / 2
						end
					else
						playerWeapon = getPlayerCurrentWeapon(killer)
						
						if playerWeapon and getWeaponDamage(killer, getPedWeapon(killer)) then
							local x1, y1, z1 = getElementPosition(killer)
							local x2, y2, z2 = getElementPosition(source)
							local damage = getWeaponDamage(killer, getPedWeapon(killer))
							value = damage
											
							if bodypart == 9 then -- Daño en disparo en la cabeza.
								local hasHelmet = getElementData(source, "helmet")
								if hasHelmet then
									if not headTick then
										headTick = getTickCount()
									end
									
									value = 0
									
									if (getTickCount() < headTick + 3000) then
										headCount = headCount + 1
										if (headCount == 2) then
											headTick = getTickCount()
											headCount = 0
											value = 12001
											isHeadshot = true
										end
									else
										headTick = getTickCount()
										headCount = 1
									end
								else
									value = 12001
									isHeadshot = true
								end
							elseif bodypart == 3 then -- Daño en disparo en pecho.
								local hasKevlar = getElementData(source, "kevlar")
								if hasKevlar then
									value = value / 2
								else
									setElementData(source, "bleeding", math.random(100, 300))
									setElementData(source, "pain", 1)
								end
							else -- Daño en las demas partes del cuerpo.
								setElementData(source, "bleeding", math.random(100, 300))
								setElementData(source, "pain", 1)
								
								if bodypart == 7 or bodypart == 8 then -- Daño por disparo en las piernas.
									setElementData(source, "brokenbone", 1)
									playSound("sounds/effects/brokenbone.mp3")
								end							
							end
						end
					end
				end
			end
		end

		setElementData(source, "blood", getElementData(source, "blood") - value)
		triggerEvent("onClientDayZPlayerDamage", source, killer, playerWeapon, isHeadshot, value, bodypart)
		
		if (getElementData(source, "blood") <= 0) then
			killThePlayer(killer, isHeadshot, playerWeapon, bodypart)
		end
	end
end
addEventHandler("onClientPlayerDamage", localPlayer, onPlayerGetHurt)

function killThePlayer(killer, headshot, weapon, bodypart)
	local cx, cy, cz, crx, cry, crz = getCameraMatrix()
	
	showChat(false)
	showDeadScreen()
	setElementData(localPlayer, "dead", true)	
	setElementData(localPlayer, "blood", 0)
	setCameraMatrix(cx, cy, cz, crx, cry, crz + 500)
	triggerServerEvent("onPlayerDayZWasted", localPlayer, killer, headshot, weapon, bodypart)
end

function destroySpawnLabel()
	if (#spawnLabel > 0) then
		for index = 1, #spawnLabel do
			local box = getElementData(spawnLabel[index], "backgroundBox")
			if isElement(box) then
				destroyBlurBox(box)
			end
			destroyElement(spawnLabel[index])
		end
		spawnLabel = {}
		spawnsLabel = false
	end
end

function initSpawnLabel()
	if spawnsLabel then return end

	local Oy = 0.15
	local Ox = 0
	local sW, sH = (scX/4)/scX, (scY/2)/scY - Oy
	
	destroySpawnLabel()
	
	spawnLabel[#spawnpointName+1] = guiCreateLabel(0, 0.05, 1.0, 0.15, "SELECCIONA UN LUGAR PARA COMENZAR", true, false)
	setElementData(spawnLabel[#spawnpointName+1], "backgroundBox", createBlurBox(0, 0, scX, scY, 100, 100, 100, 255, false), false)
	
	for index, city in ipairs(spawnpointName) do
		spawnLabel[index] = guiCreateLabel(Ox, Oy, sW, sH, city, true, false)
		Ox = Ox + sW
		if index % 4 == 0 then
			Ox = 0
			Oy = Oy + sH
		end		
	end
	
	for index = 1, #spawnLabel do
		if (index ~= #spawnLabel) then
			addEventHandler("onClientGUIClick", spawnLabel[index], selectSpawnLabel, false)
			addEventHandler("onClientMouseEnter", spawnLabel[index], function() guiLabelSetColor(source, 255, 0, 0) end, false)
			addEventHandler("onClientMouseLeave", spawnLabel[index], function() guiLabelSetColor(source, 255, 255, 255) end, false)
		end
		guiSetFont(spawnLabel[index], spawnLabelFont)
        guiLabelSetHorizontalAlign(spawnLabel[index], "center", false)
        guiLabelSetVerticalAlign(spawnLabel[index], "center")    
	end
	
	spawnsLabel = true
	showCursor(true)
end

function selectSpawnLabel()
	local city = guiGetText(source)
	triggerServerEvent("onPlayerDayZSelectSpawnpoint", localPlayer, city)
	destroySpawnLabel()
	showCursor(false)
end

function showDeadScreen()
	if not deadLabel then
		deadLabel = guiCreateLabel(0.01, 0.01, 0.98, 0.97, "ESTAS MUERTO", true)
		guiSetFont(deadLabel, deadLabelFont)
		guiLabelSetHorizontalAlign(deadLabel, "center", true)
		guiLabelSetVerticalAlign(deadLabel, "center")   
		guiSetProperty(deadLabel, "Disabled", "True")
		guiLabelSetColor(deadLabel, 255, 0, 0)
		deadLabel2 = guiCreateLabel(0.01, 0.07, 0.98, 0.97, "Reapareceras en "..startCount, true)
		guiSetFont(deadLabel2, deadLabelFont2)
		guiLabelSetHorizontalAlign(deadLabel2, "center", true)
		guiLabelSetVerticalAlign(deadLabel2, "center")   
		guiSetProperty(deadLabel2, "Disabled", "True")
		guiLabelSetColor(deadLabel2, 255, 0, 0)
	end
	fadeCamera(false, 0.1)
	setTimer(function()
		if isElement(deadLabel) and isElement(deadLabel2)then
			startCount = startCount - 1
			guiSetText(deadLabel2, "Reapareceras en "..startCount)
			if startCount == 0 then
				initSpawnLabel()
				guiSetText(deadLabel, "")
				guiSetText(deadLabel2, "")
				guiLabelSetColor(deadLabel, 255, 255, 255)
				guiLabelSetColor(deadLabel2, 255, 255, 255)
				fadeCamera(true, 0.1)
			end
		end
	end, 1000, startCount)
end
addEvent("onPlayerDeadScreenShow", true)
addEventHandler("onPlayerDeadScreenShow", root, showDeadScreen)

function hideDeadScreen()
	if isElement(deadLabel) and isElement(deadLabel2) then
		destroyElement(deadLabel)
		destroyElement(deadLabel2)
		deadLabel = nil
		deadLabel2 = nil
	end
	showChat(true)
	fadeCamera(true, 0.1)
	startCount = 6
end
addEvent("onPlayerDeadScreenHide", true)
addEventHandler("onPlayerDeadScreenHide", root, hideDeadScreen)

function drawPainEffect()
	local sx, sy = guiGetScreenSize()
	if not getElementData(localPlayer, "dead") then
		if getElementData(localPlayer, "pain") and math.floor(getElementData(localPlayer, "pain")) > 0 then
			if fadingBool == true then
				fading = fading + 1
				if fading == 150 then
					fadingBool = false
				end
			elseif fadingBool == false then
				fading = fading - 1
				if fading == 0 then
					fadingBool = true
				end
			end
			
			dxDrawRectangle(0, 0, sx, sy, tocolor(120, 0, 0, fading), false)
		end
	end
end
addEventHandler("onClientRender", root, drawPainEffect)

function onPlayerStatus()
	if getElementData(localPlayer, "Logged") then		
		if not getElementData(localPlayer, "dead") then		
			if (getElementHealth(localPlayer) == 0) then
				setElementData(localPlayer, "blood", 0)
			end
			
			if (getElementData(localPlayer, "blood") and math.floor(getElementData(localPlayer, "blood")) <= 0) then
				killThePlayer(nil, false, nil, 3)
			end
			
			--# Brokenbone.
			if (getElementData(localPlayer, "brokenbone") and getElementData(localPlayer, "brokenbone") > 0) then
				toggleControl("jump", false)
				toggleControl("sprint", false)
			else
				toggleControl("jump", true)
				toggleControl("sprint", true)
			end

			--# Bleeding.
			local x, y, z = getElementPosition(localPlayer)
			local bleeding = getElementData(localPlayer,"bleeding") or 0
			if (bleeding > 0) then
				local px, py, pz = getPedBonePosition(localPlayer,3)
				local pdistance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
				
				if (pdistance <= 120) then
					fxAddBlood (px, py, pz,0, 0, 0, 10, 1)
				end
				
				setElementData(localPlayer,"blood",getElementData(localPlayer,"blood") - (bleeding * 0.5))
				
				if (getElementData(localPlayer,"blood") <= 0) then
					setElementData(localPlayer,"blood", 0)
				end			
			end
			
			--# Volume
			local value = 0
			if getPedMoveState (localPlayer) == "stand" then
				value = 0
			elseif getPedMoveState (localPlayer) == "crouch" then	
				value = 0
			elseif getPedMoveState(localPlayer) == "crawl" then
				value = 20
			elseif getPedMoveState (localPlayer) == "walk" then
				value = 40
			elseif getPedMoveState (localPlayer) == "powerwalk" then
				value = 60
			elseif getPedMoveState (localPlayer) == "jog" then
				value = 80
			elseif getPedMoveState (localPlayer) == "sprint" then	
				value = 100
			elseif not getPedMoveState (localPlayer) then
				value = 20
			end
			if (getElementData(localPlayer,"shooting") and getElementData(localPlayer,"shooting") > 0) then
				value = value + getElementData(localPlayer,"shooting")
			end
			if getPedOccupiedVehicle(localPlayer) then
				if getVehicleType(getPedOccupiedVehicle(localPlayer)) ~= "BMX" then
					if getVehicleEngineState(getPedOccupiedVehicle(localPlayer)) then
						value = 100
					else
						value = 0
					end
				else
					value = 0
				end
			end
			if getElementData(localPlayer, "prone") then
				value = 0
			end
			if (value > 100) then
				value = 100
			end
			setElementData(localPlayer, "volume", value)
			
			--# Visible
			local value = 0
			if getPedMoveState (localPlayer) == "stand" then
				value = 40
			elseif getPedMoveState (localPlayer) == "crouch" then	
				value = 0
			elseif getPedMoveState(localPlayer) == "crawl" then
				value = 20
			elseif getPedMoveState (localPlayer) == "walk" then
				value = 60
			elseif getPedMoveState (localPlayer) == "powerwalk" then
				value = 60
			elseif getPedMoveState (localPlayer) == "jog" then
				value = 80
			elseif getPedMoveState (localPlayer) == "sprint" then	
				value = 100
			elseif not getPedMoveState (localPlayer) then	
				value = 20
			end
			if isObjectAroundPlayer(localPlayer, 2, 4) then
				value = 0
			end
			if isPedInVehicle(localPlayer) then
				value = 100
			end
			if (value > 100) then
				value = 100
			end
			if getElementData(localPlayer, "prone") then
				value = 0
			end
			setElementData(localPlayer, "visibility", value, false)
		else
			showChat(false) -- in cases.
		end
	end
end
setTimer(onPlayerStatus, 1000, 0)

function getPlayerLoad()
	if getElementData(localPlayer,"Logged") then
		if not isPedInVehicle(localPlayer) then
			local speedx, speedy, speedz = getElementVelocity (localPlayer)
			local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
			mps = actualspeed * 50
		else
			playerSpeed = 20
		end
		playerSpeed = math.floor(mps*3.5)
		
		local hunger = (math.abs((((12000 - getElementData(localPlayer,"blood")) / 12000) * 5) + playerSpeed) * 3)
		playerHunger = 0
		playerHunger = math.round(playerHunger+(hunger/80),2)
		
		local thirst = 2
		thirst = (playerSpeed+4)*3
		playerThirst = 0
		playerThirst = math.round(playerThirst+(thirst/120)*(getElementData(localPlayer,"temperature")/37),2)
	end
end
setTimer(getPlayerLoad, 30000, 0)

function setPlayerHunger()
	if getElementData(localPlayer,"Logged") then
		if getElementData(localPlayer,"food") > 0 then
			setElementData(localPlayer,"food",getElementData(localPlayer,"food")-playerHunger)
		else
			setElementData(localPlayer,"food",0)
		end
	end
end
setTimer(setPlayerHunger, 30100, 0)

function setPlayerThirst()
	if getElementData(localPlayer,"Logged") then
		if getElementData(localPlayer,"thirst") > 0 then
			setElementData(localPlayer,"thirst",getElementData(localPlayer,"thirst")-playerThirst)
		else
			setElementData(localPlayer,"thirst",0)
		end
	end
end
setTimer(setPlayerThirst, 30100, 0)

function updateDaysAliveTime()
	if getElementData(localPlayer,"Logged") then
		local daysalive = getElementData(localPlayer,"daysalive") or 0
		setElementData(localPlayer,"daysalive",daysalive+1)
	end
end
setTimer(updateDaysAliveTime, 2880000, 0)

function updatePlayTime()
	if getElementData(localPlayer,"Logged") then
		local playtime = getElementData(localPlayer,"alivetime") or 0
		setElementData(localPlayer,"alivetime",playtime+1)
	end	
end
setTimer(updatePlayTime, 60000, 0)

function updateHoursAliveTime()
	if getElementData(localPlayer,"Logged") then
		local hourstime = getElementData(localPlayer,"hoursalive") or 0
		setElementData(localPlayer,"hoursalive",hourstime+1)
	end	
end
setTimer(updateHoursAliveTime, 3600000, 0)

function infectionSigns()
	if getElementData(localPlayer,"Logged") then
		if getElementData(localPlayer,"infection") and getElementData(localPlayer,"infection") > 0 then
			local x,y,z = getElementPosition(localPlayer)
			createExplosion (x,y,z+15,8,false,0.5,false)
			local x, y, z, lx, ly, lz = getCameraMatrix()
			local randomsound = math.random(0,50)
			if randomsound >= 0 and randomsound <= 20 then
				local getnumber = math.random(0,2)
				playSound("sounds/effects/cough_"..tostring(getnumber)..".ogg", false)
				setElementData(localPlayer,"volume",100)
				setTimer(function() setElementData(localPlayer,"volume",0) end,1500,1)
			elseif randomsound >= 21 and randomsound <= 40 then	
				setElementData(localPlayer,"volume",100)
				setTimer(function() setElementData(localPlayer,"volume",0) end,1500,1)
				playSound("sounds/effects/sneezing.mp3", false)
			end
		end
	end
end
setTimer(infectionSigns, 10000, 0)

function regenerateBlood()
	if getElementData(localPlayer,"Logged") and not getElementData(localPlayer,"dead") then
		local blood = getElementData(localPlayer,"blood")
		if blood < 12000 then
			if blood >= 11940 then
				setElementData(localPlayer,"blood",12000)
			elseif blood <= 11940 and blood >= (12000*75)/100 then
				setElementData(localPlayer,"blood",blood+60)
			elseif blood <= (12000*74)/100 and blood >= (12000*50)/100 then
				setElementData(localPlayer,"blood",blood+30)
			elseif blood <= (12000*49)/100 and blood >= (12000*0.001)/100 then
				setElementData(localPlayer,"blood",blood+10)
			elseif blood >= 12001 then
				setElementData(localPlayer,"blood",12000)
			end
		end
	end
end
setTimer(regenerateBlood, 60000, 0)

function setPlayerCold()
	if getElementData(localPlayer,"Logged") then
		if getElementData(localPlayer,"temperature") <= 33 then
			setElementData(localPlayer,"cold",1)
		elseif getElementData(localPlayer,"temperature") > 33 then
			setElementData(localPlayer,"cold",0)
		end
		if getElementData(localPlayer,"cold") and getElementData(localPlayer,"cold") > 0 then
			local x,y,z = getElementPosition(localPlayer)
			createExplosion (x,y,z+15,8,false,0.5,false)
			local x, y, z, lx, ly, lz = getCameraMatrix()
			local randomsound = math.random(0,99)
			if randomsound >= 0 and randomsound <= 50 then
				local getnumber = math.random(0,2)
				playSound("sounds/effects/cough_"..tostring(getnumber)..".ogg", false)
				setElementData(localPlayer,"volume",100)
				setTimer(function() setElementData(localPlayer,"volume",0) end,1500,1)
			elseif randomsound >= 11 and randomsound <= 20 then	
				setElementData(localPlayer,"volume",100)
				setTimer(function() setElementData(localPlayer,"volume",0) end,1500,1)
				playSound("sounds/effects/sneezing.mp3")			
			end
			setElementData(localPlayer,"blood",getElementData(localPlayer,"blood")-50)
		end	
	end
end
setTimer(setPlayerCold, 40000, 0)

function checkTemperature()
	if getElementData(localPlayer,"Logged") then
		local current = getElementData(localPlayer,"temperature") or 0
		local value = 0
		
		if isElementInWater(localPlayer) then
			value = value + gameplayVariables["temperaturewater"]
		end	
		if getPedControlState(localPlayer,"sprint") then
			if (current <= 37) then
				value = value + gameplayVariables["temperaturesprint"]
			end
		end
		if getPedOccupiedVehicle(localPlayer) then
			if (current <= 37) then
				value = value + 0.008
			end
		end
		if (current + value > 41) then
			setElementData(localPlayer,"temperature",41)
		elseif (current + value <= 31) then
			setElementData(localPlayer,"temperature",31)
		else
			setElementData(localPlayer,"temperature",current + value)
		end
	end	
end
setTimer(checkTemperature, 5000, 0)