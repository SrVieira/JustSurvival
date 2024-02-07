
------------------------------------------------
-- System wyścigów, clientside
-- Autor: northez
-- Wykonano dla projektu Project X
------------------------------------------------

Race = {}

local CurrentRace = {}
local Checkpoints = {}

local Data = {
    font = nil,
    fontHeight = 0,
    
    rtSize = 500,
    poleHeight = 300,

    renderTarget = nil,
}

local lx,ly,lz = 0,0,0
local currentCheckpoint = 1
local blockade = false

local currentMarker,nextMarker,currentMarkerBlip,currentFotoradar_1,currentFotoradar_2 = nil,nil,nil,nil
function Race.drawCheckpoint()
    dxSetRenderTarget(Data.renderTarget,true)
    
    local ccp = tonumber(currentCheckpoint) or 1
    
    local blackLine = dxGetTextWidth("PUNKT KONTROLNY",1,Data.font)*1.05
    dxDrawRectangle(Data.rtSize/2-blackLine/2,0,blackLine,Data.fontHeight,tocolor(0,0,0,190))

    if currentCheckpoint == #CurrentRace.list then
        dxDrawText("META",0+1,0+1,Data.rtSize+1,0+1,tocolor(0,0,0),1,Data.font,"center")
        dxDrawText("META",0,0,Data.rtSize,0,tocolor(255,255,205),1,Data.font,"center","top",false,false,false,true)
    else
        dxDrawText("PUNKT KONTROLNY",0+1,0+1,Data.rtSize+1,0+1,tocolor(0,0,0),1,Data.font,"center","top",false,false,false,true)
        dxDrawText("PUNKT KONTROLNY",0,0,Data.rtSize,0,white,1,Data.font,"center","top",false,false,false,true)
    end

    dxDrawRectangle(0, Data.rtSize-Data.poleHeight, Data.rtSize, Data.poleHeight, tocolor(100,255,100, 200))

    dxDrawRectangle(0,Data.rtSize-Data.poleHeight,10,Data.poleHeight,white)
    dxDrawRectangle(Data.rtSize-10,Data.rtSize-Data.poleHeight,10,Data.poleHeight,white)

    dxDrawRectangle(0,Data.rtSize-Data.poleHeight,3,Data.poleHeight,tocolor(100,255,100))
    dxDrawRectangle(Data.rtSize-3,Data.rtSize-Data.poleHeight,3,Data.poleHeight,tocolor(100,255,100))

    dxSetRenderTarget()
end

local function renderCheckpoints()
    local veh = getPedOccupiedVehicle(localPlayer)
    if(not veh)then
        Race.stop()
        stopCutscene()
        return
    end

    local ms=(getTickCount()-CurrentRace.startTime)
    ms=convertTime(ms) or "0:00:00"

    local lastTime=(1000*30)-(getTickCount()-CurrentRace.timerTime)
    lastTime=convertTime(lastTime) or "0:00:00"

    if(CurrentRace.type == "fotoradar")then
        dxDrawText("Zebrane punkty:\n"..string.format("%.1f", CurrentRace.points).."/10", 0+1, sy-60/zoom+1, sx+1, sy-10/zoom+1, tocolor(0,0,0), 1, Assets.Fonts[2], "center", "bottom")
        dxDrawText("Zebrane punkty:\n#ffb81f"..string.format("%.1f", CurrentRace.points).."/10", 0, sy-60/zoom, sx, sy-10/zoom, tocolor(200,200,200), 1, Assets.Fonts[2], "center", "bottom", false, false, false, true)
        dxDrawText("Czas do zakończenia: "..lastTime, 0+1, sy-80/zoom+1, sx+1, sy-70/zoom+1, tocolor(0,0,0), 1, Assets.Fonts[1], "center", "bottom")
        dxDrawText("Czas do zakończenia: #7a0000"..lastTime, 0, sy-80/zoom, sx, sy-70/zoom, tocolor(200,200,200), 1, Assets.Fonts[1], "center", "bottom", false, false, false, true)
    else
        dxDrawText("Aktualny czas:\n"..ms, 0+1, sy-60/zoom+1, sx+1, sy-10/zoom+1, tocolor(0,0,0), 1, Assets.Fonts[2], "center", "bottom")
        dxDrawText("Aktualny czas:#ffb81f\n"..ms, 0, sy-60/zoom, sx, sy-10/zoom, tocolor(200,200,200), 1, Assets.Fonts[2], "center", "bottom", false, false, false, true)
        dxDrawText("Czas do zakończenia: "..lastTime, 0+1, sy-80/zoom+1, sx+1, sy-70/zoom+1, tocolor(0,0,0), 1, Assets.Fonts[1], "center", "bottom")
        dxDrawText("Czas do zakończenia: #7a0000"..lastTime, 0, sy-80/zoom, sx, sy-70/zoom, tocolor(200,200,200), 1, Assets.Fonts[1], "center", "bottom", false, false, false, true)
    end

    if not currentMarker then return end

    local mx,my,mz = getElementPosition(currentMarker)
    local px,py,pz = getCameraMatrix(localPlayer)
    local distance = getDistanceBetweenPoints3D(mx,my,mz,px,py,pz)

    if distance < 200 then
        local scale = 195 + (100 / math.max(math.min(distance,50),2) * 2)

        local textSize = 14
        dxDrawMaterialLine3D(
            mx,
            my,
            mz + textSize / 2,
            mx,
            my,
            mz - textSize / 2,
            Data.renderTarget,
            textSize,
            tocolor(255,255,255,scale),
            px,
            py,
            pz
        )
    end

    if nextMarker then
        mx,my,mz = getElementPosition(nextMarker)
        px,py,pz = getCameraMatrix(localPlayer)
        distance = getDistanceBetweenPoints3D(mx,my,mz,px,py,pz)

        if distance < 200 then
            local scale = 55 + (100 / math.max(math.min(distance,50),2) * 2)

            local textSize = 14
            dxDrawMaterialLine3D(
                mx,
                my,
                mz + textSize / 2,
                mx,
                my,
                mz - textSize / 2,
                Data.renderTarget,
                textSize,
                tocolor(255,255,255,scale),
                lx,
                ly,
                lz
            )
        end
    end
