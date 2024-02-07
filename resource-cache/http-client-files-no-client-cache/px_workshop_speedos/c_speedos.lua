--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

SPAM={}
SPAM.getSpam=function()
    local block=false

    if(SPAM.blockSpamTimer)then
        killTimer(SPAM.blockSpamTimer)
        exports.px_exports.px_noti:noti("Zaczekaj jedną sekunde.", "error")
        block=true
    end

    SPAM.blockSpamTimer=setTimer(function() SPAM.blockSpamTimer=nil end, 1000, 1)

    return block
end

-- global variables

local sw,sh=guiGetScreenSize()
local zoom=1920/sw

local e_blur=exports.blur

local ui={}

-- assets

local assets={}
assets.list={
    texs={
        "textures/right_button.png",
        "textures/right_button_light.png",
        "textures/enter_button.png",
    },

    fonts={
        {"Regular", 13},
        {"Bold", 15},
        {"Regular", 15},
    },
}

assets.create=function()
    assets.textures={}
    for i,v in pairs(assets.list.texs) do
        assets.textures[i]=dxCreateTexture(v, "argb", false, "clamp")
    end

    assets.fonts={}
    for i,v in pairs(assets.list.fonts) do
        assets.fonts[i]=dxCreateFont(":px_assets/fonts/Font-"..v[1]..".ttf", v[2]/zoom)
    end
end

assets.destroy=function()
    for i,v in pairs(assets.textures) do
        if(v and isElement(v))then
            destroyElement(v)
        end
    end
    assets.textures={}

    for i,v in pairs(assets.fonts) do
        if(v and isElement(v))then
            destroyElement(v)
        end
    end
    assets.fonts={}
end

-- variables

ui.selected=1
ui.selectedMenu=1
ui.panel=false
ui.speedo=false

ui.pos={
    center={sw/2-119/2/zoom, sh-83/zoom, 119/zoom, 49/zoom},
    text_1={sw/2-119/2/zoom, sh-83/zoom-30/zoom, sw/2-119/2/zoom+119/zoom, 49/zoom},
    text_2={sw/2-119/2/zoom, sh-83/zoom+49/zoom+5/zoom, sw/2-119/2/zoom+119/zoom, 49/zoom},
}

ui.speedos={
    {"Normal", cost=5000, id=5},
    {"Muscle", cost=7500, id=4},
    {"Swipe", cost=8000, id=1},
    {"Sportowy", cost=15000, id=2},
}


-- rendering, etc

