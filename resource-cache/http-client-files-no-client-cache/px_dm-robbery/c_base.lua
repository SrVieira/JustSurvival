--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

-- create peds

Robbery.SpawnPed=function(id)
	local v=Robbery.Places[id]
	if(not v)then return end

	if(v.pedElement and isElement(v.pedElement))then
		destroyElement(v.pedElement)
	end

	if(not v.pedElement)then
		v.pedElement=createPed(v.skin, unpack(v.ped))
	end

    setElementInterior(v.pedElement, v.int)
    setElementDimension(v.pedElement, v.dim)
	setElementData(v.pedElement, "ped:desc", {name="Sklepikarz", desc="O co chodzi?"})
	setElementData(v.pedElement, "bot_dm", true)
	setElementData(v.pedElement, "id", id, false)
	setElementFrozen(v.pedElement, true)
	setElementData(v.pedElement, "ghost", "all")
end

for i,v in pairs(Robbery.Places) do
	Robbery.SpawnPed(i)
end

addEventHandler("onClientPedWasted", resourceRoot, function()
	local el=source
	setTimer(function()
		local data=getElementData(el, "id")
		if(not data)then return end

		Robbery.SpawnPed(data)
	end, 10000, 1)
end)

-- functions

Robbery.Stop=function(success)
	Robbery.EndedType=false

	removeEventHandler("onClientRender", root, Robbery.DrawStart)
	removeEventHandler("onClientPlayerDamage", root, Robbery.OnDamage)
	removeEventHandler("onClientPlayerWasted", root, Robbery.OnWasted)

	setPedAnimation(Robbery.Places[Robbery.GetID].pedElement, false)

	Robbery.Now=false

	killTimer(Robbery.SirenTimer)
	Robbery.SirenTimer=false

	addEventHandler("onClientRender", root, Robbery.DrawEnd)
	addEventHandler("onClientKey", root, Robbery.OnKey)

	setElementData(localPlayer, "user:hud_disabled", true, false)

	local time=(getTickCount()-Robbery.Tick)/1000
	local min=time/60
	local sec=time%60
	local textTime=math.floor(min)..":"..string.format("%02d", math.floor(sec))

	Robbery.StartTickAnim=getTickCount()
	Robbery.TickAnim=getTickCount()
	Robbery.EndedInfo.time=textTime

	if(Robbery.AlphaAnimate)then
		destroyAnimation(Robbery.AlphaAnimate)
	end

	Robbery.AlphaAnimate=animate(Robbery.MainAlpha, 255, "Linear", 500, function(a)
		Robbery.MainAlpha=a
	end,function()
		Robbery.AlphaAnimate=false
	end)

	local respect=not success and 20-math.floor(20*(Robbery.GetMoney/Robbery.MaxMoney)) or math.floor(20*(Robbery.GetMoney/Robbery.MaxMoney))
	respect=respect < 0 and 0 or respect

	Robbery.EndedInfo.respect=respect

	triggerServerEvent("Robbery:Success", resourceRoot, success and Robbery.GetMoney or 0, respect, success)

	if(success)then
		playSound("files/music.mp3")
	end
end

Robbery.OnDamage=function(attacker,_,_,loss)
	if(Robbery.Now)then
		if(source == localPlayer)then
			Robbery.EndedInfo.dm=Robbery.EndedInfo.dm+loss
		elseif(attacker == localPlayer)then
			Robbery.EndedInfo.myDM=Robbery.EndedInfo.myDM+loss
		end
	end
end

Robbery.OnWasted=function(killer)
	if(Robbery.Now)then
		if(source == localPlayer)then
			Robbery.Stop()
		elseif(killer == localPlayer)then
			Robbery.EndedInfo.players=Robbery.EndedInfo.players+1
		end
	end
end

-- events

addEvent("Robbery:Start", true)
addEventHandler("Robbery:Start", resourceRoot, function(id)
	local v=Robbery.Places[id]
	if(not v)then return end

	if(getElementHealth(v.pedElement) <= 0)then return end

    setPedAnimation(v.pedElement, "ped", "handsup", -1, false, false)

	Robbery.Position={getElementPosition(v.pedElement)}
	Robbery.Now=true
	Robbery.Time=5 -- czas trwania napadu 15 minutek
	Robbery.Type=v.type
	Robbery.Tick=getTickCount()
	Robbery.GetMoney=0
	Robbery.GetID=id
	Robbery.MaxMoney=math.random(2000,4000) -- maksymalny lup
	Robbery.SirenTimer=setTimer(function()
		Robbery.Siren=not Robbery.Siren
	end,200,0)
	Robbery.EndedType=false
	Robbery.EndedInfo={
		time=0,
		players=0,
		dm=0,
		myDM=0,
		respect=0,
	}

	exports.px_noti:noti("Rozpoczęto napad! SAPD zostało powiadomione. Nie daj się złapać, bo napad zostanie przerwany! Uciekaj! Masz jeszcze "..Robbery.Time.." minut. Nie możesz się oddalić dalej niż 30 metrów od stacji paliw.", "info")

    triggerServerEvent("Robbery:SirenStart", resourceRoot)

	assets.create()
	addEventHandler("onClientRender", root, Robbery.DrawStart)
	addEventHandler("onClientPlayerDamage", root, Robbery.OnDamage)
	addEventHandler("onClientPlayerWasted", root, Robbery.OnWasted)
end)

addEventHandler("onClientPlayerTarget", root, function(target)
    if(getPedWeapon(localPlayer) ~= 0 and isPedAiming() and not Robbery.Now and not getElementData(localPlayer, "user:hud_disabled"))then
        for i,v in pairs(Robbery.Places) do
            if(target == v.pedElement and not Robbery.Now and not Robbery.Block)then
				local myPos={getElementPosition(localPlayer)}
				local pos={getElementPosition(target)}
				local dist=getDistanceBetweenPoints3D(myPos[1], myPos[2], myPos[3], pos[1], pos[2], pos[3])
				if(dist < 5)then
					triggerServerEvent("Robbery:Start", resourceRoot, i)

					Robbery.Block=setTimer(function()
						Robbery.Block=nil
					end,1000,1)
				end

				break
            end
        end
    end
end)

addEvent("Robbery:Stop", true)
addEventHandler("Robbery:Stop", resourceRoot, function()
	if(Robbery.Now)then
		Robbery.Stop()
		exports.px_noti:noti("Zostałeś złapany przez SAPD. Napad zostaje przerwany.", "error")
    end
end)

addEventHandler("onClientPedWasted", resourceRoot, function(killer)
    if(Robbery.Now and killer == localPlayer)then
		Robbery.Stop()
		exports.px_noti:noti("Kasjer zostął zabity! Napad zostaje przerwany.", "error")
    end
end)