--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local sx,sy = guiGetScreenSize()
local sw,sh=guiGetScreenSize()
local s = function(n) return n/zoom end

local fh = 1920

if sw < fh then
  zoom = math.min(2,fh/sw)
end

Cutscene = {
    Recorded = {},
    Animation = {},

    startPos = {0,0,0},
    startRot = {0,0,0},
    vehModel = nil,

    Cam={},
    car=false,

    info=false
}

local ct = 0

function Cutscene.record()
    local x,y,z = getElementPosition(getPedOccupiedVehicle(localPlayer))
    local rx,ry,rz = getElementRotation(getPedOccupiedVehicle(localPlayer))

    table.insert(Cutscene.Recorded,{x,y,z,rx,ry,rz})
end

function Cutscene.summary()
    if(getKeyState("space"))then
        stopCutscene()
        return
    end

    -- cam

    if(Cutscene.car and isElement(Cutscene.car))then
        local x,y,z=unpack(Cutscene.Cam)
        local rot=findRotation(Cutscene.car,x,y)
        local cam={getPointFromDistanceRotation(x,y, 15, 180-rot)}
        setCameraMatrix(x,y,z+15,cam[1],cam[2],z+10)
    end

    local c=Cutscene.info or {}

    -- draw
    dxDrawImage(sw-1214/zoom,0,1214/zoom,1080/zoom,Assets.Textures.rights)

    local myTime=convertTime(c.ms) or "0:00:00"
    dxDrawText("Czas przejazdu", 0, 205/zoom, sw-216/zoom, 0, tocolor(200,200,200),1,Assets.Fonts[6],"right", "top")
    dxDrawText(myTime, 0, 234/zoom, sw-216/zoom, 0, tocolor(200,200,200),1,Assets.Fonts[5],"right", "top")

    if(c.bonus)then
        dxDrawImage(sw-315/zoom, 332/zoom, 98/zoom, 30/zoom, Assets.Textures["new-time"])
    end

    -- 2
    local t=c.top and c.top[2] or {login="brak",time=0}
    local av=exports.px_avatars:getPlayerAvatar(t.login)
    dxDrawImage(sw-500/zoom, 474/zoom, 62/zoom, 62/zoom, av)
    dxDrawImage(sw-500/zoom, 474/zoom, 62/zoom, 62/zoom, Assets.Textures.outline)
    dxDrawImage(sw-500/zoom+62/zoom-16/2/zoom, 474/zoom-16/2/zoom, 16/zoom, 16/zoom, Assets.Textures.st)
    dxDrawText("2", sw-500/zoom+62/zoom-16/2/zoom, 474/zoom-16/2/zoom, 16/zoom+sw-500/zoom+62/zoom-16/2/zoom, 16/zoom+474/zoom-16/2/zoom, tocolor(0, 0, 0), 1, Assets.Fonts[1], "center", "center")
    dxDrawText(t.login, sw-500/zoom, 474/zoom+67/zoom, 72/zoom+sw-500/zoom, 72/zoom, tocolor(200, 200, 200), 1, Assets.Fonts[1], "center", "top")
    --

    -- 1
    local t=c.top and c.top[1] or {login="brak",time=0}
    local av=exports.px_avatars:getPlayerAvatar(t.login)
    dxDrawImage(sw-400/zoom, 444/zoom, 72/zoom, 72/zoom, av)
    dxDrawImage(sw-400/zoom, 444/zoom, 72/zoom, 72/zoom, Assets.Textures.outline)
    dxDrawImage(sw-400/zoom+72/zoom-16/2/zoom, 444/zoom-16/2/zoom, 16/zoom, 16/zoom, Assets.Textures.st)
    dxDrawText("1", sw-400/zoom+72/zoom-16/2/zoom, 444/zoom-16/2/zoom, 16/zoom+sw-400/zoom+72/zoom-16/2/zoom, 16/zoom+444/zoom-16/2/zoom, tocolor(0, 0, 0), 1, Assets.Fonts[1], "center", "center")
    dxDrawText(t.login, sw-400/zoom, 444/zoom+75/zoom, 72/zoom+sw-400/zoom, 72/zoom, tocolor(200, 200, 200), 1, Assets.Fonts[1], "center", "top")
    --

    -- 3
    local t=c.top and c.top[3] or {login="brak",time=0}
    local av=exports.px_avatars:getPlayerAvatar(t.login)
    dxDrawImage(sw-300/zoom, 480/zoom, 62/zoom, 62/zoom, av)
    dxDrawImage(sw-300/zoom, 480/zoom, 62/zoom, 62/zoom, Assets.Textures.outline)
    dxDrawImage(sw-300/zoom+62/zoom-16/2/zoom, 480/zoom-16/2/zoom, 16/zoom, 16/zoom, Assets.Textures.st)
    dxDrawText("3", sw-300/zoom+62/zoom-16/2/zoom, 480/zoom-16/2/zoom, 16/zoom+sw-300/zoom+62/zoom-16/2/zoom, 16/zoom+480/zoom-16/2/zoom, tocolor(0, 0, 0), 1, Assets.Fonts[1], "center", "center")
    dxDrawText(t.login, sw-300/zoom, 480/zoom+67/zoom, 72/zoom+sw-300/zoom, 72/zoom, tocolor(200, 200, 200), 1, Assets.Fonts[1], "center", "top")
    --

    dxDrawImage(sw-520/zoom, 566/zoom, 308/zoom, 99/zoom, Assets.Textures.podium)
    -- 2
    local t=c.top and c.top[2] or {login="brak",time=0}
    local time=convertTime(t.time)
    dxDrawText("#7b7b7bCzas\n#2f2f2f"..time, sw-520/zoom, 566/zoom+50/zoom, sw-520/zoom+94/zoom, 566/zoom+99/zoom, tocolor(0, 0, 0), 1, Assets.Fonts[1], "center", "top", false, false, false, true)
    -- 1
    local t=c.top and c.top[1] or {login="brak",time=0}
    local time=convertTime(t.time)
    dxDrawText("#7b7b7bCzas\n#2f2f2f"..time, sw-520/zoom+99/zoom, 566/zoom+20/zoom, sw-520/zoom+308/zoom-99/zoom, 566/zoom+99/zoom, tocolor(0, 0, 0), 1, Assets.Fonts[1], "center", "center", false, false, false, true)
    -- 3
    local t=c.top and c.top[3] or {login="brak",time=0}
    local time=convertTime(t.time)
    dxDrawText("#7b7b7bCzas\n#2f2f2f"..time, sw-520/zoom+308/zoom-99/zoom, 566/zoom+50/zoom, sw-520/zoom+308/zoom, 566/zoom+99/zoom, tocolor(0, 0, 0), 1, Assets.Fonts[1], "center", "top", false, false, false, true)
    --

    dxDrawImage(sw-520/zoom, 566/zoom+111/zoom, 308/zoom, 47/zoom, Assets.Textures.your_time)
    dxDrawText(getPlayerName(localPlayer), sw-520/zoom+15/zoom, 566/zoom+111/zoom, sw-520/zoom+308/zoom, 566/zoom+111/zoom+47/zoom, tocolor(57,57,57),1,Assets.Fonts[6],"left", "center")
    dxDrawText(myTime, sw-520/zoom, 566/zoom+111/zoom, sw-520/zoom+308/zoom-15/zoom, 566/zoom+111/zoom+47/zoom, tocolor(57,57,57),1,Assets.Fonts[6],"right", "center")

    dxDrawImage(sw-520/zoom, sh-233/zoom, 307/zoom, 29/zoom, Assets.Textures.space)