ui.onRender=function()
    local veh=getPedOccupiedVehicle(localPlayer)
    if(not veh)then ui.destroy() return end

    local p=ui.pos
    
    dxDrawBlurImage(p.center[1]-p.center[4]+1, p.center[2], p.center[4], p.center[4], getKeyState("arrow_l") and assets.textures[2] or assets.textures[1], 180, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawBlurImage(p.center[1]+p.center[3]-1, p.center[2], p.center[4], p.center[4], getKeyState("arrow_r") and assets.textures[2] or assets.textures[1], 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawBlurImage(p.center[1], p.center[2], p.center[3], p.center[4], assets.textures[3], 0, 0, 0, tocolor(255, 255, 255, 255))

    local cost=getElementData(veh, "vehicle:group_owner") and ui.speedos[ui.selected].cost*2 or ui.speedos[ui.selected].cost
    dxDrawShadowText("Licznik "..ui.speedos[ui.selected][1], p.text_2[1], p.text_2[2], p.text_2[3], p.text_2[4], tocolor(222, 222, 222), 1, assets.fonts[1], "center", "top")
    dxDrawShadowText("KUP", p.text_1[1]-dxGetTextWidth(" $"..cost, 1, assets.fonts[2]), p.text_1[2], p.text_1[3], p.text_1[4], tocolor(200, 200, 200), 1, assets.fonts[2], "center", "top")
    dxDrawShadowText(" #69b46d$#ffffff"..cost, p.text_1[1]+dxGetTextWidth(" $"..cost, 1, assets.fonts[2])/2, p.text_1[2], p.text_1[3], p.text_1[4], tocolor(200, 200, 200), 1, assets.fonts[3], "center", "top", false, false, false, true)
end

ui.onKey=function(key, press)
    if(not press)then return end

    local veh=getPedOccupiedVehicle(localPlayer)
    if(not veh)then ui.destroy() return end

    if(key == "arrow_l")then
        if(ui.selected > 1)then
            ui.selected=ui.selected-1
            setElementData(veh, "vehicle:speedoType", ui.speedos[ui.selected].id, false)
        end
    elseif(key == "arrow_r")then
        if(ui.selected < #ui.speedos)then
            ui.selected=ui.selected+1
            setElementData(veh, "vehicle:speedoType", ui.speedos[ui.selected].id, false)
        end
    elseif(key == "enter")then
        if(SPAM.getSpam())then return end

        setElementData(veh, "vehicle:speedoType", false, false)
        triggerLatentServerEvent("buy.speedo", resourceRoot, ui.speedos[ui.selected].id, ui.speedos[ui.selected])
    end
end

-- create

ui.create=function()
    local vehicle=getPedOccupiedVehicle(localPlayer)
    if(not vehicle or ui.panel)then return end

    if(getElementHealth(vehicle) < 1000)then
        exports.px_noti:noti("Aby ulepszyć pojazd, musi on być sprawny.", "error")
        return
    end

    if(getElementData(localPlayer, "user:gui_showed"))then return end

    local uid=getElementData(localPlayer, "user:uid")    
    local owner=getElementData(vehicle, "vehicle:owner") or getElementData(vehicle, "vehicle:liderUID")
    if(not uid or not owner or (owner and owner ~= uid))then 
        exports.px_noti:noti("Pojazd nie należy do Ciebie.", "error")
        return 
    end

    e_blur=exports.blur

    assets.create()

    addEventHandler("onClientRender", root, ui.onRender)
    addEventHandler("onClientKey", root, ui.onKey)

    ui.selected=1
    ui.selectedMenu=1

    toggleControl("enter_exit", false)

    ui.apply=false

    ui.panel=true

    ui.speedo=getElementData(vehicle, "vehicle:speedoType")

    setElementData(vehicle, "vehicle:speedoType", ui.speedos[ui.selected].id, false)

    setElementData(localPlayer, "user:gui_showed", resourceRoot, false)
end

ui.destroy=function(cancel)
    local vehicle=getPedOccupiedVehicle(localPlayer)
    if(not vehicle or not ui.panel)then return end

    if(getElementData(localPlayer, "user:gui_showed") ~= resourceRoot)then return end

    removeEventHandler("onClientRender", root, ui.onRender)
    removeEventHandler("onClientKey", root, ui.onKey)

    assets.destroy()

    toggleControl("enter_exit", true)

    ui.panel=false

    if(not cancel)then
        setElementData(vehicle, "vehicle:speedoType", ui.speedo, false)
    end

    ui.speedo=false

    setElementData(localPlayer, "user:gui_showed", false, false)
end

-- triggers

addEvent("open.ui", true)
addEventHandler("open.ui", resourceRoot, function()
    ui.create()
end)

addEvent("destroy.ui", true)
addEventHandler("destroy.ui", resourceRoot, function(cancel)
    ui.destroy(cancel)
end)

-- useful

function table.size(tab)
    local length = 0
    for _ in pairs(tab) do length = length + 1 end
    return length
end

function dxDrawShadowText(text,x,y,w,h,color,size,font,alignX,alignY,_,_,_,cFormat)
    dxDrawText(text:gsub("#%x%x%x%x%x%x", ""),x+1,y+1,w+1,h+1,tocolor(0,0,0),size,font,alignX,alignY,_,_,_,cFormat)
    dxDrawText(text,x,y,w,h,color,size,font,alignX,alignY,_,_,_,cFormat)
end

function dxDrawBlurImage(x,y,w,h,tex,rx,ry,rz,color)
    e_blur:dxDrawBlur(x,y,w,h,color)
    dxDrawImage(x,y,w,h,tex,rx,ry,rz,color)
end

-- on stop

addEventHandler("onClientResourceStop", resourceRoot, function()
    local data=getElementData(localPlayer, "user:gui_showed")
    if(data and data == resourceRoot)then
        setElementData(localPlayer, "user:gui_showed", false, false)
    end
end)