end

function Race.getAward(race, points)
    if(CurrentRace.startTime == 0 or not race)then return end

    local ms=(getTickCount()-CurrentRace.startTime)
    triggerServerEvent("Race.update", resourceRoot, race, ms, points)

    exports.px_noti:noti("Pomyślnie zakończono wyścig i zapisano wynik.", "success")
end

function Race.hitCheckpoint()
    local veh=getPedOccupiedVehicle(localPlayer)
    if(not veh)then return end

    if(getElementData(localPlayer,"user:admin") and getElementData(localPlayer,"user:admin") < 4)then return end

    if(currentFotoradar_1)then
        local speed=getElementSpeed(veh)
        local maxSpeed=250
        local minSpeed=100
        if(speed > minSpeed)then
            fadeCamera(false,0.1,255,255,255)
            setTimer(fadeCamera,60,1,true,1.5)
            destroyAndCheckElement(currentFotoradar_1)
            destroyAndCheckElement(currentFotoradar_2)
            currentFotoradar_1=nil
            currentFotoradar_2=nil

            speed=speed > maxSpeed and maxSpeed or speed

            local point=0.4*((speed-minSpeed)/(maxSpeed-minSpeed))
            CurrentRace.points=CurrentRace.points+point
            if(CurrentRace.points > 10)then
                CurrentRace.points=10
            end
        else
            exports.px_noti:noti("Minimalna prędkość wynosi 100km/h!", "error")
            return
        end    
    end

    if(CurrentRace.timer)then
        killTimer(CurrentRace.timer)
    end
    CurrentRace.timerTime=getTickCount()
    CurrentRace.timer=setTimer(Race.stop, (1000*30), 1)

    local list = CurrentRace.list
    local p = list[currentCheckpoint]

    if(currentCheckpoint >= (#CurrentRace.list-3) and not Cutscene.Recording)then
        startCutscene()
    end

    local CPOS={0,0,0}
    if currentMarker then
        if isElement(currentMarker) then
            CPOS={getElementPosition(currentMarker)}
            destroyElement(currentMarker)
        end

        currentMarker = nil
    end

    if nextMarker then
        if isElement(nextMarker) then
            destroyElement(nextMarker)
        end

        nextMarker = nil
    end

    if currentMarkerBlip then
        destroyElement(currentMarkerBlip)
        currentMarkerBlip = nil
    end

    if currentCheckpoint > #CurrentRace.list then
        Race.getAward(CurrentRace.id,CurrentRace.points)
        Cutscene.stop(CPOS,CurrentRace.positions[1])
        Race.stop()
        return
    end

    currentMarker = createMarker(p[1],p[2],p[3]-0.5,"cylinder",8,0,0,0,0)
    currentMarker.id = CurrentRace.id.."_checkpoint_"..currentCheckpoint
    currentMarkerBlip = createBlip(p[1],p[2],p[3],19)
    setElementData(currentMarker,"settings",{offIcon=true,offPlace=true},false)

    if(CurrentRace.type == "fotoradar")then
        local ps_1=getLeftPosition(currentMarker, p[4], 6)
        local ps_2=getRightPosition(currentMarker, p[4], 6)
        currentFotoradar_1=createObject(16101, ps_1[1], ps_1[2], ps_1[3]-1.1, 0, 0, p[4])
        currentFotoradar_2=createObject(16101, ps_2[1], ps_2[2], ps_2[3]-1.1, 0, 0, p[4])
    end

    p = list[currentCheckpoint + 1]

    if currentCheckpoint + 1 <= #CurrentRace.list then
        nextMarker = createMarker(p[1],p[2],p[3]-0.5,"cylinder",8,0,0,0,0)
    end

    if currentCheckpoint == 1 then
        lx,ly,lz = unpack(CurrentRace.positions[1])
    else
        lx,ly,lz = unpack(CurrentRace.list[currentCheckpoint-1])
    end

    Race.drawCheckpoint()
end

addEventHandler("onClientMarkerHit",resourceRoot,function(plr)
    if plr == localPlayer then
        if isElement(currentMarker) and source == currentMarker then
            if blockade then return end
        
            blockade = true
            setTimer(function()
                blockade = false
            end,500,1)
        
            currentCheckpoint = currentCheckpoint + 1

            Race.hitCheckpoint()

            local sound = playSound("files/checkpoint.wav")
            setSoundVolume(sound,3)
        end
    end
end)

function Race.start(raceID)
    local table = List[raceID]
    if not table then return end

    local veh = getPedOccupiedVehicle(localPlayer)
    if(not veh)then return end

    if(getElementSpeed(veh) > 1)then
        exports.px_noti:noti("Najpierw się zatrzymaj!", "error")
        return
    end

    if(CurrentRace.id)then return end

    if(CurrentRace.timer)then
        killTimer(CurrentRace.timer)
    end

    exports.px_noti:noti("Pomyślnie rozpoczęto wyścig: "..table.name..".", "success")

    CurrentRace = {
        id = raceID,
        positions = table.positions,
        list = table.checkpoints,
        name = table.name,
        timer=setTimer(Race.stop, (1000*30), 1),
        startTime=getTickCount(),
        points=0,
    }

    CurrentRace.timerTime=getTickCount()
    CurrentRace.type=table.type

    currentCheckpoint = 1

    setElementPosition(veh,table.positions[1][1],table.positions[1][2],table.positions[1][3])
    setElementRotation(veh,0,0,table.positions[1][4])

    setElementData(veh,"ghost","all")
    
    Data.font = dxCreateFont(":px_assets/fonts/Font-Medium.ttf",30)
    Data.renderTarget = dxCreateRenderTarget(Data.rtSize,Data.rtSize,true)
    Data.fontHeight = dxGetFontHeight(1,Data.font)

    Race.drawCheckpoint()
    addEventHandler("onClientRender",root,renderCheckpoints)

    Race.hitCheckpoint()

    toggleControl("enter_exit", false)
end

function Race.stop()
    destroyAndCheckElement(currentMarker)
    destroyAndCheckElement(currentMarkerBlip)
    destroyAndCheckElement(currentFotoradar_1)
    destroyAndCheckElement(currentFotoradar_2)
    currentMarker=nil
    currentMarkerBlip=nil
    currentFotoradar_1=nil
    currentFotoradar_2=nil

    removeEventHandler("onClientRender",root,renderCheckpoints)

    if(CurrentRace.timer)then
        killTimer(CurrentRace.timer)
    end

    CurrentRace = {}
    currentCheckpoint = 1

    toggleControl("enter_exit", true)

    local veh = getPedOccupiedVehicle(localPlayer)
    if(not veh)then return end

    setElementData(veh,"ghost",false)
end

-- useful

function getElementSpeed(theElement, unit)
    local vx,vy,vz=getElementVelocity(theElement)
    local speed=math.sqrt(vx^2 + vy^2 + vz^2) * 180
    return speed
end

function destroyAndCheckElement(element)
    if element and isElement(element) then
        destroyElement(element); element = nil

        return true
    else
        return false
    end
end

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end

function getLeftPosition(element, rot, plus)
    rot=rot+90

    local x,y,z = getElementPosition(element)
    local cx, cy = getPointFromDistanceRotation(x, y, plus, -rot)
    return {cx,cy,z}
end

function getRightPosition(element, rot, plus)
    rot=rot+90

    local x,y,z = getElementPosition(element)
    local cx, cy = getPointFromDistanceRotation(x, y, plus, -(rot+180))
    return {cx,cy,z}
end

function getElementSpeed(theElement, unit)
    local vx,vy,vz=getElementVelocity(theElement)
    local speed=math.sqrt(vx^2 + vy^2 + vz^2) * 180
    return speed
end