end

function Cutscene.show()
    ct = ct + 1

    for i,v in ipairs(Cutscene.Animation) do
        if i == ct and i < #Cutscene.Animation then
            setElementPosition(Cutscene.car,v[1],v[2],v[3])
            setElementRotation(Cutscene.car,v[4],v[5],v[6])
        end
    end

    if ct == #Cutscene.Animation-1 then
        Cutscene.Animation={}
    end
end

function startCutscene()
    if(Cutscene.Recording)then return end

    local car=getPedOccupiedVehicle(localPlayer)
    if(not car)then return end

    Cutscene.car=car

    Cutscene.Recorded = {}
    Cutscene.Animation = {}

    Cutscene.startPos = {getElementPosition(Cutscene.car)}
    Cutscene.startRot = {getElementRotation(Cutscene.car)}
    Cutscene.vehModel = getElementModel(Cutscene.car)

    Cutscene.Recording=true

    addEventHandler("onClientRender",root,Cutscene.record)
end

function stopCutscene()
    removeEventHandler("onClientPreRender",root,Cutscene.show)
    removeEventHandler("onClientRender",root,Cutscene.summary)

    if(Cutscene.car)then
        setElementFrozen(Cutscene.car,false)

        setElementCollisionsEnabled(Cutscene.car,true)
        setElementData(Cutscene.car,"ghost",false)
    end

    Cutscene.Recording=false

    setElementData(localPlayer, "user:hud_disabled", false, false)

    toggleAllControls(true)
    toggleControl("radar",false)

    if(Cutscene.backPosition)then
        setElementPosition(Cutscene.car, Cutscene.backPosition[1], Cutscene.backPosition[2], Cutscene.backPosition[3])
        setElementRotation(Cutscene.car, 0, 0, Cutscene.backPosition[4])
    end

    setCameraTarget(localPlayer)

    setPedCanBeKnockedOffBike(localPlayer,true)
end

function Cutscene.stop(c,backPosition)
    if(not Cutscene.Recording)then return end

    local car=getPedOccupiedVehicle(localPlayer)
    if(not car)then return end

    setPedCanBeKnockedOffBike(localPlayer,false)

    toggleAllControls(false)

    removeEventHandler("onClientRender",root,Cutscene.record)
    Cutscene.Animation = Cutscene.Recorded
    Cutscene.Recorded = {}

    addEventHandler("onClientRender",root,Cutscene.summary)
    addEventHandler("onClientPreRender",root,Cutscene.show)

    Cutscene.Cam=c

    Cutscene.car=car
    Cutscene.backPosition=backPosition

    setElementFrozen(car,true)
    setElementCollisionsEnabled(Cutscene.car,false)
    setElementData(car,"ghost","all")

    setElementData(localPlayer, "user:hud_disabled", true, false)
end

addEvent("updateCut", true)
addEventHandler("updateCut", resourceRoot, function(info)
    Cutscene.info=info
end)

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end

function findRotation(el1,x2,y2) 
    local x1,y1=getElementPosition(el1)
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end