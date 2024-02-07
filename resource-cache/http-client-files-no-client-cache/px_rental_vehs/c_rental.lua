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
local scroll=exports.px_scroll
local buttons=exports.px_buttons

-- assets

local assets={}
assets.list={
    texs={
        "textures/window.png",
        "textures/header_icon.png",
        "textures/row.png",
        "textures/row_selected.png",
        "textures/bg.png",
        "textures/have.png",
        "textures/checkbox.png",
        "textures/checkbox_selected.png",
        "textures/close.png",
    },

    fonts={
        {"SemiBold", 13},
        {"Regular", 11},
        {"Regular", 13},
        {"Medium", 13},
        {"Medium", 16},
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
ui.centerAlpha=0
ui.selectedVeh=0
ui.scroll=false
ui.selectedCheck=1
ui.selectedPay=1

ui.btns={}
ui.vehs={}

ui.times={
    "1",
    "3",
    "7"
}

ui.pays={
    "Gotówka",
    "Punkty Premium"
}

-- functions

ui.onRender=function()
    blur:dxDrawBlur(sw/2-767/2/zoom, sh/2-413/2/zoom, 767/zoom, 413/zoom, tocolor(255, 255, 255, ui.mainAlpha))
    dxDrawImage(sw/2-767/2/zoom, sh/2-413/2/zoom, 767/zoom, 413/zoom, assets.textures[1], 0, 0, 0, tocolor(255, 255, 255, ui.mainAlpha))

    dxDrawText("Wypożyczalnia pojazdów", sw/2-767/2/zoom, sh/2-413/2/zoom, 767/zoom+sw/2-767/2/zoom, sh/2-413/2/zoom+55/zoom, tocolor(200, 200, 200, ui.mainAlpha), 1, assets.fonts[3], "center", "center")
    dxDrawImage(sw/2-767/2/zoom+(767/2)/zoom+dxGetTextWidth("Wypożyczalnia pojazdów", 1, assets.fonts[3])/2+10/zoom, sh/2-413/2/zoom+(55-18)/2/zoom, 18/zoom, 18/zoom, assets.textures[2], 0, 0, 0, tocolor(255, 255, 255, ui.mainAlpha))

    dxDrawImage(sw/2-767/2/zoom+767/zoom-10/zoom-(55-10)/2/zoom, sh/2-413/2/zoom+(55-10)/2/zoom, 10/zoom, 10/zoom, assets.textures[9], 0, 0, 0, tocolor(255, 255, 255, ui.mainAlpha))

    dxDrawRectangle(sw/2-767/2/zoom, sh/2-413/2/zoom+55/zoom, 767/zoom, 1, tocolor(85, 85, 85, ui.mainAlpha))
    dxDrawRectangle(sw/2, sh/2-413/2/zoom+55/zoom, 1, 413/zoom-55/zoom, tocolor(85, 85, 85, ui.mainAlpha))

    -- list
    local row=math.floor(scroll:dxScrollGetPosition(ui.scroll)+1)
    local x=0
    for i=row,row+5 do
        local v=ui.vehs[i]
        if(v)then
            v.hoverAlpha=v.hoverAlpha or 0

            x=x+1

            local sY=(60/zoom)*(x-1)

            if(isMouseInPosition(sw/2-767/2/zoom, sh/2-413/2/zoom+55/zoom+sY, 767/2/zoom, 57/zoom) and not v.animate and v.hoverAlpha < 100)then
                v.animate=true
                animate(0, 255, "Linear", 125, function(a)
                    v.hoverAlpha=a
                end, function()
                    v.animate=false
                end)
            elseif(v.hoverAlpha and not isMouseInPosition(sw/2-767/2/zoom, sh/2-413/2/zoom+55/zoom+sY, 767/2/zoom, 57/zoom) and not v.animate and v.hoverAlpha > 0)then
                v.animate=true
                animate(255, 0, "Linear", 125, function(a)
                    v.hoverAlpha=a
                end, function()
                    v.animate=false
                end)
            end

            onClick(sw/2-767/2/zoom, sh/2-413/2/zoom+55/zoom+sY, 767/2/zoom, 57/zoom, function()
                if(ui.animate or ui.selectedVeh == i)then return end

                ui.animate=true
                animate(255, 0, "Linear", 125, function(a)
                    ui.centerAlpha=a
                    buttons:buttonSetAlpha(ui.btns[1], a)
                end, function()
                    ui.selectedVeh=i

                    setTimer(function()
                        animate(0, 255, "Linear", 125, function(a)
                            ui.centerAlpha=a
                            buttons:buttonSetAlpha(ui.btns[1], a)
                        end, function()
                            ui.animate=false
                        end)
                    end, 100, 1)
                end)
            end)

            dxDrawImage(sw/2-767/2/zoom, sh/2-413/2/zoom+55/zoom+sY, 767/2/zoom, 57/zoom, ui.selectedVeh == i and assets.textures[3] or assets.textures[4], 0, 0, 0, tocolor(255, 255, 255, ui.mainAlpha))
            dxDrawRectangle(sw/2-767/2/zoom, sh/2-413/2/zoom+55/zoom+sY+56/zoom, 767/2/zoom, 1, tocolor(85, 85, 85, ui.mainAlpha))
            dxDrawRectangle(sw/2-767/2/zoom, sh/2-413/2/zoom+55/zoom+sY+56/zoom, 767/2/zoom, 1, tocolor(35, 165, 114, v.hoverAlpha > ui.mainAlpha and ui.mainAlpha or v.hoverAlpha))

            dxDrawText(v.model, sw/2-767/2/zoom+19/zoom, sh/2-413/2/zoom+55/zoom+sY-20/zoom, 767/2/zoom, 57/zoom+sh/2-413/2/zoom+55/zoom+sY, tocolor(200, 200, 200, ui.mainAlpha), 1, assets.fonts[3], "left", "center")
            dxDrawText("Sztuk: "..v.value, sw/2-767/2/zoom+19/zoom, sh/2-413/2/zoom+55/zoom+sY+20/zoom, 767/2/zoom, 57/zoom+sh/2-413/2/zoom+55/zoom+sY, tocolor(170, 170, 170, ui.mainAlpha), 1, assets.fonts[2], "left", "center")
        
            if(v.have)then
                local color=v.have.red == 1 and tocolor(255,0,0,ui.mainAlpha) or tocolor(200, 200, 200, ui.mainAlpha)
                dxDrawText("Wynajęty do: "..v.have.date, 0, sh/2-413/2/zoom+55/zoom+sY, sw/2-767/2/zoom+19/zoom+767/2/zoom-55/zoom, 57/zoom+sh/2-413/2/zoom+55/zoom+sY, color, 1, assets.fonts[2], "right", "center")
                dxDrawImage(sw/2-767/2/zoom+19/zoom+767/2/zoom-30/zoom-18/zoom, sh/2-413/2/zoom+55/zoom+sY+(57-18)/2/zoom, 18/zoom, 18/zoom, assets.textures[6], 0, 0, 0, tocolor(255, 255, 255, ui.mainAlpha))
            end
        end
    end

    local veh=ui.vehs[ui.selectedVeh]
    if(veh)then
        dxDrawText(veh.model, sw/2-767/2/zoom+767/2/zoom, sh/2-413/2/zoom+60/zoom, sw/2-767/2/zoom+767/zoom, 70/zoom, tocolor(200, 200, 200, ui.centerAlpha), 1, assets.fonts[1], "center", "top")
        dxDrawText(veh.desc, sw/2-767/2/zoom+767/2/zoom, sh/2-413/2/zoom+60/zoom+20/zoom, sw/2-767/2/zoom+767/zoom, 70/zoom, tocolor(130, 130, 130, ui.centerAlpha), 1, assets.fonts[4], "center", "top")
        dxDrawRectangle(sw/2-767/2/zoom+(767/2)/zoom, sh/2-413/2/zoom+55/zoom+56/zoom, 767/2/zoom, 1, tocolor(80, 80, 80, ui.centerAlpha))

        dxDrawText("Wybierz ilość dni", sw/2-767/2/zoom+767/2/zoom, sh/2-413/2/zoom+55/zoom+75/zoom, sw/2-767/2/zoom+767/zoom, 70/zoom, tocolor(200, 200, 200, ui.centerAlpha), 1, assets.fonts[1], "center", "top")
        dxDrawRectangle(sw/2-767/2/zoom+(767/2)/zoom+((767/2)-130)/2/zoom, sh/2-413/2/zoom+55/zoom+100/zoom, 130/zoom, 1, tocolor(120, 120, 120, ui.centerAlpha))
        for i,v in pairs(ui.times) do
            local sX=(67/zoom)*(i-1)
            dxDrawImage(sw/2-767/2/zoom+(767/2)/zoom+115/zoom+sX, sh/2-413/2/zoom+55/zoom+112/zoom, 18/zoom, 18/zoom, ui.selectedCheck == i and assets.textures[8] or assets.textures[7], 0, 0, 0, tocolor(255, 255, 255, ui.centerAlpha))
            dxDrawText(v.."d", sw/2-767/2/zoom+(767/2)/zoom+115/zoom+sX+26/zoom, sh/2-413/2/zoom+55/zoom+112/zoom, 18/zoom, 18/zoom+sh/2-413/2/zoom+55/zoom+112/zoom, tocolor(200, 200, 200, ui.centerAlpha), 1, assets.fonts[3], "left", "center")
        
            onClick(sw/2-767/2/zoom+(767/2)/zoom+115/zoom+sX, sh/2-413/2/zoom+55/zoom+112/zoom, 18/zoom, 18/zoom, function()
                ui.selectedCheck=i
            end)
        end
        dxDrawRectangle(sw/2-767/2/zoom+(767/2)/zoom, sh/2-413/2/zoom+55/zoom+150/zoom, 767/2/zoom, 1, tocolor(80, 80, 80, ui.centerAlpha))
        
        dxDrawText("Wybierz płatność", sw/2-767/2/zoom+767/2/zoom, sh/2-413/2/zoom+55/zoom+165/zoom, sw/2-767/2/zoom+767/zoom, 70/zoom, tocolor(200, 200, 200, ui.centerAlpha), 1, assets.fonts[1], "center", "top")
        dxDrawRectangle(sw/2-767/2/zoom+(767/2)/zoom+((767/2)-130)/2/zoom, sh/2-413/2/zoom+55/zoom+165/zoom+25/zoom, 130/zoom, 1, tocolor(120, 120, 120, ui.centerAlpha))
        for i,v in pairs(ui.pays) do
            local sX=(105/zoom)*(i-1)
            dxDrawImage(sw/2-767/2/zoom+(767/2)/zoom+80/zoom+sX, sh/2-413/2/zoom+55/zoom+205/zoom, 18/zoom, 18/zoom, ui.selectedPay == i and assets.textures[8] or assets.textures[7], 0, 0, 0, tocolor(255, 255, 255, ui.centerAlpha))
            dxDrawText(v, sw/2-767/2/zoom+(767/2)/zoom+80/zoom+sX+26/zoom, sh/2-413/2/zoom+55/zoom+205/zoom, 18/zoom, 18/zoom+sh/2-413/2/zoom+55/zoom+205/zoom, tocolor(200, 200, 200, ui.centerAlpha), 1, assets.fonts[3], "left", "center")
        
            onClick(sw/2-767/2/zoom+(767/2)/zoom+80/zoom+sX, sh/2-413/2/zoom+55/zoom+205/zoom, 18/zoom, 18/zoom, function()
                ui.selectedPay=i
            end)
        end
        dxDrawRectangle(sw/2-767/2/zoom+(767/2)/zoom, sh/2-413/2/zoom+55/zoom+246/zoom, 767/2/zoom, 1, tocolor(80, 80, 80, ui.centerAlpha))

        local text=ui.selectedPay == 1 and "#4ca362$#c8c8c8"..(veh.costMoney*(ui.times[ui.selectedCheck])) or "#4ca362"..(veh.costPoints*(ui.times[ui.selectedCheck])).." #c8c8c8PP" or "#4ca362$#c8c8c80"
        dxDrawText(text, sw/2-767/2/zoom+(767/2)/zoom, sh/2-413/2/zoom+55/zoom+259/zoom, sw/2-767/2/zoom+(767)/zoom, sh/2-413/2/zoom+413/zoom-58/zoom, tocolor(200, 200, 200, ui.centerAlpha), 1, assets.fonts[5], "center", "top", false, false, false, true)
    
        onClick(sw/2-767/2/zoom+(767/2)/zoom+((767/2)-147)/2/zoom, sh/2+147/zoom, 147/zoom, 38/zoom, function()
            if(ui.selectedPay > 0 and ui.selectedCheck > 0)then
                if(SPAM.getSpam())then return end

                triggerLatentServerEvent("rent.vehicle", resourceRoot, ui.selectedPay == 1 and "money" or "points", ui.selectedPay == 1 and (veh.costMoney*(ui.times[ui.selectedCheck])) or (veh.costPoints*(ui.times[ui.selectedCheck])), veh.id, ui.times[ui.selectedCheck])
            end
        end)
    end

    onClick(sw/2-767/2/zoom+767/zoom-10/zoom-(55-10)/2/zoom, sh/2-413/2/zoom+(55-10)/2/zoom, 10/zoom, 10/zoom, function()
        ui.destroy()
    end)
end

ui.create=function()
    if(ui.animate)then return end

    blur=exports.blur
    scroll=exports.px_scroll
    buttons=exports.px_buttons

    assets.create()

    addEventHandler("onClientRender", root, ui.onRender)
    showCursor(true)

    ui.selectedVeh=1
    ui.selectedCheck=1
    ui.selectedPay=1

    ui.scroll=scroll:dxCreateScroll(sw/2-767/2/zoom+(767/2)/zoom-4, sh/2-413/2/zoom+55/zoom, 4/zoom, 4/zoom, 0, 6, ui.vehs, (405-48)/zoom, 0, 1)
    ui.btns[1]=buttons:createButton(sw/2-767/2/zoom+(767/2)/zoom+((767/2)-147)/2/zoom, sh/2+147/zoom, 147/zoom, 38/zoom, "AKCEPTUJ", 0, 9, false, false, ":px_rental_vehs/textures/button-accept.png")

    ui.animate=true
    animate(0, 255, "Linear", 250, function(a)
        ui.mainAlpha=a
        ui.centerAlpha=a

        scroll:dxScrollSetAlpha(ui.scroll, a)
        buttons:buttonSetAlpha(ui.btns[1], a)
    end, function()
        ui.animate=false
    end)
end

ui.destroy=function()
    if(ui.animate)then return end

    showCursor(false)

    ui.animate=true
    animate(255, 0, "Linear", 250, function(a)
        ui.mainAlpha=a
        ui.centerAlpha=a

        scroll:dxScrollSetAlpha(ui.scroll, a)
        buttons:buttonSetAlpha(ui.btns[1], a)
    end, function()
        assets.destroy()

        removeEventHandler("onClientRender", root, ui.onRender)

        ui.animate=false

        scroll:dxDestroyScroll(ui.scroll)
        buttons:destroyButton(ui.btns[1])

        ui.vehs={}
    end)
end

-- triggers

addEvent("open.ui", true)
addEventHandler("open.ui", resourceRoot, function(vehs)
    ui.vehs=vehs
    ui.create()
end)

addEvent("close.ui", true)
addEventHandler("close.ui", resourceRoot, function(vehs)
    ui.destroy()
end)

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