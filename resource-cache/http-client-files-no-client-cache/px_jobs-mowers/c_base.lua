--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

ui.createMower=function(obj_id, tank_id, pos)
    local x,y,z,rz=pos[1],pos[2],pos[3],pos[4] or 0,0,0,0

    ui.mower=createObject(obj_id,x,y,z,0,0,rz)
    ui.tank=createObject(tank_id,x,y,z,0,0,rz)
    attachElements(ui.tank, ui.mower)

    setElementFrozen(ui.mower, true)
    setElementCollisionsEnabled(ui.mower, false)
    setElementCollisionsEnabled(ui.tank, false)

    ui.blips[ui.mower]=createBlipAttachedTo(ui.mower,22)

    if(ui.markers["landing"])then
        setElementData(ui.mower, "interaction", {options={
            {name="Zdejmij kosz", alpha=150, animate=false, tex=":px_jobs-mowers/textures/mover-up.png"},
        }, scriptName="px_jobs-mowers", dist=2}, false)
    end

    triggerLatentServerEvent("destroy.mower", resourceRoot, true)

    setElementData(ui.mower, "interaction:only", localPlayer, false)

    return id
end

ui.attachTank=function()
    if(not ui.info.upgrades["Traktorek"])then
        detachElements(ui.tank)
        exports.pAttach:attachElementToBone(ui.tank, localPlayer, 1, 0, 0, 1.1, 90, 0, 0)

        setPedAnimation(localPlayer, "CARRY", "crry_prtial", 4.1, true, true)
    else
        triggerLatentServerEvent("attach.tank", resourceRoot, true)
    end

    ui.attachedTank=true

    if(not ui.info.upgrades["Szybcior"])then
        toggleControl("sprint", false)
    end

    toggleControl("jump", false)
    toggleControl("crouch", false)
end

ui.detachTank=function()
    if(not ui.info.upgrades["Traktorek"])then
        exports.pAttach:detachElementFromBone(ui.tank)
        attachElements(ui.tank, ui.mower)

        setPedAnimation(localPlayer, "CARRY", "liftup", 0.0, false, false, false, false)
    else
        triggerLatentServerEvent("attach.tank", resourceRoot)
    end

    ui.attachedTank=false

    toggleControl("jump", true)
    toggleControl("sprint", true)
    toggleControl("crouch", true)
end

ui.destroyMower=function(mower)
    checkAndDestroy(ui.blips[mower or ui.mower])
    checkAndDestroy(mower or ui.mower)
    checkAndDestroy(ui.tank)

    ui.blips[mower or ui.mower]=nil
    ui.tank=false

    if(not mower)then
        ui.mower=false
    end
end

