--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

-- global variables

local sw,sh=guiGetScreenSize()
local zoom = 1
local fh = 1920

if sw < fh then
  zoom = math.min(2,fh/sw)
end

-- exports

local blur=exports.blur
local buttons=exports.px_buttons
local noti=exports.px_noti

-- assets

local assets={}
assets.list={
    texs={
        "textures/bg.png",
        "textures/icon-bg.png",
        "textures/dollar-icon.png",
        "textures/user-icon.png",
    },

    fonts={
        {"Medium", 15},
        {"Regular", 13},

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

local ui={}

ui.buttons={}

ui.info=false

ui.onRender=function()
    if(ui.info.target and isElement(ui.info.target))then
        blur:dxDrawBlur(sw/2-486/2/zoom, sh/2-285/2/zoom, 486/zoom, 285/zoom)
        dxDrawImage(sw/2-486/2/zoom, sh/2-285/2/zoom, 486/zoom, 285/zoom, assets.textures[1])

        dxDrawText(ui.info.desc, sw/2-486/2/zoom, sh/2-285/2/zoom, sw/2-486/2/zoom+486/zoom, sh/2-285/2/zoom+56/zoom, tocolor(200, 200, 200), 1, assets.fonts[1], "center", "center")

        dxDrawRectangle(sw/2-349/2/zoom, sh/2-285/2/zoom+56/zoom, 349/zoom, 1, tocolor(100,100,100))

        dxDrawText("Otrzymałeś ofertę od Pracownika frakcji SARA.", sw/2-486/2/zoom, sh/2-285/2/zoom+66/zoom, sw/2-486/2/zoom+486/zoom, sh/2-285/2/zoom+56/zoom, tocolor(200, 200, 200), 1, assets.fonts[2], "center", "top")

        dxDrawImage(sw/2-486/2/zoom+90/zoom, sh/2-285/2/zoom+126/zoom, 46/zoom, 46/zoom, assets.textures[2])
        dxDrawImage(sw/2-486/2/zoom+90/zoom+(46-24)/2/zoom, sh/2-285/2/zoom+126/zoom+(46-24)/2/zoom, 24/zoom, 24/zoom, assets.textures[4])
        dxDrawText(getPlayerName(ui.info.target), sw/2-486/2/zoom+90/zoom+60/zoom, sh/2-285/2/zoom+126/zoom, 0, sh/2-285/2/zoom+126/zoom+46/zoom, tocolor(200, 200, 200), 1, assets.fonts[1], "left", "center")

        dxDrawImage(sw/2-486/2/zoom+90/zoom+202/zoom, sh/2-285/2/zoom+126/zoom, 46/zoom, 46/zoom, assets.textures[2])
        dxDrawImage(sw/2-486/2/zoom+90/zoom+(46-24)/2/zoom+202/zoom, sh/2-285/2/zoom+126/zoom+(46-24)/2/zoom, 24/zoom, 24/zoom, assets.textures[3])
        dxDrawText("$ "..ui.info.cost, sw/2-486/2/zoom+90/zoom+60/zoom+202/zoom, sh/2-285/2/zoom+126/zoom, 0, sh/2-285/2/zoom+126/zoom+46/zoom, tocolor(200, 200, 200), 1, assets.fonts[1], "left", "center")
    
        onClick(sw/2-147/zoom-10/zoom, sh/2+60/zoom, 147/zoom, 39/zoom, function()
            triggerServerEvent("change.offer", resourceRoot, false)
            ui.destroy()
        end)

        onClick(sw/2+10/zoom, sh/2+60/zoom, 147/zoom, 39/zoom, function()
            triggerServerEvent("change.offer", resourceRoot, ui.info, true)
            ui.destroy()
        end)
    else
        triggerServerEvent("change.offer", resourceRoot, false)
        ui.destroy()
    end
end

ui.create=function(info)
    if(not info or ui.info)then return end

    ui.info=info

    addEventHandler("onClientRender", root, ui.onRender)

    assets.create()

    ui.buttons[1]=buttons:createButton(sw/2-147/zoom-10/zoom, sh/2+60/zoom, 147/zoom, 39/zoom, "ANULUJ", 255, 9, false, false, ":px_factions-offers/textures/x-icon.png", {132,39,39})
    ui.buttons[2]=buttons:createButton(sw/2+10/zoom, sh/2+60/zoom, 147/zoom, 39/zoom, "POTWIERDŹ", 255, 9, false, false, ":px_factions-offers/textures/checked-icon.png")

    showCursor(true)
end
addEvent("get.offer", true)
addEventHandler("get.offer", resourceRoot, ui.create)

ui.destroy=function()
    showCursor(false)

    removeEventHandler("onClientRender", root, ui.onRender)

    assets.destroy()

    for i = 1,#ui.buttons do
        buttons:destroyButton(ui.buttons[i])
    end

    ui.info=false
end

addEvent("get.action", true)
addEventHandler("get.action", resourceRoot, function(veh, index)
    exports.px_interaction:action(false, veh, index)
end)

-- useful

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
    if(ui.animate)then return end
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