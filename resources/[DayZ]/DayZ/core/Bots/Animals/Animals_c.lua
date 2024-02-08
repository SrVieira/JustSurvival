addEventHandler("onClientPedDamage", root,
	function(attacker, weapon, loss)
		if getElementData(source,"animal") then
			cancelEvent()

			if attacker and getElementType(attacker) == "player" and attacker ~= source then
				local damage = 200
				local weap = nil
				
				if weapon == 37 or weapon == 54 or weapon == 55 then
					return
				end
				
				if weapon then
					if weapon == 51 or weapon == 19 or weapon == 59 or weapon == 63 or weapon == 16 then
						triggerServerEvent("onAnimalDie",source,getElementData(source, "attackedBy") or attacker,weap)
						return
					elseif weapon ~= 0 then
						weap = getPlayerCurrentWeapon(attacker)
						damage = getWeaponDamage(attacker, getPedWeapon(attacker))
					end
				end
				
				setElementData(source,"blood",getElementData(source,"blood")-math.floor(damage))
				
				if getElementData(source,"blood") <= 0 then
					triggerServerEvent("onAnimalDie",source,attacker,weap)
				end
				
			elseif attacker and getElementType(attacker) == "vehicle" then
				damage = 400
				
				if weapon == 37 or weapon == 54 or weapon == 55 then
					return
				end 
				
				if weapon then
					if weapon == 51 or weapon == 19 or weapon == 59 or weapon == 63 or weapon == 16 then
						triggerServerEvent("onAnimalDie",source,attacker,weap)
						return
					elseif weapon == 49 then
						damage = 700
						
						setElementData(source,"blood",getElementData(source,"blood")-damage)
						if getElementData(source,"blood") <= 0 then
							triggerServerEvent("onAnimalDie",source,attacker,weap)
						end
					elseif weapon == 50 then
						damage = 0
						
						setElementData(source,"blood",getElementData(source,"blood")-damage)
						if getElementData(source,"blood") <= 0 then
							triggerServerEvent("onAnimalDie",source,attacker,weap)
						end
					end
				end
			
			elseif attacker and getElementType(attacker) == "ped" then
				local slothbot = getElementData(source, "slothbot")

				damage = getElementData(attacker, "damage")

				if not slothbot then
					setElementData(source,"blood",getElementData(source,"blood")-damage)
				
					if getElementData(source,"blood") <= 0 then
						triggerServerEvent("onAnimalDie",source,attacker,nil)
					end					
				end
			else
				if weapon == 51 or weapon == 19 or weapon == 59 or weapon == 63 or weapon == 16 then
					triggerServerEvent("onAnimalDie", source, getElementData(source, "attackedBy") or attacker, weap)
					return
				end
			end
		end
	end
)

function animalMovement(ped)
	if isElement(ped) then
		local rotation = math.random(1,359)
		local setStance = math.random(0,50)
		setPedRotation(ped,rotation)
		if setStance >= 0 and setStance <= 40 then
			setPedAnimation (ped, "PED", "WALK_civi", -1, true, true,true)
		elseif setStance > 40 then
			setPedAnimation(ped,"PED","WEAPON_crouch",-1,true,true,true)
		end
	end
end
addEvent("onAnimalMove",true)
addEventHandler("onAnimalMove",root,animalMovement)

local jumping = {}
function checkAnimalPlayerStealth()
    local x,y,z = getElementPosition(localPlayer)
    for i,ped in ipairs(getElementsByType("ped")) do
        if getElementData(ped,"animal") and getElementData(localPlayer, "Logged") then
			if not getPedControlState(ped, "sprint") then setPedControlState(ped, "sprint", true) end
			if getElementData(localPlayer,"shooting") and getElementData(localPlayer,"shooting") > 0 then
				value = getWeaponNoiseFactor(getPedWeapon(localPlayer))
			else
				value = 2
			end

			local sound = (getElementData(localPlayer,"volume")/value)
            local visibly = (getElementData(localPlayer,"visibility")/2)
            local x,y,z = getElementPosition(localPlayer)
            local xZ,yZ,zZ = getElementPosition(ped)
			local data = fromJSON(getElementData(ped, "animalData")) or {}

            if getDistanceBetweenPoints3D (x,y,z,xZ,yZ,zZ) <= (sound+visibly)+20 then
				if getPedControlState(ped, "jump") then
					if data.animalType and data.animalType ~= "cow" then
						if not jumping[ped] then
							if getPedSimplestTask(ped) == "TASK_SIMPLE_CLIMB" then
								local xp,yp,zp = getElementPosition(ped)
								local vx, vy, vz = getElementVelocity(ped)
								setElementPosition(ped, xp,yp,zp)
								setElementVelocity(ped, vx, vy, 0.4)
								jumping[ped] = true
							end
						end
					end
				end

                if not isElement(getElementData ( ped, "leader" )) and data.offensive and not getPedOccupiedVehicle(localPlayer) then
					triggerServerEvent("setAnimalAttacking",localPlayer,ped)
					setPedAnimation(ped)
                end
            else
				if not data.offensive then
					triggerEvent("onAnimalMove",root,ped)
				else
					if getElementData ( ped, "target" ) == localPlayer and data.offensive then
						setElementData(ped,"target",nil)
						triggerEvent("onAnimalMove",root,ped)
					end
					if getElementData ( ped, "leader" ) == localPlayer and data.offensive then
						triggerServerEvent("stopAnimalAttacking",localPlayer,ped)
						triggerEvent("onAnimalMove",root,ped)
					end
				end
            end
			
			if isPedOnGround(ped) and jumping[ped] then 
				setTimer(function(ped) jumping[ped] = nil end, 500, 1, ped)
			end
        end
    end
end
setTimer(checkAnimalPlayerStealth,500,0)

function setAnimalControlState(tbl)
	if (#tbl > 0) then
		for key, animal in ipairs(tbl) do
			if isElement(animal) and not getPedControlState(animal, "sprint") then
				setPedControlState(animal, "sprint", true)
			end
		end
	end
end
addEvent("onRequestAnimalSprint", true)
addEventHandler("onRequestAnimalSprint", root, setAnimalControlState)