ui.getMower=function()
    if(SPAM.getSpam())then return end

    if(ui.checkTrigger)then return end

    if(not ui.haveMower)then
        local myPos={getElementPosition(localPlayer)}
        local hisPos={getElementPosition(ui.mower)}
        local dist=getDistanceBetweenPoints3D(myPos[1],myPos[2],myPos[3],hisPos[1],hisPos[2],hisPos[3])
        if(dist < 2)then
            local el=getElementAttachedObjects(localPlayer)
            if(#el < 1 and not ui.attachedTank)then
                noti:noti("Aby włączyć kosiarkę użyj lewego ALT'a i myszki.", "info")

                ui.haveMower=true
                ui.checkTrigger=true

                if(not ui.info.upgrades["Szybcior"])then
                    toggleControl("sprint", false)
                end
                toggleControl("jump", false)
                toggleControl("crouch", false)

                triggerLatentServerEvent("attach.mower", resourceRoot, getElementModel(ui.mower))
            end
        end
    else
        ui.checkTrigger=true
        triggerLatentServerEvent("destroy.mower", resourceRoot)
    end
end

ui.onMarkerHit=function(hit, dim)
    if(hit ~= localPlayer or not dim)then return end

    if(SPAM.getSpam())then return end

    if(source == ui.markers["landing"] and not isElementFrozen(hit))then
        if(ui.attachedTank)then
            setElementFrozen(hit, true)

            noti:noti("Trwa rozładunek kosza..", "info")
            setTimer(function()
                local progress=math.floor((ui.progress/ui.maxProgress)*100)
                triggerLatentServerEvent("get.payment", resourceRoot, progress)

                ui.progress=0
                ui.maxProgress=ui.info.upgrades["Większy kosz"] and 7.5 or 5

                setElementFrozen(hit, false)

                checkAndDestroy(ui.markers["landing"])
                checkAndDestroy(ui.blips["landing"])
                ui.markers["landing"]=nil
                ui.blips["landing"]=nil

                checkAndDestroy(ui.zones["grass"])
                checkAndDestroy(ui.blips["grass"])

                ui.blips["grass"]=createBlip(1461.2120,-36.6064,23.4836,22)
                ui.zones["grass"]=createColSphere(1461.2120,-36.6064,23.4836, 50)

                local data=getElementData(localPlayer, "user:jobs_todo") or {}
                data[3].done=false
                data[3].done=false
                setElementData(localPlayer, "user:jobs_todo", data, false)
            end, 5000, 1)
        else
            noti:noti("Najpierw zdejmij kosz z kosiarki, aby to zrobić podejdź pod kosiarkę i wybierz opcję z interakcji.", "error")
        end
    end
end

ui.onColShapeHit=function(hit, dim)
    if(hit ~= localPlayer or not dim)then return end

    if(source == ui.zones["grass"])then
        local data=getElementData(localPlayer, "user:jobs_todo") or {}
        data[2].done=true
        setElementData(localPlayer, "user:jobs_todo", data, false)

        checkAndDestroy(ui.zones["grass"])
        checkAndDestroy(ui.blips["grass"])
        ui.zones["grass"]=nil
        ui.blips["grass"]=nil
    else
        if(ui.knives == 0)then
            for i,v in pairs(ui.zones) do
                if(source == v.col and string.find(i,"grass_"))then
                    ui.checkAndDestroyArea(i)
                    break
                end
            end
        end
    end
end

ui.timerElement=false
ui.onTimer=function()
    local data=getElementData(localPlayer, "user:jobBackTime") or 60
    if(data <= 0)then
        triggerLatentServerEvent("stop.job", resourceRoot, localPlayer)
        stopJob()
        return
    else
        setElementData(localPlayer, "user:jobBackTime", data-1, false)
    end
end

ui.start={1522.1624,14.7658,24.1406}
ui.onRender=function()
    local myPos={getElementPosition(localPlayer)}
    local dist=getDistanceBetweenPoints3D(ui.start[1], ui.start[2], ui.start[3], myPos[1], myPos[2], myPos[3])
    if(dist > 200)then
        triggerLatentServerEvent("stop.job", resourceRoot, localPlayer)
        stopJob()
        return
    end

    if(ui.mower and isElement(ui.mower) and getElementType(ui.mower) == "object")then
        if(not ui.haveMower)then
            local size=0.3
            local x,y,z=getElementPosition(ui.mower)
            z=interpolateBetween(z-0.1, 0, 0, z+0.1, 0, 0, (getTickCount()-ui.tick)/1500, "SineCurve")
            dxDrawMaterialLine3D(x,y,z+size,x,y,z,assets.textures[6],size,tocolor(255,255,255))
        end
    end

    if(ui.mower and isElement(ui.mower))then
        if(getPedOccupiedVehicle(localPlayer) ~= ui.mower)then
            local myPos={getElementPosition(localPlayer)}
            local vPos={getElementPosition(ui.mower)}
            local dist=getDistanceBetweenPoints3D(myPos[1], myPos[2], myPos[3], vPos[1], vPos[2], vPos[3])
            local data=getElementData(localPlayer, "user:jobBackTime")
            if(dist > 50)then
                if(not ui.timerElement)then
                    ui.timerElement=setTimer(ui.onTimer,1000,0)
                end
            else
                setElementData(localPlayer, "user:jobBackTime", false, false)

                if(ui.timerElement and isTimer(ui.timerElement))then
                    killTimer(ui.timerElement)
                end
                ui.timerElement=false
            end
        end
    else
        triggerLatentServerEvent("stop.job", resourceRoot, localPlayer)
        stopJob()
        return
    end

    if(ui.haveMower or isPedInVehicle(localPlayer))then
        if(getKeyState("lalt"))then
            if(not isCursorShowing())then
                showCursor(true,false)
                setCursorAlpha(0)
            end

            local sx,sy=getCursorPosition()
            sx,sy=sx*sw,sy*sh

            if(not ui.cursor)then
                ui.cursor={sx,sy}
            else
                local x,y=ui.cursor[1]-sx, ui.cursor[2]-sy
                ui.knives=y > 0 and 0 or 1

                if(ui.knives == 0 and not ui.sound)then 
                    ui.sound=playSound("sounds/mower.mp3", true)
                elseif(ui.knives == 1 and ui.sound)then
                    checkAndDestroy(ui.sound)
                    ui.sound=false
                end
            end
        else
            if(isCursorShowing())then
                ui.cursor=nil
                showCursor(false)
                setCursorAlpha(255)
            end
        end

        dxDrawImage(ui.pos[1][1], ui.pos[1][2], ui.pos[1][3], ui.pos[1][4], assets.textures[1])
        dxDrawImage(ui.pos[2][1], ui.pos[2][2]-(ui.pos[2][4]/2)+(ui.pos[1][4]*(ui.knives/1)), ui.pos[2][3], ui.pos[2][4], getKeyState("lalt") and assets.textures[3] or assets.textures[2])
    end

    blur:dxDrawBlur(ui.pos[3][1], ui.pos[3][2], ui.pos[3][3], ui.pos[3][4])
    dxDrawImage(ui.pos[3][1], ui.pos[3][2], ui.pos[3][3], ui.pos[3][4], assets.textures[4])

    dxDrawText("Zapełnienie:", ui.pos[4][1], ui.pos[4][2], ui.pos[4][3], ui.pos[4][4], tocolor(200, 200, 200), 1, assets.fonts[1], "left", "top")
    dxDrawText(math.floor((ui.progress/ui.maxProgress)*100).."%", ui.pos[4][1], ui.pos[4][2], ui.pos[4][3], ui.pos[4][4], tocolor(150, 150, 150), 1, assets.fonts[1], "right", "top")

    dxDrawImage(ui.pos[5][1], ui.pos[5][2], ui.pos[5][3], ui.pos[5][4], assets.textures[5])
    dxDrawRectangle(ui.pos[5][1]+2, ui.pos[5][2]+2, (ui.pos[5][3]-4)*(ui.progress/ui.maxProgress), ui.pos[5][4]-4, tocolor(52,129,68))
end

addEvent("start.job", true)
addEventHandler("start.job", resourceRoot, function(info, vehicle)
    if(vehicle and isElement(vehicle))then
        ui.mower=vehicle

        setElementData(ui.mower, "interaction:only", localPlayer, false)

        ui.blips[ui.mower]=createBlipAttachedTo(ui.mower,22)
    end

    ui.info=info

    ui.haveMower=false
    ui.knives=1
    ui.sound=false
    ui.checkTrigger=false
    ui.attachedTank=false

    ui.progress=0
    ui.maxProgress=ui.info.upgrades["Większy kosz"] and 7.5 or 5

    assets.create()

    addEventHandler("onClientMarkerHit", resourceRoot, ui.onMarkerHit)
    addEventHandler("onClientColShapeHit", resourceRoot, ui.onColShapeHit)
    addEventHandler("onClientRender", root, ui.onRender)
    addEventHandler("onClientVehicleStartEnter", root, ui.onStartEnter)
    addEventHandler("onClientVehicleEnter", root, ui.onEnter)
    addEventHandler("onClientPlayerWasted", localPlayer, wasted)

    local data={
        {name="Udaj się po kosiarkę"},
        {name="Udaj się na pole trawy"},
        {name="Zapełnij kosiarkę"},
        {name="Rozładuj kosiarkę"},
    }
    setElementData(localPlayer, "user:jobs_todo", data, false)

    if(not ui.info.upgrades["Traktorek"])then
        bindKey("Q", "down", ui.getMower)
    end

    ui.createAreas()
end)

function wasted()
    triggerLatentServerEvent("stop.job", resourceRoot)
    stopJob()
end

function stopJob()
    if(ui.timerElement and isTimer(ui.timerElement))then
        killTimer(ui.timerElement)
    end
    ui.timerElement=false
    setElementData(localPlayer, "user:jobBackTime", false, false)
    setElementData(localPlayer, "user:jobs_todo", false, false)
    
    removeEventHandler("onClientMarkerHit", resourceRoot, ui.onMarkerHit)
    removeEventHandler("onClientColShapeHit", resourceRoot, ui.onColShapeHit)
    removeEventHandler("onClientRender", root, ui.onRender)
    removeEventHandler("onClientVehicleStartEnter", root, ui.onStartEnter)
    removeEventHandler("onClientPlayerWasted", localPlayer, wasted)
    removeEventHandler("onClientVehicleEnter", root, ui.onEnter)

    ui.destroyAreas()

    for i,v in pairs(ui.blips) do
        checkAndDestroy(v)
    end
    ui.blips={}

    for i,v in pairs(ui.markers) do
        checkAndDestroy(v)
    end
    ui.markers={}

    for i,v in pairs(ui.zones) do
        checkAndDestroy(v)
    end
    ui.zones={}

    checkAndDestroy(ui.sound)
    ui.sound=false

    checkAndDestroy(ui.mower)
    ui.mower=false

    checkAndDestroy(ui.tank)
    ui.tank=false

    assets.destroy()

    unbindKey("Q", "down", ui.getMower)

    toggleControl("jump", true)
    toggleControl("sprint", true)
    toggleControl("crouch", true)
end
addEvent("stop.job", true)
addEventHandler("stop.job", resourceRoot, stopJob)

addEvent("change.status", true)
addEventHandler("change.status", resourceRoot, function(status, mower)
    if(status)then
        local data=getElementData(localPlayer, "user:jobs_todo") or {}

        checkAndDestroy(ui.zones["grass"])
        checkAndDestroy(ui.blips["grass"])
        ui.blips["grass"]=createBlip(1461.2120,-36.6064,23.4836,22)
        ui.zones["grass"]=createColSphere(1461.2120,-36.6064,23.4836, 50)

        data[1].done=true
        setElementData(localPlayer, "user:jobs_todo", data, false)

        if(mower and isElement(mower))then
            ui.destroyMower(ui.mower)
            ui.mower=mower

            setElementData(ui.mower, "interaction:only", localPlayer, false)
        end
    else
        ui.haveMower=status

        if(not ui.haveMower)then
            toggleControl("jump", true)
            toggleControl("sprint", true)
            toggleControl("crouch", true)

            checkAndDestroy(ui.sound)
            ui.sound=false

            ui.knives=1
        end
    end

    ui.checkTrigger=false
end)

addEvent("exit.mower", true)
addEventHandler("exit.mower", resourceRoot, function()
    if(ui.markers["landing"])then
        setElementData(ui.mower, "interaction", {options={
            {name="Zdejmij kosz", alpha=150, animate=false, tex=":px_jobs-mowers/textures/mover-up.png"},
        }, scriptName="px_jobs-mowers", dist=2}, false)
    end

    checkAndDestroy(ui.sound)
    ui.sound=false

    ui.knives=1
end)

addEvent("create.mower", true)
addEventHandler("create.mower", resourceRoot, ui.createMower)

addEvent("destroy.mower", true)
addEventHandler("destroy.mower", resourceRoot, ui.destroyMower)

-- exports

function action(id,element,name,info)
    if(element ~= ui.mower)then return end

    if(name == "Zdejmij kosz" and not ui.attachedTank)then
        setElementData(ui.mower, "interaction", {options={
            {name="Załóż kosz", alpha=150, animate=false, tex=":px_jobs-mowers/textures/mover-down.png"},
        }, scriptName="px_jobs-mowers", dist=2}, false)

        ui.attachTank()
    elseif(name == "Załóż kosz" and ui.attachedTank)then
        if(not (ui.progress < (ui.maxProgress/2)) and ui.markers["landing"])then
            setElementData(ui.mower, "interaction", {options={
                {name="Zdejmij kosz", alpha=150, animate=false, tex=":px_jobs-mowers/textures/mover-up.png"},
            }, scriptName="px_jobs-mowers", dist=2}, false)
        else
            setElementData(ui.mower, "interaction", false, false)
        end

        ui.detachTank()
    end
end

ui.onStartEnter=function(plr,seat)
    if(source ~= ui.mower)then cancelEvent() end
end

ui.onEnter=function(plr,seat)
    if(source == ui.mower)then 
        local data=getElementData(localPlayer, "user:jobs_todo") or {}
        if(not data[1].done)then
            checkAndDestroy(ui.blips["grass"])
            checkAndDestroy(ui.zones["grass"])
            ui.blips["grass"]=createBlip(1461.2120,-36.6064,23.4836,22)
            ui.zones["grass"]=createColSphere(1461.2120,-36.6064,23.4836, 50)

            data[1].done=true
            setElementData(localPlayer, "user:jobs_todo", data, false)
        end

        if(mower and isElement(mower))then
            ui.destroyMower(ui.mower)
            ui.mower=mower

            setElementData(ui.mower, "interaction:only", localPlayer, false)
        end
    
        setElementData(ui.mower, "interaction", false)
    
        checkAndDestroy(ui.blips[ui.mower])
        ui.blips[ui.mower]=nil
    end
end