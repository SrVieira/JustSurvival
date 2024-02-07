--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

-- global variables

local sw,sh=guiGetScreenSize()
local zoom=1920/sw

-- exports

local blur=exports.blur

-- assets

local assets={}
assets.list={
    texs={
        "textures/bg.png",
        "textures/icon.png",
        "textures/user.png",
    },

    fonts={
        {"Medium", 13},
        {"Medium", 11},
        {"SemiBold", 13},
    },
}

assets.textures={}
assets.fonts={}

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

local ui={}

ui.info={}

-- functions

ui.onRender=function()
    if(getElementData(localPlayer, "user:hud_disabled"))then return end

    blur:dxDrawBlur(sw/2-362/2/zoom, 35/zoom, 363/zoom, 86/zoom)
    dxDrawImage(sw/2-362/2/zoom, 35/zoom, 363/zoom, 86/zoom, assets.textures[1], 0, 0, 0, tocolor(255, 255, 255)) 

    dxDrawImage(sw/2-362/2/zoom, 35/zoom+1, 363/zoom, 31/zoom, assets.textures[1], 0, 0, 0, tocolor(255, 255, 255)) 

    if(ui.info.joined)then
        dxDrawText("#585858Wyjdź z wydarzenia: #ffffff/wyjdz", sw/2-362/2/zoom, 35/zoom, sw/2-362/2/zoom+363/zoom, 31/zoom+35/zoom, tocolor(255, 255, 255, 255), 1, assets.fonts[1], "center", "center", false, false, false, true)
    else
        dxDrawText("#585858Dołącz do wydarzenia: #ffffff/event", sw/2-362/2/zoom, 35/zoom, sw/2-362/2/zoom+363/zoom, 31/zoom+35/zoom, tocolor(255, 255, 255, 255), 1, assets.fonts[1], "center", "center", false, false, false, true)
    end

    dxDrawImage(sw/2-362/2/zoom+21/zoom, 35/zoom+46/zoom, 30/zoom, 22/zoom, assets.textures[2], 0, 0, 0, tocolor(255, 255, 255)) 
    dxDrawText(ui.info.type, sw/2-362/2/zoom+64/zoom, 35/zoom+46/zoom, 30/zoom, 35/zoom+46/zoom+22/zoom, tocolor(255, 255, 255, 255), 1, assets.fonts[1], "left", "center", false, false, false, true)

    dxDrawImage(sw/2-362/2/zoom+362/zoom-39/zoom, 35/zoom+46/zoom, 21/zoom, 25/zoom, assets.textures[3], 0, 0, 0, tocolor(255, 255, 255)) 
    dxDrawText(ui.info.players.." / "..ui.info.maxPlayers, sw/2-362/2/zoom+64/zoom, 35/zoom+46/zoom, sw/2-362/2/zoom+362/zoom-39/zoom-15/zoom, 35/zoom+46/zoom+25/zoom, tocolor(200, 200, 200, 255), 1, assets.fonts[1], "right", "center", false, false, false, true)
end

ui.create=function()
    assets.create()

    blur=exports.blur
    addEventHandler("onClientRender", root, ui.onRender)
end

ui.destroy=function()
    removeEventHandler("onClientRender", root, ui.onRender)

    assets.destroy()
end

-- update

addEventHandler("onClientElementDataChange", root, function(data,old,new)
    if(data == "event:info")then
        if(new)then
            if(new.started)then
                ui.destroy()
                ui.info={}
            else
                ui.destroy()
                ui.create()
    
                ui.info={
                    type=new.type or "?",
                    players=new.players or 0,
                    maxPlayers=new.maxPlayers or 0,
                    joined=new.playersElements[localPlayer] and true or false
                }
            end
        else
            ui.destroy()
            ui.info={}
        end
    end
end)

addEventHandler("onClientElementDestroy", resourceRoot, function()
    if(getElementData(source, "event:info"))then
        ui.destroy()
        ui.info={}
    end
end)

-- on start

local ev=getElementByID("event")
if(ev and isElement(ev))then
    local new=getElementData(ev, "event:info")
    if(not new)then return end

    ui.create()

    ui.info={
        type=new.type or "?",
        players=new.players or 0,
        maxPlayers=new.maxPlayers or 0,
        joined=new.playersElements[localPlayer] and true or false
    }
end

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
function onClick(x, y, w, h, fnc, key)
	if(not isCursorShowing())then return end

	if((getTickCount()-mouseTick) > 1000 and mouseClicks > 0)then
		mouseClicks=mouseClicks-1
	end

	if(not mouseState and getKeyState(key or "mouse1"))then
		local cursor={getCursorPosition()}
        mouseState=cursor
    elseif(not getKeyState(key or "mouse1") and (mouseClick or mouseState))then
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

-- rhino

EFFECTIVE_RANGE = 10 
EXPLOSION_DAMAGE = 25
RHINO_DATA="RHINO_HP"
  
function onClientExplosion(x, y, z, type)
    local vehs=getElementsWithinRange(x,y,z,EFFECTIVE_RANGE,"vehicle")
    for i,v in pairs(vehs) do
        local tX, tY, tZ = getElementPosition(v) 
        local distance3D = getDistanceBetweenPoints3D(x, y, z, tX, tY, tZ) or 0 
        if (distance3D < EFFECTIVE_RANGE) then 
            local health = getElementData(v, RHINO_DATA)
            if(health)then
                setElementData(v, RHINO_DATA, health - EXPLOSION_DAMAGE) 
            end
        end
    end
end 
addEventHandler("onClientExplosion", getRootElement(), onClientExplosion, true) 

-- spadajace panele

local board={}

function shakeOnRender()
    if(table.size(board) > 0 and getElementDimension(localPlayer) == 659)then
        for i,v in pairs(board) do
            if(v.object and isElement(v.object))then
                local currentTick = getTickCount()
                local tickDifference = currentTick - v.tick
                local newx = tickDifference/125 * 1
                local newy = tickDifference/125 * 1
                setElementRotation(v.object, math.deg( 0.555 ), 3 * math.cos(newy + 1), 3 * math.sin(newx + 1) )
            else
                board[i]=nil
            end
        end
    end
end
addEventHandler ( "onClientRender", root, shakeOnRender )

addEvent("update.board", true)
addEventHandler("update.board", resourceRoot, function(element, id)
    board[id]={object=element,tick=getTickCount()}
end)

function table.size(tab)
    local length = 0
    for _ in pairs(tab) do length = length + 1 end
    return length
end