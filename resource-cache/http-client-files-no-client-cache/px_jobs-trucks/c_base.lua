--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Project X (MTA)
]]

ui.getPoint=function(id)
    local r=ui.zones[id]
    if(r and isElement(r))then
        local el=getElementsWithinColShape(r, "vehicle")
        if(#el >= 2)then
            triggerServerEvent("checkTrailerAndVehicle", resourceRoot, el)
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
end

ui.getBlipPosition=function(v,xywh)
    local x,y,w,h=unpack(xywh)
    local pos=isElement(v) and {getElementPosition(v)} or v
    local p1,p2=pos[1]+3000,pos[2]-3000
    local p1,p2=x+(w*(p1/6000)),y+(h*(p2/-6000))
    return p1,p2
end

ui.startExit=function()
    cancelEvent()
end

ui.elapsedTimeRender=function()
    local elapsedTime=ui.elapsedTime-((getTickCount()-ui.elapsedTimeTick)/1000)
    if(elapsedTime <= 0 and ui.info)then
        ui.info=false
    
        removeEventHandler("onClientRender", root, ui.elapsedTimeRender)
        removeEventHandler("onClientVehicleStartExit", root, ui.startExit)

        setElementFrozen(ui.vehicle, false)

        assets.destroy()

        triggerServerEvent("destroyTrailer", resourceRoot)
    else
        dxDrawText(math.floor(elapsedTime), 1, 1, sw+1, sh+1, tocolor(0, 0, 0), 1, assets.fonts[3], "center", "center")
        dxDrawText(math.floor(elapsedTime), 0, 0, sw, sh, tocolor(200, 200, 200), 1, assets.fonts[3], "center", "center")
    end
end

ui.render=function()
    local p=ui.pos

    blur:dxDrawBlur(p[1][1], p[1][2], p[1][3], p[1][4])
    dxDrawImage(p[1][1], p[1][2], p[1][3], p[1][4], assets.textures[1])

    -- left
    dxDrawImage(p[2][1], p[2][2], p[2][3], p[2][4], ui.mapTexture)
    
    local x,y=ui.getBlipPosition(localPlayer, {p[2][1], p[2][2], p[2][3], p[2][4]})
    dxDrawImage(x-p["blip"][1]/2, y-p["blip"][1]/2, p["blip"][1], p["blip"][1], assets.textures[12])

    dxDrawImage(p[3][1]+1, p[3][2], p[3][3], p[3][4], assets.textures[2])
    dxDrawText("Informacje o dostawie", p[4][1], p[4][2], p[4][3], p[4][4], tocolor(200, 200, 200), 1, assets.fonts[1], "left", "center")

    local v=ui.selected
    if(v)then
        local x,y=ui.getBlipPosition(v.trailer, {p[2][1], p[2][2], p[2][3], p[2][4]})
        dxDrawImage(x-p["blip"][2]/2, y-p["blip"][2]/2, p["blip"][2], p["blip"][2], assets.textures[10])
        local x,y=ui.getBlipPosition(v.point.pos, {p[2][1], p[2][2], p[2][3], p[2][4]})
        dxDrawImage(x-p["blip"][2]/2, y-p["blip"][2]/2, p["blip"][2], p["blip"][2], assets.textures[11])

        local elapsedTime=(ui.tick-v.info.endTime)
        elapsedTime=math.abs(math.floor(elapsedTime/1000))

        local hours = math.floor(elapsedTime / 3600)
        local minutes = math.floor((elapsedTime / 60) % 60)
        local seconds = math.floor(elapsedTime % 60)
        local time=(hours > 0 and hours.."h " or "")..((hours > 0 or minutes > 0) and minutes.."m " or "")..seconds.."s"

        local i=v.info.type == "petrol" and 7 or v.info.type == "wood" and 8 or v.info.type == "cars" and 9

        local infos={
            [1]="Ładunek: "..ui.types[v.info.type].."\nWynagrodzenie: $"..v.info.cost.."\nCena za km: $"..v.info.costForKM.."\nWaga ładunku: "..v.info.weight.."KG",
            [2]="Zleceniodawca: Magazyn\nZ: "..v.info.fromName.."\nDo: "..v.info.toName.."\nDystans: "..math.floor(v.info.distance).."m",
            [3]="Pozostały czas: "..time.."\nWymagane ulepszenia:"..(not i and "\nbrak" or ""),
        }
        dxDrawText(infos[1], p[5][1], p[5][2], p[5][3], p[5][4], tocolor(200, 200, 200), 1, assets.fonts[1], "left", "top")
        dxDrawText(infos[2], p[6][1], p[6][2], p[6][3], p[6][4], tocolor(200, 200, 200), 1, assets.fonts[1], "left", "top")
        dxDrawText(infos[3], p[7][1], p[7][2], p[7][3], p[7][4], tocolor(200, 200, 200), 1, assets.fonts[1], "left", "top")

        if(i)then
            local w,h=dxGetMaterialSize(assets.textures[i])
            w,h=w/4,h/4
            dxDrawImage(p[8][1], p[8][2], w/zoom, h/zoom, assets.textures[i], 0, 0, 0, tocolor(200, 200, 200))
        end

        dxDrawImage(p[9][1]+1, p[9][2], p[9][3], p[9][4], assets.textures[3], 0, 0, 0, tocolor(255, 255, 255, isMouseInPosition(p[9][1]+1, p[9][2], p[9][3], p[9][4]) and 200 or 255))
        dxDrawText("ROZPOCZNIJ", p[9][1], p[9][2], p[9][3]+p[9][1], p[9][4]+p[9][2], tocolor(200, 200, 200), 1, assets.fonts[2], "center", "center")

        onClick(p[9][1]+1, p[9][2], p[9][3], p[9][4], function()
            local type=v.info.type == "petrol" and "Ropa" or v.info.type == "wood" and "Drewno" or v.info.type == "cars" and "Samochody"
            if(not type or (type and ui.upgrades[type]))then
                triggerServerEvent("setOrderOwner", resourceRoot, v.id, localPlayer, v.info.type)
            else
                noti:noti("Nie posiadasz potrzebnego ulepszenia.", "error")
            end
        end)
    end

    -- right
    local x=0
    local row=math.floor(scroll:dxScrollGetPosition(ui.scroll))+1
    for i=row,row+ui.maxRows do
        local v=ui.orders[i]
        if(v)then
            x=x+1

            local sY=p[10][5]*(x-1)
            dxDrawImage(p[10][1], p[10][2]+sY, p[10][3], p[10][4], ui.selected == v and assets.textures[5] or assets.textures[4], 0, 0, 0, tocolor(255, 255, 255, isMouseInPosition(p[10][1], p[10][2]+sY, p[10][3], p[10][4]) and 200 or 255))

            dxDrawText(ui.types[v.info.type].."\n#48d058$#dedede"..v.info.cost, p[10][1]+p[10][6], p[10][2]+sY, p[10][3], p[10][4]+p[10][2]+sY, tocolor(200, 200, 200), 1, assets.fonts[1], "left", "center", false, false, false, true)

            local info=v.info.type == "petrol" and 7 or v.info.type == "wood" and 8 or v.info.type == "cars" and 9
            if(info)then
                local w,h=dxGetMaterialSize(assets.textures[info])
                local sX=p[11][3]*(i-1)
                w,h=w/4,h/4
                dxDrawImage(p[11][1], p[11][2]+sY+(p[10][4]-h/zoom)/2, w/zoom, h/zoom, assets.textures[info], 0, 0, 0, tocolor(200, 200, 200))
            end

            dxDrawText(v.info.fromName, p[10][1]+p[11][4], p[10][2]+sY, p[10][3], p[10][4]+p[10][2]+sY, tocolor(200, 200, 200), 1, assets.fonts[1], "left", "center", false, false, false, true)
            dxDrawImage(p[12][1], p[12][2]+sY, p[12][3], p[12][4], assets.textures[6])
            dxDrawText(v.info.toName, p[10][1]+p[11][4]+p[12][5], p[10][2]+sY, p[10][3], p[10][4]+p[10][2]+sY, tocolor(200, 200, 200), 1, assets.fonts[1], "left", "center", false, false, false, true)

            onClick(p[10][1], p[10][2]+sY, p[10][3], p[10][4], function()
                ui.selected=v
            end)
        end
    end
end

addEvent("createPoints", true)
addEventHandler("createPoints", resourceRoot, function(r)
    ui.blips["from"]=createBlip(r.trailer[1], r.trailer[2], r.trailer[3], 36)

    noti:noti("Udaj się odebrać zlecenie.", "info")

    ui.info=r
end)

addEvent("stopTrailer", true)
addEventHandler("stopTrailer", resourceRoot, function()
    if(ui.zones["point"])then
        checkAndDestroy(ui.blips["point"])
        ui.blips["point"]=nil

        checkAndDestroy(ui.zones["point"])
        ui.zones["point"]=nil

        assets.create()

        setElementFrozen(ui.vehicle, true)

        ui.elapsedTimeTick=getTickCount()

        addEventHandler("onClientRender", root, ui.elapsedTimeRender)
        addEventHandler("onClientVehicleStartExit", root, ui.startExit)
    end
end)

addEvent("attachTrailer", true)
addEventHandler("attachTrailer", resourceRoot, function()
    if(not ui.blips["from"] or ui.zones["point"])then return end

    checkAndDestroy(ui.blips["from"])
    ui.blips["from"]=nil

    noti:noti("Następnie udaj się zawieźć naczepe w wskazane miejsce.", "info")

    if(ui.info)then
        local r=ui.info
        ui.blips["point"]=createBlip(r.point.pos[1], r.point.pos[2], r.point.pos[3], 37)
        ui.zones["point"]=createColPolygon(unpack(r.point.shape))

        addEventHandler("onClientRender", root, c.render)
    end
end)

addEvent("togglePanel", true)
addEventHandler("togglePanel", resourceRoot, function(orders, tick)
    if(orders)then
        blur=exports.blur
        scroll=exports.px_scroll

        ui.mapTexture=exports.px_map:getMapTexture()

        updatePos()
        
        assets.create()
        addEventHandler("onClientRender", root, ui.render)
        ui.orders=orders
        showCursor(true,false)

        ui.tick=tick

        local p=ui.pos
        ui.scroll=scroll:dxCreateScroll(p[10][1]+p[10][3]-4/zoom, p[10][2], 4/zoom, 4/zoom, 0, 11, ui.orders, p[1][4], 255)
    else
        assets.destroy()
        removeEventHandler("onClientRender", root, ui.render)
        ui.orders={}
        showCursor(false)

        scroll:dxDestroyScroll(ui.scroll)
    end
end)

addEvent("start.job", true)
addEventHandler("start.job", resourceRoot, function(vehicle, upgrades)
    setElementData(localPlayer, "user:jobBackTime", false, false)

    addEventHandler("onClientRender", root, ui.onRender)
    addEventHandler("onClientPlayerWasted", localPlayer, wasted)

    ui.upgrades=upgrades
    ui.vehicle=vehicle
end)

function wasted()
    triggerLatentServerEvent("stop.job", resourceRoot)
    stopJob()
end

function stopJob()
    setElementData(localPlayer, "user:jobBackTime", false, false)
    
    ui.upgrades={}

    removeEventHandler("onClientRender", root, ui.render)
    removeEventHandler("onClientRender", root, ui.onRender)
    removeEventHandler("onClientPlayerWasted", localPlayer, wasted)

    for i,v in pairs(ui.blips) do
        checkAndDestroy(v)
    end
    ui.blips={}

    for i,v in pairs(ui.zones) do
        checkAndDestroy(v)
    end
    ui.zones={}

    ui.vehicle=false
end
addEvent("stop.job", true)
addEventHandler("stop.job", resourceRoot, stopJob)

addEvent("updateOrders", true)
addEventHandler("updateOrders", resourceRoot, function(orders, tick)
    ui.orders=orders
    ui.tick=tick
end)