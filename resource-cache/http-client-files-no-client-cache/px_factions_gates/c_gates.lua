--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local sw,sh = guiGetScreenSize()
local zoom = 1920/sw

local blur=exports.blur

-- assets

local assets={
    fonts={},
    fonts_paths={
        {":px_assets/fonts/Font-Bold.ttf", 15},
        {":px_assets/fonts/Font-Medium.ttf", 13},
        {":px_assets/fonts/Font-ExtraBold.ttf", 9},
    },

    textures={},
    textures_paths={
        "textures/bg.png",
        "textures/header.png",
        "textures/header_icon.png",
        "textures/close.png",
        "textures/gate_icon.png",
        "textures/alarm.png",
    },
}

assets.create = function()
    for k,t in pairs(assets) do
        if(k=="fonts_paths")then
            for i,v in pairs(t) do
                assets.fonts[i] = dxCreateFont(v[1], v[2]/zoom)
            end
        elseif(k=="textures_paths")then
            for i,v in pairs(t) do
                assets.textures[i] = dxCreateTexture(v, "argb", false, "clamp")
            end
        end
    end
end

assets.destroy = function()
    for k,t in pairs(assets) do
        if(k == "textures" or k == "fonts")then
            for i,v in pairs(t) do
                if(v and isElement(v))then
                    destroyElement(v)
                end
            end
            assets.fonts={}
            assets.textures={}
        end
    end
end

assets.button = function(text, x, y, w, h, color)
    dxDrawRectangle(x,y,w,h,color)
    dxDrawText(text,x,y,w+x,h+y,tocolor(200,200,200),1,assets.fonts[3],"center", "center")
end

-- variables

local ui={}

ui.info={}
ui.showed=false

ui.info={}

