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
        exports.px_noti:noti("Zaczekaj jedną sekunde.", "error")
        block=true
    end

    SPAM.blockSpamTimer=setTimer(function() SPAM.blockSpamTimer=nil end, 1000, 1)

    return block
end

-- global variables

local sw,sh=guiGetScreenSize()
local zoom=1920/sw

-- exports

local blur=exports.blur
local buttons=exports.px_buttons
local scroll=exports.px_scroll
local dialogs=exports.px_dialogs

-- assets

local assets={}
assets.list={
    texs={
        "textures/window.png",
        "textures/header_icon.png",
        "textures/veh_icon.png",
        "textures/row.png",
    },

    fonts={
        {"Regular", 17},
        {"Regular", 13},
        {"SemiBold", 13},
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

ui.mainAlpha=0
ui.vehs={}
ui.btns={}
ui.row=0

ui.dialog={
    ["Jan Rockstar"]={
        [1]={
            text="Witaj, co mogę dla Ciebie zrobić?",
            options={
                {text="Chce odebrać moje auto.", resourceName="px_water_vehicles", fnc=function()
                    triggerServerEvent("get.vehs", resourceRoot)
                end, next=-1},
                {text="Czym się zajmujesz?", next=2},
                {text="Nieważne, do zobaczenia.", ended=true}, 
            },
        },

        [2]={
            text="Moja firma wyciąga utopione pojazdy z obrębu całego San Andreas. ",
            options={
                {text="Chce odebrać swoje auto.", resourceName="px_water_vehicles", fnc=function()
                    triggerServerEvent("get.vehs", resourceRoot)
                end, next=-1},
                {text="Nieważne, do zobaczenia.", ended=true},
            }
        }
    }
}

-- functions

ui.onRender=function()
    blur:dxDrawBlur(sw/2-645/2/zoom, sh/2-261/2/zoom, 645/zoom, 261/zoom, tocolor(255, 255, 255, ui.mainAlpha))
    dxDrawImage(sw/2-645/2/zoom, sh/2-261/2/zoom, 645/zoom, 261/zoom, assets.textures[1], 0, 0, 0, tocolor(255, 255, 255, ui.mainAlpha))

    dxDrawText("Wyłowione pojazdy", sw/2-645/2/zoom, sh/2-261/2/zoom, 645/zoom+sw/2-645/2/zoom, sh/2-261/2/zoom+55/zoom, tocolor(200, 200, 200, ui.mainAlpha), 1, assets.fonts[1], "center", "center")
    dxDrawImage(sw/2-645/2/zoom+645/2/zoom+dxGetTextWidth("Wyłowione pojazdy", 1, assets.fonts[1])/2+10/zoom, sh/2-261/2/zoom+(55-15)/2/zoom, 15/zoom, 19/zoom, assets.textures[2], 0, 0, 0, tocolor(255, 255, 255, ui.mainAlpha))

    dxDrawRectangle(sw/2-643/2/zoom, sh/2-261/2/zoom+55/zoom, 643/zoom, 1, tocolor(85, 85, 85, ui.mainAlpha))

    ui.row=math.floor(scroll:dxScrollGetPosition(ui.scroll))+1

    local x=0
    for i=ui.row,ui.row+1 do
        x=x+1

        local v=ui.vehs[i]
        if(v)then
            local sY=(73/zoom)*(x-1)
            dxDrawImage(sw/2-644/2/zoom, sh/2-261/2/zoom+55/zoom+1+sY, 644/zoom, 72/zoom, assets.textures[4], 0, 0, 0, tocolor(255, 255, 255, ui.mainAlpha))
            dxDrawRectangle(sw/2-644/2/zoom, sh/2-261/2/zoom+55/zoom+1+sY+72/zoom-1, 644/zoom, 1, tocolor(85, 85, 85, ui.mainAlpha))

            dxDrawImage(sw/2-644/2/zoom+38/zoom, sh/2-261/2/zoom+55/zoom+1+sY+(72-12)/2/zoom, 26/zoom, 12/zoom, assets.textures[3], 0, 0, 0, tocolor(255, 255, 255, ui.mainAlpha))
            dxDrawText(getVehicleNameFromModel(v.model), sw/2-644/2/zoom+108/zoom, sh/2-261/2/zoom+55/zoom+1+sY, 0, sh/2-261/2/zoom+55/zoom+1+sY+72/zoom, tocolor(200, 200, 200, ui.mainAlpha), 1, assets.fonts[2], "left", "center")
            dxDrawText("ID: "..v.id, sw/2-644/2/zoom+220/zoom, sh/2-261/2/zoom+55/zoom+1+sY, 0, sh/2-261/2/zoom+55/zoom+1+sY+72/zoom, tocolor(200, 200, 200, ui.mainAlpha), 1, assets.fonts[2], "left", "center")
        
            onClick(sw/2-644/2/zoom+466/zoom, sh/2-261/2/zoom+55/zoom+1+sY+(72-38)/2/zoom, 147/zoom, 38/zoom, function()
                ui.destroy()

                if(SPAM.getSpam())then return end

                triggerServerEvent("get.veh", resourceRoot, v.id, v.groupVehicle)
            end)
        end
    end

    dxDrawRectangle(sw/2-643/2/zoom, sh/2-261/2/zoom+55/zoom+145/zoom, 643/zoom, 1, tocolor(85, 85, 85, ui.mainAlpha))
    dxDrawText('Kliknij "ESC" aby zamknąć panel.', sw/2-643/2/zoom, sh/2-261/2/zoom+55/zoom+145/zoom, sw/2-643/2/zoom+643/zoom, sh/2-261/2/zoom+261/zoom, tocolor(200, 200, 200, ui.mainAlpha > 125 and 125 or ui.mainAlpha), 1, assets.fonts[2], "center", "center")
end

ui.onKey=function(key, press)
    if(press)then
        if(key == "escape")then
            cancelEvent()

            ui.destroy()
        end
    end
end

addEvent("set.vehs", true)
addEventHandler("set.vehs", resourceRoot, function(q,q2)
    if((q and #q > 0) or (#q2 and #q2 > 0))then
        ui.vehs=q
        for i,v in pairs(q2) do
            v.groupVehicle=true
            ui.vehs[#ui.vehs+1]=v
        end
        ui.create()
    end
end)

ui.create=function()
    blur=exports.blur
    buttons=exports.px_buttons
    scroll=exports.px_scroll
    dialogs=exports.px_dialogs

    assets.create()

    addEventHandler("onClientRender", root, ui.onRender)
    addEventHandler("onClientKey", root, ui.onKey)

    showCursor(true)

    for i=1,(#ui.vehs > 2 and 2 or #ui.vehs) do
        local sY=(73/zoom)*(i-1)
        ui.btns[i]=buttons:createButton(sw/2-644/2/zoom+466/zoom, sh/2-261/2/zoom+55/zoom+1+sY+(72-38)/2/zoom, 147/zoom, 38/zoom, "ZABIERZ", 255, 10, false, false, ":px_water_vehicles/textures/button_icon.png")
    end

    ui.scroll=scroll:dxCreateScroll(sw/2-645/2/zoom+645/zoom-4, sh/2-261/2/zoom+55/zoom, 4, 4, 0, 2, ui.vehs, 261/zoom-55/zoom-60/zoom, 0, 1)

    animate(0, 255, "Linear", 250, function(a)
        ui.mainAlpha=a

        for i,v in pairs(ui.btns) do
            buttons:buttonSetAlpha(v, a)
        end

        scroll:dxScrollSetAlpha(ui.scroll, a)
    end, function()
        ui.animate=false
    end)
end

ui.destroy=function()
    showCursor(false)

    ui.animate=true
    
    removeEventHandler("onClientKey", root, ui.onKey)

    animate(255, 0, "Linear", 250, function(a)
        ui.mainAlpha=a

        for i,v in pairs(ui.btns) do
            buttons:buttonSetAlpha(v, a)
        end
    end, function()
        removeEventHandler("onClientRender", root, ui.onRender)

        assets.destroy()

        for i,v in pairs(ui.btns) do
            buttons:destroyButton(v)
        end

        scroll:dxDestroyScroll(ui.scroll)
    end)
end

function dialogFunction(id, index)
    local v=ui.dialog["Jan Rockstar"][id].options[index]
    if(v)then
        v.fnc(id)
    end
end

function action(id,element,name)
    if(name == "Rozpocznij rozmowę")then
        local data=getElementData(element, "dialog:name")
        if(data and ui.dialog[data])then
            dialogs:createDialog(ui.dialog, data)
        end
    end
end

-- triggers

-- useful

local anims = {}
local rendering = false

local function renderAnimations()
    local now = getTickCount()
    for k,v in pairs(anims) do
        v.onChange(interpolateBetween(v.from, 0, 0, v.to, 0, 0, (now - v.start) / v.duration, v.easing))
        if(now >= v.start+v.duration)then
            table.remove(anims, k)
			if(type(v.onEnd) == "function")then
                v.onEnd()
            end
        end
    end

    if(#anims == 0)then
        rendering = false
        removeEventHandler("onClientRender", root, renderAnimations)
    end
end

function animate(f, t, easing, duration, onChange, onEnd)
	if(#anims == 0 and not rendering)then
		addEventHandler("onClientRender", root, renderAnimations)
		rendering = true
	end

    assert(type(f) == "number", "Bad argument @ 'animate' [expected number at argument 1, got "..type(f).."]")
    assert(type(t) == "number", "Bad argument @ 'animate' [expected number at argument 2, got "..type(t).."]")
    assert(type(easing) == "string", "Bad argument @ 'animate' [Invalid easing at argument 3]")
    assert(type(duration) == "number", "Bad argument @ 'animate' [expected number at argument 4, got "..type(duration).."]")
    assert(type(onChange) == "function", "Bad argument @ 'animate' [expected function at argument 5, got "..type(onChange).."]")
    table.insert(anims, {from = f, to = t, easing = easing, duration = duration, start = getTickCount( ), onChange = onChange, onEnd = onEnd})

    return #anims
end

function destroyAnimation(id)
    if(anims[id])then
        anims[id] = nil
    end
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

--ui.create()