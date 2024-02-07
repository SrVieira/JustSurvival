--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

ui.createCart=function(obj_id,x,y,z,rz)
    local id=#ui.carts+1
    ui.carts[id]=createObject(obj_id,x,y,z,0,0,rz)
    setElementFrozen(ui.carts[id], true)
    setElementCollisionsEnabled(ui.carts[id], false)
    ui.blips[ui.carts[id]]=createBlipAttachedTo(ui.carts[id],22)
    return id
end

ui.destroyCart=function(id)
    checkAndDestroy(ui.blips[ui.carts[id]])
    checkAndDestroy(ui.carts[id])
    ui.blips[ui.carts[id]]=nil
    ui.carts[id]=nil
end

ui.getCart=function()    
    if(SPAM.getSpam())then return end

    local myPos={getElementPosition(localPlayer)}
    for i,v in pairs(ui.carts) do
        local hisPos={getElementPosition(v)}
        local dist=getDistanceBetweenPoints3D(myPos[1],myPos[2],myPos[3],hisPos[1],hisPos[2],hisPos[3])
        if(dist < 2)then
            local el=getElementAttachedObjects(localPlayer)
            if(#el < 1)then
                triggerLatentServerEvent("attach.cart", resourceRoot, getElementModel(v))
                ui.destroyCart(i)
                break
            end
        end
    end
end

ui.getRandomPoints=function(type)
    local randoms={}

    local tbl=type == "warehouse" and ui.warehouses or ui.atms
    local points=ui.saveCarts
    local i=0
    while(i < points)do
        local rnd=math.random(1,#tbl)
        if(not randoms[rnd])then
            local k=table.size(ui.markers)
            local v=tbl[rnd]

            ui.markers["point_"..(k+1)]=createMarker(v[1],v[2],v[3]-0.9, "cylinder", 1.5, 0, 100, 200)
            ui.blips["point_"..(k+1)]=createBlipAttachedTo(ui.markers["point_"..(k+1)], 22)
            ui.zones["point_"..(k+1)]=createColSphere(v[1],v[2],v[3],10)
            setElementData(ui.markers["point_"..(k+1)], "icon", ":px_jobs-escort/textures/atm-konwoj.png")

            randoms[rnd]=true

            i=i+1
        end
    end

    randoms=nil
end

ui.onMarkerHit=function(hit, dim)
    if(hit ~= localPlayer or not dim or isPedInVehicle(hit))then return end

    if(SPAM.getSpam())then return end

    if(source == ui.markers["veh"])then
        local data=getElementData(localPlayer, "user:jobs_todo") or {}
        data[2].done=true
        setElementData(localPlayer, "user:jobs_todo", data, false)

        noti:noti("Zaczekaj aż wózek zostanie załadowany.")

        setElementFrozen(localPlayer, true)

        ui.loading="TRWA ZAŁADUNEK..."
        ui.loadingTick=getTickCount()

        ui.loadingCarts[ui.maxCarts].tick=getTickCount()
        ui.loadingCarts[ui.maxCarts].block=false

        setTimer(function()
            ui.maxCarts=ui.maxCarts-1

            local data=getElementData(localPlayer, "user:job_todo")
            if(ui.maxCarts == 0)then
                triggerLatentServerEvent("warp.vehicle", resourceRoot)

                noti:noti("Następnie udaj się rozwieść pieniądze po punktach.", "success")

                for i,v in pairs(ui.blips) do
                    checkAndDestroy(v)
                end
                ui.blips={}
    
                ui.getRandomPoints(ui.pointsType)
    
                ui.maxCarts=ui.saveCarts
            
                local text=ui.miniLetters[ui.saveCarts]
                data={
                    {name="Udaj się po wózek", done=true},
                    {name="Zaprowadź wózek do pojazdu", done=true},
                    {name="Wnieś wózek na pakę pojazdu", done=true},
                    {name="Udaj się do punktu "..text},
                    {name="Wyjmij wózek i zanieś go do punktu "..text},
                    {name="Wróć na bazę gruppe6"},
                }
                setElementData(localPlayer, "user:jobs_todo", data, false)

                triggerLatentServerEvent("destroy.cart", resourceRoot, true)

                for i=1,ui.maxCarts do
                    ui.loadingCarts[i]={block=true, loaded=false, tick=getTickCount(), time=10000}
                end
            else
                noti:noti("Następnie udaj się załadować resztę załadunku na pakę.", "info")

                local text=ui.miniLetters[ui.maxCarts]
                local data=getElementData(localPlayer, "user:jobs_todo") or {}
                data[1]={name="Udaj się po wózek "..text}
                data[2]={name="Zaprowadź wózek do pojazdu "..text}
                data[3]={name="Wnieś wózek na pakę pojazdu "..text}
                setElementData(localPlayer, "user:jobs_todo", data, false)

                triggerLatentServerEvent("destroy.cart", resourceRoot)
            end

            checkAndDestroy(ui.markers["veh"])
            ui.markers["veh"]=nil

            setElementFrozen(localPlayer, false)

            ui.loading=false
        end, 10000, 1)
    else
        for i,v in pairs(ui.markers) do
            if(source == v and string.find(i, "point"))then
                if(ui.haveCart)then
                    local upgrades=fromJSON(ui.info.upgrades) or {}
                    local id_minigame=upgrades["Przewóz diamentów"] and 2 or upgrades["Przewóz złota"] and 2 or 1
                    local vv=ui.minigames[id_minigame]
                    if(vv)then
                        ui.gameRender={id=id_minigame,variables={i,v}}
                        ui.minigames[id_minigame].variables={
                            rot=0,
                            positions={},
                            opened=false,
                            selected=false,
                            click=false,
                        }

                        if(id_minigame == 1)then
                            for i=1,3 do
                                vv.variables.positions[#vv.variables.positions+1]={sw-math.random(150,800),sh/2-78/2/zoom,102/zoom,78/zoom}
                            end
                        else
                            vv.variables={
                                myCode="",
                                code=tostring(math.random(0,9)..math.random(0,9)..math.random(0,9)..math.random(0,9))
                            }
                        end
                    end

                    showCursor(true)
                else
                    noti:noti("Najpierw wyciągnij wózek z pojazdu.", "error")
                end

                break
            end
        end
    end
end

ui.onColShapeHit=function(hit, dim)
    if(hit ~= localPlayer or not dim)then return end

    if(SPAM.getSpam())then return end

    if(source == ui.zones["baza"])then
        triggerLatentServerEvent("reverse.job", resourceRoot, hit, ui.info)

        destroyElement(ui.zones["baza"])
        ui.zones["baza"]=nil

        destroyElement(ui.blips["baza"])
        ui.blips["baza"]=nil
    else
        for i,v in pairs(ui.zones) do
            if(source == v and string.find(i, "point"))then
                local data=getElementData(localPlayer, "user:jobs_todo") or {}
                data[4].done=true
                setElementData(localPlayer, "user:jobs_todo", data, false)
            end
        end
    end
end

ui.timerElement=false
ui.onTimer=function()
    local data=getElementData(localPlayer, "user:jobBackTime") or 60
    if(data <= 0)then
        triggerLatentServerEvent("stop.job", resourceRoot, localPlayer)
        return
    else
        setElementData(localPlayer, "user:jobBackTime", data-1, false)
    end
end

ui.onRender=function()
    -- q buttons
    if(not ui.haveCart and #ui.carts > 0)then
        local size=0.3
        for i,v in pairs(ui.carts) do
            local x,y,z=getElementPosition(v)
            z=z+1
            z=interpolateBetween(z-0.1, 0, 0, z+0.1, 0, 0, (getTickCount()-ui.tick)/1500, "SineCurve")
            dxDrawMaterialLine3D(x,y,z+size,x,y,z,assets.textures[26],size,tocolor(255,255,255))
        end
    end

    if(ui.vehicle and isElement(ui.vehicle))then
        if(getPedOccupiedVehicle(localPlayer) ~= ui.vehicle)then
            local myPos={getElementPosition(localPlayer)}
            local vPos={getElementPosition(ui.vehicle)}
            local dist=getDistanceBetweenPoints3D(myPos[1], myPos[2], myPos[3], vPos[1], vPos[2], vPos[3])
            local data=getElementData(localPlayer, "user:jobBackTime")
            if(dist > 50)then
                if(not ui.timerElement)then
                    ui.timerElement=setTimer(ui.onTimer,1000,0)
                end
            else
                if(getElementData(localPlayer, "user:jobBackTime"))then
                    setElementData(localPlayer, "user:jobBackTime", false, false)

                    if(ui.timerElement and isTimer(ui.timerElement))then
                        killTimer(ui.timerElement)
                    end
                    ui.timerElement=false
                end
            end
        else
            if(getElementData(localPlayer, "user:jobBackTime"))then
                setElementData(localPlayer, "user:jobBackTime", false, false)

                if(ui.timerElement and isTimer(ui.timerElement))then
                    killTimer(ui.timerElement)
                end
                ui.timerElement=false
            end
        end
    else
        triggerLatentServerEvent("stop.job", resourceRoot, localPlayer)
    end

    -- tablet
    if(not isPedInVehicle(localPlayer) and #ui.loadingCarts > 0)then
        local x,y=420/zoom, sh-300/zoom

        local progress=0
        for i,v in pairs(ui.loadingCarts) do
            if(not v.block)then
                progress=((getTickCount()-v.tick)/10600)*100
                break
            end
        end

        dxDrawImage(x, y, 426/zoom, 291/zoom, assets.textures[1])
        dxDrawImageSection(x, y, (426/zoom)*(progress/100), 291/zoom, 0, 0, (426)*(progress/100), 291, assets.textures[2])
        dxDrawImage(x, y, 426/zoom, 291/zoom, assets.textures[3])

        local upgrades=fromJSON(ui.info.upgrades) or {}
        local id=upgrades["Przewóz diamentów"] and 12 or upgrades["Przewóz złota"] and 11 or 10
        local name=upgrades["Przewóz diamentów"] and "DIAMENTY" or upgrades["Przewóz złota"] and "ZŁOTO" or "GOTÓWKA"
        local hex=upgrades["Przewóz diamentów"] and "#57addd" or upgrades["Przewóz złota"] and "#ffce54" or "#3c9a57"
        local text=(ui.gameRender and ui.gameRender.id == 2) and ui.minigames[2].variables.code or "PRZEWÓZ: "..hex..name
        dxDrawShadowText(text, x, y+30/zoom, x+426/zoom, 291/zoom, tocolor(200, 200, 200), 1, assets.fonts[1], "center", "top", false, false, false, true)
        
        local w,h=dxGetMaterialSize(assets.textures[id])
        dxDrawImage(x+(426-w)/2/zoom, y+94/zoom, w/zoom, h/zoom, assets.textures[id])

        local a=interpolateBetween(150,0,0,255,0,0,(getTickCount()-ui.loadingCarts[1].tick)/1000,"SineCurve")
        if(ui.loading)then
            dxDrawShadowText(ui.loading, x, y+173/zoom, x+426/zoom, 291/zoom, tocolor(200, 200, 200, a), 1, assets.fonts[1], "center", "top", false, false, false, true)
        end

        local k=#ui.loadingCarts+1
        for i=(-#ui.loadingCarts/2)+1,#ui.loadingCarts/2 do
            k=k-1
            
            local v=ui.loadingCarts[k]
            if(v)then
                local sX=(58/zoom)*(i-1)
                local aa=not v.loaded and 70 or 200
                if(not v.block)then
                    aa=aa > a and aa or a
                end

                dxDrawImage(x+(426-40)/2/zoom+sX+30/zoom, y+205/zoom, 40/zoom, 37/zoom, assets.textures[4], 0, 0, 0, tocolor(255, 255, 255, aa))
                dxDrawImage(x+(426-40)/2/zoom+sX+30/zoom+(40)/2/zoom+2, y+205/zoom+46/zoom, 4, 4, not v.loaded and assets.textures[6] or assets.textures[5])

                if((getTickCount()-v.tick) > v.time and not v.block)then
                    v.loaded=true
                    v.block=true
                end
            end
        end
    end

    -- minigame
    if(ui.gameRender)then
        local v=ui.minigames[ui.gameRender.id]
        v.render(v.variables, v.renderPositions, v.resetVariables)
    end
end

addEvent("start.job", true)
addEventHandler("start.job", resourceRoot, function(info, carts, atms, veh)
    setElementData(localPlayer, "user:jobBackTime", false, false)

    local upgrades=fromJSON(info.upgrades) or {}
    ui.pointsType=upgrades["Przewóz diamentów"] and "warehouse" or upgrades["Przewóz złota"] and "warehouse" or "atm"

    ui.haveCart=false

    ui.loading=false
    ui.loadingTick=0
    ui.loadingCarts={}

    ui.info=info
    ui.vehicle=veh

    ui.saveCarts=#carts
    ui.maxCarts=#carts

    for i=1,#carts do
        ui.loadingCarts[i]={block=true, loaded=false, tick=getTickCount(), time=10000}
    end

    ui.atms = {}

    for i,v in ipairs(atms) do
        local zone=getZoneName(v[1],v[2],v[3],true)
        if(zone ~= "San Fierro")then
            table.insert(ui.atms, v)
        end
    end

    assets.create()

    addEventHandler("onClientMarkerHit", resourceRoot, ui.onMarkerHit)
    addEventHandler("onClientColShapeHit", resourceRoot, ui.onColShapeHit)
    addEventHandler("onClientRender", root, ui.onRender)
    addEventHandler("onClientPlayerWasted", localPlayer, wasted)

    local text=ui.miniLetters[#carts]
    local data=getElementData(localPlayer, "user:jobs_todo") or {}
    data={
        {name="Udaj się po wózek "..text},
        {name="Zaprowadź wózek do pojazdu "..text},
        {name="Wnieś wózek na pakę pojazdu "..text},
        {name="Udaj się do punktu "..text},
        {name="Wyjmij wózek i zanieś go do punktu "..text},
        {name="Wróć na bazę gruppe6"},
    }
    setElementData(localPlayer, "user:jobs_todo", data, false)

    bindKey("Q", "down", ui.getCart)
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
    removeEventHandler("onClientPlayerWasted", localPlayer, wasted)

    for i,v in pairs(ui.blips) do
        checkAndDestroy(v)
    end
    ui.blips={}

    for i,v in pairs(ui.markers) do
        checkAndDestroy(v)
    end
    ui.markers={}

    assets.destroy()

    unbindKey("Q", "down", ui.getCart)

    for i,v in pairs(ui.carts) do
        ui.destroyCart(i)
    end
end
addEvent("stop.job", true)
addEventHandler("stop.job", resourceRoot, stopJob)

addEvent("vehicle.point", true)
addEventHandler("vehicle.point", resourceRoot, function(cart, veh)
    local data=getElementData(localPlayer, "user:jobs_todo") or {}
    data[1].done=true
    setElementData(localPlayer, "user:jobs_todo", data, false)

    for i,v in pairs(ui.blips) do
        if(v == cart)then
            destroyElement(v)
            ui.blips[v]=nil
        end
    end

    ui.markers["veh"]=createMarker(0,0,0,"cylinder", 1.5, 0, 255, 0)
    attachElements(ui.markers["veh"], veh, 0, -5, 0)
    setElementData(ui.markers["veh"], "icon", ":px_jobs-escort/textures/marker-konwoj.png")
end)

addEvent("change.status", true)
addEventHandler("change.status", resourceRoot, function(status)
    ui.haveCart=status
end)

addEvent("create.cart", true)
addEventHandler("create.cart", resourceRoot, ui.createCart)

addEvent("destroy.cart", true)
addEventHandler("destroy.cart", resourceRoot, ui.destroyCart)

addEventHandler("onClientVehicleStartEnter", resourceRoot, function()
    if(#ui.carts > 0)then
        cancelEvent()
    end
end)