ui.positions={}
for i=1,3 do
    local sY=(117/zoom)*(i-1)
    for i=1,6 do
        local sX=(139/zoom)*(i-1)
        ui.positions[#ui.positions+1]={sX=sX,sY=sY}
    end
end

-- functions

floor=math.floor

ui.onRender=function()
    local w,h=floor(901/zoom),floor(601/zoom)

    -- bg
    blur:dxDrawBlur(sw/2-w/2, sh/2-h/2, w, h)
    dxDrawImage(sw/2-w/2, sh/2-h/2, w, h, assets.textures[1])

    -- header
    dxDrawImage(sw/2-w/2+1, sh/2-h/2+1, w-2, 55/zoom-2, assets.textures[2])
    dxDrawImage(sw/2-w/2-(20-55)/2/zoom, sh/2-h/2-(20-55)/2/zoom, 26/zoom, 20/zoom, assets.textures[3])
    dxDrawText("Zarządzanie koszarami", sw/2-w/2+60/zoom, sh/2-h/2, 0, sh/2-h/2+55/zoom, tocolor(200,200,200), 1, assets.fonts[1], "left", "center")

    -- close
    dxDrawImage(sw/2-w/2+w-10/zoom+(10-55)/2/zoom, sh/2-h/2-(10-55)/2/zoom, 10/zoom, 10/zoom, assets.textures[4])

    -- body
    dxDrawText("Sterowanie bramami", sw/2-w/2+41/zoom, sh/2-h/2+76/zoom, 0, 0, tocolor(200,200,200), 1, assets.fonts[2], "left", "top")

    assets.button("OTWÓRZ WSZYSTKIE", sw/2-w/2+w-126/zoom-41/zoom, sh/2-h/2+68/zoom, 126/zoom, 27/zoom, tocolor(100,100,100,100))
    assets.button("ZAMKNIJ WSZYSTKIE", sw/2-w/2+w-265/zoom-41/zoom, sh/2-h/2+68/zoom, 126/zoom, 27/zoom, tocolor(160,80,80,100))
    onClick(sw/2-w/2+w-126/zoom-41/zoom, sh/2-h/2+68/zoom, 126/zoom, 27/zoom, function()
        if(not SPAM.getSpam())then
            triggerServerEvent("gateFunction", resourceRoot, ui.info)
        end
    end)
    onClick(sw/2-w/2+w-265/zoom-41/zoom, sh/2-h/2+68/zoom, 126/zoom, 27/zoom, function()
        if(not SPAM.getSpam())then
            triggerServerEvent("gateFunction", resourceRoot, ui.info)
        end
    end)

    for i,v in pairs(ui.info.value.gates) do
        local pos=ui.positions[i]
        if(pos)then
            dxDrawImage(sw/2-w/2+41/zoom+pos.sX, sh/2-h/2+111/zoom+pos.sY, 126/zoom, 79/zoom, assets.textures[2])
            dxDrawImage(sw/2-w/2+41/zoom+pos.sX+12/zoom, sh/2-h/2+111/zoom+pos.sY+(79-20)/2/zoom, 26/zoom, 20/zoom, assets.textures[5])
            dxDrawText("Brama", sw/2-w/2+41/zoom+pos.sX+50/zoom, sh/2-h/2+111/zoom+pos.sY+20/zoom, 0, 0, tocolor(200,200,200), 1, assets.fonts[2], "left", "top")
            dxDrawText("#"..i, sw/2-w/2+41/zoom+pos.sX+50/zoom, sh/2-h/2+111/zoom+pos.sY+40/zoom, 0, 0, tocolor(200,200,200), 1, assets.fonts[2], "left", "top")
            assets.button(not v.state and "OTWÓRZ" or "ZAMKNIJ", sw/2-w/2+41/zoom+pos.sX, sh/2-h/2+111/zoom+pos.sY+79/zoom, 126/zoom, 27/zoom, not v.state and tocolor(100,100,100,100) or tocolor(160,80,80,100))
        
            onClick(sw/2-w/2+41/zoom+pos.sX, sh/2-h/2+111/zoom+pos.sY+79/zoom, 126/zoom, 27/zoom, function()
                if(not SPAM.getSpam())then
                    triggerServerEvent("gateFunction", resourceRoot, ui.info, i)
                end
            end)
        end
    end

    -- bottom
    dxDrawText("Powiadomienie", sw/2-w/2+41/zoom, sh/2-h/2+478/zoom, 0, 0, tocolor(200,200,200), 1, assets.fonts[2], "left", "top")
    dxDrawImage(floor(sw/2-w/2+41/zoom), floor(sh/2-h/2+478/zoom+30/zoom), floor(820/zoom), floor(54/zoom), assets.textures[6])
    onClick(floor(sw/2-w/2+41/zoom), floor(sh/2-h/2+478/zoom+30/zoom), floor(820/zoom), floor(54/zoom), function()
        triggerServerEvent("gateAlarm", resourceRoot, ui.info)
    end)

    -- click
    onClick(sw/2-w/2+w-10/zoom+(10-55)/2/zoom, sh/2-h/2-(10-55)/2/zoom, 10/zoom, 10/zoom, function()
        ui.destroy() 
    end)
end

SPAM={}
SPAM.getSpam=function()
    local block=false

    if(SPAM.blockSpamTimer)then
        killTimer(SPAM.blockSpamTimer)
        exports.px_noti:noti("Zaczekaj jedną sekunde.", "error")
        block=true
    end

    SPAM.blockSpamTimer=setTimer(function() SPAM.blockSpamTimer=nil end, 1000, 1)

    return block
end

ui.create=function()
    blur=exports.blur
    
    assets.create()

    addEventHandler("onClientRender", root, ui.onRender)

    showCursor(true, false)
end

ui.destroy=function()
    assets.destroy()

    removeEventHandler("onClientRender", root, ui.onRender)

    showCursor(false)
end

addEvent("open.gui", true)
addEventHandler("open.gui", resourceRoot, function(info)
    ui.info=info

    ui.showed=not ui.showed
    if(ui.showed)then ui.create() else ui.destroy() end
end)

-- useful function created by Asper

function isMouseInPosition(x, y, w, h)
	if(not isCursorShowing())then return end

	local cx,cy=getCursorPosition()
	cx,cy=cx*sw,cy*sh

    if(isCursorShowing() and (cx >= x and cx <= (x + w)) and (cy >= y and cy <= (y + h)))then
        return true
    end
    return false
end

function getPosition(myX, myY, x, y, w, h)
    if(isCursorShowing() and (myX >= x and myX <= (x + w)) and (myY >= y and myY <= (y + h)))then
        return true
    end
    return false
end

local mouseState=false
local mouseTick=getTickCount()
local mouseClicks=0
local mouseClick=false
function onClick(x, y, w, h, fnc)
	if(not isCursorShowing())then return end

	if((getTickCount()-mouseTick) > 1000 and mouseClicks > 0)then
		mouseClicks=mouseClicks-1
	end

	if(not mouseState and getKeyState("mouse1"))then
		local cursor={getCursorPosition()}
        mouseState=cursor
    elseif(not getKeyState("mouse1") and (mouseClick or mouseState))then
        mouseClick=false
        mouseState=false
    end

    if(mouseState and mouseClicks < 10 and not mouseClick)then
		local cx,cy=unpack(mouseState)
        cx,cy=cx*sw,cy*sh

        if(getPosition(cx, cy, x, y, w, h))then
			fnc()

			mouseClicks=mouseClicks+1
            mouseTick=getTickCount()
            mouseClick=true
        end
	end
end

-- alarm

addEvent("gateAlarm", true)
addEventHandler("gateAlarm", resourceRoot, function(pos)
    local s=playSound3D("sounds/alarm.mp3", pos[1], pos[2], pos[3], true)
    setSoundMaxDistance(s,100)
    setTimer(function()
        destroyElement(s)
    end, 15000, 1)
end)