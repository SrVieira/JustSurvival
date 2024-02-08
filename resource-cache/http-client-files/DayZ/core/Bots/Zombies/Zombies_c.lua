function zombieMovement(ped)
	if isElement(ped) then
		local rotation = math.random(1,359)
		local setStance = math.random(0,50)
		setPedRotation(ped,rotation)
		if setStance >= 0 and setStance <= 49 then
			setPedAnimation (ped, "RYDER", "RYD_Die_PT1", -1, true, true, true)
		elseif setStance == 50 then
			setPedAnimation(ped,"PED","WEAPON_crouch",-1,true,true,true)
		end
	end
end
addEvent("onZombieMove",true)
addEventHandler("onZombieMove",getRootElement(),zombieMovement)

function checkAliveZombies()
	local zombiesalive = 0
	local zombiestotal = 0
	for i,ped in ipairs(getElementsByType("ped")) do
		if getElementData(ped,"zombie") then
			zombiesalive = zombiesalive + 1
		end
		if getElementData(ped,"deadzombie") then
			zombiestotal = zombiestotal + 1
		end
	end
	setElementData(getRootElement(),"zombiesalive",zombiesalive)
	setElementData(getRootElement(),"zombiestotal",zombiestotal+zombiesalive)
end
setTimer(checkAliveZombies,5000,0)

function checkZombiePlayerStealth()
    local x,y,z = getElementPosition(localPlayer)
    for i,ped in ipairs(getElementsByType("ped")) do
        if getElementData(ped,"zombie") then
			if getElementData(localPlayer,"shooting") and getElementData(localPlayer,"shooting") > 0 then
				value = getWeaponNoiseFactor(getPedWeapon(localPlayer))
			else
				value = 2
			end
			local sound = getElementData(localPlayer,"volume")/value
            local visibly = getElementData(localPlayer,"visibility")/2
            local xZ,yZ,zZ = getElementPosition(ped)
            if getDistanceBetweenPoints3D (x,y,z,xZ,yZ,zZ) <= sound+visibly then
                if getElementData ( ped, "leader" ) == nil then
					if not getElementData(ped,"deadzombie") then
						triggerServerEvent("botAttack",localPlayer,ped)
					end
                end
            else
				if getElementData ( ped, "target" ) == localPlayer then
					setElementData(ped,"target",nil)
					triggerEvent("onZombieMove",root,ped)
				end
                if getElementData ( ped, "leader" ) == localPlayer then
                    triggerServerEvent("botStopFollow",localPlayer,ped)
                    triggerEvent("onZombieMove",root,ped)
                end
            end
        end
    end
end
setTimer(checkZombiePlayerStealth,500,0)

function zombieSpawning()
	if getElementData(localPlayer,"Logged") and not getElementData(localPlayer,"zombieProof") then
		if not isPedInVehicle(localPlayer) then
				local x, y, z = getElementPosition(getLocalPlayer())
				triggerServerEvent("createZomieForPlayer",getLocalPlayer(),x,y,z)
			end
		end
	end
setTimer(zombieSpawning,3000,0)

function zombieDayZDamage(attacker,weapon,bodypart,loss)
	cancelEvent()
	if getElementData(source,"zombie") then
		if attacker and getElementType(attacker) == "player" and attacker ~= source then
			local headshot = false
			local damage = 100
			local weap = nil
			if weapon == 37 or weapon == 54 or weapon == 55 then
				return
			end
			if weapon then
				if weapon == 51 or weapon == 19 or weapon == 59 or weapon == 63 or weapon == 16 then
					triggerServerEvent("onZombieGetsKilled",source,getElementData(source, "attackedBy") or attacker,weap)
					return
				elseif weapon ~= 0 then
					weap = getPlayerCurrentWeapon(attacker)
					damage = getWeaponDamage(attacker, getPedWeapon(attacker))
					
					local x1,y1,z1 = getElementPosition(source)
					local x2,y2,z2 = getElementPosition(attacker)

					if bodypart == 9 then
						damage = damage*3
						headshot = true
					end
					if (getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) > 1) and (getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) < 3) and getWeaponAmmoName(weap) == "12 Gauge" then
						triggerServerEvent("onZombieGetsKilled",source,attacker,weap,headshot,bodypart)
						return
					end

					setElementData(source,"blood",getElementData(source,"blood")-math.floor(damage))
					if getElementData(source,"blood") <= 0 then
						triggerServerEvent("onZombieGetsKilled",source,attacker,weap,headshot,bodypart)
					end
				elseif weapon == 0 then
					return
				end
			end
		elseif attacker and getElementType(attacker) == "vehicle" then
			damage = 100
			if weapon == 37 or weapon == 54 or weapon == 55 then
				return
			end 
			if weapon then
				if weapon == 51 or weapon == 19 or weapon == 59 or weapon == 63 or weapon == 16 then
					triggerServerEvent("onZombieGetsKilled",source,attacker,weap,false,bodypart)
					return
				elseif weapon == 49 then
					damage = 700
					
					setElementData(source,"blood",getElementData(source,"blood")-damage)
					if getElementData(source,"blood") <= 0 then
						triggerServerEvent("onZombieGetsKilled",source,attacker,weap,headshot,bodypart)
					end
				elseif weapon == 50 then
					damage = 0
					
					setElementData(source,"blood",getElementData(source,"blood")-damage)
					if getElementData(source,"blood") <= 0 then
						triggerServerEvent("onZombieGetsKilled",source,attacker,weap,headshot,bodypart)
					end
				end
			end
		else
			if weapon == 51 or weapon == 19 or weapon == 59 or weapon == 63 or weapon == 16 then
				triggerServerEvent("onZombieGetsKilled",source,getElementData(source, "attackedBy") or attacker,weap, false, bodypart)
				return
			end
		end
	end
end
addEventHandler ("onClientPedDamage",root,zombieDayZDamage)